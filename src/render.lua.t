##vcd-viewer
@open_scratch_buffer+=
local buf = vim.api.nvim_create_buf(false, true)


@foreach_waveform_draw_it+=
local lines = {}
for _, id_code in ipairs(ordered) do
  local entry = parsed[id_code]
  local prev
  @draw_waveform_using_box_drawing_characters
  @append_to_lines_with_name
  @save_name_for_highlight
end

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
-- @draw_single_timeframe_end

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

@append_to_lines_with_name+=
local len = vim.api.nvim_strwidth(entry.ref)
@create_whitespace_replacement
table.insert(lines, white .. " " .. table.concat(upper, ""))
table.insert(lines, entry.ref .. " " .. table.concat(lower, ""))

@create_whitespace_replacement+=
local white = ""
for i=1,len do
  white = white .. " "
end

@foreach_waveform_draw_it-=
local name_pos = {}

@save_name_for_highlight+=
table.insert(name_pos, {
  #lines+margin, margin*2, #entry.ref+margin*2
})

@create_highlight_namespace+=
local ns_id = vim.api.nvim_create_namespace("")
for _, pos in ipairs(name_pos) do
  local row, scol, ecol = unpack(pos)
  vim.api.nvim_buf_add_highlight(buf, ns_id, "String", row-1, scol,  ecol)
end

@variables+=
local margin = 1

@create_float_window+=
local editor_width = vim.o.columns
local editor_height = vim.o.lines

@compute_max_width

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
