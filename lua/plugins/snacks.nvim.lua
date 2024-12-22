local battery = require("util.battery")

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    notifier = { enabled = true },
    git = { enabled = true },
    lazygit = { enabled = true },
    debug = { enabled = true },
    notify = { enabled = true },
    quickfile = {
      enabled = true,
      {
        -- any treesitter langs to exclude
        exclude = { "latex" },
      },
    },
    words = { enabled = true },
    dashboard = {
      preset = {
        header = [[


                              /^ ^\
                             / 0 0 \
        |\__/,|   (`\        V\ Y /V
      _.|o o  |_   ) )        / - \
    -(((---(((-------        /    |
                            V__) ||
        ]],
        ---@type snacks.dashboard.Item[]
        keys = {
          {
            action = ":lua require('telescope.builtin').find_files()",
            desc = "Find file",
            icon = " ",
            key = "f",
          },
          {

            action = ":lua require('telescope.builtin').oldfiles()",
            desc = "Recent files",
            icon = " ",
            key = "r",
          },
          {
            action = ":cd /Users/pxwg-dogggie/Desktop/physics/notes/",
            desc = "Physics Notes",
            icon = " ",
            key = "p",
          },
          {
            icon = " ",
            key = "n",
            desc = "New Draft",
            action = ":lua require('util.new_drafts').create_and_open_new_draft()",
          },
          {
            icon = " ",
            key = "g",
            desc = "Find Text",
            action = function()
              require("telescope.builtin").live_grep()
            end,
          },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = function()
              require("telescope.builtin").find_files({ cwd = "~/.config/nvim" })
            end,
          },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          {
            icon = "󰸌 ",
            key = "d",
            desc = "Colorscheme",
            action = function()
              require("telescope.builtin").colorscheme()
            end,
          },
          {
            icon = " ",
            key = "h",
            desc = "Help",
            action = function()
              require("telescope.builtin").help_tags()
            end,
          },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { pane = 1, section = "header", padding = 1 },
        {
          pane = 2,
          section = "terminal",
          cmd = "macmon",
          height = 15,
          ttl = 15 * 100,
          padding = 1,
          enabled = function()
            return vim.api.nvim_win_get_width(0) >= 120 and vim.api.nvim_win_get_height(0) >= 20
          end,
        },
        { icon = " ", title = "Keymaps", section = "keys", indent = 4, padding = 1 },
        { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 3, padding = 1 },
        { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 3, padding = 1 },
        {
          pane = 1,
          icon = " ",
          title = "Git Status",
          section = "terminal",
          enabled = vim.fn.isdirectory(".git") == 1,
          cmd = "hub status --short --branch --renames",
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        {
          pane = 2,
          icon = " ",
          title = "Battery: " .. battery.get_battery_status() .. "%  Remain Time: " .. battery.get_battery_time(),
          height = 1,
        },
        { section = "startup" },
      },
    },
  },
}
