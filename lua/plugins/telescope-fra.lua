return {
  "nvim-telescope/telescope-frecency.nvim",
  enabled = false,
  lazy = true,
  auto_validate = true,
  ignore_patterns = { "*/.git", "*/.git/*", "*/.DS_Store" },
  matcher = "fuzzy",
  path_display = { "filename_first " },
  config = function()
    require("telescope").load_extension("frecency")
  end,
}
