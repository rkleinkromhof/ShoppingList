
--[[
    Local functions
]] 
local function showGreeting(name)
    local greeting = "Hello, " .. name .. "!"
    
    message(greeting)
end

local function capitalize(str)
    return (str:gsub("^%l", string.upper))
end

--[[
    Public methods
]]

function ShoppingListGreet(name)
    local nameExists = name ~= nil and string.len(name) > 0

    if(nameExists) then
        showGreeting(capitalize(name))
    else
        local playerName = UnitName("player")

        showGreeting(playerName)
    end
end

