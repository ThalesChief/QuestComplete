SLASH_QUESTCOMPLETE1 = '/qc';
local debugInfo = "QuestComplete: ";
local Config = {}
local QC = {}
function Config:Toggle(msg, editBox)
	local menu = QC or Config:handlerNew(msg, editBox)
	menu:setShow(not menu:isShown())
end
function Config:handlerNew(msg, editBox)
    local command, rest = msg:match("^(%S)%s(.-)$")
    -- Any leading non-whitespace is captured into command
    -- the rest (minus leading whitespace) is captured into rest.
	print("command, rest",command, rest)
    if command == "d" and rest ~= "" then
        -- Handle adding of the contents of rest... to something.
		--Config:Toggle()
    elseif command == "remove" and rest ~= "" then
        -- Handle removing of the contents of rest... to something.
    else
        -- If not handled above, display some sort of help message
        print(msg)
		local QC = CreateFrame('Frame', 'Quest Complete', UIParent,"UIPanelDialogTemplate")
		QC:SetFrameStrata("BACKGROUND")
		QC:SetSize(150, 70)
		QC:SetPoint("CENTER",0,0)
		QC:SetMovable(true);
		QC:EnableMouse(true);
		QC:SetResizable(true)
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

		--QC.bg1 = QC:CreateTexture (nil, "background")
        --QC.bg1:SetTexture ("Interface\AddOns\QuestComplete\UI\interface.blp", true)
        --QC.bg1:SetAlpha (0.8)
        --QC.bg1:SetSize (128, 32)
        --QC.bg1:SetAllPoints(f)
		
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
		QC.Title:ClearAllPoints()
		QC.Title:SetFontObject("GameFontHighlight")
		QC.Title:SetPoint("LEFT", AssisTODOUITitleBG, "LEFT", 6, 0)
		QC.Title:SetText("Status:")
		
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
				core.Chat:Print("/run print(IsQuestFlaggedCompleted("..text.."))")
			end
		end)
		
		QC.textField:SetScript("OnLeave", function() 
			local text = QC.textField:GetText()
			if text ~= "" then
				core.Chat:Print("/run print(IsQuestFlaggedCompleted("..text.."))")
			end
		end)
		 
		QC.textField:SetScript("OnEnterPressed", function()
			local text = QC.textField:GetText()
			if text ~= "" then
				core.Chat:Print("/run print(IsQuestFlaggedCompleted("..text.."))")
			end
		end)
		QC.textField:SetScript("OnTabPressed", function()
			local text = QC.textField:GetText()
			if text ~= "" then
				core.Chat:Print(text)
			end
		end)
		QC.textField:SetScript("OnTextChanged", function()
			local text = QC.textField:GetText()
			if text ~= "" then
				core.Chat:Print(text)
			end
		end)
		QC.textField:SetScript("OnEscapePressed", function()
			QC.textField:ClearFocus()
		end)
		
		--[[
			CHILD FRAME: check button
		--]]
		--QC.checkBtn = QC:CreateButton("CENTER", child, "TOP", -70, "Check")
		
		QC.okButton = CreateFrame("Button", nil, QC, "GameMenuButtonTemplate");
		QC.okButton:SetPoint("TOPLEFT", QC.textField, "TOPLEFT", 70,0);
		QC.okButton:SetSize(50, 20);
		QC.okButton:SetText("Check");
		QC.okButton:SetNormalFontObject("GameFontNormal");
		QC.okButton:SetHighlightFontObject("GameFontHighlight");
		QC.okButton:SetScript("OnMouseDown", 
			function(self, button)
				if button == "LeftButton" then
					local text = QC.textField:GetText()
					print(text)
					if text ~= "" then
						local message = "/run mesasage(IsQuestFlaggedCompleted("..text.."))"
						QC.textField:SetText(message)
						--QC.textField:Print("/run print(IsQuestFlaggedCompleted("..text.."))")
						AddMessage(message, 255, 0, 0, QC, 2000)
					end
				elseif button == "RightButton" then
				end
			end
		)
		
		QC:Show()
		--StartSizing("point") 
		--StopMovingOrSizing()
		--StartMoving()
		--SetScale(scale)
		--SetResizable(isResizable)
		--SetMovable(isMovable)
		--SetMinResize(minWidth, minHeight) 
		--SetMaxResize(maxWidth, maxHeight)
    end
end
local function handlerAux(msg, editBox)
	Config:Toggle(msg, editBox)
end
SlashCmdList.QUESTCOMPLETE = handlerAux;
