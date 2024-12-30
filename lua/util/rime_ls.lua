local M = {}
  lspconfig.rime_ls.setup({
    init_options = {
      enabled = vim.g.rime_enabled,
      shared_data_dir = "/usr/share/rime-data",
      user_data_dir = "~/.local/share/rime-ls",
      log_dir = "/tmp",
      max_candidates = 9,
      paging_characters = { ",", "." },
      trigger_characters = {},
      schema_trigger_character = "&",
      max_tokens = 0,
      always_incomplete = false,
      preselect_first = false,
      show_filter_text_in_label = false,
      long_filter_text = true,
    },
    on_attach = rime_on_attach,
    capabilities = capabilities,
  })

function M.check_rime_status()
  local clients = vim.lsp.get_clients()
  for _, client in ipairs(clients) do
    if client.name == "rime_ls" then
      return true
    end
  end
  return false
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
