local M = {}

-- HACK: 用于模拟cursor 的ai模式
function M.replace_content()
  local current_win = vim.api.nvim_get_current_win()
  local cursor_pos = vim.api.nvim_win_get_cursor(current_win)

  vim.schedule(function()
    -- 复制当前选中的内容
    vim.api.nvim_command('normal! "vy')
    -- 切换到左侧窗口
    vim.api.nvim_command("wincmd h")
    -- 粘贴内容
    vim.api.nvim_command('normal! gv"vp')
    -- 切换回原窗口
    vim.api.nvim_set_current_win(current_win)
    vim.api.nvim_win_set_cursor(current_win, cursor_pos)
  end)
end

return M
