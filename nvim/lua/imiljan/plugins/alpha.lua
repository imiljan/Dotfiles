return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                     ]],
      [[       ████ ██████           █████      ██                     ]],
      [[      ███████████             █████                             ]],
      [[      █████████ ███████████████████ ███   ███████████   ]],
      [[     █████████  ███    █████████████ █████ ██████████████   ]],
      [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
      [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
      [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
    }

    -- default https://github.com/goolord/alpha-nvim/blob/main/lua/alpha/themes/dashboard.lua
    dashboard.section.buttons.val = {
      dashboard.button("e", "  New file", "<cmd>ene <CR>"),
      dashboard.button("<C-p>", "󰈞  Git files"),
      dashboard.button("SPC s f", "󰈞  Find files"),
      dashboard.button("SPC s g", "󰈬  Find word"),
      dashboard.button("SPC s .", "󰊄  Recently opened files"),
      dashboard.button("SPC s m", "  Jump to marks"),
      dashboard.button("SPC q l", "  Open last session"),
      dashboard.button("SPC s n", "  Config"),
    }

    alpha.setup(dashboard.config)
  end,
}
