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

