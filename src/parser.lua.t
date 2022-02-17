##vcd-viewer
@functions+=
function M.parse(lines)
  local parsed = {}
  local ordered = {}
  @parse_header_section
  @parse_variable_definition_section
  @parse_data_section
  return parsed, ordered
end

@parse_header_section+=
local i = 1
while #lines[i] > 0 do
  i = i + 1
end
@skip_empty_lines

@skip_empty_lines+=
while #lines[i] == 0 do
  i = i + 1
end

@parse_variable_definition_section+=
while #lines[i] > 0 do
  local vary_type, size, id_code, ref = lines[i]:match("^%s*$var%s+(%a+)%s+(%d+)%s+(%S+)%s+(%S+)")
  if vary_type and size and id_code and ref then
    @save_variable
  end
  i = i + 1
end

@skip_empty_lines

@save_variable+=
parsed[id_code] = {
  vary_type = vary_type,
  size = tonumber(size),
  ref = ref,
  data = {},
}

@parse_data_section+=
local timeframe = {}
while i <= #lines do
  if lines[i]:match("#%d+") then
    @fill_timeframe
  else
    @parse_timestep_data
  end
  i = i + 1
end
@fill_timeframe

@parse_timestep_data+=
local val = lines[i]:sub(1,1)
local id_code = lines[i]:sub(2,2)
if parsed[id_code] then
  timeframe[id_code] = val
end

@fill_timeframe+=
for id_code, val in pairs(timeframe) do
  table.insert(parsed[id_code].data, val)
end

@save_variable-=
if not parsed[id_code] then
  table.insert(ordered, id_code)
end
