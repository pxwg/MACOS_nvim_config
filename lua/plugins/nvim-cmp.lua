return {
  "hrsh7th/nvim-cmp",
  version = false, -- last release is way too old
  lazy = true,
  opts = function()
    local cmp = require('cmp')
    return {
      completion = {
        autocomplete = false,
      },
      sources = cmp.config.sources({
        { name = 'cmdline' }
      }),
      enabled = function()
        -- Enable only in command line mode
        return vim.api.nvim_get_mode().mode == 'c'
      end,
    }
  end,
}
