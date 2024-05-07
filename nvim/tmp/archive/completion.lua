-- cmp treesitter
-- https://github.com/xzbdmw/nvimconfig/blob/6829ce4aee6b2a3987c489bdf8553b5f37e519b9/lua/plugins/cmp.lua#L580

--[[
  Get completion context, such as namespace where item is from.
  Depending on the LSP, this information is stored in different places.
  The process to find them is very manual: log the payloads And see where useful information is stored.

  See https://www.reddit.com/r/neovim/comments/128ndxk/comment/jen9444/?utm_source=share&utm_medium=web2x&context=3
]]
local function get_lsp_completion_context(completion, source)
  local ok, source_name = pcall(function()
    return source.source.client.config.name
  end)
  if not ok then
    return nil
  end

  if source_name == 'tsserver' then
    return completion.detail
  elseif source_name == 'pyright' and completion.labelDetails ~= nil then
    return completion.labelDetails.description
  elseif source_name == 'texlab' then
    return completion.detail
  elseif source_name == 'clangd' then
    local doc = completion.documentation
    if doc == nil then
      return
    end

    local import_str = doc.value

    local i, j = string.find(import_str, '["<].*[">]')
    if i == nil then
      return
    end

    return string.sub(import_str, i, j)
  end
end

function format(entry, vim_item)
  local ELLIPSIS_CHAR = '…'
  if not require('cmp.utils.api').is_cmdline_mode() then
    local abbr_width_max = 25
    local menu_width_max = 20

    local item = require('lspkind').cmp_format({
      ellipsis_char = ELLIPSIS_CHAR,
      maxwidth = abbr_width_max,
      mode = 'symbol',
    })(entry, vim_item)

    item.abbr = vim.trim(item.abbr)

    -- give padding until min/max width is met
    -- https://github.com/hrsh7th/nvim-cmp/issues/980#issuecomment-1121773499
    local abbr_width = string.len(item.abbr)
    if abbr_width < abbr_width_max then
      local padding = string.rep(' ', abbr_width_max - abbr_width)
      vim_item.abbr = item.abbr .. padding
    end

    local cmp_ctx = get_lsp_completion_context(entry.completion_item, entry.source)
    if cmp_ctx ~= nil and cmp_ctx ~= '' then
      item.menu = cmp_ctx
    else
      item.menu = ''
    end

    local menu_width = string.len(item.menu)
    if menu_width > menu_width_max then
      item.menu = vim.fn.strcharpart(item.menu, 0, menu_width_max - 1)
      item.menu = item.menu .. ELLIPSIS_CHAR
    else
      local padding = string.rep(' ', menu_width_max - menu_width)
      item.menu = padding .. item.menu
    end

    return item
  else
    local abbr_width_min = 20
    local abbr_width_max = 50

    local item = require('lspkind').cmp_format({
      ellipsis_char = ELLIPSIS_CHAR,
      maxwidth = abbr_width_max,
      mode = 'symbol',
    })(entry, vim_item)

    item.abbr = vim.trim(item.abbr)

    -- give padding until min/max width is met
    -- https://github.com/hrsh7th/nvim-cmp/issues/980#issuecomment-1121773499
    local abbr_width = string.len(item.abbr)
    if abbr_width < abbr_width_min then
      local padding = string.rep(' ', abbr_width_min - abbr_width)
      vim_item.abbr = item.abbr .. padding
    end

    return item
  end
end
