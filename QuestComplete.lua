SLASH_QUESTCOMPLETE1 = '/qc';
local debugInfo = "QuestComplete: ";
local Config = {}
local QC = {}
Config.created = false
Config.Showed = false

local function handlerNew(msg,editBox)
    local command, rest = msg:match("^(%S)%s(.-)$")
    -- Any leading non-whitespace is captured into command
    -- the rest (minus leading whitespace) is captured into rest.
    if command == "d" and rest ~= "" then
        -- Handle adding of the contents of rest... to something.
		--Config:Toggle()
    elseif command == "remove" and rest ~= "" then
        -- Handle removing of the contents of rest... to something.
	elseif Config.created == true and Config.Showed == true then
		QC:Hide();
		print("QC Off")
		Config.Showed = false
	elseif Config.created == true and Config.Showed == false then
		QC:Show()
		QC.questsCompleted = {}
		QC.questsCompleted = GetQuestsCompleted(QC.questsCompleted)
		Config.Showed = true
    elseif Config.created == false then
        -- If not handled above, display some sort of help message
        print("QC Created")
		
	QC = CreateFrame('Frame', 'Quest Complete', UIParent,"UIPanelDialogTemplate")
	Config.created = true
	Config.Showed = true
	QC:SetFrameStrata("BACKGROUND")
	QC:SetSize(150, 70)
	QC:SetPoint("CENTER",0,0)
	QC:SetMovable(true);
	QC:EnableMouse(true);
	QC:SetResizable(false)
	QC:RegisterForDrag("LeftButton");
	QC:SetScript("OnDragStart", QC.StartMoving);
	QC:SetScript("OnDragStop", QC.StopMovingOrSizing);
	QC:SetClampedToScreen(true)
	QC:SetScale(1)
	QC.x = QC:GetLeft() 
	QC.y = (QC:GetTop() - QC:GetHeight()) 
	QC:SetMinResize(150, 70)
	QC:SetScript("OnUpdate", function(self) 
		if self.isMoving == true then
			self.x = self:GetLeft() 
			self.y = (self:GetTop() - self:GetHeight()) 
			self:ClearAllPoints()
			self:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", self.x, self.y)
		end
	end)

	--[[
		PARENT FRAME: resButton
			The resize button which the user can click to resize the window

		 -> Anchors to AssisTODOUI
	]]
	QC.ResizeButton = CreateFrame("Button", "resButton", QC)
	QC.ResizeButton:SetSize(16, 16)
	QC.ResizeButton:SetPoint("BOTTOMRIGHT", -5, 7)
	QC.ResizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	QC.ResizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	QC.ResizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

	QC.ResizeButton:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" then
			self.isSizing = true
			self:GetParent():StartSizing("BOTTOMRIGHT")
			self:GetParent():SetUserPlaced(true)
		elseif button == "RightButton" then
			self.isScaling = true
		end
	end)

	QC.ResizeButton:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" then
			self.isSizing = false
			self:GetParent():StopMovingOrSizing()
		elseif button == "RightButton" then
			self.isScaling = false
		end
	end)
	QC.ResizeButton:SetScript("OnUpdate", function(self, button)
		if self.isScaling == true then
			local cx, cy = GetCursorPosition()
			cx = cx / self:GetEffectiveScale() - self:GetParent():GetLeft() 
			cy = self:GetParent():GetHeight() - (cy / self:GetEffectiveScale() - self:GetParent():GetBottom() )

			local tNewScale = cx / self:GetParent():GetWidth()
			local tx, ty = self:GetParent().x / tNewScale, self:GetParent().y / tNewScale

			self:GetParent():ClearAllPoints()
			self:GetParent():SetScale(self:GetParent():GetScale() * tNewScale)
			self:GetParent():SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", tx, ty)
			self:GetParent().x, self:GetParent().y = tx, ty
		end

		child:SetSize(QC:GetWidth()-42, 500)
	end)

	--[[
		PARENT FRAME: Title
			Sets the template title
	]]
	--QC.Title:ClearAllPoints()
	QC.Title:SetFontObject("GameFontHighlight")
	QC.Title:SetPoint("TOPLEFT", QC, "TOPLEFT", 0, -10)
	QC.Title:SetText("Quest status")

	--[[
		CHILD FRAME: Textbox
	--]]
	QC.textField = CreateFrame("EditBox", nil, QC, "InputBoxTemplate")
	QC.textField:SetPoint("TOPLEFT", QC, "TOPLEFT", 20, -35)
	QC.textField:SetSize(60, 20)
	QC.textField:SetAutoFocus(false)

	QC.textField:SetScript("OnEnter", function(self)
		local text = QC.textField:GetText()
		if text ~= "" then
			QC.CheckQuest()
		end
	end)

	QC.textField:SetScript("OnEnterPressed", function()
		local text = QC.textField:GetText()
		if text ~= "" then
			QC.CheckQuest()
		end
	end)

	QC.textField:SetScript("OnLeave", function() 
		local text = QC.textField:GetText()
		if text ~= "" then
			QC.textField:ClearFocus()
		end
	end)

	QC.textField:SetScript("OnEscapePressed", function()
		QC.textField:ClearFocus()
	end)

	--[[
		CHILD FRAME: check button
	--]]

	function QC.CheckQuest(button)
		if button == "LeftButton" or not button then
			local text = QC.textField:GetText()
			QC.completed = "Not Completed"
			local r,g,b = 1,0,0
			if text ~= "" then
				if QC.questsCompleted and QC.questsCompleted[tonumber(text)] then
					QC.completed = "Completed"
					r,g,b = 0,1,0
				end
			end
			QC.Title:SetText(tostring(QC.completed))
			QC.Title:SetTextColor(r,g,b,1)
			QC.textField:ClearFocus()
		end
	end

	QC.okButton = CreateFrame("Button", nil, QC, "GameMenuButtonTemplate");
	QC.okButton:SetPoint("TOPLEFT", QC.textField, "TOPLEFT", 70,0);
	QC.okButton:SetSize(50, 20);
	QC.okButton:SetText("Check");
	QC.okButton:SetNormalFontObject("GameFontNormal");
	QC.okButton:SetHighlightFontObject("GameFontHighlight");
	QC.okButton:SetScript("OnMouseDown",QC.CheckQuest)
	--[[
	QC:SetScript("QUEST_QUERY_COMPLETE", function()
		print("QC query completed")
		--QC.questsCompleted = {GetQuestsCompleted()}
	end)
	print("QC loading query completed")
	--QueryQuestsCompleted()
	]]

	local GetQuestsCompleted = GetQuestsCompleted
	if not GetQuestsCompleted then
		function GetQuestsCompleted(tbl)
			local tbl = tbl or {};
			for lixo,questID in ipairs(C_QuestLog.GetAllCompletedQuestIDs()) do
				local name = C_QuestLog.GetTitleForQuestID(id)
				tbl[questID] = true
			end
			return tbl;
		end
	end
	QC.questsCompleted = {}
	QC.questsCompleted = GetQuestsCompleted(QC.questsCompleted)
	QC:Show()
    end
end
SlashCmdList.QUESTCOMPLETE = handlerNew;
