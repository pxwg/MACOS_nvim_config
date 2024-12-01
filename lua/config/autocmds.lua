-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Set conceal level
local keymap = vim.keymap
local tex = require("util.latex")
local toggle_rime_and_set_flag = function()
  require("lsp.rime_2").toggle_rime()
  rime_toggled = false
end

-- import quotes
local quotes = {}
local home = os.getenv("HOME")
local file_path = home .. "/quotes.txt"

local file = io.open(file_path, "r")

if file then
  for line in file:lines() do
    table.insert(quotes, line)
  end
  file:close()
else
  print("无法打开文件")
end

math.randomseed(os.time())
local random_quote = quotes[math.random(#quotes)]

vim.cmd([[set conceallevel=2]])

keymap.set("n", "<localleader>e", " ", { call = require("lsp.rime_2").setup_rime() })

local rime_ls_active = true
local rime_toggled = true --默认打开require("lsp.rime_2")_ls

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "*.tex", "*.md", "*.copilot-chat" },
  callback = function()
    require("lsp.rime_2").setup_rime()
  end,
})

-- vim.api.nvim_create_autocmd("CursorMovedI", {
--   pattern = "*",
--   callback = function()
--     if vim.bo.filetype == "tex" then
--       if tex.in_mathzone() == true or tex.in_table() == true or tex.in_tikz() == true then
--         if rime_toggled == true then
--           require("lsp.rime_2").toggle_rime()
--           rime_toggled = false
--         end
--       else
--         if rime_toggled == false then
--           require("lsp.rime_2").toggle_rime()
--           rime_toggled = true
--         end
--       end
--     end
--   end,
-- })

keymap.set("i", "jn", function()
  require("lsp.rime_2").toggle_rime()
  rime_toggled = not rime_toggled
  rime_ls_active = not rime_ls_active
end)

vim.api.nvim_create_autocmd("CursorMovedI", {
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "tex" then
      -- in the mathzone or table or tikz and rime is active, disable rime
      if (tex.in_mathzone() == true or tex.in_table() == true or tex.in_tikz() == true) and rime_ls_active == true then
        if rime_toggled == true then
          require("lsp.rime_2").toggle_rime()
          rime_toggled = false
        end
        -- in the text but rime is not active(by hand), do nothing
      elseif rime_ls_active == false then
        -- in the text but rime is active(by hand ), thus the configuration is for mathzone or table or tikz
      else
        if rime_toggled == false then
          require("lsp.rime_2").toggle_rime()
          rime_toggled = true
        end
      end
    end
  end,
})

if vim.g.neovide then
  vim.g.neovide_scale_factor = 1
  vim.o.guifont = "JetBrainsMono_Nerd_Font:h19"
  vim.g.neovide_fullscreen = true
  vim.g.neovide_refresh_rate = 144
  vim.g.neovide_transparency = 0.8
  vim.g.neovide_transparency = 0.85
  vim.g.neovide_transparency_point = 0.8
  vim.opt.linespace = -1
  vim.g.neovide_show_border = false
  vim.g.neovide_cursor_animation_length = 0.03
end

if string.match(vim.env.PATH, "tex") then
  vim.notify(random_quote, vim.log.levels.INFO, { title = "今日格言", position = "bottom" })
end

vim.cmd([[
set spell
set spelllang=en,cjk]])
