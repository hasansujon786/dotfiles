" augroup colorextend
"   autocmd!
"   autocmd ColorScheme * call onedark#extend_highlight("FoldColumn", { "fg": { "gui": "#4b5263" } })
" augroup END

call s:h("jsThis", { "fg": s:dark_yellow })
call s:h("jsVariableDef", { "fg": s:dark_yellow })
" call s:h("jsModuleKeyword", { "fg": s:red })
call s:h("jsObjectKey", { "fg": s:red })
call s:h("jsObjectValue", { "fg": s:red })
call s:h("jsObjectProp", { "fg": s:red })
call s:h("jsDestructuringAssignment", {"fg": s:dark_red})

call s:h("jsBracket", {"fg": s:red})
call s:h("jsParen", {"fg": s:red})
call s:h("jsParenDecorator", {"fg": s:red})
call s:h("jsParenIfElse", {"fg": s:red})
call s:h("jsParenRepeat", {"fg": s:red})
call s:h("jsParenSwitch", {"fg": s:red})
call s:h("jsParenCatch", {"fg": s:red})
call s:h("jsFuncArgs", {"fg": s:red})
call s:h("jsClassBlock", {"fg": s:red})
call s:h("jsFuncBlock", {"fg": s:red})
call s:h("jsIfElseBlock", {"fg": s:red})
call s:h("jsTryCatchBlock", {"fg": s:red})
call s:h("jsFinallyBlock", {"fg": s:red})
call s:h("jsSwitchBlock", {"fg": s:red})
call s:h("jsRepeatBlock", {"fg": s:red})
call s:h("jsDestructuringBlock", {"fg": s:red})
call s:h("jsDestructuringArray", {"fg": s:red})
call s:h("jsObject", {"fg": s:red})
call s:h("jsBlock", {"fg": s:red})
call s:h("jsModuleGroup", {"fg": s:red})
call s:h("jsSpreadExpression", {"fg": s:red})
call s:h("jsRestExpression", {"fg": s:yellow})
call s:h("jsTernaryIf", {"fg": s:red})



" {
"   'green': {'gui': '#98C379', 'cterm': '114', 'cterm16': '2'},
"   'visual_black': {'gui': 'NONE', 'cterm': 'NONE', 'cterm16': '0'},
"   'yellow': {'gui': '#E5C07B', 'cterm': '180', 'cterm16': '3'},
"   'comment_grey': {'gui': '#5C6370', 'cterm': '59', 'cterm16': '15'},
"   'red': {'gui': '#E06C75', 'cterm': '204', 'cterm16': '1'},
"   'special_grey': {'gui': '#3B4048', 'cterm': '238', 'cterm16': '15'},
"   'gutter_fg_grey': {'gui': '#4B5263', 'cterm': '238', 'cterm16': '15'},
"   'visual_grey': {'gui': '#3E4452', 'cterm': '237', 'cterm16': '15'},
"   'cursor_grey': {'gui': '#2C323C', 'cterm': '236', 'cterm16': '8'},
"   'dark_yellow': {'gui': '#D19A66', 'cterm': '173', 'cterm16': '11'},
"   'blue': {'gui': '#61AFEF', 'cterm': '39', 'cterm16': '4'},
"   'purple': {'gui': '#C678DD', 'cterm': '170', 'cterm16': '5'},
"   'black': {'gui': '#282C34', 'cterm': '235', 'cterm16': '0'},
"   'menu_grey': {'gui': '#3E4452', 'cterm': '237', 'cterm16': '8'},
"   'dark_red': {'gui': '#BE5046', 'cterm': '196', 'cterm16': '9'},
"   'white': {'gui': '#ABB2BF', 'cterm': '145', 'cterm16': '7'},
"   'cyan': {'gui': '#56B6C2', 'cterm': '38', 'cterm16': '6'},
"   'vertsplit': {'gui': '#181A1F', 'cterm': '59', 'cterm16': '15'}
" }

