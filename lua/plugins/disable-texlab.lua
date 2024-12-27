return {
  "neovim/nvim-lspconfig",
  optional = true,
  opts = {
    servers = {
      texlab = {
        enabled = false,
      },
    },
  },
}
