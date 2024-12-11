local battery = require("util.battery")
local rime = require("util.rime_ls")
local dashboard = { "dashboard", "alpha", "ministarter", "snacks_dashboard" }
local tex = require("util.latex")

-- local function rime_toggle_color()
--   if rime.check_rime_status() and rime_toggled == true then
--     return { bg = "#74c7ec", fg = "#313244", gui = "bold" }
--   elseif rime_toggled == false and rime_ls_active == true and tex.in_text() == false then
--     return { bg = "#fab387", fg = "#313244", gui = "bold" }
--   elseif rime_toggled == false and rime_ls_active == true and tex.in_text() then
--     return { bg = "#f38ba8", fg = "#313244", gui = "bold" }
--   end
-- end
--
-- local function rime_toggle_word()
--   if rime.check_rime_status() and rime_toggled == true then
--     return "text"
--   elseif rime_toggled == false and rime_ls_active == true and tex.in_text() == false then
--     return "math"
--   elseif rime_toggled == false and rime_ls_active == true and tex.in_text() then
--     return "error"
--   end
-- end

-- local function rime_toggle_color()
--   if rime.check_rime_status() and rime_toggled then
--     return { bg = "#74c7ec", fg = "#313244", gui = "bold" }
--   elseif rime_ls_active then
--     if tex.in_text() then
--       return { bg = "#f38ba8", fg = "#313244", gui = "bold" }
--     else
--       return { bg = "#fab387", fg = "#313244", gui = "bold" }
--     end
--   end
--   if not rime_toggled and not rime_ls_active then
--     if not tex.in_text() then
--       return { bg = "#fab387", fg = "#313244", gui = "bold" }
--     else
--       return { bg = "#74c7ec", fg = "#313244", gui = "bold" }
--     end
--   end
-- end
--
-- local function rime_toggle_word()
--   if rime.check_rime_status() and rime_toggled then
--     return "cn"
--   elseif rime_ls_active then
--     if tex.in_text() then
--       return "error"
--     else
--       return "math"
--     end
--   end
--   if not rime_toggled and not rime_ls_active then
--     if tex.in_text() then
--       return "eng"
--     else
--       return "math"
--     end
--   end
-- end

local function rime_toggle_color()
  if rime.check_rime_status() and rime_toggled then
    return { bg = "#74c7ec", fg = "#313244", gui = "bold" }
  elseif rime_ls_active then
    return tex.in_text() and { bg = "#f38ba8", fg = "#313244", gui = "bold" }
      or { bg = "#fab387", fg = "#313244", gui = "bold" }
  elseif not rime_toggled and not rime_ls_active then
    return tex.in_text() and { bg = "#74c7ec", fg = "#313244", gui = "bold" }
      or { bg = "#fab387", fg = "#313244", gui = "bold" }
  end
end

local function rime_toggle_word()
  if rime.check_rime_status() and rime_toggled then
    return "cn"
  elseif rime_ls_active then
    return tex.in_text() and "error" or "math"
  elseif not rime_toggled and not rime_ls_active then
    return tex.in_text() and "en" or "math"
  end
end

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
    table.insert(opts.sections.lualine_x, {
      function()
        -- return rime.check_rime_status()
        return rime_toggle_word()
      end,
      color = rime_toggle_color,
      separator = { left = "", right = "" },
    })
    opts.sections.lualine_y = {
      function()
        return "  " .. battery.get_battery_status() .. " 󰥔  " .. battery.get_battery_time()
      end,
    }
  end,
}
