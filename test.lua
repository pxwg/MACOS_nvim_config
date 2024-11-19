local latex_util = require("util.latex")

-- 测试 in_env 函数
local function test_in_env()
  local env = "itemize"
  local result = latex_util.in_env(env)
  print("in_env('" .. env .. "'):", result)
end

-- 测试 in_mathzone 函数
local function test_in_mathzone()
  local result = latex_util.in_mathzone()
  print("in_mathzone():", result)
end

-- 测试 in_text 函数
local function test_in_text()
  local result = latex_util.in_text()
  print("in_text():", result)
end

-- 测试 in_item 函数
local function test_in_item()
  local result = latex_util.in_item()
  print("in_item():", result)
end

-- 测试 clean 函数
local function test_clean()
  latex_util.clean()
  print("clean() executed")
end

-- 测试 sympy_calc 函数
local function test_sympy_calc()
  -- 先设置一个选中的文本
  vim.fn.setreg("v", "2 + 2")
  latex_util.sympy_calc()
end

local function test_in_table()
  local result = latex_util.in_table()
  print("in_table():", result)
end

-- 执行测试
test_in_env()
test_in_mathzone()
test_in_text()
test_in_item()
test_in_table()
test_clean()
test_sympy_calc()
