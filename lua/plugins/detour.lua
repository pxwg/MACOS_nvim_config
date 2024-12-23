return {
  "carbon-steel/detour.nvim",
  enable = true,
  config = function()
    vim.keymap.set("n", "<c-w><enter>", ":Detour<cr>")
    vim.keymap.set("n", "<c-w>.", ":DetourCurrentWindow<cr>")
  end,
}
