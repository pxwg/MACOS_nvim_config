vim.g.conform_autoformat = true
return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  opts = function(_, opts)
    -- 添加 latex autocorrect 配置
    opts.formatters_by_ft.tex = { "autocorrect" }
    opts.formatters_by_ft.markdown = { "autocorrect" }
    return opts
  end,
}
