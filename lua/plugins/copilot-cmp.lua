return {
  "zbirenbaum/copilot-cmp",
  enabled = false,
  dependencies = "copilot.lua",
  opts = {},
  event = "InsertEnter", -- 在插入模式下加载插件
  config = function(_, opts)
    local copilot_cmp = require("copilot_cmp")
    copilot_cmp.setup(opts)
    -- attach cmp source whenever copilot attaches
    -- fixes lazy-loading issues with the copilot cmp source
    LazyVim.lsp.on_attach(function(client)
      copilot_cmp._on_insert_enter({})
    end, "copilot")
  end,
}
