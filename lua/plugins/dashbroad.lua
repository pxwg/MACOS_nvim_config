return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",

  opts = function()
    -- local logo = [[
    --        ██╗      █████╗ ███████╗██╗   ██╗ ██╗   ██╗ ██╗ ███╗   ███╗          Z
    --        ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝ ██║   ██║ ██║ ████╗ ████║      Z
    --        ██║     ███████║  ███╔╝  ╚████╔╝  ██║   ██║ ██║ ██╔████╔██║   z
    --        ██║     ██╔══██║ ███╔╝    ╚██╔╝   ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║ z
    --        ███████╗██║  ██║███████╗   ██║     ╚████╔╝  ██║ ██║ ╚═╝ ██║
    --        ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝      ╚═══╝   ╚═╝ ╚═╝     ╚═╝
    --
    --              -- customized for latex
    --        ]]

    local logo = [[

██████╗  ██████╗  ██████╗  ██████╗ ██╗███████╗     ██████╗ █████╗ ████████╗████████╗██╗███████╗
██╔══██╗██╔═══██╗██╔════╝ ██╔════╝ ██║██╔════╝    ██╔════╝██╔══██╗╚══██╔══╝╚══██╔══╝██║██╔════╝
██║  ██║██║   ██║██║  ███╗██║  ███╗██║█████╗      ██║     ███████║   ██║      ██║   ██║█████╗  
██║  ██║██║   ██║██║   ██║██║   ██║██║██╔══╝      ██║     ██╔══██║   ██║      ██║   ██║██╔══╝  
██████╔╝╚██████╔╝╚██████╔╝╚██████╔╝██║███████╗    ╚██████╗██║  ██║   ██║      ██║   ██║███████╗
╚═════╝  ╚═════╝  ╚═════╝  ╚═════╝ ╚═╝╚══════╝     ╚═════╝╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝╚══════╝


    ]]
    logo = string.rep("\n", 5) .. logo .. "\n\n"

    _G.create_and_open_new_draft = function()
      local base_path = "~/Desktop/physics/nvim_drafts/nvim_draft_"
      local extension = ".tex"
      local date_format = "%Y%m%d_%H%M" -- Format: YYYYMMDD_HHMM
      local date_str = os.date(date_format)
      local draft_path = base_path .. date_str .. extension

      -- Create the file
      vim.fn.writefile({}, vim.fn.expand(draft_path))

      -- Open the file in a new buffer
      vim.cmd("edit " .. draft_path)
    end
    --
    local opts = {
      theme = "doom",
      hide = {
        -- this is taken care of by lualine
        -- enabling this messes up the actual laststatus setting after loading a file
        statusline = false,
      },
      preview = {
        -- command = "cat", -- preview command
        file_path = "~/.config/nvim/logo.txt", -- preview file path
        file_height = 80, -- preview file height
        file_width = 80, -- preview file width
      },
      config = {
        header = vim.split(logo, "\n"),
          -- stylua: ignore
          center = {
            { action = "Telescope find_files",                                     desc = " Find file",       icon = " ", key = "f" },
            { action = "Telescope oldfiles",                                       desc = " Recent files",    icon = " ", key = "r" },
            { action = "cd ~/Desktop/physics/notes",                               desc = " Physics Notes",   icon = " ", key = "p" },
            { action = 'lua create_and_open_new_draft()',                          desc = " New Draft", icon = " ", key = "n" },
            { action = "Telescope live_grep",                                      desc = " Find text",       icon = " ", key = "g" },
            { action = 'lua LazyVim.pick.config_files()()',                        desc = " Config",          icon = " ", key = "c" },
            { action = 'lua require("persistence").load()',                        desc = " Restore Session", icon = " ", key = "s" },
            { action = "LazyExtras",                                               desc = " Lazy Extras",     icon = " ", key = "x" },
            { action = "Lazy",                                                     desc = " Lazy",            icon = "󰒲 ", key = "l" },
            { action = "qa",                                                       desc = " Quit",            icon = " ", key = "q" },
          },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
        end,
      },
    }
    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
      button.key_format = "  %s"
    end

    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        pattern = "DashboardLoaded",
        callback = function()
          require("lazy").show()
        end,
      })
    end
    return opts
  end,
}
