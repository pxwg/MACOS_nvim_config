function contains_unacceptable_character(content)
  if content == nil then
    return true
  end
  local ignored_head_number = false
  for i = 1, #content do
    local b = string.byte(content, i)
    if b >= 48 and b <= 57 or b == 32 or b == 46 then
      -- number dot and space
      if ignored_head_number then
        return true
      end
    elseif b <= 127 then
      return true
    else
      ignored_head_number = true
    end
  end
  return false
end
function is_rime_item(item)
  if item == nil or item.source_name ~= "LSP" then
    return false
  end
  local client = vim.lsp.get_client_by_id(item.client_id)
  return client ~= nil and client.name == "rime_ls"
end
--- @param item blink.cmp.CompletionItem
function rime_item_acceptable(item)
  -- return true
  return not contains_unacceptable_character(item.label) or item.label:match("%d%d%d%d%-%d%d%-%d%d %d%d:%d%d:%d%d%")
end
function get_n_rime_item_index(n, items)
  if items == nil then
    items = require("blink.cmp.completion.list").items
  end
  local result = {}
  if items == nil or #items == 0 then
    return result
  end
  for i, item in ipairs(items) do
    if is_rime_item(item) and rime_item_acceptable(item) then
      result[#result + 1] = i
      if #result == n then
        break
      end
    end
  end
  return result
end

return {
  {
    "saghen/blink.compat",
    -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
    event = "InsertEnter",
    version = "*",
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    -- use a release tag to download pre-built binaries
    version = "*",
    build = "cargo build --release",
    dependencies = {
      -- add source
      {
        "dmitmel/cmp-digraphs",
        "L3MON4D3/LuaSnip",
        "mikavilpas/blink-ripgrep.nvim",
        "giuxtaposition/blink-cmp-copilot",
        "zbirenbaum/copilot-cmp",
      },
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
          preset = "none",
          ["<cr>"] = { "accept", "fallback" },
          ["<tab>"] = { "snippet_forward", "fallback" },
          ["<C-y>"] = { "select_and_accept" },
          ["<s-tab>"] = { "snippet_backward", "fallback" },
          ["<c-j>"] = { "scroll_documentation_up", "fallback" },
          ["<c-k>"] = { "scroll_documentation_down", "fallback" },
          ["<c-n>"] = { "select_next", "fallback" },
          ["<down>"] = { "select_next", "fallback" },
          ["<up>"] = { "select_prev", "fallback" },
          ["<c-p>"] = { "select_prev", "fallback" },
          ["<c-x>"] = { "show", "fallback" },
          ["<c-c>"] = { "cancel", "fallback" },
          ["<space>"] = {
            function(cmp)
              if not vim.g.rime_enabled then
                return false
              end
              local rime_item_index = get_n_rime_item_index(1)
              if #rime_item_index ~= 1 then
                return false
              end
              return cmp.accept({ index = rime_item_index[1] })
            end,
            "fallback",
          },
          [";"] = {
            -- FIX: can not work when binding ;<space> to other key
            function(cmp)
              if not vim.g.rime_enabled then
                return false
              end
              local rime_item_index = get_n_rime_item_index(2)
              if #rime_item_index ~= 2 then
                return false
              end
              return cmp.accept({ index = rime_item_index[2] })
            end,
            "fallback",
          },
          ["'"] = {
            function(cmp)
              if not vim.g.rime_enabled then
                return false
              end
              local rime_item_index = get_n_rime_item_index(3)
              if #rime_item_index ~= 3 then
                return false
              end
              return cmp.accept({ index = rime_item_index[3] })
            end,
            "fallback",
          },
        },
        completion = {
          documentation = {
            auto_show = true,
          },
          menu = {
            auto_show = function(ctx)
              return ctx.mode ~= "cmdline"
            end,
            -- auto_show = true,
            draw = {
              columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
            },
            border = "rounded",
            winhighlight = "FloatBorder:CmpBorder",
            -- winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel,FloatBorder:CmpBorder",
          },
        },
        sources = {
          -- default = { "lsp", "path", "luasnip", "buffer", "ripgrep", "lazydev" },
          default = { "lsp", "path", "luasnip", "buffer", "copilot", "ripgrep" },
          providers = {
            lsp = {
              fallbacks = { "ripgrep", "buffer" },
              --- @param items blink.cmp.CompletionItem[]
              transform_items = function(_, items)
                -- demote snippets
                for _, item in ipairs(items) do
                  if item.kind == require("blink.cmp.types").CompletionItemKind.Snippet then
                    item.score_offset = item.score_offset - 3
                  end
                end
                -- filter non-acceptable rime items
                return vim.tbl_filter(function(item)
                  if not is_rime_item(item) then
                    return true
                  end
                  item.detail = nil
                  return rime_item_acceptable(item)
                end, items)
              end,
            },
            buffer = { max_items = 5 },
            luasnip = { name = "Snip" },
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              score_offset = 100,
            },
            copilot = {
              name = "copilot",
              module = "blink-cmp-copilot",
              score_offset = 100,
              async = true,
              transform_items = function(_, items)
                local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                local kind_idx = #CompletionItemKind + 1
                CompletionItemKind[kind_idx] = "Copilot"
                for _, item in ipairs(items) do
                  item.kind = kind_idx
                end
                return items
              end,
            },
            ripgrep = {
              module = "blink-ripgrep",
              name = "RG",
              max_items = 5,
              ---@module 'blink-ripgrep'
              ---@type blink-ripgrep.Options
              opts = {
                prefix_min_len = 4,
                context_size = 5,
                max_filesize = "1M",
                project_root_marker = vim.g.root_markers,
                search_casing = "--smart-case",
                -- (advanced) Any additional options you want to give to ripgrep.
                -- See `rg -h` for a list of all available options. Might be
                -- helpful in adjusting performance in specific situations.
                -- If you have an idea for a default, please open an issue!
                --
                -- Not everything will work (obviously).
                additional_rg_options = {},
                -- When a result is found for a file whose filetype does not have a
                -- treesitter parser installed, fall back to regex based highlighting
                -- that is bundled in Neovim.
                fallback_to_regex_highlighting = true,
              },
            },
            -- copilot = {
            --   name = "copilot", -- IMPORTANT: use the same name as you would for nvim-cmp
            --   module = "blink.compat.source",
            --   async = true,
            --   -- all blink.cmp source config options work as normal:
            --   score_offset = 100,
            --
            --   transform_items = function(_, items)
            --     local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
            --     local kind_idx = #CompletionItemKind + 1
            --     CompletionItemKind[kind_idx] = "Copilot"
            --     for _, item in ipairs(items) do
            --       item.kind = kind_idx
            --     end
            --     return items
            --   end,
            --   -- this table is passed directly to the proxied completion source
            --   -- as the `option` field in nvim-cmp's source config
            --   --
            --   -- this is NOT the same as the opts in a plugin's lazy.nvim spec
            -- },
          },
        },
      })
    end,
  },
}
