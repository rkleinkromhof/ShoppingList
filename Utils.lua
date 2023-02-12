--[[
    Local functions and variables
]] 

-- stringify methods per Lua Data Type
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

--[[
    Public methods
]]

-- Capitalizes a sentence.
-- @tparam string str The string to capitalize.
function ShoppingList_Capitalize(str)
    return (str:gsub("^%l", string.upper))
end

-- Stringifies a value
-- @param value The value to stringify. Can be any type, but for some types no actual content is returned (like function)
function ShoppingList_Stringify(value)
    local valueType = type(value)
    local method = stringMethods[valueType]

    if method then
        return string.format("[%s] %s", valueType, method(value))
    end
    return "unknown type:"..valueType
end

-- Prints a message detailing the event and its arguments; for debugging purposes.
-- @tparam string event The event name.
-- @tparam table args The arguments passed to the event handler.
function ShoppingList_PrintEventArgs(event, args)
    local stringifiedArgs
    for i = 1, #args do
        stringifiedArgs = (stringifiedArgs and stringifiedArgs.."," or "")..ShoppingList_Stringify(args[i])
    end

    print("[ShoppingList] OnEvent: event="..event..", args="..stringifiedArgs)
end

--[[
    Hello World stuff
]]

-- Shows a greeting message.
-- @tparam string name The name of the player to greet.
local function showGreeting(name)
    local greeting = "Hello, " .. name .. "!"
    
    message(greeting)
end

-- Greets the player.
-- @tparam string name The name of the player to greet. Omit to use the current player's name.
function ShoppingList_Greet(name)
    local nameExists = name ~= nil and string.len(name) > 0

    if(nameExists) then
        showGreeting(ShoppingList_Capitalize(name))
    else
        local playerName = UnitName("player")

        showGreeting(playerName)
    end
end