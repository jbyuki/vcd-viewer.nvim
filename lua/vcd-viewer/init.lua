-- Generated using ntangle.nvim
local margin = 1

local M = {}
function M.parse(lines)
  local parsed = {}
  local ordered = {}
  local i = 1
  while #lines[i] > 0 do
    i = i + 1
  end
  while #lines[i] == 0 do
    i = i + 1
  end


  while #lines[i] > 0 do
    local vary_type, size, id_code, ref = lines[i]:match("^%s*$var%s+(%a+)%s+(%d+)%s+(%S+)%s+(%S+)")
    if vary_type and size and id_code and ref then
      if not parsed[id_code] then
        table.insert(ordered, id_code)
      end
      parsed[id_code] = {
        vary_type = vary_type,
        size = tonumber(size),
        ref = ref,
        data = {},
      }

    end
    i = i + 1
  end

  while #lines[i] == 0 do
    i = i + 1
  end


  local timeframe = {}
  while i <= #lines do
    if lines[i]:match("#%d+") then
      for id_code, val in pairs(timeframe) do
        table.insert(parsed[id_code].data, val)
      end

    else
      local val = lines[i]:sub(1,1)
      local id_code = lines[i]:sub(2,2)
      if parsed[id_code] then
        timeframe[id_code] = val
      end

    end
    i = i + 1
  end
  for id_code, val in pairs(timeframe) do
    table.insert(parsed[id_code].data, val)
  end


  return parsed, ordered
end

function M.view()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  local parsed, ordered = M.parse(lines)

  local buf = vim.api.nvim_create_buf(false, true)


  local name_pos = {}

  local lines = {}
  for _, id_code in ipairs(ordered) do
    local entry = parsed[id_code]
    local prev
    local upper = {}
    local lower = {}
    if entry.data[1] == "1" then
      table.insert(upper, "─")
      table.insert(lower, " ")
      table.insert(upper, "─")
      table.insert(lower, " ")
    elseif entry.data[1] == "0" then
      table.insert(upper, " ")
      table.insert(lower, "─")
      table.insert(upper, " ")
      table.insert(lower, "─")
    end

    for i=2,#entry.data do
      local val = entry.data[i]
      if entry.data[i-1] == "0" and entry.data[i] == "1" then
        table.insert(upper, "┌")
        table.insert(lower, "┘")
        table.insert(upper, "─")
        table.insert(lower, " ")
      elseif entry.data[i-1] == "0" and entry.data[i] == "0" then
        table.insert(upper, " ")
        table.insert(lower, "─")
        table.insert(upper, " ")
        table.insert(lower, "─")
      elseif entry.data[i-1] == "1" and entry.data[i] == "0" then
        table.insert(upper, "┐")
        table.insert(lower, "└")
        table.insert(upper, " ")
        table.insert(lower, "─")
      elseif entry.data[i-1] == "1" and entry.data[i] == "1" then
        table.insert(upper, "─")
        table.insert(lower, " ")
        table.insert(upper, "─")
        table.insert(lower, " ")
      end

    end
    -- @draw_single_timeframe_end

    local len = vim.api.nvim_strwidth(entry.ref)
    local white = ""
    for i=1,len do
      white = white .. " "
    end

    table.insert(lines, white .. " " .. table.concat(upper, ""))
    table.insert(lines, entry.ref .. " " .. table.concat(lower, ""))

    table.insert(name_pos, {
      #lines+margin, margin*2, #entry.ref+margin*2
    })

  end

  for i=1,margin do
    table.insert(lines, 1, "")
  end

  local prefix = ""
  for i=1,2*margin do
    prefix = prefix .. " "
  end

  for i=1,#lines do
    lines[i] = prefix .. lines[i]
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)

  local ns_id = vim.api.nvim_create_namespace("")
  for _, pos in ipairs(name_pos) do
    local row, scol, ecol = unpack(pos)
    vim.api.nvim_buf_add_highlight(buf, ns_id, "String", row-1, scol,  ecol)
  end

  local editor_width = vim.o.columns
  local editor_height = vim.o.lines

  local max_width = 0
  for i=1,#lines do
    max_width = math.max(vim.api.nvim_strwidth(lines[i]), max_width)
  end


  local w = math.min(math.floor(editor_width*0.8), max_width + margin*2)
  local h = math.min(math.floor(editor_height*0.8), #lines + margin)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = w,
    height = h,
    col = math.floor((editor_width - w)/2),
    row = math.floor((editor_height - h)/2),
    border = "single",
    style = "minimal",
  })

end

return M
