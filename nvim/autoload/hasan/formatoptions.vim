function hasan#formatoptions#setup() abort
  setlocal formatoptions-=a " Auto formatting is BAD.
  setlocal formatoptions-=t " Don't auto format my code. I got linters for that.
  setlocal formatoptions+=c " In general, I like it when comments respect textwidth
  setlocal formatoptions+=q " Allow formatting comments w/ gq
  setlocal formatoptions-=o " O and o, don't continue comments
  setlocal formatoptions+=r " But do continue when pressing enter.
  setlocal formatoptions+=n " Indent past the formatlistpat, not underneath it.
  setlocal formatoptions+=j " Auto-remove comments if possible.
  setlocal formatoptions-=2 " I'm not in gradeschool anymore
endfunction
