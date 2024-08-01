return {
  { "tpope/vim-fugitive", cmd = { "G", "Git" } },
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
    keys = { { "<leader>lg", ":LazyGit<CR>", desc = "Open LazyGit" } },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          vim.keymap.set("n", "]h", function()
            if vim.wo.diff then
              return "]h"
            end

            vim.schedule(function()
              gs.next_hunk()
            end)

            return "<Ignore>"
          end, { buffer = bufnr, expr = true, desc = "HUNK: Next" })

          vim.keymap.set("n", "[h", function()
            if vim.wo.diff then
              return "[h"
            end

            vim.schedule(function()
              gs.prev_hunk()
            end)

            return "<Ignore>"
          end, { buffer = bufnr, expr = true, desc = "HUNK: Prev" })

          vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "HUNK: preview" })

          vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { buffer = bufnr, desc = "HUNK: stage" })
          vim.keymap.set("v", "<leader>hs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { buffer = bufnr, desc = "HUNK: stage" })
          vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { buffer = bufnr, desc = "HUNK: reset" })
          vim.keymap.set("v", "<leader>hr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { buffer = bufnr, desc = "HUNK: reset" })

          vim.keymap.set("n", "<leader>hS", gs.stage_buffer, { buffer = bufnr, desc = "HUNK: stage buffer" })
          vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, { buffer = bufnr, desc = "HUNK: undo stage" })
          vim.keymap.set("n", "<leader>hR", gs.reset_buffer, { buffer = bufnr, desc = "HUNK: reset buffer" })
          vim.keymap.set("n", "<leader>hb", function()
            gs.blame_line({ full = true })
          end, { buffer = bufnr, desc = "HUNK: blame line" })
          vim.keymap.set("n", "<leader>hd", gs.diffthis, { buffer = bufnr, desc = "HUNK: diff" })
          vim.keymap.set("n", "<leader>hD", function()
            gs.diffthis("~")
          end, { buffer = bufnr, desc = "HUNK: diff file" })

          vim.keymap.set(
            "n",
            "<leader>htb",
            gs.toggle_current_line_blame,
            { buffer = bufnr, desc = "HUNK: toggle current line blame" }
          )
          vim.keymap.set("n", "<leader>htd", gs.toggle_deleted, { buffer = bufnr, desc = "HUNK: toggle deleted" })

          -- Text object
          vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "HUNK: Select hunk" })
        end,
      })
    end,
  },
}
