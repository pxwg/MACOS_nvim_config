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
local cmp = require("cmp")
local tdf = require("util.tdf")
local lspconfig = require("lspconfig")

-- import quotes
local quotes = {}
local home = os.getenv("HOME")
local file_path = home .. "/quotes.txt"

local file = io.open(file_path, "r")

local function is_rime_entry(entry)
  return entry ~= nil and entry.source.name == "nvim_lsp" and entry.source.source.client.name == "rime_ls"
end

local function auto_upload_rime()
  if not cmp.visible() then
    return
  end
  local entries = cmp.core.view:get_entries()
  if entries == nil or #entries == 0 then
    return
  end
  local first_entry = cmp.get_selected_entry()
  if first_entry == nil then
    first_entry = cmp.core.view:get_first_entry()
  end
  if first_entry ~= nil and is_rime_entry(first_entry) then
    local rime_ls_entry_occur = false
    for _, entry in ipairs(entries) do
      if is_rime_entry(entry) then
        if rime_ls_entry_occur then
          return
        end
        rime_ls_entry_occur = true
      end
    end
    if rime_ls_entry_occur then
      cmp.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      })
    end
  end
end

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

_G.rime_toggled = rime_toggled
_G.rime_ls_active = rime_ls_active

keymap.set("i", "jn", function()
  vim.cmd("LspStart rime_ls")
  require("lsp.rime_2").toggle_rime()
  _G.rime_toggled = not _G.rime_toggled
  _G.rime_ls_active = not _G.rime_ls_active
end, { noremap = true, silent = true, desc = "toggle rime-ls" })

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "*.tex", "*.md", "*.copilot-chat" },
  callback = function()
    require("lsp.rime_2").setup_rime()
  end,
})

-- 基本逻辑: 在text 区域，rime_toggle = true 始终成立, rime_ls_active = true 在中文输入法下成立。如果在数学区域，则rime_toggle = false, rime_ls_active = true 应当始终成立, 如果

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "*" },
  callback = function()
    -- TODO: deactivate rime from user update
    -- if not _G.rime_ls_active and not _G.rime_ls_active then
    -- return nil
    -- else
    _G.rime_toggled = true
    _G.rime_ls_active = true
    -- end
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

local function switch_rime_math()
  if vim.bo.filetype == "tex" then
    -- in the mathzone or table or tikz and rime is active, disable rime
    if (tex.in_mathzone() == true or tex.in_tikz() == true) and rime_ls_active == true then
      if _G.rime_toggled == true then
        require("lsp.rime_2").toggle_rime()
        _G.rime_toggled = false
      end
      -- in the text but rime is not active(by hand), do nothing
    elseif _G.rime_ls_active == false then
      -- in the text but rime is active(by hand ), thus the configuration is for mathzone or table or tikz
    else
      if _G.rime_toggled == false then
        require("lsp.rime_2").toggle_rime()
        _G.rime_toggled = true
      end
    end
  end
end

local function switch_rime_math_md()
  if vim.bo.filetype == "markdown" then
    -- in the mathzone or table or tikz and rime is active, disable rime
    if tex.in_latex() and rime_ls_active == true then
      if _G.rime_toggled == true then
        require("lsp.rime_2").toggle_rime()
        _G.rime_toggled = false
      end
      -- in the text but rime is not active(by hand), do nothing
    elseif _G.rime_ls_active == false then
      -- in the text but rime is active(by hand ), thus the configuration is for mathzone or table or tikz
    else
      if _G.rime_toggled == false then
        require("lsp.rime_2").toggle_rime()
        _G.rime_toggled = true
      end
    end
  end
end

vim.api.nvim_create_autocmd("CursorMovedI", {
  pattern = "*",
  callback = switch_rime_math,
})

vim.api.nvim_create_autocmd("CursorMovedI", {
  pattern = "*",
  callback = switch_rime_math_md,
})

-- TODO: 让这段代码可以监控数学区域内的中文输入法是否打开，如果打开则打印到lualine ✅
-- TODO: 支持英文输入的状态栏检测(单buffer) 每次进入buffer  需要手动改变输入法✅

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

-- local ts_utils = require("nvim-treesitter.ts_utils")
--
-- local function is_comment()
--   local node = ts_utils.get_node_at_cursor()
--   while node do
--     if node:type() == "comment" then
--       return true
--     end
--     node = node:parent()
--   end
--   return false
-- end
--
-- local rime_ls_active_f = function()
--   local clients = vim.lsp.get_active_clients()
--   for _, client in ipairs(clients) do
--     if client.name == "rime_ls" then
--       return true
--     end
--   end
--   return false
-- end
--
-- -- cannot be used for now
-- vim.api.nvim_create_autocmd("CursorMoved", {
--   pattern = "*",
--   callback = function()
--     local ft = vim.bo.filetype
--     if ft ~= "tex" and ft ~= "markdown" and ft ~= "copilot-chat" then
--       if is_comment() and rime_ls_active_f() then
--         vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<localleader>f", true, true, true), "n", false)
--         print("restart")
--       elseif is_comment() and rime_ls_active_f() == false then
--         vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<localleader>f", true, true, true), "n", false)
--         print("start")
--       elseif is_comment() == false and rime_ls_active_f() then
--         vim.api.nvim_command("LspStop rime_ls")
--       end
--     end
--   end,
-- })

local punc_en = { [[\]], [[_]], [["]], [[']], [[<]], [[>]] }
local punc_zh = { [[、]], [[——]], [[“]], [[”]], [[《]], [[》]] }

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  -- pattern = rime_ls_filetypes,
  callback = function(env)
    -- copilot cannot attach client automatically, we must attach manually.
    local rime_ls_client = vim.lsp.get_clients({ name = "rime_ls" })
    if #rime_ls_client == 0 then
      vim.cmd("LspStart rime_ls")
      rime_ls_client = vim.lsp.get_clients({ name = "rime_ls" })
    end

    for i = 1, #punc_en do
      local src = punc_en[i] .. "<space>"
      local dst = 'rime_enabled ? "' .. punc_zh[i] .. '" : "' .. punc_en[i] .. ' "'
      vim.keymap.set({ "i", "s" }, src, dst, {
        noremap = true,
        silent = false,
        expr = true,
        buffer = true,
      })
    end
    --
    for numkey = 1, 9 do
      local numkey_str = tostring(numkey)
      vim.keymap.set({ "i", "s" }, numkey_str, function()
        local visible = cmp.visible()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(numkey_str, true, false, true), "n", true)
        if visible then
          vim.schedule(auto_upload_rime)
        end
      end, {
        noremap = true,
        silent = true,
        buffer = true,
      })
    end
  end,
})

local uv = vim.loop
local handle

local function watch_file_changes()
  local watch_file_path = "/tmp/nvim_hammerspoon_latex.txt"

  local function on_change(err, filename, status)
    if err then
      print("Error watching file:", err)
      return
    end
    if status.change then
      tdf.synctex_inverse()
    end
  end

  if not handle then
    handle = uv.new_fs_event()
    uv.fs_event_start(handle, watch_file_path, {}, vim.schedule_wrap(on_change))
  end
end

-- 执行tdf.synctex_inverse()

vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function()
    watch_file_changes()
  end,
})

-- Disable autoformat for latex files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "tex" },
  callback = function()
    vim.b.autoformat = false
    vim.diagnostic.enable(false)
  end,
})

-- Disable autoformat for markdown files

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "markdown" },
  callback = function()
    vim.b.autoformat = false
    vim.diagnostic.enable(false)
  end,
})
