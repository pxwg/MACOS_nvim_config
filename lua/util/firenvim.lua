local M = {}

function M.adjust_minimum_lines()
  if vim.g.started_by_firenvim then
    if vim.o.lines < 25 then
      vim.o.lines = 25
    end
  end
end

return M
