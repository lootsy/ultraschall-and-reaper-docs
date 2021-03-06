-- Meo Mespotine (mespotine.de) 15.5.2018 for the ultraschall.fm-project

-- the following code can be used to check, which strings within Reaper are
-- valid config-variables that can be used by the SWS-functions 
--      SNM_GetIntConfigVar(), SNM_SetIntConfigVar(), SNM_GetDoubleConfigVar() and SNM_SetDoubleConfigVar()
-- where you pass the variable-name as parameter "varname".
-- This script expects a string with all entries to check for, each separated by a newline, with no trailing or
-- preceding spaces, as otherwise the variable might be fail-checked.

-- To get a list to check, use Microsoft Process Explorer, start Reaper, rightlick on it and click on Properties.
-- The tab "Strings" contains all strings within Reaper. Click "Memory" and "Save" to save them into a textfile.
-- Open the text-file, copy all(!) entries into clipboard and run this commented code.
-- After execution, it will put all found strings, that are valid config-variables into the clipboard.
--
-- keep in mind: some config-variables are duplicate, often in different camel-cases, some may not be found 
-- by this code (rendercfg seems to be problematic candidate)
-- but at least, it's a start.

-- Oh, and if you want to parse your own reaper.ini(whose entries seem to be a valuable source for variable-names),
-- decomment the first line in the for statement!

-- the variable int_line contains all valid variables, each separated by a \n
-- the variable rest_line contains all strings, that weren't valid variables(where the check failed),
--     each separated by a \n

ultraschall={}
function ultraschall.GetStringFromClipboard_SWS()
  -- gets a big string from clipboard, using the 
  -- CF_GetClipboardBig-function from SWS
  -- and deals with all aspects necessary, that
  -- surround using it.
  local buf = reaper.CF_GetClipboard(buf)
  local WDL_FastString=reaper.SNM_CreateFastString("HudelDudel")
  local clipboardstring=reaper.CF_GetClipboardBig(WDL_FastString)
  reaper.SNM_DeleteFastString(WDL_FastString)
  return clipboardstring
end


A=ultraschall.GetStringFromClipboard_SWS()
  
A=A.."\n"
int_line="" -- found valid variables
rest_line="" -- strings, where the check failed
LL=0

for line in A:gmatch("(.-)%c") do
  --line=tostring(line:match("(.-)=")) --uncomment, if you want to parse a reaper.ini
  L=reaper.SNM_GetDoubleConfigVar(line, -1)
  L2=reaper.SNM_GetDoubleConfigVar(line, -2)
  if (L~=-1 or L2~=-2) then if line~="nil" then int_line=int_line..line.."\n" LL=LL+1 end else rest_line=rest_line..line.."\n" end
end


if int_line=="" then reaper.MB("nothing found","",0) 
else reaper.CF_SetClipboard(int_line) end

