return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup({
      settings = {
        save_on_toggle = true,
      },
    })

    vim.keymap.set("n", "<leader>aa", function()
      harpoon:list():add()
    end, { desc = "Harpoon: Add file" })
    vim.keymap.set("n", "<leader>ar", function()
      harpoon:list():remove()
    end, { desc = "Harpoon: Remove file" })
    vim.keymap.set("n", "<leader>ac", function()
      harpoon:list():clear()
    end, { desc = "Harpoon: Clear all" })
    vim.keymap.set("n", "<leader>ao", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon: Toggle quick menu" })

    vim.keymap.set("n", "[a", function()
      harpoon:list():prev()
    end, { desc = "Harpoon: Previous" })
    vim.keymap.set("n", "]a", function()
      harpoon:list():next()
    end, { desc = "Harpoon: Next" })

    vim.keymap.set("n", "<leader>1", function()
      harpoon:list():select(1)
    end, { desc = "Harpoon: Navigate to 1" })
    vim.keymap.set("n", "<leader>2", function()
      harpoon:list():select(2)
    end, { desc = "Harpoon: Navigate to 2" })
    vim.keymap.set("n", "<leader>3", function()
      harpoon:list():select(3)
    end, { desc = "Harpoon: Navigate to 3" })
    vim.keymap.set("n", "<leader>4", function()
      harpoon:list():select(4)
    end, { desc = "Harpoon: Navigate to 4" })
    vim.keymap.set("n", "<leader>5", function()
      harpoon:list():select(5)
    end, { desc = "Harpoon: Navigate to 5" })
  end,
}
