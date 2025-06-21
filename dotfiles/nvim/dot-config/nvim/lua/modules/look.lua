-- vim.o.termguicolors = true

local neopywal = require("neopywal")
neopywal.setup()

-- always use the dark theme
-- that is because the light theme and auto mode will flip fg and bg colors
-- that is already taken care of by the custom pywal16 script that
-- sets the colorscheme wal-reload.sh
local auto_dark_mode = require("auto-dark-mode")
auto_dark_mode.setup({
    set_dark_mode = function()
        vim.api.nvim_set_option_value("background", "dark", {})
        vim.cmd[[colorscheme neopywal-dark]]
    end,
    set_light_mode = function()
        vim.api.nvim_set_option_value("background", "light", {})
        vim.cmd[[colorscheme neopywal-dark]]
    end,
    update_interval = 1000, -- in milliseconds
    fallback = "dark",
})

auto_dark_mode.init()

require("twilight").setup()
