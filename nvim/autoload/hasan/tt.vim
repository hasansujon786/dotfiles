function! hasan#tt#is_tt_paused()
  return tt#get_remaining() != -1 && tt#is_running() ? 0 : tt#get_remaining() == -1 ? 0 : 1
endfunction
function! hasan#tt#msg()
  return tt#get_remaining_full_format().' '.tt#get_status_formatted()
endfunction

function! hasan#tt#update_current_timer()
  let status = tt#get_status()
  let remaining_time = tt#get_remaining() > 60 ? (tt#get_remaining() / 60) + 1 : 1
  let new_time = input({'prompt':'Update '..status..' Timer> ','default': remaining_time})
  if new_time < 1 | return | endif
  call tt#set_timer(new_time)
endfunction

function! hasan#tt#update_current_status()
  let status = tt#get_status()
  let new_status = input({'prompt':'Update Status> ','default': status})
  if len(new_status) <= 2 | return | endif
  call tt#set_status(new_status)
endfunction


function! hasan#tt#work(custom_time) abort
  let start_from_begin = 1
  let work_time = get(g:, 'tt_default_time', 25)

  if a:custom_time
    let work_time = input({'prompt':'Set a time> ','default': work_time})
    if work_time < 1 | return | endif
  elseif (tt#is_running() || hasan#tt#is_tt_paused() && a:custom_time == 0)
    " call _#echoWarn('')
    let start_from_begin = confirm(">>> Cancel the current timer & start a new timer? <<<", "&Yes\n&No", 1)
    if start_from_begin == 2 || start_from_begin == 0 | return | endif
  endif

  call tt#clear_task()
  call tt#clear_timer()

  call tt#set_status('working')
  call tt#set_timer(work_time)
  call tt#start_timer()
  call tt#when_done('AfterWork')
  execute 'TimerShow'
endfunction

function! hasan#tt#break()
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
  " lua require('hasan.utils.timer').run()
endfunction

" augroup TtAirline
"   autocmd!
"   autocmd User TtTick call s:should_tt_update_tabline()
" augroup END

function! hasan#tt#statusline_status()
  if !exists('g:tt_loaded')
    return ''
  else
    try
      let icon = tt#get_status() =~ 'break' ? '' : ''
      let status = (!tt#is_running() && !hasan#tt#is_tt_paused() ? 'off' :
            \ hasan#tt#is_tt_paused() ? 'paused' :
            \ tt#get_remaining_smart_format())
      return icon.' '.status
    catch
      return ''
    endtry
  endif
endfunction

function! hasan#tt#format_abbrev_duration(duration)
  let l:hours = a:duration / 60 / 60
  let l:minutes = a:duration / 60 % 60
  let l:seconds = a:duration % 60

  if a:duration <= 60
    return printf('%d:%02d', l:minutes, l:seconds)
  elseif l:hours > 0
    let l:displayed_hours = l:hours
    if l:minutes > 0 || l:seconds > 0
      let l:displayed_hours += 1
    endif
    return printf('%dh', l:displayed_hours)
  else
    let l:displayed_minutes = l:minutes
    if l:seconds > 0
      let l:displayed_minutes += 1
    endif
    return printf('%dm', l:displayed_minutes)
  endif
endfunction


