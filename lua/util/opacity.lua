local M = {}

function M.set_opacity(disable)
  local stdout = vim.loop.new_tty(1, false)

  if disable then
    stdout:write(
      ("\x1bPtmux;\x1b\x1b]1337;SetUserVar=%s=%s\b\x1b\\"):format("WINDOW_OPACITY", vim.fn.system({ "base64" }, "1"))
    )
  else
    stdout:write(
      ("\x1bPtmux;\x1b\x1b]1337;SetUserVar=%s=%s\b\x1b\\"):format("WINDOW_OPACITY", vim.fn.system({ "base64" }, "0.9"))
    )
  end

  vim.cmd([[redraw]])
end

return M
