SLASH_QUESTCOMPLETE1 = '/qc';
debugInfo = "QuestComplete: ";

local function handler(msg, editBox)    
    --info = debugInfo..tostring(C_QuestLog.GetNumQuestLogEntries())
    local f = CreateFrame('Frame', 'Quest Complete', UIParent)
    f:SetFrameStrata("BACKGROUND")

    f:SetWidth(300) -- Set these to whatever height/width is needed 
    f:SetHeight(300) -- for your Texture
   

    f:SetPoint("CENTER",0,0)
    f:Show()
end

local function handlerNew(msg, editBox)
    local command, rest = msg:match("^(%S)%s(.-)$")
    -- Any leading non-whitespace is captured into command
    -- the rest (minus leading whitespace) is captured into rest.
    if command == "add" and rest ~= "" then
        -- Handle adding of the contents of rest... to something.
    elseif command == "remove" and rest ~= "" then
        -- Handle removing of the contents of rest... to something.
    else
        -- If not handled above, display some sort of help message
        print("Syntax: /yourcmd (add|remove) someIdentifier")
    end
end

SlashCmdList["QUESTCOMPLETE"] = handlerNew;