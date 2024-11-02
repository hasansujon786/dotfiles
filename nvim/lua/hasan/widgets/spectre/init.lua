local engine = require('hasan.widgets.spectre.engine')
local fn = require('utils.fn')
local n = require('nui-components')
local Icons = require('hasan.utils.ui.icons')
local search_tree = require('hasan.widgets.spectre.components.search_tree')

local window = {
  -- blend = 0,
  highlight = {
    -- FloatBorder = 'Normal',
    NormalFloat = 'SidebarDark',
    Cursorline = 'None',
  },
}
local info_window = {
  highlight = {
    NormalFloat = 'NuiComponentsInfo',
    Cursorline = 'None',
  },
}

local M = {}

M.open_visual = function(opts)
  opts = opts or {}
  if opts.select_word then
    opts.search_text = vim.fn.expand('<cword>')
  else
    opts.search_text = require('hasan.utils').get_visual_selection()
  end
  M.open(opts)
end

function M.open(opts)
  if M.renderer then
    return M.renderer:focus()
  end

  opts = vim.tbl_extend('force', {
    cwd = nil,
    search_text = '',
    replace_text = '',
    search_paths = {},
  }, opts or {})

  if opts.current_file then
    local file_path = vim.fn.fnameescape(vim.fn.expand('%:p:.'))
    if vim.loop.os_uname().sysname == 'Windows_NT' then
      file_path = vim.fn.substitute(file_path, '\\', '/', 'g')
    end
    opts.search_paths = { file_path }
  end
  if type(opts.search_paths) == 'string' then
    opts.search_paths = { opts.search_paths }
  end

  local ui_info = {
    width = vim.o.columns,
    height = vim.o.lines,
  }

  local renderer = n.create_renderer({
    width = math.min(100, ui_info.width),
    height = ui_info.height - 1,
    relative = 'editor',
    position = { row = 0, col = '100%' },
  })

  local signal = n.create_signal({
    search_query = opts.search_text,
    replace_query = opts.replace_text,
    search_paths = opts.search_paths,
    filter_path = '',
    is_replace_field_visible = false,
    is_filter_field_visible = #opts.search_paths > 0,
    is_match_case_insensitive_checked = false,
    search_info = '',
    search_results = {},
  })

  local subscription = signal:observe(function(prev, curr)
    local diff = fn.isome(
      { 'search_query', 'is_match_case_insensitive_checked', 'search_paths', 'filter_path' },
      function(key)
        return not vim.deep_equal(prev[key], curr[key])
      end
    )

    if diff then
      if #curr.search_query > 2 then
        engine.search(curr, signal)
      else
        signal.search_info = ''
        signal.search_results = {}
      end
    end

    if not (prev.replace_query == curr.replace_query) and #curr.search_query > 2 then
      signal.search_results = engine.process(curr)
    end
  end)

  local function move_cursor_to_eol()
    if vim.api.nvim_get_mode().mode == 'n' then
      feedkeys('A')
    end
  end
  local actions = {
    toggle_replace_input = function(is_replace_focus)
      signal.is_replace_field_visible = is_replace_focus

      local next_input = renderer:get_component_by_id(is_replace_focus and 'replace_query' or 'search_query')
      renderer:schedule(function()
        next_input:focus()
        vim.defer_fn(move_cursor_to_eol, 120)
      end)
    end,
    toggle_filter_input = function()
      local is_checked = not signal.is_filter_field_visible:get_value()
      signal.is_filter_field_visible = is_checked

      local next_input = renderer:get_component_by_id(is_checked and 'filter_path' or 'search_query')
      renderer:schedule(function()
        next_input:focus()
        vim.defer_fn(move_cursor_to_eol, 120)
      end)
    end,
  }

  renderer:add_mappings({
    {
      mode = { 'n' },
      key = '<leader>q',
      handler = function()
        renderer:close()
      end,
    },
    {
      mode = { 'n' },
      key = '|',
      handler = function()
        local width = renderer:get_size().width
        if ui_info.width > width then
          renderer:set_size({ width = ui_info.width })
        else
          renderer:set_size({ width = math.min(100, ui_info.width) })
        end
      end,
    },
    {
      mode = { 'n', 'i' },
      key = '<A-c>',
      handler = function()
        signal.is_match_case_insensitive_checked = not signal.is_match_case_insensitive_checked:get_value()
      end,
    },
    {
      mode = { 'n', 'i' },
      key = '<C-f>',
      handler = actions.toggle_filter_input,
    },
    {
      mode = { 'n', 'i' },
      key = '<C-t>',
      handler = function()
        local is_visible = not signal.is_replace_field_visible:get_value()
        actions.toggle_replace_input(is_visible)
      end,
    },
  })

  renderer:on_mount(function()
    if opts.search_text == '' or #opts.search_text <= 2 then
      return
    end

    local curr = signal:get_value()
    engine.search(curr, signal)
  end)
  renderer:on_unmount(function()
    subscription:unsubscribe()
    M.renderer = nil
  end)

  M.renderer = renderer

  local left_gap = function()
    return n.gap({ size = 3, window = window })
  end

  local body = n.rows(
    -- Row 1
    n.columns(
      { size = 3 },
      n.checkbox({
        window = window,
        border_style = 'none',
        default_sign = Icons.Other.ChevronSlimRight,
        checked_sign = Icons.Other.ChevronSlimDown,
        padding = { top = 1, left = 1, bottom = 1 },
        value = signal.is_replace_field_visible,
        on_change = function(is_checked)
          actions.toggle_replace_input(is_checked)
        end,
      }),
      n.text_input({
        window = window,
        autofocus = true,
        flex = 1,
        max_lines = 1,
        id = 'search_query',
        border_label = 'Search',
        value = signal.search_query,
        on_change = fn.debounce(function(value)
          signal.search_query = value
        end, 400),
        -- window = {
        --   blend = 0,
        --   highlight = {
        --     FloatBorder = 'Normal',
        --     NormalFloat = 'String',
        --   },
        -- },
      }),
      n.checkbox({
        window = window,
        label = 'Aa',
        default_sign = '',
        checked_sign = '',
        border_style = 'rounded',
        is_focusable = false,
        value = signal.is_match_case_insensitive_checked,
        on_change = function(is_checked)
          signal.is_match_case_insensitive_checked = is_checked
        end,
      })
    ),
    -- Row 2
    n.columns(
      {
        size = 3,
        hidden = signal.is_replace_field_visible:map(function(value)
          return not value
        end),
      },
      left_gap(),
      n.text_input({
        window = window,
        max_lines = 1,
        flex = 1,
        id = 'replace_query',
        border_label = 'Replace',
        on_change = fn.debounce(function(value)
          signal.replace_query = value
        end, 400),
      })
    ),
    -- Row 3
    n.columns(
      {
        size = 3,
        hidden = signal.is_filter_field_visible:map(function(value)
          return not value
        end),
      },
      left_gap(),
      n.text_input({
        window = window,
        flex = 1,
        size = 1,
        id = 'filter_path',
        max_lines = 1,
        border_label = 'Pattern to filter',
        -- placeholder = 'lua/**/*.lua',
        value = signal.filter_path,
        on_change = fn.debounce(function(value)
          signal.filter_path = value
        end, 400),
      }),
      n.text_input({
        window = window,
        size = 1,
        flex = 1,
        max_lines = 1,
        border_label = 'Directories to include',
        -- placeholder = 'lua/, plugin/',
        value = signal.search_paths:map(function(paths)
          return table.concat(paths, ',')
        end),
        on_change = fn.debounce(function(value)
          signal.search_paths = fn.ireject(fn.imap(vim.split(value, ','), fn.trim), function(path)
            return path == ''
          end)
        end, 400),
      })
    ),
    -- Row 4
    n.columns(
      {
        size = 2,
        hidden = signal.search_info:map(function(value)
          return value == ''
        end),
      },
      n.paragraph({
        is_focusable = false,
        lines = signal.search_info,
        padding = { left = 3 },
        window = info_window,
      }),
      n.gap({ flex = 1, window = window }),
      n.paragraph({
        is_focusable = false,
        lines = 'Toggle Case:<A-c>, Replace:<C-t>, Filter:<C-f>',
        padding = { right = 1 },
        window = info_window,
      })
    ),
    -- Row 5
    search_tree({
      search_query = signal.search_query,
      replace_query = signal.replace_query,
      data = signal.search_results,
      origin_winid = renderer:get_origin_winid(),
      hidden = signal.search_results:map(function(value)
        return #value == 0
      end),
    })
    -- n.gap(1),
    -- n.columns(
    --   {
    --     size = 1,
    --     on_state_change = function(state)
    --       return {
    --         hidden = not (state.search_results and #state.replace_value > 0)
    --       }
    --     end
    --   },
    --   n.gap({flex = 1}),
    --   n.button(
    --     {
    --       label = "Replace All",
    --       on_press = function()
    --       end
    --     }
    --   ),
    --   n.gap(1),
    --   n.button(
    --     {
    --       label = "Clear",
    --       on_press = function()
    --       end
    --     }
    --   )
    -- )
  )

  renderer:render(body)
  renderer.layout._.float.win_options = { winblend = 0, winhighlight = 'Normal:None' }
end

return M
