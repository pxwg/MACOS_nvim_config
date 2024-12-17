-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local cn = require("util.autocorrect")
local Util = require("lazyvim.util")
local tex = require("util.latex")
-- local synctex = require("util.synctex_view")
local synctex = require("util.tdf")
local replace = require("util.replace")

vim.api.nvim_create_autocmd("CursorMovedI", {
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "tex" then
      if tex.in_item() == true then
        keymap.set("i", ";<CR>", ";<CR>\\item ", { noremap = true, silent = true })
        keymap.set("i", "'<CR>", "<CR>\\item ", { noremap = true, silent = true })
      else
        keymap.set("i", ";<CR>", ";<CR>", { noremap = true, silent = true })
        keymap.set("i", "'<CR>", "'<CR>", { noremap = true, silent = true })
      end
    end
  end,
})

-- keymap.set("n", "<leader>in", function()
--   -- 进入普通模式
--   vim.cmd("normal! <Esc>")
--   -- 关闭宏录制
--   vim.cmd("q")
--   -- 关闭其他可能的记录功能
--   vim.cmd("nohlsearch")
--   vim.cmd("set nomore")
-- end, { noremap = true, silent = true, desc = "Initialize Neovim State" })
-- keymap.set("n", "<localleader>e", " ", { call = rime.setup_rime() })

-- keymapping for forward search
-- keymap.set(
--   "n",
--   "<localleader>lf",
--   " ",
--   { noremap = true, silent = true, desc = "Forward Searching", callback = synctex.synctex_view }
-- )
keymap.set(
  "n",
  "<localleader>lf",
  " ",
  { noremap = true, silent = true, desc = "Forward Searching", callback = synctex.synctex_forward }
) -- modified for kitty with HammerSpoon

-- kemap for inverse search
keymap.set(
  "n",
  "<localleader>li",
  " ",
  { noremap = true, silent = true, desc = "Inverse Searching", callback = synctex.synctex_edit }
)
-- keymapping for show pdf
-- keymap.set("n", "<localleader>lp", function()
--   synctex.convert_tex_to_pdf()
--   vim.defer_fn(function()
--     synctex.synctex_view()
--   end, 1500)
-- end, { noremap = true, silent = true, desc = "View PDF in Terminal" })

-- Key mappings
keymap.set({ "i", "s" }, "jj", "<Esc>")
-- keymap.set({ "i", "s" }, "jk", "<Esc>")
-- keymap.set({ "i", "s" }, "kj", "<Esc>")
keymap.set({ "i", "s" }, ";;", "<Esc>")

keymap.set("n", "<leader>h", "<cmd>noh<cr>", { desc = "no highlight" })

-- keymap.set("i", "<c-c>", "<cmd>lua require('luasnip.extras.select_choice')()<cr>")
-- keymap.set("i", "<c-s>", "<cmd>lua require('luasnip.extras.select_choice')()<Cr>")
keymap.set({ "i", "s" }, "<c-u>", "<cmd>lua require('luasnip.extras.select_choice')()<cr>")
keymap.set({ "i", "s" }, "<c-n>", "<Plug>luasnip-next-choice")
keymap.set({ "i", "s" }, "<c-p>", "<Plug>luasnip-prev-choice")

keymap.set("n", "<leader>gg", function()
  LazyVim.lazygit({ cwd = LazyVim.root.git() })
end, { desc = "Lazygit (Root Dir)" })
keymap.set("n", "<leader>gG", function()
  LazyVim.lazygit()
end, { desc = "Lazygit (cwd)" })
keymap.set("n", "<leader>gb", LazyVim.lazygit.blame_line, { desc = "Git Blame Line" })
keymap.set("n", "<leader>gB", LazyVim.lazygit.browse, { desc = "Git Browse" })

