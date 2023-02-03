SLASH_HELLO1 = "/shop"
SLASH_HELLO2 = "/sl"

local shoppingListFrame;

local function ShoppingListSlashHandler(name)
    shoppingListFrame:Init()
    shoppingListFrame:Show()
end

SlashCmdList["HELLO"] = ShoppingListSlashHandler

shoppingListFrame = {
    ["frame"] = nil, -- our main frame

    ["Init"] = function ()
        local self = shoppingListFrame
        
        if not self.frame then
            local userSettings = {
                ["reagentWidth"] = 100
            }
            -- Enable default user settings
            if userSettings["hide"] == nil then userSettings["hide"] = false end
            if userSettings["removeCraft"] == nil then userSettings["removeCraft"] = true end
            if userSettings["showRemaining"] == nil then userSettings["showRemaining"] = false end
            if userSettings["showTooltip"] == nil then userSettings["showTooltip"] = true end
            if userSettings["recipeRows"] == nil then userSettings["recipeRows"] = 15 end
            if userSettings["reagentRows"] == nil then userSettings["reagentRows"] = 15 end
            if userSettings["recipeWidth"] == nil then userSettings["recipeWidth"] = 150 end
            if userSettings["recipeNoWidth"] == nil then userSettings["recipeNoWidth"] = 30 end
            if userSettings["reagentWidth"] == nil then userSettings["reagentWidth"] = 150 end
            if userSettings["reagentNoWidth"] == nil then userSettings["reagentNoWidth"] = 50 end
            if userSettings["vendorAll"] == nil then userSettings["vendorAll"] = true end
            if userSettings["reagentQuality"] == nil then userSettings["reagentQuality"] = 1 end
            if userSettings["closeWhenDone"] == nil then userSettings["closeWhenDone"] = false end
            if userSettings["showKnowledgeNotPerks"] == nil then userSettings["showKnowledgeNotPerks"] = false end

            local cols = {}

            -- Column formatting, Reagents
            cols[1] = {
                ["name"] = "Reagents",
                ["width"] = userSettings["reagentWidth"],
                ["align"] = "LEFT",
                ["color"] = {
                    ["r"] = 1.0,
                    ["g"] = 1.0,
                    ["b"] = 1.0,
                    ["a"] = 1.0
                },
                ["colorargs"] = nil,
                ["bgcolor"] = {
                    ["r"] = 0.0,
                    ["g"] = 0.0,
                    ["b"] = 0.0,
                    ["a"] = 0.0
                },
                ["defaultsort"] = "dsc",
                ["sort"] = "dsc",
                ["DoCellUpdate"] = nil,
            }
            
            -- Column formatting, Amount
            cols[2] = {
                ["name"] = "#",
                ["width"] = userSettings["reagentNoWidth"],
                ["align"] = "RIGHT",
                ["color"] = {
                    ["r"] = 1.0,
                    ["g"] = 1.0,
                    ["b"] = 1.0,
                    ["a"] = 1.0
                },
                ["bgcolor"] = {
                    ["r"] = 0.0,
                    ["g"] = 0.0,
                    ["b"] = 0.0,
                    ["a"] = 0.0
                },
                ["defaultsort"] = "dsc",
                ["sort"] = "dsc",
                ["DoCellUpdate"] = nil,
            }

            -- Frame
            local _frame = CreateFrame("Frame", "slFrame", UIParent, "ShoppingListItemTemplate")
            _frame:SetSize(255, 270)
		    _frame:SetPoint("CENTER")
		    _frame:EnableMouse(true)
		    _frame:SetMovable(true)

            -- Close button
            local close = CreateFrame("Button", "pslCloseButtonName1", _frame, "UIPanelCloseButton")
            close:SetPoint("TOPRIGHT", _frame, "TOPRIGHT", 1, -2)
            close:SetScript("OnClick", function() _frame:Hide() end)

            -- Create tracking window
            -- table1 = ScrollingTable:CreateST(cols, 50, nil, nil, _frame)

            self.frame = _frame
        end
    end,

    ["Show"] = function ()
        local self = shoppingListFrame
        self.frame:Show()
    end
}