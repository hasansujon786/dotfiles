setl shiftwidth=1 tabstop=1 softtabstop=1
setl conceallevel=2 concealcursor=n

nnoremap cic   <cmd>lua require('orgmode').action('org_mappings.toggle_checkbox')<CR>
nnoremap <C-q> <cmd>lua require('orgmode').action('org_mappings.toggle_checkbox')<CR>

lua << EOF
function CmpOrgmodeSetup()
  require('cmp').setup.buffer {
    enabled = true,
    sources = {
      { name = 'orgmode' },
      { name = 'luasnip' },
      { name = 'spell' },
      { name = 'buffer'},
      { name = 'path' },
    },
  }
end
EOF

