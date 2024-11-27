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
    quickfile = { enabled = true },
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
            action = ":lua Snacks.dashboard.pick('files')",
            desc = "Find file",
            icon = " ",
            key = "f",
          },
          {
            action = ":lua Snacks.dashboard.pick('oldfiles')",
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
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
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
