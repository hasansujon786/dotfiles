if exists('b:current_syntax')
    finish
endif

syn match qfFileName /^[^│]*/ nextgroup=qfSeparatorLeft
syn match qfSeparatorLeft /│/ contained nextgroup=qfLineNr
syn match qfLineNr /[^│]*/ contained nextgroup=qfSeparatorRight
syn match qfSeparatorRight '│' contained nextgroup=qfError,qfWarning,qfInfo,qfNote
syn match qfError / E .*$/ contained
syn match qfWarning / W .*$/ contained
syn match qfInfo / I .*$/ contained
syn match qfNote / [NH] .*$/ contained

hi def link qfFileName Directory
hi def link qfSeparatorLeft qfSeparator
hi def link qfSeparatorRight qfSeparator
hi def link qfLineNr LineNr
hi def link qfError DiagnosticSignError
hi def link qfWarning DiagnosticSignWarn
hi def link qfInfo DiagnosticSignInfo
hi def link qfNote DiagnosticSignHint

let b:current_syntax = 'qf'
