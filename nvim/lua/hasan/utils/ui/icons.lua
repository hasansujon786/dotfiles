-- require('hasan.utils.ui.icons')
local useCodicons = true

-- https://github.com/ecosse3/nvim
local other = {
  abc                 = '',
  arrowReturn         = '',
  bomb                = '',
  box                 = '',
  buffer              = '﬘',
  calculator          = '',
  calculator2         = '',
  SquareEmpty         = '',
  SquareFull          = '',
  SquareCheck         = '',
  SquareCheck2        = '',
  container           = '',
  cubeTree            = '',
  curlies             = '',
  database            = '﬘',
  emptyBox            = '',
  errorSlash          = 'ﰸ',
  f                   = '',
  fileBg              = '',
  fileCopy            = '',
  fileCutCorner       = '',
  fileNoBg            = '',
  fileNoLines         = '',
  fileNoLinesBg       = '',
  FolderNoBg          = '',
  FolderOpen2         = 'ﱮ',
  FolderOpenNoBg      = '',
  ellipsis            = '…',
  File                = '',
  File2               = '',
  FileReference       = '',
  Files               = '',
  FindFile            = '',
  FileSymlink         = '',
  FolderEmpty         = '',
  FolderOpenEmpty     = '',
  Folder              = '',
  FolderOpen          = '',
  FolderSymlink       = '',
  gears               = '',
  gitAdd              = '',
  gitChange           = '柳',
  gitRemove           = '',
  happyFace           = 'ﲃ',
  hexCutOut           = '',
  info                = '',
  infoOutline         = '',
  key                 = '',
  light               = '',
  lightbulb           = '',
  lightbulbOutline    = '',
  m                   = 'm',
  numbers             = '',
  paint               = '',
  paragraph           = '',
  pencil              = '',
  pie                 = '',
  ribbon              = '',
  ribbonNoBg          = '',
  ruler               = '',
  scissors            = '',
  scope               = '',
  search              = '',
  search2             = '',
  settings            = '',
  settings2           = '',
  sort                = '',
  spell               = '暈',
  snippet             = '',
  t                   = '',
  terminal            = '',
  threeDots           = '',
  threeDotsBoxed      = '',
  timer               = '',
  tree                = '',
  treeDiagram         = '',
  vim                 = '',
  wrench              = '',
  clouldCode          = 'ﲳ',
  flowerOrg           = '✿',
  heart               = '♥',
  circleBg            = '●',
  circleOutline       = '○',
  circleOutline2      = '◉',
  startBg             = '',
  asterisk            = '✸',
  loading             = '',
  hash                = '',
  disk                = '',
  disk2               = '',
  wathc               = '',
  lock                = '',
  lock2               = '',
  ArrowCircleDown     = '',
  ArrowCircleLeft     = '',
  ArrowCircleRight    = '',
  ArrowCircleUp       = '',
  BoldArrowDown       = '',
  BoldArrowLeft       = '',
  BoldArrowRight      = '',
  BoldArrowUp         = '',
  BoxChecked          = '',
  ChevronShortUp      = '',
  ChevronShortDown    = '',
  ChevronShortLeft    = '',
  ChevronShortRight   = '',
  DoubleChevronRight  = '',
  DoubleChevronLeft   = '«',
  DoubleChevronUp     = '',
  DoubleChevronDown   = '',
  Stacks              = '',
  Scopes              = '',
  Watches             = '',
  DebugConsole        = '',
  Plus                = '',
  Project             = '',
  Tab                 = '',
  Target              = '',
  Text                = '',
  Tree                = '',
  UrlLink             = '',
  Taskmanagement      = '陼',
  Newspaper           = '',
  NoteEdit            = '',
  GitHub              = '',
  Monitoring          = '',
  Globe               = '',
  Frozen              = '',
  diagnostics = {
    Error = '',
    Warn  = '',
    Info  = '',
    Ques  = '', -- 
    Hint  = '',
    Ok    = '',
  },
}

-- nerdicons
local nerdicons =  {
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
    Array   = '',
    Number  = '#',
    String  = '',
    Boolean = '⊨',
    Object  = '',
  },
  documents = {
    File       = '',
    Files      = '',
    Folder     = '',
    OpenFolder = '',
  },
  git = {
    Add      = '',
    Mod      = '',
    Remove   = '',
    Ignore   = '',
    Rename   = '',
    Diff     = '',
    Repo     = '',
    Octoface = '',
    Branch   = '',
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
    Bug       = '', -- 
    Code      = '',
    Telescope = '',
    Gear      = '',
    Package   = '',
    List      = '',
    SignIn    = '',
    SignOut   = '',
    Check     = '',
    Fire      = '',
    Note      = '',
    BookMark  = '',
    Pencil    = '',
    Trash     = '',
    Table     = '',
    Calendar  = '',
    Circle    = '',
    BigCircle = '',
    BigUnfilledCircle = '',
    CloudDownload = '',
    NoteBook      = '',
    ChevronLeft   = '',
    ChevronUp     = '',
    ChevronRight  = '',
    ChevronDown   = '',
  },
  diagnostics = {
    Error = '',
    Warn  = '',
    Info  = '',
    Ques  = '',
    Hint  = '',
    -- hint = '󱤅 ',
    -- other = '󰠠 ',
  },
  misc = {
    Robot    = 'ﮧ',
    Squirrel = '',
    Tag      = '',
    Watch    = '',
  },
  Other = other,
}

-- codicons
local codicons = {
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
    Add      = '',
    Mod      = '',
    Remove   = '',
    Ignore   = '',
    Rename   = '',
    Diff     = '',
    Repo     = '',
    Octoface = '',
    Branch   = '',
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
    SignOut   = '',
    Check     = '',
    Fire      = '',
    Note      = '',
    BookMark  = '',
    Pencil    = '',
    Trash     = '',
    Table     = '',
    Calendar  = '',
    Circle    = '',
    BigCircle = '',
    BigUnfilledCircle = '',
    CloudDownload = '',
    NoteBook      = '',
    ChevronLeft   = '',
    ChevronUp     = '',
    ChevronRight  = '',
    ChevronDown   = '',
  },
  diagnostics = {
    Error = '',-- 
    Warn  = '',
    Info  = '',-- 
    Ques  = '',
    Hint  = '', --  ,
  },
  misc = {
    Robot    = '',
    Squirrel = '',
    Tag      = '',
    Watch    = '',
  },
  Other = other,
}

return useCodicons and codicons or nerdicons
