return {
  'folke/edgy.nvim',
  event = 'VeryLazy',
  commit = '4ccc1c6',
  lazy = true, -- make sure we load this during startup if it is your main colorscheme
  config = function()
    local color = require('hasan.utils.color')
    vim.opt.splitkeep = 'screen'

    local fg = '#a5b0c5'
    local cyan = '#56B6C2'
    local bg_dark = '#1E242E'
    local bg_gray = '#2D3343'

    color.fg_bg('EdgyWinBarDark', cyan, bg_dark)
    color.fg_bg('EdgyWinBarLight', cyan, bg_gray)
    color.fg_bg('EdgyNormalDark', fg, bg_dark)

    local dark_bar = color.make_winhighlight({
      Winbar = 'EdgyWinBarDark',
      EdgyIcon = 'EdgyWinBarDark',
      EdgyTitle = 'EdgyWinBarDark',
      EdgyIconActive = 'EdgyWinBarDark',
      Normal = 'EdgyNormalDark',
    })

    local gray_bar = color.make_winhighlight({
      Winbar = 'EdgyWinBarLight',
      EdgyIcon = 'EdgyWinBarLight',
      EdgyTitle = 'EdgyWinBarLight',
      EdgyIconActive = 'EdgyWinBarLight',
      CursorLine = 'CursorLineFocus',
      Normal = 'EdgyNormal',
    })

    local custom_color_ft = { 'floaterm' }
    augroup('MY_EDGY_AUGROUP')(function(autocmd)
      autocmd({ 'FileType' }, function(_)
        local win = vim.api.nvim_get_current_win()
        if vim.api.nvim_win_get_config(win).relative == '' then
          reset_edgy_win_hl()
          vim.cmd([[
            augroup edgy_custom_hl
              autocmd! * <buffer>
              autocmd WinEnter,BufEnter <buffer> lua reset_edgy_win_hl()
            augroup END
          ]])
        end
      end, { pattern = custom_color_ft })
    end)

    function _G.reset_edgy_win_hl()
      vim.defer_fn(function()
        if vim.tbl_contains(custom_color_ft, vim.bo.filetype) then
          vim.wo.winhighlight = dark_bar
        end
      end, 10)
    end

    -- // layout config:
    local bottom = {
      {
        ft = 'floaterm',
        wo = { winbar = true, winhighlight = dark_bar },
        filter = function(_, win)
          return vim.api.nvim_win_get_config(win).relative == ''
        end,
      },
      {
        ft = 'scratchpad',
        wo = { winbar = false },
      },
    }
    local left = {
      {
        ft = 'NvimTree',
        open = 'NvimTreeOpen',
        filter = function(_, _)
          if vim.b.vinegar then
            return false
          end
          return true
        end,
        wo = { winbar = false },
      },
      {
        ft = 'neo-tree',
        open = 'Neotree filesystem left',
        filter = function(buf, win)
          local pos = vim.api.nvim_buf_get_var(buf, 'neo_tree_position')
          if pos == 'current' or require('hasan.utils').is_floating_win(win) then
            return false
          end
          return true
        end,
        wo = { winbar = false, winhighlight = '' },
      },
    }
    local right = {
      {
        ft = 'flutterToolsOutline',
        open = 'FlutterOutlineOpen',
        wo = { winbar = true, winhighlight = gray_bar },
      },
      {
        ft = 'Outline',
        open = 'Outline',
        wo = { winbar = true, winhighlight = dark_bar },
      },
    }

    -- // dynamic config: flutter log
    table.insert(require('hasan.core.state').ui.edgy.open_flutter_log_on_right and right or bottom, {
      ft = 'log',
      open = 'FlutterLogOpen',
      wo = { winbar = true, winhighlight = dark_bar },
    })

    require('edgy').setup({
      bottom = bottom,
      right = right,
      left = left,
      options = {
        left = { size = 31 },
        bottom = { size = 10 },
        right = { size = 40 },
        top = { size = 10 },
      },
      wo = {
        winbar = true,
        winhighlight = 'WinBar:EdgyWinBar,Normal:EdgyNormal',
      },
      animate = {
        enabled = false,
        fps = 100, -- frames per second
        cps = 200, -- cells per second
        on_begin = function()
          vim.g.minianimate_disable = true
        end,
        on_end = function()
          vim.g.minianimate_disable = false
        end,
        -- Spinner for pinned views that are loading.
        -- if you have noice.nvim installed, you can use any spinner from it, like:
        -- spinner = require("noice.util.spinners").spinners.circleFull,
        spinner = {
          frames = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
          interval = 80,
        },
      },
      keys = {
        ['q'] = function(win)
          win:close()
          require('nebulous').update_all_windows()
          -- win:hide()
        end,
        ['<c-q>'] = function(win)
          win:hide()
          require('nebulous').update_all_windows()
        end,
        [']w'] = function(win)
          win:next({ visible = true, focus = true })
        end,
        -- previous open window
        ['[w'] = function(win)
          win:prev({ visible = true, focus = true })
        end,
        -- next loaded window
        [']W'] = function(win)
          win:next({ pinned = false, focus = true })
        end,
        -- prev loaded window
        ['[W'] = function(win)
          win:prev({ pinned = false, focus = true })
        end,
        -- increase width
        ['<A-.>'] = function(win)
          win:resize('width', 5)
        end,
        -- decrease width
        ['<A-,>'] = function(win)
          win:resize('width', -5)
        end,
        -- increase height
        ['<A-=>'] = function(win)
          win:resize('height', 2)
        end,
        -- decrease height
        ['<A-->'] = function(win)
          win:resize('height', -2)
        end,
        -- reset all custom sizing
        ['|'] = function(win)
          win.view.edgebar:equalize()
        end,
      },
    })
  end,
}
