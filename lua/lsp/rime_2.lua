local M = {}
-- local rime_ls_filetypes = { "markdown", "vimwiki", "tex" }
-- local rime_ls_filetypes = { "vimwiki" }
-- local cmp = require("cmp")

function M.setup_rime()
  -- global status
  vim.g.rime_enabled = true
  require("blink.cmp.completion.list").show_emitter:on(function(event)
    -- if last char is number, and the only completion item is provided by rime-ls, accept it
    local items = event.items
    local line = event.context.line
    local col = vim.fn.col(".") - 1
    if #items ~= 1 then
      return
    end
    if line:sub(col - 1, col):match("%a%d") == nil then
      return
    end
    local item = items[1]
    local client = vim.lsp.get_client_by_id(item.client_id)
    if (not client) or client.name ~= "rime_ls" then
      return
    end
    require("blink.cmp").accept({ index = 1 })
  end)
  -- add rime to lspconfig as a custom server
  local lspconfig = require("lspconfig")
  local configs = require("lspconfig.configs")
  if not configs.rime_ls then
    configs.rime_ls = {
      default_config = {
        name = "rime_ls",
        cmd = { vim.fn.expand("~/.config/nvim/rime-ls/target/release/rime_ls") }, -- your path to rime-ls
        -- cmd = vim.lsp.rpc.connect("127.0.0.1", 9257),
        filetypes = { "*" },
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
      end)
    end
    -- keymaps for executing command
    vim.keymap.set("n", "<leader>rr", toggle_rime, { desc = "Toggle [R]ime" })
    vim.keymap.set("i", "<C-x>", toggle_rime, { desc = "Toggle Rime" })
    vim.keymap.set("n", "<leader>rs", function()
      vim.lsp.buf.execute_command({ command = "rime-ls.sync-user-data" })
    end, { desc = "[R]ime [S]ync" })
  end

  -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
  capabilities.general.positionEncodings = { "utf-8", "utf-16" }

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
      show_filter_text_in_label = false,
      max_candidates = 9,
    },
    on_attach = rime_on_attach,
    capabilities = capabilities,
  })
end

return M