keymap.set("n", "<leader>h", function()
  local harpoon = require("harpoon")
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon Quick Menu" })

local function save_and_delete_last_line()
  local ft = vim.bo.filetype
  local cursor_pos = vim.fn.getpos(".") -- 记录光标位置

  if ft == "tex" or ft == "markdown" then
    -- 修复一些上游的问题: autoformat 插件会在最后一行多加一个空行，需要额外删除
    vim.cmd("w")
    local view = vim.fn.winsaveview()
    vim.api.nvim_buf_set_lines(0, -2, -1, false, {})
    vim.fn.winrestview(view)
    cn.autocorrect()
    vim.cmd("w")
  else
    vim.cmd("w")
  end
  vim.fn.setpos(".", cursor_pos) -- 恢复光标位置
end

keymap.set("n", "<leader>ua", function()
  cn.autocorrect()
end, { noremap = true, silent = true, desc = "AutoCorrect For Chinese File" })

-- Set up an autocmd to trigger the function after LSP completion
--

-- vim.api.nvim_exec(
--   [[
--   augroup SaveAndDeleteLastLine
--     autocmd!
--     autocmd CompleteDone * lua save_and_delete_last_line()
--   augroup END
-- ]],
--   false
-- )

_G.save_and_delete_last_line = save_and_delete_last_line
-- keymap.set("i", "<C-l>", "<NOP>", { noremap = true, silent = true })
--
-- --Map <C-l> to right arrow in insert mode
-- keymap.set({ "i", "s" }, "<cm-l>", "<Right>", { noremap = true, silent = true })
-- keymap.set({ "i", "s" }, "<C-h>", "<Left>", { noremap = true, silent = true })
-- keymap.set({ "i", "s" }, "<C-k>", "<Up>", { noremap = true, silent = true })
-- keymap.set({ "i", "s" }, "<C-j>", "<Down>", { noremap = true, silent = true })

-- Map <C-s> to the function
vim.api.nvim_set_keymap("n", "<C-s>", ":lua save_and_delete_last_line()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-s>", "<Esc>:lua save_and_delete_last_line()<CR>", { noremap = true, silent = true })

keymap.set("n", "<leader>uc", function()
  Util.toggle("conceallevel", false, { 0, 2 })
end, { desc = "Toggle Conceal" })

keymap.set({ "i", "n", "s" }, "<c-z>", "<cmd>undo<cr>")

keymap.set("i", "<c-e>", "<esc><c-e>a")

-- rime_ls for Copilot-Chat
keymap.set("n", "<C-c>", function()
  vim.cmd("CopilotChat")
  vim.cmd("LspStart rime_ls")
end, { noremap = true, silent = true })
keymap.set("n", "<leader>aa", function()
  vim.cmd("CopilotChat")
  vim.cmd("LspStart rime_ls")
end, { noremap = true, silent = true, desc = "Toggle (Copilot-Chat)" })

keymap.set("i", "<C-d>", " ")

-- Map $ to L in normal mode
keymap.set({ "n", "s", "v" }, "L", "$", { noremap = true, silent = true })

-- Map 0 to H in normal mode
keymap.set({ "n", "s", "v" }, "H", "^", { noremap = true, silent = true })

-- pickbufferline

-- keymap.set("n", "<leader>bg", ":BufferLinePick<CR>", { noremap = true, silent = true })

-- 下面的是来自 Gilles Castel 的快速拼写修正的 keymap,
-- "It basically jumps to the previous spelling mistake [s, then picks the first suggestion 1z=, and then jumps back `]a. The <c-g>u in the middle make it possible to undo the spelling correction quickly."
keymap.set("i", "<c-l>", "<c-g>u<Esc>[s1z=`]a<c-g>u")

-- 下面是来自 Gilles Castel 的图片插入代码, 见https://github.com/gillescastel/inkscape-figures
-- 需要注意的是, rofi 在 xorg 显示服务器上面才能正常工作.
-- 他的另一个项目, inkscape shortcut 也需要在 xorg 服务器下运行来捕获窗口.
keymap.set(
  "i",
  "<C-f>",
  [[ <Esc>: silent exec '.!inkscape-figures create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w<CR>]]
)

keymap.set(
  "n",
  "<C-f>",
  [[ : silent exec '!inkscape-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>]]
)

-- BufferLinePick
keymap.set("n", "<leader>bg", ":BufferLinePick<CR>", { noremap = true, silent = true })

keymap.set(
  { "n", "i" },
  "<localleader>f",
  "<ESC>:LspStart rime_ls<CR>",
  { noremap = true, silent = true, desc = "start rime-ls" }
)

local function is_rightmost_window()
  local current_win = vim.api.nvim_get_current_win()
  local current_pos = vim.api.nvim_win_get_position(current_win)[2]
  local max_col = current_pos

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local pos = vim.api.nvim_win_get_position(win)[2]
    if pos > max_col then
      max_col = pos
    end
  end

  return current_pos == max_col
end

-- 切换到右侧窗口，并检查是否已经是最右侧窗口
keymap.set("n", "<C-l>", function()
  if is_rightmost_window() then
    vim.fn.system("hs -c 'focusNextWindow()'")
  else
    vim.cmd("wincmd l")
  end
end, { noremap = true, silent = true, desc = "Move to right window" })

-- 类似cursor 的功能，将ai 的代码段直接应用于所选文本
keymap.set("v", "<leader>ai", function()
  replace.replace_content()
end, { noremap = true, silent = true, desc = "Replace selected text with AI code" })
