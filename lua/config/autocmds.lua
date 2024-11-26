-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Set conceal level
local keymap = vim.keymap
local tex = require("util.latex")

vim.cmd([[set conceallevel=2]])

keymap.set("n", "<localleader>e", " ", { call = require("lsp.rime_2").setup_rime() })

local rime_ls_active = true
local rime_toggled = true --默认打开require("lsp.rime_2")_ls

_G.toggle_rime_and_set_flag = function()
  require("lsp.rime_2").toggle_rime()
  rime_toggled = false
end

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "*.tex", "*.md", "*.copilot-chat" },
  callback = function()
    require("lsp.rime_2").setup_rime()
  end,
})

vim.api.nvim_create_autocmd("CursorMovedI", {
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "tex" then
      if tex.in_mathzone() == true or tex.in_table() == true or tex.in_tikz() == true then
        if rime_toggled == true then
          require("lsp.rime_2").toggle_rime()
          rime_toggled = false
        end
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
  vim.o.guifont = "JetBrainsMono_Nerd_Font_Propo:h19"
  vim.g.neovide_fullscreen = true
  vim.g.neovide_transparency = 1
  vim.g.neovide_transparency_point = 0.8
  vim.opt.linespace = -1
  vim.g.neovide_show_border = false
  vim.g.neovide_cursor_animation_length = 0.05
end

vim.cmd.sleep("10m") -- 如果没有这个延时, 信息就不能显示出来了
vim.cmd([[
set spell
set spelllang=en,cjk]])
