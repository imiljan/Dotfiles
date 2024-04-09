return {
  { "tpope/vim-fugitive" },
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

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]h", function()
            if vim.wo.diff then
              return "]h"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Next hunk" })

          map("n", "[h", function()
            if vim.wo.diff then
              return "[h"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Prev hunk" })

          map("n", "<leader>hs", gs.stage_hunk, { desc = "HUNK: stage" })
          map("n", "<leader>hr", gs.reset_hunk, { desc = "HUNK: reset" })
          map("v", "<leader>hs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "HUNK: stage" })
          map("v", "<leader>hr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "HUNK: reset" })

          map("n", "<leader>hS", gs.stage_buffer, { desc = "HUNK: stage buffer" })
          map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "HUNK: undo stage" })
          map("n", "<leader>hR", gs.reset_buffer, { desc = "HUNK: reset buffer" })
          map("n", "<leader>hp", gs.preview_hunk, { desc = "HUNK: preview" })
          map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
          end, { desc = "HUNK: blame line" })
          map("n", "<leader>htb", gs.toggle_current_line_blame, { desc = "HUNK: toggle current line blame" })
          map("n", "<leader>hd", gs.diffthis, { desc = "HUNK: diff" })
          map("n", "<leader>hD", function()
            gs.diffthis("~")
          end, { desc = "HUNK: diff file" })
          map("n", "<leader>htd", gs.toggle_deleted, { desc = "HUNK: toggle deleted" })

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
        end,
      })
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
    keys = { { "<leader>lg", ":LazyGit<CR>", desc = "Open LazyGit" } },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
