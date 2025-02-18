local file_util = require('hasan.utils.file')
local text_util = require('hasan.utils.text')

local M = {}
local is_win = jit.os:find('Windows')

local bloc_data = {
  bloc = function(file_prefix, class_prefix)
    local template = [[
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part '${file}_event.dart';
part '${file}_state.dart';

class ${class}Bloc extends Bloc<${class}Event, ${class}State> {
  ${class}Bloc() : super(${class}Initial()) {
    on<${class}Event>((event, emit) {
      // TODO: implement event handler
    });
  }
}
]]

    template = template:gsub('%${file}', file_prefix)
    template = template:gsub('%${class}', class_prefix)
    return template
  end,
  cubit = function(file_prefix, class_prefix)
    local template = [[
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part '${file}_state.dart';

class ${class}Cubit extends Cubit<${class}State> {
  ${class}Cubit() : super(${class}Initial());
  // TODO: implement cubit methods here
}
]]

    template = template:gsub('%${file}', file_prefix)
    template = template:gsub('%${class}', class_prefix)
    return template
  end,
  event = function(file_prefix, class_prefix)
    local template = [[
part of '${file}_bloc.dart';

sealed class ${class}Event extends Equatable {
  const ${class}Event();

  @override
  List<Object> get props => [];
}
]]

    template = template:gsub('%${file}', file_prefix)
    template = template:gsub('%${class}', class_prefix)
    return template
  end,
  state = function(file_prefix, class_prefix, state_type)
    local template = [[
part of '${file}_${state_type}.dart';

sealed class ${class}State extends Equatable {
  const ${class}State();

  @override
  List<Object> get props => [];
}

final class ${class}Initial extends ${class}State {}
]]

    template = template:gsub('%${file}', file_prefix)
    template = template:gsub('%${class}', class_prefix)
    template = template:gsub('%${state_type}', state_type)
    return template
  end,
}

M.create_new_bloc = function(node_path, node_type, callback, is_cubit)
  local state_type = is_cubit and 'cubit' or 'bloc'

  vim.ui.input({
    prompt = 'Enter ' .. state_type .. ' name',
    icon = ' ',
    default = 'counter',
  }, function(val)
    if type(val) ~= 'string' or val == '' then
      return
    end

    local file_prefix = string.lower(vim.trim(val))
    local class_prefix = text_util.snake_to_camel_case(file_prefix)

    if not file_prefix or file_prefix == '' then
      vim.notify('Give a name', 'error')
      return
    end

    local parent_path = vim.fs.normalize(node_type == 'directory' and node_path or vim.fs.dirname(node_path))

    local parent_is_root = vim.fs.basename(parent_path) == state_type
    local root_path = parent_path .. '/' .. state_type
    if parent_is_root then
      root_path = parent_path
    end

    local root_stat = vim.uv.fs_stat(root_path)
    if not (root_stat and root_stat.type == 'directory') then
      vim.uv.fs_mkdir(root_path, 511) -- 511 = 0o777 permissions
    end

    local file_format = '%s_%s.dart'

    local bloc_tree = {
      {
        type = 'file',
        name = file_format:format(file_prefix, 'bloc'),
        content = bloc_data.bloc(file_prefix, class_prefix),
      },
      {
        type = 'file',
        name = file_format:format(file_prefix, 'state'),
        content = bloc_data.state(file_prefix, class_prefix, state_type),
      },
      {
        type = 'file',
        name = file_format:format(file_prefix, 'event'),
        content = bloc_data.event(file_prefix, class_prefix),
      },
    }

    local cubit_tree = {
      {
        type = 'file',
        name = file_format:format(file_prefix, 'cubit'),
        content = bloc_data.cubit(file_prefix, class_prefix),
      },
      {
        type = 'file',
        name = file_format:format(file_prefix, 'state'),
        content = bloc_data.state(file_prefix, class_prefix, state_type),
      },
    }

    local tree = is_cubit and cubit_tree or bloc_tree
    file_util.create_from_tree(
      root_path,
      tree,
      vim.schedule_wrap(function()
        if callback then
          local destination = parent_is_root and vim.fs.joinpath(root_path, tree[1].name) or root_path
          callback(is_win and file_util.convert_path_to_windows(destination) or destination)
        end
      end)
    )
  end)
end

M.create_new_feature = function(node_path, node_type, callback)
  vim.ui.input({
    prompt = 'Enter feature name',
    icon = ' ',
    default = 'counter',
  }, function(val)
    if type(val) ~= 'string' or val == '' then
      return
    end

    local feature_name = string.lower(vim.trim(val))
    if not feature_name or feature_name == '' then
      vim.notify('Give a feature name', 'error')
      return
    end

    local parent_path = vim.fs.normalize(node_type == 'directory' and node_path or vim.fs.dirname(node_path))

    local new_root_path = parent_path .. '/' .. feature_name
    local root_stat = vim.uv.fs_stat(new_root_path)
    if root_stat and root_stat.type == 'directory' then
      vim.notify(string.format('"%s" feature already exists', feature_name), 'error')
      return
    end

    local tree = {
      {
        name = feature_name,
        children = {
          { name = 'data' },
          {
            name = 'presentation',
            children = {
              { name = 'pages' },
              { name = 'components' },
            },
          },
          {
            name = 'domain',
            children = {
              { name = 'entities' },
              { name = 'repoes' },
            },
          },
        },
      },
    }

    file_util.create_from_tree(
      parent_path,
      tree,
      vim.schedule_wrap(function()
        if callback then
          callback(is_win and file_util.convert_path_to_windows(new_root_path) or new_root_path)
        end
      end)
    )
  end)
end

return M
