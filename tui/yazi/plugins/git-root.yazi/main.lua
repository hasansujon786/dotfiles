--- @since 25.2.7

local function fail(s, ...)
  ya.notify({ title = 'Git root', content = string.format(s, ...), timeout = 5, level = 'error' })
end

local M = {
  entry = function(_, _)
    local result, err = Command('git'):args({ 'rev-parse', '--show-toplevel' }):stdout(Command.PIPED):output()
    local output = result.stdout
    if output == '' or output == nil or err then
      return fail('`git` command failed', err)
    end

    local target = output:gsub('\n$', '')
    if target == '' or target == nil then
      return fail('`git` has not found any target')
    end
    ya.mgr_emit('cd', { target })
  end,
}

return M
