local M = {}

M.is_comment = function()
  local captures = vim.treesitter.get_captures_at_cursor(0)
  for _, capture in ipairs(captures) do
    if capture == "comment" then
      return true
    end
  end
  return false
end

_G.is_comment = M.is_comment

return M
