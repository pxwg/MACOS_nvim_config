return {
  "stevearc/dressing.nvim",
  priority = 100,
  opts = {
    select = {
      enabled = true,
      backend = { "builtin" },
      builtin = {
        -- Display numbers for options and set up keymaps
        show_numbers = true,
        -- These are passed to nvim_open_win
        border = "rounded",
        -- 'editor' and 'win' will default to being centered
        relative = "editor",

        buf_options = {},
        win_options = {
          cursorline = true,
          cursorlineopt = "both",
          -- disable highlighting for the brackets around the numbers
          winhighlight = "MatchParen:",
          -- adds padding at the left border
          statuscolumn = " ",
        },

        -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        -- the min_ and max_ options can be a list of mixed types.
        -- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
        width = nil,
        max_width = { 140, 0.8 },
        min_width = { 1, 0.08 },
        height = nil,
        min_height = { 1, 0.05 },
      },
    },
  },
}
