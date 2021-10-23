
vim.opt.spell=true

function CmpNeogitCommitMessageSetup()
  require('cmp').setup.buffer {
    enabled = true,
    sources = {
      { name = 'vsnip' },
      { name = 'spell' },
      { name = 'buffer',
        opts = {
          get_bufnrs = function()
            return vim.api.nvim_list_bufs()
          end,
        },
      },
    },
  }
end
