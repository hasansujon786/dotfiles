let g:tt_taskfile = '~/tasks.md'

function! hasan#tt#is_tt_paused()
  return tt#get_remaining() != -1 && tt#is_running() ? 0 : tt#get_remaining() == -1 ? 0 : 1
endfunction

command! Work
\  call tt#set_timer(25)
\| call tt#start_timer()
\| call tt#set_status('working')
\| call tt#when_done('AfterWork')
\| call notification#open(['TaskTimer:', 'Timer Started '. tt#get_status_formatted()])

command! AfterWork
      \ Break

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
  call notification#open(['TaskTimer:', 'Break Started '. tt#get_status_formatted()])
endfunction

command! AfterBreak
  \  call tt#set_status('get ready')
  \| call tt#clear_timer()
  \| call notification#open(['TaskTimer:', 'Break Ended '. tt#get_status_formatted()])

command! ClearTimer
  \  call tt#clear_status()
  \| call tt#clear_task()
  \| call tt#clear_timer()

command! ShowTimer
      \ call notification#open(['TaskTimer:',
      \ tt#get_remaining_full_format()." ".tt#get_status_formatted().tt#get_task()])

command! PauseOrPlayTimer
      \  if tt#is_running()
      \|   call notification#open(['TaskTimer:', 'Timer Paused '. tt#get_status_formatted()])
      \| else
      \|   call notification#open(['TaskTimer:', 'Timer is running '. tt#get_status_formatted()])
      \| endif
      \| call tt#toggle_timer()

command! -nargs=1 UpdateCurrentTimer call tt#set_timer(<f-args>)
command! -nargs=1 UpdateCurrentStatus call tt#set_status(<f-args>)
command! -range MarkTask <line1>,<line2>call tt#mark_task()
command! OpenTasks call tt#open_tasks() <Bar> call tt#focus_tasks()

command! WorkOnTask
  \  if tt#can_be_task(getline('.'))
  \|   call tt#set_task(getline('.'), line('.'))
  \|   execute 'Work'
  \|   echomsg "Current task: " . tt#get_task()
  \|   call tt#when_done('AfterWorkOnTask')
  \| endif

" @todo: work on this
command! AfterWorkOnTask
  \  call tt#play_sound()
  \| call tt#open_tasks()
  \| call tt#mark_last_task()
  \| Break


" augroup TtAirline
"   autocmd!
"   autocmd User TtTick call s:should_tt_update_tabline()
" augroup END
