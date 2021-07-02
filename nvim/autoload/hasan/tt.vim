let g:tt_taskfile = '~/tasks.md'

function! hasan#tt#is_tt_paused()
  return tt#get_remaining() != -1 && tt#is_running() ? 0 : tt#get_remaining() == -1 ? 0 : 1
endfunction
function! hasan#tt#msg()
  return tt#get_remaining_full_format().' '.tt#get_status_formatted()
endfunction

command! -bang Work call s:work(<bang>0)
function s:work(keep_task) abort
  let start_from_begin = 1
  if (tt#is_running() || hasan#tt#is_tt_paused())
    call _#echoWarn('>>> Cancel the current timer & start a new timer? <<<')
    let start_from_begin = confirm("", "&Yes\n&No", 2)
  endif

  if start_from_begin == 1
    if(!a:keep_task) | call tt#clear_task() | endif
    call tt#set_timer(25)
    call tt#start_timer()
    call tt#set_status('working')
    call tt#when_done('AfterWork')
    execute 'TimerShow'
  endif
endfunction

command! AfterWork Break

command! Break call Break()
function! Break()
  let l:count = tt#get_state('break-count', 0)
  if l:count >= 3
    call tt#set_timer(15)
    call tt#set_status('long break')
    call tt#set_state('break-count', 0)
  else
    call tt#set_timer(5)
    call tt#set_status('break')
    call tt#set_state('break-count', l:count + 1)
  endif
  call tt#start_timer()
  call tt#when_done('AfterBreak')
  lua require('notifier').alert({vim.fn['hasan#tt#msg']()}, {title = 'TaskTimer'})
endfunction

command! AfterBreak
  \  call tt#set_status('get ready')
  \| call tt#clear_timer()
  \| lua require('notifier').alert({'Break Ended ' .. vim.fn['tt#get_status_formatted']()}, {title = 'TaskTimer'})

command! TimerStop
  \  call tt#clear_status()
  \| call tt#clear_task()
  \| call tt#clear_timer()

command! TimerShow lua require('notifier').open({vim.fn['hasan#tt#msg']()}, {title = 'TaskTime'})

command! TimerToggle
      \ call tt#toggle_timer()

command! -nargs=1 UpdateCurrentTimer call tt#set_timer(<f-args>)
command! -nargs=1 UpdateCurrentStatus call tt#set_status(<f-args>)
command! -range MarkTask <line1>,<line2>call tt#mark_task()
command! OpenTasks call tt#open_tasks() <Bar> call tt#focus_tasks()

command! WorkOnTask
  \  if tt#can_be_task(getline('.'))
  \|   call tt#set_task(getline('.'), line('.'))
  \|   execute 'Work!'
  \|   call tt#when_done('AfterWorkOnTask')
  \| endif

command! AfterWorkOnTask
  \  call tt#open_tasks()
  \| call tt#mark_last_task()
  \| Break


" augroup TtAirline
"   autocmd!
"   autocmd User TtTick call s:should_tt_update_tabline()
" augroup END
