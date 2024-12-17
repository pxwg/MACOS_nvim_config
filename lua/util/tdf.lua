local M = {}

-- HACK: 用于对终端pdf 查看器 tdf 的双向查找

function M.get_largest_pdf_in_current_dir()
  local current_dir = vim.fn.expand("%:p:h")
  local pdf_files = vim.fn.globpath(current_dir, "*.pdf", false, true)
  if #pdf_files == 0 then
    return nil
  end

  local largest_pdf = pdf_files[1]
  local largest_size = vim.fn.getfsize(largest_pdf)

  for _, pdf in ipairs(pdf_files) do
    local size = vim.fn.getfsize(pdf)
    if size > largest_size then
      largest_pdf = pdf
      largest_size = size
    end
  end

  return largest_pdf
end

local function getPages()
  local handle = io.popen('hs -c "print(getPages())"')
  if not handle then
    print("Failed to open handle")
    return nil
  end

  local result = handle:read("*a")
  handle:close()

  if not result then
    print("Failed to read result")
    return nil
  end

  -- print(result)
  return result
end

_G.getPages = getPages

-- TODO: need to consider the inverse searching which could trigger to the source file (via synctex 'input')

function M.convert_tex_to_pdf()
  local tex_filename = vim.fn.expand("%:t")
  local tex_filepath = vim.fn.expand("%:p")
  local pdf_filename = tex_filename:gsub("%.tex$", ".pdf")
  -- local pdf_filepath = [["]] .. vim.fn.expand("%:p:h") .. "/" .. pdf_filename .. [["]]
  local pdf_filepath = [["]] .. M.get_largest_pdf_in_current_dir() .. [["]]
  local pdf_pos = M.get_largest_pdf_in_current_dir()
  pdf_pos = tostring(pdf_pos)

  local line_number = vim.fn.line(".")
  local column_number = vim.fn.col(".")
  local synctex_command =
    string.format("synctex view -i %d:%d:%s -o %s", line_number, column_number, tex_filepath, pdf_filepath)

  local result = vim.fn.system(synctex_command)

  if vim.fn.filereadable(pdf_pos) == 0 then
    vim.notify("Error: PDF file not found at " .. pdf_filepath, vim.log.levels.WARN)
    return
  end

  local page = result:match("Page:(%d+)")
  local x = result:match("x:([%d%.]+)")
  local y = result:match("y:([%d%.]+)")

  local hs_command = string.format("hs -c 'openPDF(%s,%s,%s,%s)'", pdf_filepath, x, y, page)
  vim.fn.system(hs_command)
  vim.fn.system("hs -c 'enterLaTeXMode()'")
end

function M.synctex_forward()
  local tex_filename = vim.fn.expand("%:t")
  local tex_filepath = vim.fn.expand("%:p")
  local pdf_filename = tex_filename:gsub("%.tex$", ".pdf")
  -- local pdf_filepath = vim.fn.expand("%:p:h") .. "/" .. pdf_filename
  local pdf_filepath = M.get_largest_pdf_in_current_dir()

  local line_number = vim.fn.line(".")
  local column_number = vim.fn.col(".")
  local synctex_command =
    string.format("synctex view -i %d:%d:%s -o %s", line_number, column_number, tex_filepath, pdf_filepath)

  -- 执行命令并获取输出
  local result = vim.fn.system(synctex_command)

  -- 打印 synctex_command 和 result 以进行调试
  -- print("synctex_command:", synctex_command)
  -- print("result:", result)

  local page = result:match("Page:(%d+)")
  local x = result:match("x:([%d%.]+)")
  local y = result:match("y:([%d%.]+)")

  -- print("Page:" .. page)
  -- print("x:" .. x)
  -- print("y:" .. y)

  if page and x and y then
    local hs_command = string.format("hs -c 'drawRedDotOnA4(%s,%s,%s)'", x, y, page)
    local hs_result = vim.fn.system(hs_command)
    --   print("hs_command:", hs_command)
    --   print("hs_result:", hs_result)
    -- else
    --   print("Failed to extract Page, x, or y values.")
  end
end

