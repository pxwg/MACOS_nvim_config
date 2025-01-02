local M = {}

function M.check_rime_status()
  local clients = vim.lsp.get_clients()
  for _, client in ipairs(clients) do
    if client.name == "rime_ls" then
      return true
    end
  end
  return false
end

function M.enable_lsps()
  -- 恢复所有 LSP
  vim.cmd("LspStart")
  vim.cmd([[Copilot enable]])
  vim.b.lsp_disabled = false
end

function M.disable_lsps()
  -- 禁止所有 LSP 除了 rime_ls
  local active_clients = vim.lsp.get_clients()
  for _, client in ipairs(active_clients) do
    -- if client.name ~= "rime_ls" and client.name ~= "copilot" then
    -- 短暂禁用copilot 在中文输入，因为短时间内还不支持，但预计之后可以支持
    if client.name ~= "rime_ls" then
      vim.lsp.stop_client(client.id)
    end
    vim.cmd([[Copilot disable]])
  end
  vim.b.lsp_disabled = true
end

function M.toggle_lsps()
  if vim.b.lsp_disabled then
    M.enable_lsps()
    vim.b.lsp_disabled = not vim.b.lsp_disabled
  else
    M.disable_lsps()
    vim.b.lsp_disabled = true
  end
end

function M.check_lsps()
  local clients = vim.lsp.get_active_clients()
  for _, client in ipairs(clients) do
    if client.name ~= "rime_ls" and client.name ~= "copilot" then
      return true
    end
  end
  return false
end

function M.check_lsps_check()
  if vim.b.lsp_disabled then
    M.enable_lsps()
    return
  end

  local start_time = vim.loop.now()
  local timer = vim.loop.new_timer()

  -- HACK: 为了避免在启动时触发lsp, 这很可能导致一些未知的问题，比如说因为编码冲突导致的智障
  timer:start(
    0,
    100,
    vim.schedule_wrap(function()
      if vim.loop.now() - start_time >= 3000 then
        timer:stop()
        timer:close()
        if not M.check_lsps() then
          M.enable_lsps()
          vim.b.lsp_disabled = false
        end
      elseif M.check_lsps() then
        timer:stop()
        timer:close()
        M.disable_lsps()
        vim.b.lsp_disabled = true
      end
    end)
  )
end

function M.toggle_lsps_check()
  if vim.b.lsp_disabled then
    -- M.enable_lsps()
    return
  end

  local start_time = vim.loop.now()
  local timer = vim.loop.new_timer()

  -- HACK: 为了避免在启动时触发lsp, 这很可能导致一些未知的问题，比如说因为编码冲突导致的智障
  timer:start(
    0,
    100,
    vim.schedule_wrap(function()
      if vim.loop.now() - start_time >= 3000 then
        timer:stop()
        timer:close()
        if not M.check_lsps() then
          M.enable_lsps()
          vim.b.lsp_disabled = false
        end
      elseif M.check_lsps() then
        timer:stop()
        timer:close()
        M.disable_lsps()
        vim.b.lsp_disabled = true
      end
    end)
  )
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
