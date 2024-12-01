return {
  "akinsho/bufferline.nvim",
  priority = 100,
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
    opts.options.always_show_bufferline = true
    return opts
  end,
}
