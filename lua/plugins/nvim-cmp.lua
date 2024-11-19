return {
  "hrsh7th/nvim-cmp",
  version = false, -- last release is way too old
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
  },
  opts = function()
    -- Existing nvim-cmp configuration
    vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
    local compare = require("cmp.config.compare")
    local cmp = require("cmp")
    local defaults = require("cmp.config.default")()
    local auto_select = true

    --     -- Integrate rime_ls configuration
    --     local lspconfig = require("lspconfig")
    --     local configs = require("lspconfig.configs")
    --     local rime_ls_filetypes = { "markdown", "text", "org", "latex" } -- Define your filetypes here
    --
    --     if not configs.rime_ls then
    --       configs.rime_ls = {
    --         default_config = {
    --           name = "rime_ls",
    --           cmd = { vim.fn.expand("~/Desktop/rime-ls-0.4.0/target/release/rime_ls") },
    --           filetypes = rime_ls_filetypes,
    --           single_file_support = true,
    --         },
    --         settings = {},
    --         docs = {
    --           description = [[
    -- https://www.github.com/wlh320/rime-ls
    --
    -- A language server for librime
    -- ]],
    --         },
    --       }
    --     end
    --
    return {
      auto_brackets = {}, -- configure any filetype to auto add brackets
      completion = {
        completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
      },
      preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-k>"] = cmp.mapping({
          i = function()
            if cmp.visible() then
              cmp.abort()
            else
              cmp.complete()
            end
          end,
          c = function()
            if cmp.visible() then
              cmp.close()
            else
              cmp.complete()
            end
          end,
        }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = LazyVim.cmp.confirm({ select = auto_select }),
        ["<C-y>"] = LazyVim.cmp.confirm({ select = true }),
        ["<S-CR>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
        ["<C-CR>"] = function(fallback)
          cmp.abort()
          fallback()
        end,
        ["<Space>"] = cmp.mapping(function(fallback)
          local entry = cmp.get_selected_entry()
          if entry == nil then
            entry = cmp.core.view:get_first_entry()
          end
          if entry and entry.source.name == "nvim_lsp" and entry.source.source.client.name == "rime_ls" then
            cmp.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            })
          else
            fallback()
          end
        end, { "i" }),
      }),
      window = {
        completion = {
          border = "rounded",
          winhighlight = "Normal:BorderBG,FloatBorder:BorderBG,CursorLine:PmenuSel,Search:None",
        },
        documentation = {
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:BorderBG,CursorLine:PmenuSel,Search:None",
        },
      },
      sources = cmp.config.sources({
        { name = "rime_ls_2", priority = 100 },
        { name = "copilot" },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "buffer" },
        { name = "luasnip" },
      }),
      formatting = {
        format = function(entry, item)
          local icons = LazyVim.config.icons.kinds
          if icons[item.kind] then
            item.kind = icons[item.kind] .. item.kind
          end

          local widths = {
            abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
            menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
          }

          for key, width in pairs(widths) do
            if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
              item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
            end
          end

          return item
        end,
      },
      experimental = {
        ghost_text = {
          hl_group = "CmpGhostText",
        },
      },
      sorting = {
        comparators = {
          compare.sort_text,
          compare.offset,
          compare.exact,
          compare.score,
          compare.recently_used,
          compare.kind,
          compare.length,
          compare.order,
        },
      },
    }
  end,

  main = "lazyvim.util.cmp",
}
