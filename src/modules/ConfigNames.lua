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
-- Names containing letters come before numeric-only names in Alphabetical.
function M.SortKey(name)
 local parts={};local letters=false
 for _,cp in utf8.codes(name)do
  if cp>=65 and cp<=90 then cp+=32 end
  if cp>=1040 and cp<=1071 then cp+=32 elseif cp==1025 then cp=1105 end
  if(cp>=97 and cp<=122)or(cp>=192 and cp<=687)or(cp>=880 and cp<=1327)or(cp>=12352 and cp<=40959)then letters=true end
  parts[#parts+1]=utf8.char(cp)
 end
 local key=table.concat(parts)
 return letters and 0 or(name:match('^%d+$')and 1 or 2),key
end
function M.NameLess(a,b,reversed)
 local ac,ak=M.SortKey(a);local bc,bk=M.SortKey(b)
 if ac~=bc then return ac<bc end -- Letters remain first in either direction.
 if ac==1 then local an,bn=tonumber(a),tonumber(b);if an and bn and an~=bn then if reversed then return an>bn else return an<bn end end end
 if ak==bk then ak,bk=a,b end
 if reversed then return ak>bk else return ak<bk end
end
return M
