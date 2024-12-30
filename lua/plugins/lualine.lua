local battery = require("util.battery")
local rime = require("util.rime_ls")
local dashboard = { "dashboard", "alpha", "ministarter", "snacks_dashboard" }
local tex = require("util.latex")

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
  elseif rime_ls_active and tex.in_latex() then
    return "math"
  elseif rime_ls_active then
    return tex.in_text() and "error" or "math"
  elseif not rime_toggled and not rime_ls_active then
    return tex.in_text() and "en" or "math"
  end
end

local function enabled()
  if vim.g.started_by_firenvim then
    return false
  else
    return true
  end
end

local function is_texlab_open()
  if vim.b.texlab_active then
    return "󰿉"
  else
    return ""
  end
end

local function is_marksman_open()
  if vim.b.marksman_active then
    return " "
  else
    return ""
  end
end

return {
  "nvim-lualine/lualine.nvim",
  enabled = enabled,
  opts = function(_, opts)
    local options = {
      theme = "auto",
      -- globalstatus = vim.o.laststatus == 3,
      disabled_filetypes = { statusline = dashboard, winbar = dashboard },
      section_separators = { right = " ", left = " " },
      component_separators = { left = "󰩃 ", right = "󰄛 " },
    }
    opts.options = options
    table.insert(opts.sections.lualine_x, {
      function()
        return rime_toggle_word()
      end,
      color = rime_toggle_color,
      separator = { left = "", right = " " },
    })
    table.insert(opts.sections.lualine_x, 2, {
      function()
        return is_texlab_open()
      end,
    })
    table.insert(opts.sections.lualine_x, 2, {
      function()
        return is_marksman_open()
      end,
    })
    opts.sections.lualine_y = {
      function()
        return "  " .. battery.get_battery_status() .. " 󰥔  " .. battery.get_battery_time()
      end,
    }
  end,
}
