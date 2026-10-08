local M = {}

function M.copy_path_snacks(_, item)
  local modify = vim.fn.fnamemodify
  local filepath = item.file
  local filename = modify(filepath, ":t")
  local values = {
    filepath,
    modify(filepath, ":."),
    modify(filepath, ":~"),
    filename,
    modify(filename, ":r"),
    modify(filename, ":e"),
  }
  -- vim.print(vim.inspect(values))
  local items = {
    "Absolute path: " .. values[1],
    "Path relative to CWD: " .. values[2],
    "Path relative to HOME: " .. values[3],
    "Filename: " .. values[4],
  }
  if vim.fn.isdirectory(filepath) == 0 then
    vim.list_extend(items, {
      "Filename without extension: " .. values[5],
      "Extension of the filename: " .. values[6],
    })
  end
  vim.ui.select(items, { prompt = "Choose to copy to clipboard:" }, function(choice, i)
    if not choice then
      vim.notify("Selection cancelled")
      return
    end
    if not i then
      vim.notify("Invalid selection")
      return
    end
    local result = values[i]
    vim.fn.setreg('"', result) -- Neovim unnamed register
    vim.fn.setreg("+", result) -- System clipboard
    vim.notify("Copied: " .. result)
  end)
end

function M.copy_path(state)
  -- NeoTree is based on [NuiTree](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree)
  -- The node is based on [NuiNode](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree#nuitreenode)
  local node = state.tree:get_node()
  local filepath = node:get_id()
  local filename = node.name
  local modify = vim.fn.fnamemodify

  local results = {
    filepath,
    modify(filepath, ":."),
    modify(filepath, ":~"),
    filename,
    modify(filename, ":r"),
    modify(filename, ":e"),
  }

  vim.ui.select({
    "1. Absolute path: " .. results[1],
    "2. Path relative to CWD: " .. results[2],
    "3. Path relative to HOME: " .. results[3],
    "4. Filename: " .. results[4],
    "5. Filename without extension: " .. results[5],
    "6. Extension of the filename: " .. results[6],
  }, { prompt = "Choose to copy to clipboard:" }, function(choice)
    if choice then
      local i = tonumber(choice:sub(1, 1))
      if i then
        local result = results[i]
        vim.fn.setreg('"', result) -- set the default register
        vim.fn.setreg("+", result) -- set the clipboard register
        vim.notify("Copied: " .. result)
      else
        vim.notify("Invalid selection")
      end
    else
      vim.notify("Selection cancelled")
    end
  end)
end

return M
