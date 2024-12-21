local utils = require('hasan.utils')

local function get_title(opts)
  return opts and opts.title and string.format(' %s ', opts.title) or nil
end

local function merge_conf(default_opts, opts)
  if not opts then
    return default_opts
  end
  return utils.merge(default_opts, opts or {})
end

local function register_dropdown(preview)
  return function(opts)
    local default_opts = {
      winopts = {
        height = preview and 0.75 or 20,
        width = 0.6,
        row = 0.5,
        col = 0.5,
        title = get_title(opts),
        preview = {
          vertical = 'up:45%',
          layout = 'vertical',
          hidden = preview and 'nohidden' or 'hidden',
        },
      },
    }

    return merge_conf(default_opts, opts)
  end
end

local themes = {
  default = function(opts)
    local default_opts = {
      winopts = {
        title = get_title(opts),
      },
    }
    return merge_conf(default_opts, opts)
  end,
  cursor = function(opts)
    local default_opts = {
      winopts = {
        title = get_title(opts),
        relative = 'cursor',
        row = 1,
        col = 1,
        height = 8,
        width = 90,
        preview = {
          hidden = 'hidden',
          layout = 'horizontal',
        },
      },
    }

    return merge_conf(default_opts, opts)
  end,
  top_panel = function(opts)
    local default_opts = {
      winopts = {
        height = 0.75,
        width = 0.6,
        row = 0,
        col = 0.5,
        title = get_title(opts),
        preview = {
          layout = 'vertical',
          vertical = 'down:45%',
          hidden = 'hidden', -- hidden|nohidden
        },
      },
    }

    return merge_conf(default_opts, opts)
  end,
  ivy = function(opts)
    local default_opts = {
      winopts = {
        height = 0.75,
        width = 1,
        row = 1,
        col = 0.5,
        title = get_title(opts),
        preview = {
          layout = 'flex',
          hidden = 'nohidden',
        },
      },
    }

    return merge_conf(default_opts, opts)
  end,
  dropdown = register_dropdown(true),
  dropdown_no_preview = register_dropdown(false),
}

return themes
