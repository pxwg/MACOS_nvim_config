return {
  "ppwwyyxx/vim-PinyinSearch",
  event = "BufRead",
  config = function()
    vim.g.PinyinSearch_Dict = "/Users/pxwg-dogggie/.local/share/nvim/lazy/vim-PinyinSearch/PinyinSearch.dict"
    -- 绑定键以运行 PinyinSearch 命令
    vim.api.nvim_set_keymap("n", "<leader>p", ":call PinyinSearch()<CR>", { noremap = true, silent = true })
  end,
}
