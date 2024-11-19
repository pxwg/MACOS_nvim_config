local M = {}
local rime_ls_filetypes = { "markdown", "vimwiki", "copilot-chat", "latex" }

M.start_rime = function()
  local cmp_ok, cmp = pcall(require, "cmp")
  if not cmp_ok then
    vim.notify("nvim-cmp not installed", vim.log.levels.ERROR)
    error()
  end
  local function rime_status()
    if vim.g.rime_enabled then
      return "ㄓ"
    else
      return ""
    end
  end
  require("lualine").setup({
    sections = {
      lualine_x = { rime_status, "copilot", "encoding", "fileformat", "filetype" },
    },
  })

  local client_id = vim.lsp.start_client({
    name = "rime-ls",
    cmd = { os.getenv("HOME") .. "/Desktop/rime-ls-0.4.0/target/release/rime_ls" },
    init_options = {
      enabled = true,
      shared_data_dir = "~/Library/Rime/",
      user_data_dir = os.getenv("HOME") .. "/Library/Rime_2",
      log_dir = os.getenv("HOME") .. "/.local/share/rime-ls",
      max_candidates = 10,
      paging_characters = { ",", ".", "-", "=", " " },
      trigger_characters = {},
      schema_trigger_character = "&",
      always_incomplete = false,
      max_tokens = 1,
      preselect_first = false,
      show_filter_text_in_lebal = false,
    },
  })
  if client_id then
    vim.lsp.buf_attach_client(0, client_id)
    vim.keymap.set("n", "<localleader>f", function()
      vim.lsp.buf.execute_command({ command = "rime-ls.toggle-rime" })
    end)
    vim.keymap.set("n", "<localleader>r", function()
      vim.lsp.buf.execute_command({ command = "rime-ls.sync-user-data" })
    end)
  end
end

local punc_en = { ",", ".", ":", ";", "?" }
local punc_zh = { "，", "。", "：", "；", "？" }
vim.api.nvim_create_autocmd("FileType", {
  pattern = rime_ls_filetypes,
  callback = function()
    for i = 1, #punc_en do
      local src = punc_en[i] .. "<space>"
      local dst = 'rime_enabled ? "' .. punc_zh[i] .. '" : "' .. punc_en[i] .. ' "'
      vim.api.nvim_buf_set_keymap(0, mode, src, dst, {
        noremap = true,
        silent = false,
        expr = true,
      })
    end
  end,
})

-- local rime_ls_filetypes = { "markdown", "vimwiki", "latex" }
-- local function is_rime_entry(entry)
--   return vim.tbl_get(entry, "source", "name") == "nvim_lsp"
--     and vim.tbl_get(entry, "source", "source", "client", "name") == "rime_ls"
-- end
-- local cmp = require("cmp")
-- local function auto_upload_rime()
--   if not cmp.visible() then
--     return
--   end
--   local entries = cmp.core.view:get_entries()
--   if entries == nil or #entries == 0 then
--     return
--   end
--   local first_entry = cmp.get_selected_entry()
--   if first_entry == nil then
--     first_entry = cmp.core.view:get_first_entry()
--   end
--   if first_entry ~= nil and is_rime_entry(first_entry) then
--     local rime_ls_entries_cnt = 0
--     for _, entry in ipairs(entries) do
--       if is_rime_entry(entry) then
--         rime_ls_entries_cnt = rime_ls_entries_cnt + 1
--         if rime_ls_entries_cnt == 2 then
--           break
--         end
-- -       end
--     end
--     if rime_ls_entries_cnt == 1 then
--       cmp.confirm({
--         behavior = cmp.ConfirmBehavior.Insert,
--         select = true,
--       })
--     end
--   end
-- end
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = rime_ls_filetypes,
--   callback = function()
--     for numkey = 1, 9 do
--       local numkey_str = tostring(numkey)
--       vim.api.nvim_buf_set_keymap(0, "i", numkey_str, "", {
--         noremap = true,
--         silent = false,
--         callback = function()
--           vim.fn.feedkeys(numkey_str .. " ", "n")
--           vim.schedule(auto_upload_rime)
--         end,
--       })
--       vim.api.nvim_buf_set_keymap(0, "s", numkey_str, "", {
--         noremap = true,
--         silent = false,
--         callback = function()
--           vim.fn.feedkeys(numkey_str .. " ", "n")
--           vim.schedule(auto_upload_rime)
--         end,
--       })
--     end
--   end,
-- })

local cmp = require("cmp")
local function is_rime_entry(entry)
  return entry ~= nil
    and vim.tbl_get(entry, "source", "name") == "nvim_lsp"
    and vim.tbl_get(entry, "source", "source", "client", "name") == "rime_ls"
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
vim.api.nvim_create_autocmd("FileType", {
  pattern = rime_ls_filetypes,
  callback = function()
    for numkey = 1, 9 do
      local numkey_str = tostring(numkey)
      vim.api.nvim_buf_set_keymap(0, "i", numkey_str, "", {
        noremap = true,
        silent = false,
        callback = function()
          vim.fn.feedkeys(numkey_str, "n")
          -- 使用 `vim.schedule` 可以保证 `auto_upload_rime` 在 `feedkeys` 之后执行
          vim.schedule(auto_upload_rime)
        end,
      })
    end
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    M.start_rime()
  end,
  pattern = "*",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = rime_ls_filetypes,
  callback = function(env)
    local rime_ls_client = vim.lsp.get_clients({ name = "rime_ls" })
    -- 如果没有启动 `rime-ls` 就手动启动
    if #rime_ls_client == 0 then
      vim.cmd("LspStart rime_ls")
      rime_ls_client = vim.lsp.get_clients({ name = "rime_ls" })
    end
    -- `attach` 到 `buffer`
    if #rime_ls_client > 0 then
      vim.lsp.buf_attach_client(env.buf, rime_ls_client[1].id)
    end
  end,
})

return M
