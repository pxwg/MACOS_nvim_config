-- 这段代码是为了定义一个硬编码n模式下q键关闭的浮动窗口，目标是实现在这个窗口内运行Copilot Chat 的输入，并且直接在cursor 后补全
local function create_floating_window()
  -- 创建浮动窗口的配置
  local buf = vim.api.nvim_create_buf(false, true)
  local width = 50
  local height = 10
  local border_buf = vim.api.nvim_create_buf(false, true)

  local border_opts = {
    style = "minimal",
    relative = "cursor",
    width = width + 2,
    height = height + 2,
    row = 1,
    col = 0,
  }

  -- 边框内容
  local border_lines = {}
  for i = 1, height + 2 do
    if i == 1 then
      table.insert(border_lines, "╭" .. string.rep("─", width) .. "╮")
    elseif i == height + 2 then
      table.insert(border_lines, "╰" .. string.rep("─", width) .. "╯")
    else
      table.insert(border_lines, "│" .. string.rep(" ", width) .. "│")
    end
  end

  -- 设置边框内容
  vim.api.nvim_buf_set_lines(border_buf, 0, -1, false, border_lines)

  -- 打开边框窗口
  vim.api.nvim_open_win(border_buf, true, border_opts)

  local opts = {
    style = "minimal",
    relative = "cursor",
    width = width,
    height = height,
    row = 1,
    col = 1,
  }

  -- 打开浮动窗口
  vim.api.nvim_open_win(buf, true, opts)

  -- 在浮动窗口中设置内容
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Hello, World!", "This is a floating window with a border." })

  -- 设置浮动窗口的文件类型为 markdown
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

  -- 设置按键映射来关闭窗口和 buffer
  vim.api.nvim_buf_set_keymap(buf, "n", "q", "<Cmd>bd!<CR><Cmd>bd!<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(border_buf, "n", "q", "<Cmd>bd!<CR><Cmd>bd!<CR>", { noremap = true, silent = true })
end

create_floating_window()
