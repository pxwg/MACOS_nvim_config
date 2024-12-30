-- TeX 文件类型设置
vim.opt_local.expandtab = true -- 将 Tab 键转换为空格
vim.opt_local.tabstop = 1 -- 设置 Tab 宽度为 1 个空格
vim.opt_local.shiftwidth = 1 -- 每次缩进使用 1 个空格

-- -- 离开文件时重置选项
-- vim.api.nvim_create_autocmd("BufLeave", {
--   buffer = 0, -- 0 表示当前缓冲区
--   callback = function()
--     vim.opt_local.expandtab = false
--     vim.opt_local.tabstop = 8 -- 重置为默认值或其他值
--     vim.opt_local.shiftwidth = 8 -- 重置为默认值或其他值
--   end,
-- })
-- vim.cmd([[LspStart rime_ls]])
