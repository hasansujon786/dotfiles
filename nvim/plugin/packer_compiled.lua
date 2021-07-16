-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/hasan/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/hasan/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/hasan/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/hasan/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/hasan/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["colorv.vim"] = {
    commands = { "ColorV" },
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/colorv.vim"
  },
  ["dashboard-nvim"] = {
    config = { "\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21config.dashboard\frequire\0" },
    loaded = true,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/start/dashboard-nvim"
  },
  ["emmet-vim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/emmet-vim"
  },
  ["fern-renderer-nerdfont.vim"] = {
    loaded = true,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/start/fern-renderer-nerdfont.vim"
  },
  ["fern.vim"] = {
    loaded = true,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/start/fern.vim"
  },
  ["glyph-palette.vim"] = {
    loaded = true,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/start/glyph-palette.vim"
  },
  ["gv.vim"] = {
    commands = { "GV" },
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/gv.vim"
  },
  harpoon = {
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/harpoon"
  },
  indentLine = {
    after_files = { "/home/hasan/.local/share/nvim/site/pack/packer/opt/indentLine/after/plugin/indentLine.vim" },
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/indentLine"
  },
  ["kissline.nvim"] = {
    loaded = true,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/start/kissline.nvim"
  },
  neogit = {
    commands = { "Neogit" },
    loaded = false,
    needs_bufread = true,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/neogit"
  },
  ["neoscroll.nvim"] = {
    config = { "\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21config.neoscroll\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/neoscroll.nvim"
  },
  ["nerdfont.vim"] = {
    loaded = true,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/start/nerdfont.vim"
  },
  ["notifier.nvim"] = {
    loaded = true,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/start/notifier.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21config.autopairs\frequire\0" },
    loaded = true,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/start/nvim-autopairs"
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\2\ni\0\0\3\0\6\0\n6\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\3\0009\0\4\0'\2\5\0B\0\2\1K\0\1\0\30ColorizerReloadAllBuffers\bcmd\bvim\nsetup\14colorizer\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/nvim-colorizer.lua"
  },
  ["nvim-compe"] = {
    config = { "\27LJ\2\n,\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\17config.compe\frequire\0" },
    loaded = true,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/start/nvim-compe"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22config.treesitter\frequire\0" },
    loaded = true,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-ts-context-commentstring"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/nvim-ts-context-commentstring"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["onedark.nvim"] = {
    loaded = true,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/start/onedark.nvim"
  },
  ["orgmode.nvim"] = {
    config = { "\27LJ\2\n.\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\19config.orgmode\frequire\0" },
    loaded = false,
    needs_bufread = true,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/orgmode.nvim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  playground = {
    commands = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
    loaded = false,
    needs_bufread = true,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["quick-scope"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/quick-scope"
  },
  ["startuptime.vim"] = {
    commands = { "StartupTime" },
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/startuptime.vim"
  },
  ["telescope-fzy-native.nvim"] = {
    loaded = true,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/start/telescope-fzy-native.nvim"
  },
  ["telescope-project.nvim"] = {
    commands = { "SwitchProjects" },
    config = { "\27LJ\2\nq\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0Rcommand! SwitchProjects lua require(\"telescope\").extensions.project.project{}\bcmd\bvim\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/telescope-project.nvim"
  },
  ["telescope-yanklist.nvim"] = {
    loaded = true,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/start/telescope-yanklist.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21config.telescope\frequire\0" },
    loaded = true,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["vim-CtrlXA"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/vim-CtrlXA"
  },
  ["vim-commentary"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/vim-commentary"
  },
  ["vim-eunuch"] = {
    commands = { "Delete", "Move", "Rename", "Mkdir", "Chmod" },
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/vim-eunuch"
  },
  ["vim-floaterm"] = {
    commands = { "FloatermNew", "FloatermToggle" },
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/vim-floaterm"
  },
  ["vim-fugitive"] = {
    commands = { "Git", "GBrowse", "GV" },
    loaded = false,
    needs_bufread = true,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/vim-fugitive"
  },
  ["vim-gitgutter"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/vim-gitgutter"
  },
  ["vim-indent-object"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/vim-indent-object"
  },
  ["vim-open-url"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/vim-open-url"
  },
  ["vim-rel-jump"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/vim-rel-jump"
  },
  ["vim-repeat"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/vim-repeat"
  },
  ["vim-rhubarb"] = {
    commands = { "Git", "GBrowse", "GV" },
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/vim-rhubarb"
  },
  ["vim-rooter"] = {
    config = { "\27LJ\2\n5\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\1\0=\1\2\0K\0\1\0\24rooter_silent_chdir\6g\bvim\0" },
    loaded = true,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/start/vim-rooter"
  },
  ["vim-sneak"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/vim-sneak"
  },
  ["vim-snippets"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/vim-snippets"
  },
  ["vim-surround"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/vim-surround"
  },
  ["vim-tt"] = {
    config = { "\27LJ\2\n+\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\1\0=\1\2\0K\0\1\0\14tt_loaded\6g\bvim\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/vim-tt"
  },
  ["vim-visual-multi"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/vim-visual-multi"
  },
  ["vim-vsnip"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/vim-vsnip"
  },
  vimwiki = {
    commands = { "VimwikiIndex", "VimwikiTabIndex", "VimwikiUISelect" },
    loaded = false,
    needs_bufread = true,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/vimwiki"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20config.whichkey\frequire\0" },
    loaded = true,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/start/which-key.nvim"
  },
  ["zen-mode.nvim"] = {
    commands = { "ZenMode" },
    loaded = false,
    needs_bufread = false,
    path = "/home/hasan/.local/share/nvim/site/pack/packer/opt/zen-mode.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
try_loadstring("\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20config.whichkey\frequire\0", "config", "which-key.nvim")
time([[Config for which-key.nvim]], false)
-- Config for: nvim-compe
time([[Config for nvim-compe]], true)
try_loadstring("\27LJ\2\n,\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\17config.compe\frequire\0", "config", "nvim-compe")
time([[Config for nvim-compe]], false)
-- Config for: nvim-autopairs
time([[Config for nvim-autopairs]], true)
try_loadstring("\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21config.autopairs\frequire\0", "config", "nvim-autopairs")
time([[Config for nvim-autopairs]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21config.telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: vim-rooter
time([[Config for vim-rooter]], true)
try_loadstring("\27LJ\2\n5\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\1\0=\1\2\0K\0\1\0\24rooter_silent_chdir\6g\bvim\0", "config", "vim-rooter")
time([[Config for vim-rooter]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22config.treesitter\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: dashboard-nvim
time([[Config for dashboard-nvim]], true)
try_loadstring("\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21config.dashboard\frequire\0", "config", "dashboard-nvim")
time([[Config for dashboard-nvim]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
if vim.fn.exists(":VimwikiIndex") == 0 then
vim.cmd [[command! -nargs=* -range -bang -complete=file VimwikiIndex lua require("packer.load")({'vimwiki'}, { cmd = "VimwikiIndex", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":VimwikiTabIndex") == 0 then
vim.cmd [[command! -nargs=* -range -bang -complete=file VimwikiTabIndex lua require("packer.load")({'vimwiki'}, { cmd = "VimwikiTabIndex", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":VimwikiUISelect") == 0 then
vim.cmd [[command! -nargs=* -range -bang -complete=file VimwikiUISelect lua require("packer.load")({'vimwiki'}, { cmd = "VimwikiUISelect", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":TSPlaygroundToggle") == 0 then
vim.cmd [[command! -nargs=* -range -bang -complete=file TSPlaygroundToggle lua require("packer.load")({'playground'}, { cmd = "TSPlaygroundToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":TSHighlightCapturesUnderCursor") == 0 then
vim.cmd [[command! -nargs=* -range -bang -complete=file TSHighlightCapturesUnderCursor lua require("packer.load")({'playground'}, { cmd = "TSHighlightCapturesUnderCursor", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":SwitchProjects") == 0 then
vim.cmd [[command! -nargs=* -range -bang -complete=file SwitchProjects lua require("packer.load")({'telescope-project.nvim'}, { cmd = "SwitchProjects", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":ColorV") == 0 then
vim.cmd [[command! -nargs=* -range -bang -complete=file ColorV lua require("packer.load")({'colorv.vim'}, { cmd = "ColorV", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":FloatermToggle") == 0 then
vim.cmd [[command! -nargs=* -range -bang -complete=file FloatermToggle lua require("packer.load")({'vim-floaterm'}, { cmd = "FloatermToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":FloatermNew") == 0 then
vim.cmd [[command! -nargs=* -range -bang -complete=file FloatermNew lua require("packer.load")({'vim-floaterm'}, { cmd = "FloatermNew", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":StartupTime") == 0 then
vim.cmd [[command! -nargs=* -range -bang -complete=file StartupTime lua require("packer.load")({'startuptime.vim'}, { cmd = "StartupTime", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":Neogit") == 0 then
vim.cmd [[command! -nargs=* -range -bang -complete=file Neogit lua require("packer.load")({'neogit'}, { cmd = "Neogit", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":Delete") == 0 then
vim.cmd [[command! -nargs=* -range -bang -complete=file Delete lua require("packer.load")({'vim-eunuch'}, { cmd = "Delete", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":Move") == 0 then
vim.cmd [[command! -nargs=* -range -bang -complete=file Move lua require("packer.load")({'vim-eunuch'}, { cmd = "Move", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":Rename") == 0 then
vim.cmd [[command! -nargs=* -range -bang -complete=file Rename lua require("packer.load")({'vim-eunuch'}, { cmd = "Rename", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":Mkdir") == 0 then
vim.cmd [[command! -nargs=* -range -bang -complete=file Mkdir lua require("packer.load")({'vim-eunuch'}, { cmd = "Mkdir", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":Chmod") == 0 then
vim.cmd [[command! -nargs=* -range -bang -complete=file Chmod lua require("packer.load")({'vim-eunuch'}, { cmd = "Chmod", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":ZenMode") == 0 then
vim.cmd [[command! -nargs=* -range -bang -complete=file ZenMode lua require("packer.load")({'zen-mode.nvim'}, { cmd = "ZenMode", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":Git") == 0 then
vim.cmd [[command! -nargs=* -range -bang -complete=file Git lua require("packer.load")({'vim-rhubarb', 'vim-fugitive'}, { cmd = "Git", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":GBrowse") == 0 then
vim.cmd [[command! -nargs=* -range -bang -complete=file GBrowse lua require("packer.load")({'vim-rhubarb', 'vim-fugitive'}, { cmd = "GBrowse", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":GV") == 0 then
vim.cmd [[command! -nargs=* -range -bang -complete=file GV lua require("packer.load")({'vim-rhubarb', 'gv.vim', 'vim-fugitive'}, { cmd = "GV", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'vim-snippets', 'vim-vsnip'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
vim.cmd [[au VimEnter * ++once lua require("packer.load")({'neoscroll.nvim', 'vim-tt', 'harpoon'}, { event = "VimEnter *" }, _G.packer_plugins)]]
vim.cmd [[au BufRead * ++once lua require("packer.load")({'vim-gitgutter', 'vim-visual-multi', 'vim-indent-object', 'vim-open-url', 'nvim-colorizer.lua', 'vim-sneak', 'vim-surround', 'nvim-ts-context-commentstring', 'orgmode.nvim', 'vim-repeat', 'quick-scope', 'emmet-vim', 'vim-rel-jump', 'vim-CtrlXA', 'vim-commentary', 'indentLine'}, { event = "BufRead *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
