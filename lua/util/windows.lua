local M = {}

M.create_floating_window = function()
  -- 创建浮动窗口的配置
  local buf = vim.api.nvim_create_buf(false, true)
  local border_buf = vim.api.nvim_create_buf(false, true)

  -- 初始窗口大小
  local width = 1
  local height = 1

  local win, border_win

  -- 获取初始光标位置
  local initial_cursor_pos = vim.api.nvim_win_get_cursor(0)
  local initial_cursor_row = initial_cursor_pos[1] + 1
  local initial_cursor_col = initial_cursor_pos[2]

  local function update_window_size()
    vim.schedule(function()
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local max_line_length = 0
      for _, line in ipairs(lines) do
        if #line > max_line_length then
          max_line_length = #line
        end
      end
      width = max_line_length
      height = #lines

      -- 更新边框内容
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
      vim.api.nvim_buf_set_lines(border_buf, 0, -1, false, border_lines)

      -- 更新窗口大小和位置
      vim.api.nvim_win_set_config(win, {
        style = "minimal",
        relative = "editor",
        width = width,
        height = height,
        row = initial_cursor_row,
        col = initial_cursor_col + 1,
      })
      vim.api.nvim_win_set_config(border_win, {
        style = "minimal",
        relative = "editor",
        width = width + 2,
        height = height + 2,
        row = initial_cursor_row - 1,
        col = initial_cursor_col - 1,
      })
    end)
  end

  local border_opts = {
    style = "minimal",
    relative = "editor",
    width = width + 2,
    height = height + 2,
    row = initial_cursor_row - 1,
    col = initial_cursor_col - 1,
  }

  -- 设置边框内容
  local border_lines = {
    "╭─╮",
    "│ │",
    "╰─╯",
  }
  vim.api.nvim_buf_set_lines(border_buf, 0, -1, false, border_lines)

  -- 打开边框窗口
  border_win = vim.api.nvim_open_win(border_buf, true, border_opts)

  local opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = initial_cursor_row,
    col = initial_cursor_col,
  }

  -- 打开浮动窗口
  win = vim.api.nvim_open_win(buf, true, opts)

  -- 设置按键映射来关闭窗口和 buffer
  vim.api.nvim_buf_set_keymap(buf, "n", "q", "<Cmd>bd!<CR><Cmd>bd!<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(border_buf, "n", "q", "<Cmd>bd!<CR><Cmd>bd!<CR>", { noremap = true, silent = true })

  -- 监听缓冲区变化
  vim.api.nvim_buf_attach(buf, false, {
    on_lines = function()
      update_window_size()
    end,
  })

  return buf, win
end

M.create_floating_window_with_size = function(input_width, input_height)
  -- 创建浮动窗口的配置
  local buf = vim.api.nvim_create_buf(false, true)
  local border_buf = vim.api.nvim_create_buf(false, true)

  -- 初始窗口大小
  local width = input_width
  local height = input_height

  local win, border_win

  -- 获取初始光标位置
  local initial_cursor_pos = vim.api.nvim_win_get_cursor(0)
  local initial_cursor_row = initial_cursor_pos[1]
  local initial_cursor_col = initial_cursor_pos[2] + 9

  local function update_window_size()
    vim.schedule(function()
      -- 更新边框内容
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
      vim.api.nvim_buf_set_lines(border_buf, 0, -1, false, border_lines)

      -- 更新窗口大小和位置
      vim.api.nvim_win_set_config(win, {
        style = "minimal",
        relative = "editor",
        width = width,
        height = height,
        row = initial_cursor_row,
        col = initial_cursor_col,
      })
      vim.api.nvim_win_set_config(border_win, {
        style = "minimal",
        relative = "editor",
        width = width + 2,
        height = height + 2,
        row = initial_cursor_row - 1,
        col = initial_cursor_col - 1,
      })
    end)
  end

  local border_opts = {
    style = "minimal",
    relative = "editor",
    width = width + 2,
    height = height + 2,
    row = initial_cursor_row - 1,
    col = initial_cursor_col - 1,
  }

  -- 设置边框内容

  local border_lines = {}
  table.insert(border_lines, "╭" .. string.rep("─", width) .. "╮")
  for i = 1, height do
    table.insert(border_lines, "│" .. string.rep(" ", width) .. "│")
  end
  table.insert(border_lines, "╰" .. string.rep("─", width) .. "╯")

  vim.api.nvim_buf_set_lines(border_buf, 0, -1, false, border_lines)

  -- 打开边框窗口
  border_win = vim.api.nvim_open_win(border_buf, true, border_opts)

  local opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = initial_cursor_row,
    col = initial_cursor_col,
  }

  -- 打开浮动窗口
  win = vim.api.nvim_open_win(buf, true, opts)

  -- 设置按键映射来关闭窗口和 buffer
  vim.api.nvim_buf_set_keymap(buf, "n", "q", "<Cmd>bd!<CR><Cmd>bd!<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(border_buf, "n", "q", "<Cmd>bd!<CR><Cmd>bd!<CR>", { noremap = true, silent = true })

  -- 监听缓冲区变化
  vim.api.nvim_buf_attach(buf, false, {
    on_lines = function()
      update_window_size()
    end,
  })

  return buf, win
end

-- M.create_floating_window_with_size(30, 20)

return M

-- local function open_terminal_in_floating_window()
--   -- 创建浮动窗口并打开终端
--   local buf, win = create_floating_window()
--   vim.fn.termopen(vim.o.shell)
--   vim.cmd("startinsert")
-- end
