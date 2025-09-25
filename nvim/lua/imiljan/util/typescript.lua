local ms = require("vim.lsp.protocol").Methods

local M = {}

-- https://github.com/typescript-language-server/typescript-language-server?tab=readme-ov-file#workspace-commands-workspaceexecutecommand

function M.organize_imports(bufnr)
  -- https://github.com/typescript-language-server/typescript-language-server/blob/master/README.md#organize-imports
  local command_params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(bufnr or 0), { mode = "All" } },
  }

  vim.lsp.buf_request_sync(bufnr or 0, ms.workspace_executeCommand, command_params)
end

function M.go_to_source_definition()
  -- https://github.com/typescript-language-server/typescript-language-server?tab=readme-ov-file#go-to-source-definition
  local params = vim.lsp.util.make_position_params(0, "utf-8")
  local command_params = {
    command = "_typescript.goToSourceDefinition",
    arguments = { params.textDocument.uri, params.position },
  }
  local resp = vim.lsp.buf_request_sync(0, ms.workspace_executeCommand, command_params)

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
    vim.lsp.util.show_document(result[1], "utf-8", { reuse_win = true, focus = true })
  else
    vim.print(err)
    vim.notify(err.error.message, vim.log.levels.ERROR)
  end
end

function M.rename_file()
  -- https://github.com/typescript-language-server/typescript-language-server?tab=readme-ov-file#rename-file
  local source_file = vim.api.nvim_buf_get_name(0)

  vim.ui.input({
    prompt = "Target >  ",
    completion = "file",
    default = source_file,
  }, function(target_file)
    if target_file ~= nil and source_file ~= nil then
      local command_params = {
        command = "_typescript.applyRenameFile",
        arguments = { { sourceUri = source_file, targetUri = target_file } },
      }

      vim.lsp.util.rename(source_file, target_file)
      vim.lsp.buf_request(0, ms.workspace_executeCommand, command_params)
    end
  end)
end

return M
