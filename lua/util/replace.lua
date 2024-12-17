local M = {}

-- HACK: 用于模拟cursor 的ai模式
function M.replace_content()
  local current_win = vim.api.nvim_get_current_win()
  local cursor_pos = vim.api.nvim_win_get_cursor(current_win)

  vim.schedule(function()
    vim.api.nvim_command('normal! "vy')
    vim.api.nvim_command("wincmd h")
    vim.api.nvim_command('normal! gv"vp')
    vim.api.nvim_set_current_win(current_win)
    vim.api.nvim_win_set_cursor(current_win, cursor_pos)
  end)
end

return M
