local M=require('../src/modules/ConfigNames')
local n=0
local function check(v,msg)n+=1;assert(v,msg)end
for _,v in ipairs({'Default','Night profile','Sirius_2','Тест'})do check(M.Validate(v)==v,'valid name')end
check(M.Validate('  Trim  ')=='Trim','trim')
for _,v in ipairs({'',' ','..','.','../escape','a\\b','a:b','a\n','a?b',string.rep('a',65)})do check(not M.Validate(v),'invalid name '..v)end
check(M.ValidateData({__elements={a={__type='Toggle',value=true},b={__type='Slider',value=12}}}),'valid data')
for _,v in ipairs({{}, {__elements=5},{__elements={a=false}},{__elements={a={__type='Toggle',value='true'}}},{__elements={a={__type='Slider',value=0/0}}},{__elements={a={__type='Input',value=7}}}})do check(not M.ValidateData(v),'invalid data')end
print('ConfigNames: '..n..' checks passed')
