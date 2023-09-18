return {
  'luukvbaal/statuscol.nvim',
  event = 'BufReadPost',
  lazy = true,
  config = function()
    local relculright = false
    -- local builtin = require('statuscol.builtin')

    local function custom_lnumfunc(args, _)
      -- if args.sclnu and fa.sign and fa.sign.wins[args.win].signs[args.lnum] then
      --   return '%=' .. M.signfunc(args, fa)
      -- end
      if not args.rnu and not args.nu then
        return ''
      end
      if args.virtnum ~= 0 then
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

    require('statuscol').setup({
      relculright = relculright,
      segments = {
        -- { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
        -- {
        --   sign = { name = { 'Diagnostic' }, maxwidth = 2, auto = true },
        --   click = 'v:lua.ScSa',
        -- },
        {
          sign = { name = { '.*' }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
          click = 'v:lua.ScSa',
        },
        {
          text = { custom_lnumfunc },
          click = 'v:lua.ScLa',
        },
        {
          sign = { name = { 'GitSign' }, colwidth = 1, auto = false, wrap = true },
          click = 'v:lua.ScSa',
        },
      },
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
