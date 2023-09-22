local Job = require('plenary.job')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local make_entry = require('telescope.make_entry')
local action_state = require('telescope.actions.state')
local conf = require('telescope.config').values

local flutter_ui = require('flutter-tools.ui')
local M = {}

--------------------------------------------------
-------- Pub commands ----------------------------
--------------------------------------------------
local pub_job = nil
local function on_pub_get(result, err)
  local timeout = err and 10000 or nil
  P(result)
  flutter_ui.notify(result, { timeout = timeout })
end

function M.run_flutter_cmd(args, msg)
  pub_job = Job:new({
    command = 'C:\\tools\\flutter\\bin\\flutter.BAT',
    args = args,
    cwd = vim.loop.cwd(),
  })
  pub_job:after_success(vim.schedule_wrap(function(j)
    on_pub_get(j:result())
    pub_job = nil
  end))
  pub_job:after_failure(vim.schedule_wrap(function(j)
    on_pub_get(j:stderr_result(), true)
    pub_job = nil
  end))
  pub_job:start()

  if msg ~= nil or msg ~= '' then
    flutter_ui.notify(msg, { timeout = 1000 })
  end
end

M.pub_install = function()
  local fpath = vim.fn.fnamemodify('~/dotfiles/pub.json', ':p')
  local data = vim.fn.readfile(fpath)
  local packages = vim.fn.json_decode(data)['packages']

  local opts = {
    results_title = 'flutter_packages',
    -- prompt_title = 'Search Todos',
    previewer = false,
    install_pkg = function(prompt_bufnr, as_dev)
      require('telescope.actions').close(prompt_bufnr)
      local pkg = action_state.get_selected_entry()[1]
      local cmd = { 'pub', 'add', pkg, as_dev and '--dev' }
      M.run_flutter_cmd(cmd, { 'Installing ' .. pkg })
    end,
  }

  pickers
    .new(opts, {
      finder = finders.new_table({
        results = packages,
        entry_maker = make_entry.gen_from_string(opts),
      }),
      sorter = conf.file_sorter(opts),
      attach_mappings = function(_, map)
        map('n', '<cr>', function(prompt_bufnr)
          opts.install_pkg(prompt_bufnr, false)
        end)
        map('n', '<C-v>', function(prompt_bufnr)
          opts.install_pkg(prompt_bufnr, true)
        end)
        map('i', '<cr>', function(prompt_bufnr)
          opts.install_pkg(prompt_bufnr, false)
        end)
        map('i', '<C-v>', function(prompt_bufnr)
          opts.install_pkg(prompt_bufnr, true)
        end)

        map('i', '<C-t>', nil)
        map('i', '<C-s>', nil)
        map('n', '<C-t>', nil)
        map('n', '<C-s>', nil)
        return true
      end,
    })
    :find()
end

return M
