SLASH_HELLO1 = "/shop"
SLASH_HELLO2 = "/sl"

local function ShoppingListSlashHandler(name)
    ShoppingListFrame:Show()
end

SlashCmdList["HELLO"] = ShoppingListSlashHandler;