local M = {}

function M.select_markdown_code_block()
  local search_pattern = "^```"
  vim.fn.search(search_pattern, "bW")
  vim.api.nvim_command("normal! kV")
  vim.fn.search(search_pattern, "bW")
  vim.api.nvim_command("normal! j")
end

return M
