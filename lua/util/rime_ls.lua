local M = {}

function M.check_rime_status()
  local clients = vim.lsp.get_active_clients()
  for _, client in ipairs(clients) do
    if client.name == "rime_ls" then
      return "ㄓ"
    end
  end
  return ""
end

-- cannot be used in this way
-- function M.setup_autocmd()
--   vim.api.nvim_create_augroup("RimeStatusGroup", { clear = true })
--
--   vim.api.nvim_create_autocmd("BufReadPost", {
--     group = "RimeStatusGroup",
--     callback = function()
--       return M.check_rime_status()
--     end,
--   })
-- end

return M
