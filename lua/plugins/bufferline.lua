return {
  "akinsho/bufferline.nvim",
  priority = 100,
  optional = true,
  -- enabled = false,
  opts = function(_, opts)
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