" SpecialKey     xxx ctermfg=238 guifg=#3B4048
" EndOfBuffer    xxx links to NonText
" TermCursor     xxx cterm=reverse gui=reverse
" TermCursorNC   xxx cleared
" NonText        xxx ctermfg=238 guifg=#3B4048
" Directory      xxx ctermfg=39 guifg=#61AFEF
" ErrorMsg       xxx ctermfg=204 guifg=#E06C75
" IncSearch      xxx ctermfg=180 ctermbg=59 guifg=#E5C07B guibg=#5C6370
" Search         xxx ctermfg=235 ctermbg=180 guifg=#282C34 guibg=#E5C07B
" MoreMsg        xxx cleared
" ModeMsg        xxx cleared
" LineNr         xxx ctermfg=238 guifg=#4B5263
" CursorLineNr   xxx cleared
" Question       xxx ctermfg=170 guifg=#C678DD
" StatusLine     xxx ctermfg=145 ctermbg=236 guifg=#ABB2BF guibg=#2C323C
" StatusLineNC   xxx ctermfg=59 guifg=#5C6370
" VertSplit      xxx ctermfg=59 guifg=#181A1F
" Title          xxx ctermfg=114 guifg=#98C379
" Visual         xxx ctermbg=237 guibg=#3E4452
" VisualNC       xxx cleared
" WarningMsg     xxx ctermfg=180 guifg=#E5C07B
" WildMenu       xxx ctermfg=235 ctermbg=39 guifg=#282C34 guibg=#61AFEF
" Folded         xxx ctermfg=59 guifg=#5C6370
" FoldColumn     xxx cleared
" DiffAdd        xxx ctermfg=235 ctermbg=114 guifg=#282C34 guibg=#98C379
" DiffChange     xxx cterm=underline ctermfg=180 gui=underline guifg=#E5C07B
" DiffDelete     xxx ctermfg=235 ctermbg=204 guifg=#282C34 guibg=#E06C75
" DiffText       xxx ctermfg=235 ctermbg=180 guifg=#282C34 guibg=#E5C07B
" SignColumn     xxx cleared
" Conceal        xxx ctermfg=239 guifg=#3B4048
" SpellBad       xxx cterm=underline ctermfg=204 gui=underline guifg=#E06C75
" SpellCap       xxx ctermfg=173 guifg=#D19A66
" SpellRare      xxx ctermfg=173 guifg=#D19A66
" SpellLocal     xxx ctermfg=173 guifg=#D19A66
" Pmenu          xxx ctermbg=237 guibg=#3E4452
" PmenuSel       xxx ctermfg=235 ctermbg=39 guifg=#282C34 guibg=#61AFEF
" PmenuSbar      xxx ctermbg=238 guibg=#3B4048
" PmenuThumb     xxx ctermbg=145 guibg=#ABB2BF
" TabLine        xxx ctermfg=59 guifg=#5C6370
" TabLineSel     xxx ctermfg=145 guifg=#ABB2BF
" TabLineFill    xxx cleared
" CursorColumn   xxx ctermbg=236 guibg=#2C323C
" CursorLine     xxx ctermbg=236 guibg=#2C323C
" ColorColumn    xxx ctermfg=15 ctermbg=248 guifg=#282C34 guibg=magenta
" QuickFixLine   xxx ctermfg=235 ctermbg=180 guifg=#282C34 guibg=#E5C07B
" Whitespace     xxx links to NonText
" NormalNC       xxx cleared
" MsgSeparator   xxx links to StatusLine
" NormalFloat    xxx links to Pmenu
" MsgArea        xxx cleared
" RedrawDebugNormal xxx cterm=reverse gui=reverse
" RedrawDebugClear xxx ctermbg=11 guibg=Yellow
" RedrawDebugComposed xxx ctermbg=10 guibg=Green
" RedrawDebugRecompose xxx ctermbg=9 guibg=Red
" lCursor        xxx guifg=bg guibg=fg
" Substitute     xxx links to Search
" MatchParen     xxx cterm=underline ctermfg=39 gui=underline guifg=#61AFEF
" Normal         xxx ctermfg=145 ctermbg=235 guifg=#ABB2BF guibg=#282C34
" NvimInternalError xxx ctermfg=9 ctermbg=9 guifg=Red guibg=Red
" NvimAssignment xxx links to Operator
" Operator       xxx ctermfg=170 guifg=#C678DD
" NvimPlainAssignment xxx links to NvimAssignment
" NvimAugmentedAssignment xxx links to NvimAssignment
" NvimAssignmentWithAddition xxx links to NvimAugmentedAssignment
" NvimAssignmentWithSubtraction xxx links to NvimAugmentedAssignment
" NvimAssignmentWithConcatenation xxx links to NvimAugmentedAssignment
" NvimOperator   xxx links to Operator
" NvimUnaryOperator xxx links to NvimOperator
" NvimUnaryPlus  xxx links to NvimUnaryOperator
" NvimUnaryMinus xxx links to NvimUnaryOperator
" NvimNot        xxx links to NvimUnaryOperator
" NvimBinaryOperator xxx links to NvimOperator
" NvimComparison xxx links to NvimBinaryOperator
" NvimComparisonModifier xxx links to NvimComparison
" NvimBinaryPlus xxx links to NvimBinaryOperator
" NvimBinaryMinus xxx links to NvimBinaryOperator
" NvimConcat     xxx links to NvimBinaryOperator
" NvimConcatOrSubscript xxx links to NvimConcat
" NvimOr         xxx links to NvimBinaryOperator
" NvimAnd        xxx links to NvimBinaryOperator
" NvimMultiplication xxx links to NvimBinaryOperator
" NvimDivision   xxx links to NvimBinaryOperator
" NvimMod        xxx links to NvimBinaryOperator
" NvimTernary    xxx links to NvimOperator
" NvimTernaryColon xxx links to NvimTernary
" NvimParenthesis xxx links to Delimiter
" Delimiter      xxx cleared
" NvimLambda     xxx links to NvimParenthesis
" NvimNestingParenthesis xxx links to NvimParenthesis
" NvimCallingParenthesis xxx links to NvimParenthesis
" NvimSubscript  xxx links to NvimParenthesis
" NvimSubscriptBracket xxx links to NvimSubscript
" NvimSubscriptColon xxx links to NvimSubscript
" NvimCurly      xxx links to NvimSubscript
" NvimContainer  xxx links to NvimParenthesis
" NvimDict       xxx links to NvimContainer
" NvimList       xxx links to NvimContainer
" NvimIdentifier xxx links to Identifier
" Identifier     xxx ctermfg=204 guifg=#E06C75
" NvimIdentifierScope xxx links to NvimIdentifier
" NvimIdentifierScopeDelimiter xxx links to NvimIdentifier
" NvimIdentifierName xxx links to NvimIdentifier
" NvimIdentifierKey xxx links to NvimIdentifier
" NvimColon      xxx links to Delimiter
" NvimComma      xxx links to Delimiter
" NvimArrow      xxx links to Delimiter
" NvimRegister   xxx links to SpecialChar
" SpecialChar    xxx cleared
" NvimNumber     xxx links to Number
" Number         xxx ctermfg=173 guifg=#D19A66
" NvimFloat      xxx links to NvimNumber
" NvimNumberPrefix xxx links to Type
" Type           xxx ctermfg=180 guifg=#E5C07B
" NvimOptionSigil xxx links to Type
" NvimOptionName xxx links to NvimIdentifier
" NvimOptionScope xxx links to NvimIdentifierScope
" NvimOptionScopeDelimiter xxx links to NvimIdentifierScopeDelimiter
" NvimEnvironmentSigil xxx links to NvimOptionSigil
" NvimEnvironmentName xxx links to NvimIdentifier
" NvimString     xxx links to String
" String         xxx ctermfg=114 guifg=#98C379
" NvimStringBody xxx links to NvimString
" NvimStringQuote xxx links to NvimString
" NvimStringSpecial xxx links to SpecialChar
" NvimSingleQuote xxx links to NvimStringQuote
" NvimSingleQuotedBody xxx links to NvimStringBody
" NvimSingleQuotedQuote xxx links to NvimStringSpecial
" NvimDoubleQuote xxx links to NvimStringQuote
" NvimDoubleQuotedBody xxx links to NvimStringBody
" NvimDoubleQuotedEscape xxx links to NvimStringSpecial
" NvimFigureBrace xxx links to NvimInternalError
" NvimSingleQuotedUnknownEscape xxx links to NvimInternalError
" NvimSpacing    xxx links to Normal
" NvimInvalidSingleQuotedUnknownEscape xxx links to NvimInternalError
" NvimInvalid    xxx links to Error
" Error          xxx ctermfg=204 guifg=#E06C75
" NvimInvalidAssignment xxx links to NvimInvalid
" NvimInvalidPlainAssignment xxx links to NvimInvalidAssignment
" NvimInvalidAugmentedAssignment xxx links to NvimInvalidAssignment
" NvimInvalidAssignmentWithAddition xxx links to NvimInvalidAugmentedAssignment
" NvimInvalidAssignmentWithSubtraction xxx links to NvimInvalidAugmentedAssignment
" NvimInvalidAssignmentWithConcatenation xxx links to NvimInvalidAugmentedAssignment
" NvimInvalidOperator xxx links to NvimInvalid
" NvimInvalidUnaryOperator xxx links to NvimInvalidOperator
" NvimInvalidUnaryPlus xxx links to NvimInvalidUnaryOperator
" NvimInvalidUnaryMinus xxx links to NvimInvalidUnaryOperator
" NvimInvalidNot xxx links to NvimInvalidUnaryOperator
" NvimInvalidBinaryOperator xxx links to NvimInvalidOperator
" NvimInvalidComparison xxx links to NvimInvalidBinaryOperator
" NvimInvalidComparisonModifier xxx links to NvimInvalidComparison
" NvimInvalidBinaryPlus xxx links to NvimInvalidBinaryOperator
" NvimInvalidBinaryMinus xxx links to NvimInvalidBinaryOperator
" NvimInvalidConcat xxx links to NvimInvalidBinaryOperator
" NvimInvalidConcatOrSubscript xxx links to NvimInvalidConcat
" NvimInvalidOr  xxx links to NvimInvalidBinaryOperator
" NvimInvalidAnd xxx links to NvimInvalidBinaryOperator
" NvimInvalidMultiplication xxx links to NvimInvalidBinaryOperator
" NvimInvalidDivision xxx links to NvimInvalidBinaryOperator
" NvimInvalidMod xxx links to NvimInvalidBinaryOperator
" NvimInvalidTernary xxx links to NvimInvalidOperator
" NvimInvalidTernaryColon xxx links to NvimInvalidTernary
" NvimInvalidDelimiter xxx links to NvimInvalid
" NvimInvalidParenthesis xxx links to NvimInvalidDelimiter
" NvimInvalidLambda xxx links to NvimInvalidParenthesis
" NvimInvalidNestingParenthesis xxx links to NvimInvalidParenthesis
" NvimInvalidCallingParenthesis xxx links to NvimInvalidParenthesis
" NvimInvalidSubscript xxx links to NvimInvalidParenthesis
" NvimInvalidSubscriptBracket xxx links to NvimInvalidSubscript
" NvimInvalidSubscriptColon xxx links to NvimInvalidSubscript
" NvimInvalidCurly xxx links to NvimInvalidSubscript
" NvimInvalidContainer xxx links to NvimInvalidParenthesis
" NvimInvalidDict xxx links to NvimInvalidContainer
" NvimInvalidList xxx links to NvimInvalidContainer
" NvimInvalidValue xxx links to NvimInvalid
" NvimInvalidIdentifier xxx links to NvimInvalidValue
" NvimInvalidIdentifierScope xxx links to NvimInvalidIdentifier
" NvimInvalidIdentifierScopeDelimiter xxx links to NvimInvalidIdentifier
" NvimInvalidIdentifierName xxx links to NvimInvalidIdentifier
" NvimInvalidIdentifierKey xxx links to NvimInvalidIdentifier
" NvimInvalidColon xxx links to NvimInvalidDelimiter
" NvimInvalidComma xxx links to NvimInvalidDelimiter
" NvimInvalidArrow xxx links to NvimInvalidDelimiter
" NvimInvalidRegister xxx links to NvimInvalidValue
" NvimInvalidNumber xxx links to NvimInvalidValue
" NvimInvalidFloat xxx links to NvimInvalidNumber
" NvimInvalidNumberPrefix xxx links to NvimInvalidNumber
" NvimInvalidOptionSigil xxx links to NvimInvalidIdentifier
" NvimInvalidOptionName xxx links to NvimInvalidIdentifier
" NvimInvalidOptionScope xxx links to NvimInvalidIdentifierScope
" NvimInvalidOptionScopeDelimiter xxx links to NvimInvalidIdentifierScopeDelimiter
" NvimInvalidEnvironmentSigil xxx links to NvimInvalidOptionSigil
" NvimInvalidEnvironmentName xxx links to NvimInvalidIdentifier
" NvimInvalidString xxx links to NvimInvalidValue
" NvimInvalidStringBody xxx links to NvimStringBody
" NvimInvalidStringQuote xxx links to NvimInvalidString
" NvimInvalidStringSpecial xxx links to NvimStringSpecial
" NvimInvalidSingleQuote xxx links to NvimInvalidStringQuote
" NvimInvalidSingleQuotedBody xxx links to NvimInvalidStringBody
" NvimInvalidSingleQuotedQuote xxx links to NvimInvalidStringSpecial
" NvimInvalidDoubleQuote xxx links to NvimInvalidStringQuote
" NvimInvalidDoubleQuotedBody xxx links to NvimInvalidStringBody
" NvimInvalidDoubleQuotedEscape xxx links to NvimInvalidStringSpecial
" NvimInvalidDoubleQuotedUnknownEscape xxx links to NvimInvalidValue
" NvimInvalidFigureBrace xxx links to NvimInvalidDelimiter
" NvimInvalidSpacing xxx links to ErrorMsg
" NvimDoubleQuotedUnknownEscape xxx links to NvimInvalidValue
" Comment        xxx cterm=italic ctermfg=59 gui=italic guifg=#5C6370
" Constant       xxx ctermfg=38 guifg=#56B6C2
" Special        xxx ctermfg=39 guifg=#61AFEF
" Statement      xxx ctermfg=170 guifg=#C678DD
" PreProc        xxx ctermfg=180 guifg=#E5C07B
" Underlined     xxx cterm=underline gui=underline
" Ignore         xxx cleared
" Todo           xxx ctermfg=170 guifg=#C678DD
" Character      xxx ctermfg=114 guifg=#98C379
" Boolean        xxx ctermfg=173 guifg=#D19A66
" Float          xxx ctermfg=173 guifg=#D19A66
" Function       xxx ctermfg=39 guifg=#61AFEF
" Conditional    xxx ctermfg=170 guifg=#C678DD
" Repeat         xxx ctermfg=170 guifg=#C678DD
" Label          xxx ctermfg=170 guifg=#C678DD
" Keyword        xxx ctermfg=204 guifg=#E06C75
" Exception      xxx ctermfg=170 guifg=#C678DD
" Include        xxx ctermfg=39 guifg=#61AFEF
" Define         xxx ctermfg=170 guifg=#C678DD
" Macro          xxx ctermfg=170 guifg=#C678DD
" PreCondit      xxx ctermfg=180 guifg=#E5C07B
" StorageClass   xxx ctermfg=180 guifg=#E5C07B
" Structure      xxx ctermfg=180 guifg=#E5C07B
" Typedef        xxx ctermfg=180 guifg=#E5C07B
" Tag            xxx cleared
" SpecialComment xxx ctermfg=59 guifg=#5C6370
" Debug          xxx cleared
" CursorIM       xxx cleared
" StatusLineTerm xxx ctermfg=145 ctermbg=236 guifg=#ABB2BF guibg=#2C323C
" StatusLineTermNC xxx ctermfg=59 guifg=#5C6370
" Terminal       xxx ctermfg=145 ctermbg=235 guifg=#ABB2BF guibg=#282C34
" VisualNOS      xxx ctermbg=237 guibg=#3E4452
" debugPC        xxx ctermbg=238 guibg=#3B4048
" debugBreakpoint xxx ctermfg=235 ctermbg=204 guifg=#282C34 guibg=#E06C75
" cssAttrComma   xxx ctermfg=170 guifg=#C678DD
" cssAttributeSelector xxx ctermfg=114 guifg=#98C379
" cssBraces      xxx ctermfg=145 guifg=#ABB2BF
" cssClassName   xxx ctermfg=173 guifg=#D19A66
" cssClassNameDot xxx ctermfg=173 guifg=#D19A66
" cssDefinition  xxx ctermfg=170 guifg=#C678DD
" cssFontAttr    xxx ctermfg=173 guifg=#D19A66
" cssFontDescriptor xxx ctermfg=170 guifg=#C678DD
" cssFunctionName xxx ctermfg=39 guifg=#61AFEF
" cssIdentifier  xxx ctermfg=39 guifg=#61AFEF
" cssImportant   xxx ctermfg=170 guifg=#C678DD
" cssInclude     xxx ctermfg=145 guifg=#ABB2BF
" cssIncludeKeyword xxx ctermfg=170 guifg=#C678DD
" cssMediaType   xxx ctermfg=173 guifg=#D19A66
" cssProp        xxx ctermfg=145 guifg=#ABB2BF
" cssPseudoClassId xxx ctermfg=173 guifg=#D19A66
" cssSelectorOp  xxx ctermfg=170 guifg=#C678DD
" cssSelectorOp2 xxx ctermfg=170 guifg=#C678DD
" cssTagName     xxx ctermfg=204 guifg=#E06C75
" fishKeyword    xxx ctermfg=170 guifg=#C678DD
" fishConditional xxx ctermfg=170 guifg=#C678DD
" goDeclaration  xxx ctermfg=170 guifg=#C678DD
" goBuiltins     xxx ctermfg=38 guifg=#56B6C2
" goFunctionCall xxx ctermfg=39 guifg=#61AFEF
" goVarDefs      xxx ctermfg=204 guifg=#E06C75
" goVarAssign    xxx ctermfg=204 guifg=#E06C75
" goVar          xxx ctermfg=170 guifg=#C678DD
" goConst        xxx ctermfg=170 guifg=#C678DD
" goType         xxx ctermfg=180 guifg=#E5C07B
" goTypeName     xxx ctermfg=180 guifg=#E5C07B
" goDeclType     xxx ctermfg=38 guifg=#56B6C2
" goTypeDecl     xxx ctermfg=170 guifg=#C678DD
" htmlArg        xxx ctermfg=173 guifg=#D19A66
" htmlBold       xxx cterm=bold ctermfg=173 gui=bold guifg=#D19A66
" htmlEndTag     xxx ctermfg=145 guifg=#ABB2BF
" htmlH1         xxx ctermfg=204 guifg=#E06C75
" htmlH2         xxx ctermfg=204 guifg=#E06C75
" htmlH3         xxx ctermfg=204 guifg=#E06C75
" htmlH4         xxx ctermfg=204 guifg=#E06C75
" htmlH5         xxx ctermfg=204 guifg=#E06C75
" htmlH6         xxx ctermfg=204 guifg=#E06C75
" htmlItalic     xxx cterm=italic ctermfg=170 gui=italic guifg=#C678DD
" htmlLink       xxx cterm=underline ctermfg=38 gui=underline guifg=#56B6C2
" htmlSpecialChar xxx ctermfg=173 guifg=#D19A66
" htmlSpecialTagName xxx ctermfg=204 guifg=#E06C75
" htmlTag        xxx ctermfg=145 guifg=#ABB2BF
" htmlTagN       xxx ctermfg=204 guifg=#E06C75
" htmlTagName    xxx ctermfg=204 guifg=#E06C75
" htmlTitle      xxx ctermfg=145 guifg=#ABB2BF
" javaScriptBraces xxx ctermfg=145 guifg=#ABB2BF
" javaScriptFunction xxx ctermfg=170 guifg=#C678DD
" javaScriptIdentifier xxx ctermfg=204 guifg=#E06C75
" javaScriptNull xxx ctermfg=173 guifg=#D19A66
" javaScriptNumber xxx ctermfg=173 guifg=#D19A66
" javaScriptRequire xxx ctermfg=38 guifg=#56B6C2
" javaScriptReserved xxx ctermfg=170 guifg=#C678DD
" jsArrowFunction xxx ctermfg=170 guifg=#C678DD
" jsClassKeyword xxx ctermfg=170 guifg=#C678DD
" jsClassMethodType xxx ctermfg=170 guifg=#C678DD
" jsDocParam     xxx ctermfg=39 guifg=#61AFEF
" jsDocTags      xxx ctermfg=170 guifg=#C678DD
" jsExport       xxx ctermfg=170 guifg=#C678DD
" jsExportDefault xxx ctermfg=170 guifg=#C678DD
" jsExtendsKeyword xxx ctermfg=170 guifg=#C678DD
" jsFrom         xxx ctermfg=170 guifg=#C678DD
" jsFuncCall     xxx ctermfg=39 guifg=#61AFEF
" jsFunction     xxx ctermfg=170 guifg=#C678DD
" jsGenerator    xxx ctermfg=180 guifg=#E5C07B
" jsGlobalObjects xxx ctermfg=180 guifg=#E5C07B
" jsImport       xxx ctermfg=170 guifg=#C678DD
" jsModuleAs     xxx ctermfg=170 guifg=#C678DD
" jsModuleWords  xxx ctermfg=170 guifg=#C678DD
" jsModules      xxx ctermfg=170 guifg=#C678DD
" jsNull         xxx ctermfg=173 guifg=#D19A66
" jsOperator     xxx ctermfg=170 guifg=#C678DD
" jsStorageClass xxx ctermfg=170 guifg=#C678DD
" jsSuper        xxx ctermfg=204 guifg=#E06C75
" jsTemplateBraces xxx ctermfg=196 guifg=#BE5046
" jsTemplateVar  xxx ctermfg=114 guifg=#98C379
" jsThis         xxx ctermfg=204 guifg=#E06C75
" jsUndefined    xxx ctermfg=173 guifg=#D19A66
" javascriptArrowFunc xxx ctermfg=170 guifg=#C678DD
" javascriptClassExtends xxx ctermfg=170 guifg=#C678DD
" javascriptClassKeyword xxx ctermfg=170 guifg=#C678DD
" javascriptDocNotation xxx ctermfg=170 guifg=#C678DD
" javascriptDocParamName xxx ctermfg=39 guifg=#61AFEF
" javascriptDocTags xxx ctermfg=170 guifg=#C678DD
" javascriptEndColons xxx ctermfg=145 guifg=#ABB2BF
" javascriptExport xxx ctermfg=170 guifg=#C678DD
" javascriptFuncArg xxx ctermfg=145 guifg=#ABB2BF
" javascriptFuncKeyword xxx ctermfg=170 guifg=#C678DD
" javascriptImport xxx ctermfg=170 guifg=#C678DD
" javascriptMethodName xxx ctermfg=145 guifg=#ABB2BF
" javascriptObjectLabel xxx ctermfg=145 guifg=#ABB2BF
" javascriptOpSymbol xxx ctermfg=38 guifg=#56B6C2
" javascriptOpSymbols xxx ctermfg=38 guifg=#56B6C2
" javascriptPropertyName xxx ctermfg=114 guifg=#98C379
" javascriptTemplateSB xxx ctermfg=196 guifg=#BE5046
" javascriptVariable xxx ctermfg=170 guifg=#C678DD
" jsonCommentError xxx ctermfg=145 guifg=#ABB2BF
" jsonKeyword    xxx ctermfg=204 guifg=#E06C75
" jsonBoolean    xxx ctermfg=173 guifg=#D19A66
" jsonNumber     xxx ctermfg=173 guifg=#D19A66
" jsonQuote      xxx ctermfg=145 guifg=#ABB2BF
" jsonMissingCommaError xxx ctermfg=204 gui=reverse guifg=#E06C75
" jsonNoQuotesError xxx ctermfg=204 gui=reverse guifg=#E06C75
" jsonNumError   xxx ctermfg=204 gui=reverse guifg=#E06C75
" jsonString     xxx ctermfg=114 guifg=#98C379
" jsonStringSQError xxx ctermfg=204 gui=reverse guifg=#E06C75
" jsonSemicolonError xxx ctermfg=204 gui=reverse guifg=#E06C75
" lessVariable   xxx ctermfg=170 guifg=#C678DD
" lessAmpersandChar xxx ctermfg=145 guifg=#ABB2BF
" lessClass      xxx ctermfg=173 guifg=#D19A66
" markdownBlockquote xxx ctermfg=59 guifg=#5C6370
" markdownBold   xxx cterm=bold ctermfg=173 gui=bold guifg=#D19A66
" markdownCode   xxx ctermfg=114 guifg=#98C379
" markdownCodeBlock xxx ctermfg=114 guifg=#98C379
" markdownCodeDelimiter xxx ctermfg=114 guifg=#98C379
" markdownH1     xxx ctermfg=204 guifg=#E06C75
" markdownH2     xxx ctermfg=204 guifg=#E06C75
" markdownH3     xxx ctermfg=204 guifg=#E06C75
" markdownH4     xxx ctermfg=204 guifg=#E06C75
" markdownH5     xxx ctermfg=204 guifg=#E06C75
" markdownH6     xxx ctermfg=204 guifg=#E06C75
" markdownHeadingDelimiter xxx ctermfg=204 guifg=#E06C75
" markdownHeadingRule xxx ctermfg=59 guifg=#5C6370
" markdownId     xxx ctermfg=170 guifg=#C678DD
" markdownIdDeclaration xxx ctermfg=39 guifg=#61AFEF
" markdownIdDelimiter xxx ctermfg=170 guifg=#C678DD
" markdownItalic xxx cterm=italic ctermfg=170 gui=italic guifg=#C678DD
" markdownLinkDelimiter xxx ctermfg=170 guifg=#C678DD
" markdownLinkText xxx ctermfg=39 guifg=#61AFEF
" markdownListMarker xxx ctermfg=204 guifg=#E06C75
" markdownOrderedListMarker xxx ctermfg=204 guifg=#E06C75
" markdownRule   xxx ctermfg=59 guifg=#5C6370
" markdownUrl    xxx cterm=underline ctermfg=38 gui=underline guifg=#56B6C2
" perlFiledescRead xxx ctermfg=114 guifg=#98C379
" perlFunction   xxx ctermfg=170 guifg=#C678DD
" perlMatchStartEnd xxx ctermfg=39 guifg=#61AFEF
" perlMethod     xxx ctermfg=170 guifg=#C678DD
" perlPOD        xxx ctermfg=59 guifg=#5C6370
" perlSharpBang  xxx ctermfg=59 guifg=#5C6370
" perlSpecialString xxx ctermfg=38 guifg=#56B6C2
" perlStatementFiledesc xxx ctermfg=204 guifg=#E06C75
" perlStatementFlow xxx ctermfg=204 guifg=#E06C75
" perlStatementInclude xxx ctermfg=170 guifg=#C678DD
" perlStatementScalar xxx ctermfg=170 guifg=#C678DD
" perlStatementStorage xxx ctermfg=170 guifg=#C678DD
" perlSubName    xxx ctermfg=180 guifg=#E5C07B
" perlVarPlain   xxx ctermfg=39 guifg=#61AFEF
" phpVarSelector xxx ctermfg=204 guifg=#E06C75
" phpOperator    xxx ctermfg=145 guifg=#ABB2BF
" phpParent      xxx ctermfg=145 guifg=#ABB2BF
" phpMemberSelector xxx ctermfg=145 guifg=#ABB2BF
" phpType        xxx ctermfg=170 guifg=#C678DD
" phpKeyword     xxx ctermfg=170 guifg=#C678DD
" phpClass       xxx ctermfg=180 guifg=#E5C07B
" phpUseClass    xxx ctermfg=145 guifg=#ABB2BF
" phpUseAlias    xxx ctermfg=145 guifg=#ABB2BF
" phpInclude     xxx ctermfg=170 guifg=#C678DD
" phpClassExtends xxx ctermfg=114 guifg=#98C379
" phpDocTags     xxx ctermfg=145 guifg=#ABB2BF
" phpFunction    xxx ctermfg=39 guifg=#61AFEF
" phpFunctions   xxx ctermfg=38 guifg=#56B6C2
" phpMethodsVar  xxx ctermfg=173 guifg=#D19A66
" phpMagicConstants xxx ctermfg=173 guifg=#D19A66
" phpSuperglobals xxx ctermfg=204 guifg=#E06C75
" phpConstants   xxx ctermfg=173 guifg=#D19A66
" rubyBlockParameter xxx ctermfg=204 guifg=#E06C75
" rubyBlockParameterList xxx ctermfg=204 guifg=#E06C75
" rubyClass      xxx ctermfg=170 guifg=#C678DD
" rubyConstant   xxx ctermfg=180 guifg=#E5C07B
" rubyControl    xxx ctermfg=170 guifg=#C678DD
" rubyEscape     xxx ctermfg=204 guifg=#E06C75
" rubyFunction   xxx ctermfg=39 guifg=#61AFEF
" rubyGlobalVariable xxx ctermfg=204 guifg=#E06C75
" rubyInclude    xxx ctermfg=39 guifg=#61AFEF
" rubyIncluderubyGlobalVariable xxx ctermfg=204 guifg=#E06C75
" rubyInstanceVariable xxx ctermfg=204 guifg=#E06C75
" rubyInterpolation xxx ctermfg=38 guifg=#56B6C2
" rubyInterpolationDelimiter xxx ctermfg=204 guifg=#E06C75
" rubyRegexp     xxx ctermfg=38 guifg=#56B6C2
" rubyRegexpDelimiter xxx ctermfg=38 guifg=#56B6C2
" rubyStringDelimiter xxx ctermfg=114 guifg=#98C379
" rubySymbol     xxx ctermfg=38 guifg=#56B6C2
" sassAmpersand  xxx ctermfg=204 guifg=#E06C75
" sassClass      xxx ctermfg=173 guifg=#D19A66
" sassControl    xxx ctermfg=170 guifg=#C678DD
" sassExtend     xxx ctermfg=170 guifg=#C678DD
" sassFor        xxx ctermfg=145 guifg=#ABB2BF
" sassFunction   xxx ctermfg=38 guifg=#56B6C2
" sassId         xxx ctermfg=39 guifg=#61AFEF
" sassInclude    xxx ctermfg=170 guifg=#C678DD
" sassMedia      xxx ctermfg=170 guifg=#C678DD
" sassMediaOperators xxx ctermfg=145 guifg=#ABB2BF
" sassMixin      xxx ctermfg=170 guifg=#C678DD
" sassMixinName  xxx ctermfg=39 guifg=#61AFEF
" sassMixing     xxx ctermfg=170 guifg=#C678DD
" sassVariable   xxx ctermfg=170 guifg=#C678DD
" scssExtend     xxx ctermfg=170 guifg=#C678DD
" scssImport     xxx ctermfg=170 guifg=#C678DD
" scssInclude    xxx ctermfg=170 guifg=#C678DD
" scssMixin      xxx ctermfg=170 guifg=#C678DD
" scssSelectorName xxx ctermfg=173 guifg=#D19A66
" scssVariable   xxx ctermfg=170 guifg=#C678DD
" texStatement   xxx ctermfg=170 guifg=#C678DD
" texSubscripts  xxx ctermfg=173 guifg=#D19A66
" texSuperscripts xxx ctermfg=173 guifg=#D19A66
" texTodo        xxx ctermfg=196 guifg=#BE5046
" texBeginEnd    xxx ctermfg=170 guifg=#C678DD
" texBeginEndName xxx ctermfg=39 guifg=#61AFEF
" texMathMatcher xxx ctermfg=39 guifg=#61AFEF
" texMathDelim   xxx ctermfg=39 guifg=#61AFEF
" texDelimiter   xxx ctermfg=173 guifg=#D19A66
" texSpecialChar xxx ctermfg=173 guifg=#D19A66
" texCite        xxx ctermfg=39 guifg=#61AFEF
" texRefZone     xxx ctermfg=39 guifg=#61AFEF
" typescriptReserved xxx ctermfg=170 guifg=#C678DD
" typescriptEndColons xxx ctermfg=145 guifg=#ABB2BF
" typescriptBraces xxx ctermfg=145 guifg=#ABB2BF
" xmlAttrib      xxx ctermfg=173 guifg=#D19A66
" xmlEndTag      xxx ctermfg=204 guifg=#E06C75
" xmlTag         xxx ctermfg=204 guifg=#E06C75
" xmlTagName     xxx ctermfg=204 guifg=#E06C75
" GitGutterAdd   xxx links to SignifySignAdd
" SignifySignAdd xxx ctermfg=114 guifg=#98C379
" GitGutterChange xxx links to SignifySignChange
" SignifySignChange xxx ctermfg=180 guifg=#E5C07B
" GitGutterDelete xxx links to SignifySignDelete
" SignifySignDelete xxx ctermfg=204 guifg=#E06C75
" EasyMotionTarget xxx cterm=bold ctermfg=204 gui=bold guifg=#E06C75
" EasyMotionTarget2First xxx cterm=bold ctermfg=180 gui=bold guifg=#E5C07B
" EasyMotionTarget2Second xxx cterm=bold ctermfg=173 gui=bold guifg=#D19A66
" EasyMotionShade xxx ctermfg=59 guifg=#5C6370
" NeomakeWarningSign xxx ctermfg=180 guifg=#E5C07B
" NeomakeErrorSign xxx ctermfg=204 guifg=#E06C75
" NeomakeInfoSign xxx ctermfg=39 guifg=#61AFEF
" mkdDelimiter   xxx ctermfg=170 guifg=#C678DD
" mkdHeading     xxx ctermfg=204 guifg=#E06C75
" mkdLink        xxx ctermfg=39 guifg=#61AFEF
" mkdURL         xxx cterm=underline ctermfg=38 gui=underline guifg=#56B6C2
" diffAdded      xxx ctermfg=114 guifg=#98C379
" diffRemoved    xxx ctermfg=204 guifg=#E06C75
" gitcommitComment xxx ctermfg=59 guifg=#5C6370
" gitcommitUnmerged xxx ctermfg=114 guifg=#98C379
" gitcommitOnBranch xxx cleared
" gitcommitBranch xxx ctermfg=170 guifg=#C678DD
" gitcommitDiscardedType xxx ctermfg=204 guifg=#E06C75
" gitcommitSelectedType xxx ctermfg=114 guifg=#98C379
" gitcommitHeader xxx cleared
" gitcommitUntrackedFile xxx ctermfg=38 guifg=#56B6C2
" gitcommitDiscardedFile xxx ctermfg=204 guifg=#E06C75
" gitcommitSelectedFile xxx ctermfg=114 guifg=#98C379
" gitcommitUnmergedFile xxx ctermfg=180 guifg=#E5C07B
" gitcommitFile  xxx cleared
" gitcommitSummary xxx ctermfg=145 guifg=#ABB2BF
" gitcommitOverflow xxx ctermfg=204 guifg=#E06C75
" gitcommitNoBranch xxx links to gitcommitBranch
" gitcommitUntracked xxx links to gitcommitComment
" gitcommitDiscarded xxx links to gitcommitComment
" gitcommitSelected xxx links to gitcommitComment
" gitcommitDiscardedArrow xxx links to gitcommitDiscardedFile
" gitcommitSelectedArrow xxx links to gitcommitSelectedFile
" gitcommitUnmergedArrow xxx links to gitcommitUnmergedFile
" QuickScopePrimary xxx cterm=underline ctermfg=155 gui=underline guifg=tomato
" QuickScopeSecondary xxx cterm=underline ctermfg=81 gui=underline guifg=#d78787
" GlyphPalette8  xxx guifg=#6b7089
" Sneak          xxx ctermfg=0 ctermbg=14 guifg=#282C33 guibg=#E06B74
" SneakScope     xxx ctermfg=0 ctermbg=15 guifg=#282C33 guibg=#61AFEF
" CocHighlightText xxx ctermbg=248 guibg=#3B4048
" HLNext         xxx cterm=bold ctermfg=204 gui=bold guifg=#282C34 guibg=#E06C75
" GlyphPaletteDirectory xxx links to Directory
" GlyphPalette0  xxx ctermfg=0 guifg=#282C34
" GlyphPalette1  xxx ctermfg=1 guifg=#E06C75
" GlyphPalette2  xxx ctermfg=2 guifg=#98C379
" GlyphPalette3  xxx ctermfg=3 guifg=#E5C07B
" GlyphPalette4  xxx ctermfg=4 guifg=#61AFEF
" GlyphPalette5  xxx ctermfg=5 guifg=#C678DD
" GlyphPalette6  xxx ctermfg=6 guifg=#56B6C2
" GlyphPalette7  xxx ctermfg=7 guifg=#ABB2BF
" GlyphPalette9  xxx ctermfg=9 guifg=#BE5046
" GlyphPalette10 xxx ctermfg=10 guifg=#98C379
" GlyphPalette11 xxx ctermfg=11 guifg=#D19A66
" GlyphPalette12 xxx ctermfg=12 guifg=#61AFEF
" GlyphPalette13 xxx ctermfg=13 guifg=#C678DD
" GlyphPalette14 xxx ctermfg=14 guifg=#56B6C2
" GlyphPalette15 xxx ctermfg=15 guifg=#5C6370
" LightlineLeft_normal_0 xxx cterm=bold ctermfg=235 ctermbg=76 gui=bold guifg=#282c34 guibg=#98c379
" LightlineLeft_normal_0_1 xxx ctermfg=76 ctermbg=240 guifg=#98c379 guibg=#3e4452
" LightlineLeft_normal_0_tabsel xxx ctermfg=76 ctermbg=66 guifg=#98c379 guibg=#ABB2BF
" LightlineLeft_normal_1 xxx ctermfg=145 ctermbg=240 guifg=#abb2bf guibg=#3e4452
" LightlineLeft_normal_1_2 xxx ctermfg=240 ctermbg=66 guifg=#3e4452 guibg=#2C323C
" LightlineLeft_normal_1_tabsel xxx ctermfg=240 ctermbg=66 guifg=#3e4452 guibg=#ABB2BF
" LightlineLeft_normal_2 xxx ctermfg=252 ctermbg=66 guifg=#717785 guibg=#2C323C
" LightlineLeft_normal_2_3 xxx ctermfg=66 ctermbg=66 guifg=#2C323C guibg=#2C323C
" LightlineLeft_normal_2_tabsel xxx ctermfg=66 ctermbg=66 guifg=#2C323C guibg=#ABB2BF
" LightlineLeft_normal_tabsel xxx cterm=bold ctermfg=252 ctermbg=66 gui=bold guifg=#282C33 guibg=#ABB2BF
" LightlineLeft_normal_tabsel_0 xxx ctermfg=66 ctermbg=76 guifg=#ABB2BF guibg=#98c379
" LightlineLeft_normal_tabsel_1 xxx ctermfg=66 ctermbg=240 guifg=#ABB2BF guibg=#3e4452
" LightlineLeft_normal_tabsel_2 xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#2C323C
" LightlineLeft_normal_tabsel_3 xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#2C323C
" LightlineLeft_normal_tabsel_tabsel xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#ABB2BF
" LightlineRight_normal_0 xxx cterm=bold ctermfg=235 ctermbg=76 gui=bold guifg=#282c34 guibg=#98c379
" LightlineRight_normal_0_1 xxx ctermfg=76 ctermbg=240 guifg=#98c379 guibg=#3e4452
" LightlineRight_normal_0_tabsel xxx ctermfg=76 ctermbg=66 guifg=#98c379 guibg=#ABB2BF
" LightlineRight_normal_1 xxx ctermfg=145 ctermbg=240 guifg=#abb2bf guibg=#3e4452
" LightlineRight_normal_1_2 xxx ctermfg=240 ctermbg=66 guifg=#3e4452 guibg=#2C323C
" LightlineRight_normal_1_tabsel xxx ctermfg=240 ctermbg=66 guifg=#3e4452 guibg=#ABB2BF
" LightlineRight_normal_2 xxx ctermfg=252 ctermbg=66 guifg=#717785 guibg=#2C323C
" LightlineRight_normal_2_3 xxx ctermfg=66 ctermbg=66 guifg=#2C323C guibg=#2C323C
" LightlineRight_normal_2_tabsel xxx ctermfg=66 ctermbg=66 guifg=#2C323C guibg=#ABB2BF
" LightlineRight_normal_tabsel xxx cterm=bold ctermfg=252 ctermbg=66 gui=bold guifg=#282C33 guibg=#ABB2BF
" LightlineRight_normal_tabsel_0 xxx ctermfg=66 ctermbg=76 guifg=#ABB2BF guibg=#98c379
" LightlineRight_normal_tabsel_1 xxx ctermfg=66 ctermbg=240 guifg=#ABB2BF guibg=#3e4452
" LightlineRight_normal_tabsel_2 xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#2C323C
" LightlineRight_normal_tabsel_3 xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#2C323C
" LightlineRight_normal_tabsel_tabsel xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#ABB2BF
" LightlineMiddle_normal xxx ctermfg=252 ctermbg=66 guifg=#717785 guibg=#2C323C
" LightlineLeft_active_0 xxx links to LightlineLeft_command_0
" LightlineLeft_active_0_1 xxx links to LightlineLeft_command_0_1
" LightlineLeft_active_0_tabsel xxx links to LightlineLeft_command_0_tabsel
" LightlineLeft_active_1 xxx links to LightlineLeft_command_1
" LightlineLeft_active_1_2 xxx links to LightlineLeft_command_1_2
" LightlineLeft_active_1_tabsel xxx links to LightlineLeft_command_1_tabsel
" LightlineLeft_active_2 xxx links to LightlineLeft_command_2
" LightlineLeft_active_2_3 xxx links to LightlineLeft_command_2_3
" LightlineLeft_active_2_tabsel xxx links to LightlineLeft_command_2_tabsel
" LightlineLeft_active_tabsel xxx links to LightlineLeft_command_tabsel
" LightlineLeft_active_tabsel_0 xxx links to LightlineLeft_command_tabsel_0
" LightlineLeft_active_tabsel_1 xxx links to LightlineLeft_command_tabsel_1
" LightlineLeft_active_tabsel_2 xxx links to LightlineLeft_command_tabsel_2
" LightlineLeft_active_tabsel_3 xxx links to LightlineLeft_command_tabsel_3
" LightlineLeft_active_tabsel_tabsel xxx links to LightlineLeft_command_tabsel_tabsel
" LightlineRight_active_0 xxx links to LightlineRight_command_0
" LightlineRight_active_0_1 xxx links to LightlineRight_command_0_1
" LightlineRight_active_0_tabsel xxx links to LightlineRight_command_0_tabsel
" LightlineRight_active_1 xxx links to LightlineRight_command_1
" LightlineRight_active_1_2 xxx links to LightlineRight_command_1_2
" LightlineRight_active_1_tabsel xxx links to LightlineRight_command_1_tabsel
" LightlineRight_active_2 xxx links to LightlineRight_command_2
" LightlineRight_active_2_3 xxx links to LightlineRight_command_2_3
" LightlineRight_active_2_tabsel xxx links to LightlineRight_command_2_tabsel
" LightlineRight_active_tabsel xxx links to LightlineRight_command_tabsel
" LightlineRight_active_tabsel_0 xxx links to LightlineRight_command_tabsel_0
" LightlineRight_active_tabsel_1 xxx links to LightlineRight_command_tabsel_1
" LightlineRight_active_tabsel_2 xxx links to LightlineRight_command_tabsel_2
" LightlineRight_active_tabsel_3 xxx links to LightlineRight_command_tabsel_3
" LightlineRight_active_tabsel_tabsel xxx links to LightlineRight_command_tabsel_tabsel
" LightlineMiddle_active xxx links to LightlineMiddle_command
" LightlineLeft_tabline_0 xxx ctermfg=252 ctermbg=66 guifg=#717785 guibg=#3E4452
" LightlineLeft_tabline_0_1 xxx ctermfg=66 ctermbg=66 guifg=#3E4452 guibg=#2C323C
" LightlineLeft_tabline_0_tabsel xxx ctermfg=66 ctermbg=66 guifg=#3E4452 guibg=#ABB2BF
" LightlineLeft_tabline_tabsel xxx cterm=bold ctermfg=252 ctermbg=66 gui=bold guifg=#282C33 guibg=#ABB2BF
" LightlineLeft_tabline_tabsel_0 xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#3E4452
" LightlineLeft_tabline_tabsel_1 xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#2C323C
" LightlineLeft_tabline_tabsel_tabsel xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#ABB2BF
" LightlineRight_tabline_0 xxx cterm=bold ctermfg=235 ctermbg=76 gui=bold guifg=#282c34 guibg=#98c379
" LightlineRight_tabline_0_1 xxx ctermfg=76 ctermbg=240 guifg=#98c379 guibg=#3e4452
" LightlineRight_tabline_0_tabsel xxx ctermfg=76 ctermbg=66 guifg=#98c379 guibg=#ABB2BF
" LightlineRight_tabline_1 xxx ctermfg=145 ctermbg=240 guifg=#abb2bf guibg=#3e4452
" LightlineRight_tabline_1_2 xxx ctermfg=240 ctermbg=66 guifg=#3e4452 guibg=#2C323C
" LightlineRight_tabline_1_tabsel xxx ctermfg=240 ctermbg=66 guifg=#3e4452 guibg=#ABB2BF
" LightlineRight_tabline_2 xxx ctermfg=252 ctermbg=66 guifg=#717785 guibg=#2C323C
" LightlineRight_tabline_2_3 xxx ctermfg=66 ctermbg=66 guifg=#2C323C guibg=#2C323C
" LightlineRight_tabline_2_tabsel xxx ctermfg=66 ctermbg=66 guifg=#2C323C guibg=#ABB2BF
" LightlineRight_tabline_tabsel xxx cterm=bold ctermfg=252 ctermbg=66 gui=bold guifg=#282C33 guibg=#ABB2BF
" LightlineRight_tabline_tabsel_0 xxx ctermfg=66 ctermbg=76 guifg=#ABB2BF guibg=#98c379
" LightlineRight_tabline_tabsel_1 xxx ctermfg=66 ctermbg=240 guifg=#ABB2BF guibg=#3e4452
" LightlineRight_tabline_tabsel_2 xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#2C323C
" LightlineRight_tabline_tabsel_3 xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#2C323C
" LightlineRight_tabline_tabsel_tabsel xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#ABB2BF
" LightlineMiddle_tabline xxx ctermfg=252 ctermbg=66 guifg=#717785 guibg=#2C323C
" QuickScopeCursor xxx links to Cursor
" CocUnderline   xxx cterm=underline gui=underline
" CocBold        xxx cterm=bold gui=bold
" CocErrorSign   xxx ctermfg=9 guifg=#ff0000
" CocWarningSign xxx ctermfg=130 guifg=#ff922b
" CocInfoSign    xxx ctermfg=11 guifg=#fab005
" CocHintSign    xxx ctermfg=12 guifg=#15aabf
" CocSelectedText xxx ctermfg=9 guifg=#fb4934
" CocCodeLens    xxx ctermfg=248 guifg=#999999
" CocErrorFloat  xxx links to CocErrorSign
" CocWarningFloat xxx links to CocWarningSign
" CocInfoFloat   xxx links to CocInfoSign
" CocHintFloat   xxx links to CocHintSign
" CocErrorHighlight xxx links to CocUnderline
" CocWarningHighlight xxx links to CocUnderline
" CocInfoHighlight xxx links to CocUnderline
" CocHintHighlight xxx links to CocUnderline
" CocListMode    xxx links to ModeMsg
" CocListPath    xxx links to Comment
" CocHoverRange  xxx links to Search
" CocCursorRange xxx links to Search
" CocHighlightRead xxx links to CocHighlightText
" CocHighlightWrite xxx links to CocHighlightText
" CocFloating    xxx links to NormalFloat
" CocErrorVirtualText xxx links to CocErrorSign
" CocWarningVirtualText xxx links to CocWarningSign
" CocInfoVirtualText xxx links to CocInfoSign
" CocHintVirtualText xxx links to CocHintSign
" CocListBlackBlack xxx guifg=#282C34 guibg=#282C34
" CocListBlackBlue xxx guifg=#282C34 guibg=#61AFEF
" CocListBlackGreen xxx guifg=#282C34 guibg=#98C379
" CocListBlackGrey xxx guifg=#282C34 guibg=#3E4452
" CocListBlackWhite xxx guifg=#282C34 guibg=#ABB2BF
" CocListBlackCyan xxx guifg=#282C34 guibg=#56B6C2
" CocListBlackYellow xxx guifg=#282C34 guibg=#E5C07B
" CocListBlackMagenta xxx guifg=#282C34 guibg=#C678DD
" CocListBlackRed xxx guifg=#282C34 guibg=#E06C75
" CocListFgBlack xxx ctermfg=0 guifg=#282C34
" CocListBgBlack xxx ctermbg=0 guibg=#282C34
" CocListBlueBlack xxx guifg=#61AFEF guibg=#282C34
" CocListBlueBlue xxx guifg=#61AFEF guibg=#61AFEF
" CocListBlueGreen xxx guifg=#61AFEF guibg=#98C379
" CocListBlueGrey xxx guifg=#61AFEF guibg=#3E4452
" CocListBlueWhite xxx guifg=#61AFEF guibg=#ABB2BF
" CocListBlueCyan xxx guifg=#61AFEF guibg=#56B6C2
" CocListBlueYellow xxx guifg=#61AFEF guibg=#E5C07B
" CocListBlueMagenta xxx guifg=#61AFEF guibg=#C678DD
" CocListBlueRed xxx guifg=#61AFEF guibg=#E06C75
" CocListFgBlue  xxx ctermfg=12 guifg=#61AFEF
" CocListBgBlue  xxx ctermbg=12 guibg=#61AFEF
" CocListGreenBlack xxx guifg=#98C379 guibg=#282C34
" CocListGreenBlue xxx guifg=#98C379 guibg=#61AFEF
" CocListGreenGreen xxx guifg=#98C379 guibg=#98C379
" CocListGreenGrey xxx guifg=#98C379 guibg=#3E4452
" CocListGreenWhite xxx guifg=#98C379 guibg=#ABB2BF
" CocListGreenCyan xxx guifg=#98C379 guibg=#56B6C2
" CocListGreenYellow xxx guifg=#98C379 guibg=#E5C07B
" CocListGreenMagenta xxx guifg=#98C379 guibg=#C678DD
" CocListGreenRed xxx guifg=#98C379 guibg=#E06C75
" CocListFgGreen xxx ctermfg=10 guifg=#98C379
" CocListBgGreen xxx ctermbg=10 guibg=#98C379
" CocListGreyBlack xxx guifg=#3E4452 guibg=#282C34
" CocListGreyBlue xxx guifg=#3E4452 guibg=#61AFEF
" CocListGreyGreen xxx guifg=#3E4452 guibg=#98C379
" CocListGreyGrey xxx guifg=#3E4452 guibg=#3E4452
" CocListGreyWhite xxx guifg=#3E4452 guibg=#ABB2BF
" CocListGreyCyan xxx guifg=#3E4452 guibg=#56B6C2
" CocListGreyYellow xxx guifg=#3E4452 guibg=#E5C07B
" CocListGreyMagenta xxx guifg=#3E4452 guibg=#C678DD
" CocListGreyRed xxx guifg=#3E4452 guibg=#E06C75
" CocListFgGrey  xxx ctermfg=248 guifg=#3E4452
" CocListBgGrey  xxx ctermbg=248 guibg=#3E4452
" CocListWhiteBlack xxx guifg=#ABB2BF guibg=#282C34
" CocListWhiteBlue xxx guifg=#ABB2BF guibg=#61AFEF
" CocListWhiteGreen xxx guifg=#ABB2BF guibg=#98C379
" CocListWhiteGrey xxx guifg=#ABB2BF guibg=#3E4452
" CocListWhiteWhite xxx guifg=#ABB2BF guibg=#ABB2BF
" CocListWhiteCyan xxx guifg=#ABB2BF guibg=#56B6C2
" CocListWhiteYellow xxx guifg=#ABB2BF guibg=#E5C07B
" CocListWhiteMagenta xxx guifg=#ABB2BF guibg=#C678DD
" CocListWhiteRed xxx guifg=#ABB2BF guibg=#E06C75
" CocListFgWhite xxx ctermfg=15 guifg=#ABB2BF
" CocListBgWhite xxx ctermbg=15 guibg=#ABB2BF
" CocListCyanBlack xxx guifg=#56B6C2 guibg=#282C34
" CocListCyanBlue xxx guifg=#56B6C2 guibg=#61AFEF
" CocListCyanGreen xxx guifg=#56B6C2 guibg=#98C379
" CocListCyanGrey xxx guifg=#56B6C2 guibg=#3E4452
" CocListCyanWhite xxx guifg=#56B6C2 guibg=#ABB2BF
" CocListCyanCyan xxx guifg=#56B6C2 guibg=#56B6C2
" CocListCyanYellow xxx guifg=#56B6C2 guibg=#E5C07B
" CocListCyanMagenta xxx guifg=#56B6C2 guibg=#C678DD
" CocListCyanRed xxx guifg=#56B6C2 guibg=#E06C75
" CocListFgCyan  xxx ctermfg=14 guifg=#56B6C2
" CocListBgCyan  xxx ctermbg=14 guibg=#56B6C2
" CocListYellowBlack xxx guifg=#E5C07B guibg=#282C34
" CocListYellowBlue xxx guifg=#E5C07B guibg=#61AFEF
" CocListYellowGreen xxx guifg=#E5C07B guibg=#98C379
" CocListYellowGrey xxx guifg=#E5C07B guibg=#3E4452
" CocListYellowWhite xxx guifg=#E5C07B guibg=#ABB2BF
" CocListYellowCyan xxx guifg=#E5C07B guibg=#56B6C2
" CocListYellowYellow xxx guifg=#E5C07B guibg=#E5C07B
" CocListYellowMagenta xxx guifg=#E5C07B guibg=#C678DD
" CocListYellowRed xxx guifg=#E5C07B guibg=#E06C75
" CocListFgYellow xxx ctermfg=11 guifg=#E5C07B
" CocListBgYellow xxx ctermbg=11 guibg=#E5C07B
" CocListMagentaBlack xxx guifg=#C678DD guibg=#282C34
" CocListMagentaBlue xxx guifg=#C678DD guibg=#61AFEF
" CocListMagentaGreen xxx guifg=#C678DD guibg=#98C379
" CocListMagentaGrey xxx guifg=#C678DD guibg=#3E4452
" CocListMagentaWhite xxx guifg=#C678DD guibg=#ABB2BF
" CocListMagentaCyan xxx guifg=#C678DD guibg=#56B6C2
" CocListMagentaYellow xxx guifg=#C678DD guibg=#E5C07B
" CocListMagentaMagenta xxx guifg=#C678DD guibg=#C678DD
" CocListMagentaRed xxx guifg=#C678DD guibg=#E06C75
" CocListFgMagenta xxx ctermfg=13 guifg=#C678DD
" CocListBgMagenta xxx ctermbg=13 guibg=#C678DD
" CocListRedBlack xxx guifg=#E06C75 guibg=#282C34
" CocListRedBlue xxx guifg=#E06C75 guibg=#61AFEF
" CocListRedGreen xxx guifg=#E06C75 guibg=#98C379
" CocListRedGrey xxx guifg=#E06C75 guibg=#3E4452
" CocListRedWhite xxx guifg=#E06C75 guibg=#ABB2BF
" CocListRedCyan xxx guifg=#E06C75 guibg=#56B6C2
" CocListRedYellow xxx guifg=#E06C75 guibg=#E5C07B
" CocListRedMagenta xxx guifg=#E06C75 guibg=#C678DD
" CocListRedRed  xxx guifg=#E06C75 guibg=#E06C75
" CocListFgRed   xxx ctermfg=9 guifg=#E06C75
" CocListBgRed   xxx ctermbg=9 guibg=#E06C75
" GitGutterAddInvisible xxx guifg=bg
" GitGutterChangeInvisible xxx guifg=bg
" GitGutterDeleteInvisible xxx guifg=bg
" GitGutterChangeDeleteInvisible xxx links to GitGutterChangeInvisible
" GitGutterChangeDelete xxx links to GitGutterChange
" GitGutterAddLine xxx links to DiffAdd
" GitGutterChangeLine xxx links to DiffChange
" GitGutterDeleteLine xxx links to DiffDelete
" GitGutterChangeDeleteLine xxx links to GitGutterChangeLine
" GitGutterAddLineNr xxx links to CursorLineNr
" GitGutterChangeLineNr xxx links to CursorLineNr
" GitGutterDeleteLineNr xxx links to CursorLineNr
" GitGutterChangeDeleteLineNr xxx links to CursorLineNr
" GitGutterAddIntraLine xxx cterm=reverse gui=reverse
" GitGutterDeleteIntraLine xxx cterm=reverse gui=reverse
" diffChanged    xxx ctermfg=180 guifg=#E5C07B
"                xxx cleared
" VitalWindowSelectorStatusLine xxx links to StatusLineNC
" VitalWindowSelectorIndicator xxx links to DiffText
" FernWindowSelectStatusLine xxx links to VitalWindowSelectorStatusLine
" FernWindowSelectIndicator xxx links to VitalWindowSelectorIndicator
" LightlineLeft_inactive_0 xxx ctermfg=252 ctermbg=66 guifg=#717785 guibg=#3E4452
" LightlineLeft_inactive_0_1 xxx ctermfg=66 ctermbg=235 guifg=#3E4452 guibg=#2c323d
" LightlineLeft_inactive_0_tabsel xxx ctermfg=66 ctermbg=66 guifg=#3E4452 guibg=#ABB2BF
" LightlineLeft_inactive_tabsel xxx cterm=bold ctermfg=252 ctermbg=66 gui=bold guifg=#282C33 guibg=#ABB2BF
" LightlineLeft_inactive_tabsel_0 xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#3E4452
" LightlineLeft_inactive_tabsel_1 xxx ctermfg=66 ctermbg=235 guifg=#ABB2BF guibg=#2c323d
" LightlineLeft_inactive_tabsel_tabsel xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#ABB2BF
" LightlineRight_inactive_0 xxx ctermfg=252 ctermbg=66 guifg=#717785 guibg=#3E4452
" LightlineRight_inactive_0_1 xxx ctermfg=66 ctermbg=235 guifg=#3E4452 guibg=#2c323d
" LightlineRight_inactive_0_tabsel xxx ctermfg=66 ctermbg=66 guifg=#3E4452 guibg=#ABB2BF
" LightlineRight_inactive_1 xxx ctermfg=241 ctermbg=235 guifg=#5c6370 guibg=#2c323d
" LightlineRight_inactive_1_2 xxx ctermfg=235 ctermbg=235 guifg=#2c323d guibg=#2c323d
" LightlineRight_inactive_1_tabsel xxx ctermfg=235 ctermbg=66 guifg=#2c323d guibg=#ABB2BF
" LightlineRight_inactive_tabsel xxx cterm=bold ctermfg=252 ctermbg=66 gui=bold guifg=#282C33 guibg=#ABB2BF
" LightlineRight_inactive_tabsel_0 xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#3E4452
" LightlineRight_inactive_tabsel_1 xxx ctermfg=66 ctermbg=235 guifg=#ABB2BF guibg=#2c323d
" LightlineRight_inactive_tabsel_2 xxx ctermfg=66 ctermbg=235 guifg=#ABB2BF guibg=#2c323d
" LightlineRight_inactive_tabsel_tabsel xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#ABB2BF
" LightlineMiddle_inactive xxx ctermfg=241 ctermbg=235 guifg=#5c6370 guibg=#2c323d
" FernRootText   xxx links to Comment
" FernLeafSymbol xxx links to Directory
" FernLeafText   xxx links to None
" None           xxx cleared
" FernBranchSymbol xxx links to Statement
" FernBranchText xxx links to Statement
" FernGitStatusBracket xxx links to Comment
" FernGitStatusIndex xxx links to Special
" FernGitStatusWorktree xxx links to WarningMsg
" FernGitStatusUnmerged xxx links to ErrorMsg
" FernGitStatusUntracked xxx links to Comment
" FernGitStatusIgnored xxx links to Comment
" FernLeaf       xxx cleared
" FernBranch     xxx cleared
" FernRoot       xxx cleared
" FernBadgeSep   xxx cleared
" FernBadge      xxx cleared
" FernGitStatus  xxx cleared
" FernMarkedLine xxx links to Title
" FernMarkedText xxx links to Title
" CocErrorLine   xxx cleared
" CocWarningLine xxx cleared
" CocInfoLine    xxx cleared
" CocHintLine    xxx cleared
" CocSelectedLine xxx cleared
" HighlightedyankRegion xxx links to IncSearch
" CocYankLine    xxx cleared
" diffOnly       xxx links to Constant
" diffIdentical  xxx links to Constant
" diffDiffer     xxx links to Constant
" diffBDiffer    xxx links to Constant
" diffIsA        xxx links to Constant
" diffNoEOL      xxx links to Constant
" diffCommon     xxx links to Constant
" diffSubname    xxx links to PreProc
" diffLine       xxx links to Statement
" diffFile       xxx links to Type
" diffOldFile    xxx links to diffFile
" diffNewFile    xxx links to diffFile
" diffIndexLine  xxx links to PreProc
" diffComment    xxx links to Comment
" fugitiveHash   xxx links to Identifier
" fugitiveSymbolicRef xxx links to Function
" fugitiveHeader xxx links to Label
" fugitiveBareHeader xxx links to fugitiveHeader
" fugitiveHelpTag xxx links to Tag
" fugitiveHelpHeader xxx links to fugitiveHeader
" fugitiveHeading xxx links to PreProc
" fugitiveSection xxx cleared
" fugitivePreposition xxx cleared
" fugitiveCount  xxx links to Number
" fugitiveInstruction xxx links to Type
" fugitiveDone   xxx cleared
" fugitiveStop   xxx links to Function
" fugitiveModifier xxx links to Type
" fugitiveHunk   xxx cleared
" fugitiveUntrackedHeading xxx links to PreCondit
" fugitiveUntrackedSection xxx cleared
" fugitiveUntrackedModifier xxx links to StorageClass
" fugitiveUnstagedHeading xxx links to Macro
" fugitiveUnstagedSection xxx cleared
" fugitiveUnstagedModifier xxx links to Structure
" fugitiveStagedHeading xxx links to Include
" fugitiveStagedSection xxx cleared
" fugitiveStagedModifier xxx links to Typedef
" fzf1           xxx guifg=#E5C07B guibg=#3B4048
" fzf2           xxx guifg=#98C379 guibg=#3B4048
" fzf3           xxx guifg=#ABB2BF guibg=#3B4048
" LightlineLeft_terminal_0 xxx cterm=bold ctermfg=235 ctermbg=75 gui=bold guifg=#282c34 guibg=#61afef
" LightlineLeft_terminal_0_1 xxx ctermfg=75 ctermbg=240 guifg=#61afef guibg=#3e4452
" LightlineLeft_terminal_0_tabsel xxx ctermfg=75 ctermbg=66 guifg=#61afef guibg=#ABB2BF
" LightlineLeft_terminal_1 xxx ctermfg=145 ctermbg=240 guifg=#abb2bf guibg=#3e4452
" LightlineLeft_terminal_1_2 xxx ctermfg=240 ctermbg=66 guifg=#3e4452 guibg=#2C323C
" LightlineLeft_terminal_1_tabsel xxx ctermfg=240 ctermbg=66 guifg=#3e4452 guibg=#ABB2BF
" LightlineLeft_terminal_2 xxx ctermfg=252 ctermbg=66 guifg=#717785 guibg=#2C323C
" LightlineLeft_terminal_2_3 xxx ctermfg=66 ctermbg=66 guifg=#2C323C guibg=#2C323C
" LightlineLeft_terminal_2_tabsel xxx ctermfg=66 ctermbg=66 guifg=#2C323C guibg=#ABB2BF
" LightlineLeft_terminal_tabsel xxx cterm=bold ctermfg=252 ctermbg=66 gui=bold guifg=#282C33 guibg=#ABB2BF
" LightlineLeft_terminal_tabsel_0 xxx ctermfg=66 ctermbg=75 guifg=#ABB2BF guibg=#61afef
" LightlineLeft_terminal_tabsel_1 xxx ctermfg=66 ctermbg=240 guifg=#ABB2BF guibg=#3e4452
" LightlineLeft_terminal_tabsel_2 xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#2C323C
" LightlineLeft_terminal_tabsel_3 xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#2C323C
" LightlineLeft_terminal_tabsel_tabsel xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#ABB2BF
" LightlineRight_terminal_0 xxx cterm=bold ctermfg=235 ctermbg=75 gui=bold guifg=#282c34 guibg=#61afef
" LightlineRight_terminal_0_1 xxx ctermfg=75 ctermbg=240 guifg=#61afef guibg=#3e4452
" LightlineRight_terminal_0_tabsel xxx ctermfg=75 ctermbg=66 guifg=#61afef guibg=#ABB2BF
" LightlineRight_terminal_1 xxx ctermfg=145 ctermbg=240 guifg=#abb2bf guibg=#3e4452
" LightlineRight_terminal_1_2 xxx ctermfg=240 ctermbg=66 guifg=#3e4452 guibg=#2C323C
" LightlineRight_terminal_1_tabsel xxx ctermfg=240 ctermbg=66 guifg=#3e4452 guibg=#ABB2BF
" LightlineRight_terminal_2 xxx ctermfg=252 ctermbg=66 guifg=#717785 guibg=#2C323C
" LightlineRight_terminal_2_3 xxx ctermfg=66 ctermbg=66 guifg=#2C323C guibg=#2C323C
" LightlineRight_terminal_2_tabsel xxx ctermfg=66 ctermbg=66 guifg=#2C323C guibg=#ABB2BF
" LightlineRight_terminal_tabsel xxx cterm=bold ctermfg=252 ctermbg=66 gui=bold guifg=#282C33 guibg=#ABB2BF
" LightlineRight_terminal_tabsel_0 xxx ctermfg=66 ctermbg=75 guifg=#ABB2BF guibg=#61afef
" LightlineRight_terminal_tabsel_1 xxx ctermfg=66 ctermbg=240 guifg=#ABB2BF guibg=#3e4452
" LightlineRight_terminal_tabsel_2 xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#2C323C
" LightlineRight_terminal_tabsel_3 xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#2C323C
" LightlineRight_terminal_tabsel_tabsel xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#ABB2BF
" LightlineMiddle_terminal xxx ctermfg=252 ctermbg=66 guifg=#717785 guibg=#2C323C
" vimTodo        xxx links to Todo
" vimCommand     xxx links to Statement
" vimOnlyCommand xxx cleared
" vimStdPlugin   xxx cleared
" vimOnlyOption  xxx cleared
" vimTermOption  xxx cleared
" vimErrSetting  xxx links to vimError
" vimGroup       xxx links to Type
" vimHLGroup     xxx links to vimGroup
" vimOnlyHLGroup xxx cleared
" nvimHLGroup    xxx links to vimHLGroup
" vimGlobal      xxx cleared
" vimSubst       xxx links to vimCommand
" vimComment     xxx links to Comment
" vimNumber      xxx links to Number
" vimAddress     xxx links to vimMark
" vimAutoCmd     xxx links to vimCommand
" vimEcho        xxx cleared
" vimIsCommand   xxx cleared
" vimExtCmd      xxx cleared
" vimFilter      xxx cleared
" vimLet         xxx links to vimCommand
" vimMap         xxx links to vimCommand
" vimMark        xxx links to Number
" vimSet         xxx cleared
" vimSyntax      xxx links to vimCommand
" vimUserCmd     xxx cleared
" vimCmdSep      xxx cleared
" vimVar         xxx links to Identifier
" vimFBVar       xxx links to vimVar
" vimInsert      xxx links to vimString
" vimBehaveModel xxx links to vimBehave
" vimBehaveError xxx links to vimError
" vimBehave      xxx links to vimCommand
" vimFTCmd       xxx links to vimCommand
" vimFTOption    xxx links to vimSynType
" vimFTError     xxx links to vimError
" vimFiletype    xxx cleared
" vimAugroup     xxx cleared
" vimExecute     xxx cleared
" vimNotFunc     xxx links to vimCommand
" vimFuncName    xxx links to Function
" vimFunction    xxx cleared
" vimFunctionError xxx links to vimError
" vimLineComment xxx links to vimComment
" vimSpecFile    xxx links to Identifier
" vimOper        xxx links to Operator
" vimOperParen   xxx cleared
" vimString      xxx links to String
" vimRegister    xxx links to SpecialChar
" vimCmplxRepeat xxx links to SpecialChar
" vimRegion      xxx cleared
" vimSynLine     xxx cleared
" vimNotation    xxx links to Special
" vimCtrlChar    xxx links to SpecialChar
" vimFuncVar     xxx links to Identifier
" vimContinue    xxx links to Special
" vimSetEqual    xxx cleared
" vimOption      xxx links to PreProc
" vimAugroupKey  xxx links to vimCommand
" vimAugroupError xxx links to vimError
" vimEnvvar      xxx links to PreProc
" vimFunc        xxx links to vimError
" vimParenSep    xxx links to Delimiter
" vimSep         xxx links to Delimiter
" vimOperError   xxx links to Error
" vimFuncKey     xxx links to vimCommand
" vimFuncSID     xxx links to Special
" vimAbb         xxx links to vimCommand
" vimEchoHL      xxx links to vimCommand
" vimHighlight   xxx links to vimCommand
" vimNorm        xxx links to vimCommand
" vimSearch      xxx links to vimString
" vimUnmap       xxx links to vimMap
" vimUserCommand xxx links to vimCommand
" vimFuncBody    xxx cleared
" vimFuncBlank   xxx cleared
" vimPattern     xxx links to Type
" vimSpecFileMod xxx links to vimSpecFile
" vimEscapeBrace xxx cleared
" vimSetString   xxx links to vimString
" vimSubstRep    xxx cleared
" vimSubstRange  xxx cleared
" vimUserAttrb   xxx links to vimSpecial
" vimUserAttrbError xxx links to Error
" vimUserAttrbKey xxx links to vimOption
" vimUserAttrbCmplt xxx links to vimSpecial
" vimUserCmdError xxx links to Error
" vimUserAttrbCmpltFunc xxx links to Special
" vimCommentString xxx links to vimString
" vimPatSepErr   xxx links to vimError
" vimPatSep      xxx links to SpecialChar
" vimPatSepZ     xxx links to vimPatSep
" vimPatSepZone  xxx links to vimString
" vimPatSepR     xxx links to vimPatSep
" vimPatRegion   xxx cleared
" vimNotPatSep   xxx links to vimString
" vimStringEnd   xxx links to vimString
" vimStringCont  xxx links to vimString
" vimSubstTwoBS  xxx links to vimString
" vimSubstSubstr xxx links to SpecialChar
" vimCollection  xxx cleared
" vimSubstPat    xxx cleared
" vimSubst1      xxx links to vimSubst
" vimSubst2      xxx cleared
" vimSubstDelim  xxx links to Delimiter
" vimSubstRep4   xxx cleared
" vimSubstFlagErr xxx links to vimError
" vimCollClass   xxx cleared
" vimCollClassErr xxx links to vimError
" vimSubstFlags  xxx links to Special
" vimMarkNumber  xxx links to vimNumber
" vimPlainMark   xxx links to vimMark
" vimRange       xxx cleared
" vimPlainRegister xxx links to vimRegister
" vimSetMod      xxx links to vimOption
" vimSetSep      xxx links to Statement
" vimMapMod      xxx links to vimBracket
" vimMapLhs      xxx cleared
" vimAutoEvent   xxx links to Type
" nvimAutoEvent  xxx links to vimAutoEvent
" vimAutoCmdSpace xxx cleared
" vimAutoEventList xxx cleared
" vimAutoCmdSfxList xxx cleared
" vimEchoHLNone  xxx links to vimGroup
" vimMapBang     xxx links to vimCommand
" nvimMap        xxx links to vimMap
" nvimUnmap      xxx links to vimUnmap
" vimMapRhs      xxx cleared
" vimMapModKey   xxx links to vimFuncSID
" vimMapModErr   xxx links to vimError
" vimMapRhsExtend xxx cleared
" vimMenuBang    xxx cleared
" vimMenuPriority xxx cleared
" vimMenuName    xxx links to PreProc
" vimMenuMod     xxx links to vimMapMod
" vimMenuNameMore xxx links to vimMenuName
" vimMenuMap     xxx cleared
" vimMenuRhs     xxx cleared
" vimBracket     xxx links to Delimiter
" vimUserFunc    xxx links to Normal
" vimElseIfErr   xxx links to Error
" vimBufnrWarn   xxx links to vimWarn
" vimNormCmds    xxx cleared
" vimGroupSpecial xxx links to Special
" vimGroupList   xxx cleared
" vimSynError    xxx links to Error
" vimSynContains xxx links to vimSynOption
" vimSynKeyContainedin xxx links to vimSynContains
" vimSynNextgroup xxx links to vimSynOption
" vimSynType     xxx links to vimSpecial
" vimAuSyntax    xxx cleared
" vimSynCase     xxx links to Type
" vimSynCaseError xxx links to vimError
" vimClusterName xxx cleared
" vimGroupName   xxx links to vimGroup
" vimGroupAdd    xxx links to vimSynOption
" vimGroupRem    xxx links to vimSynOption
" vimIskList     xxx cleared
" vimIskSep      xxx links to Delimiter
" vimSynKeyOpt   xxx links to vimSynOption
" vimSynKeyRegion xxx cleared
" vimMtchComment xxx links to vimComment
" vimSynMtchOpt  xxx links to vimSynOption
" vimSynRegPat   xxx links to vimString
" vimSynMatchRegion xxx cleared
" vimSynMtchCchar xxx cleared
" vimSynMtchGroup xxx cleared
" vimSynPatRange xxx links to vimString
" vimSynNotPatRange xxx links to vimSynRegPat
" vimSynRegOpt   xxx links to vimSynOption
" vimSynReg      xxx links to Type
" vimSynMtchGrp  xxx links to vimSynOption
" vimSynRegion   xxx cleared
" vimSynPatMod   xxx cleared
" vimSyncC       xxx links to Type
" vimSyncLines   xxx cleared
" vimSyncMatch   xxx cleared
" vimSyncError   xxx links to Error
" vimSyncLinebreak xxx cleared
" vimSyncLinecont xxx cleared
" vimSyncRegion  xxx cleared
" vimSyncGroupName xxx links to vimGroupName
" vimSyncKey     xxx links to Type
" vimSyncGroup   xxx links to vimGroupName
" vimSyncNone    xxx links to Type
" vimHiLink      xxx cleared
" vimHiClear     xxx links to vimHighlight
" vimHiKeyList   xxx cleared
" vimHiCtermError xxx links to vimError
" vimHiBang      xxx cleared
" vimHiGroup     xxx links to vimGroupName
" vimHiAttrib    xxx links to PreProc
" vimFgBgAttrib  xxx links to vimHiAttrib
" vimHiAttribList xxx links to vimError
" vimHiCtermColor xxx cleared
" vimHiFontname  xxx cleared
" vimHiGuiFontname xxx cleared
" vimHiGuiRgb    xxx links to vimNumber
" vimHiTerm      xxx links to Type
" vimHiCTerm     xxx links to vimHiTerm
" vimHiStartStop xxx links to vimHiTerm
" vimHiCtermFgBg xxx links to vimHiTerm
" vimHiGui       xxx links to vimHiTerm
" vimHiGuiFont   xxx links to vimHiTerm
" vimHiGuiFgBg   xxx links to vimHiTerm
" vimHiKeyError  xxx links to vimError
" vimHiTermcap   xxx cleared
" vimHiNmbr      xxx links to Number
" vimCommentTitle xxx links to PreProc
" vimCommentTitleLeader xxx cleared
" vimSearchDelim xxx links to Statement
" vimEmbedError  xxx links to Normal
" vimAugroupSyncA xxx cleared
" vimError       xxx links to Error
" vimKeyCodeError xxx links to vimError
" vimWarn        xxx links to WarningMsg
" vimAuHighlight xxx links to vimHighlight
" vimAutoCmdOpt  xxx links to vimOption
" vimAutoSet     xxx links to vimCommand
" vimCondHL      xxx links to vimCommand
" vimElseif      xxx links to vimCondHL
" vimFold        xxx links to Folded
" vimSynOption   xxx links to Special
" vimHLMod       xxx links to PreProc
" vimKeyCode     xxx links to vimSpecFile
" vimKeyword     xxx links to Statement
" vimScriptDelim xxx links to Comment
" vimSpecial     xxx links to Type
" vimStatement   xxx links to Statement
" BG3e4452       xxx ctermfg=15 ctermbg=238 guifg=#ffffff guibg=#3e4452
" BG2c323c       xxx ctermfg=15 ctermbg=236 guifg=#ffffff guibg=#2c323c
" BG282c34       xxx ctermfg=15 ctermbg=236 guifg=#ffffff guibg=#282c34
" LightlineLeft_visual_0 xxx cterm=bold ctermfg=235 ctermbg=176 gui=bold guifg=#282c34 guibg=#c678dd
" LightlineLeft_visual_0_1 xxx ctermfg=176 ctermbg=240 guifg=#c678dd guibg=#3e4452
" LightlineLeft_visual_0_tabsel xxx ctermfg=176 ctermbg=66 guifg=#c678dd guibg=#ABB2BF
" LightlineLeft_visual_1 xxx ctermfg=145 ctermbg=240 guifg=#abb2bf guibg=#3e4452
" LightlineLeft_visual_1_2 xxx ctermfg=240 ctermbg=66 guifg=#3e4452 guibg=#2C323C
" LightlineLeft_visual_1_tabsel xxx ctermfg=240 ctermbg=66 guifg=#3e4452 guibg=#ABB2BF
" LightlineLeft_visual_2 xxx ctermfg=252 ctermbg=66 guifg=#717785 guibg=#2C323C
" LightlineLeft_visual_2_3 xxx ctermfg=66 ctermbg=66 guifg=#2C323C guibg=#2C323C
" LightlineLeft_visual_2_tabsel xxx ctermfg=66 ctermbg=66 guifg=#2C323C guibg=#ABB2BF
" LightlineLeft_visual_tabsel xxx cterm=bold ctermfg=252 ctermbg=66 gui=bold guifg=#282C33 guibg=#ABB2BF
" LightlineLeft_visual_tabsel_0 xxx ctermfg=66 ctermbg=176 guifg=#ABB2BF guibg=#c678dd
" LightlineLeft_visual_tabsel_1 xxx ctermfg=66 ctermbg=240 guifg=#ABB2BF guibg=#3e4452
" LightlineLeft_visual_tabsel_2 xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#2C323C
" LightlineLeft_visual_tabsel_3 xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#2C323C
" LightlineLeft_visual_tabsel_tabsel xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#ABB2BF
" LightlineRight_visual_0 xxx cterm=bold ctermfg=235 ctermbg=176 gui=bold guifg=#282c34 guibg=#c678dd
" LightlineRight_visual_0_1 xxx ctermfg=176 ctermbg=240 guifg=#c678dd guibg=#3e4452
" LightlineRight_visual_0_tabsel xxx ctermfg=176 ctermbg=66 guifg=#c678dd guibg=#ABB2BF
" LightlineRight_visual_1 xxx ctermfg=145 ctermbg=240 guifg=#abb2bf guibg=#3e4452
" LightlineRight_visual_1_2 xxx ctermfg=240 ctermbg=66 guifg=#3e4452 guibg=#2C323C
" LightlineRight_visual_1_tabsel xxx ctermfg=240 ctermbg=66 guifg=#3e4452 guibg=#ABB2BF
" LightlineRight_visual_2 xxx ctermfg=252 ctermbg=66 guifg=#717785 guibg=#2C323C
" LightlineRight_visual_2_3 xxx ctermfg=66 ctermbg=66 guifg=#2C323C guibg=#2C323C
" LightlineRight_visual_2_tabsel xxx ctermfg=66 ctermbg=66 guifg=#2C323C guibg=#ABB2BF
" LightlineRight_visual_tabsel xxx cterm=bold ctermfg=252 ctermbg=66 gui=bold guifg=#282C33 guibg=#ABB2BF
" LightlineRight_visual_tabsel_0 xxx ctermfg=66 ctermbg=176 guifg=#ABB2BF guibg=#c678dd
" LightlineRight_visual_tabsel_1 xxx ctermfg=66 ctermbg=240 guifg=#ABB2BF guibg=#3e4452
" LightlineRight_visual_tabsel_2 xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#2C323C
" LightlineRight_visual_tabsel_3 xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#2C323C
" LightlineRight_visual_tabsel_tabsel xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#ABB2BF
" LightlineMiddle_visual xxx ctermfg=252 ctermbg=66 guifg=#717785 guibg=#2C323C
" LightlineLeft_insert_0 xxx cterm=bold ctermfg=235 ctermbg=75 gui=bold guifg=#282c34 guibg=#61afef
" LightlineLeft_insert_0_1 xxx ctermfg=75 ctermbg=240 guifg=#61afef guibg=#3e4452
" LightlineLeft_insert_0_tabsel xxx ctermfg=75 ctermbg=66 guifg=#61afef guibg=#ABB2BF
" LightlineLeft_insert_1 xxx ctermfg=145 ctermbg=240 guifg=#abb2bf guibg=#3e4452
" LightlineLeft_insert_1_2 xxx ctermfg=240 ctermbg=66 guifg=#3e4452 guibg=#2C323C
" LightlineLeft_insert_1_tabsel xxx ctermfg=240 ctermbg=66 guifg=#3e4452 guibg=#ABB2BF
" LightlineLeft_insert_2 xxx ctermfg=252 ctermbg=66 guifg=#717785 guibg=#2C323C
" LightlineLeft_insert_2_3 xxx ctermfg=66 ctermbg=66 guifg=#2C323C guibg=#2C323C
" LightlineLeft_insert_2_tabsel xxx ctermfg=66 ctermbg=66 guifg=#2C323C guibg=#ABB2BF
" LightlineLeft_insert_tabsel xxx cterm=bold ctermfg=252 ctermbg=66 gui=bold guifg=#282C33 guibg=#ABB2BF
" LightlineLeft_insert_tabsel_0 xxx ctermfg=66 ctermbg=75 guifg=#ABB2BF guibg=#61afef
" LightlineLeft_insert_tabsel_1 xxx ctermfg=66 ctermbg=240 guifg=#ABB2BF guibg=#3e4452
" LightlineLeft_insert_tabsel_2 xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#2C323C
" LightlineLeft_insert_tabsel_3 xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#2C323C
" LightlineLeft_insert_tabsel_tabsel xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#ABB2BF
" LightlineRight_insert_0 xxx cterm=bold ctermfg=235 ctermbg=75 gui=bold guifg=#282c34 guibg=#61afef
" LightlineRight_insert_0_1 xxx ctermfg=75 ctermbg=240 guifg=#61afef guibg=#3e4452
" LightlineRight_insert_0_tabsel xxx ctermfg=75 ctermbg=66 guifg=#61afef guibg=#ABB2BF
" LightlineRight_insert_1 xxx ctermfg=145 ctermbg=240 guifg=#abb2bf guibg=#3e4452
" LightlineRight_insert_1_2 xxx ctermfg=240 ctermbg=66 guifg=#3e4452 guibg=#2C323C
" LightlineRight_insert_1_tabsel xxx ctermfg=240 ctermbg=66 guifg=#3e4452 guibg=#ABB2BF
" LightlineRight_insert_2 xxx ctermfg=252 ctermbg=66 guifg=#717785 guibg=#2C323C
" LightlineRight_insert_2_3 xxx ctermfg=66 ctermbg=66 guifg=#2C323C guibg=#2C323C
" LightlineRight_insert_2_tabsel xxx ctermfg=66 ctermbg=66 guifg=#2C323C guibg=#ABB2BF
" LightlineRight_insert_tabsel xxx cterm=bold ctermfg=252 ctermbg=66 gui=bold guifg=#282C33 guibg=#ABB2BF
" LightlineRight_insert_tabsel_0 xxx ctermfg=66 ctermbg=75 guifg=#ABB2BF guibg=#61afef
" LightlineRight_insert_tabsel_1 xxx ctermfg=66 ctermbg=240 guifg=#ABB2BF guibg=#3e4452
" LightlineRight_insert_tabsel_2 xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#2C323C
" LightlineRight_insert_tabsel_3 xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#2C323C
" LightlineRight_insert_tabsel_tabsel xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#ABB2BF
" LightlineMiddle_insert xxx ctermfg=252 ctermbg=66 guifg=#717785 guibg=#2C323C
" LightlineLeft_command_0 xxx cterm=bold ctermfg=235 ctermbg=76 gui=bold guifg=#282c34 guibg=#98c379
" LightlineLeft_command_0_1 xxx ctermfg=76 ctermbg=240 guifg=#98c379 guibg=#3e4452
" LightlineLeft_command_0_tabsel xxx ctermfg=76 ctermbg=66 guifg=#98c379 guibg=#ABB2BF
" LightlineLeft_command_1 xxx ctermfg=145 ctermbg=240 guifg=#abb2bf guibg=#3e4452
" LightlineLeft_command_1_2 xxx ctermfg=240 ctermbg=66 guifg=#3e4452 guibg=#2C323C
" LightlineLeft_command_1_tabsel xxx ctermfg=240 ctermbg=66 guifg=#3e4452 guibg=#ABB2BF
" LightlineLeft_command_2 xxx ctermfg=252 ctermbg=66 guifg=#717785 guibg=#2C323C
" LightlineLeft_command_2_3 xxx ctermfg=66 ctermbg=66 guifg=#2C323C guibg=#2C323C
" LightlineLeft_command_2_tabsel xxx ctermfg=66 ctermbg=66 guifg=#2C323C guibg=#ABB2BF
" LightlineLeft_command_tabsel xxx cterm=bold ctermfg=252 ctermbg=66 gui=bold guifg=#282C33 guibg=#ABB2BF
" LightlineLeft_command_tabsel_0 xxx ctermfg=66 ctermbg=76 guifg=#ABB2BF guibg=#98c379
" LightlineLeft_command_tabsel_1 xxx ctermfg=66 ctermbg=240 guifg=#ABB2BF guibg=#3e4452
" LightlineLeft_command_tabsel_2 xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#2C323C
" LightlineLeft_command_tabsel_3 xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#2C323C
" LightlineLeft_command_tabsel_tabsel xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#ABB2BF
" LightlineRight_command_0 xxx cterm=bold ctermfg=235 ctermbg=76 gui=bold guifg=#282c34 guibg=#98c379
" LightlineRight_command_0_1 xxx ctermfg=76 ctermbg=240 guifg=#98c379 guibg=#3e4452
" LightlineRight_command_0_tabsel xxx ctermfg=76 ctermbg=66 guifg=#98c379 guibg=#ABB2BF
" LightlineRight_command_1 xxx ctermfg=145 ctermbg=240 guifg=#abb2bf guibg=#3e4452
" LightlineRight_command_1_2 xxx ctermfg=240 ctermbg=66 guifg=#3e4452 guibg=#2C323C
" LightlineRight_command_1_tabsel xxx ctermfg=240 ctermbg=66 guifg=#3e4452 guibg=#ABB2BF
" LightlineRight_command_2 xxx ctermfg=252 ctermbg=66 guifg=#717785 guibg=#2C323C
" LightlineRight_command_2_3 xxx ctermfg=66 ctermbg=66 guifg=#2C323C guibg=#2C323C
" LightlineRight_command_2_tabsel xxx ctermfg=66 ctermbg=66 guifg=#2C323C guibg=#ABB2BF
" LightlineRight_command_tabsel xxx cterm=bold ctermfg=252 ctermbg=66 gui=bold guifg=#282C33 guibg=#ABB2BF
" LightlineRight_command_tabsel_0 xxx ctermfg=66 ctermbg=76 guifg=#ABB2BF guibg=#98c379
" LightlineRight_command_tabsel_1 xxx ctermfg=66 ctermbg=240 guifg=#ABB2BF guibg=#3e4452
" LightlineRight_command_tabsel_2 xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#2C323C
" LightlineRight_command_tabsel_3 xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#2C323C
" LightlineRight_command_tabsel_tabsel xxx ctermfg=66 ctermbg=66 guifg=#ABB2BF guibg=#ABB2BF
" LightlineMiddle_command xxx ctermfg=252 ctermbg=66 guifg=#717785 guibg=#2C323C
