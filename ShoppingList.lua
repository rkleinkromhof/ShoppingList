-- Imports
local ScrollingTable = LibStub("ScrollingTable")

-- Inits
local api = CreateFrame("Frame") -- For registering API Events
local shoppingListFrame;

-- API Events
api:RegisterEvent("ADDON_LOADED")
--api:RegisterEvent("BAG_UPDATE")
api:RegisterEvent("TRACKED_RECIPE_UPDATE")

print("[ShoppingList] booting up AddOn")

shoppingListFrame = {
    ["frame"] = nil, -- our main frame

    ["Init"] = function ()
        local self = shoppingListFrame
        
        if not self.frame then
            print("[ShoppingList] init frame")
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
            --local _frame = CreateFrame("Frame", "slFrame", UIParent, "ShoppingListItemTemplate")
            local _frame = CreateFrame("Frame", "slFrame", UIParent, "ShoppingListItemTemplate" and "BackdropTemplate") -- BackdropTemplateMixin
            _frame:SetSize(255, 270)
		    _frame:SetPoint("CENTER")
		    _frame:EnableMouse(true)
		    _frame:SetMovable(true)
            self.frame = _frame

            -- Close button
            local close = CreateFrame("Button", "pslCloseButtonName1", _frame, "UIPanelCloseButton")
            close:SetPoint("TOPRIGHT", _frame, "TOPRIGHT", 1, -2)
            close:SetScript("OnClick", function() _frame:Hide() end)

            -- Create tracking window
            table1 = ScrollingTable:CreateST(cols, 50, nil, nil, _frame)
            table1:SetDisplayRows(userSettings["reagentRows"], 15)
            table1:SetDisplayCols(cols)

            self.frame:SetSize(userSettings["reagentWidth"]+userSettings["reagentNoWidth"]+30, userSettings["reagentRows"]*15+45)
        end
    end,

    ["OnAddonLoaded"] = function ()
        -- Slash commands
        SLASH_SHOPPINGLIST1 = "/shop"
        SLASH_SHOPPINGLIST2 = "/sl"

        SlashCmdList["SHOPPINGLIST"] = shoppingListFrame.SlashHandler

        shoppingListFrame:Init()

        -- TODO: load data
    end,

    ["Show"] = function ()
        local self = shoppingListFrame
        self.frame:Show()
    end,

    ["SlashHandler"] = function (name)
        shoppingListFrame:Show()
    end
}

api:SetScript("OnEvent", function(self, event, arg1, arg2, ...)
    if event == "ADDON_LOADED" and arg1 == "ShoppingList" then
        print("[ShoppingList] AddOn loaded")
        shoppingListFrame.OnAddonLoaded()
    end
end)