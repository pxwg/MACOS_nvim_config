local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
capabilities.offsetEncoding = { "utf-16" } -- 设置统一的 offsetEncoding
capabilities.general.positionEncodings = { "utf-8" }

return {
  "neovim/nvim-lspconfig",
  optional = true,
  opts = {
    servers = {
      texlab = {
        keys = {
          { "<Leader>K", "<plug>(vimtex-doc-package)", desc = "Vimtex Docs", silent = true },
        },
        capabilities = capabilities,
      },
    },
  },
}
