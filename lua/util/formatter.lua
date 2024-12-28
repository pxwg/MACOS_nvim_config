local signs = require("gitsigns")

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

vim.api.nvim_create_user_command("DiffFormat", diff_format, { desc = "Format changed lines" })
