local M = {}
-- local rime_ls_filetypes = { "markdown", "vimwiki", "tex" }
local rime_ls_filetypes = { "vimwiki" }
local cmp = require("cmp")

function M.setup_rime()
  -- global status
  vim.g.rime_enabled = true

  -- add rime-ls to lspconfig as a custom server
  -- see `:h lspconfig-new`
  local lspconfig = require("lspconfig")
  local configs = require("lspconfig.configs")
  if not configs.rime_ls then
    configs.rime_ls = {
      default_config = {
        name = "rime_ls",
        cmd = { vim.fn.expand("/usr/local/bin/rime_ls") }, -- your path to rime-ls
        filetypes = rime_ls_filetypes,
        single_file_support = true,
        autostart = true, -- Add this line to prevent automatic start, in order to boost
      },
      settings = {},
      docs = {
        description = [[
https://www.github.com/wlh320/rime-ls

A language server for librime
]],
      },
    }
  end

  local rime_on_attach = function(client, _)
    local toggle_rime = function()
      client.request("workspace/executeCommand", { command = "rime-ls.toggle-rime" }, function(_, result, ctx, _)
        if ctx.client_id == client.id then
          vim.g.rime_enabled = result
        end
        if cmp.visible() then
          if not vim.g.rime_enabled then
            cmp.close()
          end
          cmp.complete()
        end
      end)
    end
    -- keymaps for executing command
    -- vim.keymap.set("i", "jn", toggle_rime)
    vim.keymap.set("n", "<localleader>rs", function()
      vim.lsp.buf.execute_command({ command = "rime-ls.sync-user-data" })
    end)
  end

  -- Function to attach LSP only in insert mode, which could boost the performance
  local function attach_in_normal_mode(client, bufnr)
    if not client.attached_buffers[bufnr] then
      print("Attaching buffer:", bufnr)
      client.attached_buffers[bufnr] = true
      client.config.on_attach(client, bufnr)
    end
  end

  local function deattach(client, bufnr)
    if client.attached_buffers[bufnr] then
      print("Detaching buffer:", bufnr)
      client.attached_buffers[bufnr] = false
      if client.config.on_detach then
        client.config.on_detach(client, bufnr)
      end
    end
  end
  --
  -- local function tex_in_math(client, bufnr)
  --   print("tex_in_math called with rime_toggled:", rime_toggled, "rime_ls_active:", rime_ls_active)
  --   if rime_toggled == false and rime_ls_active == false then
  --     attach_in_normal_mode(client, bufnr)
  --   else
  --     deattach(client, bufnr)
  --   end
  -- end

  -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
  -- local function is_cursor_in_braces()
  --   local cursor_pos = vim.api.nvim_win_get_cursor(0)
  --   local line = vim.api.nvim_get_current_line()
  --   local before_cursor = line:sub(1, cursor_pos[2])
  --   local after_cursor = line:sub(cursor_pos[2] + 1)
  --
  --   local open_braces = before_cursor:match("{")
  --   local close_braces = after_cursor:match("}")
  --
  --   return open_braces and close_braces
  -- end
  --
  -- local function tex_in_math(client, bufnr)
  --   print("tex_in_math called with rime_toggled:", rime_toggled, "rime_ls_active:", rime_ls_active)
  --   if is_cursor_in_braces() then
  --     attach_in_normal_mode(client, bufnr)
  --   else
  --     deattach(client, bufnr)
  --   end
  -- end
  --
  -- lspconfig.texlab.setup({
  --   on_attach = tex_in_math,
  -- })

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
  capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
  capabilities.general.positionEncodings = { "utf-8" }

  lspconfig.rime_ls.setup({
    init_options = {
      enabled = vim.g.rime_enabled,
      shared_data_dir = "/Library/Input Methods/Squirrel.app/Contents/SharedSupport",
      user_data_dir = "~/Library/Rime_2/",
      log_dir = vim.fn.expand("~/.local/share/rime-ls"),
      -- paging_characters = { "-", "=", ",", ".", "?", "!" },
      paging_characters = { ",", "." },
      trigger_characters = {},
      schema_trigger_character = "&",
      -- show_filter_text_in_label = false,
      max_candidates = 9,
      long_filter_text = true,
    },
    -- on_attach = attach_in_insert_mode,
    on_attach = rime_on_attach,
    capabilities = capabilities,
  })
end

function M.toggle_rime()
  local client = vim.lsp.get_clients({ name = "rime_ls" })[1]
  if client then
    client.request("workspace/executeCommand", { command = "rime-ls.toggle-rime" }, function(_, result, ctx, _)
      if ctx.client_id == client.id then
        vim.g.rime_enabled = result
      end
      if cmp.visible() then
        if not vim.g.rime_enabled then
          cmp.close()
        end
        cmp.complete()
      end
    end)
  end
end

return M
