augroup Nebulous
  au!
  " Change active/inactive window background
  au FocusGained,WinEnter,BufWinEnter * call nebulous#focus_window()
  au FocusLost * call nebulous#blur_current_window()
  au FileType Whichkey call timer_start(0, function('nebulous#whichkey_hack'))
augroup END
