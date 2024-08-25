local M = {}

-- https://github.com/typescript-language-server/typescript-language-server?tab=readme-ov-file#workspace-commands-workspaceexecutecommand
function M.organize_imports(bufnr)
  -- https://github.com/typescript-language-server/typescript-language-server/blob/master/README.md#organize-imports
  vim.lsp.buf_request_sync(bufnr or 0, "workspace/executeCommand", {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(bufnr or 0), { mode = "All" } },
    title = "TypeScript Organize Imports",
  })
end

function M.go_to_source_definition()
  local resp = vim.lsp.buf_request_sync(0, "workspace/executeCommand", {
    command = "_typescript.goToSourceDefinition",
    arguments = { vim.api.nvim_buf_get_name(0), vim.lsp.util.make_position_params().position },
    title = "TypeScript Go To Source Definition",
  })

  if resp == nil then
    vim.notify("_typescript.goToSourceDefinition returned nil", vim.log.levels.ERROR)
    return
  end

  local result = nil
  local err = nil
  if resp[1]["result"] ~= nil then
    print(1)
    result = resp[1]["result"]
    err = resp[2]
  else
    print(2)
    err = resp[1]
    result = resp[2]["result"]
  end

  if result ~= nil then
    vim.lsp.util.jump_to_location(result[1], "utf-8", true)
  else
    vim.print(err)
    vim.notify(err.message, vim.log.levels.ERROR)
  end
end

function M.rename_file()
  local source_file = vim.api.nvim_buf_get_name(0)

  vim.ui.input({
    prompt = "Target >  ",
    completion = "file",
    default = source_file,
  }, function(target_file)
    if target_file ~= nil and source_file ~= nil then
      vim.lsp.util.rename(source_file, target_file)
      vim.lsp.buf.execute_command({
        command = "_typescript.applyRenameFile",
        arguments = { { sourceUri = source_file, targetUri = target_file } },
        title = "TypeScript Rename File",
      })
    end
  end)
end

return M
