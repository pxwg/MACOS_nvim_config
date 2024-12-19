local ls = require("luasnip")
local sa = require("sniprun.api")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local line_begin = require("luasnip.extras.expand_conditions").line_begin
local tex = require("util.latex")

local get_visual = function(args, parent)
  if #parent.snippet.env.select_raw > 0 then
    return sn(nil, t(parent.snippet.env.select_raw))
  else -- if select_raw is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

local function execute_and_listen(sympy_script)
  local mma_output = ""

  -- local sympy_script = "Print[hello]"
  -- local sa = require("sniprun.api")
  local api_listener_window = function(ind)
    if ind.status == "ok" then
      mma_output = ind.message
    elseif ind.status == "error" then
      mma_output = ind.message
    else
      mma_output = ind.message
    end
    mma_output = mma_output:gsub('^"(.*)"$', "%1")
    return mma_output
  end

  sa.register_listener(api_listener_window) -- register the listener

  sa.run_string(sympy_script, "mathematica")

  while true do
    if mma_output ~= sympy_script then
      return mma_output
    end
  end
end

return {
  s(
    { trig = "mcal", wordtrig = false, snippettype = "autosnippet", priority = 2000 },
    fmta("mcal <> mcal", {
      i(0),
    }),
    { condition = tex.in_mathzone }
  ),

  s(
    { trig = "mcal", wordtrig = false, snippettype = "autosnippet", priority = 3000 },
    fmta("mcal <> mcal", {
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),

  s(
    { trig = "mcal", wordtrig = false, snippettype = "autosnippet", priority = 3000 },
    c(1, {
      sn(
        nil,
        fmta("mcal <> mcal", {
          d(1, get_visual),
        })
      ),
      sn(
        nil,
        fmta("pcal <> pcal", {
          d(1, get_visual),
        })
      ),
    }),
    { condition = tex.in_mathzone }
  ),
  s( -- this one evaluates anything inside the simpy block
    {
      trig = "mcal.*mcals",
      regTrig = true,
      desc = "sympy block evaluator",
      snippetType = "autosnippet",
      priority = 10000,
    },
    d(1, function(_, parent)
      -- gets the part of the block we actually want, and replaces spaces
      -- at the beginning and at the end
      local to_eval = string.gsub(parent.trigger, "^mcal(.*)mcals", "%1")
      to_eval = string.gsub(to_eval, "^%s+(.*)%s+$", "%1")

      -- replace single backslashes with double backslashes
      to_eval = string.gsub(to_eval, "\\mathrm{d}", "d")
      to_eval = string.gsub(to_eval, "\\mathrm{i}", "i")
      to_eval = string.gsub(to_eval, "\\", "\\\\")

      local job = require("plenary.job")

      local sympy_script = string.format(
        [[
        a = fullsimplify[toexpression["%s",texform] ];
        b = texform[a];
        return["%s =" b]
        ]],
        -- origin = re.sub(r'^\s+|\s+$', '', origin)
        -- parsed = parse_expr(origin)
        -- output = origin + parsed
        -- print_latex(parsed)
        to_eval,
        to_eval
      )

      sympy_script = string.gsub(sympy_script, "^[\t%s]+", "")
      local result = {}

      job
        :new({
          command = "wolframscript",
          args = {
            "-c",
            sympy_script,
          },
          on_exit = function(j)
            result = j:result()
          end,
          -- timeout = 210000000,
        })
        :sync()

      return sn(nil, t(result))
    end)
  ),
  s( -- this one evaluates anything inside the simpy block
    {
      trig = "mcalt.*mcalts",
      regTrig = true,
      desc = "sympy block evaluator",
      snippetType = "autosnippet",
      priority = 2000,
    },
    d(1, function(_, parent)
      -- gets the part of the block we actually want, and replaces spaces
      -- at the beginning and at the end
      local to_eval = string.gsub(parent.trigger, "^mcalt(.*)mcalts", "%1")
      -- local new = to_eval
      to_eval = string.gsub(to_eval, "^%s+(.*)%s+$", "%1")

      -- replace single backslashes with double backslashes
      to_eval = string.gsub(to_eval, "\\mathrm{d}", "d")
      to_eval = string.gsub(to_eval, "\\mathrm{i}", "i")
      to_eval = string.gsub(to_eval, "\\", "\\\\")

      -- local job = require("plenary.job")

      local sympy_script = string.format(

        'a = FullSimplify[ToExpression["%s", TeXForm]]; b = TeXForm[a]; Print[" %s =" b]',

        -- origin = re.sub(r'^\s+|\s+$', '', origin)
        -- parsed = parse_expr(origin)
        -- output = origin + parsed
        -- print_latex(parsed)
        to_eval,
        to_eval
      )
      -- sympy_script = string.gsub(sympy_script, "^[\t%s]+", "")
      -- local old = sympy_script

      -- local result = ""
      -- vim.wait(5000)
      -- result = _G.result
      -- local function remove_quotes_if_needed(str)
      --   if str:match('^".*"$') then
      --     return str:gsub('^"(.*)"$', "%1")
      --   else
      --     return old
      --   end
      -- end

      -- local result = execute_and_listen(sympy_script)
      local timeout = 5 -- 设置超时时间为5秒
      local start_time = os.time()
      local init = _G.result
      local result = init

      sa.run_string(sympy_script, "mathematica")

      while true do
        if result == init then
          result = _G.result
        elseif result ~= init then
          _G.result = ""
          result = result:gsub('^"(.*)"$', "%1")
          return sn(nil, { t(result) })
        end
        if os.time() - start_time > timeout then
          return sn(nil, { t("Error: Operation timed out") })
        end
        vim.wait(100) -- 添加适当的延迟，避免高 CPU 占用
      end
      -- if type(result) == "string" then
      -- end
      -- return sn(nil, { t(out) })
    end)
  ),
}
