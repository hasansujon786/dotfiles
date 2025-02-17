local M = {}

M.create_file_with_text = function(file_path, default_text)
  local fd = vim.uv.fs_open(file_path, 'w', 438) -- 438 = 0o666 permission
  if not fd then
    vim.notify('Error: Could not create ' .. file_path, 'error')
    return
  end

  vim.uv.fs_write(fd, default_text)
  vim.uv.fs_close(fd)
end

local block_data = {
  block = function(file_prefix, class_prefix)
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
  state = function(file_prefix, class_prefix)
    local template = [[
part of '${file}_bloc.dart';

sealed class ${class}State extends Equatable {
  const ${class}State();

  @override
  List<Object> get props => [];
}

final class ${class}Initial extends ${class}State {}
]]

    template = template:gsub('%${file}', file_prefix)
    template = template:gsub('%${class}', class_prefix)
    return template
  end,
}

local function capitalize_first_char(str)
  return str:sub(1, 1):upper() .. str:sub(2)
end

local function snake_to_camel_case(str)
  return str
    :gsub('_(%a)', function(letter)
      return letter:upper()
    end)
    :gsub('^%l', string.upper)
end

M.create_new_bloc = function(node_path, node_type)
  local filename = vim.fn.input('Enter filename: ', 'counter')
  local path_format = '%s/%s_%s.dart'

  if not filename then
    vim.notify('Give a bloc name', 'error')
    return
  end

  local dir_path = node_type == 'directory' and node_path or vim.fs.dirname(node_path)
  dir_path = vim.fs.normalize(dir_path) .. '/block'

  local dir_state = vim.uv.fs_stat(dir_path)
  if dir_state and dir_state.type == 'directory' then
    vim.notify('Directory already exists', 'error')
    return
  end

  local success, err = vim.uv.fs_mkdir(dir_path, 511) -- 511 = 0o777 permission

  if not success then
    vim.notify('Error: Could not create directory ' .. dir_path, 'error')
    return
  end

  local file_prefix = string.lower(vim.trim(filename))
  local class_prefix = snake_to_camel_case(file_prefix)

  local paths = {
    { name = 'block', data = block_data.block(file_prefix, class_prefix) },
    { name = 'event', data = block_data.event(file_prefix, class_prefix) },
    { name = 'state', data = block_data.state(file_prefix, class_prefix) },
  }

  for _, module in ipairs(paths) do
    vim.schedule(function()
      M.create_file_with_text(path_format:format(dir_path, filename, module.name), module.data)
    end)
  end
end

return M
