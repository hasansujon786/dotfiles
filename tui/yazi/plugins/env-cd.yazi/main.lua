return {
  entry = function(self, jobs)
    local env_var = jobs.args[1]
    if not env_var then
      return
    end

    local path = os.getenv(env_var) or os.getenv('HOME')
    ya.manager_emit('cd', { path })
  end,
}
