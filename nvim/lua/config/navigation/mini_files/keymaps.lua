local function notify(msg, logLevel)
  return vim.notify(msg, logLevel == nil and vim.log.levels.INFO or logLevel, { title = 'MiniFiles' })
end
-- Set focused directory as current working directory
local set_cwd = function()
  local path = (MiniFiles.get_fs_entry() or {}).path
  if path == nil then
    return notify('Cursor is not on valid entry')
  end
  local dir = vim.fs.dirname(path)
  vim.fn.chdir(dir)
  notify('CWD updated to ' .. dir)
end

-- Yank in register full path of entry under cursor
local yank_path = function(modifier)
  modifier = modifier or function(path)
    return path
  end

  local path = (MiniFiles.get_fs_entry() or {}).path
  if path == nil then
    return notify('Cursor is not on a valid entry')
  end

  path = modifier(path)

  vim.fn.setreg('+', path)
  notify('Copied ' .. path .. ' to clipboard')
end

-- Open path with system default handler (useful for non-text files)
local ui_open = function()
  local path = (MiniFiles.get_fs_entry() or {}).path
  if path == nil then
    return notify('Cursor is not on valid entry', vim.log.levels.ERROR)
  end
  vim.ui.open(path)
end

local ui_reveal = function()
  local path = (MiniFiles.get_fs_entry() or {}).path
  if path == nil then
    return notify('Cursor is not on valid entry', vim.log.levels.ERROR)
  end

  local dir = vim.fs.dirname(path)
  if dir == nil then
    return notify('Cursor is not on valid entry', vim.log.levels.ERROR)
  end
  vim.ui.open(dir)
end

local go_in_plus = function()
  for _ = 1, vim.v.count1 do
    MiniFiles.go_in({ close_on_file = true })
  end
end

local go_out_with_count = function()
  for _ = 1, vim.v.count1 do
    MiniFiles.go_out()
  end
end

return {
  setup = function(b)
    vim.keymap.set('n', 'g~', set_cwd, { buffer = b, desc = 'Set cwd' })
    vim.keymap.set('n', '<CR>', go_in_plus, { buffer = b, desc = 'Go in entry plus' })
    vim.keymap.set('n', '-', go_out_with_count, { buffer = b, desc = 'Go out of directory' })

    -- Yank paths
    vim.keymap.set('n', 'gy', function()
      yank_path(function(path)
        return vim.fn.fnamemodify(path, ':.')
      end)
    end, { buffer = b, desc = 'Yank path' })
    vim.keymap.set('n', 'gY', function()
      yank_path(function(path)
        return vim.fn.fnamemodify(path, ':t')
      end)
    end, { buffer = b, desc = 'Yank path' })
    vim.keymap.set('n', 'gr', function()
      yank_path(function(path)
        return vim.fn.fnamemodify(path, ':~')
      end)
    end, { buffer = b, desc = 'Yank path' })

    vim.keymap.set('n', 'R', ui_reveal, { buffer = b, desc = 'OS reveal' })
    vim.keymap.set('n', 'gX', ui_open, { buffer = b, desc = 'OS open' })

    vim.keymap.set({ 'n', 'x' }, '<leader>s', MiniFiles.synchronize, { buffer = b, desc = 'OS open' })
  end,
}
