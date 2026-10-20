local M={}
function M.Validate(value)
 if type(value)~='string'then return nil,'Enter a preset name'end
 if value:find('%c')then return nil,'Control characters are not allowed'end
 local name=value:match('^%s*(.-)%s*$')
 if #name==0 or #name>64 or name=='.'or name=='..'or name:find('[\\/:*?"<>|%c]')then return nil,'Use 1–64 characters without path separators'end
 return name
end
function M.ValidateData(data)
 if type(data)~='table'or type(data.__elements)~='table'then return false,'Invalid preset: missing __elements'end
 for flag,record in pairs(data.__elements)do
  if type(flag)~='string'or type(record)~='table'or type(record.__type)~='string'then return false,'Invalid element record'end
  local t,v=record.__type,record.value
  if t=='Toggle'and type(v)~='boolean'then return false,'Invalid toggle'end
  if t=='Slider'and(type(v)~='number'or v~=v or math.abs(v)==math.huge)then return false,'Invalid slider'end
  if t=='Input'and type(v)~='string'then return false,'Invalid input'end
  if t=='Dropdown'and v~=nil and type(v)~='string'and type(v)~='table'then return false,'Invalid choice'end
 end
 return true
end
return M
