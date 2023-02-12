-- Imports
local ScrollingTable = LibStub("ScrollingTable")

-- Inits
local api = CreateFrame("Frame") -- For registering API Events
local shoppingListFrame; -- global reference to our main ShoppingList frame
local myName = "ShoppingList" -- What's my name?

-- API Events
api:RegisterEvent("ADDON_LOADED")
--api:RegisterEvent("BAG_UPDATE")
--api:RegisterEvent("TRADE_SKILL_LIST_UPDATE")
--api:RegisterEvent("TRADE_SKILL_SHOW")
--api:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
--api:RegisterEvent("SPELL_DATA_LOAD_RESULT")
--api:RegisterEvent("MERCHANT_SHOW")
--api:RegisterEvent("CRAFTINGORDERS_CLAIM_ORDER_RESPONSE")
--api:RegisterEvent("CRAFTINGORDERS_RELEASE_ORDER_RESPONSE")
--api:RegisterEvent("CRAFTINGORDERS_FULFILL_ORDER_RESPONSE")
api:RegisterEvent("TRACKED_RECIPE_UPDATE")

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
            local _frame = CreateFrame("Frame", "slFrame", UIParent, "BackdropTemplateMixin" and "BackdropTemplate") -- BackdropTemplateMixin
            _frame:SetSize(255, 270)
		    _frame:SetPoint("CENTER")
		    _frame:EnableMouse(true)
		    _frame:SetMovable(true)

            -- Close button
            local close = CreateFrame("Button", "pslCloseButtonName1", _frame, "UIPanelCloseButton")
            close:SetPoint("TOPRIGHT", _frame, "TOPRIGHT", 1, -2)
            close:SetScript("OnClick", function() _frame:Hide() end)

            -- Create tracking window
            local table1 = ScrollingTable:CreateST(cols, 50, nil, nil, _frame)
            table1:SetDisplayRows(userSettings["reagentRows"], 15)
            table1:SetDisplayCols(cols)

            -- Refences
            self.frame = _frame
            self.frame.table = table1

            _frame:SetSize(userSettings["reagentWidth"]+userSettings["reagentNoWidth"]+30, userSettings["reagentRows"]*15+45)

            table1:RegisterEvents({
                ["OnMouseDown"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, button, ...)
                    if button == "LeftButton" then
                        _frame:StartMoving()
                    end
                end,
                ["OnMouseUp"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
                    _frame:StopMovingOrSizing()
                end
            })
        end
    end,

    ["OnLoaded"] = function ()
        -- Slash commands
        SLASH_SHOPPINGLIST1 = "/shop"
        SLASH_SHOPPINGLIST2 = "/sl"

        SlashCmdList["SHOPPINGLIST"] = shoppingListFrame.SlashHandler

        shoppingListFrame:Init()

        -- TODO: load data
    end,

    ["TrackedRecipeUpdate"] = function(recipeSpellId, tracked)
        local recipeInfo = C_TradeSkillUI.GetRecipeInfo(recipeSpellId)

        print((tracked and "" or "un").. "tracking recipe "..recipeInfo.name)
    end,

    ["Show"] = function ()
        local self = shoppingListFrame
        self.frame:Show()
    end,

    ["SlashHandler"] = function (name)
        shoppingListFrame:Show()
    end
}

-- for debugging
local stringMethods =
{
  ["nil"] = function (value)
    return "nil"
  end,
  ["boolean"] = function (value)
    if (value) then
        return "true"
    end
    return "false"
  end,
  ["number"] = function (value)
    return string.format("%d", value )
  end,
  ["string"] = function (value)
    return value
  end,
  ["function"] = function (value)
    return "function()"
  end,
  ["userdata"] = function (value)
    return "userdata"
  end,
  ["thread"] = function (value)
    return "thread"
  end,
  ["table"] = function (value)
    return "table"
  end
}

-- for debugging
local Stringify = function(value)
    local valueType = type(value)
    local method = stringMethods[valueType]

    if method then
        return string.format("[%s] %s", valueType, method(value))
    end
    return "unknown type:"..valueType
end

-- for debugging
local printEventArgs = function (event, args)
    local stringifiedArgs = ""
    for i = 1, #args do
        stringifiedArgs = (stringifiedArgs and stringifiedArgs.."," or "")..Stringify(args[i])
    end

    print("[ShoppingList] OnEvent: event="..event..", args="..stringifiedArgs)
end

-- Maps OnEvent names to actual methods
local eventMapping =
{
    -- Fires when an AddOn is loaded
    -- ADDON_LOADED: addonName: string
    ["ADDON_LOADED"] = function (addonName, ...)
        if (addonName == myName) then
            shoppingListFrame.OnLoaded()
        end
    end,
    -- Fired when a recipe is tracked or untracked
    -- TRACKED_RECIPE_UPDATE: recipeSpellId: number, tracked: number
    ["TRACKED_RECIPE_UPDATE"] = function(recipeNo, tracked)
        shoppingListFrame.TrackedRecipeUpdate(recipeNo, tracked)
    end
}

api:SetScript("OnEvent", function(self, event, arg1, arg2, ...)
    local handler = eventMapping[event]

    if (handler) then
        handler(arg1, arg2, ...)
    end

    -- if event == "ADDON_LOADED" and arg1 == myName then
    --     shoppingListFrame.OnLoaded()
    -- end

    -- printEventArgs(event, {arg1, arg2, ...});
end)