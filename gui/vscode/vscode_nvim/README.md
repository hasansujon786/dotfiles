https://github.com/Axlefublr/dotfiles/blob/main/init.lua
https://github.com/microsoft/vscode-docs/blob/main/docs/getstarted/tips-and-tricks.md
https://github.com/initialrise/vscode-vim-dotfiles

```lua
signature_help = "editor.action.triggerParameterHints",
code_action = "editor.action.sourceAction",
api.nvim_create_autocmd({ "CmdlineChanged" }, {
  group = api.nvim_create_augroup("vscode.inccommand", {}),
  callback = function()
    vim.schedule(refresh_completion)
  end,
})

-- Comment or uncomment lines using Commentary
keymap({ 'n', 'x', 'o' }, 'gc', '<Plug>VSCodeCommentary')
keymap('n', 'gcc', '<Plug>VSCodeCommentaryLine')

-- keymap({ 'n', 'x' }, '<leader>r', function()
--   vscode.with_insert(function()
--     vscode.action('editor.action.refactor')
--   end)
-- end)

local map = {
  hover = "editor.action.showHover",
  declaration = "editor.action.peekDeclaration",
  definition = "editor.action.peekDefinition",
  type_definition = "editor.action.peekTypeDefinition",
  implementation = "editor.action.peekImplementation",
  signature_help = "editor.action.triggerParameterHints",
  completion = "editor.action.triggerSuggest",
  format = "editor.action.formatDocument",
  rename = "editor.action.rename",
  references = "editor.action.referenceSearch.trigger",
  document_symbol = "workbench.action.gotoSymbol",
  incoming_calls = "editor.showIncomingCalls",
  outgoing_calls = "editor.showOutgoingCalls",
  ---@param kind "subtypes"|"supertypes"
  typehierarchy = function(kind)
    local cmd
    if kind == "subtypes" then
      cmd = "editor.showSubtypes"
    elseif kind == "supertypes" then
      cmd = "editor.showSupertypes"
    else
      cmd = "editor.showTypeHierarchy"
    end
    vscode.action(cmd)
  end,
  list_workspace_folders = function()
    return vscode.eval("return (vscode.workspace.workspaceFolders || []).map((folder) => folder.name);")
  end,
  add_workspace_folder = "workbench.action.addRootFolder",
  remove_workspace_folder = "workbench.action.removeRootFolder",
  workspace_symbol = function(query)
    vscode.action("workbench.action.quickOpen", { args = { "#" .. (query or "") } })
  end,
  document_highlight = "editor.action.wordHighlight.trigger",
  clear_references = vim.NIL,
  code_action = "editor.action.sourceAction",
  execute_command = vim.NIL,
}
```
