-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local Util = require("lazyvim.util")
local tex = require("util.latex")
local synctex = require("util.synctex_view")

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

-- keymap.set("n", "<localleader>e", " ", { call = rime.setup_rime() })

-- keymapping for forward search
keymap.set(
  "n",
  "<localleader>lf",
  " ",
  { noremap = true, silent = true, desc = "Forward Searching", callback = synctex.synctex_view }
)
-- kemap for inverse search
keymap.set(
  "n",
  "<localleader>li",
  " ",
  { noremap = true, silent = true, desc = "Inverse Searching", callback = synctex.synctex_edit }
)
-- keymapping for show pdf
keymap.set("n", "<localleader>lp", function()
  synctex.convert_tex_to_pdf()
  vim.defer_fn(function()
    synctex.synctex_view()
  end, 1500)
end, { noremap = true, silent = true, desc = "View PDF in Terminal" })

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

local function save_and_delete_last_line()
  local ft = vim.bo.filetype
  if ft == "tex" or ft == "markdown" then
    -- Save the current window view
    local view = vim.fn.winsaveview()
    -- Join the undo history to make the operation non-undoable
    -- Delete the last line
    vim.api.nvim_buf_set_lines(0, -2, -1, false, {})
    -- Restore the original window view
    vim.fn.winrestview(view)
    -- Save the file again
    vim.cmd("w")
  else
    -- Just save the file
    vim.cmd("w")
  end
end

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
