return {
  "prochri/telescope-all-recent.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "kkharji/sqlite.lua",
    "stevearc/dressing.nvim",
  },
  opts = {
    picker = {
      man_pages = { -- enable man_pages picker. Disable cwd and use frecency sorting.
        disable = false,
        use_cwd = false,
        sorting = "frecency",
      },
    },
  },
}
