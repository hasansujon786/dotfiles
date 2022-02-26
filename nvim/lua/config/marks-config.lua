require'marks'.setup {
  mappings = {
    set = 'm',
    delete = 'm-',
    delete_line = 'm--',
    delete_buf = 'dx<space>',
    set_next = 'm,',
    toggle = 'm=',
    preview = 'm;',
    next = 'm]',
    prev = 'm[',

    -- set_bookmark0 = 'm0',
    -- delete_bookmark0 = 'dm0',
    -- next_bookmark = 'm}',
    -- prev_bookmark = 'm{',
    -- delete_bookmark = 'dm=',

    next_bookmark0 = "'0",
    prev_bookmark0 = "'0",
    next_bookmark1 = "'1",
    prev_bookmark1 = "'1",
    next_bookmark2 = "'2",
    prev_bookmark2 = "'2",
    next_bookmark3 = "'3",
    prev_bookmark3 = "'3",
    next_bookmark4 = "'4",
    prev_bookmark4 = "'4",
    next_bookmark5 = "'5",
    prev_bookmark5 = "'5",

    annotate = 'm<CR>',
  },
  default_mappings = true,
  -- builtin_marks = { ".", "<", ">", "^" }, -- which builtin marks to show. default {}
  cyclic = true,
  force_write_shada = true, -- whether the shada file is updated after modifying uppercase marks. default false
  refresh_interval = 250,
  sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
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
}
