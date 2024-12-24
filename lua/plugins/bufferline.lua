return {
  "akinsho/bufferline.nvim",
  priority = 100,
  lazy = true,
  optional = true,
  -- event = "BufWinEnter",
  -- enabled = false,
  opts = function(_, opts)
    if (vim.g.colors_name or ""):find("catppuccin") then
      opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
    end
    opts.options = opts.options or {}
    opts.options.custom_filter = function(buf_number)
      local buf_ft = vim.bo[buf_number].filetype
      if buf_ft == "copilot-chat" or buf_ft == "snacks_dashboard" then
        return false
      end
      return true
    end
    opts.options.always_show_bufferline = false
    opts.options.show_buffer_close_icons = false
    opts.options.show_close_icon = false
    opts.options.separator_style = { " ", " " }
    return opts
  end,
}
