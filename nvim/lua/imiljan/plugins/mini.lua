return {
  "echasnovski/mini.nvim",
  config = function()
    -- Better Around/Inside textobjects
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    --
    -- -- Main textobject prefixes
    -- around = 'a',
    -- inside = 'i',
    --
    -- -- Next/last variants
    -- around_next = 'an',
    -- inside_next = 'in',
    -- around_last = 'al',
    -- inside_last = 'il',
    --
    -- -- Move cursor to corresponding edge of `a` textobject
    -- goto_left = 'g[',
    -- goto_right = 'g]',
    require("mini.ai").setup({ n_lines = 500 })

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    --
    --  add = 'sa', -- Add surrounding in Normal and Visual modes
    --  delete = 'sd', -- Delete surrounding
    --  find = 'sf', -- Find surrounding (to the right)
    --  find_left = 'sF', -- Find surrounding (to the left)
    --  highlight = 'sh', -- Highlight surrounding
    --  replace = 'sr', -- Replace surrounding
    --  update_n_lines = 'sn', -- Update `n_lines`
    --
    --  suffix_last = 'l', -- Suffix to search with "prev" method
    --  suffix_next = 'n', -- Suffix to search with "next" method
    require("mini.surround").setup({ n_lines = 100 })

    -- require("mini.pairs").setup()
  end,
}
