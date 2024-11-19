return {
  "liubianshi/cmp-lsp-rimels",
  keys = { { "<localleader>k", mode = "i" } },
  config = function()
    require("rimels").setup({})
  end,
}
