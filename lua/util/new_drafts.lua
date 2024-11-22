local M = {}

function M.create_and_open_new_draft()
  local base_path = "~/Desktop/physics/nvim_drafts/nvim_draft_"
  local extension = ".tex"
  local date_format = "%Y%m%d_%H%M" -- Format: YYYYMMDD_HHMM
  local date_str = os.date(date_format)
  local draft_path = base_path .. date_str .. extension
  -- Create the file
  vim.fn.writefile({}, vim.fn.expand(draft_path))
  -- Open the file in a new buffer
  vim.cmd("edit " .. draft_path)
end

return M
