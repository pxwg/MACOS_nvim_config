local M = {}

-- HACK: 用于模拟cursor 的ai模式,其中强调了对GPT抽风输出行号的自动处理，用的是正则表达式，原则上不会点背到直接匹配上了吧

function M.replace_content_and_back()
  local current_win = vim.api.nvim_get_current_win()
  local cursor_pos = vim.api.nvim_win_get_cursor(current_win)

  vim.api.nvim_command('normal! "vy')
  vim.api.nvim_command("wincmd h")

  local content = vim.fn.getreg("v")
  local lines = vim.split(content, "\n")
  for i, line in ipairs(lines) do
    lines[i] = line:gsub("^%s*%d+:*", "", 1)
  end
  vim.fn.setreg("v", table.concat(lines, "\n"))
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  if start_pos[2] ~= 0 and end_pos[2] ~= 0 then
    vim.api.nvim_command('normal! gv"vp')
  else
    vim.api.nvim_command('normal! ggVG"vp')
  end

  vim.api.nvim_set_current_win(current_win)
  vim.api.nvim_win_set_cursor(current_win, cursor_pos)
end

function M.replace_content()
  vim.api.nvim_command('normal! "vy')
  vim.api.nvim_command("wincmd h")

  local content = vim.fn.getreg("v")
  local lines = vim.split(content, "\n")
  for i, line in ipairs(lines) do
    lines[i] = line:gsub("^%s*%d+:*", "", 1)
  end
  vim.fn.setreg("v", table.concat(lines, "\n"))
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  if start_pos[2] ~= 0 and end_pos[2] ~= 0 then
    vim.api.nvim_command('normal! gv"vp')
  else
    vim.api.nvim_command('normal! ggVG"vp')
  end
end

function M.insert_content()
  vim.schedule(function()
    vim.api.nvim_command('normal! "vy')
    vim.api.nvim_command("wincmd h")
    local content = vim.fn.getreg("v")
    local lines = vim.split(content, "\n")
    for i, line in ipairs(lines) do
      lines[i] = line:gsub("^%s*%d+:*", "")
    end
    vim.fn.setreg("v", table.concat(lines, "\n"))
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    if start_pos[2] ~= 0 and end_pos[2] ~= 0 then
      local line_num = end_pos[2] + 2
      vim.api.nvim_command(line_num .. 'normal! "vp')
    else
      vim.api.nvim_command("normal! Go")
      vim.api.nvim_command('normal! "vp')
    end
  end)
end

return M
