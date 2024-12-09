local battery = require("util.battery")
local rime = require("util.rime_ls")
local dashboard = { "dashboard", "alpha", "ministarter", "snacks_dashboard" }

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    local options = {
      theme = "auto",
      globalstatus = vim.o.laststatus == 3,
      disabled_filetypes = { statusline = dashboard },
      section_separators = { right = "", left = "" },
      component_separators = { left = "󰩃 ", right = "󰄛 " },
    }
    opts.options = options
    table.insert(opts.sections.lualine_y, {
      function()
        -- return rime.check_rime_status()
        return rime.setup_autocmd()
      end,
    })
    table.insert(opts.sections.lualine_y, {
      function()
        return "  " .. battery.get_battery_status() .. " 󰥔  " .. battery.get_battery_time()
      end,
    })
  end,
}
