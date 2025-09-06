-- Create some toggle mappings
Snacks.toggle.line_number():map('<leader>tn')
Snacks.toggle.option('cursorcolumn', { name = 'Cursorcolumn' }):map('<leader>tC')
Snacks.toggle.option('cursorline', { name = 'Cursorline' }):map('<leader>tL')
Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>ts')
Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>tw')
Snacks.toggle
  .option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
  :map('<leader>to')
Snacks.toggle.inlay_hints():map('<leader>th')
Snacks.toggle.treesitter({ name = 'Treesitter' }):map('<leader>tT')
Snacks.toggle.indent():map('<leader>ti')
Snacks.toggle.dim():map('<leader>tm')
Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map('<leader>tB')
Snacks.toggle.diagnostics():map('<leader>td')
Snacks.toggle({
  name = 'Diagnostic Lines',
  get = function()
    return vim.diagnostic.config().virtual_text
  end,
  set = function(st)
    return vim.diagnostic.config({ virtual_text = st })
  end,
}):map('<leader>tl')

Snacks.toggle({
  name = 'Transparency',
  get = function()
    return require('core.state').theme.transparency
  end,
  set = function(_)
    require('hasan.utils.color').toggle_transparency(false)
  end,
}):map('<leader>tb')

Snacks.toggle({
  name = 'Highlight same words',
  get = function()
    return type(vim.w.auto_highlight_id) == 'number'
  end,
  set = function(state)
    vim.fn['autohl#_AutoHighlightToggle']()
  end,
}):map('<leader>tW')

Snacks.toggle({
  name = 'TSContext',
  get = function()
    return require('treesitter-context').enabled
  end,
  set = function(state)
    if state then
      require('treesitter-context').enable()
    else
      require('treesitter-context').disable()
    end
  end,
}):map('<leader>t-')
