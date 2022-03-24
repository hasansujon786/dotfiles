-- require('hasan.utils.ui.icons')
local useCodicons = true

-- https://github.com/microsoft/vscode/blob/main/src/vs/base/common/codicons.ts
-- go to the above and then enter <c-v>u<unicode> and the symbold should appear
-- or go here and upload the font file: https://mathew-kurian.github.io/CharacterMap/
-- find more here: https://www.nerdfonts.com/cheat-sheet
-- https://www.chrisatmachine.com/Neovim/26-lsp-symbols/
-- https://code.visualstudio.com/docs/editor/intellisense

if not useCodicons then
  return {
    kind = {
      Function      = '',
      Method        = '',
      Constructor   = '',
      Variable      = '',
      Field         = '',
      TypeParameter = '',
      Constant      = '',
      Class         = 'פּ',
      Interface     = '蘒',
      Struct        = '',
      Event         = '',
      Operator      = '',
      Module        = '',
      Property      = '',
      Value         = '',
      Enum          = '',
      EnumMember    = '',
      Reference     = '',
      Keyword       = '',
      File          = '',
      Folder        = '',
      Color         = '',
      Unit          = '',
      Snippet       = '',
      Text          = '',
    },
    type = {
      Array   = '',
      Number  = '',
      String  = '',
      Boolean = '蘒',
      Object  = '',
    },
    documents = {
      File       = '',
      Files      = '',
      Folder     = '',
      OpenFolder = '',
    },
    git = {
      Add    = '',
      Mod    = '',
      Remove = '',
      Ignore = '',
      Rename = '',
      Diff   = '',
      Repo   = '',
    },
    ui = {
      Lock      = '',
      Close     = '',
      NewFile   = '',
      Search    = '',
      Lightbulb = '',
      Project   = '',
      Dashboard = '',
      History   = '',
      Comment   = '',
      Bug       = '',
      Code      = '',
      Telescope = '',
      Gear      = '',
      Package   = '',
      List      = '',
      SignIn    = '',
      Check     = '',
      Fire      = '',
      Note      = '',
      BookMark  = '',
      Pencil    = '',
      Table     = '',
      Calendar  = '',
      Circle    = '',
      BigCircle = '',
      BigUnfilledCircle = '',
      ChevronRight = '>',
    },
    diagnostics = {
      Error = '',
      Warn  = '',
      Info  = '',
      Ques  = '',
      Hint  = '',
    },
    misc = {
      Robot    = 'ﮧ',
      Squirrel = '',
      Tag      = '',
      Watch    = '',
    },
  }
else
  return {
    kind = {
      Function      = '',
      Method        = '',
      Constructor   = '',
      Variable      = '',
      Field         = '',
      TypeParameter = '',
      Constant      = '',
      Class         = '',
      Interface     = '',
      Struct        = '',
      Event         = '',
      Operator      = '',
      Module        = '',
      Property      = '',
      Value         = '',
      Enum          = '',
      EnumMember    = '',
      Reference     = '',
      Keyword       = '',
      File          = '',
      Folder        = '',
      Color         = '',
      Unit          = '',
      Snippet       = '',
      Text          = '',
      -- Misc          = '',
    },
    type = {
      Array   = '',
      Number  = '',
      String  = '',
      Boolean = '',
      Object  = '',
    },
    documents = {
      File       = '',
      Files      = '',
      Folder     = '',
      OpenFolder = '',
    },
    git = {
      Add    = '',
      Mod    = '',
      Remove = '',
      Ignore = '',
      Rename = '',
      Diff   = '',
      Repo   = '',
    },
    ui = {
      Lock      = '',
      Close     = '',
      NewFile   = '',
      Search    = '',
      Lightbulb = '',
      Project   = '',
      Dashboard = '',
      History   = '',
      Comment   = '',
      Bug       = '',
      Code      = '',
      Telescope = '',
      Gear      = '',
      Package   = '',
      List      = '',
      SignIn    = '',
      Check     = '',
      Fire      = '',
      Note      = '',
      BookMark  = '',
      Pencil    = '',
      Table     = '',
      Calendar  = '',
      Circle    = '',
      BigCircle = '',
      BigUnfilledCircle = '',
      ChevronRight = '',
    },
    diagnostics = {
      Error = '',
      Warn  = '',
      Info  = '',
      Ques  = '',
      Hint  = '',
    },
    misc = {
      Robot    = '',
      Squirrel = '',
      Tag      = '',
      Watch    = '',
    },
  }
end
