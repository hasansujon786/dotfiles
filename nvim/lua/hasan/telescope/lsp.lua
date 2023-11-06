local telescopeMakeEntryModule = require('telescope.make_entry')
local telescopeEntryDisplayModule = require('telescope.pickers.entry_display')

local telescopePickers = {}

local fileTypeIconWidth = 2

local treesitter_type_highlight = {
  ['associated'] = 'TSConstant',
  ['constant'] = 'TSConstant',
  ['field'] = 'TSField',
  ['function'] = 'TSFunction',
  ['method'] = 'TSMethod',
  ['parameter'] = 'TSParameter',
  ['property'] = 'TSProperty',
  ['struct'] = 'Struct',
  ['var'] = 'TSVariableBuiltin',
}

local lsp_type_highlight = {
  ['Class'] = 'TelescopeResultsClass',
  ['Constant'] = 'TelescopeResultsConstant',
  ['Field'] = 'TelescopeResultsField',
  ['Function'] = 'TelescopeResultsFunction',
  ['Method'] = 'TelescopeResultsMethod',
  ['Property'] = 'TelescopeResultsOperator',
  ['Struct'] = 'TelescopeResultsStruct',
  ['Variable'] = 'TelescopeResultsVariable',
}

local function concate(tables)
  local fusedTable = tables[1]
  for key, value in pairs(tables[2]) do
    fusedTable[key] = value
  end
  return fusedTable
end

local typeIcons = concate({ require('hasan.utils.ui.icons').kind, require('hasan.utils.ui.icons').type })
local function getKindIcon(entry)
  return typeIcons[(entry.symbol_type:lower():gsub('^%l', string.upper))]
end

function telescopePickers.prettyDocumentSymbols(localOptions)
  if localOptions ~= nil and type(localOptions) ~= 'table' then
    print('Options must be a table.')
    return
  end

  local options = localOptions or {}

  local originalEntryMaker = telescopeMakeEntryModule.gen_from_lsp_symbols(options)
  local type_highlight = vim.F.if_nil(options.symbol_highlights, lsp_type_highlight)

  options.entry_maker = function(line)
    local originalEntryTable = originalEntryMaker(line)

    local displayer = telescopeEntryDisplayModule.create({
      separator = ' ',
      items = {
        { width = fileTypeIconWidth },
        { width = 50 },
        { remaining = true },
      },
    })

    originalEntryTable.display = function(entry)
      return displayer({
        { getKindIcon(entry), type_highlight[entry.symbol_type] },
        entry.symbol_name,
        { entry.symbol_type:lower(), type_highlight[entry.symbol_type] },
      })
    end

    return originalEntryTable
  end

  require('telescope.builtin').lsp_document_symbols(options)
end

return telescopePickers
