nnoremap <Leader>tW :Work<cr>
nnoremap <Leader>tb :Break<cr>
nnoremap <Leader>tt :ShowTimer<cr>
nnoremap <Leader>to :OpenTasks<cr>
nnoremap <Leader>tp :ToggleTimer<cr>
nnoremap <Leader>th :HideAndShowTimer<cr>
nnoremap <Leader>tu :UpdateCurrentTimer<space>
nnoremap <Leader>tU :UpdateCurrentStatus<space>

let g:tt_show_on_load = 1
let g:tt_taskfile = '~/tasks.md'

command! Work
\  call tt#set_timer(25)
\| call tt#start_timer()
\| call tt#set_status('working')
\| echo 'working'
\| call tt#when_done('AfterWork')
\| call s:tt_toggle_visibility(1)

command! AfterWork
  \  call tt#play_sound()
  \| call tt#open_tasks()
  \| echo 'after work'
  \| call s:tt_toggle_visibility(1)
  \| Break

command! WorkOnTask
  \  if tt#can_be_task(getline('.'))
  \|   call tt#set_task(getline('.'), line('.'))
  \|   execute 'Work'
  \|   echomsg "Current task: " . tt#get_task()
  \|   call tt#when_done('AfterWorkOnTask')
  \| endif

command! AfterWorkOnTask
  \  call tt#play_sound()
  \| call tt#open_tasks()
  \| call tt#mark_last_task()
  \| call s:tt_toggle_visibility(1)
  \| Break

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
  call tt#clear_task()
  call tt#when_done('AfterBreak')
endfunction

command! AfterBreak
  \  call tt#play_sound()
  \| call tt#set_status('ready')
  \| call tt#clear_timer()
  \| call s:tt_toggle_visibility(1)

command! ClearTimer
  \  call tt#clear_status()
  \| call tt#clear_task()
  \| call tt#clear_timer()
  \| call s:tt_toggle_visibility(0)

command! -range MarkTask <line1>,<line2>call tt#mark_task()
command! OpenTasks call tt#open_tasks() <Bar> call tt#focus_tasks()
command! ShowTimer echomsg tt#get_remaining_full_format() . " " . tt#get_status_formatted() . " " . tt#get_task()
command! ToggleTimer call tt#toggle_timer() | call s:tt_toggle_visibility(1)
command! HideAndShowTimer call s:tt_hideAndShowTimer()
command! -nargs=1 UpdateCurrentTimer call tt#set_timer(<f-args>)
command! -nargs=1 UpdateCurrentStatus call tt#set_status(<f-args>)


function! Should_tt_visible()
  if !exists('g:tt_show_on_load')
    return 0
  else
    return g:tt_show_on_load
  endif
endfunction

function! Is_tt_paused()
  return tt#get_remaining() != -1 && tt#is_running() ? 0 : tt#get_remaining() == -1 ? 0 : 1
endfunction

function! s:tt_toggle_visibility(bool)
  let g:tt_show_on_load = a:bool
endfunction

function s:tt_hideAndShowTimer()
  if g:tt_show_on_load
    call s:tt_toggle_visibility(0)
  else
    call s:tt_toggle_visibility(1)
  endif
endfunction

" function s:tt_after_toggle_timer()
"   if g:tt_show_on_load == 0
"     call s:tt_toggle_visibility(1)
"   endif
" endfunction


" augroup TtAirline
"   autocmd!
"   autocmd User TtTick call s:should_tt_update_tabline()
" augroup END
