local make_entry = require('telescope.make_entry')
local entry_display = require('telescope.pickers.entry_display')

local function concate(tables)
  local fusedTable = tables[1]
  for key, value in pairs(tables[2]) do
    fusedTable[key] = value
  end
  return fusedTable
end

local fileTypeIconWidth = 2
local kindIcons = require('hasan.utils.ui.icons').kind
local typeIcons = concate({ kindIcons, require('hasan.utils.ui.icons').type })

local treesitter_type_highlight = {
  ['associated'] = 'TelescopeResultsConstant',
  ['constant'] = 'TelescopeResultsConstant',
  ['field'] = 'TelescopeResultsField',
  ['function'] = 'TelescopeResultsFunction',
  ['method'] = 'TelescopeResultsFunction',
  ['parameter'] = 'TSParameter',
  ['property'] = 'TelescopeResultsOperator',
  ['struct'] = 'TelescopeResultsStruct',
  ['var'] = 'TelescopeResultsVariable',
}
local treesitter_type_icon = {
  ['associated'] = kindIcons.Variable,
  ['constant'] = kindIcons.Constant,
  ['field'] = kindIcons.Field,
  ['function'] = kindIcons.Function,
  ['method'] = kindIcons.Method,
  ['parameter'] = kindIcons.Variable,
  ['property'] = kindIcons.Property,
  ['struct'] = kindIcons.Struct,
  ['var'] = kindIcons.Variable,
}
local function getKindIconTree(entry)
  return treesitter_type_icon[entry.kind:lower()] or 'X'
end

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
local function getKindIcon(entry)
  return typeIcons[entry.symbol_type] or 'X'
end

local pickers = {}

function pickers.prettyTreesitter(localOptions)
  if localOptions ~= nil and type(localOptions) ~= 'table' then
    print('Options must be a table.')
    return
  end

  local opts = localOptions or {}
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()

  local originalEntryMaker = make_entry.gen_from_treesitter(opts)
  local type_highlight = vim.F.if_nil(opts.symbol_highlights, treesitter_type_highlight)

  opts.entry_maker = function(line)
    local originalEntryTable = originalEntryMaker(line)

    local display_items = {
      { width = fileTypeIconWidth },
      { width = opts.symbol_width or 54 },
      { remaining = true },
    }

    if opts.show_line then
      table.insert(display_items, 3, { width = 6 })
    end

    local displayer = entry_display.create({
      separator = ' ',
      items = display_items,
    })

    originalEntryTable.display = function(entry)
      local msg = vim.api.nvim_buf_get_lines(bufnr, entry.lnum, entry.lnum, false)[1] or ''
      msg = vim.trim(msg)

      local display_columns = {
        { getKindIconTree(entry), type_highlight[entry.kind] },
        entry.text,
        { entry.kind, type_highlight[entry.kind], type_highlight[entry.kind] },
        msg,
      }

      if opts.show_line then
        table.insert(display_columns, 3, { entry.lnum .. ':' .. entry.col, 'TelescopeResultsLineNr' })
      end

      return displayer(display_columns)
    end

    return originalEntryTable
  end

  require('telescope.builtin').treesitter(opts)
end

function pickers.prettyDocumentSymbols(localOptions)
  if localOptions ~= nil and type(localOptions) ~= 'table' then
    print('Options must be a table.')
    return
  end

  local options = localOptions or {}

  local originalEntryMaker = make_entry.gen_from_lsp_symbols(options)
  local type_highlight = vim.F.if_nil(options.symbol_highlights, lsp_type_highlight)

  options.entry_maker = function(line)
    local originalEntryTable = originalEntryMaker(line)

    local displayer = entry_display.create({
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

return pickers
