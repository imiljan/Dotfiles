-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/angularls.lua
-- Guard: only attach in workspaces that actually use Angular.

---@type vim.lsp.Config
return {
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, { "angular.json", "nx.json" })
    if not root then
      return
    end

    -- Only attach if the workspace has @angular/core as a dependency
    local pkg_path = vim.fs.joinpath(root, "package.json")
    local stat = vim.uv.fs_stat(pkg_path)
    if not stat then
      return
    end

    local ok, content = pcall(vim.fn.readblob, pkg_path)
    if not ok or not content then
      return
    end

    local json = vim.json.decode(content) or {}
    local deps = json.dependencies or {}
    local dev_deps = json.devDependencies or {}

    if not deps["@angular/core"] and not dev_deps["@angular/core"] then
      return
    end

    on_dir(root)
  end,
}
