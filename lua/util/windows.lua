local M = {}

-- mathematica 计算器
M.create_floating_window = function()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].filetype = "mma"

  -- 初始窗口大小
  local width = 15
  local height = 2

  local win

  -- 获取初始光标位置
  local initial_cursor_pos = vim.api.nvim_win_get_cursor(0)
  local initial_cursor_row = initial_cursor_pos[1] + 1
  local initial_cursor_col = initial_cursor_pos[2]

  local function size_check(input_width, input_height)
    local out_width = input_width < 15 and 15 or input_width
    local out_height = input_height < 2 and 2 or input_height
    return { out_width, out_height }
  end

  local function update_window_size()
    vim.schedule(function()
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local max_line_length = 0
      for _, line in ipairs(lines) do
        if #line > max_line_length then
          max_line_length = #line
        end
      end

      local size = size_check(max_line_length, #lines)
      width = size[1]
      height = size[2]

      -- 更新窗口大小和位置
      vim.api.nvim_win_set_config(win, {
        style = "minimal",
        relative = "editor",
        width = width,
        height = height,
        row = initial_cursor_row,
        col = initial_cursor_col,
        border = "rounded",
        title = "󰪚 Mathematica",
        -- title_pos = "center",
      })
    end)
  end

  local opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = initial_cursor_row,
    col = initial_cursor_col,
    border = "rounded",
    title = "󰪚 Mathematica",
    -- title_pos = "center",
  }

  -- 打开浮动窗口
  win = vim.api.nvim_open_win(buf, true, opts)

  -- 设置按键映射来关闭窗口和 buffer
  vim.api.nvim_buf_set_keymap(buf, "n", "q", "<Cmd>:q<CR>", { noremap = true, silent = true })

  -- 监听缓冲区变化
  vim.api.nvim_buf_attach(buf, false, {
    on_lines = function()
      update_window_size()
    end,
  })

  return buf, win
end

M.create_floating_window_with_size = function(input_width, input_height)
  local buf = vim.api.nvim_create_buf(false, true)
  local border_buf = vim.api.nvim_create_buf(false, true)

  local width = input_width
  local height = input_height

  local win
  -- 获取初始光标位置
  local initial_cursor_pos = vim.api.nvim_win_get_cursor(0)
  local initial_cursor_row = initial_cursor_pos[1]
  local initial_cursor_col = initial_cursor_pos[2] + 9

  local opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = initial_cursor_row,
    col = initial_cursor_col,
    border = "rounded",
    title = " Result",
  }

  -- 打开浮动窗口
  win = vim.api.nvim_open_win(buf, true, opts)

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
