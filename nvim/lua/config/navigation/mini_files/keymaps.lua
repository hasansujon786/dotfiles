local mini_files = require('mini.files')

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

local function get_cursor_path()
  local path = (MiniFiles.get_fs_entry() or {}).path
  if path == nil then
    notify('Cursor is not on a valid entry')
    return nil
  end

  return path
end

local function get_cursor_dir()
  local curr_entry = mini_files.get_fs_entry()
  if not curr_entry then
    vim.notify('Failed to retrieve current entry in mini.files.', vim.log.levels.ERROR)
    return
  end

  return curr_entry.fs_type == 'directory' and curr_entry.path or vim.fn.fnamemodify(curr_entry.path, ':h')
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
    local fa = require('hasan.utils.file_action')
    vim.keymap.set('n', 'g~', set_cwd, { buffer = b, desc = 'Set cwd' })
    vim.keymap.set('n', '<CR>', go_in_plus, { buffer = b, desc = 'Go in entry plus' })
    vim.keymap.set('n', '-', go_out_with_count, { buffer = b, desc = 'Go out of directory' })

    -- Yank paths
    vim.keymap.set('n', 'Y', function()
      fa.yank_path(get_cursor_path(), ':t', 'MiniFiles')
    end, { buffer = b, desc = 'Yank path' })
    vim.keymap.set('n', 'g.', function()
      fa.yank_path(get_cursor_path(), ':.', 'MiniFiles')
    end, { buffer = b, desc = 'Yank path' })
    vim.keymap.set('n', 'gy', function()
      fa.yank_path(get_cursor_path(), ':~', 'MiniFiles')
    end, { buffer = b, desc = 'Yank path' })

    vim.keymap.set('n', 'R', ui_reveal, { buffer = b, desc = 'OS reveal' })
    vim.keymap.set('n', 'gX', ui_open, { buffer = b, desc = 'OS open' })
    vim.keymap.set({ 'n', 'x' }, '<leader>s', MiniFiles.synchronize, { buffer = b, desc = 'Synchronize' })

    vim.keymap.set('n', 'gZ', function()
      fa.zip_and_yank_to_clipboard(get_cursor_path())
    end, { buffer = b, desc = 'Zip and copy to clipboard' })
    vim.keymap.set('n', '<C-c>', function()
      fa.copy_content_to_clipboard(get_cursor_path())
    end, { buffer = b, desc = 'Copy file/directory to system clipboard' })
    vim.keymap.set('n', '<C-v>', function()
      if not mini_files then
        vim.notify('mini.files module not loaded.', vim.log.levels.ERROR)
        return
      end

      local curr_dir = get_cursor_dir()
      fa.paste_content_from_clipboard(curr_dir)
      mini_files.synchronize()
    end, { buffer = b, desc = 'Paste file/directory from system clipboard' })
  end,
}
