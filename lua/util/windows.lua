local M = {}

-- TODO: 重构代码，使用更多的函数调用，KISS 原则，减少单个函数的不可复用性
-- mathematica 计算器
M.create_floating_window = function()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].filetype = "mma"
  vim.bo[buf].buftype = ""

  -- 初始窗口大小
  local width = 15
  local height = 1

  local win

  -- 获取初始光标位置
  local initial_cursor_pos = vim.api.nvim_win_get_cursor(0)
  local initial_cursor_row = initial_cursor_pos[1] + 1
  local initial_cursor_col = initial_cursor_pos[2]

  local function size_check(input_width, input_height)
    local out_width = input_width < 15 and 15 or input_width
    local out_height = input_height < 1 and 1 or input_height
    return { out_width, out_height }
  end

  local function update_window_size()
    vim.schedule(function()
      if not vim.api.nvim_win_is_valid(win) then
        return
      end

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
        width = width + 1,
        height = height,
        row = initial_cursor_row,
        col = initial_cursor_col,
        border = "rounded",
        title = "󰪚 Calculater",
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
    title = "󰪚 Calculater",
    -- title_pos = "center",
  }

  -- 打开浮动窗口
  win = vim.api.nvim_open_win(buf, true, opts)

  -- 设置按键映射来关闭窗口和 buffer
  vim.api.nvim_buf_set_keymap(buf, "n", "q", "<Cmd>lua ConfirmSaveAndClose()<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "<C-s>", "<Cmd>lua ConifrmAndSave()<CR>", { noremap = true, silent = true })

  -- 定义确认保存并关闭的函数
  function ConfirmSaveAndClose()
    local options = { "Yes", "No" }
    vim.ui.select(options, { prompt = "Save?" }, function(choice)
      if choice == "Yes" then
        SaveAndClose()
      else
        vim.api.nvim_command("q")
      end
    end)
  end

  function ConifrmAndSave()
    local options = { "Yes", "No" }
    vim.ui.select(options, { prompt = "Save?" }, function(choice)
      if choice == "Yes" then
        Save()
      end
    end)
  end

  -- 定义保存并关闭的函数
  function SaveAndClose()
    local file_path = "~/Desktop/physics/mma_draft/mma_" .. os.date("%Y%m%d%H%M%S") .. ".nb"
    vim.api.nvim_command("write " .. file_path)
    vim.api.nvim_command("q")
  end

  function Save()
    local file_path = "~/Desktop/physics/mma_draft/mma_" .. os.date("%Y%m%d%H%M%S") .. ".nb"
    vim.api.nvim_command("write " .. file_path)
  end

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

  local function size_check(in_width, in_height)
    local out_width = in_width < 9 and 9 or in_width
    local out_height = in_height < 1 and 1 or in_height
    return { out_width, out_height }
  end

  local width = size_check(input_width, input_height)[1]
  local height = size_check(input_width, input_height)[2]

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
    title_pos = "center",
  }

  -- 打开浮动窗口
  win = vim.api.nvim_open_win(buf, true, opts)

  vim.api.nvim_buf_set_keymap(buf, "n", "q", "<Cmd>:q<CR>", { noremap = true, silent = true })

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
