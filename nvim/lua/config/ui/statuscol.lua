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
  dependencies = {
    {
      'chentoast/marks.nvim',
      keys = {
        { 'm/', '<cmd>MarksListBuf<CR>', desc = 'Marks: Show buf list' },
      },
      opts = {
        mappings = {
          -- set = 'm',
          delete = 'm-', -- specific {key}
          delete_line = 'm--',
          delete_buf = 'm_',
          set_next = 'm,',
          toggle = 'm;',
          preview = "m'",
          prev = '[w',
          next = ']w',

          -- set_bookmark0 = 'm0',
          -- delete_bookmark0 = 'dm0',
          -- next_bookmark = 'm}',
          -- prev_bookmark = 'm{',
          -- delete_bookmark = 'dm=',
          -- annotate = 'm<CR>',

          -- next_bookmark0 = "'0",
          -- prev_bookmark0 = "'0",
          -- next_bookmark1 = "'1",
          -- prev_bookmark1 = "'1",
          -- next_bookmark2 = "'2",
          -- prev_bookmark2 = "'2",
          -- next_bookmark3 = "'3",
          -- prev_bookmark3 = "'3",
          -- next_bookmark4 = "'4",
          -- prev_bookmark4 = "'4",
          -- next_bookmark5 = "'5",
          -- prev_bookmark5 = "'5",
        },
        default_mappings = false,
        -- builtin_marks = { '.', '<', '>', '^' }, -- which builtin marks to show. default {}
        cyclic = true,
        force_write_shada = true, -- whether the shada file is updated after modifying uppercase marks. default false
        refresh_interval = 250,
        sign_priority = { builtin = 8, lower = 10, upper = 15, bookmark = 20 },
        -- disables mark tracking for specific filetypes. default {}
        excluded_filetypes = {},
        -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
        -- sign/virttext. Bookmarks can be used to group together positions and quickly move
        -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
        -- default virt_text is "".
        bookmark_0 = { sign = '' },
        bookmark_1 = { sign = '◉' },
        bookmark_2 = { sign = '○' },
        bookmark_3 = { sign = '✸' },
        bookmark_4 = { sign = '✿' },
        bookmark_5 = { sign = '♥' },
      },
    },
  },
}
