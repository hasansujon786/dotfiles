local state = ya.sync(function()
  return cx.active.current.cwd
end)

local function fail(s, ...)
  ya.notify({ title = 'Git root', content = string.format(s, ...), timeout = 5, level = 'error' })
end

return {
  entry = function()
    -- local cwd = state()

    local child, err = Command('git'):args({ 'rev-parse', '--show-toplevel' }):stdout(Command.PIPED):spawn()
    if not child then
      return fail('`git` command failed', err)
    end

    local output, err_output = child:wait_with_output()
    if not output then
      return fail('Cannot read `git` output, error code %s', err_output)
    elseif not output.status.success then
      return fail('`git` exited with error code %s', output.status.code)
    end

    local target = output.stdout:gsub('\n$', '')
    if target ~= '' then
      ya.manager_emit('cd', { target })
    else
      return fail('`git` has not found any target')
    end
  end,
}
