local M = {}

-- Yank in register full path of entry under cursor
function M.yank_path(path, modifier, title)
  if path == nil then
    return
  end

  path = vim.fn.fnamemodify(vim.fs.normalize(path), modifier)
  vim.fn.setreg('+', path)

  vim.notify('Coppied [' .. path .. '] to clipboard', vim.log.levels.INFO, { title = title })
end

function M.copy_content_to_clipboard(path)
  if not path then
    vim.notify('No file or directory selected', vim.log.levels.WARN)
    return
  end

  path = vim.fs.normalize(path)

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

function M.paste_content_from_clipboard(curr_dir)
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

  vim.notify('Pasted successfully.', vim.log.levels.INFO)
end

function M.zip_and_yank_to_clipboard(path)
  if not path then
    vim.notify('No file or directory selected', vim.log.levels.WARN)
    return
  end

  local path = vim.fs.normalize(path)
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

return M
