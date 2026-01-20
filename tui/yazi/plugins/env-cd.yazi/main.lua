local falback_paths = {
  REPOES = '~/repoes',
}
return {
  entry = function(self, jobs)
    local env_var = jobs.args[1]
    if not env_var then
      return
    end

    local path = false or falback_paths[env_var] or os.getenv('HOME')
    ya.manager_emit('cd', { path })
  end,
}
