" http://shapecatcher.com/
" https://fsymbols.com/draw/
" https://fsymbols.com/all/

" Powerline characters:
"                
"  ﰖ   
"   
"    
"         
"          
"      
"   ﬘   
" ↳ ▲ ▼ ↪    ➤  |>     ›   ❯ 	 ➜  
"         
" 30°
"   ◎ ●   ✹ ✚ ✭ ✪ ★ ⌘ ☠
" ‖ ▎   ┃ ║ ╬ █
" '─│─│╭╮╯╰'
"    
" numbers_sup = {'¹','²','³','⁴','⁵','⁶','⁷','⁸','⁹','⁰'}
" ■ ▁ ▂ ▃ ▄ ▅ ▆ ▇ █ ▀ ▔ ▏ ▎ ▍ ▌ ▋ ▊ ▉ ▐ ▕ ▖ ▗ ▘ ▙ ▚ ▛ ▜ ▝ ▞ ▟ ░ ▒ ▓
"   פּ     蘒練  some other good icons

"-- https://www.chrisatmachine.com/Neovim/26-lsp-symbols/
"-- https://code.visualstudio.com/docs/editor/intellisense
"-- '', -- Function
"-- '﬌', -- Snippet
"-- '', -- Reference
"-- '', -- Folder

"-- it from coc.vim by chrisAtMachine
""suggest.completionItemKindLabels": {
"  "method": "  ",
"  "function": "  ",
"  "variable": "[]",
"  "field": "  ",
"  "typeParameter": "<>",
"  "constant": "  ",
"  "class": " פּ ",
"  "interface": " 蘒",
"  "struct": "  ",
"  "event": "  ",
"  "operator": "  ",
"  "module": "  ",
"  "property": "  ",
"  "enum": " 練",
"  "reference": "  ",
"  "keyword": "  ",
"  "file": "  ",
"  "folder": " ﱮ ",
"  "color": "  ",
"  "unit": " 塞 ",
"  "snippet": "  ",
"  "text": "  ",
"  "constructor": "  ",
"  "value": "  ",
"  "enumMember": "  "
"},

"vim_item.kind = ({
"  Class = 'ﴯ',
"  Constant = '',
"  Color = '',
"  Constructor = '',
"  Enum = '',
"  EnumMember = '',
"  Event = '',
"  Field = 'ﰠ',
"  File = '',
"  Folder = '',
"  Function = '',
"  Interface = '',
"  Keyword = '',
"  Method = '',
"  Module = '',
"  Operator = '',
"  Property = 'ﰠ',
"  Reference = '',
"  Snippet = "",
"  Struct = 'פּ',
"  Text = '',
"  TypeParameter = '',
"  Unit = '塞',
"  Value = '',
"  Variable = ''
"})[vim_item.kind]

"-- symbols for autocomplete
"vim.lsp.protocol.CompletionItemKind = {
"  "   (Text) ",
"  "   (Method)",
"  "   (Function)",
"  "   (Constructor)",
"  " ﴲ  (Field)",
"  "[] (Variable)",
"  "   (Class)",
"  " ﰮ  (Interface)",
"  "   (Module)",
"  " 襁 (Property)",
"  "   (Unit)",
"  "   (Value)",
"  " 練 (Enum)",
"  "   (Keyword)",
"  "   (Snippet)",
"  "   (Color)",
"  "   (File)",
"  "   (Reference)",
"  "   (Folder)",
"  "   (EnumMember)",
"  " ﲀ  (Constant)",
"  " ﳤ  (Struct)",
"  "   (Event)",
"  "   (Operator)",
"  "   (TypeParameter)",
"}

"icons = {
"  Class = " ",
"  Color = " ",
"  Constant = " ",
"  Constructor = " ",
"  Enum = "了 ",
"  EnumMember = " ",
"  Field = " ",
"  File = " ",
"  Folder = " ",
"  Function = " ",
"  Interface = "ﰮ ",
"  Keyword = " ",
"  Method = "ƒ",
"  Module = " ",
"  Property = " ",
"  Snippet = "﬌ ",
"  Struct = " ",
"  Text = " ",
"  Unit = " ",
"  Value = " ",
"  Variable = " ",
"}

" vim.opt.fillchars = {
"   horiz = '━',
"   horizup = '┻',
"   horizdown = '┳',
"   vert = '┃',
"   vertleft  = '┫',
"   vertright = '┣',
"   verthoriz = '╋',
" }

" -- local border = {
" --   { "┏", "FloatBorder" },
" --   { "━", "FloatBorder" },
" --   { "┓", "FloatBorder" },
" --   { "┃", "FloatBorder" },
" --   { "┛", "FloatBorder" },
" --   { "━", "FloatBorder" },
" --   { "┗", "FloatBorder" },
" --   { "┃", "FloatBorder" },
" -- }

" local border = {
"     { "╔", "FloatBorder" },
"     { "═", "FloatBorder" },
"     { "╗", "FloatBorder" },
"     { "║", "FloatBorder" },
"     { "╝", "FloatBorder" },
"     { "═", "FloatBorder" },
"     { "╚", "FloatBorder" },
"     { "║", "FloatBorder" },
" }

" -- local border = {
" --   {  "▛","FloatBorder"},
" --   {  "▀","FloatBorder"},
" --   {  "▜","FloatBorder"},
" --   {  "▐","FloatBorder"},
" --   {  "▟","FloatBorder"},
" --   {  "▄","FloatBorder"},
" --   {  "▙","FloatBorder"},
" --   {  "▌","FloatBorder"},
" -- }

