local function get_rime_status()
  local clients = vim.lsp.get_active_clients()
  for _, client in ipairs(clients) do
    if client.name == "rime_ls" then
      return "ㄓ"
    end
  end
  return ""
end

local function get_battery_status()
  local handle = io.popen("pmset -g batt")
  if handle == nil then
    return "N/A"
  end
  local result = handle:read("*a")
  handle:close()
  if result == nil then
    return "N/A"
  end
  local battery_percentage = result:match("(%d+)%%")
  return battery_percentage or "N/A"
end

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
        return ": " .. get_battery_status()
      end,
    })
  end,
}
