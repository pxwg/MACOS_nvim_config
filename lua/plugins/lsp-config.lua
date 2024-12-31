return {
  'neovim/nvim-lspconfig',
  event = "LazyFile",
  dependencies = {
    -- Setup lsp installed in mason
    'williamboman/mason-lspconfig.nvim',
    -- Useful status updates for LSP
    { 'j-hui/fidget.nvim', config = true },
  },
  config = function()
    -- LSP settings.
    --  This function gets run when an LSP connects to a particular buffer.
    local on_attach = function(client, bufnr)
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      -- local nmap = function(keys, func, desc)
      --   if desc then
      --     desc = 'LSP: ' .. desc
      --   end
      --   vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      -- end

      -- -- nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
      -- nmap('<leader>rn', require('nvchad.lsp.renamer'), '[R]e[n]ame')
      -- nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
      --
      -- nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
      -- nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
      -- nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
      --
      -- -- See `:help K` for why this keymap
      -- nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
      -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
      --
      -- -- Lesser used LSP functionality
      -- nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
      -- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
      -- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
      -- nmap('<leader>wl', function()
      --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      -- end, '[W]orkspace [L]ist Folders')

      -- inlay hint
      if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true)
      end

      -- code lens
      if client.server_capabilities.codeLensProvider then
        vim.lsp.codelens.refresh({ bufnr = bufnr })
        vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
          buffer = bufnr,
          callback = function()
            vim.lsp.codelens.refresh({ bufnr = bufnr })
          end,
        })
      end

    end

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
    -- force utf-8
    capabilities.general.positionEncodings = { 'utf-8', 'utf-16' }

    -- Load mason_lspconfig
    require('mason-lspconfig').setup_handlers {
      function(server_name)
        require('lspconfig')[server_name].setup {
          capabilities = capabilities,
          on_attach = on_attach,
        }
      end,
      -- dedicated handler
      ["texlab"] = function()
        require('lspconfig').texlab.setup {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = {
            texlab = {
              -- I prefer formatting bibtex file with latexindent
              bibtexFormatter = 'latexindent'
            }
          }
        }
      end
    }
  end
}