" -- local border = {
" --   { "╭", "FloatBorder" },
" --   { "─", "FloatBorder" },
" --   { "╮", "FloatBorder" },
" --   { "│", "FloatBorder" },
" --   { "╯", "FloatBorder" },
" --   { "─", "FloatBorder" },
" --   { "╰", "FloatBorder" },
" --   { "│", "FloatBorder" },
" -- }

" ⊑ ⊂ ∋ ⅀ ⊃ ⊤ ≋ ∀ ⋰ ⊥ ⊛ ⊖ ⊗ ⊙ ⊕ ↑ ↗ → ↘ ↓ ↙ ← ↖ ↔ ↕ @ & ¶ § © ® ₿ ¢ ¤ $ ₫ € ₽ £
" ₮ ¥ ƒ ∙ ≔ ∁ ≃ ≅ ∐ ⎪ ⋎ ∣ ∕ ∸ ⋐ ⋱ ∈ ⋮ ∎ ≡ ∹ ∃ ≳ ⎩ ⎨ ⎥ ⎦ ⎤ ⊢ ≗ ∘ ∼ ⊓ ⊔ ⎧ ⎢ ⎣ ⎡ ≲
" ⋯ ⊸ ⊎ ⨀ ⨆ ≇ ⊈ ≉ ∌ ∉ ≯ ≱ ≢ ≮ ≰ ⊄ ⊅ + − × ÷ = ≠ > < ≥ ≤ ± ≈ ¬ ~ ^ ∞ ∅ ∧ ∨ ∩ ∪ ∫
" ∏ ∑ √ ∂ µ ⍳ ⍴ ℓ ℮ ∥ ⎜ ⎝ ⎛ ⎟ ⎠ ⎞ % ‰ ⁺ ™ ° ′ ″ ≺ ≼ ∷ ≟ ∶ ⊆ ⊇ ⤖ ⎭ ⎬ ⎫ ↭ ↞ ↠ ↣ ↥
" ↦ ↧ ⇉ ⇑ ⇒ ⇓ ⇔ ⇧ ⇨ ⌄ ➜ ⟵ ⟶ ⟷ ● ◯ ◔ ◕ ◌ ◎ ◦ ◆ ◇ ◊ ■ □ ▪ ▫ ◧ ◨ ◩ ◪ ◫ ▲ ▶ ▼ ◀ △ ▷
" ▽ ◁ ► ◄ ▻ ◅ ▴ ▸ ▾ ◂ ▵ ▹ ▿ ◃ ⍨ ⚠ ✓ ✕ ✗ ⋆ ✶ | ¦ † ‡ № ⌃ ⌂ ⌅ ⌥ ⌘ ⏻ ⏼ ⭘ ⏽ ⏾ � ┌ └
" ┐ ┘ ┼ ┬ ┴ ├ ┤ ───── │ ╡ ╢ ╖ ╕ ╣ ║ ╗ ╝ ╜ ╛ ╞ ╟ ╚ ╔ ╩ ╦ ╠ ═ ╬ ╧ ╨ ╤ ╥ ╙ ╘ ╒ ╓ ╫
" ╪ ━ ┃ ┄ ┅ ┆ ┇ ┈ ┉ ┊ ┋ ┍ ┎ ┏ ┑ ┒ ┓ ┕ ┖ ┗ ┙ ┚ ┛ ┝ ┞ ┟ ┠ ┡ ┢ ┣ ┥ ┦ ┧ ┨ ┩ ┪ ┫ ┭ ┮
" ┯ ┰ ┱ ┲ ┳ ┵ ┶ ┷ ┸ ┹ ┺ ┻ ┽ ┾ ┿ ╀ ╁ ╂ ╃ ╄ ╅ ╆ ╇ ╈ ╉ ╊ ╋ ╌ ╍ ╎ ╏ ╭ ╮ ╯ ╰ ╱ ╲ ╳ ╴
" ╵ ╶ ╷ ╸ ╹ ╺ ╻ ╼ ╽ ╾ ╿

" $ € ƒ ₺ ₱ ₽ ₹ £ ¥ ₿ ฿ ¢ ¤ + − × ÷ = ≠ > < ≥ ≤ ± ≈ ~ ¬ ^ ∅ ⭘ ∞ ∫ ∏ ∑ √ ∂ % ‰ ↑
" ↗ → ↘ ↓ 2193 ↙ ← ↖ ↔ ↕ ◊ ☐ ☑ ☒ @ & ¶ § © ® ™ ° | ¦ † ℓ ℮ ‡ № ➲ ☁ 🌧 🌩 ☇ ☠ ☹ ☾
" ♥ ❄ ⎇ ⎋ 🌐 💳 🔒 🔓 ⇪ ⌧ ⌫ ⌦ ⏏ ⌨ ⌥ ⌘ ⏎ ⏻ ⏼ ⭘ ⏽ ⏾ ⎙ ☚ ☛ ☜ ☝ ☞ ☟ ª º ● ○ ◯ ◐ ◑ ◒
" ◓ ◖ ◗ ◔ ◕ ◴ ◵ ◶ ◷ ◍ ◌ ◉ ◎ ◦ ◙ ◚ ◛ ◠ ◡ ◜◝ ◞ ◟ ◆ ◇ ▮ ▬ ▭ ▯ ■ □ ▢ ▣ ▪ ▫ ◧ ◨ ◩ ◪ ◫
" ◰ ◱ ◲ ◳ ▲ ▶ ▼ ◀ ◄ ◥ ◢ ◣ ◤─
