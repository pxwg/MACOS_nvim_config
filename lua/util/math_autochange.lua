local tex = require("util.latex")
local rime = require("util.rime_ls")
local lspconfig = require("lspconfig")

-- TODO: 现在这个函数仍然存在一些问题，尝试通过修改lspattach 来实现这个修正!
local function switch_rime_math()
  if vim.bo.filetype == "tex" then
    -- if vim.fn.mode() == "i" and vim.bo.filetype == "tex" then
    -- in the mathzone or table or tikz and rime is active, disable rime
    if (tex.in_mathzone() == true or tex.in_tikz() == true) and rime_ls_active == true then
      if _G.rime_toggled == true then
        require("lsp.rime_2").toggle_rime()
        rime.enable_lsps()
        _G.rime_toggled = false
      end
      -- in the text but rime is not active(by hand), do nothing
    elseif _G.rime_ls_active == false then
      rime.enable_lsps()
      -- in the text but rime is active(by hand ), thus the configuration is for mathzone or table or tikz
    else
      if _G.rime_toggled == false then
        require("lsp.rime_2").toggle_rime()
        rime.disable_lsps()
        _G.rime_toggled = true
      end
      if _G.rime_ls_active and _G.rime_toggled then
        rime.toggle_lsps_check()
      end
    end
  end
end

local function attach(client, bufnr)
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

function texlab_in_math(client, bufnr)
  if vim.bo.filetype == "tex" then
    -- if vim.fn.mode() == "i" and vim.bo.filetype == "tex" then
    -- in the mathzone or table or tikz and rime is active, disable rime
    if (tex.in_mathzone() == true or tex.in_tikz() == true) and rime_ls_active == true then
      if _G.rime_toggled == true then
        attach(client, bufnr)
      end
      -- in the text but rime is not active(by hand), do nothing
    elseif _G.rime_ls_active == false then
        attach(client, bufnr)
      -- in the text but rime is active(by hand ), thus the configuration is for mathzone or table or tikz
    else
      if _G.rime_toggled == false then
        deattach(client, bufnr)
      end
      if _G.rime_ls_active and _G.rime_toggled then
        rime.toggle_lsps_check()
      end
    end
  end
end

vim.api.nvim_create_autocmd("CursorMovedI", {
  pattern = "*.tex",
  callback = switch_rime_math,
})

vim.api.nvim_create_autocmd(
  { "InsertLeave", "InsertEnter" },
  { pattern = "*.tex", callback = require("util.rime_ls").check_lsps_check }
)

lspconfig.texlab.setup({
  on_attach = texlab_in_math,
})
