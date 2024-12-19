local M = {}

-- HACK: 用于模拟cursor 的ai模式
function M.replace_content_and_back()
  local current_win = vim.api.nvim_get_current_win()
  local cursor_pos = vim.api.nvim_win_get_cursor(current_win)

  vim.schedule(function()
    vim.api.nvim_command('normal! "vy')
    vim.api.nvim_command("wincmd h")
    if vim.fn.getpos("'<")[2] ~= 0 and vim.fn.getpos("'>")[2] ~= 0 then
      vim.api.nvim_command('normal! gv"vp')
    else
      vim.api.nvim_command('normal! ggVG"vp')
    end
    vim.api.nvim_set_current_win(current_win)
    vim.api.nvim_win_set_cursor(current_win, cursor_pos)
  end)
end

function M.replace_content()
  vim.schedule(function()
    vim.api.nvim_command('normal! "vy')
    vim.api.nvim_command("wincmd h")
    if vim.fn.getpos("'<")[2] ~= 0 and vim.fn.getpos("'>")[2] ~= 0 then
      vim.api.nvim_command('normal! gv"vp')
    else
      vim.api.nvim_command('normal! ggVG"vp')
    end
  end)
end

function M.insert_content()
  vim.schedule(function()
    vim.api.nvim_command('normal! "vy')
    vim.api.nvim_command("wincmd h")
    if vim.fn.getpos("'<")[2] ~= 0 and vim.fn.getpos("'>")[2] ~= 0 then
      local end_pos = vim.fn.getpos("'>")
      local end_line = end_pos[2]
      vim.api.nvim_command(end_line + 1 .. 'normal! "vp')
    else
      vim.api.nvim_command('normal! G"vp')
    end
  end)
end

return M
