augroup Nebulous
  au!
  " Change active/inactive window background
  au WinEnter,BufWinEnter * call nebulous#focus_window()
  au User NotifierNotificationLoaded,NeogitStatusRefreshed call nebulous#focus_window()
  au FocusLost * call nebulous#blur_current_window()
  au FocusGained * call nebulous#focus_current_window()
  au InsertEnter * call nebulous#pause()
  au FileType WhichKey call timer_start(0, function('nebulous#whichkey_hack'))
augroup END
