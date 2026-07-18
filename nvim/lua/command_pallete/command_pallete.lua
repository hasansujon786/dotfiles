---@alias CommandGroup { name: string, commands: Command[] }
---@alias Command { [1]: string, [2]: string | fun() }

---@class CommandPalette
---@field snacks_opts snacks.picker.Config
---@field groups CommandGroup[]
---@field select_command fun(self: CommandPalette, commands: Command[], on_back?: fun())
---@field show fun(self: CommandPalette)
---@field _all_commands Command[]
local CommandPalette = {
  snacks_opts = {
    layout = { preset = 'vscode' },
    focus = 'list',
  },
  groups = {},
  _all_commands = {},
}

function CommandPalette:select_command(commands, on_back)
  local function go_back(picker)
    picker:close()
    if on_back then
      vim.schedule(on_back)
    end
  end

  ---@type snacks.picker.Config
  local select_actions = {
    actions = {
      back_or_delete = function(picker)
        if picker.input:get() ~= '' then
          return '<BS>'
        end
        go_back(picker)
      end,
      back = go_back,
    },
    win = {
      input = {
        keys = {
          ['<BS>'] = { 'back_or_delete', mode = 'i', expr = true },
          ['<C-h>'] = { 'back_or_delete', mode = 'i', expr = true },
        },
      },
      list = {
        keys = {
          ['<BS>'] = 'back',
          ['<C-h>'] = 'back',
        },
      },
    },
  }

  vim.ui.select(commands, {
    prompt = 'Select command:',
    snacks = vim.tbl_extend('force', self.snacks_opts, select_actions),
    format_item = function(item)
      return item[1]
    end,
  }, function(command)
    if not command then
      return
    end

    if type(command[2]) == 'function' then
      command[2]()
    elseif type(command[2]) == 'string' then
      vim.cmd(command[2])
    end
  end)
end

function CommandPalette:show()
  vim.ui.select(self.groups, {
    prompt = 'Select category:',
    snacks = self.snacks_opts,
    format_item = function(item)
      return item.name
    end,
  }, function(group)
    if not group then
      return
    end
    self:select_command(group.commands, function()
      self:show()
    end)
  end)
end

function CommandPalette:build_all_commands()
  local all = {}
  for _, group in ipairs(self.groups) do
    for _, cmd in ipairs(group.commands) do
      table.insert(all, {
        label = cmd[1],
        text = cmd[1],
        cmd = cmd[2],
        group = group.name,
      })
    end
  end
  return all
end

function CommandPalette:show_all()
  Snacks.picker.pick({
    items = self._all_commands,
    title = '',
    prompt = '>',
    layout = { preset = 'vscode' },
    format = function(item, ctx)
      local width = ctx.list.win.opts.width
      local total_cols = width - 2

      local ret = {} ---@type snacks.picker.Highlight[]

      local a = Snacks.picker.util.align

      ret[#ret + 1] = { item.label, 'SnacksPickerFile' }
      -- ret[#ret + 1] = { ' ' }

      local text_width = #item.label
      local padding = math.max(0, total_cols - text_width)

      ret[#ret + 1] = { a(item.group, padding, { align = 'right' }), 'SnacksPickerTotals' }
      return ret
    end,
    confirm = function(picker, item)
      picker:close()
      if not item then
        return
      end
      if type(item.cmd) == 'function' then
        item.cmd()
      elseif type(item.cmd) == 'string' then
        vim.cmd(item.cmd)
      end
    end,
  })
end

function CommandPalette:group(name, commands)
  table.insert(self.groups, { name = name, commands = commands })

  for _, cmd in ipairs(commands) do
    table.insert(self._all_commands, {
      label = cmd[1],
      text = cmd[1],
      cmd = cmd[2],
      group = name,
    })
  end
end

return CommandPalette
