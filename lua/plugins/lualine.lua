local function get_rime_status()
  local clients = vim.lsp.get_active_clients()
  for _, client in ipairs(clients) do
    if client.name == "rime_ls" then
      return "ㄓ"
    end
  end
  return ""
end

local battery = require("util.battery")

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    local options = {
      theme = "auto",
      globalstatus = vim.o.laststatus == 3,
      disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
    }
    opts.options = options

    table.insert(opts.sections.lualine_x, {
      function()
        return get_rime_status()
      end,
    })
    table.insert(opts.sections.lualine_y, {
      function()
        return ": " .. battery.get_battery_status() .. " 󰥔 " .. battery.get_battery_time()
      end,
    })
  end,
}
