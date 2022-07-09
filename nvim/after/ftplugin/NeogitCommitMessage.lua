
vim.opt.spell=true

function CmpNeogitCommitMessageSetup()
  require('cmp').setup.buffer {
    enabled = true,
    sources = {
      { name = 'luasnip' },
      { name = 'spell' },
      { name = 'buffer',
        option = {
          get_bufnrs = function()
            return vim.api.nvim_list_bufs()
          end,
        },
      },
    },
  }
end
