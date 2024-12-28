local signs = require("gitsigns")

-- 暂时还不可以使用

local function print_hunks()
  local data = signs.get_hunks()
  if not data then
    print("No hunks available")
    return
  end
  for _, hunk in ipairs(data) do
    print(vim.inspect(hunk))
  end
end

_G.print_hunks = print_hunks

local diff_format = function()
  local data = signs.get_hunks()
  if not data or not vim.g.conform_autoformat then
    -- vim.notify("no hunks in this buffer, formatting all")
    require("conform").format({ lsp_fallback = true, timeout_ms = 500 })
    return
  end
  local ranges = {}
  for _, hunk in ipairs(data) do
    if hunk.type ~= "delete" then
      local total_lines = vim.api.nvim_buf_line_count(0)
      local end_line = hunk.added.start + hunk.added.count
      if end_line > total_lines then
        end_line = total_lines
      end

      local start_line = hunk.added.start
      if start_line < 1 then
        start_line = 1
      end
      table.insert(ranges, 1, {
        start = { start_line, 0 },
        ["end"] = { end_line, 0 },
      })
    end
  end

  for _, range in pairs(ranges) do
    require("conform").format({ lsp_fallback = true, timeout_ms = 500, range = range })
  end
end

-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*",
--   callback = function()
--     local ft = vim.bo.filetype
--     if ft ~= "tex" and ft ~= "markdown" then
--       diff_format()
--     end
--   end,
--   desc = "Auto format changed lines",
-- })

-- vim.api.nvim_create_user_command("DiffFormat", diff_format, { desc = "Format changed lines" })

local function record_hunks(bufnr)
  local data = signs.get_hunks(bufnr)
  if not data then
    print("No hunks available")
    return nil
  end
  return data
end

local function apply_hunks_to_buffer(hunks, temp_bufnr)
  for _, hunk in ipairs(hunks) do
    if hunk.type ~= "delete" then
      local start_line = hunk.added.start - 1
      local end_line = hunk.added.start - 1 + hunk.added.count
      local lines = vim.api.nvim_buf_get_lines(temp_bufnr, start_line, end_line, false)
      vim.api.nvim_buf_set_lines(0, start_line, end_line, false, lines)
    end
  end
end

local function diff_format_hunks()
  local bufnr = vim.api.nvim_get_current_buf()
  local hunks = record_hunks(bufnr)
  if not hunks then
    print("No hunks to format")
    return
  end

  -- Create a temporary buffer
  local temp_bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(temp_bufnr, 0, -1, false, vim.api.nvim_buf_get_lines(bufnr, 0, -1, false))

  -- Format the entire buffer and save to the temporary buffer
  vim.api.nvim_buf_call(temp_bufnr, function()
    require("conform").format({ lsp_fallback = true, timeout_ms = 500 })
  end)

  -- Apply hunks to the original buffer
  apply_hunks_to_buffer(hunks, temp_bufnr)

  -- Delete the temporary buffer
  vim.api.nvim_buf_delete(temp_bufnr, { force = true })
end

vim.api.nvim_create_user_command("DiffFormat", diff_format_hunks, { desc = "Format changed lines" })
