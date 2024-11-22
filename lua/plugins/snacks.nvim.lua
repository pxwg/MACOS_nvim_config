return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    dashboard = {
      preset = {
        header = [[
                                  /^ ^\
                                 / 0 0 \
        |\__/,|   (`\            V\ Y /V
      _.|o o  |_   ) )            / - \
    -(((---(((-------            /    |
                                V__) ||

        ]],
        -- stylua: ignore
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", title = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "r", title = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          {
            icon = " ",
            key = "p",
            title = "Physics Notes",
            action = ":cd /Users/pxwg-dogggie/Desktop/physics/notes/"},
          {
            icon = " ",
            key = "n",
            title = "New Draft",
            action = ":lua require('util.new_drafts').create_and_open_new_draft()"},
          { icon = " ", key = "g", title = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')"},
          {
            icon = " ",
            key = "c",
            title = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})"
            },
          { icon = " ", key = "s", title = "Restore Session", action = ":lua require('persistence').load()" },
          { icon = " ", key = "x", title = "Lazy Extras", action = ":LazyExtras"},
          { icon = "󰒲 ", key = "l", title = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", title = "Quit", action = ":qa" },
        },
      },
      sections = {
        { pane = 1, section = "header", padding = 1 },
        -- {
        --   pane = 2,
        --   section = "cat_and_dog",
        --   padding = 1,
        -- },
        { icon = " ", title = "Keymaps", section = "keys", indent = 1, padding = 1 },
        { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        {
          pane = 2,
          icon = " ",
          title = "Git Status",
          section = "terminal",
          -- enabled = LazyVim.git.get_root() ~= nil,
          cmd = "hub status --short --branch --renames",
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        { section = "startup" },
      },
    },
  },
}
