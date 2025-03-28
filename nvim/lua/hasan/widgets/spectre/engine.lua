local spectre_search = require('spectre.search')
local spectre_state = require('spectre.state')
local spectre_state_utils = require('spectre.state_utils')
local spectre_utils = require('spectre.utils')

local Tree = require('nui.tree')
local fn = require('utils.fn')

local M = {}

function M.process(options)
  options = options or {}

  return fn.kmap(spectre_state.groups, function(group, filename)
    local children = fn.imap(group, function(entry)
      local id = tostring(math.random())

      local diff = spectre_utils.get_hl_line_text({
        search_query = options.search_query,
        replace_query = options.replace_query,
        search_text = entry.text,
        padding = 0,
      }, spectre_state.regex)

      return Tree.Node({ text = diff.text, _id = id, diff = diff, entry = entry })
    end)

    local id = tostring(math.random())
    local node = Tree.Node({ text = filename:gsub('^./', ''), _id = id }, children)

    node:expand()

    return node
  end)
end

local function search_handler(options, signal)
  local start_time = 0
  local total = 0

  spectre_state.groups = {}

  return {
    on_start = function()
      spectre_state.is_running = true
      start_time = vim.loop.hrtime()
    end,
    on_result = function(item)
      if not spectre_state.is_running then
        return
      end

      if not spectre_state.groups[item.filename] then
        spectre_state.groups[item.filename] = {}
      end

      table.insert(spectre_state.groups[item.filename], item)
      total = total + 1
    end,
    on_error = function(_) end,
    on_finish = function()
      if not spectre_state.is_running then
        return
      end

      local end_time = (vim.loop.hrtime() - start_time) / 1E9

      signal.search_results = M.process(options)
      signal.search_info = string.format('Total: %s match, time: %ss', total, end_time)

      spectre_state.finder_instance = nil
      spectre_state.is_running = false
    end,
  }
end

function M.stop()
  if not spectre_state.finder_instance then
    return
  end

  spectre_state.finder_instance:stop()
  spectre_state.finder_instance = nil
end

function M.search(options, signal)
  options = options or {}

  M.stop()

  local search_engine = spectre_search['rg']
  spectre_state.options['ignore-case'] = not options.is_match_case_insensitive_checked
  spectre_state.finder_instance =
    search_engine:new(spectre_state_utils.get_search_engine_config(), search_handler(options, signal))
  spectre_state.regex = require('spectre.regex.vim')

  pcall(function()
    spectre_state.finder_instance:search({
      -- the directory where the search tool will be started in
      cwd = vim.fn.getcwd(),
      search_text = options.search_query,
      replace_query = options.replace_query,
      -- the pattern of files to consider for searching
      path = #options.filter_path > 2 and options.filter_path or nil,
      -- the directories or files to search in
      search_paths = #options.search_paths > 0 and options.search_paths or nil,
    })
  end)
end

local function replace_handler(tree, node)
  return {
    on_done = function(result)
      if result.ref then
        node.ref = result.ref
        tree:render()
      end
    end,
    on_error = function(_) end,
  }
end

M.run_replace = function(entries, tree, search_query, replace_query)
  local replacer_creator = spectre_state_utils.get_replace_creator()

  for _, text_node in ipairs(entries) do
    local replacer =
      replacer_creator:new(spectre_state_utils.get_replace_engine_config(), replace_handler(tree, text_node))

    local entry = text_node.entry

    replacer:replace({
      lnum = entry.lnum,
      col = entry.col,
      cwd = vim.fn.getcwd(),
      display_lnum = 0,
      filename = entry.filename,
      search_text = search_query,
      replace_text = replace_query,
    })
  end
end

return M
