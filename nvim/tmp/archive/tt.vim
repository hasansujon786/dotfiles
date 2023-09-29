" { 'mkropat/vim-tt', lazy = true, event = 'CursorHold', config = function() vim.g.tt_loaded = 1 end },
" t = {
"   name = '+task-and-timer',
"   q = { '<cmd>TimerStop<CR>', 'Quit the timer' },
"   w = { '<cmd>Work<CR>', 'Start work timer' },
"   W = { '<cmd>Work!<CR>', 'Start custom timer' },
"   s = { '<cmd>TimerShow<CR>', 'Show timer status' },
"   p = { '<cmd>TimerToggle<CR>', 'Pause or Paly' },
"   b = { '<cmd>Break<CR>', 'Take a break' },
"   o = { '<cmd>OpenTasks<CR>', 'Open tasks' },
"   u = { '<cmd>UpdateCurrentTimer<CR>', 'Update current timer' },
"   U = { '<cmd>UpdateCurrentStatus<CR>', 'Update current status' },
" },
let g:tt_taskfile = '~/tasks.md'
let g:tt_default_time = 25

command! -bang Work call hasan#tt#work(<bang>0)
command! AfterWork Break
command! Break call hasan#tt#break()
command! AfterBreak
  \  call tt#set_status('')
  \| call tt#clear_timer()
  \| lua require('notifier').alert({'Break Ended ' .. vim.fn['tt#get_status_formatted']()}, {title = 'TaskTimer'})

command! TimerStop
  \  call tt#clear_status()
  \| call tt#clear_task()
  \| call tt#clear_timer()
command! TimerShow lua require('notifier').notify({vim.fn['hasan#tt#msg']()}, {title = 'TaskTime'})
command! TimerToggle call tt#toggle_timer()

command! UpdateCurrentTimer call hasan#tt#update_current_timer()
command! UpdateCurrentStatus call hasan#tt#update_current_status()



" command! -range MarkTask <line1>,<line2>call tt#mark_task()
" command! OpenTasks call tt#open_tasks() <Bar> call tt#focus_tasks()

" command! WorkOnTask
"   \  if tt#can_be_task(getline('.'))
"   \|   call tt#set_task(getline('.'), line('.'))
"   \|   execute 'Work!'
"   \|   call tt#when_done('AfterWorkOnTask')
"   \| endif

" command! AfterWorkOnTask
"   \  call tt#open_tasks()
"   \| call tt#mark_last_task()
"   \| Break

