local function get_rime_status()
  local clients = vim.lsp.get_active_clients()
  for _, client in ipairs(clients) do
    if client.name == "rime_ls" then
      return "ㄓ"
    end
  end
  return ""
end
local harpoon = require("harpoon")
local devicons = require("nvim-web-devicons")

local yellow = "#f5c2e7"
local yellow_orange = "#f5c2e7"
local background_color = "#191C28"
local grey = "#b4bef1"
local light_blue = "#9CDCFE"

vim.api.nvim_set_hl(0, "HarpoonInactive", { fg = grey, bg = background_color })
vim.api.nvim_set_hl(0, "HarpoonActive", { fg = light_blue, bg = background_color })
vim.api.nvim_set_hl(0, "HarpoonNumberActive", { fg = yellow, bg = background_color })
vim.api.nvim_set_hl(0, "HarpoonNumberInactive", { fg = yellow_orange, bg = background_color })
vim.api.nvim_set_hl(0, "TabLineFill", { fg = white, bg = background_color })
vim.api.nvim_set_hl(0, "HarpoonIconActive", { fg = light_blue, bg = background_color })
vim.api.nvim_set_hl(0, "HarpoonIconInactive", { fg = grey, bg = background_color })

function Harpoon_files()
  local contents = {}
  local marks_length = harpoon:list():length()
  local current_file_path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
  for index = 1, marks_length do
    local harpoon_file_path = harpoon:list():get(index).value

    local label = ""
    if vim.startswith(harpoon_file_path, "oil") then
      local dir_path = string.sub(harpoon_file_path, 7)
      dir_path = vim.fn.fnamemodify(dir_path, ":.")
      label = "[" .. dir_path .. "]"
    elseif harpoon_file_path ~= "" then
      label = vim.fn.fnamemodify(harpoon_file_path, ":t")
    end

    label = label ~= "" and label or "(empty)"
    local icon = devicons.get_icon(harpoon_file_path, vim.fn.fnamemodify(harpoon_file_path, ":e"), { default = true })
    if current_file_path == harpoon_file_path then
      label = string.format("%%#HarpoonIconActive#%s %%#HarpoonActive#%s", icon, label)
      contents[index] = string.format("%%#HarpoonNumberActive# %s. %s ", index, label)
    else
      label = string.format("%%#HarpoonIconInactive#%s %%#HarpoonInactive#%s", icon, label)
      contents[index] = string.format("%%#HarpoonNumberInactive# %s. %s ", index, label)
    end
  end
  return table.concat(contents)
end

-- function Harpoon_files()
--   local contents = {}
--   local marks_length = harpoon:list():length()
--   local current_file_path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
--   for index = 1, marks_length do
--     local harpoon_file_path = harpoon:list():get(index).value
--
--     local label = ""
--     if vim.startswith(harpoon_file_path, "oil") then
--       local dir_path = string.sub(harpoon_file_path, 7)
--       dir_path = vim.fn.fnamemodify(dir_path, ":.")
--       label = "[" .. dir_path .. "]"
--     elseif harpoon_file_path ~= "" then
--       label = vim.fn.fnamemodify(harpoon_file_path, ":t")
--     end
--
--     label = label ~= "" and label or "(empty)"
--     if current_file_path == harpoon_file_path then
--       contents[index] = string.format("%%#HarpoonNumberActive# %s. %%#HarpoonActive#%s ", index, label)
--     else
--       contents[index] = string.format("%%#HarpoonNumberInactive# %s. %%#HarpoonInactive#%s ", index, label)
--     end
--   end
--   return table.concat(contents)
-- end

local battery = require("util.battery")
local dashboard = { "dashboard", "alpha", "ministarter", "snacks_dashboard" }

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    local options = {
      theme = "auto",
      globalstatus = vim.o.laststatus == 3,
      disabled_filetypes = { statusline = dashboard },
    }
    opts.options = options
    opts.component_separators = { "|", "|" }
    opts.tabline = {
      lualine_c = {
        function()
          return Harpoon_files()
        end,
      },
    }
    table.insert(opts.sections.lualine_y, {
      function()
        return get_rime_status()
      end,
    })
    table.insert(opts.sections.lualine_y, {
      function()
        return "  " .. battery.get_battery_status() .. " 󰥔 " .. battery.get_battery_time()
      end,
    })
  end,
}