-- TODO: need to consider the inverse searching which could trigger to the source file (via synctex 'input')
-- function M.synctex_inverse()
--   local page_number = getPages()
--   page_number = tonumber(page_number)
--
--   -- Read x and y from /tmp/nvim_hammerspoon_latex.txt
--   local file = io.open("/tmp/nvim_hammerspoon_latex.txt", "r")
--   local x, y
--   if file then
--     x = file:read("*line")
--     y = file:read("*line")
--     file:close()
--   else
--     print("Failed to open /tmp/nvim_hammerspoon_latex.txt")
--     return
--   end
--
--   -- Check if x and y are not nil
--   if not x or not y then
--     print("x or y is nil")
--     return
--   end
--
--   -- Get the current file path and pdf file path
--   local pdf_filename = vim.fn.expand("%:t"):gsub("%.tex$", ".pdf")
--   local pdf_filepath = vim.fn.expand("%:p:h") .. "/" .. pdf_filename
--   -- Construct the synctex edit command
--   local synctex_command = string.format("synctex edit -o %s:%s:%s:%s", page_number, x, y, pdf_filepath)
--
--   -- Execute the command and get the result
--   local handle = io.popen(synctex_command)
--   local result = nil
--   if handle then
--     result = handle:read("*a")
--     handle:close()
--   end
--   local line = result:match("Line:(%d+)")
--   local column = result:match("Column:(%-?%d+)")
--   local input_line = result:match("(Input:.-)\n")
--
--   if input_line then
--     -- 提取文件路径
--     local input = input_line:match("Input:(.*)")
--     -- 检查文件后缀是否为 .tex
--     if input:match("%.tex$") then
--       _G.input = input
--     else
--       _G.input = nil
--       print("input = nil")
--     end
--   else
--     print("Failed to extract Input line from result")
--   end
--
--   -- Convert the result to a number and jump to the line
--   local line_number = tonumber(line)
--   local column_number = tonumber(column)
--   -- print("column_number:", column_number)
--   if line_number and column_number then
--     if _G.input == nil then
--       vim.fn.cursor(line_number, 1)
--     else
--       vim.api.nvim_command("edit" .. _G.input)
--       vim.fn.cursor(line_number, 1)
--     end
--   else
--     print("Failed to get line number from synctex edit command")
--   end
-- end

function M.synctex_inverse(pdf_file)
  local page_number = tonumber(getPages())

  -- Read x and y from /tmp/nvim_hammerspoon_latex.txt
  local file = io.open("/tmp/nvim_hammerspoon_latex.txt", "r")
  if not file then
    print("Failed to open /tmp/nvim_hammerspoon_latex.txt")
    return
  end

  local x, y = file:read("*line"), file:read("*line")
  file:close()

  if not x or not y then
    print("x or y is nil")
    return
  end

  -- Get the current file path and pdf file path
  local pdf_filepath = M.get_largest_pdf_in_current_dir()
  -- print("pdf_filename:", pdf_filepath)

  -- Construct the synctex edit command
  local synctex_command = string.format("synctex edit -o %s:%s:%s:%s", page_number, x, y, pdf_filepath)

  -- Execute the command and get the result
  local handle = io.popen(synctex_command)
  if not handle then
    print("Failed to execute synctex command")
    return
  end

  local result = handle:read("*a")
  handle:close()

  local line = result:match("Line:(%d+)")
  local column = result:match("Column:(%-?%d+)")
  local input_line = result:match("(Input:.-)\n")

  if not input_line then
    print("Failed to extract Input line from result")
    return
  end

  -- 提取文件路径
  local input = input_line:match("Input:(.*)")
  -- 检查文件后缀是否为 .tex
  if not input:match("%.tex$") then
    print("input = nil")
    return
  end

  -- Convert the result to a number and jump to the line
  local line_number = tonumber(line)
  local column_number = tonumber(column)

  if not line_number or not column_number then
    print("Failed to get line number from synctex edit command")
    return
  end

  -- Open the input file and jump to the specific line and column
  vim.api.nvim_command("edit " .. input)
  vim.fn.cursor(line_number, column_number > 0 and column_number or 1)
end

return M
