---try_change_quicklook
---@param p snacks.Picker
---@param action string|nil
local function try_change_quicklook(p, action)
  if not vim.b.qlook then
    if action then
      p:action(action)
    end
    return
  end

  if vim.b.qlook then
    vim.schedule(function()
      if action then
        p:action(action)
      end

      local cur_item = p.list:current()
      if not cur_item or cur_item._path == nil then
        return
      end

      local ok = pcall(require('hasan.utils.file').quicklook, { cur_item._path })
      if ok then
        vim.b.qlook = cur_item._path
      end
    end)
  end
end

return {
  utils = {
    try_change_quicklook = try_change_quicklook,
    show_explorer = function()
      Snacks.explorer()
      vim.defer_fn(function()
        vim.cmd([[wincmd p]])
      end, 300)
    end,
  },
  source = {
    tree = true,
    watch = true,
    diagnostics = false,
    diagnostics_open = false,
    follow_file = true,
    focus = 'list',
    auto_close = false,
    actions = {
      explorer_collasp_all_root = function(picker)
        local cwd = vim.uv.cwd()
        if not cwd then
          return
        end
        local Tree = require('snacks.explorer.tree')
        cwd = vim.fs.normalize(cwd)

        Tree:close_all(cwd)
        picker:set_cwd(cwd)
        picker:find()
      end,
      explorer_system_reveal = function(_, item)
        local file = item.file or item._path
        if not file then
          return
        end
        require('hasan.utils.file').system_open(file, { reveal = true })
      end,
      terminal = function(_, item)
        if not item then
          return
        end

        Snacks.terminal(nil, {
          shell = 'bash',
          win = { wo = { winbar = '' } },
          cwd = Snacks.picker.util.dir(item),
        })
      end,
      explorer_flash = function(...)
        require('config.navigation.snacks.custom').flash_on_picker(...)
      end,
      toggle_focus_or_quicklook = function(p)
        local cur_item = p.list:current()
        local action = not vim.b.qlook and 'toggle_focus'
          or cur_item and cur_item._path == vim.b.qlook and 'list_down'
          or nil
        try_change_quicklook(p, action)
      end,
      my_list_down = function(p)
        local cur_item = p.list:current()
        local action = not vim.b.qlook and 'toggle_focus'
          or cur_item and cur_item._path == vim.b.qlook and 'list_down'
          or nil
        require('config.navigation.snacks.explorer').utils.try_change_quicklook(p, action)
      end,
    },
    win = {
      input = {
        keys = {
          ['<tab>'] = { 'toggle_focus', mode = { 'i', 'n' } },
        },
      },
      list = {
        keys = {
          ['o'] = 'confirm',
          ['O'] = 'explorer_open', -- open with system application
          ['R'] = 'explorer_system_reveal',
          ['d'] = 'explorer_del',

          [']c'] = 'explorer_git_next',
          ['[c'] = 'explorer_git_prev',
          ['-'] = 'explorer_up',
          ['g/'] = 'picker_grep',
          ['x'] = 'explorer_close', -- close directory
          ['W'] = 'explorer_collasp_all_root',
          ['<tab>'] = { 'toggle_focus_or_quicklook', mode = { 'i', 'n' } },

          ['s'] = 'flash',
          ['<c-t>'] = 'terminal',
          ['i'] = { 'quicklook', mode = { 'i', 'n' } },
          ['<C-i>'] = { 'quicklook', mode = { 'i', 'n' } },

          -- ['k'] = { 'my_list_up', mode = { 'i', 'n' } },
          -- ['j'] = { 'my_list_down', mode = { 'i', 'n' } },
          ['<A-p>'] = { 'my_list_up', mode = { 'i', 'n' } },
          ['<A-n>'] = { 'my_list_down', mode = { 'i', 'n' } },

          ['<leader>/'] = false,
          ['<BS>'] = false,
          -- ['.'] = 'explorer_focus',
          -- ['I'] = 'toggle_ignored',
          -- ['H'] = 'toggle_hidden',
          -- ['Z'] = 'explorer_close_all',
          -- [''] = 'picker_grep',
        },
      },
    },
  },
}
