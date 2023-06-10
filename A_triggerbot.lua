--[[           Triggerbot           ]]--
--[[           --Author--            ]]--
--[[           Terminator           ]]--
--[[  (github.com/titaniummachine1  ]]--


local menuLoaded, MenuLib = pcall(require, "Menu")                                -- Load MenuLib
assert(menuLoaded, "MenuLib not found, please install it!")                       -- If not found, throw error
assert(MenuLib.Version >= 1.44, "MenuLib version is too old, please update it!")  -- If version is too old, throw error

--[[ Menu ]]--
local menu = MenuLib.Create("Truggerbot", MenuFlags.AutoSize)
menu.Style.TitleBg = { 205, 95, 50, 255 } -- Title Background Color (Flame Pea)
menu.Style.Outline = true                 -- Outline around the menu

local mEnable         = menu:AddComponent(MenuLib.Checkbox("Enable", true, ItemFlags.FullWidth))
local mEnableBody     = menu:AddComponent(MenuLib.Checkbox("Body", false, ItemFlags.FullWidth))
menu:AddComponent(MenuLib.Label("pressing ESC resets", ItemFlags.FullWidth))
local mBindkey        = menu:AddComponent(MenuLib.Keybind("Triggerbot Key", KEY_LSHIFT))

local function OnCreateMove(pCmd)
  if mEnable:GetValue() == true then --and  then --gamerules.IsMatchTypeCasual()
    local me = entities.GetLocalPlayer();
    local keybind = mBindkey:GetValue()
    local source = me:GetAbsOrigin() + me:GetPropVector( "localdata", "m_vecViewOffset[0]" ) ;
    local destination = source + engine.GetViewAngles():Forward() * 1000;
    local pLocalClass = me:GetPropInt("m_iClass")
    local trace = engine.TraceLine( source, destination, MASK_SHOT );

    if (trace.entity ~= nill) then
        if (keybind == KEY_NONE) and trace.hitgroup == 1 --if aiming at head and keybind is none then shoot
            or input.IsButtonDown(keybind) and trace.hitgroup == 1 then --if aiming at head and keybind is pressed then shoot
                    pCmd:SetButtons(pCmd:GetButtons() | IN_ATTACK)
        elseif mEnableBody:GetValue() and (keybind == KEY_NONE) and trace.hitgroup >= 2 --if aiming at body and keybind is none then shoot
            or mEnableBody:GetValue() and input.IsButtonDown(keybind) and trace.hitgroup >= 2 then --if aiming at body and keybind is pressed then shoot
                    pCmd:SetButtons(pCmd:GetButtons() | IN_ATTACK)
        end
    end
  end
end

--[[ Remove the menu when unloaded ]]--
local function OnUnload()                                -- Called when the script is unloaded
  MenuLib.RemoveMenu(menu)                             -- Remove the menu
  client.Command('play "ui/buttonclickrelease"', true) -- Play the "buttonclickrelease" sound
end

callbacks.Unregister("Unload", "MCT_Unload")                    -- Unregister the "Unload" callback
callbacks.Unregister("CreateMove", "MCT_CreateMove")            -- Unregister the "CreateMove" callback

callbacks.Register("Unload", "MCT_Unload", OnUnload)                         -- Register the "Unload" callback
callbacks.Register("CreateMove", "MCT_CreateMove", OnCreateMove)             -- Register the "CreateMove" callback
--[[ Play sound when loaded ]]--
client.Command('play "ui/buttonclick"', true) -- Play the "buttonclick" sound when the script is loaded
