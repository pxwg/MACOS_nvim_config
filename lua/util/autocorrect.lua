local M = {}

-- HACK: 用于对终端 autocorrect 的修正

function M.autocorrect()
  -- 获取当前 buffer 的绝对路径
  local path = vim.fn.expand("%:p")

  -- 构建终端命令
  local cmd = "autocorrect " .. path

  -- 执行终端命令并获取输出
  local handle = io.popen(cmd)
  if handle == nil then
    vim.notify("Failed to execute autocorrect command", vim.log.levels.WARN)
    return
  end

  local result = handle:read("*a")
  handle:close()

  if result == nil then
    vim.notify("Failed to read autocorrect command output", vim.log.levels.WARN)
    return
  end

  local lines = vim.fn.split(result, "\n")
  table.insert(lines, "") --
  for i = #lines, 1, -1 do
    if lines[i] ~= "" then
      break
    end
    table.remove(lines, i)
  end

  -- 将输出结果覆盖掉原先的文件
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

  -- 通知用户操作完成
  -- print("Autocorrect applied to " .. path)
end

return M
