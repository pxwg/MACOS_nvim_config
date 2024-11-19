-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--

-- vim.api.nvim_create_augroup("chat", { clear = true })
-- vim.api.nvim_create_autocmd("FileType", {
--   group = "copilot_chat",
--   pattern = "copilot-chat",
--   callback = function()
--     vim.bo.filetype = "markdown"
--   end,
-- })
-- Set conceal level
local tex = require("util.latex")
local rime = require("lsp.rime_2")

vim.cmd([[set conceallevel=2]])

local rime_ls_active = false
local rime_toggled = false

_G.toggle_rime_and_set_flag = function()
  rime.toggle_rime()
  rime_toggled = true
end

vim.api.nvim_create_autocmd("CursorMovedI", {
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "tex" then
      if tex.in_mathzone() == true or tex.in_table() == true or tex.in_tikz() == true then
        if rime_toggled == false then
          rime.toggle_rime()
          rime_toggled = true
        end
      else
        if rime_toggled == true then
          rime.toggle_rime()
          rime_toggled = false
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

-- local function set_latex_md_settings()
--   if vim.bo.filetype == "tex" or vim.bo.filetype == "markdown" then
--     vim.o.tabstop = 1
--     vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
--     vim.o.softtabstop = 1 -- Number of spaces inserted instead of a TAB character
--     vim.o.shiftwidth = 1 -- Number of spaces inserted when indenting
--   end
-- end
--
-- -- Bind the function to the BufRead and BufNewFile events for LaTeX and Markdown files
-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--   pattern = { "*.tex", "*.md" },
--   callback = set_latex_md_settings,
-- })

-- vim.api.nvim_create_autocmd({ "Filetype" }, {
--   pattern = "copilot-chat",
--   callback = function()
--     vim.cmd("setlocal filetype=markdown")
--   end,
-- })
