##vcd-viewer
@open_scratch_buffer+=
local buf = vim.api.nvim_create_buf(false, true)


@foreach_waveform_draw_it+=
local lines = {}
for _, id_code in ipairs(ordered) do
  local entry = parsed[id_code]
  local prev
  @draw_waveform_using_box_drawing_characters
  @save_name_for_highlight
end

@append_names_to_lines
@add_margin_to_lines

vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)

@draw_waveform_using_box_drawing_characters+=
local upper = {}
local lower = {}
@draw_single_timeframe_start
for i=2,#entry.data do
  local val = entry.data[i]
  @draw_single_timeframe
end
@draw_single_timeframe_end
table.insert(lines, table.concat(upper, ""))
table.insert(lines, table.concat(lower, ""))

@draw_single_timeframe_start+=
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

@draw_single_timeframe_end+=
if entry.data[#entry.data] == "1" then
  table.insert(upper, "─")
  table.insert(lower, " ")
elseif entry.data[#entry.data] == "0" then
  table.insert(upper, " ")
  table.insert(lower, "─")
end

@draw_single_timeframe+=
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

@declare_functions+=
local create_whitespace

@functions+=
function rep(n, c)
  local text = ""
  for i=1,n do
    text = text .. (c or " ")
  end
  return text
end

@append_names_to_lines+=
@compute_max_width_names
for i, id_code in ipairs(ordered) do
  local entry = parsed[id_code]
  local upper_blank = rep(max_width_name+2)
  local lower_blank = rep(max_width_name - vim.api.nvim_strwidth(entry.ref) + 2)
  lines[2*(i-1)+1] = upper_blank .. lines[2*(i-1)+1]
  lines[2*(i-1)+2] = entry.ref .. lower_blank .. lines[2*(i-1)+2]
end

@compute_max_width_names+=
local max_width_name = 0
for i, id_code in ipairs(ordered) do
  local entry = parsed[id_code]
  max_width_name = math.max(vim.api.nvim_strwidth(entry.ref), max_width_name)
end

@foreach_waveform_draw_it-=
local name_pos = {}

@save_name_for_highlight+=
table.insert(name_pos, {
  #lines+margin, margin, #entry.ref+margin
})

@create_highlight_namespace+=
local ns_id = vim.api.nvim_create_namespace("")


@set_highlight_for_names+=
for _, pos in ipairs(name_pos) do
  local row, scol, ecol = unpack(pos)
  vim.api.nvim_buf_add_highlight(buf, ns_id, "String", row-1, scol,  ecol)
end

@variables+=
local margin = 1

@create_float_window+=
local editor_width = vim.o.columns
local editor_height = vim.o.lines

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

@compute_max_width+=
local max_width = 0
for i=1,#lines do
  max_width = math.max(vim.api.nvim_strwidth(lines[i]), max_width)
end

@add_margin_to_lines+=
local white = ""

@compute_max_width

for i=1,max_width do
  white = white .. " "
end

for i=1,margin do
  table.insert(lines, 1, white)
end

local prefix = ""
for i=1,margin do
  prefix = prefix .. " "
end

for i=1,#lines do
  lines[i] = prefix .. lines[i]
end

@set_highlight_for_timesteps+=
local hl_group = "Whitespace"
local hl_group_high = "Error"
local hl_group_low = "Question"
for i=margin+1,#lines do
  local len_line = vim.str_utfindex(lines[i])
  local j = max_width_name + 2 + 1
  while j < len_line do
    @compute_col_for_cell
    local c = lines[i]:sub(scol+1,ecol)
    if c ~= " " then
      if (j-max_width_name)%2 == 1 then
        vim.api.nvim_buf_add_highlight(buf, ns_id, hl_group, i-1, scol, ecol)
      else
        @highlight_waveform_based_on_value
      end
    end
    j = j + 1
  end
end

@compute_col_for_cell+=
local scol = vim.str_byteindex(lines[i], j)
local ecol = vim.str_byteindex(lines[i], j+1)

@highlight_waveform_based_on_value+=
if (i-margin)%2 == 0 then
  vim.api.nvim_buf_add_highlight(buf, ns_id, hl_group_low, i-1, scol, ecol)
else
  vim.api.nvim_buf_add_highlight(buf, ns_id, hl_group_high, i-1, scol, ecol)
end
