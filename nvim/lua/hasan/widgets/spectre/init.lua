local fn = require('utils.fn')
local n = require('nui-components')
local Icons = require('hasan.utils.ui.icons')
local engine = require('hasan.widgets.spectre.engine')
local search_tree = require('hasan.widgets.spectre.components.search_tree')
local gap = require('hasan.widgets.spectre.components.gap')
local constants = require('hasan.widgets.spectre.constants')

local window = constants.hls.window
local info_text_window = constants.hls.info_text_window
local popup_options = constants.popup_options

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
    max_width = vim.o.columns,
    max_height = vim.o.lines,
    width = math.floor(vim.o.columns / 2),
  }
  local renderer = n.create_renderer({
    width = ui_info.width,
    height = ui_info.max_height - 1,
    relative = 'editor',
    position = { row = 0, col = '100%' },
  })

  local is_replace_processing = false
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
    vim.cmd('startinsert!')
  end

  local actions = {
    insert_search_input = function()
      renderer:get_component_by_id('search_query'):focus()
    end,
    toggle_replace_input = function(is_replace_focus)
      is_replace_focus = is_replace_focus or not signal.is_replace_field_visible:get_value()
      signal.is_replace_field_visible = is_replace_focus

      local next_input = renderer:get_component_by_id(is_replace_focus and 'replace_query' or 'search_query')
      renderer:schedule(function()
        next_input:focus()
        vim.defer_fn(move_cursor_to_eol, 300)
      end)
    end,
    toggle_filter_input = function()
      local is_checked = not signal.is_filter_field_visible:get_value()
      signal.is_filter_field_visible = is_checked

      local next_input = renderer:get_component_by_id(is_checked and 'filter_path' or 'search_query')
      renderer:schedule(function()
        next_input:focus()
        vim.defer_fn(move_cursor_to_eol, 300)
      end)
    end,
    close = function()
      renderer:close()
    end,
    replace_all = function()
      if is_replace_processing then
        vim.notify('Spectre is already running', vim.log.levels.WARN, { title = 'Spectre' })
        return
      end

      local search_query = signal.search_query:get_value()
      local replace_query = signal.replace_query:get_value()
      if not search_query or search_query == '' then
        return
      end

      local tree = renderer:get_component_by_id('search_tree'):get_tree()
      if not tree then
        vim.notify('There is no item to replace', vim.log.levels.INFO, { title = 'Spectre' })
        return
      end
      local tree_nodes = tree:get_nodes()
      if not tree_nodes or #tree_nodes == 0 then
        vim.notify('There is no item to replace', vim.log.levels.INFO, { title = 'Spectre' })
        return
      end
      is_replace_processing = true

      for _, file_node in ipairs(tree_nodes) do
        local text_nodes = tree:get_nodes(file_node:get_id())
        engine.run_replace(text_nodes, tree, search_query, replace_query)
      end
      vim.schedule(vim.cmd.checktime)
      is_replace_processing = false
    end,
    toggle_zoom = function()
      local cur_width = renderer:get_size().width
      if ui_info.max_width > cur_width then
        renderer:set_size({ width = ui_info.max_width })
      else
        renderer:set_size({ width = ui_info.width })
      end
    end,
    exit_zoom = function()
      local cur_width = renderer:get_size().width
      if cur_width ~= ui_info.width then
        renderer:set_size({ width = ui_info.width })
      end
    end,
    toggle_case = function()
      signal.is_match_case_insensitive_checked = not signal.is_match_case_insensitive_checked:get_value()
    end,
  }

  renderer:add_mappings({
    { key = 'q', handler = actions.close, mode = { 'n' } },
    { key = '<leader>q', handler = actions.close, mode = { 'n' } },
    { key = 'R', handler = actions.replace_all, mode = { 'n' } },
    { key = '|', handler = actions.toggle_zoom, mode = { 'n' } },
    { key = '<A-c>', handler = actions.toggle_case, mode = { 'n', 'i' } },
    { key = '<C-f>', handler = actions.toggle_filter_input, mode = { 'n', 'i' } },
    { key = '<C-t>', handler = actions.toggle_replace_input, mode = { 'n', 'i' } },
  })

  renderer:on_mount(function()
    -- Initialise search only if char length is greater than 2
    if opts.search_text == '' or #opts.search_text <= 2 then
      return
    end

    local curr = signal:get_value()
    engine.search(curr, signal)
  end)
  renderer:on_unmount(function()
    vim.api.nvim_set_current_win(renderer:get_origin_winid())
    subscription:unsubscribe()
    M.renderer = nil
  end)

  M.renderer = renderer

  local left_gap = function()
    return gap({ size = 3, window = window })
  end

  local body = n.rows(
    gap({ size = 1, window = window }),
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
      }, popup_options),
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
      }, popup_options),
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
      }, popup_options)
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
      }, popup_options)
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
      }, popup_options),
      n.text_input({
        window = window,
        size = 1,
        flex = 1,
        max_lines = 1,
        border_label = 'Files to include',
        -- placeholder = 'lua/, plugin/',
        value = signal.search_paths:map(function(paths)
          return table.concat(paths, ',')
        end),
        on_change = fn.debounce(function(value)
          signal.search_paths = fn.ireject(fn.imap(vim.split(value, ','), fn.trim), function(path)
            return path == ''
          end)
        end, 400),
      }, popup_options)
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
        window = info_text_window,
      }, popup_options),
      gap({ flex = 1, window = window }),
      n.paragraph({
        is_focusable = false,
        lines = 'Toggle Case:<A-c>, Replace:<C-t>, Filter:<C-f>',
        padding = { right = 1 },
        window = info_text_window,
      }, popup_options)
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
      exit_zoom = actions.exit_zoom,
      insert_search_input = actions.insert_search_input,
    })
    -- gap(1),
    -- n.columns(
    --   {
    --     size = 1,
    --     on_state_change = function(state)
    --       return {
    --         hidden = not (state.search_results and #state.replace_value > 0)
    --       }
    --     end
    --   },
    --  gap({flex = 1}),
    --   n.button(
    --     {
    --       label = "Replace All",
    --       on_press = function()
    --       end
    --     }
    --   ),
    --   gap(1),
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
  -- change canvas transparent
  renderer.layout._.float.win_options = {
    winblend = 0,
    winhighlight = 'Normal:NuiComponentsNormal',
  }
end

return M
