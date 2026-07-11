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

local function copy_to_cb()
  local curr_entry = mini_files.get_fs_entry()

  if not curr_entry then
    vim.notify('No file or directory selected', vim.log.levels.WARN)
    return
  end

  local path = vim.fs.normalize(curr_entry.path)
  local sys = vim.uv.os_uname().sysname

  local cmd

  if sys == 'Darwin' then
    local safe_path = path:gsub([[\]], [[\\]]):gsub([["]], [[\"]])

    cmd = {
      'osascript',
      '-e',
      string.format([[tell application "Finder" to set the clipboard to (POSIX file "%s")]], safe_path),
    }
  elseif sys == 'Windows_NT' then
    cmd = {
      'powershell',
      '-NoProfile',
      '-Command',
      string.format('Set-Clipboard -Path "%s"', path),
    }
  else
    vim.notify('Copying files is not supported on this OS', vim.log.levels.WARN)
    return
  end

  local result = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify('Copy failed:\n' .. result, vim.log.levels.ERROR)
    return
  end

  vim.notify(string.format("Copied '%s' to system clipboard", vim.fn.fnamemodify(path, ':t')), vim.log.levels.INFO)
end
local paste_from_cb = function()
  if not mini_files then
    vim.notify('mini.files module not loaded.', vim.log.levels.ERROR)
    return
  end

  local curr_entry = mini_files.get_fs_entry()
  if not curr_entry then
    vim.notify('Failed to retrieve current entry in mini.files.', vim.log.levels.ERROR)
    return
  end

  local curr_dir = curr_entry.fs_type == 'directory' and curr_entry.path or vim.fn.fnamemodify(curr_entry.path, ':h')

  local sys = vim.uv.os_uname().sysname

  if sys == 'Darwin' then
    -- Get copied file/folder from Finder clipboard
    local script = [[
      use framework "AppKit"
      on run
        try
          set theFile to the clipboard as alias
          return POSIX path of theFile
        end try

        set pb to current application's NSPasteboard's generalPasteboard()

        try
          set filesList to (pb's propertyListForType:"NSFilenamesPboardType") as list
          if filesList is not missing value then
            if (count of filesList) > 0 then
              return (item 1 of filesList) as text
            end if
          end if
        end try

        try
          set u to pb's stringForType:"public.file-url"
          if u is not missing value then
            set nsurl to current application's NSURL's URLWithString:u
            if nsurl is not missing value then
              return (nsurl's path()) as text
            end if
          end if
        end try

        return "error"
      end run
    ]]

    local source_path = vim.fn.system({ 'osascript', '-e', script })
    source_path = source_path:gsub('%s+$', '')

    if vim.v.shell_error ~= 0 or source_path == '' or source_path == 'error' then
      vim.notify('Clipboard does not contain a valid file or directory.', vim.log.levels.WARN)
      return
    end

    local dest_path = curr_dir .. '/' .. vim.fn.fnamemodify(source_path, ':t')

    local copy_cmd = vim.fn.isdirectory(source_path) == 1 and { 'cp', '-R', source_path, dest_path }
      or { 'cp', source_path, dest_path }

    local result = vim.fn.system(copy_cmd)

    if vim.v.shell_error ~= 0 then
      vim.notify('Paste failed:\n' .. result, vim.log.levels.ERROR)
      return
    end
  elseif sys == 'Windows_NT' then
    -- Read copied file/folder from Explorer clipboard
    local source_path = vim.fn.system({
      'powershell',
      '-NoProfile',
      '-Command',
      '(Get-Clipboard -Format FileDropList | Select-Object -First 1).FullName',
    })

    source_path = source_path:gsub('%s+$', '')

    if vim.v.shell_error ~= 0 or source_path == '' then
      vim.notify('Clipboard does not contain a valid file or directory.', vim.log.levels.WARN)
      return
    end

    local dest_path = curr_dir .. '\\' .. vim.fn.fnamemodify(source_path, ':t')

    local ps = string.format(
      [[Copy-Item -LiteralPath '%s' -Destination '%s' -Recurse -Force]],
      source_path:gsub("'", "''"),
      dest_path:gsub("'", "''")
    )

    local result = vim.fn.system({
      'powershell',
      '-NoProfile',
      '-Command',
      ps,
    })

    if vim.v.shell_error ~= 0 then
      vim.notify('Paste failed:\n' .. result, vim.log.levels.ERROR)
      return
    end
  else
    vim.notify('Paste from clipboard is not supported on this OS.', vim.log.levels.WARN)
    return
  end

  mini_files.synchronize()
  vim.notify('Pasted successfully.', vim.log.levels.INFO)
end
local zip_and_yank = function()
  local curr_entry = require('mini.files').get_fs_entry()

  if not curr_entry then
    vim.notify('No file or directory selected', vim.log.levels.WARN)
    return
  end

  local path = vim.fs.normalize(curr_entry.path)
  local name = vim.fn.fnamemodify(path, ':t')
  local timestamp = os.date('%y%m%d%H%M%S')
  local sys = vim.uv.os_uname().sysname

  local zip_path

  if sys == 'Darwin' then
    local parent_dir = vim.fn.fnamemodify(path, ':h')
    zip_path = string.format('/tmp/%s_%s.zip', name, timestamp)

    local zip_cmd = string.format(
      'cd %s && zip -r %s %s',
      vim.fn.shellescape(parent_dir),
      vim.fn.shellescape(zip_path),
      vim.fn.shellescape(name)
    )

    local result = vim.fn.system(zip_cmd)

    if vim.v.shell_error ~= 0 then
      vim.notify('Failed to create zip file:\n' .. result, vim.log.levels.ERROR)
      return
    end

    local copy_result = vim.fn.system({
      'osascript',
      '-e',
      string.format([[tell application "Finder" to set the clipboard to (POSIX file "%s")]], zip_path),
    })

    if vim.v.shell_error ~= 0 then
      vim.notify('Failed to copy zip file to clipboard:\n' .. copy_result, vim.log.levels.ERROR)
      return
    end
  elseif sys == 'Windows_NT' then
    local temp = vim.fn.getenv('TEMP')
    zip_path = string.format('%s\\%s_%s.zip', temp, name, timestamp)

    local ps = string.format(
      [[
      Compress-Archive -LiteralPath '%s' -DestinationPath '%s' -Force
      Set-Clipboard -Path '%s'
      ]],
      path:gsub("'", "''"),
      zip_path:gsub("'", "''"),
      zip_path:gsub("'", "''")
    )

    local result = vim.fn.system({
      'powershell',
      '-NoProfile',
      '-Command',
      ps,
    })

    if vim.v.shell_error ~= 0 then
      vim.notify('Failed to create/copy zip file:\n' .. result, vim.log.levels.ERROR)
      return
    end
  else
    vim.notify('Unsupported operating system', vim.log.levels.WARN)
    return
  end

  vim.notify(zip_path, vim.log.levels.INFO)
  vim.notify('Zipped and copied to clipboard', vim.log.levels.INFO)
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
    vim.keymap.set({ 'n', 'x' }, '<leader>s', MiniFiles.synchronize, { buffer = b, desc = 'Synchronize' })

    vim.keymap.set('n', '<C-c>', copy_to_cb, { buffer = b, desc = 'Copy file/directory to system clipboard' })
    vim.keymap.set('n', '<C-v>', paste_from_cb, { buffer = b, desc = 'Paste file/directory from system clipboard' })
    vim.keymap.set('n', 'yz', zip_and_yank, { buffer = b, desc = 'Zip and copy to clipboard' })
  end,
}
