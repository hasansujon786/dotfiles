return {
  'luukvbaal/statuscol.nvim',
  event = 'BufReadPost',
  lazy = true,
  config = function()
    local relculright = false
    -- local builtin = require('statuscol.builtin')

    local function custom_line_num_func(args, _)
      -- if args.sclnu and fa.sign and fa.sign.wins[args.win].signs[args.lnum] then
      --   return '%=' .. M.signfunc(args, fa)
      -- end
      if not args.rnu and not args.nu then
        return '%='
      end

      -- virtnum setup: https://www.reddit.com/r/neovim/comments/1ggwaho/multiline_showbreaklike_wrapping_symbols_in/
      if vim.v.virtnum < 0 then
        return '%=-'
      elseif vim.v.virtnum > 0 then
        return '%='
      end

      local lnum = args.rnu and (args.relnum > 0 and args.relnum or (args.nu and args.lnum or 0)) or args.lnum

      -- if thou and lnum > 999 then
      --   lnum = reverse(lnum):gsub('%d%d%d', '%1' .. thou):reverse():gsub('^%' .. thou, '')
      -- end

      if args.relnum == 0 and not relculright and args.rnu then
        if lnum < 10 then
          return lnum .. '  ' .. '%='
        end
        return lnum .. '%='
      else
        if lnum < 10 then
          return '%=' .. '  ' .. lnum
        end
        if lnum < 100 then
          return '%=' .. ' ' .. lnum
        end
        return '%=' .. lnum
      end
    end

    local segments = {
      -- {
      --   sign = { name = { 'Diagnostic' }, maxwidth = 2, auto = true },
      --   click = 'v:lua.ScSa',
      -- },
      {
        sign = {
          name = { '.*' }, -- table of lua patterns to match the sign name against
          text = { '.*' }, -- table of lua patterns to match the extmark sign text against
          namespace = { '.*' }, -- table of lua patterns to match the extmark sign namespace against
          maxwidth = 2,
          colwidth = 1,
          auto = true,
          wrap = true,
        },
        click = 'v:lua.ScSa',
      },
      {
        text = { custom_line_num_func },
        click = 'v:lua.ScLa',
      },
      {
        sign = {
          namespace = { 'gitsigns' },
          colwidth = 1,
          auto = false,
          wrap = true,
        },
        click = 'v:lua.ScSa',
      },
    }

    if vim.o.foldcolumn ~= '0' then
      table.insert(segments, {
        text = { require('statuscol.builtin').foldfunc },
        click = 'v:lua.ScFa',
      })
    end

    require('statuscol').setup({
      relculright = relculright,
      segments = segments,
      ft_ignore = {
        'help',
        'fern',
        'NvimTree',
        'neo-tree',
        'fzf',
        'floating',
        'qf',
        'scratchpad',
        'NeogitStatus',
        'NeogitPopup',
        'log',
        'flutterToolsOutline',
        'packer',
        'Outline',
        'dashboard',
        'alpha',
        'floaterm',
        'noice',
        'query',
        'dapui_scopes',
        'dapui_breakpoints',
        'dapui_stacks',
        'dapui_watches',
        'dapui_console',
        'dap-repl',
        -- dap-float
      },
    })
  end,
}
