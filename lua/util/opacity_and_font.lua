local M = {}

-- Inspired by https://github.com/wez/wezterm/discussions/2550

function M.set_opacity()
  local stdout = vim.loop.new_tty(1, false)

  stdout:write(
    ("\x1bPtmux;\x1b\x1b]1337;SetUserVar=%s=%s\b\x1b\\"):format(
      "WINDOW_OPACITY",
      vim.fn.system({ "base64" }, "1")
    )
  )

  vim.cmd([[redraw]])
end

function M.set_fontsize()
  local stdout = vim.loop.new_tty(1, false)

  stdout:write(
    ("\x1bPtmux;\x1b\x1b]1337;SetUserVar=%s=%s\b\x1b\\"):format("FONT_SIZE", vim.fn.system({ "base64" }, "+1"))
  )

  vim.cmd([[redraw]])
end

function M.back_opacity()
  local stdout = vim.loop.new_tty(1, false)
  stdout:write(
    ("\x1bPtmux;\x1b\x1b]1337;SetUserVar=%s=%s\b\x1b\\"):format("WINDOW_OPACITY", vim.fn.system({ "base64" }, "0.9"))
  )
  vim.cmd([[redraw]])
end

function M.back_fontsize()
  local stdout = vim.loop.new_tty(1, false)
  stdout:write(
    ("\x1bPtmux;\x1b\x1b]1337;SetUserVar=%s=%s\b\x1b\\"):format("FONT_SIZE", vim.fn.system({ "base64" }, "-1"))
  )
  vim.cmd([[redraw]])
end

return M
