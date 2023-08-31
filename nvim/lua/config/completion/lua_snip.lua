return {
  config = function()
    local ls = require('luasnip')
    local icons = require('hasan.utils.ui.icons')
    local types = require('luasnip.util.types')
    ls.config.set_config({
      -- This tells LuaSnip to remember to keep around the last snippet.
      -- You can jump back into it even if you move outside of the selection
      history = true,
      -- This one is cool cause if you have dynamic snippets, it updates as you type!
      update_events = 'TextChanged,TextChangedI,InsertEnter,InsertLeave',
      region_check_events = 'InsertEnter,CursorMoved',
      delete_check_events = 'TextChanged,InsertLeave',
      -- Autosnippets:
      enable_autosnippets = false,
      -- ext_opts = nil,
      ext_opts = {
        [types.choiceNode] = {
          passive = { virt_text = { { '◇', 'Comment' } } },
          active = { virt_text = { { '◆', 'CmpItemKindClass' } } },
        },
        [types.insertNode] = {
          passive = { virt_text = { { icons.ui.Circle, 'Comment' } } },
          active = { virt_text = { { icons.ui.Circle, 'String' } } },
        },
      },
    })

    -- require('luasnip').filetype_extend('javascriptreact', { 'javascript' }) -- (to, {from})
    -- require('luasnip').filetype_extend('javascript', { 'javascriptreact' })
    -- require('luasnip').filetype_extend('typescript', { 'javascript' })
    -- require('luasnip').filetype_extend('typescriptreact', { 'javascript' })

    local configPath = require('hasan.utils.file').config_root()
    vim.cmd([[command! LuaSnipEditLocal :lua require("luasnip.loaders.from_lua").edit_snippet_files()]])
    vim.defer_fn(function()
      require('luasnip.loaders.from_lua').lazy_load({ paths = { configPath .. '/lua/snips' } })
      require('luasnip.loaders.from_vscode').lazy_load({ paths = { configPath .. '/.vsnip' } })
      require('luasnip.loaders.from_vscode').lazy_load()

      -- LuaSnip Snippet History Fix (Seems to work really well, I think.)
      -- https://github.com/Aumnescio/dotfiles/blob/a3efe4d1fdbc7592dd0d84f39539a93b7a119e43/nvim/init.lua#L3365
      local luasnip_fix_augroup = vim.api.nvim_create_augroup('MyLuaSnipHistory', { clear = true })
      vim.api.nvim_create_autocmd('ModeChanged', {
        pattern = '*',
        callback = function()
          if
            ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
            and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
            and not require('luasnip').session.jump_active
          then
            require('luasnip').unlink_current()
          end
        end,
        group = luasnip_fix_augroup,
      })
    end, 100)
  end,
}
