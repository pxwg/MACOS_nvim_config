return {
  {
    "saghen/blink.compat",
    -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
    version = "*",
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },
  {
    "saghen/blink.cmp",
    lazy = false, -- lazy loading handled internally
    -- use a release tag to download pre-built binaries
    version = "v0.*",
    dependencies = {
      -- add source
      { "dmitmel/cmp-digraphs" },
    },
    -- build = 'cargo build --release',
    config = function()
      -- if last char is number, and the only completion item is provided by rime-ls, accept it
      require("blink.cmp.completion.list").show_emitter:on(function(event)
        if #event.items ~= 1 then
          return
        end
        local col = vim.fn.col(".") - 1
        if event.context.line:sub(1, col):match("^.*%a+%d+$") == nil then
          return
        end
        local client = vim.lsp.get_client_by_id(event.items[1].client_id)
        if (not client) or client.name ~= "rime_ls" then
          return
        end
        require("blink.cmp").accept({ index = 1 })
      end)

      -- link BlinkCmpKind to CmpItemKind since nvchad/base46 does not support it
      local set_hl = function(hl_group, opts)
        opts.default = true -- Prevents overriding existing definitions
        vim.api.nvim_set_hl(0, hl_group, opts)
      end
      for _, kind in ipairs(require("blink.cmp.types").CompletionItemKind) do
        set_hl("BlinkCmpKind" .. kind, { link = "CmpItemKind" .. kind or "BlinkCmpKind" })
      end

      require("blink.cmp").setup({
        keymap = {
          preset = "enter", -- 'default', 'super-tab', 'enter'
          ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
          ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
          ["<C-y>"] = { "show", "select_and_accept" },
        },
        completion = {
          documentation = {
            auto_show = true,
          },
          menu = {
            auto_show = function(ctx)
              return ctx.mode ~= "cmdline"
            end,
            draw = {
              columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
            },
            border = "single",
            winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None,FloatBorder:CmpBorder",
          },
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer", "digraphs" },
          providers = {
            digraphs = {
              name = "digraphs", -- IMPORTANT: use the same name as you would for nvim-cmp
              module = "blink.compat.source",

              -- all blink.cmp source config options work as normal:
              score_offset = -3,

              -- this table is passed directly to the proxied completion source
              -- as the `option` field in nvim-cmp's source config
              --
              -- this is NOT the same as the opts in a plugin's lazy.nvim spec
              opts = {
                -- this is an option from cmp-digraphs
                cache_digraphs_on_start = true,
              },
            },
            lsp = {
              transform_items = function(_, items)
                for _, item in ipairs(items) do
                  if item.kind == require("blink.cmp.types").CompletionItemKind.Snippet then
                    item.score_offset = item.score_offset - 3
                  end
                end
                return items
              end,
            },
          },
        },
      })
    end,
  },
}
