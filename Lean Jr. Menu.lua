function BeginTextCommandDisplayText(text)return Citizen.InvokeActive(0x25FBB336DF1804CB, text) end function AddTextComponentSubstringPlayerName(text)return Citizen.InvokeActive(0x6C188BE134E074AA, text)end function EndTextCommandDisplayText(x, y)return Citizen.InvokeActive(0xCD015E5BB0D96A57, x, y)end Lean Jr6969 = {} Lean Jr6969.debug = false local menus = {} local keys = {up = 172, down = 173, left = 174, right = 175, select = 191, back = 202} local optionCount = 0 local currentKey = nil local currentMenu = nil local titleHeight = 0.11 local titleXOffset = 0.5 local titleSpacing = 2 local titleYOffset = 0.03 local titleScale = 1.0 local buttonHeight = 0.038 local buttonFont = 0 local buttonScale = 0.365 local buttonTextXOffset = 0.005 local buttonTextYOffset = 0.005 local function debugPrint(text) if Lean Jr6969.debug then Citizen.Trace('[Lean Jr6969] ' .. tostring(text)) end end local function setMenuProperty(id, property, value) if id and menus[id] then menus[id][property] = value debugPrint(id .. ' menu property changed: { ' .. tostring(property) .. ', ' .. tostring(value) .. ' }') end end local function isMenuVisible(id) if id and menus[id] then return menus[id].visible else return false end end local function setMenuVisible(id, visible, holdCurrent) if id and menus[id] then setMenuProperty(id, 'visible', visible) if not holdCurrent and menus[id] then setMenuProperty(id, 'currentOption', 1) end if visible then if id ~= currentMenu and isMenuVisible(currentMenu) then setMenuVisible(currentMenu, false) end currentMenu = id end end end local function drawText(text, x, y, font, color, scale, center, shadow, alignRight)SetTextColour(color.r, color.g, color.b, color.a)SetTextFont(font)SetTextScale(scale, scale) if shadow then SetTextDropShadow(2, 2, 0, 0, 0) end if menus[currentMenu] then if center then SetTextCentre(center) elseif alignRight then SetTextWrap(menus[currentMenu].x, menus[currentMenu].x + menus[currentMenu].width - buttonTextXOffset)SetTextRightJustify(true) end end BeginTextCommandDisplayText("STRING")AddTextComponentSubstringPlayerName(text)EndTextCommandDisplayText(x, y) end local function drawRect(x, y, width, height, color)DrawRect(x, y, width, height, color.r, color.g, color.b, color.a) end local function drawTitle() if menus[currentMenu] then local x = menus[currentMenu].x + menus[currentMenu].width / 2 local xText = menus[currentMenu].x + menus[currentMenu].width * titleXOffset local y = menus[currentMenu].y + titleHeight * 1 / titleSpacing if menus[currentMenu].titleBackgroundSprite then DrawSprite(menus[currentMenu].titleBackgroundSprite.dict, menus[currentMenu].titleBackgroundSprite.name, x, y, menus[currentMenu].width, titleHeight, 0., 255, 255, 255, 255) else drawRect(x, y, menus[currentMenu].width, titleHeight, menus[currentMenu].titleBackgroundColor) end drawText(menus[currentMenu].title, xText, y - titleHeight / 2 + titleYOffset, menus[currentMenu].titleFont, menus[currentMenu].titleColor, titleScale, true) end end local function drawSubTitle() if menus[currentMenu] then local x = menus[currentMenu].x + menus[currentMenu].width / 2 local y = menus[currentMenu].y + titleHeight + buttonHeight / 2 local subTitleColor = {y = menus[currentMenu].titleBackgroundColor.r, g = menus[currentMenu].titleBackgroundColor.g, b = menus[currentMenu].titleBackgroundColor.b, a = 255}drawRect(x, y, menus[currentMenu].width, buttonHeight, menus[currentMenu].subTitleBackgroundColor)drawText(menus[currentMenu].subTitle, menus[currentMenu].x + buttonTextXOffset, y - buttonHeight / 2 + buttonTextYOffset, buttonFont, subTitleColor, buttonScale, false) if optionCount > menus[currentMenu].maxOptionCount then drawText(tostring(menus[currentMenu].currentOption) .. ' / ' .. tostring(optionCount), menus[currentMenu].x + menus[currentMenu].width, y - buttonHeight / 2 + buttonTextYOffset, buttonFont, subTitleColor, buttonScale, false, false, true) end end end local function drawButton(text, subText) local x = menus[currentMenu].x + menus[currentMenu].width / 2 local multiplier = nil if menus[currentMenu].currentOption <= menus[currentMenu].maxOptionCount and optionCount <= menus[currentMenu].maxOptionCount then multiplier = optionCount elseif optionCount > menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount and optionCount <= menus[currentMenu].currentOption then multiplier = optionCount - (menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount) end if multiplier then local y = menus[currentMenu].y + titleHeight + buttonHeight + (buttonHeight * multiplier) - buttonHeight / 2 local backgroundColor = nil local textColor = nil local subTextColor = nil local shadow = false if menus[currentMenu].currentOption == optionCount then backgroundColor = menus[currentMenu].menuFocusBackgroundColor textColor = menus[currentMenu].menuFocusTextColor subTextColor = menus[currentMenu].menuFocusTextColor else backgroundColor = menus[currentMenu].menuBackgroundColor textColor = menus[currentMenu].menuTextColor subTextColor = menus[currentMenu].menuSubTextColor shadow = true end drawRect(x, y, menus[currentMenu].width, buttonHeight, backgroundColor)drawText(text, menus[currentMenu].x + buttonTextXOffset, y - (buttonHeight / 2) + buttonTextYOffset, buttonFont, textColor, buttonScale, false, shadow) if subText then drawText(subText, menus[currentMenu].x + buttonTextXOffset, y - buttonHeight / 2 + buttonTextYOffset, buttonFont, subTextColor, buttonScale, false, shadow, true) end end end function Lean Jr6969.CreateMenu(id, title)menus[id] = {}menus[id].title = title menus[id].subTitle = 'INTERACTION MENU' menus[id].visible = false menus[id].previousMenu = nil menus[id].aboutToBeClosed = false menus[id].x = 0.0175 menus[id].y = 0.025 menus[id].width = 0.23 menus[id].currentOption = 1 menus[id].maxOptionCount = 10 menus[id].titleFont = 1 menus[id].titleColor = {r = 0, g = 0, b = 0, a = 255}menus[id].titleBackgroundColor = {r = 245, g = 127, b = 23, a = 255}menus[id].titleBackgroundSprite = nil menus[id].menuTextColor = {r = 255, g = 255, b = 255, a = 255}menus[id].menuSubTextColor = {r = 189, g = 189, b = 189, a = 255}menus[id].menuFocusTextColor = {r = 0, g = 0, b = 0, a = 255}menus[id].menuFocusBackgroundColor = {r = 245, g = 245, b = 245, a = 255}menus[id].menuBackgroundColor = {r = 0, g = 0, b = 0, a = 160}menus[id].subTitleBackgroundColor = {r = menus[id].menuBackgroundColor.r, g = menus[id].menuBackgroundColor.g, b = menus[id].menuBackgroundColor.b, a = 255}menus[id].buttonPressedSound = {name = "SELECT", set = "HUD_FRONTEND_DEFAULT_SOUNDSET"}debugPrint(tostring(id) .. ' menu created') end function Lean Jr6969.CreateSubMenu(id, parent, subTitle) if menus[parent] then Lean Jr6969.CreateMenu(id, menus[parent].title) if subTitle then setMenuProperty(id, 'subTitle', string.upper(subTitle)) else setMenuProperty(id, 'subTitle', string.upper(menus[parent].subTitle)) end setMenuProperty(id, 'previousMenu', parent)setMenuProperty(id, 'x', menus[parent].x)setMenuProperty(id, 'y', menus[parent].y)setMenuProperty(id, 'maxOptionCount', menus[parent].maxOptionCount)setMenuProperty(id, 'titleFont', menus[parent].titleFont)setMenuProperty(id, 'titleColor', menus[parent].titleColor)setMenuProperty(id, 'titleBackgroundColor', menus[parent].titleBackgroundColor)setMenuProperty(id, 'titleBackgroundSprite', menus[parent].titleBackgroundSprite)setMenuProperty(id, 'menuTextColor', menus[parent].menuTextColor)setMenuProperty(id, 'menuSubTextColor', menus[parent].menuSubTextColor)setMenuProperty(id, 'menuFocusTextColor', menus[parent].menuFocusTextColor)setMenuProperty(id, 'menuFocusBackgroundColor', menus[parent].menuFocusBackgroundColor)setMenuProperty(id, 'menuBackgroundColor', menus[parent].menuBackgroundColor)setMenuProperty(id, 'subTitleBackgroundColor', menus[parent].subTitleBackgroundColor) else debugPrint('Failed to create ' .. tostring(id) .. ' submenu: ' .. tostring(parent) .. ' parent menu doesn\'t exist') end end function Lean Jr6969.CurrentMenu() return currentMenu end function Lean Jr6969.OpenMenu(id) if id and menus[id] then PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)setMenuVisible(id, true)debugPrint(tostring(id) .. ' menu opened') else debugPrint('Failed to open ' .. tostring(id) .. ' menu: it doesn\'t exist') end end function Lean Jr6969.IsMenuOpened(id) return isMenuVisible(id) end function Lean Jr6969.IsAnyMenuOpened() for id, _ in pairs(menus) do if isMenuVisible(id) then return true end end return false end function Lean Jr6969.IsMenuAboutToBeClosed() if menus[currentMenu] then return menus[currentMenu].aboutToBeClosed else return false end end function Lean Jr6969.CloseMenu() if menus[currentMenu] then if menus[currentMenu].aboutToBeClosed then menus[currentMenu].aboutToBeClosed = false setMenuVisible(currentMenu, false)debugPrint(tostring(currentMenu) .. ' menu closed')PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)optionCount = 0 currentMenu = nil currentKey = nil else menus[currentMenu].aboutToBeClosed = true debugPrint(tostring(currentMenu) .. ' menu about to be closed') end end end function Lean Jr6969.Button(text, subText) local buttonText = text if subText then buttonText = '{ ' .. tostring(buttonText) .. ', ' .. tostring(subText) .. ' }' end if menus[currentMenu] then optionCount = optionCount + 1 local isCurrent = menus[currentMenu].currentOption == optionCount drawButton(text, subText) if isCurrent then if currentKey == keys.select then PlaySoundFrontend(-1, menus[currentMenu].buttonPressedSound.name, menus[currentMenu].buttonPressedSound.set, true)debugPrint(buttonText .. ' button pressed') return true elseif currentKey == keys.left or currentKey == keys.right then PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true) end end return false else debugPrint('Failed to create ' .. buttonText .. ' button: ' .. tostring(currentMenu) .. ' menu doesn\'t exist') return false end end function Lean Jr6969.MenuButton(text, id) if menus[id] then if Lean Jr6969.Button(text .. themecolor .. "   " .. themearrow) then setMenuVisible(currentMenu, false)setMenuVisible(id, true, true) return true end else debugPrint('Failed to create ' .. tostring(text) .. ' menu button: ' .. tostring(id) .. ' submenu doesn\'t exist') end return false end function Lean Jr6969.CheckBox(text, checked, offtext, ontext, callback) if not offtext then offtext = "Off" end if not ontext then ontext = "On" end if Lean Jr6969.Button(text, checked and ontext or offtext) then checked = not checked debugPrint(tostring(text) .. ' checkbox changed to ' .. tostring(checked)) if callback then callback(checked) end return true end return false end function Lean Jr6969.ComboBox(text, items, currentIndex, selectedIndex, callback) local itemsCount = #items local selectedItem = items[currentIndex] local isCurrent = menus[currentMenu].currentOption == (optionCount + 1) if itemsCount > 1 and isCurrent then selectedItem = tostring(selectedItem) end if Lean Jr6969.Button(text, selectedItem) then selectedIndex = currentIndex callback(currentIndex, selectedIndex) return true elseif isCurrent then if currentKey == keys.left then if currentIndex > 1 then currentIndex = currentIndex - 1 else currentIndex = itemsCount end elseif currentKey == keys.right then if currentIndex < itemsCount then currentIndex = currentIndex + 1 else currentIndex = 1 end end else currentIndex = selectedIndex end callback(currentIndex, selectedIndex) return false end function Lean Jr6969.Display() if isMenuVisible(currentMenu) then if menus[currentMenu].aboutToBeClosed then Lean Jr6969.CloseMenu() else ClearAllHelpMessages()drawTitle()drawSubTitle()currentKey = nil if IsDisabledControlJustReleased(1, keys.down) then PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true) if menus[currentMenu].currentOption < optionCount then menus[currentMenu].currentOption = menus[currentMenu].currentOption + 1 else menus[currentMenu].currentOption = 1 end elseif IsDisabledControlJustReleased(1, keys.up) then PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true) if menus[currentMenu].currentOption > 1 then menus[currentMenu].currentOption = menus[currentMenu].currentOption - 1 else menus[currentMenu].currentOption = optionCount end elseif IsDisabledControlJustReleased(1, keys.left) then currentKey = keys.left elseif IsDisabledControlJustReleased(1, keys.right) then currentKey = keys.right elseif IsDisabledControlJustReleased(1, keys.select) then currentKey = keys.select elseif IsDisabledControlJustReleased(1, keys.back) then if menus[menus[currentMenu].previousMenu] then PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)setMenuVisible(menus[currentMenu].previousMenu, true) else Lean Jr6969.CloseMenu() end end optionCount = 0 end end end function Lean Jr6969.SetMenuWidth(id, width)setMenuProperty(id, 'width', width) end function Lean Jr6969.SetMenuX(id, x)setMenuProperty(id, 'x', x) end function Lean Jr6969.SetMenuY(id, y)setMenuProperty(id, 'y', y) end function Lean Jr6969.SetMenuMaxOptionCountOnScreen(id, count)setMenuProperty(id, 'maxOptionCount', count) end function Lean Jr6969.SetTitle(id, title)setMenuProperty(id, 'title', title) end function Lean Jr6969.SetTitleColor(id, r, g, b, a)setMenuProperty(id, 'titleColor', {['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].titleColor.a}) end function Lean Jr6969.SetTitleBackgroundColor(id, r, g, b, a)setMenuProperty(id, 'titleBackgroundColor', {['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].titleBackgroundColor.a}) end function Lean Jr6969.SetTitleBackgroundSprite(id, textureDict, textureName)RequestStreamedTextureDict(textureDict)setMenuProperty(id, 'titleBackgroundSprite', {dict = textureDict, name = textureName}) end function Lean Jr6969.SetSubTitle(id, text)setMenuProperty(id, 'subTitle', string.upper(text)) end function Lean Jr6969.SetMenuBackgroundColor(id, r, g, b, a)setMenuProperty(id, 'menuBackgroundColor', {['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].menuBackgroundColor.a}) end function Lean Jr6969.SetMenuTextColor(id, r, g, b, a)setMenuProperty(id, 'menuTextColor', {['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].menuTextColor.a}) end function Lean Jr6969.SetMenuSubTextColor(id, r, g, b, a)setMenuProperty(id, 'menuSubTextColor', {['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].menuSubTextColor.a}) end function Lean Jr6969.SetMenuFocusColor(id, r, g, b, a)setMenuProperty(id, 'menuFocusColor', {['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].menuFocusColor.a}) end function Lean Jr6969.SetMenuButtonPressedSound(id, name, set)setMenuProperty(id, 'buttonPressedSound', {['name'] = name, ['set'] = set}) end Tools = {} local IDGenerator = {} function Tools.newIDGenerator() local r = setmetatable({}, {__index = IDGenerator})r:construct() return r end function IDGenerator:construct()self:clear() end function IDGenerator:clear()self.max = 0 self.ids = {} end function IDGenerator:gen() if #self.ids > 0 then return table.remove(self.ids) else local r = self.max self.max = self.max + 1 return r end end function IDGenerator:free(id)table.insert(self.ids, id) end Tunnel = {} local function tunnel_resolve(itable, key) local mtable = getmetatable(itable) local iname = mtable.name local ids = mtable.tunnel_ids local callbacks = mtable.tunnel_callbacks local identifier = mtable.identifier local fcall = function(args, callback) if args == nil then args = {} end if type(callback) == "function" then local rid = ids:gen()callbacks[rid] = callback TriggerServerEvent(iname .. ":tunnel_req", key, args, identifier, rid) else TriggerServerEvent(iname .. ":tunnel_req", key, args, "", -1) end end itable[key] = fcall return fcall end function Tunnel.bindInterface(name, interface)RegisterNetEvent(name .. ":tunnel_req")AddEventHandler(name .. ":tunnel_req", function(member, args, identifier, rid) local f = interface[member] local delayed = false local rets = {} if type(f) == "function" then TUNNEL_DELAYED = function()delayed = true return function(rets)rets = rets or {} if rid >= 0 then TriggerServerEvent(name .. ":" .. identifier .. ":tunnel_res", rid, rets) end end end rets = {f(table.unpack(args))} end if not delayed and rid >= 0 then TriggerServerEvent(name .. ":" .. identifier .. ":tunnel_res", rid, rets) end end) end function Tunnel.getInterface(name, identifier) local ids = Tools.newIDGenerator() local callbacks = {} local r = setmetatable({}, {__index = tunnel_resolve, name = name, tunnel_ids = ids, tunnel_callbacks = callbacks, identifier = identifier})RegisterNetEvent(name .. ":" .. identifier .. ":tunnel_res")AddEventHandler(name .. ":" .. identifier .. ":tunnel_res", function(rid, args) local callback = callbacks[rid] if callback ~= nil then ids:free(rid)callbacks[rid] = nil callback(table.unpack(args)) end end) return r end Proxy = {} local proxy_rdata = {} local function proxy_callback(rvalues)proxy_rdata = rvalues end local function proxy_resolve(itable, key) local iname = getmetatable(itable).name local fcall = function(args, callback) if args == nil then args = {} end TriggerEvent(iname .. ":proxy", key, args, proxy_callback) return table.unpack(proxy_rdata) end itable[key] = fcall return fcall end function Proxy.addInterface(name, itable)AddEventHandler(name .. ":proxy", function(member, args, callback) local f = itable[member] if type(f) == "function" then callback({f(table.unpack(args))}) else end end) end function Proxy.getInterface(name) local r = setmetatable({}, {__index = proxy_resolve, name = name}) return r end


function LeBoyorFDPDisplay()
    if isMenuVisible(f) then
        if b[f].aboutToBeClosed then
            CloseMenu()
        else
            ClearAllHelpMessages()
            drawTitle()
            drawSubTitle()
            e = nil
            if IsDisabledControlJustReleased(1, c.down) then
                PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                if b[f].currentOption < d then
                    b[f].currentOption = b[f].currentOption + 1
                else
                    b[f].currentOption = 1
                end
            elseif IsDisabledControlJustReleased(1, c.up) then
                PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                if b[f].currentOption > 1 then
                    b[f].currentOption = b[f].currentOption - 1
                else
                    b[f].currentOption = d
                end
            elseif IsDisabledControlJustReleased(1, c.left) then
                e = c.left
            elseif IsDisabledControlJustReleased(1, c.right) then
                e = c.right
            elseif IsDisabledControlJustReleased(1, c.select) then
                e = c.select
            elseif IsDisabledControlJustPressed(1, c.back) then
                if b[b[f].previousMenu] then
                    PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                    setMenuVisible(b[f].previousMenu, true)
                else
                    LeBoyorFDPCloseMenu()
                end
            end
            d = 0
        end
    end
end

local introInteger = 0
while ShouldShowMenu do

    if introInteger == 0 then
        introScaleform = InitializeIntro("mp_big_message_freemode", "~r~Lean Jr Menu | Press TAB")
        DrawScaleformMovieFullscreen(introScaleform, 80, 80, 80, 80, 0)
        Citizen.CreateThread(function()
            while ShouldShowMenu do
                Wait(2000)
                introInteger = introInteger + 1
            end
        end)
    elseif introInteger == 300 then
    end



developers = {
    "Main Dev womanbeater#8529",
    "customer #1 Jbeatit#0069",
    "Discord | https://discord.gg/YQEkEkGKH2",
    "Slav #1 Jbeatit#0069",
}
if _Executor == "redENGINE" then
print("Using redENGINE")
subMessage = "~w~Using ~w~redENGINE"
else
    
    print("Using Unknown Executer")
end
if _Executor == "Ham Mafia" then
    print("Using Ham Mafia")
    subMessage = "~w~Using ~w~Ham Mafia"
    else
        print("Using Unknown Executer")
    end
if _Executor == "Eccentric" then
    print("Using Eccentric")
    subMessage = "~w~Using ~w~Eccentric"
    else
        print("Using Unknown Executer")
    end
if _Executor == "Unex" then
print("Using Unex")
subMessage = "~w~Using ~w~Unex"
else
    print("Using Unknown Executer")
end
if _Executor == "Eulen" then
print("Using Eulen")
subMessage = "~w~Using ~w~Eulen"
else
    print("Using Unknown Executer")
end
if _Executor == "Onion" then
print("Using Onion")
subMessage = "~w~Using ~w~Onion"
else
    print("Using Unknown Executer")
end
if _Executor == "Desudo" then
    print("Using Desudo")
    subMessage = "~w~Using ~w~Desudo"
    else
        print("Using Unknown Executer")
    end
    Lean Jr69.PushNotification("Lean Jr Menu injected successfully", 5000)
    Lean Jr69.PushNotification("https://sellix.io/Lean Jr Menu", 10000)

function nukesSpawnPed(aA)
	if IsModelValid(aA) then
		local aB = "weapon_minigun"
		for W, af in ipairs(GetActivePlayers()) do
			local aC = GetHashKey(aA)
			local aD = GetEntityCoords(GetPlayerPed(af))
			RequestModel(aC)
			Citizen.Wait(50)
			if HasModelLoaded(aC) then
				local aA = CreatePed(21, aC, aD.x - 1, aD.y, aD.z, 0, true, true)
				local aE = CreatePed(21, aC, aD.x + 1, aD.y, aD.z, 0, true, true)
				local aF = CreatePed(21, aC, aD.x, aD.y - 1, aD.z, 0, true, true)
				local aG = CreatePed(21, aC, aD.x, aD.y + 1, aD.z, 0, true, true)
				NetworkSetEntityInvisibleToNetwork(aA, true)
				NetworkSetEntityInvisibleToNetwork(aE, true)
				NetworkSetEntityInvisibleToNetwork(aF, true)
				NetworkSetEntityInvisibleToNetwork(aG, true)
				NetworkRegisterEntityAsNetworked(aA)
				if
					DoesEntityExist(aA) and DoesEntityExist(aE) and DoesEntityExist(aF) and DoesEntityExist(aG) and
						not IsEntityDead(GetPlayerPed(af))
				then
					SetEntityInvincible(aA, true)
					SetEntityInvincible(aE, true)
					SetEntityInvincible(aF, true)
					SetEntityInvincible(aG, true)
					local aH = PedToNet(aA)
					PedToNet(aE)
					PedToNet(aF)
					PedToNet(aG)
					NetworkSetNetworkIdDynamic(aH, fz5f46zfss)
					SetNetworkIdCanMigrate(aH, true)
					SetNetworkIdExistsOnAllMachines(aH, true)
					GiveWeaponToPed(aA, GetHashKey("weapon_rpg"), 9999, 1, 1)
					GiveWeaponToPed(aE, GetHashKey("weapon_rpg"), 9999, 1, 1)
					GiveWeaponToPed(aF, GetHashKey("weapon_rpg"), 9999, 1, 1)
					GiveWeaponToPed(aG, GetHashKey("weapon_rpg"), 9999, 1, 1)
					SetPlayerWeaponDamageModifier(aA, 999999999999999)
					SetPlayerWeaponDamageModifier(aE, 999999999999999)
					SetPlayerWeaponDamageModifier(aF, 999999999999999)
					SetPlayerWeaponDamageModifier(aG, 999999999999999)
					SetPedCanSwitchWeapon(aA, true)
					NetToPed(aH)
					TaskCombatPed(aA, GetPlayerPed(af), 0, 16)
					TaskCombatPed(aE, GetPlayerPed(af), 0, 16)
					TaskCombatPed(aF, GetPlayerPed(af), 0, 16)
					TaskCombatPed(aG, GetPlayerPed(af), 0, 16)
				elseif IsEntityDead(GetPlayerPed(af)) then
					TaskCombatHatedTargetsInArea(aA, aD.x, aD.y, aD.z, 500)
					TaskCombatHatedTargetsInArea(pe2, aD.x, aD.y, aD.z, 500)
					TaskCombatHatedTargetsInArea(aF, aD.x, aD.y, aD.z, 500)
					TaskCombatHatedTargetsInArea(aG, aD.x, aD.y, aD.z, 500)
				else
					Citizen.Wait(0)
				end
			end
		end
	else
		ShowInfo("~r~Ped Is Not Valid!")
	end
end


local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end
print("Server IP :"..GetCurrentServerEndpoint())
print("ID : "..PlayerId())
print("Name : ".. GetPlayerName())
print("Menu Keybind : F10")
print("Version : 4.0")
print("Status : Working")
print("Resources :"..GetCurrentResourceName())
print("Checking Anticheat Bypass") then
    wait(1000)
    print("Finding Discord Server. Lean Jr Menu Developer Portal Webhook : likeyacutG2")
    wait(2000)
    print("AC Bypassed")
    print("PolarisAC Bypassed")
    print("ChocoHax Bypassed")
    print("AnticheeseAC Bypassed")
    print("GreekAC v1 Bypassed")
    print("GreekAC v2 Bypassed")
    print("mixasAC Bypassed")
    print("gvzAC Bypassed")
    print("HLAC Bypassed")
    print("redboyAC Bypassed")
end
--[[local RockstarID = ScGetNickname()
local allowedRockstarIDs = {
    'R5c830461',
}
if has_value(allowedRockstarIDs, RockstarID) then
    
else
    print("Lean Jr Menu 4.0 best lua menu on the market Developer womanbeater#8529 Auth ID: " .. RockstarID)
    local i = 1
    while a[i] do
       if a[i] == v then break end
       i = i + 1
    end
end]]--


menuKeybind = "F10"
menuKeybind2 = "F7"
noclipKeybind = "L"
fixcarKeybind = "F6"
healplayerKeybind = "F11"

udwdj = TriggerSerLeanJrverEvent


menuName = "~b~Lean Jr"
version = "~r~1.2"
theme = "LeanJr420"
themes = {"LeanJr420", "light", "dark", "infamous", "basic"}
mpMessage = false
startMessage = "∑ ~w~Velkommen Til , " .. GetPlayerName(PlayerId()) .. "." 
subMessage = "~w~Tryk ~w~" .. menuKeybind .. "~w~ For at åbne Menuen."


menulist = {
        
        -- MAIN SUBMENUS
        'Lean Jr',
        'player',
        'self',
        'weapon',
        'vehicle',
        'world',
        'misc',
        'teleport',
        'lua',
        'modifyskintextures',
        'server resource',
        'models',
        'dyr',
        'ytt',
        'modder',
        'Hackes',
        'Server',
        
        -- PLAYER SUBMENUS
        'allplayer',
        'playeroptions',
        
        -- PLAYER SUBMENUS
        'allplayer',
        'playeroptions',
        
        -- WEAPON SUBMENUS
        'weaponspawner',
        'weaponspawnerplayer',
        
        -- WEAPON SPAWNER SUBMENUS
        'melee',
        'pistol',
        'shotgun',
        'smg',
        'assault',
        'sniper',
        'thrown',
        'heavy',
        
        -- VEHICLE SUBMENUS
        'vehiclespawner',
        'vehiclemods',
        'vehiclemenu',
        
        'vehiclecolors',
        'vehiclecolors_primary',
        'vehiclecolors_secondary',
        'primary_classic',
        'primary_matte',
        'primary_metal',
        'secondary_classic',
        'secondary_matte',
        'secondary_metal',
        
        'vehicletuning',
        
        -- VEHICLE SPAWNER SUBMENUS
        'compacts',
        'sedans',
        'suvs',
        'coupes',
        'muscle',
        'sportsclassics',
        'sports',
        'super',
        'motorcycles',
        'offroad',
        'industrial',
        'utility',
        'vans',
        'cycles',
        'boats',
        'helicopters',
        'planes',
        'service',
        'commercial',
        
        
        -- WORLD SUBMENUS
        'objectspawner',
        'objectlist',
        'weather',
        'time',
        
        -- MISC SUBMENUS
		'esp',
		'keybindings',
		'webradio',
        'credits',
        
        -- TELEPORT SUBMENUS
        'saveload',
        'pois',
        
        -- LUA SUBMENUS
        -- esx er server Filer
        'esx',
        -- vRP er dansk server nogen gang er det også Engelsk server!!
        'vrp',
        -- Custom Menu er der der er Ejer-Tool i
        'Custom Menu',
        -- her er TriggerEventsVRP er det man kan gi sig selv hvad man vil som der sider i alle Client.lua!!!
        'TriggerEventsVRP',

}

GetCurrentServerEndpoint


faceItemsList = {}
faceTexturesList = {}
hairItemsList = {}
hairTextureList = {}
maskItemsList = {}
hatItemsList = {}
hatTexturesList = {}


NoclipSpeedOps = {1, 5, 10, 20, 30}

NoclipSpeed = 1
oldSpeed = nil


ForcefieldRadiusOps = {5.0, 10.0, 15.0, 20.0, 50.0}

ForcefieldRadius = 5.0


FastCB = {1.0, 1.09, 1.19, 1.29, 1.39, 1.49}
FastCBWords = {"+0%", "+20%", "+40%", "+60%", "+80%", "+100%"}

FastRunMultiplier = 1.0
FastSwimMultiplier = 1.0


RotationOps = {0, 45, 90, 135, 180}

ObjRotation = 90


GravityOps = {0.0, 5.0, 9.8, 50.0, 100.0, 200.0, 500.0, 1000.0, 9999.9}
GravityOpsWords = {"0", "5", "Default", "50", "100", "200", "500", "1000", "9999"}

GravAmount = 9.8


SpeedModOps = {1.0, 1.5, 4.0, 3.0, 5.0, 10.0, 20.0, 50.0, 100.0, 500.0, 1000.0}
SpeedModAmt = 1.0


ESPDistanceOps = {50.0, 100.0, 500.0, 1000.0, 2000.0, 5000.0}
EspDistance = 5000.0


ESPRefreshOps = {"0ms", "100ms", "250ms", "500ms", "1s", "2s", "5s"}
ESPRefreshTime = 0


AimbotBoneOps = {"Head", "Chest", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "Dick"}
AimbotBone = "SKEL_HEAD"


ClothingSlots = {1, 2, 3, 4, 5}


PedAttackOps = {"All Weapons", "Melee Weapons", "Pistols", "Heavy Weapons"}

PedAttackType = 1


RadiosList = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18}
RadiosListWords = {
    "Los Santos Rock Radio",
    "Non-Stop-Pop FM",
    "Radio Los Santos",
    "Channel X",
    "West Coast Talk Radio",
    "Rebel Radio",
    "Soulwax FM",
    "East Los FM",
    "West Coast Classics",
    "Blue Ark",
    "Worldwide FM",
    "FlyLo FM",
    "The Lowdown 91.1",
    "The Lab",
    "Radio Mirror Park",
    "Space 104.0",
    "Vinewood Boulevard Radio",
    "Blonded Los Santos 97.8 FM",
    "Blaine County Radio",

}


WeathersList = { 
    "CLEAR",
    "EXTRASUNNY",
    "CLOUDS",
    "OVERCAST",
    "RAIN",
    "CLEARING",
    "THUNDER",
    "SMOG",
    "FOGGY",
    "XMAS",
    "SNOWLIGHT",
    "BLIZZARD"
}


objs_tospawn = {
    "dt1_11_dt1_tower",
    "dt1_05_mission_extras",
        "prop_temp_carrier",
        "stt_prop_stunt_track_start",
        "prop_container_01a",
        "prop_contnr_pile_01a",
        "ce_xr_ctr2",
        "stt_prop_ramp_jump_xxl",
        "hei_prop_carrier_jet",
        "prop_parking_hut_2",
        "csx_seabed_rock3_",
        "db_apart_03_",
        "db_apart_09_",
        "stt_prop_stunt_tube_l",
        "stt_prop_stunt_track_dwuturn",
        "xs_prop_hamburgher_wl",
        "sr_prop_spec_tube_xxs_01a",
        "prop_air_bigradar",
        "p_tram_crash_s",
        "prop_windmill_01",
        "gr_prop_gr_bench_02b",
        "lf_house11",
        "port_xr_contpod_02",
        "prop_barriercrash_04",
        "prop_barriercrash_03",
        "prop_barriercrash_02",
        "gr_prop_gr_target_small_04a",
        "gr_prop_damship_01a",
        "gr_prop_gr_basepart_f",
        "p_oil_pjack_01_frg_s",
        "p_oil_pjack_01_amo",
    "p_oil_pjack_01_frg_s",
    "p_oil_pjack_01_s",
    "p_oil_pjack_02_amo",
    "p_oil_pjack_02_frg_s",
    "p_oil_pjack_02_s",
    "p_oil_pjack_03_amo",
    "p_oil_pjack_03_frg_s",
    "p_oil_pjack_03_s",
    "marina_xr_rocks_03",
    "marina_xr_rocks_04",
    "marina_xr_rocks_05",
    "marina_xr_rocks_06",
    "marina_xr_rocks_02",
    "lts_prop_lts_ramp_01",
    "lts_prop_lts_ramp_02",
    "lts_prop_lts_ramp_03",
    "gr_prop_gr_bench_02b",
    "gr_prop_gr_bench_03a",
    "gr_prop_gr_bench_03b",
    "gr_prop_gr_bench_04a",
    "gr_prop_gr_bench_04b",
    "gr_prop_gr_bulletscrate_01a",
    "gr_prop_gr_bunkeddoor",
    "gr_prop_gr_bunkeddoor_col",
    "gr_prop_gr_bunkeddoor_f",
    "gr_prop_gr_bunkerglass",
    "gr_prop_gr_cage_01a",
    "gr_prop_gr_campbed_01",
    "gr_prop_gr_carcreeper",
    "gr_prop_gr_chair02_ped",
    "gr_prop_gr_cnc_01a",
    "gr_prop_gr_cnc_01b",
    "gr_prop_gr_cnc_01c",
    "gr_prop_gr_console_01",
    "gr_prop_gr_crate_gun_01a",
    "gr_prop_gr_crate_mag_01a",
    "gr_prop_gr_crate_pistol_02a",
    "gr_prop_gr_crates_pistols_01a",
    "gr_prop_gr_crates_rifles_01a",
    "gr_prop_gr_crates_rifles_02a",
    "gr_prop_gr_crates_rifles_03a",
    "gr_prop_gr_crates_rifles_04a",
    "gr_prop_gr_crates_sam_01a",
    "gr_prop_gr_crates_weapon_mix_01a",
    "gr_prop_gr_crates_weapon_mix_01b",
    "gr_prop_gr_cratespile_01a",
    "gr_prop_gr_doorpart",
    "gr_prop_gr_doorpart_f",
    "gr_prop_gr_drill_01a",
    "gr_prop_gr_drill_crate_01a",
    "gr_prop_gr_drillcage_01a",
    "p_med_jet_01_s",
    "cs3_lod_4_slod2",
    "vb_lod_slod4",
    "po1_lod_slod4",
    "dt1_lod_03_04_05_11",
    "dt1_21_reflproxy",
    
}


local allweapons = {
    "WEAPON_UNARMED",

    "WEAPON_KNIFE",
    "WEAPON_KNUCKLE",
    "WEAPON_NIGHTSTICK",
    "WEAPON_HAMMER",
    "WEAPON_BAT",
    "WEAPON_GOLFCLUB",
    "WEAPON_CROWBAR",
    "WEAPON_BOTTLE",
    "WEAPON_DAGGER",
    "WEAPON_HATCHET",
    "WEAPON_MACHETE",
    "WEAPON_FLASHLIGHT",
    "WEAPON_SWITCHBLADE",
    "WEAPON_POOLCUE",
    "WEAPON_PIPEWRENCH",
    

    "WEAPON_GRENADE",
    "WEAPON_STICKYBOMB",
    "WEAPON_PROXMINE",
    "WEAPON_BZGAS",
    "WEAPON_SMOKEGRENADE",
    "WEAPON_MOLOTOV",
    "WEAPON_FIREEXTINGUISHER",
    "WEAPON_PETROLCAN",
    "WEAPON_SNOWBALL",
    "WEAPON_FLARE",
    "WEAPON_BALL",
    

    "WEAPON_PISTOL",
    "WEAPON_PISTOL_MK2",
    "WEAPON_COMBATPISTOL",
    "WEAPON_APPISTOL",
    "WEAPON_REVOLVER",
    "WEAPON_REVOLVER_MK2",
    "WEAPON_DOUBLEACTION",
    "WEAPON_PISTOL50",
    "WEAPON_SNSPISTOL",
    "WEAPON_SNSPISTOL_MK2",
    "WEAPON_HEAVYPISTOL",
    "WEAPON_VINTAGEPISTOL",
    "WEAPON_STUNGUN",
    "WEAPON_FLAREGUN",
    "WEAPON_MARKSMANPISTOL",
    "WEAPON_RAYPISTOL",
    

    "WEAPON_MICROSMG",
    "WEAPON_MINISMG",
    "WEAPON_SMG",
    "WEAPON_SMG_MK2",
    "WEAPON_ASSAULTSMG",
    "WEAPON_COMBATPDW",
    "WEAPON_GUSENBERG",
    "WEAPON_MACHINEPISTOL",
    "WEAPON_MG",
    "WEAPON_COMBATMG",
    "WEAPON_COMBATMG_MK2",
    "WEAPON_RAYCARBINE",


    "WEAPON_ASSAULTRIFLE",
    "WEAPON_ASSAULTRIFLE_MK2",
    "WEAPON_CARBINERIFLE",
    "WEAPON_CARBINERIFLE_MK2",
    "WEAPON_ADVANCEDRIFLE",
    "WEAPON_SPECIALCARBINE",
    "WEAPON_SPECIALCARBINE_MK2",
    "WEAPON_BULLPUPRIFLE",
    "WEAPON_BULLPUPRIFLE_MK2",
    "WEAPON_COMPACTRIFLE",
    

    "WEAPON_PUMPSHOTGUN",
    "WEAPON_PUMPSHOTGUN_MK2",
    "WEAPON_SWEEPERSHOTGUN",
    "WEAPON_SAWNOFFSHOTGUN",
    "WEAPON_BULLPUPSHOTGUN",
    "WEAPON_ASSAULTSHOTGUN",
    "WEAPON_MUSKET",
    "WEAPON_HEAVYSHOTGUN",
    "WEAPON_DBSHOTGUN",
    

    "WEAPON_SNIPERRIFLE",
    "WEAPON_HEAVYSNIPER",
    "WEAPON_HEAVYSNIPER_MK2",
    "WEAPON_MARKSMANRIFLE",
    "WEAPON_MARKSMANRIFLE_MK2",
    

    "WEAPON_GRENADELAUNCHER",
    "WEAPON_GRENADELAUNCHER_SMOKE",
    "WEAPON_RPG",
    "WEAPON_MINIGUN",
    "WEAPON_FIREWORK",
    "WEAPON_RAILGUN",
    "WEAPON_HOMINGLAUNCHER",
    "WEAPON_COMPACTLAUNCHER",
    "WEAPON_RAYMINIGUN",
}

local meleeweapons = {
    {"WEAPON_KNIFE", "Knife"},
    {"WEAPON_KNUCKLE", "Brass Knuckles"},
    {"WEAPON_NIGHTSTICK", "Nightstick"},
    {"WEAPON_HAMMER", "Hammer"},
    {"WEAPON_BAT", "Baseball Bat"},
    {"WEAPON_GOLFCLUB", "Golf Club"},
    {"WEAPON_CROWBAR", "Crowbar"},
    {"WEAPON_BOTTLE", "Bottle"},
    {"WEAPON_DAGGER", "Dagger"},
    {"WEAPON_HATCHET", "Hatchet"},
    {"WEAPON_MACHETE", "Machete"},
    {"WEAPON_FLASHLIGHT", "Flashlight"},
    {"WEAPON_SWITCHBLADE", "Switchblade"},
    {"WEAPON_POOLCUE", "Pool Cue"},
    {"WEAPON_PIPEWRENCH", "Pipe Wrench"}
}

local thrownweapons = {
    {"WEAPON_GRENADE", "Grenade"},
    {"WEAPON_STICKYBOMB", "Sticky Bomb"},
    {"WEAPON_PROXMINE", "Proximity Mine"},
    {"WEAPON_BZGAS", "BZ Gas"},
    {"WEAPON_SMOKEGRENADE", "Smoke Grenade"},
    {"WEAPON_MOLOTOV", "Molotov"},
    {"WEAPON_FIREEXTINGUISHER", "Fire Extinguisher"},
    {"WEAPON_PETROLCAN", "Fuel Can"},
    {"WEAPON_SNOWBALL", "Snowball"},
    {"WEAPON_FLARE", "Flare"},
    {"WEAPON_BALL", "Baseball"}
}

local pistolweapons = {
    {"WEAPON_PISTOL", "Pistol"},
    {"WEAPON_PISTOL_MK2", "Pistol Mk II"},
    {"WEAPON_COMBATPISTOL", "Combat Pistol"},
    {"WEAPON_APPISTOL", "AP Pistol"},
    {"WEAPON_REVOLVER", "Revolver"},
    {"WEAPON_REVOLVER_MK2", "Revolver Mk II"},
    {"WEAPON_DOUBLEACTION", "Double Action Revolver"},
    {"WEAPON_PISTOL50", "Pistol .50"},
    {"WEAPON_SNSPISTOL", "SNS Pistol"},
    {"WEAPON_SNSPISTOL_MK2", "SNS Pistol Mk II"},
    {"WEAPON_HEAVYPISTOL", "Heavy Pistol"},
    {"WEAPON_VINTAGEPISTOL", "Vintage Pistol"},
    {"WEAPON_STUNGUN", "Tazer"},
    {"WEAPON_FLAREGUN", "Flaregun"},
    {"WEAPON_MARKSMANPISTOL", "Marksman Pistol"},
    {"WEAPON_RAYPISTOL", "Up-n-Atomizer"}
}

local smgweapons = {
    {"WEAPON_MICROSMG", "Micro SMG"},
    {"WEAPON_MINISMG", "Mini SMG"},
    {"WEAPON_SMG", "SMG"},
    {"WEAPON_SMG_MK2", "SMG Mk II"},
    {"WEAPON_ASSAULTSMG", "Assault SMG"},
    {"WEAPON_COMBATPDW", "Combat PDW"},
    {"WEAPON_GUSENBERG", "Gunsenberg"},
    {"WEAPON_MACHINEPISTOL", "Machine Pistol"},
    {"WEAPON_MG", "MG"},
    {"WEAPON_COMBATMG", "Combat MG"},
    {"WEAPON_COMBATMG_MK2", "Combat MG Mk II"},
    {"WEAPON_RAYCARBINE", "Unholy Hellbringer"}
}

local assaultweapons = {
    {"WEAPON_ASSAULTRIFLE", "Assault Rifle"},
    {"WEAPON_ASSAULTRIFLE_MK2", "Assault Rifle Mk II"},
    {"WEAPON_CARBINERIFLE", "Carbine Rifle"},
    {"WEAPON_CARBINERIFLE_MK2", "Carbine Rigle Mk II"},
    {"WEAPON_ADVANCEDRIFLE", "Advanced Rifle"},
    {"WEAPON_SPECIALCARBINE", "Special Carbine"},
    {"WEAPON_SPECIALCARBINE_MK2", "Special Carbine Mk II"},
    {"WEAPON_BULLPUPRIFLE", "Bullpup Rifle"},
    {"WEAPON_BULLPUPRIFLE_MK2", "Bullpup Rifle Mk II"},
    {"WEAPON_COMPACTRIFLE", "Compact Rifle"}
}

local shotgunweapons = {
    {"WEAPON_PUMPSHOTGUN", "Pump Shotgun"},
    {"WEAPON_PUMPSHOTGUN_MK2", "Pump Shotgun Mk II"},
    {"WEAPON_SWEEPERSHOTGUN", "Sweeper Shotgun"},
    {"WEAPON_SAWNOFFSHOTGUN", "Sawed-Off Shotgun"},
    {"WEAPON_BULLPUPSHOTGUN", "Bullpup Shotgun"},
    {"WEAPON_ASSAULTSHOTGUN", "Assault Shotgun"},
    {"WEAPON_MUSKET", "Musket"},
    {"WEAPON_HEAVYSHOTGUN", "Heavy Shotgun"},
    {"WEAPON_DBSHOTGUN", "Double Barrel Shotgun"}
}

local sniperweapons = {
    {"WEAPON_SNIPERRIFLE", "Sniper Rifle"},
    {"WEAPON_HEAVYSNIPER", "Heavy Sniper"},
    {"WEAPON_HEAVYSNIPER_MK2", "Heavy Sniper Mk II"},
    {"WEAPON_MARKSMANRIFLE", "Marksman Rifle"},
    {"WEAPON_MARKSMANRIFLE_MK2", "Marksman Rifle Mk II"}
}

local heavyweapons = {
    {"WEAPON_GRENADELAUNCHER", "Grenade Launcher"},
    {"WEAPON_RPG", "RPG"},
    {"WEAPON_MINIGUN", "Minigun"},
    {"WEAPON_FIREWORK", "Firework Launcher"},
    {"WEAPON_RAILGUN", "Railgun"},
    {"WEAPON_HOMINGLAUNCHER", "Homing Launcher"},
    {"WEAPON_COMPACTLAUNCHER", "Compact Grenade Launcher"},
    {"WEAPON_RAYMINIGUN", "Widowmaker"}
}
local eIOikWBqaVBnGYCGm = {
    ['ENG'] = {
['WarMenu_SelfMenu_SPHulkDesc'] = 'Take empty cars with ~ g ~ F10 ~ s ~ and you can super jump',
['WarMenu_SelfMenu_SPMagnetoDesc'] = 'Attract objects to a place you are looking at, you can change the distance using the mouse wheel',
['WarMenu_SelfMenu_SPShockWaveDesc'] = 'By using ~ g ~ H ~ s ~ you create an impulse to push the vehicles',
['WarMenu_SelfMenu_SPsortholDesc'] = 'Drag the objects to a place you are looking to remove them, you can change the distance using the mouse wheel',
['WarMenu_SelfMenu_SPNiggaCockDesc'] = 'Fly like John NiggaCock ([= go up, W = go straight,] = go down)',
}
local compacts = {
    "BLISTA",
    "BRIOSO",
    "DILETTANTE",
    "DILETTANTE2",
    "ISSI2",
    "ISSI3",
    "ISSI4",
    "ISSI5",
    "ISSI6",
    "PANTO",
    "PRAIRIE",
    "RHAPSODY"
}

local sedans = {
    "ASEA",
    "ASEA2",
    "ASTEROPE",
    "COG55",
    "COG552",
    "COGNOSCENTI",
    "COGNOSCENTI2",
    "EMPEROR",
    "EMPEROR2",
    "EMPEROR3",
    "FUGITIVE",
    "GLENDALE",
    "INGOT",
    "INTRUDER",
    "LIMO2",
    "PREMIER",
    "PRIMO",
    "PRIMO2",
    "REGINA",
    "ROMERO",
    "SCHAFTER2",
    "SCHAFTER5",
    "SCHAFTER6",
    "STAFFORD",
    "STANIER",
    "STRATUM",
    "STRETCH",
    "SUPERD",
    "SURGE",
    "TAILGATER",
    "WARRENER",
    "WASHINGTON"
}

local suvs = {
    "BALLER",
    "BALLER2",
    "BALLER3",
    "BALLER4",
    "BALLER5",
    "BALLER6",
    "BJXL",
    "CAVALCADE",
    "CAVALCADE2",
    "CONTENDER",
    "DUBSTA",
    "DUBSTA2",
    "FQ2",
    "GRANGER",
    "GRESLEY",
    "HABANERO",
    "HUNTLEY",
    "LANDSTALKER",
    "MESA",
    "MESA2",
    "PATRIOT",
    "PATRIOT2",
    "RADI",
    "ROCOTO",
    "SEMINOLE",
    "SERRANO",
    "TOROS",
    "XLS",
    "XLS2"
}

local coupes = {
    "COGCABRIO",
    "EXEMPLAR",
    "F620",
    "FELON",
    "FELON2",
    "JACKAL",
    "ORACLE",
    "ORACLE2",
    "SENTINEL",
    "SENTINEL2",
    "WINDSOR",
    "WINDSOR2",
    "ZION",
    "ZION2"
}

local muscle = {
    "BLADE",
    "BUCCANEER",
    "BUCCANEER2",
    "CHINO",
    "CHINO2",
    "CLIQUE",
    "COQUETTE3",
    "DEVIANT",
    "DOMINATOR",
    "DOMINATOR2",
    "DOMINATOR3",
    "DOMINATOR4",
    "DOMINATOR5",
    "DOMINATOR6",
    "DUKES",
    "DUKES2",
    "ELLIE",
    "FACTION",
    "FACTION2",
    "FACTION3",
    "GAUNTLET",
    "GAUNTLET2",
    "HERMES",
    "HOTKNIFE",
    "HUSTLER",
    "IMPALER",
    "IMPALER2",
    "IMPALER3",
    "IMPALER4",
    "IMPERATOR",
    "IMPERATOR2",
    "IMPERATOR3",
    "LURCHER",
    "MOONBEAM",
    "MOONBEAM2",
    "NIGHTSHADE",
    "PHOENIX",
    "PICADOR",
    "RATLOADER",
    "RATLOADER2",
    "RUINER",
    "RUINER2",
    "RUINER3",
    "SABREGT",
    "SABREGT2",
    "SLAMVAN",
    "SLAMVAN2",
    "SLAMVAN3",
    "SLAMVAN4",
    "SLAMVAN5",
    "SLAMVAN6",
    "STALION",
    "STALION2",
    "TAMPA",
    "TAMPA3",
    "TULIP",
    "VAMOS",
    "VIGERO",
    "VIRGO",
    "VIRGO2",
    "VIRGO3",
    "VOODOO",
    "VOODOO2",
    "YOSEMITE"
}

local sportsclassics = {
    "ARDENT",
    "BTYPE",
    "BTYPE2",
    "BTYPE3",
    "CASCO",
    "CHEBUREK",
    "CHEETAH2",
    "COQUETTE2",
    "DELUXO",
    "FAGALOA",
    "FELTZER3",
    "GT500",
    "INFERNUS2",
    "JB700",
    "JESTER3",
    "MAMBA",
    "MANANA",
    "MICHELLI",
    "MONROE",
    "PEYOTE",
    "PIGALLE",
    "RAPIDGT3",
    "RETINUE",
    "SAVESTRA",
    "STINGER",
    "STINGERGT",
    "STROMBERG",
    "SWINGER",
    "TORERO",
    "TORNADO",
    "TORNADO2",
    "TORNADO3",
    "TORNADO4",
    "TORNADO5",
    "TORNADO6",
    "TURISMO2",
    "VISERIS",
    "Z190",
    "ZTYPE"
}

local sports = {
    "ALPHA",
    "BANSHEE",
    "BESTIAGTS",
    "BLISTA2",
    "BLISTA3",
    "BUFFALO",
    "BUFFALO2",
    "BUFFALO3",
    "CARBONIZZARE",
    "COMET2",
    "COMET3",
    "COMET4",
    "COMET5",
    "COQUETTE",
    "ELEGY",
    "ELEGY2",
    "FELTZER2",
    "FLASHGT",
    "FUROREGT",
    "FUSILADE",
    "FUTO",
    "GB200",
    "HOTRING",
    "ITALIGTO",
    "JESTER",
    "JESTER2",
    "KHAMELION",
    "KURUMA",
    "KURUMA2",
    "LYNX",
    "MASSACRO",
    "MASSACRO2",
    "NEON",
    "NINEF",
    "NINEF2",
    "OMNIS",
    "PARIAH",
    "PENUMBRA",
    "RAIDEN",
    "RAPIDGT",
    "RAPIDGT2",
    "RAPTOR",
    "REVOLTER",
    "RUSTON",
    "SCHAFTER2",
    "SCHAFTER3",
    "SCHAFTER4",
    "SCHAFTER5",
    "SCHLAGEN",
    "SCHWARZER",
    "SENTINEL3",
    "SEVEN70",
    "SPECTER",
    "SPECTER2",
    "SULTAN",
    "SURANO",
    "TAMPA2",
    "TROPOS",
    "VERLIERER2",
    "ZR380",
    "ZR3802",
    "ZR3803"
}

local super = {
    "ADDER",
    "AUTARCH",
    "BANSHEE2",
    "BULLET",
    "CHEETAH",
    "CYCLONE",
    "DEVESTE",
    "ENTITYXF",
    "ENTITY2",
    "FMJ",
    "GP1",
    "INFERNUS",
    "ITALIGTB",
    "ITALIGTB2",
    "LE7B",
    "NERO",
    "NERO2",
    "OSIRIS",
    "PENETRATOR",
    "PFISTER811",
    "PROTOTIPO",
    "REAPER",
    "SC1",
    "SCRAMJET",
    "SHEAVA",
    "SULTANRS",
    "T20",
    "TAIPAN",
    "TEMPESTA",
    "TEZERACT",
    "TURISMOR",
    "TYRANT",
    "TYRUS",
    "VACCA",
    "VAGNER",
    "VIGILANTE",
    "VISIONE",
    "VOLTIC",
    "VOLTIC2",
    "XA21",
    "ZENTORNO"
}

local motorcycles = {
    "AKUMA",
    "AVARUS",
    "BAGGER",
    "BATI",
    "BATI2",
    "BF400",
    "CARBONRS",
    "CHIMERA",
    "CLIFFHANGER",
    "DAEMON",
    "DAEMON2",
    "DEFILER",
    "DEATHBIKE",
    "DEATHBIKE2",
    "DEATHBIKE3",
    "DIABLOUS",
    "DIABLOUS2",
    "DOUBLE",
    "ENDURO",
    "ESSKEY",
    "FAGGIO",
    "FAGGIO2",
    "FAGGIO3",
    "FCR",
    "FCR2",
    "GARGOYLE",
    "HAKUCHOU",
    "HAKUCHOU2",
    "HEXER",
    "INNOVATION",
    "LECTRO",
    "MANCHEZ",
    "NEMESIS",
    "NIGHTBLADE",
    "OPPRESSOR",
    "OPPRESSOR2",
    "PCJ",
    "RATBIKE",
    "RUFFIAN",
    "SANCHEZ",
    "SANCHEZ2",
    "SANCTUS",
    "SHOTARO",
    "SOVEREIGN",
    "THRUST",
    "VADER",
    "VINDICATOR",
    "VORTEX",
    "WOLFSBANE",
    "ZOMBIEA",
    "ZOMBIEB"
}

local offroad = {
    "BFINJECTION",
    "BIFTA",
    "BLAZER",
    "BLAZER2",
    "BLAZER3",
    "BLAZER4",
    "BLAZER5",
    "BODHI2",
    "BRAWLER",
    "BRUISER",
    "BRUISER2",
    "BRUISER3",
    "BRUTUS",
    "BRUTUS2",
    "BRUTUS3",
    "CARACARA",
    "DLOADER",
    "DUBSTA3",
    "DUNE",
    "DUNE2",
    "DUNE3",
    "DUNE4",
    "DUNE5",
    "FREECRAWLER",
    "INSURGENT",
    "INSURGENT2",
    "INSURGENT3",
    "KALAHARI",
    "KAMACHO",
    "MARSHALL",
    "MENACER",
    "MESA3",
    "MONSTER",
    "MONSTER3",
    "MONSTER4",
    "MONSTER5",
    "NIGHTSHARK",
    "RANCHERXL",
    "RANCHERXL2",
    "RCBANDITO",
    "REBEL",
    "REBEL2",
    "RIATA",
    "SANDKING",
    "SANDKING2",
    "TECHNICAL",
    "TECHNICAL2",
    "TECHNICAL3",
    "TROPHYTRUCK",
    "TROPHYTRUCK2"
}

local industrial = {
    "BULLDOZER",
    "CUTTER",
    "DUMP",
    "FLATBED",
    "GUARDIAN",
    "HANDLER",
    "MIXER",
    "MIXER2",
    "RUBBLE",
    "TIPTRUCK",
    "TIPTRUCK2"
}

local utility = {
    "AIRTUG",
    "CADDY",
    "CADDY2",
    "CADDY3",
    "DOCKTUG",
    "FORKLIFT",
    "TRACTOR2",
    "TRACTOR3",
    "MOWER",
    "RIPLEY",
    "SADLER",
    "SADLER2",
    "SCRAP",
    "TOWTRUCK",
    "TOWTRUCK2",
    "TRACTOR",
    "UTILLITRUCK",
    "UTILLITRUCK2",
    "UTILLITRUCK3",
    "ARMYTRAILER",
    "ARMYTRAILER2",
    "FREIGHTTRAILER",
    "ARMYTANKER",
    "TRAILERLARGE",
    "DOCKTRAILER",
    "TR3",
    "TR2",
    "TR4",
    "TRFLAT",
    "TRAILERS",
    "TRAILERS4",
    "TRAILERS2",
    "TRAILERS3",
    "TVTRAILER",
    "TRAILERLOGS",
    "TANKER",
    "TANKER2",
    "BALETRAILER",
    "GRAINTRAILER",
    "BOATTRAILER",
    "RAKETRAILER",
    "TRAILERSMALL"
}

local vans = {
    "BISON",
    "BISON2",
    "BISON3",
    "BOBCATXL",
    "BOXVILLE",
    "BOXVILLE2",
    "BOXVILLE3",
    "BOXVILLE4",
    "BOXVILLE5",
    "BURRITO",
    "BURRITO2",
    "BURRITO3",
    "BURRITO4",
    "BURRITO5",
    "CAMPER",
    "GBURRITO",
    "GBURRITO2",
    "JOURNEY",
    "MINIVAN",
    "MINIVAN2",
    "PARADISE",
    "PONY",
    "PONY2",
    "RUMPO",
    "RUMPO2",
    "RUMPO3",
    "SPEEDO",
    "SPEEDO2",
    "SPEEDO4",
    "SURFER",
    "SURFER2",
    "TACO",
    "YOUGA",
    "YOUGA2"
}

local cycles = {
    "BMX",
    "CRUISER",
    "FIXTER",
    "SCORCHER",
    "TRIBIKE",
    "TRIBIKE2",
    "TRIBIKE3"
}

local boats = {
    "DINGHY",
    "DINGHY2",
    "DINGHY3",
    "DINGHY4",
    "JETMAX",
    "MARQUIS",
    "PREDATOR",
    "SEASHARK",
    "SEASHARK2",
    "SEASHARK3",
    "SPEEDER",
    "SPEEDER2",
    "SQUALO",
    "SUBMERSIBLE",
    "SUBMERSIBLE2",
    "SUNTRAP",
    "TORO",
    "TORO2",
    "TROPIC",
    "TROPIC2",
    "TUG"
}

local helicopters = {
    "AKULA",
    "ANNIHILATOR",
    "BUZZARD",
    "BUZZARD2",
    "CARGOBOB",
    "CARGOBOB2",
    "CARGOBOB3",
    "CARGOBOB4",
    "FROGGER",
    "FROGGER2",
    "HAVOK",
    "HUNTER",
    "MAVERICK",
    "POLMAV",
    "SAVAGE",
    "SEASPARROW",
    "SKYLIFT",
    "SUPERVOLITO",
    "SUPERVOLITO2",
    "SWIFT",
    "SWIFT2",
    "VALKYRIE",
    "VALKYRIE2",
    "VOLATUS"
}


local planes = {
    "ALPHAZ1",
    "AVENGER",
    "AVENGER2",
    "BESRA",
    "BLIMP",
    "BLIMP2",
    "BLIMP3",
    "BOMBUSHKA",
    "CARGOPLANE",
    "CUBAN800",
    "DODO",
    "DUSTER",
    "HOWARD",
    "HYDRA",
    "JET",
    "LAZER",
    "LUXOR",
    "LUXOR2",
    "MAMMATUS",
    "MICROLIGHT",
    "MILJET",
    "MOGUL",
    "MOLOTOK",
    "NIMBUS",
    "NOKOTA",
    "PYRO",
    "ROGUE",
    "SEABREEZE",
    "SHAMAL",
    "STARLING",
    "STRIKEFORCE",
    "STUNT",
    "TITAN",
    "TULA",
    "VELUM",
    "VELUM2",
    "VESTRA",
    "VOLATOL"
}

local service = {
    "AIRBUS",
    "BRICKADE",
    "BUS",
    "COACH",
    "PBUS2",
    "RALLYTRUCK",
    "RENTALBUS",
    "TAXI",
    "TOURBUS",
    "TRASH",
    "TRASH2",
    "WASTELANDER",
    "AMBULANCE",
    "FBI",
    "FBI2",
    "FIRETRUK",
    "LGUARD",
    "PBUS",
    "POLICE",
    "POLICE2",
    "POLICE3",
    "POLICE4",
    "POLICEB",
    "POLICEOLD1",
    "POLICEOLD2",
    "POLICET",
    "POLMAV",
    "PRANGER",
    "PREDATOR",
    "RIOT",
    "RIOT2",
    "SHERIFF",
    "SHERIFF2",
    "APC",
    "BARRACKS",
    "BARRACKS2",
    "BARRACKS3",
    "BARRAGE",
    "CHERNOBOG",
    "CRUSADER",
    "HALFTRACK",
    "KHANJALI",
    "RHINO",
    "SCARAB",
    "SCARAB2",
    "SCARAB3",
    "THRUSTER",
    "TRAILERSMALL2"
}

local commercial = {
    "BENSON",
    "BIFF",
    "CERBERUS",
    "CERBERUS2",
    "CERBERUS3",
    "HAULER",
    "HAULER2",
    "MULE",
    "MULE2",
    "MULE3",
    "MULE4",
    "PACKER",
    "Lean Jr",
    "Lean Jr2",
    "Lean Jr3",
    "POUNDER",
    "POUNDER2",
    "STOCKADE",
    "STOCKADE3",
    "TERBYTE",
    "CABLECAR",
    "FREIGHT",
    "FREIGHTCAR",
    "FREIGHTCONT1",
    "FREIGHTCONT2",
    "FREIGHTGRAIN",
    "METROTRAIN",
    "TANKERCAR"
}


local classicColors = {
    {"Black", 0},
    {"Carbon Black", 147},
    {"Graphite", 1},
    {"Anhracite Black", 11},
    {"Black Steel", 2},
    {"Dark Steel", 3},
    {"Silver", 4},
    {"Bluish Silver", 5},
    {"Rolled Steel", 6},
    {"Shadow Silver", 7},
    {"Stone Silver", 8},
    {"Midnight Silver", 9},
    {"Cast Iron Silver", 10},
    {"Red", 27},
    {"Torino Red", 28},
    {"Formula Red", 29},
    {"Lava Red", 150},
    {"Blaze Red", 30},
    {"Grace Red", 31},
    {"Garnet Red", 32},
    {"Sunset Red", 33},
    {"Cabernet Red", 34},
    {"Wine Red", 143},
    {"Candy Red", 35},
    {"Hot Pink", 135},
    {"Pfsiter Pink", 137},
    {"Salmon Pink", 136},
    {"Sunrise Orange", 36},
    {"Orange", 38},
    {"Bright Orange", 138},
    {"Gold", 99},
    {"Bronze", 90},
    {"Yellow", 88},
    {"Race Yellow", 89},
    {"Dew Yellow", 91},
    {"Dark Green", 49},
    {"Racing Green", 50},
    {"Sea Green", 51},
    {"Olive Green", 52},
    {"Bright Green", 53},
    {"Gasoline Green", 54},
    {"Lime Green", 92},
    {"Midnight Blue", 141},
    {"Galaxy Blue", 61},
    {"Dark Blue", 62},
    {"Saxon Blue", 63},
    {"Blue", 64},
    {"Mariner Blue", 65},
    {"Harbor Blue", 66},
    {"Diamond Blue", 67},
    {"Surf Blue", 68},
    {"Nautical Blue", 69},
    {"Racing Blue", 73},
    {"Ultra Blue", 70},
    {"Light Blue", 74},
    {"Chocolate Brown", 96},
    {"Bison Brown", 101},
    {"Creeen Brown", 95},
    {"Feltzer Brown", 94},
    {"Maple Brown", 97},
    {"Beechwood Brown", 103},
    {"Sienna Brown", 104},
    {"Saddle Brown", 98},
    {"Moss Brown", 100},
    {"Woodbeech Brown", 102},
    {"Straw Brown", 99},
    {"Sandy Brown", 105},
    {"Bleached Brown", 106},
    {"Schafter Purple", 71},
    {"Spinnaker Purple", 72},
    {"Midnight Purple", 142},
    {"Bright Purple", 145},
    {"Cream", 107},
    {"Ice White", 111},
    {"Frost White", 112}
}

local matteColors = {
    {"Black", 12},
    {"Gray", 13},
    {"Light Gray", 14},
    {"Ice White", 131},
    {"Blue", 83},
    {"Dark Blue", 82},
    {"Midnight Blue", 84},
    {"Midnight Purple", 149},
    {"Schafter Purple", 148},
    {"Red", 39},
    {"Dark Red", 40},
    {"Orange", 41},
    {"Yellow", 42},
    {"Lime Green", 55},
    {"Green", 128},
    {"Forest Green", 151},
    {"Foliage Green", 155},
    {"Olive Darb", 152},
    {"Dark Earth", 153},
    {"Desert Tan", 154}
}

local metalColors = {
    {"Brushed Steel", 117},
    {"Brushed Black Steel", 118},
    {"Brushed Aluminum", 119},
    {"Chrome", 120},
    {"Pure Gold", 158},
    {"Brushed Gold", 159}
}


local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118,
    ["MOUSE1"] = 24
}

-- Get ESX shared object
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(c)ESX = c end)
        Citizen.Wait(1000)
    end
end)


vRP = Proxy.getInterface("vRP")



HitChance = 100, 200, 300, 400, 500,




local function ForceMod()
    ForceTog = not ForceTog
    
    if ForceTog then
        
        Citizen.CreateThread(function()
            ShowInfo("Force ~g~ENABLED ~r~\nPress E to use")
            
            local ForceKey = Keys["E"]
            local Force = 0.5
            local KeyPressed = false
            local KeyTimer = 0
            local KeyDelay = 15
            local ForceEnabled = false
            local StartPush = false
            
            function forcetick()
                
                if (KeyPressed) then
                    KeyTimer = KeyTimer + 1
                    if (KeyTimer >= KeyDelay) then
                        KeyTimer = 0
                        KeyPressed = false
                    end
                end
                
                
                
                if IsDisabledControlPressed(0, ForceKey) and not KeyPressed and not ForceEnabled then
                    KeyPressed = true
                    ForceEnabled = true
                end
                
                if (StartPush) then
                    
                    StartPush = false
                    local pid = PlayerPedId()
                    local CamRot = GetGameplayCamRot(2)
                    
                    local force = 5
                    
                    local Fx = -(math.sin(math.rad(CamRot.z)) * force * 10)
                    local Fy = (math.cos(math.rad(CamRot.z)) * force * 10)
                    local Fz = force * (CamRot.x * 0.2)
                    
                    local PlayerVeh = GetVehiclePedIsIn(pid, false)
                    
                    for k in EnumerateVehicles() do
                        SetEntityInvincible(k, false)
                        if IsEntityOnScreen(k) and k ~= PlayerVeh then
                            ApplyForceToEntity(k, 1, Fx, Fy, Fz, 0, 0, 0, true, false, true, true, true, true)
                        end
                    end
                    
                    for k in EnumeratePeds() do
                        if IsEntityOnScreen(k) and k ~= pid then
                            ApplyForceToEntity(k, 1, Fx, Fy, Fz, 0, 0, 0, true, false, true, true, true, true)
                        end
                    end
                
                end
                
                
                if IsDisabledControlPressed(0, ForceKey) and not KeyPressed and ForceEnabled then
                    KeyPressed = true
                    StartPush = true
                    ForceEnabled = false
                end
                
                if (ForceEnabled) then
                    local pid = PlayerPedId()
                    local PlayerVeh = GetVehiclePedIsIn(pid, false)
                    
                    Markerloc = GetGameplayCamCoord() + (RotationToDirection(GetGameplayCamRot(2)) * 20)
                    
                    DrawMarker(28, Markerloc, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 180, 0, 0, 35, false, true, 2, nil, nil, false)
                    
                    for k in EnumerateVehicles() do
                        SetEntityInvincible(k, true)
                        if IsEntityOnScreen(k) and (k ~= PlayerVeh) then
                            RequestControlOnce(k)
                            FreezeEntityPosition(k, false)
                            Oscillate(k, Markerloc, 0.5, 0.3)
                        end
                    end
                    
                    for k in EnumeratePeds() do
                        if IsEntityOnScreen(k) and k ~= PlayerPedId() then
                            RequestControlOnce(k)
                            SetPedToRagdoll(k, 4000, 5000, 0, true, true, true)
                            FreezeEntityPosition(k, false)
                            Oscillate(k, Markerloc, 0.5, 0.3)
                        end
                    end
                
                end
            
            end
            
            while ForceTog do forcetick()Wait(0) end
        end)
    else ShowInfo("Force ~r~Disabled") end

end

esp

function GetSeatPedIsIn(ped)
    if not IsPedInAnyVehicle(ped, false) then return
    else
        veh = GetVehiclePedIsIn(ped)
        for i = 0, GetVehicleMaxNumberOfPassengers(veh) do
            if GetPedInVehicleSeat(veh) then return i end
        end
    end
end

local function ClonePedVeh()
    local ped = GetPlayerPed(SelectedPlayer)
    local pedVeh = nil
    local PlayerPed = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        pedVeh = GetVehiclePedIsIn(ped, false)
    else
        pedVeh = GetVehiclePedIsIn(ped, true)
        if DoesEntityExist(pedVeh) then
            local vmh = GetEntityModel(pedVeh)
            local playerpos = GetEntityCoords(PlayerPed, false)
            local playerveh =
                CreateVehicle(vmh, playerpos.x, playerpos.y, playerpos.z, GetEntityHeading(PlayerPed), true, true)
            SetPedIntoVehicle(PlayerPed, playerveh, -1)
            local pcolor, scolor = nil
            GetVehicleColours(pedVeh, pcolor, scolor)
            SetVehicleColours(playerveh, pcolor, scolor)
            if IsThisModelACar(vmh) or IsThisModelABike(vhm) then
                SetVehicleModKit(playerveh, 0)
                SetVehicleWheelType(playerveh, GetVehicleWheelType(pedVeh))
                local pc, wc = nil
                SetVehicleNumberPlateTextIndex(playerveh, GetVehicleNumberPlateTextIndex(pedVeh))
                SetVehicleNumberPlateText(playerveh, GetVehicleNumberPlateText(pedVeh))
                GetVehicleExtraColours(pedVeh, pc, wc)
                SetVehicleExtraColours(playerveh, pc, wc)
            end
        end
    end
end

function GetCamDirFromScreenCenter()
    local pos = GetGameplayCamCoord()
    local world = ScreenToWorld(0, 0)
    local ret = SubVectors(world, pos)
    return ret
end



if RainbowVeh then
    local u48y34 = k(1.0)
    SetVehicleCustomPrimaryColour(GetVehiclePedIsUsing(PlayerPedId(-1)), u48y34.r, u48y34.g, u48y34.b)
    SetVehicleCustomSecondaryColour(GetVehiclePedIsUsing(PlayerPedId(-1)), u48y34.r, u48y34.g, u48y34.b)
end

if ou328hSync then
    local u48y34 = k(1.0)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsUsing(ped)
    SetVehicleNeonLightEnabled(veh, 0, true)
    SetVehicleNeonLightEnabled(veh, 0, true)
    SetVehicleNeonLightEnabled(veh, 1, true)
    SetVehicleNeonLightEnabled(veh, 2, true)
    SetVehicleNeonLightEnabled(veh, 3, true)
    SetVehicleCustomPrimaryColour(GetVehiclePedIsUsing(PlayerPedId(-1)), u48y34.r, u48y34.g, u48y34.b)
    SetVehicleCustomSecondaryColour(GetVehiclePedIsUsing(PlayerPedId(-1)), u48y34.r, u48y34.g, u48y34.b)
    SetVehicleNeonLightsColour(GetVehiclePedIsUsing(PlayerPedId(-1)), u48y34.r, u48y34.g, u48y34.b)
end


if ou328hNeon then
    local u48y34 = k(1.0)
local ped = PlayerPedId()
local veh = GetVehiclePedIsUsing(ped)
    SetVehicleNeonLightEnabled(veh, 0, true)
    SetVehicleNeonLightEnabled(veh, 0, true)
    SetVehicleNeonLightEnabled(veh, 1, true)
    SetVehicleNeonLightEnabled(veh, 2, true)
    SetVehicleNeonLightEnabled(veh, 3, true)
    SetVehicleNeonLightsColour(GetVehiclePedIsUsing(PlayerPedId(-1)), u48y34.r, u48y34.g, u48y34.b)
end



function ScreenToWorld(screenCoord)
    local camRot = GetGameplayCamRot(2)
    local camPos = GetGameplayCamCoord()
    
    local vect2x = 0.0
    local vect2y = 0.0
    local vect21y = 0.0
    local vect21x = 0.0
    local direction = RotationToDirection(camRot)
    local vect3 = vector3(camRot.x + 10.0, camRot.y + 0.0, camRot.z + 0.0)
    local vect31 = vector3(camRot.x - 10.0, camRot.y + 0.0, camRot.z + 0.0)
    local vect32 = vector3(camRot.x, camRot.y + 0.0, camRot.z + -10.0)
    
    local direction1 = RotationToDirection(vector3(camRot.x, camRot.y + 0.0, camRot.z + 10.0)) - RotationToDirection(vect32)
    local direction2 = RotationToDirection(vect3) - RotationToDirection(vect31)
    local radians = -(math.rad(camRot.y))
    
    vect33 = (direction1 * math.cos(radians)) - (direction2 * math.sin(radians))
    vect34 = (direction1 * math.sin(radians)) - (direction2 * math.cos(radians))
    
    local case1, x1, y1 = WorldToScreenRel(((camPos + (direction * 10.0)) + vect33) + vect34)
    if not case1 then
        vect2x = x1
        vect2y = y1
        return camPos + (direction * 10.0)
    end
    
    local case2, x2, y2 = WorldToScreenRel(camPos + (direction * 10.0))
    if not case2 then
        vect21x = x2
        vect21y = y2
        return camPos + (direction * 10.0)
    end
    
    if math.abs(vect2x - vect21x) < 0.001 or math.abs(vect2y - vect21y) < 0.001 then
        return camPos + (direction * 10.0)
    end
    
    local x = (screenCoord.x - vect21x) / (vect2x - vect21x)
    local y = (screenCoord.y - vect21y) / (vect2y - vect21y)
    return ((camPos + (direction * 10.0)) + (vect33 * x)) + (vect34 * y)

end

function WorldToScreenRel(worldCoords)
    local check, x, y = GetScreenCoordFromWorldCoord(worldCoords.x, worldCoords.y, worldCoords.z)
    if not check then
        return false
    end
    
    screenCoordsx = (x - 0.5) * 4.0
    screenCoordsy = (y - 0.5) * 4.0
    return true, screenCoordsx, screenCoordsy
end

function RotationToDirection(rotation)
    local retz = math.rad(rotation.z)
    local retx = math.rad(rotation.x)
    local absx = math.abs(math.cos(retx))
    return vector3(-math.sin(retz) * absx, math.cos(retz) * absx, math.sin(retx))
end

local function GetCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
    local pitch = GetGameplayCamRelativePitch()
    
    local x = -math.sin(heading * math.pi / 180.0)
    local y = math.cos(heading * math.pi / 180.0)
    local z = math.sin(pitch * math.pi / 180.0)
    
    local len = math.sqrt(x * x + y * y + z * z)
    if len ~= 0 then
        x = x / len
        y = y / len
        z = z / len
    end
    
    return x, y, z
end





local function fv()
    local cb = KeyboardInput('Enter Vehicle Spawn Name', '', 100)
    local cw = KeyboardInput('Enter Vehicle Licence Plate', '', 100)
    if cb and IsModelValid(cb) and IsModelAVehicle(cb) then
        RequestModel(cb)
        while not HasModelLoaded(cb) do
            Citizen.Wait(0)
        end
        local veh =
            CreateVehicle(
            GetHashKey(cb),
            GetEntityCoords(PlayerPedId(-1)),
            GetEntityHeading(PlayerPedId(-1)),
            true,
            true
        )
        SetVehicleNumberPlateText(veh, cw)
        local cx = ESX.Game.GetVehicleProperties(veh)
        TriggerServerEvent('esx_vehicleshop:setVehicleOwned', cx)
        av('~g~~h~Success', false)
    else
        av('~b~~h~Model is not valid!', true)
    end
end




function ApplyForce(entity, direction)
    ApplyForceToEntity(entity, 3, direction, 0, 0, 0, false, false, true, true, false, true)
end

function RequestControlOnce(entity)
    if not NetworkIsInSession or NetworkHasControlOfEntity(entity) then
        return true
    end
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(entity), true)
    return NetworkRequestControlOfEntity(entity)
end

function RequestControl(entity)
    Citizen.CreateThread(function()
        local tick = 0
        while not RequestControlOnce(entity) and tick <= 12 do
            tick = tick + 1
            Wait(0)
        end
        return tick <= 12
    end)
end

function Oscillate(entity, position, angleFreq, dampRatio)
    local pos1 = ScaleVector(SubVectors(position, GetEntityCoords(entity)), (angleFreq * angleFreq))
    local pos2 = AddVectors(ScaleVector(GetEntityVelocity(entity), (4.0 * angleFreq * dampRatio)), vector3(0.0, 0.0, 0.1))
    local targetPos = SubVectors(pos1, pos2)
    
    ApplyForce(entity, targetPos)
end


function ShowMPMessage(message, subtitle, ms)
    Citizen.CreateThread(function()
        Citizen.Wait(0)
        function Initialize(scaleform)
            local scaleform = RequestScaleformMovie(scaleform)
            while not HasScaleformMovieLoaded(scaleform) do
                Citizen.Wait(0)
            end
            PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
            PushScaleformMovieFunctionParameterString(message)
            PushScaleformMovieFunctionParameterString(subtitle)
            PopScaleformMovieFunctionVoid()
            Citizen.SetTimeout(6500, function()
                PushScaleformMovieFunction(scaleform, "SHARD_ANIM_OUT")
                PushScaleformMovieFunctionParameterInt(1)
                PushScaleformMovieFunctionParameterFloat(0.33)
                PopScaleformMovieFunctionVoid()
                Citizen.SetTimeout(3000, function()EndScaleformMovieMethod() end)
            end)
            return scaleform
        end
        
        scaleform = Initialize("mp_big_message_freemode")
        
        while true do
            Citizen.Wait(0)
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 150, 0)
        end
    end)
end

function ShowInfo(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, false)
end

function DrawTxt(text, x, y, scale, size)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(scale, size)
    SetTextDropshadow(1, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)
    
    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    
    if onScreen then
        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

-- END DRAWING FUNCTIONS
-- UTILITY FUNCTIONS
local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}

local function GetHeadItems()
    local headItems = GetNumberOfPedDrawableVariations(PlayerPedId(), 0)
    local faceItemsList = {}
    for i = 1, headItems do
        faceItemsList[i] = i
    end
	return faceItemsList
end

local function RwFbMFt4el(player)
    local ped = GetPlayerPed(player)
    local tLoc = GetEntityCoords(ped)

    local destination = GetPedBoneCoords(ped, 0, 0.0, 0.0, 0.0)
    local origin = GetPedBoneCoords(ped, 57005, 0.0, 0.0, 0.2)



    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
end


local function TazePlayer15x(player)
    local ped = GetPlayerPed(player)
    local tLoc = GetEntityCoords(ped)

    local destination = GetPedBoneCoords(ped, 0, 0.0, 0.0, 0.0)
    local origin = GetPedBoneCoords(ped, 57005, 0.0, 0.0, 0.2)



    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
end




local function ShootPlayer(player)
    local ped = GetPlayerPed(player)
    local tLoc = GetEntityCoords(ped)

    local destination = GetPedBoneCoords(ped, 0, 0.0, 0.0, 0.0)
    local origin = GetPedBoneCoords(ped, 4.0, 0.0, 0.0, 4.0)


    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_PUMPSHOTGUN`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_REVOLVER_MK2`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_PUMPSHOTGUN`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_REVOLVER_MK2`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_PUMPSHOTGUN`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_REVOLVER_MK2`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_PUMPSHOTGUN`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_REVOLVER_MK2`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_PUMPSHOTGUN`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_REVOLVER_MK2`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_PUMPSHOTGUN`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_REVOLVER_MK2`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_PUMPSHOTGUN`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_REVOLVER_MK2`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_PUMPSHOTGUN`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_REVOLVER_MK2`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_PUMPSHOTGUN`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_REVOLVER_MK2`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_PUMPSHOTGUN`, PlayerPedId(), true, false, 999.0)
end



local function ShootPlayer2(player)
    local ped = GetPlayerPed(player)
    local tLoc = GetEntityCoords(ped)

    local destination = GetPedBoneCoords(ped, 0, 0.0, 0.0, 0.0)
    local origin = GetPedBoneCoords(ped, 4.0, 0.0, 0.0, 4.0)


    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
end

local function GetHeadTextures(faceID)
    local headTextures = GetNumberOfPedTextureVariations(PlayerPedId(), 0, faceID)
	local headTexturesList = {}
    for i = 1, headTextures do
        headTexturesList[i] = i
    end
	return headTexturesList
end

local function GetHairItems()
    local hairItems = GetNumberOfPedDrawableVariations(PlayerPedId(), 2)
    local hairItemsList = {}
    for i = 1, hairItems do
        hairItemsList[i] = i
    end
    return hairItemsList
end

local function GetHairTextures(hairID)
    local hairTexture = GetNumberOfPedTextureVariations(PlayerPedId(), 2, hairID)
    local hairTextureList = {}
    for i = 1, hairTexture do
        hairTextureList[i] = i
    end
    return hairTextureList
end

local function GetMaskItems()
    local maskItems = GetNumberOfPedDrawableVariations(PlayerPedId(), 1)
    local maskItemsList = {}
    for i = 1, maskItems do
        maskItemsList[i] = i
    end
	return maskItemsList
end

local function GetHatItems()
    local hatItems = GetNumberOfPedPropDrawableVariations(PlayerPedId(), 0)
    local hatItemsList = {}
    for i = 1, hatItems do
        hatItemsList[i] = i
    end
	return hatItemsList
end

local function GetHatTextures(hatID)
	local hatTextures = GetNumberOfPedPropTextureVariations(PlayerPedId(), 0, hatID)
	local hatTexturesList = {}
	for i = 1, hatTextures do
        hatTexturesList[i] = i
    end
	return hatTexturesList
end

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
        
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
        
        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next
        
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end












local RCCar = {}

-- Lean Jr6969

RCCar.Start = function()
	if DoesEntityExist(RCCar.Entity) then return end

	RCCar.Spawn()

	RCCar.Tablet(true)

	while DoesEntityExist(RCCar.Entity) and DoesEntityExist(RCCar.Driver) do
		Citizen.Wait(5)

		local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),  GetEntityCoords(RCCar.Entity), true)

		RCCar.DrawInstructions(distanceCheck)
		RCCar.HandleKeys(distanceCheck)

		if distanceCheck <= 10000000.0 then
			if not NetworkHasControlOfEntity(RCCar.Driver) then
				NetworkRequestControlOfEntity(RCCar.Driver)
			elseif not NetworkHasControlOfEntity(RCCar.Entity) then
				NetworkRequestControlOfEntity(RCCar.Entity)
			end
		else
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 6, 2500)
		end
	end
end

RCCar.HandleKeys = function(distanceCheck)
	if IsControlJustReleased(0, 47) then
		if IsCamRendering(RCCar.Camera) then
			RCCar.ToggleCamera(false)
		else
			RCCar.ToggleCamera(true)
		end
	end

	if distanceCheck <= 10000000.0 then
		if IsControlJustPressed(0, 73) then
			RCCar.Attach("pick")
		end
	end

	if distanceCheck < 10000000.0 then
	    if IsControlJustReleased(0, 108) then
		    local coos = GetEntityCoords(RCCar.Entity, true)
            AddExplosion(coos.x, coos.y, coos.z, 2, 100000.0, true, false, 0)
		end
		if IsControlPressed(0, 172) and not IsControlPressed(0, 173) then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 9, 1)
		end
		
		if IsControlJustReleased(0, 172) or IsControlJustReleased(0, 173) then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 6, 2500)
		end

		if IsControlPressed(0, 173) and not IsControlPressed(0, 172) then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 22, 1)
		end

		if IsControlPressed(0, 174) and IsControlPressed(0, 173) then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 13, 1)
		end

		if IsControlPressed(0, 175) and IsControlPressed(0, 173) then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 14, 1)
		end

		if IsControlPressed(0, 172) and IsControlPressed(0, 173) then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 30, 100)
		end

		if IsControlPressed(0, 174) and IsControlPressed(0, 172) then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 7, 1)
		end

		if IsControlPressed(0, 175) and IsControlPressed(0, 172) then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 8, 1)
		end

		if IsControlPressed(0, 174) and not IsControlPressed(0, 172) and not IsControlPressed(0, 173) then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 4, 1)
		end

		if IsControlPressed(0, 175) and not IsControlPressed(0, 172) and not IsControlPressed(0, 173) then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 5, 1)
		end
	end
end

RCCar.DrawInstructions = function(distanceCheck)
	local steeringButtons = {
		{
			["label"] = "Right",
			["button"] = "~INPUT_CELLPHONE_RIGHT~"
		},
		{
			["label"] = "Forward",
			["button"] = "~INPUT_CELLPHONE_UP~"
		},
		{
			["label"] = "Reverse",
			["button"] = "~INPUT_CELLPHONE_DOWN~"
		},
		{
			["label"] = "Left",
			["button"] = "~INPUT_CELLPHONE_LEFT~"
		}
	}

	local pickupButton = {
		["label"] = "Delete",
		["button"] = "~INPUT_VEH_DUCK~"
	}
	
	local explodeButton = {
		["label"] = "Explode",
		["button"] = "~INPUT_VEH_FLY_ROLL_LEFT_ONLY~"
	}

	local buttonsToDraw = {
		{
			["label"] = "Toggle Camera",
			["button"] = "~INPUT_DETONATE~"
		}
	}

	if distanceCheck <= 10000000.0 then
		for buttonIndex = 1, #steeringButtons do
			local steeringButton = steeringButtons[buttonIndex]

			table.insert(buttonsToDraw, steeringButton)
		end

		if distanceCheck <= 1000000.0 then
			table.insert(buttonsToDraw, explodeButton)
		end
		
		if distanceCheck <= 1000000.0 then
			table.insert(buttonsToDraw, pickupButton)
		end
	end

    Citizen.CreateThread(function()
        local instructionScaleform = RequestScaleformMovie("instructional_buttons")

        while not HasScaleformMovieLoaded(instructionScaleform) do
            Wait(0)
        end

        PushScaleformMovieFunction(instructionScaleform, "CLEAR_ALL")
        PushScaleformMovieFunction(instructionScaleform, "TOGGLE_MOUSE_BUTTONS")
        PushScaleformMovieFunctionParameterBool(0)
        PopScaleformMovieFunctionVoid()

        for buttonIndex, buttonValues in ipairs(buttonsToDraw) do
            PushScaleformMovieFunction(instructionScaleform, "SET_DATA_SLOT")
            PushScaleformMovieFunctionParameterInt(buttonIndex - 1)

            PushScaleformMovieMethodParameterButtonName(buttonValues["button"])
            PushScaleformMovieFunctionParameterString(buttonValues["label"])
            PopScaleformMovieFunctionVoid()
        end

        PushScaleformMovieFunction(instructionScaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
        PushScaleformMovieFunctionParameterInt(-1)
        PopScaleformMovieFunctionVoid()
        DrawScaleformMovieFullscreen(instructionScaleform, 255, 255, 255, 255)
    end)
end

-- 4x482

RCCar.Spawn = function()
	RCCar.LoadModels({ GetHashKey(RCCAR123), 68070371 })

	local spawnCoords, spawnHeading = GetEntityCoords(PlayerPedId()) + GetEntityForwardVector(PlayerPedId()) * 4.0, GetEntityHeading(PlayerPedId())

	RCCar.Entity = CreateVehicle(GetHashKey(RCCAR123), spawnCoords, spawnHeading, true)

	while not DoesEntityExist(RCCar.Entity) do
		Citizen.Wait(5)
	end

	RCCar.Driver = CreatePed(5, 68070371, spawnCoords, spawnHeading, true)

	SetEntityInvincible(RCCar.Driver, true)
	SetEntityVisible(RCCar.Driver, false)
	FreezeEntityPosition(RCCar.Driver, true)
	SetPedAlertness(RCCar.Driver, 0.0)
    SetVehicleNumberPlateText(RCCar.Entity, "womanbeater#8529")
	TaskWarpPedIntoVehicle(RCCar.Driver, RCCar.Entity, -1)
   

	while not IsPedInVehicle(RCCar.Driver, RCCar.Entity) do
		Citizen.Wait(0)
	end

	RCCar.Attach("place")
end

RCCar.Attach = function(param)
	if not DoesEntityExist(RCCar.Entity) then
		return
	end
	
	RCCar.LoadModels({ "pickup_object" })

	if param == "place" then

		PlaceObjectOnGroundProperly(RCCar.Entity)
	elseif param == "pick" then
		if DoesCamExist(RCCar.Camera) then
			RCCar.ToggleCamera(false)
		end

		RCCar.Tablet(false)

		DeleteVehicle(RCCar.Entity)
		DeleteEntity(RCCar.Driver)

		RCCar.UnloadModels()
	end
end

RCCar.Tablet = function(boolean)
	if boolean then



	
		Citizen.CreateThread(function()
			while DoesEntityExist(RCCar.TabletEntity) do
				Citizen.Wait(5)
	

			end

			ClearPedTasks(PlayerPedId())
		end)
	else
		DeleteEntity(RCCar.TabletEntity)
	end
end

ConfigCamera = true

RCCar.ToggleCamera = function(boolean)
	if not ConfigCamera then return end

	if boolean then
		if not DoesEntityExist(RCCar.Entity) then return end 
		if DoesCamExist(RCCar.Camera) then DestroyCam(RCCar.Camera) end

		RCCar.Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

		AttachCamToEntity(RCCar.Camera, RCCar.Entity, 0.0, 0.0, 0.4, true)

		Citizen.CreateThread(function()
			while DoesCamExist(RCCar.Camera) do
				Citizen.Wait(5)

				SetCamRot(RCCar.Camera, GetEntityRotation(RCCar.Entity))
			end
		end)

		local easeTime = 500 * math.ceil(GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(RCCar.Entity), true) / 10)

		RenderScriptCams(1, 1, easeTime, 1, 1)

		Citizen.Wait(easeTime)

	else
		local easeTime = 500 * math.ceil(GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(RCCar.Entity), true) / 10)

		RenderScriptCams(0, 1, easeTime, 1, 0)

		Citizen.Wait(easeTime)

		ClearTimecycleModifier()

		DestroyCam(RCCar.Camera)
	end
end

RCCar.LoadModels = function(models)
	for modelIndex = 1, #models do
		local model = models[modelIndex]

		if not RCCar.CachedModels then
			RCCar.CachedModels = {}
		end

		table.insert(RCCar.CachedModels, model)

		if IsModelValid(model) then
			while not HasModelLoaded(model) do
				RequestModel(model)
	
				Citizen.Wait(10)
			end
		else
			while not HasAnimDictLoaded(model) do
				RequestAnimDict(model)
	
				Citizen.Wait(10)
			end    
		end
	end
end

RCCar.UnloadModels = function()
	for modelIndex = 1, #RCCar.CachedModels do
		local model = RCCar.CachedModels[modelIndex]

		if IsModelValid(model) then
			SetModelAsNoLongerNeeded(model)
		else
			RemoveAnimDict(model)   
		end
	end
end









function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
    return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function table.removekey(array, element)
    for i = 1, #array do
        if array[i] == element then
            table.remove(array, i)
        end
    end
end

function AddVectors(vect1, vect2)
    return vector3(vect1.x + vect2.x, vect1.y + vect2.y, vect1.z + vect2.z)
end

function SubVectors(vect1, vect2)
    return vector3(vect1.x - vect2.x, vect1.y - vect2.y, vect1.z - vect2.z)
end

function ScaleVector(vect, mult)
    return vector3(vect.x * mult, vect.y * mult, vect.z * mult)
end

function round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function GetKeyboardInput(text)
	if not text then text = "Input" end
    DisplayOnscreenKeyboard(0, "", "", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
		DrawTxt(text, 0.32, 0.37, 0.0, 0.4)
        DisableAllControlActions(0)

        if IsDisabledControlPressed(0, Keys["ESC"]) then return "" end
        Wait(0)
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        Wait(0)
        return result
    end
end
local function RequestModelSync_SDUFHSIDGSDG(model_DSIGHODSIGSD, timeout_DSIUFHISDGSDG) timeout_DSIUFHISDGSDG = timeout_DSIUFHISDGSDG or 2500 local counter_DSGIHSDIUGJDSGDS = 0 Citizen.InvokeActive(0x963D27A58DF860AC, Citizen.InvokeActive(0xD24D37CC275948CC, model_DSIGHODSIGSD)) while not Citizen.InvokeActive(0x98A4EB5D89A0C952, Citizen.InvokeActive(0xD24D37CC275948CC, model_DSIGHODSIGSD)) do Citizen.InvokeActive(0x963D27A58DF860AC, model_DSIGHODSIGSD) counter_DSGIHSDIUGJDSGDS = counter_DSGIHSDIUGJDSGDS + 100 Wait(0) if counter_DSGIHSDIUGJDSGDS >= timeout_DSIUFHISDGSDG then return false end end return true end


function SpectatePlayer(id)
    local player = GetPlayerPed(id)
    if Spectating then
        RequestCollisionAtCoord(GetEntityCoords(player))
        NetworkSetInSpectatorMode(true, player)
    else
        RequestCollisionAtCoord(GetEntityCoords(player))
        NetworkSetInSpectatorMode(false, player)
    end
end


local function PossessVehicle(target)
    PossessingVeh = not PossessingVeh
    
    if not PossessingVeh then
        SetEntityVisible(PlayerPedId(), true, 0)
        SetEntityCoords(PlayerPedId(), oldPlayerPos)
        SetEntityCollision(PlayerPedId(), true, 1)
    else
        SpectatePlayer(selectedPlayer)
        ShowInfo("~b~Checking Player...")
        Wait(3000)
        if IsPedInAnyVehicle(GetPlayerPed(selectedPlayer), 0) then
            SpectatePlayer(selectedPlayer)
            oldPlayerPos = GetEntityCoords(PlayerPedId())
            SetEntityVisible(PlayerPedId(), false, 0)
            SetEntityCollision(PlayerPedId(), false, 0)
        else
            SpectatePlayer(selectedPlayer)
            PossessingVeh = false
            ShowInfo("~r~Player not in a vehicle!  (Try again?)")
        end
        
        
        local Markerloc = nil


        Citizen.CreateThread(function()
            local ped = GetPlayerPed(target)
            local veh = GetVehiclePedIsIn(ped, 0)
            
            while PossessingVeh do
                
                DrawTxt("~b~Possessing ~w~" .. GetPlayerName(target) .. "'s ~b~Vehicle", 0.1, 0.05, 0.0, 0.4)
                DrawTxt("~b~Controls:\n~w~-------------------", 0.1, 0.2, 0.0, 0.4)
                DrawTxt("~b~W/S: ~w~Forward/Back\n~b~SPACEBAR: ~w~Up\n~b~CTRL: ~w~Down\n~b~X: ~w~Cancel", 0.1, 0.25, 0.0, 0.4)
                Markerloc = GetGameplayCamCoord() + (RotationToDirection(GetGameplayCamRot(2)) * 20)
                DrawMarker(28, Markerloc, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 0, 0, 180, 35, false, true, 2, nil, nil, false)
                
                local forward = SubVectors(Markerloc, GetEntityCoords(veh))
                local vpos = GetEntityCoords(veh)
                local vf = GetEntityForwardVector(veh)
                local vrel = SubVectors(vpos, vf)
                
                SetEntityCoords(PlayerPedId(), vrel.x, vrel.y, vpos.z + 1.1)
                SetEntityNoCollisionEntity(PlayerPedId(), veh, 1)
                
                RequestControlOnce(veh)
                
                if IsDisabledControlPressed(0, Keys["W"]) then
                    ApplyForce(veh, forward * 0.1)
                end
                
                if IsDisabledControlPressed(0, Keys["S"]) then
                    ApplyForce(veh, -(forward * 0.1))
                end
                
                if IsDisabledControlPressed(0, Keys["SPACE"]) then
                    ApplyForceToEntity(veh, 3, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
                end
                
                if IsDisabledControlPressed(0, Keys["LEFTCTRL"]) then
                    ApplyForceToEntity(veh, 3, 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
                end
                
                if IsDisabledControlPressed(0, Keys["X"]) or GetEntityHealth(PlayerPedId()) < 5.0 then
                    PossessingVeh = false
                    SetEntityVisible(PlayerPedId(), true, 0)
                    SetEntityCoords(PlayerPedId(), oldPlayerPos)
                    SetEntityCollision(PlayerPedId(), true, 1)
                end
                
                Wait(0)
            end
        end)
    end
end

function GetWeaponNameFromHash(hash)
    for i = 1, #allweapons do
        if GetHashKey(allweapons[i]) == hash then
            return string.sub(allweapons[i], 8)
        end
    end
end

local function FixVeh(veh)
    SetVehicleEngineHealth(veh, 1000)
    SetVehicleFixed(veh)
end

local function ExplodePlayer(target)
    local ped = GetPlayerPed(target)
    local coords = GetEntityCoords(ped)
    AddExplosion(coords.x + 1, coords.y + 1, coords.z + 1, 4, 100.0, true, false, 0.0)
end


    local function hejhej(target)
        local ped = GetPlayerPed(target)
        local coords = GetEntityCoords(ped)
        AddExplosion(coords.x + 1, coords.y + 1, coords.z + 1, 4, 100.0, true, false, 0.0)
        local function hejhej(target)
            local ped = GetPlayerPed(target)
            local coords = GetEntityCoords(ped)
            AddExplosion(coords.x + 1, coords.y + 1, coords.z + 1, 4, 100.0, true, false, 0.0)
            local function hejhej(target)
                local ped = GetPlayerPed(target)
                local coords = GetEntityCoords(ped)
                AddExplosion(coords.x + 1, coords.y + 1, coords.z + 1, 4, 100.0, true, false, 0.0)
            end    
        end 
    end
    function RapeAllFunc()
        Citizen.CreateThread(function()
            for i=0,128 do
                RequestModel("a_m_o_acult_01")
                RequestAnimDict("rcmpaparazzo_2")
                while not HasAnimDictLoaded("rcmpaparazzo_2")do
                    Citizen.Wait(0)
                end
                if IsPedInAnyVehicle(GetPlayerPed(i),true)then
                    local veh=GetVehiclePedIsIn(GetPlayerPed(i),true)
                    while not NetworkHasControlOfEntity(veh)do
                        NetworkRequestControlOfEntity(veh)
                        Citizen.Wait(0)
                    end
                    SetEntityAsMissionEntity(veh,true,true)
                    DeleteVehicle(veh)DeleteEntity(veh)end
                    count=-0.2
                    for b=1,3 do
                        local x,y,z=table.unpack(GetEntityCoords(GetPlayerPed(i),true))
                        local bD=CreatePed(4,GetHashKey("a_m_o_acult_01"),x,y,z,0.0,true,false)
                        SetEntityAsMissionEntity(bD,true,true)
                        AttachEntityToEntity(bD,GetPlayerPed(i),4103,11816,count,0.00,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
                        ClearPedTasks(GetPlayerPed(i))TaskPlayAnim(GetPlayerPed(i),"rcmpaparazzo_2","shag_loop_poppy",2.0,2.5,-1,49,0,0,0,0)
                        SetPedKeepTask(bD)TaskPlayAnim(bD,"rcmpaparazzo_2","shag_loop_a",2.0,2.5,-1,49,0,0,0,0)
                        SetEntityInvincible(bD,true)count=count-0.4
                end
            end
        end)
    end      

local function ExplodeAll(self)
    local plist = GetActivePlayers()
    for i = 0, #plist do
        if not self and i == PlayerId() then i = i + 1 end
        ExplodePlayer(i)
    end
end


local function PedAttack(target, attackType)
    local coords = GetEntityCoords(GetPlayerPed(target))
    
    if attackType == 1 then weparray = allweapons
    elseif attackType == 2 then weparray = meleeweapons
    elseif attackType == 3 then weparray = pistolweapons
    elseif attackType == 4 then weparray = heavyweapons
    end
    
    for k in EnumeratePeds() do
        if k ~= GetPlayerPed(target) and not IsPedAPlayer(k) and GetDistanceBetweenCoords(coords, GetEntityCoords(k)) < 2000 then
            local rand = math.ceil(math.random(#weparray))
            if weparray ~= allweapons then GiveWeaponToPed(k, GetHashKey(weparray[rand][1]), 9999, 0, 1)
            else GiveWeaponToPed(k, GetHashKey(weparray[rand]), 9999, 0, 1) end
            ClearPedTasks(k)
            TaskCombatPed(k, GetPlayerPed(target), 0, 16)
            SetPedCombatAbility(k, 100)
            SetPedCombatRange(k, 2)
            SetPedCombatAttributes(k, 46, 1)
            SetPedCombatAttributes(k, 5, 1)
        end
    end
end


function ApplyShockwave(entity)
    local pos = GetEntityCoords(PlayerPedId())
    local coord = GetEntityCoords(entity)
    local dx = coord.x - pos.x
    local dy = coord.y - pos.y
    local dz = coord.z - pos.z
    local distance = math.sqrt(dx * dx + dy * dy + dz * dz)
    local distanceRate = (50 / distance) * math.pow(1.04, 1 - distance)
    ApplyForceToEntity(entity, 1, distanceRate * dx, distanceRate * dy, distanceRate * dz, math.random() * math.random(-1, 1), math.random() * math.random(-1, 1), math.random() * math.random(-1, 1), true, false, true, true, true, true)
end

local function DoForceFieldTick(radius)
    local player = PlayerPedId()
    local coords = GetEntityCoords(PlayerPedId())
    local playerVehicle = GetPlayersLastVehicle()
    local inVehicle = IsPedInVehicle(player, playerVehicle, true)
    
    DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, radius, radius, radius, 180, 80, 0, 35, false, true, 2, nil, nil, false)
    
    for k in EnumerateVehicles() do
        if (not inVehicle or k ~= playerVehicle) and GetDistanceBetweenCoords(coords, GetEntityCoords(k)) <= radius * 1.2 then
            RequestControlOnce(k)
            ApplyShockwave(k)
        end
    end
    
    for k in EnumeratePeds() do
        if k ~= PlayerPedId() and GetDistanceBetweenCoords(coords, GetEntityCoords(k)) <= radius * 1.2 then
            RequestControlOnce(k)
            SetPedRagdollOnCollision(k, true)
            SetPedRagdollForceFall(k)
            ApplyShockwave(k)
        end
    end
end

local function DoRapidFireTick()
    DisablePlayerFiring(PlayerPedId(), true)
    if IsDisabledControlPressed(0, Keys["MOUSE1"]) then
        local _, weapon = GetCurrentPedWeapon(PlayerPedId())
        local wepent = GetCurrentPedWeaponEntityIndex(PlayerPedId())
        local camDir = GetCamDirFromScreenCenter()
        local camPos = GetGameplayCamCoord()
        local launchPos = GetEntityCoords(wepent)
        local targetPos = camPos + (camDir * 200.0)
        
        ClearAreaOfProjectiles(launchPos, 0.0, 1)
        
        ShootSingleBulletBetweenCoords(launchPos, targetPos, 5, 1, weapon, PlayerPedId(), true, true, 24000.0)
        ShootSingleBulletBetweenCoords(launchPos, targetPos, 5, 1, weapon, PlayerPedId(), true, true, 24000.0)
    end
end
Citizen.CreateThread(function()
	while menuyes do
	Wait(0)
	if rage_bot_toogle_ifdsygdiufgsdfg then
		
		local plist_iduygusdigsdfg = GetActivePlayers()
		for i_didsfyg98sduriesdfg = 1, #plist_iduygusdigsdfg do
			rage_bot_UGDUYFHDSIGKHUIDFGDFG(Citizen.InvokeActive(0x43A66C31C68491C0, plist_iduygusdigsdfg[i_didsfyg98sduriesdfg]))
		end
	
	end
end

local function StripPlayer(target)
    local ped = GetPlayerPed(target)
    RemoveAllPedWeapons(ped, arwet)
end

local function StripAll(self)
    local plist = GetActivePlayers()
    for i = 0, #plist do
        if not self and i == PlayerId() then i = i + 1 end
        StripPlayer(i)
    end
end

local function KickFromVeh(target)
    local ped = GetPlayerPed(target)
    if IsPedInAnyVehicle(ped, false) then
        ClearPedTasksImmediately(ped)
    end
end

local function KickAllFromVeh(self)
    local plist = GetActivePlayers()
    for i = 0, #plist do
        if not self and i == PlayerId() then i = i + 1 end
        KickFromVeh(i)
    end
end

local function CancelAnimsAll(self)
    local plist = GetActivePlayers()
    for i = 0, #plist do
        if not self and i == PlayerId() then i = i + 1 end
        ClearPedTasksImmediately(GetPlayerPed(plist[i]))
    end
end

local function RandomClothes(target)
    local ped = GetPlayerPed(target)
    SetPedRandomComponentVariation(ped, false)
    SetPedRandomProps(ped)
end

local function GiveAllWeapons(target)
    local ped = GetPlayerPed(target)
    for i = 0, #allweapons do
        GiveWeaponToPed(ped, GetHashKey(allweapons[i]), 9999, false, false)
    end
end

local function GiveAllPlayersWeapons(self)
    local plist = GetActivePlayers()
    for i = 0, #plist do
        if not self and i == PlayerId() then i = i + 1 end
        GiveAllWeapons(i)
    end
end

local function GiveWeapon(target, weapon)
    local ped = GetPlayerPed(target)
    GiveWeaponToPed(ped, GetHashKey(weapon), 9999, false, false)
end

local function GiveMaxAmmo(target)
    local ped = GetPlayerPed(target)
    for i = 1, #allweapons do
        AddAmmoToPed(ped, GetHashKey(allweapons[i]), 9999)
    end
end

local function TeleportToPlayer(target)
    local ped = GetPlayerPed(target)
    local pos = GetEntityCoords(ped)
    SetEntityCoords(PlayerPedId(), pos)
end

local function TeleportToWaypoint()
    local entity = PlayerPedId()
    if IsPedInAnyVehicle(entity, false) then
        entity = GetVehiclePedIsUsing(entity)
    end
    local success = false
    local blipFound = false
    local blipIterator = GetBlipInfoIdIterator()
    local blip = GetFirstBlipInfoId(8)
    
    while DoesBlipExist(blip) do
        if GetBlipInfoIdType(blip) == 4 then
            cx, cy, cz = table.unpack(Citizen.InvokeActive(0xFA7C7F0AADF25D09, blip, Citizen.ReturnResultAnyway(), Citizen.ResultAsVector()))
            blipFound = true
            break
        end
        blip = GetNextBlipInfoId(blipIterator)
        Wait(0)
    end
    
    if blipFound then
        local groundFound = false
        local yaw = GetEntityHeading(entity)
        
        for i = 0, 1000, 1 do
            SetEntityCoordsNoOffset(entity, cx, cy, ToFloat(i), false, false, false)
            SetEntityRotation(entity, 0, 0, 0, 0, 0)
            SetEntityHeading(entity, yaw)
            SetGameplayCamRelativeHeading(0)
            Wait(0)
            if GetGroundZFor_3dCoord(cx, cy, ToFloat(i), cz, false) then
                cz = ToFloat(i)
                groundFound = true
                break
            end
        end
        if not groundFound then
            cz = -300.0
        end
        success = true
    else
        ShowInfo('~r~Blip not found')
    end
    
    if success then
        SetEntityCoordsNoOffset(entity, cx, cy, cz, false, false, true)
        SetGameplayCamRelativeHeading(0)
        if IsPedSittingInAnyVehicle(PlayerPedId()) then
            if GetPedInVehicleSeat(GetVehiclePedIsUsing(PlayerPedId()), -1) == PlayerPedId() then
                SetVehicleOnGroundProperly(GetVehiclePedIsUsing(PlayerPedId()))
            end
        end
    end

end

local function ToggleGodmode(tog)
    local ped = PlayerPedId()
    SetEntityProofs(ped, tog, tog, tog, tog, tog)
    SetPedCanRagdoll(ped, not tog)
end

local function ToggleNoclip()
    Noclipping = not Noclipping
    if Noclipping then
        SetEntityVisible(PlayerPedId(), false, false)
    else
        SetEntityRotation(GetVehiclePedIsIn(PlayerPedId(), 0), GetGameplayCamRot(2), 2, 1)
        SetEntityVisible(GetVehiclePedIsIn(PlayerPedId(), 0), true, false)
        SetEntityVisible(PlayerPedId(), true, false)
    end
end

local function ToggleESP()
    ESPEnabled = not ESPEnabled
	local _,x,y = false, 0.0, 0.0
	
	Citizen.CreateThread(function()
		while ESPEnabled do
            local plist = GetActivePlayers()
            table.removekey(plist, PlayerId())
            for i = 1, #plist do
				local targetCoords = GetEntityCoords(GetPlayerPed(plist[i]))
				_, x, y = GetScreenCoordFromWorldCoord(targetCoords.x, targetCoords.y, targetCoords.z)
			end
			Wait(ESPRefreshTime)
		end
	end)
	LinesEnabled
    Citizen.CreateThread(function()
        while ESPEnabled do
            local plist = GetActivePlayers()
            table.removekey(plist, PlayerId())
            for i = 1, #plist do
                local targetCoords = GetEntityCoords(GetPlayerPed(plist[i]))
                local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), targetCoords)
                if distance <= EspDistance then
                    local _, wephash = GetCurrentPedWeapon(GetPlayerPed(plist[i]), 1)
                    local wepname = GetWeaponNameFromHash(wephash)
                    local vehname = "On Foot"
                    if IsPedInAnyVehicle(GetPlayerPed(plist[i]), 0) then
                        vehname = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(plist[i])))))
                    end
                    if wepname == nil then wepname = "Unknown" end
                    DrawRect(x, y, 0.008, 0.01, 0, 0, 255, 255)
                    DrawRect(x, y, 0.003, 0.005, 255, 0, 0, 255)
                    local espstring1 = "~b~ID: ~w~" .. GetPlayerServerId(plist[i]) .. "~w~  |  ~b~Name: ~w~" .. GetPlayerName(plist[i]) .. "  |  ~b~Distance: ~w~" .. math.floor(distance)
                    local espstring2 = "~b~Weapon: ~w~" .. wepname .. "  |  ~b~Vehicle: ~w~" .. vehname
                    DrawTxt(espstring1, x - 0.05, y - 0.04, 0.0, 0.2)
                    DrawTxt(espstring2, x - 0.05, y - 0.03, 0.0, 0.2)
                end
            end
            Wait(0)
        end
    end)
end

LINE
function ToggleBlips()
    BlipsEnabled = not BlipsEnabled
    
    if not BlipsEnabled then
        for i = 1, #pblips do
            RemoveBlip(pblips[i])
        end
    else
        
        Citizen.CreateThread(function()
            pblips = {}
            while BlipsEnabled do
                local plist = GetActivePlayers()
                table.removekey(plist, PlayerId())
                for i = 1, #plist do
                    if NetworkIsPlayerActive(plist[i]) then
                        ped = GetPlayerPed(plist[i])
                        pblips[i] = GetBlipFromEntity(ped)
                        if not DoesBlipExist(pblips[i]) then
                            pblips[i] = AddBlipForEntity(ped)
                            SetBlipSprite(pblips[i], 1)
                            Citizen.InvokeActive(0x5FBCA48327B914DF, pblips[i], true)
                        else
                            veh = GetVehiclePedIsIn(ped, false)
                            blipSprite = GetBlipSprite(pblips[i])
                            if not GetEntityHealth(ped) then -- dead
                                if blipSprite ~= 274 then
                                    SetBlipSprite(pblips[i], 274)
                                    Citizen.InvokeActive(0x5FBCA48327B914DF, pblips[i], false)
                                end
                            elseif veh then
                                vehClass = GetVehicleClass(veh)
                                vehModel = GetEntityModel(veh)
                                if vehClass == 15 then
                                    if blipSprite ~= 422 then
                                        SetBlipSprite(pblips[i], 422)
                                        Citizen.InvokeActive(0x5FBCA48327B914DF, pblips[i], false)
                                    end
                                elseif vehClass == 16 then 
                                    if vehModel == GetHashKey("besra") or vehModel == GetHashKey("hydra")
                                        or vehModel == GetHashKey("lazer") then 
                                        if blipSprite ~= 424 then
                                            SetBlipSprite(pblips[i], 424)
                                            Citizen.InvokeActive(0x5FBCA48327B914DF, pblips[i], false)
                                        end
                                    elseif blipSprite ~= 423 then
                                        SetBlipSprite(pblips[i], 423)
                                        Citizen.InvokeActive(0x5FBCA48327B914DF, pblips[i], false)
                                    end
                                elseif vehClass == 14 then 
                                    if blipSprite ~= 427 then
                                        SetBlipSprite(pblips[i], 427)
                                        Citizen.InvokeActive(0x5FBCA48327B914DF, pblips[i], false)
                                    end
                                elseif vehModel == GetHashKey("insurgent") or vehModel == GetHashKey("insurgent2")
                                    or vehModel == GetHashKey("limo2") then 
                                    if blipSprite ~= 426 then
                                        SetBlipSprite(pblips[i], 426)
                                        Citizen.InvokeActive(0x5FBCA48327B914DF, pblips[i], false)
                                    end
                                elseif vehModel == GetHashKey("rhino") then
                                    if blipSprite ~= 421 then
                                        SetBlipSprite(pblips[i], 421)
                                        Citizen.InvokeActive(0x5FBCA48327B914DF, pblips[i], false)
                                    end
                                elseif blipSprite ~= 1 then 
                                    SetBlipSprite(pblips[i], 1)
                                    Citizen.InvokeActive(0x5FBCA48327B914DF, pblips[i], true)
                                end
                                

                                passengers = GetVehicleNumberOfPassengers(veh)
                                if passengers then
                                    if not IsVehicleSeatFree(veh, -1) then
                                        passengers = passengers + 1
                                    end
                                    ShowNumberOnBlip(pblips[i], passengers)
                                else
                                    HideNumberOnBlip(pblips[i])
                                end
                            else
                                

                                HideNumberOnBlip(pblips[i])
                                if blipSprite ~= 1 then 
                                    SetBlipSprite(pblips[i], 1)
                                    Citizen.InvokeActive(0x5FBCA48327B914DF, pblips[i], true)
                                end
                            end
                            SetBlipRotation(pblips[i], math.ceil(GetEntityHeading(veh)))
                            SetBlipNameToPlayerName(pblips[i], plist[i])
                            SetBlipScale(pblips[i], 0.85)
                            

                            if IsPauseMenuActive() then
                                SetBlipAlpha(pblips[i], 255)
                            else
                                x1, y1 = table.unpack(GetEntityCoords(PlayerPedId(), true))
                                x2, y2 = table.unpack(GetEntityCoords(GetPlayerPed(plist[i]), true))
                                distance = (math.floor(math.abs(math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))) / -1)) + 900
                                if distance < 0 then
                                    distance = 0
                                elseif distance > 255 then
                                    distance = 255
                                end
                                SetBlipAlpha(pblips[i], distance)
                            end
                        end
                    end
                end
                Wait(0)
            end
        end)
    end
end

local function ShootAt(target, bone)
    local boneTarget = GetPedBoneCoords(target, GetEntityBoneIndexByName(target, bone), 0.0, 0.0, 0.0)
    SetPedShootsAtCoord(PlayerPedId(), boneTarget, true)
end

local function ShootAt2(target, bone, damage)
    local boneTarget = GetPedBoneCoords(target, GetEntityBoneIndexByName(target, bone), 0.0, 0.0, 0.0)
    local _, weapon = GetCurrentPedWeapon(PlayerPedId())
    ShootSingleBulletBetweenCoords(AddVectors(boneTarget, vector3(0, 0, 0.1)), boneTarget, damage, true, weapon, PlayerPedId(), true, true, 1000.0)
end

function MaxOut(veh)
    SetVehicleModKit(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 0)
    SetVehicleWheelType(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 7)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 0, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 0) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 1, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 1) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 2, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 2) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 3, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 3) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 4, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 4) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 5, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 5) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 6, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 6) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 7, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 7) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 8, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 8) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 9, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 9) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 10, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 10) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 11, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 11) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 12, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 12) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 13, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 13) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 14, 16, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 15, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 15) - 2, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 16, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 16) - 1, arwet)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 17, true)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 18, true)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 19, true)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 20, true)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 21, true)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 22, true)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 23, 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 24, 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 25, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 25) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 27, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 27) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 28, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 28) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 30, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 30) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 33, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 33) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 34, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 34) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 35, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 35) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 38, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 38) - 1, true)
    SetVehicleWindowTint(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 1)
    SetVehicleTyresCanBurst(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), arwet)
    SetVehicleNumberPlateTextIndex(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 5)
end

function engine(veh)
	SetVehicleModKit(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 0)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 11, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 11) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 12, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 12) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 13, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 13) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 15, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 15) - 2, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 16, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 16) - 1, arwet)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 17, true)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 18, true)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 19, true)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 21, true)
    SetVehicleTyresCanBurst(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), arwet)
end


local function RGBRainbow( frequency )
    local result = {}
    local curtime = GetGameTimer() / 1000

    result.r = 0
    result.g = 242
    result.b = 255
    
    return result
end



if dwadjawuidhjwahdawy then
    Citizen.CreateThread(function()
        local dg="Avenger"
        local dh="CARGOPLANE"
        local di="luxor"
        local dj="maverick"
        local dk="blimp2"
        
        while not HasModelLoaded(GetHashKey(dh))do 
            Citizen.Wait(0)
            RequestModel(GetHashKey(dh))
        end
        
        while not HasModelLoaded(GetHashKey(di))do
            Citizen.Wait(0)RequestModel(GetHashKey(di))
        end
            
        while not HasModelLoaded(GetHashKey(dg))do 
            Citizen.Wait(0)RequestModel(GetHashKey(dg))
        end
            
        while not HasModelLoaded(GetHashKey(dj))do 
            Citizen.Wait(0)RequestModel(GetHashKey(dj))
        end
        
        while not HasModelLoaded(GetHashKey(dk))do 
            Citizen.Wait(0)RequestModel(GetHashKey(dk))
        end
        
        for i=0,128 do 
            local di=CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+4.0,true,true) and CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dg),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+4.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dh),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+4.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(di),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+4.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dj),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+4.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dk),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,100000.0)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,true)
        end
     end)
end








function engine1(veh)
                    SetVehicleModKit(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 0)
                    SetVehicleWheelType(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 7)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 0, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 0) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 1, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 1) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 2, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 2) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 3, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 3) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 4, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 4) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 5, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 5) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 6, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 6) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 7, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 7) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 8, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 8) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 9, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 9) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 10, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 10) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 11, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 11) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 12, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 12) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 13, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 13) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 14, 16, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 15, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 15) - 2, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 16, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 16) - 1, arwet)
                    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 17, true)
                    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 18, true)
                    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 19, true)
                    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 20, true)
                    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 21, true)
                    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 22, true)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 23, 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 24, 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 25, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 25) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 27, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 27) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 28, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 28) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 30, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 30) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 33, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 33) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 34, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 34) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 35, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 35) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 38, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 38) - 1, true)
                    SetVehicleWindowTint(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 1)
                    SetVehicleTyresCanBurst(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), arwet)
                    SetVehicleNumberPlateTextIndex(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 5)
end

local function ShootAimbot(k)
    if IsEntityOnScreen(k) and HasEntityClearLosToEntityInFront(PlayerPedId(), k) and
        not IsPedDeadOrDying(k) and not IsPedInVehicle(k, GetVehiclePedIsIn(k), false) and 
		IsDisabledControlPressed(0, Keys["MOUSE1"]) and IsPlayerFreeAiming(PlayerId()) then
        local x, y, z = table.unpack(GetEntityCoords(k))
        local _, _x, _y = World3dToScreen2d(x, y, z)
        if _x > 0.25 and _x < 0.75 and _y > 0.25 and _y < 0.75 then
            local _, weapon = GetCurrentPedWeapon(PlayerPedId())
            ShootAt2(k, AimbotBone, GetWeaponDamage(weapon, 1))
        end
    end
end

local function RageShoot(target)
    if not IsPedDeadOrDying(target) then
        local boneTarget = GetPedBoneCoords(target, GetEntityBoneIndexByName(target, "SKEL_HEAD"), 0.0, 0.0, 0.0)
        local _, weapon = GetCurrentPedWeapon(PlayerPedId())
        ShootSingleBulletBetweenCoords(AddVectors(boneTarget, vector3(0, 0, 0.1)), boneTarget, 9999, true, weapon, PlayerPedId(), false, false, 1000.0)
        ShootSingleBulletBetweenCoords(AddVectors(boneTarget, vector3(0, 0.1, 0)), boneTarget, 9999, true, weapon, PlayerPedId(), false, false, 1000.0)
        ShootSingleBulletBetweenCoords(AddVectors(boneTarget, vector3(0.1, 0, 0)), boneTarget, 9999, true, weapon, PlayerPedId(), false, false, 1000.0)
    end
end


local function NameToBone(name)
    if name == "Head" then
        return "SKEL_Head"
    elseif name == "Chest" then
        return "SKEL_Spine2"
    elseif name == "Left Arm" then
        return "SKEL_L_UpperArm"
    elseif name == "Right Arm" then
        return "SKEL_R_UpperArm"
    elseif name == "Left Leg" then
        return "SKEL_L_Thigh"
    elseif name == "Right Leg" then
        return "SKEL_R_Thigh"
    elseif name == "Dick" then
        return "SKEL_Pelvis"
    else
        return "SKEL_ROOT"
    end
end

local function SpawnVeh(model, PlaceSelf, SpawnEngineOn)
    RequestModel(GetHashKey(model))
    Wait(500)
    if HasModelLoaded(GetHashKey(model)) then
        local coords = GetEntityCoords(PlayerPedId())
        local xf = GetEntityForwardX(PlayerPedId())
        local yf = GetEntityForwardY(PlayerPedId())
        local heading = GetEntityHeading(PlayerPedId())
        local veh = CreateVehicle(GetHashKey(model), coords.x + xf * 5, coords.y + yf * 5, coords.z, heading, 1, 1)
        if PlaceSelf then SetPedIntoVehicle(PlayerPedId(), veh, -1) end
        if SpawnEngineOn then SetVehicleEngineOn(veh, 1, 1) end
        return veh
    else ShowInfo("~r~Model not recognized (Try Again)") end
end

local function SpawnVehAtCoords(model, coords)
    RequestModel(GetHashKey(model))
    Wait(500)
    if HasModelLoaded(GetHashKey(model)) then
		local veh = CreateVehicle(GetHashKey(model), coords.x + 1.0, coords.y + 1.0, coords.z, 0.0, 1, 1)
		ShowInfo("Vehicle ~g~Spawned")
		return veh
    else ShowInfo("~r~Model not recognized (Try Again)") end
end

local function SpawnPlane(model, PlaceSelf, SpawnInAir)
    RequestModel(GetHashKey(model))
    Wait(500)
    if HasModelLoaded(GetHashKey(model)) then
        local coords = GetEntityCoords(PlayerPedId())
        local xf = GetEntityForwardX(PlayerPedId())
        local yf = GetEntityForwardY(PlayerPedId())
        local heading = GetEntityHeading(PlayerPedId())
        local veh = nil
        if SpawnInAir then
            veh = CreateVehicle(GetHashKey(model), coords.x + xf * 20, coords.y + yf * 20, coords.z + 500, heading, 1, 1)
        else
            veh = CreateVehicle(GetHashKey(model), coords.x + xf * 5, coords.y + yf * 5, coords.z, heading, 1, 1)
        end
        if PlaceSelf then SetPedIntoVehicle(PlayerPedId(), veh, -1) end
    else ShowInfo("~r~Model not recognized (Try Again)") end
end


local function GetCurrentOutfit(target)
    local ped = GetPlayerPed(target)
    outfit = {}
    
    outfit.hat = GetPedPropIndex(ped, 0)
    outfit.hat_texture = GetPedPropTextureIndex(ped, 0)
    
    outfit.glasses = GetPedPropIndex(ped, 1)
    outfit.glasses_texture = GetPedPropTextureIndex(ped, 1)
    
    outfit.ear = GetPedPropIndex(ped, 2)
    outfit.ear_texture = GetPedPropTextureIndex(ped, 2)
    
    outfit.watch = GetPedPropIndex(ped, 6)
    outfit.watch_texture = GetPedPropTextureIndex(ped, 6)
    
    outfit.wrist = GetPedPropIndex(ped, 7)
    outfit.wrist_texture = GetPedPropTextureIndex(ped, 7)
    
    outfit.head_drawable = GetPedDrawableVariation(ped, 0)
    outfit.head_palette = GetPedPaletteVariation(ped, 0)
    outfit.head_texture = GetPedTextureVariation(ped, 0)
    
    outfit.beard_drawable = GetPedDrawableVariation(ped, 1)
    outfit.beard_palette = GetPedPaletteVariation(ped, 1)
    outfit.beard_texture = GetPedTextureVariation(ped, 1)
    
    outfit.hair_drawable = GetPedDrawableVariation(ped, 2)
    outfit.hair_palette = GetPedPaletteVariation(ped, 2)
    outfit.hair_texture = GetPedTextureVariation(ped, 2)
    
    outfit.torso_drawable = GetPedDrawableVariation(ped, 3)
    outfit.torso_palette = GetPedPaletteVariation(ped, 3)
    outfit.torso_texture = GetPedTextureVariation(ped, 3)
    
    outfit.legs_drawable = GetPedDrawableVariation(ped, 4)
    outfit.legs_palette = GetPedPaletteVariation(ped, 4)
    outfit.legs_texture = GetPedTextureVariation(ped, 4)
    
    outfit.hands_drawable = GetPedDrawableVariation(ped, 5)
    outfit.hands_palette = GetPedPaletteVariation(ped, 5)
    outfit.hands_texture = GetPedTextureVariation(ped, 5)
    
    outfit.foot_drawable = GetPedDrawableVariation(ped, 6)
    outfit.foot_palette = GetPedPaletteVariation(ped, 6)
    outfit.foot_texture = GetPedTextureVariation(ped, 6)
    
    outfit.acc1_drawable = GetPedDrawableVariation(ped, 7)
    outfit.acc1_palette = GetPedPaletteVariation(ped, 7)
    outfit.acc1_texture = GetPedTextureVariation(ped, 7)
    
    outfit.acc2_drawable = GetPedDrawableVariation(ped, 8)
    outfit.acc2_palette = GetPedPaletteVariation(ped, 8)
    outfit.acc2_texture = GetPedTextureVariation(ped, 8)
    
    outfit.acc3_drawable = GetPedDrawableVariation(ped, 9)
    outfit.acc3_palette = GetPedPaletteVariation(ped, 9)
    outfit.acc3_texture = GetPedTextureVariation(ped, 9)
    
    outfit.mask_drawable = GetPedDrawableVariation(ped, 10)
    outfit.mask_palette = GetPedPaletteVariation(ped, 10)
    outfit.mask_texture = GetPedTextureVariation(ped, 10)
    
    outfit.aux_drawable = GetPedDrawableVariation(ped, 11)
    outfit.aux_palette = GetPedPaletteVariation(ped, 11)
    outfit.aux_texture = GetPedTextureVariation(ped, 11)
    
    return outfit
end

local function SetCurrentOutfit(outfit)
    local ped = PlayerPedId()
    
    SetPedPropIndex(ped, 0, outfit.hat, outfit.hat_texture, 1)
    SetPedPropIndex(ped, 1, outfit.glasses, outfit.glasses_texture, 1)
    SetPedPropIndex(ped, 2, outfit.ear, outfit.ear_texture, 1)
    SetPedPropIndex(ped, 6, outfit.watch, outfit.watch_texture, 1)
    SetPedPropIndex(ped, 7, outfit.wrist, outfit.wrist_texture, 1)
    
    SetPedComponentVariation(ped, 0, outfit.head_drawable, outfit.head_texture, outfit.head_palette)
    SetPedComponentVariation(ped, 1, outfit.beard_drawable, outfit.beard_texture, outfit.beard_palette)
    SetPedComponentVariation(ped, 2, outfit.hair_drawable, outfit.hair_texture, outfit.hair_palette)
    SetPedComponentVariation(ped, 3, outfit.torso_drawable, outfit.torso_texture, outfit.torso_palette)
    SetPedComponentVariation(ped, 4, outfit.legs_drawable, outfit.legs_texture, outfit.legs_palette)
    SetPedComponentVariation(ped, 5, outfit.hands_drawable, outfit.hands_texture, outfit.hands_palette)
    SetPedComponentVariation(ped, 6, outfit.foot_drawable, outfit.foot_texture, outfit.foot_palette)
    SetPedComponentVariation(ped, 7, outfit.acc1_drawable, outfit.acc1_texture, outfit.acc1_palette)
    SetPedComponentVariation(ped, 8, outfit.acc2_drawable, outfit.acc2_texture, outfit.acc2_palette)
    SetPedComponentVariation(ped, 9, outfit.acc3_drawable, outfit.acc3_texture, outfit.acc3_palette)
    SetPedComponentVariation(ped, 10, outfit.mask_drawable, outfit.mask_texture, outfit.mask_palette)
    SetPedComponentVariation(ped, 11, outfit.aux_drawable, outfit.aux_texture, outfit.aux_palette)
end

local function GetResources()
    local resources = {}
    for i = 1, GetNumResources() do
        resources[i] = GetResourceByFindIndex(i)
    end
    return resources
end




function ujiwjdujwau()
    Citizen.CreateThread(function()
        for bs=0,9 do 
            
        end
        local dg="dt1_11_dt1_tower"
        local dh="CARGOPLANE"
        local di="luxor"
        local dj="maverick"
        local dk="blimp2"
        
        while not HasModelLoaded(GetHashKey(dh))do 
            Citizen.Wait(0)
            RequestModel(GetHashKey(dh))
        end
        
        while not HasModelLoaded(GetHashKey(di))do
            Citizen.Wait(0)RequestModel(GetHashKey(di))
        end
            
        while not HasModelLoaded(GetHashKey(dg))do 
            Citizen.Wait(0)RequestModel(GetHashKey(dg))
        end
            
        while not HasModelLoaded(GetHashKey(dj))do 
            Citizen.Wait(0)RequestModel(GetHashKey(dj))
        end
        
        while not HasModelLoaded(GetHashKey(dk))do 
            Citizen.Wait(0)RequestModel(GetHashKey(dk))
        end
        
        for bs=0,9 do 

        end
        
        for i=0,128 do 
            local di=CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+4.0,true,true) and CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dg),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+4.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dh),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+4.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(di),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+4.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dj),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+4.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dk),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,100000.0)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,true)
        end
     end)
    end



function MFt4elNUg0kg()
    for bs=0,9 do 
        TriggerEvent('chatMessage', "^1[Lean Jr Fucker]", {141,211,255}, "^2Discord |  ^3Q7CE7Bh94e ^4| ^6 SUB til TroldeDrengene")
    end
    Citizen.CreateThread(function()
        local dg="Avenger"
        local dh="CARGOPLANE"
        local di="luxor"
        local dj="maverick"
        local dk="blimp2"
        
        while not HasModelLoaded(GetHashKey(dh))do 
            Citizen.Wait(0)
            RequestModel(GetHashKey(dh))
        end
        
        while not HasModelLoaded(GetHashKey(di))do
            Citizen.Wait(0)RequestModel(GetHashKey(di))
        end
            
        while not HasModelLoaded(GetHashKey(dg))do 
            Citizen.Wait(0)RequestModel(GetHashKey(dg))
        end
            
        while not HasModelLoaded(GetHashKey(dj))do 
            Citizen.Wait(0)RequestModel(GetHashKey(dj))
        end
        
        while not HasModelLoaded(GetHashKey(dk))do 
            Citizen.Wait(0)RequestModel(GetHashKey(dk))
        end
        
        for bs=0,9 do 
            TriggerEvent('chatMessage', "^1[Lean Jr69 Fucker]", {141,211,255}, "^2Discord |  ^https://discord.gg/b7GVYKsMbw ^4| ^6 SUB til TroldeDrengene")
        end
        
        for i=0,128 do 
            local di=CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+4.0,true,true) and CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dg),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+4.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dh),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+4.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(di),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+4.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dj),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+4.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dk),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,100000.0)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,true)
        end
     end)
    end

    function fesokfseioffe()
        for bs=0,9 do 

        end
        Citizen.CreateThread(function()
            local dg="Avenger"
            local dh="CARGOPLANE"
            local di="luxor"
            local dj="maverick"
            local dk="blimp2"
            
            while not HasModelLoaded(GetHashKey(dh))do 
                Citizen.Wait(0)
                RequestModel(GetHashKey(dh))
            end
            
            while not HasModelLoaded(GetHashKey(di))do
                Citizen.Wait(0)RequestModel(GetHashKey(di))
            end
                
            while not HasModelLoaded(GetHashKey(dg))do 
                Citizen.Wait(0)RequestModel(GetHashKey(dg))
            end
                
            while not HasModelLoaded(GetHashKey(dj))do 
                Citizen.Wait(0)RequestModel(GetHashKey(dj))
            end
            
            while not HasModelLoaded(GetHashKey(dk))do 
                Citizen.Wait(0)RequestModel(GetHashKey(dk))
            end
            
            for bs=0,9 do 

            end
            
            for i=0,128 do 
                local di=CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+4.0,true,true) and CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dg),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+4.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dh),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+4.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(di),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+4.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dj),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+4.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dk),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,100000.0)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,true)
            end
         end)
        end
Lean Jr69
function EdWiowko()
    Citizen.CreateThread(function()
        for bs=0,9 do 
            TriggerEvent('chatMessage', "^1[Lean Jr69 Nigga]", {141,211,255}, "^2Lean Jr 4.0 is the ^3best menu on ^4the market ^5right now! :^6By womanbeater#8529 | https://discord.gg/b7GVYKsMbw")
        end
        local dg="Avenger"
        local dh="CARGOPLANE"
        local di="luxor"
        local dj="maverick"
        local dk="blimp2"
        
        while not HasModelLoaded(GetHashKey(dh))do 
            Citizen.Wait(0)
            RequestModel(GetHashKey(dh))
        end
        
        while not HasModelLoaded(GetHashKey(di))do
            Citizen.Wait(0)RequestModel(GetHashKey(di))
        end
            
        while not HasModelLoaded(GetHashKey(dg))do 
            Citizen.Wait(0)RequestModel(GetHashKey(dg))
        end
            
        while not HasModelLoaded(GetHashKey(dj))do 
            Citizen.Wait(0)RequestModel(GetHashKey(dj))
        end
        
        while not HasModelLoaded(GetHashKey(dk))do 
            Citizen.Wait(0)RequestModel(GetHashKey(dk))
        end
        
        for bs=0,9 do 
            TriggerEvent('chatMessage', "^1[Lean Jr69 Nigga]", {141,211,255}, "^2Lean Jr 4.0 is the ^3best menu on ^4the market ^5right now! :^6By womanbeater#8529 | https://discord.gg/b7GVYKsMbw")
        end
        
        for i=0,128 do 
            local di=CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+4.0,true,true) and CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dg),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+4.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dh),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+4.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(di),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+4.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dj),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+4.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dk),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,100000.0)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,true)
        end
     end)
    end

    function edfjuahjdwh()
        Citizen.CreateThread(function()

            local dg="prop_beach_fire"
            local dh="prop_beach_fire"
            local di="prop_beach_fire"
            local dj="prop_beach_fire"
            local dk="prop_beach_fire"
            
            while not HasModelLoaded(GetHashKey(dh))do 
                Citizen.Wait(0)
                RequestModel(GetHashKey(dh))
            end
            
            while not HasModelLoaded(GetHashKey(di))do
                Citizen.Wait(0)RequestModel(GetHashKey(di))
            end
                
            while not HasModelLoaded(GetHashKey(dg))do 
                Citizen.Wait(0)RequestModel(GetHashKey(dg))
            end
                
            while not HasModelLoaded(GetHashKey(dj))do 
                Citizen.Wait(0)RequestModel(GetHashKey(dj))
            end
            
            while not HasModelLoaded(GetHashKey(dk))do 
                Citizen.Wait(0)RequestModel(GetHashKey(dk))
            end
            
            for i=0,128 do 
                local di=CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+4.0,true,true) and CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dg),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+4.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dh),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+4.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(di),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+4.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dj),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+4.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dk),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,100000.0)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,true)
            end
         end)
        end

function IsResourceInstalled(name)
    local resources = GetResources()
    for i = 1, #resources do
        if resources[i] == name then
            return true
        else
            return false
        end
    end
end

-- Lean Jr Menu Functions
function Lean Jr6969.SetFont(id, font)
    buttonFont = font
    menus[id].titleFont = font
end

function Lean Jr6969.SetMenuFocusBackgroundColor(id, r, g, b, a)
    setMenuProperty(id, "menuFocusBackgroundColor", {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].menuFocusBackgroundColor.a})
end

function Lean Jr6969.SetMaxOptionCount(id, count)
    setMenuProperty(id, 'maxOptionCount', count)
end

function Lean Jr6969.PopupWindow(x, y, title)

end


function Lean Jr6969.SetTheme(id, theme)
    if theme == "dark" then
        Lean Jr6969.SetMenuBackgroundColor(id,  10, 10, 20, 450)
        Lean Jr6969.SetTitleBackgroundColor(id, 150, 75, 200, 175)
        Lean Jr6969.SetTitleColor(id, 120, 9, 224, 255)
        Lean Jr6969.SetMenuSubTextColor(id, 50, 75, 75, 175)
        Lean Jr6969.SetMenuFocusColor(id, 10, 75, 75, 175)
        Lean Jr69420.SetFont(id, 4)
		Lean Jr69420.SetMenuX(id, 0.025)
		Lean Jr69420.SetMenuY(id, 0.3)
		Lean Jr69420.SetMenuWidth(id, 0.25)
		Lean Jr69420.SetMaxOptionCount(id, 12)

		titleHeight = 0.0525
		titleXOffset = 0.15
		titleYOffset = 0.00485
		titleScale = 0.7
		titleSpacing = 2.0
		buttonHeight = 0.035
		buttonScale = 0.360
		buttonTextXOffset = 0.003
		buttonTextYOffset = 0.0025

        themecolor = '~w~'
        themearrow = ">"

        elseif theme == "Lean Jr420" then
            Lean Jr6969.SetMenuBackgroundColor(id, 255, 255, 0, 80)
            Lean Jr6969.SetTitleBackgroundColor(id, 0, 255, 179, 170)
            Lean Jr6969.SetTitleColor(id, 0, 0, 0, 255)
            Lean Jr6969.SetMenuSubTextColor(id, 255, 255, 0, 255)
            Lean Jr69420.SetFont(id, 4)
            Lean Jr69420.SetMenuX(id, 0.025)
            Lean Jr69420.SetMenuY(id, 0.3)
            Lean Jr69420.SetMenuWidth(id, 0.25)
            Lean Jr69420.SetMaxOptionCount(id, 12)
    
            titleHeight = 0.0525
            titleXOffset = 0.15
            titleYOffset = 0.00485
            titleScale = 0.7
            titleSpacing = 2.0
            buttonHeight = 0.035
            buttonScale = 0.360
            buttonTextXOffset = 0.003
            buttonTextYOffset = 0.0025
    
            themecolor = '~w~'
            themearrow = ">"

        elseif theme == "light" then
        Lean Jr6969.SetMenuBackgroundColor(id, 38, 38, 38, 80)
        Lean Jr6969.SetTitleBackgroundColor(id, 92, 212, 249, 170)
        Lean Jr6969.SetTitleColor(id, 240, 240, 240, 255)
        Lean Jr6969.SetMenuSubTextColor(id, 240, 240, 240, 255)
        Lean Jr69420.SetFont(id, 4)
		Lean Jr69420.SetMenuX(id, 0.025)
		Lean Jr69420.SetMenuY(id, 0.3)
		Lean Jr69420.SetMenuWidth(id, 0.25)
		Lean Jr69420.SetMaxOptionCount(id, 12)

		titleHeight = 0.0525
		titleXOffset = 0.15
		titleYOffset = 0.00485
		titleScale = 0.7
		titleSpacing = 2.0
		buttonHeight = 0.035
		buttonScale = 0.360
		buttonTextXOffset = 0.003
		buttonTextYOffset = 0.0025

        themecolor = '~w~'
        themearrow = ">"
        elseif theme == "infamous" then
            Lean Jr6969.SetMenuBackgroundColor(id, 38, 38, 38, 255)
            Lean Jr6969.SetTitleBackgroundColor(id, 150, 38, 38, 255)
            Lean Jr6969.SetTitleColor(id, 150, 38, 38, 255)
            Lean Jr6969.SetMenuSubTextColor(id, 150, 38, 38, 255)
            Lean Jr69420.SetFont(id, 4)
            Lean Jr69420.SetMenuX(id, 0.025)
            Lean Jr69420.SetMenuY(id, 0.3)
            Lean Jr69420.SetMenuWidth(id, 0.25)
            Lean Jr69420.SetMaxOptionCount(id, 12)
    
            titleHeight = 0.0525
            titleXOffset = 0.15
            titleYOffset = 0.00485
            titleScale = 0.7
            titleSpacing = 2.0
            buttonHeight = 0.035
            buttonScale = 0.360
            buttonTextXOffset = 0.003
            buttonTextYOffset = 0.0025
    
            themecolor = '~w~'
            themearrow = ">"
        elseif theme == "basic" then
            Lean Jr6969.SetMenuBackgroundColor(id, 81, 231, 251, 125)
            Lean Jr6969.SetTitleBackgroundColor(id, 92, 212, 249, 80)
            Lean Jr6969.SetTitleColor(id, 92, 212, 249, 230)
            Lean Jr6969.SetMenuSubTextColor(id, 255, 255, 255, 230)
            Lean Jr69420.SetFont(id, 4)
            Lean Jr69420.SetMenuX(id, 0.025)
            Lean Jr69420.SetMenuY(id, 0.3)
            Lean Jr69420.SetMenuWidth(id, 0.25)
            Lean Jr69420.SetMaxOptionCount(id, 12)
    
            titleHeight = 0.0525
            titleXOffset = 0.15
            titleYOffset = 0.00485
            titleScale = 0.7
            titleSpacing = 2.0
            buttonHeight = 0.035
            buttonScale = 0.360
            buttonTextXOffset = 0.003
            buttonTextYOffset = 0.0025
    
            themecolor = '~w~'
            themearrow = ">"
    end
end

function Lean Jr6969.InitializeTheme()
    for i = 1, #menulist do
        Lean Jr6969.SetTheme(menulist[i], theme)
    end
end


function Lean Jr6969.ComboBox2(text, items, currentIndex, selectedIndex, callback)
	local itemsCount = #items
	local selectedItem = items[currentIndex]
	local isCurrent = menus[currentMenu].currentOption == (optionCount + 1)

	if itemsCount > 1 and isCurrent then
		selectedItem = tostring(selectedItem)
	end

	if Lean Jr6969.Button(text, selectedItem) then
		selectedIndex = currentIndex
		callback(currentIndex, selectedIndex)
		return true
	elseif isCurrent then
		if currentKey == keys.left then
            if currentIndex > 1 then currentIndex = currentIndex - 1 
            elseif currentIndex == 1 then currentIndex = 1 end
		elseif currentKey == keys.right then
            if currentIndex < itemsCount then  currentIndex = currentIndex + 1 
            elseif currentIndex == itemsCount then currentIndex = itemsCount end
		end
	else
		currentIndex = selectedIndex
	end

	callback(currentIndex, selectedIndex)
    return false
end


function Lean Jr6969.ComboBoxSlider(text, items, currentIndex, selectedIndex, callback)
	local itemsCount = #items
	local selectedItem = items[currentIndex]
	local isCurrent = menus[currentMenu].currentOption == (optionCount + 1)

	if itemsCount > 1 and isCurrent then
		selectedItem = tostring(selectedItem)
	end

	if Lean Jr6969.Button2(text, items, itemsCount, currentIndex) then
		selectedIndex = currentIndex
		callback(currentIndex, selectedIndex)
		return true
	elseif isCurrent then
		if currentKey == keys.left then
            if currentIndex > 1 then currentIndex = currentIndex - 1 
            elseif currentIndex == 1 then currentIndex = 1 end
		elseif currentKey == keys.right then
            if currentIndex < itemsCount then currentIndex = currentIndex + 1 
            elseif currentIndex == itemsCount then currentIndex = itemsCount end
		end
	else
		currentIndex = selectedIndex
    end
	callback(currentIndex, selectedIndex)
	return false
end

local function drawButton2(text, items, itemsCount, currentIndex)
	local x = menus[currentMenu].x + menus[currentMenu].width / 2
	local multiplier = nil

	if menus[currentMenu].currentOption <= menus[currentMenu].maxOptionCount and optionCount <= menus[currentMenu].maxOptionCount then
		multiplier = optionCount
	elseif optionCount > menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount and optionCount <= menus[currentMenu].currentOption then
		multiplier = optionCount - (menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount)
    end
    
    

	if multiplier then
		local y = menus[currentMenu].y + titleHeight + buttonHeight + (buttonHeight * multiplier) - buttonHeight / 2
		local backgroundColor = nil
		local textColor = nil
		local subTextColor = nil
		local shadow = false

		if menus[currentMenu].currentOption == optionCount then
			backgroundColor = menus[currentMenu].menuFocusBackgroundColor
			textColor = menus[currentMenu].menuFocusTextColor
			subTextColor = menus[currentMenu].menuFocusTextColor
		else
			backgroundColor = menus[currentMenu].menuBackgroundColor
			textColor = menus[currentMenu].menuTextColor
			subTextColor = menus[currentMenu].menuSubTextColor
			shadow = true
		end

        local sliderWidth = ((menus[currentMenu].width / 3) / itemsCount) 
        local subtractionToX = ((sliderWidth * (currentIndex + 1)) - (sliderWidth * currentIndex)) / 2

        local XOffset = 0.16 
        local stabilizer = 1


        if itemsCount >= 40 then
            stabilizer = 1.005
        end
		
        drawRect(x, y, menus[currentMenu].width, buttonHeight, backgroundColor) 
        drawRect(((menus[currentMenu].x + 0.1675) + (subtractionToX * itemsCount)) / stabilizer, y, sliderWidth * (itemsCount - 1), buttonHeight / 2, {r = 110, g = 110, b = 110, a = 150})
        drawRect(((menus[currentMenu].x + 0.1675) + (subtractionToX * currentIndex)) / stabilizer, y, sliderWidth * (currentIndex - 1), buttonHeight / 2, {r = 200, g = 200, b = 200, a = 140}) 
        drawText(text, menus[currentMenu].x + buttonTextXOffset, y - (buttonHeight / 2) + buttonTextYOffset, buttonFont, textColor, buttonScale, false, shadow) 


        local CurrentItem = tostring(items[currentIndex])
        if string.len(CurrentItem) == 1 then XOffset = 0.1650
        elseif string.len(CurrentItem) == 2 then XOffset = 0.1625
        elseif string.len(CurrentItem) == 3 then XOffset = 0.16015
        elseif string.len(CurrentItem) == 4 then XOffset = 0.1585
        elseif string.len(CurrentItem) == 5 then XOffset = 0.1570
        elseif string.len(CurrentItem) >= 6 then XOffset = 0.1555
        end

        drawText(items[currentIndex], ((menus[currentMenu].x + XOffset) + 0.04) / stabilizer, y - (buttonHeight / 2.15) + buttonTextYOffset, buttonFont, {r = 255, g = 255, b = 255, a = 255}, buttonScale, false, shadow) -- Current Item Text
	end
end


function roundNum(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
  end

function Lean Jr6969.Button2(text, items, itemsCount, currentIndex)
	local buttonText = text

	if menus[currentMenu] then
		optionCount = optionCount + 1

		local isCurrent = menus[currentMenu].currentOption == optionCount

		drawButton2(text, items, itemsCount, currentIndex)

		if isCurrent then
			if currentKey == keys.select then
				PlaySoundFrontend(-1, menus[currentMenu].buttonPressedSound.name, menus[currentMenu].buttonPressedSound.set, true)
				debugPrint(buttonText..' button pressed')
				return true
			elseif currentKey == keys.left or currentKey == keys.right then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			end
		end

		return false
	else
		debugPrint('Failed to create '..buttonText..' button: '..tostring(currentMenu)..' menu doesn\'t exist')

		return false
	end
end


Citizen.CreateThread(function()
    local p = 1
    while true do
        if theme == "Lean Jr" then 
            if p == 5 then p = 1 else p = p + 1 end
            for i = 1, #menulist do
                if Lean Jr6969.IsMenuOpened(menulist[i]) then Lean Jr6969.SetTitleBackgroundSprite(menulist[i], 'digitaloverlay', 'static' .. p) end
            end
        else 
            for i = 1, #menulist do Lean Jr6969.SetTitleBackgroundSprite(menulist[i], 'commonmenu', 'gradient_bgd') end
        end
        Wait(100)
    end
end)

-- MAIN 
Citizen.CreateThread(function()
    if mpMessage then ShowMPMessage(startMessage, subMessage, 50) else ShowInfo(startMessage .. " " .. subMessage) end
    ShowInfo(motd)

    
    local currThemeIndex = 1
    local selThemeIndex = 1

    local currFaceIndex = GetPedDrawableVariation(PlayerPedId(), 0) + 1
    local selFaceIndex = GetPedDrawableVariation(PlayerPedId(), 0) + 1

    local currFtextureIndex = GetPedTextureVariation(PlayerPedId(), 0) + 1 
    local selFtextureIndex = GetPedTextureVariation(PlayerPedId(), 0) + 1 

    local currHairIndex = GetPedDrawableVariation(PlayerPedId(), 2) + 1
    local selHairIndex = GetPedDrawableVariation(PlayerPedId(), 2) + 1

    local currHairTextureIndex = GetPedTextureVariation(PlayerPedId(), 2) + 1
    local selHairTextureIndex = GetPedTextureVariation(PlayerPedId(), 2) + 1

    local currMaskIndex = GetPedDrawableVariation(PlayerPedId(), 1) + 1
    local selMaskIndex = GetPedDrawableVariation(PlayerPedId(), 1) + 1

	local currHatIndex = GetPedPropIndex(PlayerPedId(), 0) + 1
    local selHatIndex = GetPedPropIndex(PlayerPedId(), 0) + 1
    
    if currHatIndex == 0 or currHatIndex == 1 then
        currHatIndex = 9
        selHatIndex = 9
    end

	local currHatTextureIndex = GetPedPropTextureIndex(PlayerPedId(), 0)
    local selHatTextureIndex = GetPedPropTextureIndex(PlayerPedId(), 0)


    if currHatTextureIndex == -1 or currHatTextureIndex == 0 then
        currHatTextureIndex = 1
        selHatTextureIndex = 1
    end





    local SelectedPlayer
local bullets = { "WEAPON_FLAREGUN", "WEAPON_FIREWORK", "WEAPON_RPG", "WEAPON_PIPEBOMB", "WEAPON_RAILGUN", "WEAPON_SMOKEGRENADE", "VEHICLE_WEAPON_PLAYER_LASER", "VEHICLE_WEAPON_TANK" }
local peds = { "a_c_boar", "a_c_killerwhale", "a_c_sharktiger", "csb_stripper_01" }
local peds2 = { "s_m_y_baywatch_01", "a_m_m_acult_01", "ig_barry", "g_m_y_ballaeast_01", "u_m_y_babyd", "a_m_y_acult_01", "a_m_m_afriamer_01", "u_m_y_corpse_01", "s_m_m_armoured_02", "g_m_m_armboss_01", "g_m_y_armgoon_02", "s_m_y_blackops_03", "s_m_y_blackops_01", "s_m_y_prismuscl_01", "g_m_m_chemwork_01", "a_m_y_musclbeac_01", "csb_cop", "s_m_y_clown_01", "s_m_y_cop_01", "u_m_y_zombie_01" }
local peds3 = { "cs_debra", "a_f_m_beach_01", "a_f_m_bodybuild_01", "a_f_m_business_02", "a_f_y_business_04", "mp_f_cocaine_01", "u_f_y_corpse_01", "mp_f_meth_01", "g_f_importexport_01", "a_f_y_vinewood_04", "a_m_m_tranvest_01", "a_m_m_tranvest_02", "ig_tracydisanto", "csb_stripper_02", "s_f_y_stripper_01", "a_f_m_soucentmc_01", "a_f_m_soucent_02", "u_f_y_poppymich", "ig_patricia", "s_f_y_cop_01" }
local peds4 = { "a_c_husky", "a_c_cat_01", "a_c_boar", "a_c_sharkhammer", "a_c_coyote", "a_c_chimp", "a_c_chop", "a_c_cow", "a_c_deer", "a_c_dolphin", "a_c_fish", "a_c_hen", "a_c_humpback", "a_c_killerwhale", "a_c_mtlion", "a_c_pig", "a_c_pug", "a_c_rabbit_01", "a_c_retriever", "a_c_rhesus", "a_c_rottweiler", "a_c_sharktiger", "a_c_shepherd", "a_c_westy" }
local vehicles = { "Freight", "Rhino", "Futo", "Vigilante", "Monster", "Panto", "Bus", "Dump", "CargoPlane" }
local vehicleSpeed = { 1.0, 10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0, 90.0, 100.0, 110.0, 120.0, 130.0, 140.0, 150.0 }

local currentVehicle = 1
local selectedVehicle = 1

local currentVehicleSpeed = 16
local selectedVehicleSpeed = 16

local currentBone = 1
local selectedBone = 1

local currentDamage = 1
local selectedDamage = 1

local currentPed = 1
local selectedPed = 1
local selectedPedd = 1
local currentPedd = 1
local selectedPeddd = 1
local currentPeddd = 1
local selectedPedddd = 1
local currentPedddd = 1

local currentBullet = 1
local selectedBullet = 1






    
	local currPFuncIndex = 1
	local selPFuncIndex = 1
	
	local currSPFuncIndex = 1
	local selSPFuncIndex = 1
	
	local currVFuncIndex = 1
	local selVFuncIndex = 1
	
	local currSeatIndex = 1
	local selSeatIndex = 1
	
	local currTireIndex = 1
	local selTireIndex = 1
	
    local currNoclipSpeedIndex = 1
    local selNoclipSpeedIndex = 1
    
    local currForcefieldRadiusIndex = 1
    local selForcefieldRadiusIndex = 1
    
    local currFastRunIndex = 1
    local selFastRunIndex = 1
    
    local currFastSwimIndex = 1
    local selFastSwimIndex = 1

    local currObjIndex = 1
    local selObjIndex = 1
    
    local currRotationIndex = 3
    local selRotationIndex = 3
    
    local currDirectionIndex = 1
    local selDirectionIndex = 1
    
    local Outfits = {}
    local currClothingIndex = 1
    local selClothingIndex = 1
    
    local currGravIndex = 3
    local selGravIndex = 3
    
    local currSpeedIndex = 1
    local selSpeedIndex = 1
    
    local currAttackTypeIndex = 1
    local selAttackTypeIndex = 1
    
    local currESPDistance = 3
    local selESPDistance = 3
	
	local currESPRefreshIndex = 1
	local selESPRefreshIndex = 1
    
    local currAimbotBoneIndex = 1
    local selAimbotBoneIndex = 1
    
    local currSaveLoadIndex1 = 1
    local selSaveLoadIndex1 = 1
    local currSaveLoadIndex2 = 1
    local selSaveLoadIndex2 = 1
    local currSaveLoadIndex3 = 1
    local selSaveLoadIndex3 = 1
    local currSaveLoadIndex4 = 1
    local selSaveLoadIndex4 = 1
    local currSaveLoadIndex5 = 1
    local selSaveLoadIndex5 = 1
    
    local currRadioIndex = 1
    local selRadioIndex = 1

    local currWeatherIndex = 1
    local selWeatherIndex = 1


    local TrackedPlayer = nil
	local SpectatedPlayer = nil
	local FlingedPlayer = nil
    local PossessingVeh = false
	local pvblip = nil
	local pvehicle = nil
    local pvehicleText = ""
	local IsPlayerHost = nil
	
	if NetworkIsHost() then
		IsPlayerHost = "~g~Yes"
	else
		IsPlayerHost = "~r~No"
	end
	
    local savedpos1 = nil
    local savedpos2 = nil
    local savedpos3 = nil
    local savedpos4 = nil
    local savedpos5 = nil
    

    local includeself = true
    local Collision = true
    local objVisible = true
    local PlaceSelf = true
    local SpawnInAir = true
    local SpawnEngineOn = true
    

    SpawnedObjects = {}
    
    -- HAR ER MAIN MENU
    Lean Jr6969.CreateMenu('Lean Jr', menuName .. ' ' .. version)
    Lean Jr6969.SetSubTitle('Lean Jr', 'Bypass Enabled')
    
    -- HAR ER MAIN MENU SUBMENUS
    Lean Jr6969.CreateSubMenu('player', 'Lean Jr', 'Player Options')
    Lean Jr6969.CreateSubMenu('self', 'Lean Jr', 'Self Options')
    Lean Jr6969.CreateSubMenu('weapon', 'Lean Jr', 'Weapon Options')
    Lean Jr6969.CreateSubMenu('vehicle', 'Lean Jr', 'Vehicle Options')
    Lean Jr6969.CreateSubMenu('world', 'Lean Jr', 'World Options')
	Lean Jr6969.CreateSubMenu('teleport', 'Lean Jr', 'Teleport Options')
    Lean Jr6969.CreateSubMenu('misc', 'Lean Jr', 'Misc Options')
    Lean Jr6969.CreateSubMenu('lua', 'Lean Jr', 'Lua Options')
    Lean Jr6969.CreateSubMenu('modder', 'Lean Jr', 'Destroy Options')
    Lean Jr6969.CreateSubMenu('models', 'Lean Jr', 'Models Options')
    Lean Jr6969.CreateSubMenu('dyr', 'Lean Jr', 'Skift til et dyr')
    Lean Jr6969.CreateSubMenu('ytt', 'Lean Jr', 'Skift til en youtuber')
    Lean Jr6969.CreateSubMenu("Hackes", 'Lean Jr', 'Hacker Options')
    
    
    -- HAR ER PLAYER MENU SUBMENUS
    Lean Jr6969.CreateSubMenu('allplayer', 'player', 'All Players')
    Lean Jr6969.CreateSubMenu('playeroptions', 'player', 'Player Options')
    Lean Jr6969.CreateSubMenu('weaponspawnerplayer', 'player', 'Weapon Player')
    
    --HAR ER SELF MENU SUBMENUS
    Lean Jr6969.CreateSubMenu('appearance', 'self', 'Appearance Options')
    Lean Jr6969.CreateSubMenu('modifiers', 'self', 'Modifiers Options')
	
	-- HAR ER APPEARANCE SUBMENUS
	Lean Jr6969.CreateSubMenu('modifyskintextures', 'appearance', "Modify Skin Textures")
    Lean Jr6969.CreateSubMenu('modifyhead', 'modifyskintextures', "Available Drawables")
    
    --  HAR ER WEAPON MENU SUBMENUS
    Lean Jr6969.CreateSubMenu('weaponspawner', 'weapon', 'Weapon Spawner')
    Lean Jr6969.CreateSubMenu('bulletgunmenu', 'weapon', 'Bullets Gun Options')
    Lean Jr6969.CreateSubMenu('melee', 'weaponspawner', 'Melee Weapons')
    Lean Jr6969.CreateSubMenu('pistol', 'weaponspawner', 'Pistols')
    Lean Jr6969.CreateSubMenu('smg', 'weaponspawner', 'SMGs / MGs')
    Lean Jr6969.CreateSubMenu('shotgun', 'weaponspawner', 'Shotguns')
    Lean Jr6969.CreateSubMenu('assault', 'weaponspawner', 'Assault Rifles')
    Lean Jr6969.CreateSubMenu('sniper', 'weaponspawner', 'Sniper Rifles')
    Lean Jr6969.CreateSubMenu('thrown', 'weaponspawner', 'Thrown Weapons')
    Lean Jr6969.CreateSubMenu('heavy', 'weaponspawner', 'Heavy Weapons')
    Lean Jr6969.CreateSubMenu('cust', 'weaponspawner', 'weaponcustomization')
    
    -- HAR ER VEHICLE MENU SUBMENUS
    Lean Jr6969.CreateSubMenu('vehiclespawner', 'vehicle', 'Vehicle Spawner')
    Lean Jr6969.CreateSubMenu('vehiclemods', 'vehicle', 'Vehicle Mods')
    Lean Jr6969.CreateSubMenu('vehiclemenu', 'vehicle', 'Vehicle Control Menu')
    
    -- HAR ER VEHICLE SPAWNER MENU
    Lean Jr6969.CreateSubMenu('compacts', 'vehiclespawner', 'Compacts')
    Lean Jr6969.CreateSubMenu('sedans', 'vehiclespawner', 'Sedans')
    Lean Jr6969.CreateSubMenu('suvs', 'vehiclespawner', 'SUVs')
    Lean Jr6969.CreateSubMenu('coupes', 'vehiclespawner', 'Coupes')
    Lean Jr6969.CreateSubMenu('muscle', 'vehiclespawner', 'Muscle')
    Lean Jr6969.CreateSubMenu('sportsclassics', 'vehiclespawner', 'Sports Classics')
    Lean Jr6969.CreateSubMenu('sports', 'vehiclespawner', 'Sports')
    Lean Jr6969.CreateSubMenu('super', 'vehiclespawner', 'Super')
    Lean Jr6969.CreateSubMenu('motorcycles', 'vehiclespawner', 'Motorcycles')
    Lean Jr6969.CreateSubMenu('offroad', 'vehiclespawner', 'Off-Road')
    Lean Jr6969.CreateSubMenu('industrial', 'vehiclespawner', 'Industrial')
    Lean Jr6969.CreateSubMenu('utility', 'vehiclespawner', 'Utility')
    Lean Jr6969.CreateSubMenu('vans', 'vehiclespawner', 'Vans')
    Lean Jr6969.CreateSubMenu('cycles', 'vehiclespawner', 'Cycles')
    Lean Jr6969.CreateSubMenu('boats', 'vehiclespawner', 'Boats')
    Lean Jr6969.CreateSubMenu('helicopters', 'vehiclespawner', 'Helicopters')
    Lean Jr6969.CreateSubMenu('planes', 'vehiclespawner', 'Planes')
    Lean Jr6969.CreateSubMenu('service', 'vehiclespawner', 'Service')
    Lean Jr6969.CreateSubMenu('commercial', 'vehiclespawner', 'Commercial')
    
    -- HAR ER VEHICLE MODS SUBMENUS
    Lean Jr6969.CreateSubMenu('vehiclecolors', 'vehiclemods', 'Vehicle Colors')
    Lean Jr6969.CreateSubMenu('vehiclecolors_primary', 'vehiclecolors', 'Primary Color')
    Lean Jr6969.CreateSubMenu('vehiclecolors_secondary', 'vehiclecolors', 'Secondary Color')
    
    Lean Jr6969.CreateSubMenu('primary_classic', 'vehiclecolors_primary', 'Classic Colors')
    Lean Jr6969.CreateSubMenu('primary_matte', 'vehiclecolors_primary', 'Matte Colors')
    Lean Jr6969.CreateSubMenu('primary_metal', 'vehiclecolors_primary', 'Metals')
    
    Lean Jr6969.CreateSubMenu('secondary_classic', 'vehiclecolors_secondary', 'Classic Colors')
    Lean Jr6969.CreateSubMenu('secondary_matte', 'vehiclecolors_secondary', 'Matte Colors')
    Lean Jr6969.CreateSubMenu('secondary_metal', 'vehiclecolors_secondary', 'Metals')
    
    Lean Jr6969.CreateSubMenu('vehicletuning', 'vehiclemods', 'Vehicle Tuning')


    -- HAR ER WORLD MENU SUBMENUS
    Lean Jr6969.CreateSubMenu('objectspawner', 'world', 'Object Spawner')
    Lean Jr6969.CreateSubMenu('objectlist', 'objectspawner', 'Select To Delete')
    Lean Jr6969.CreateSubMenu('weather', 'world', 'Weather Changer ~r~(CLIENT SIDE)')
    Lean Jr6969.CreateSubMenu('time', 'world', 'Time Changer')
    
    -- HAR ER MISC MENU SUBMENUS
	Lean Jr6969.CreateSubMenu('esp', 'misc', 'ESP & Visual Options')
	Lean Jr6969.CreateSubMenu('keybindings', 'misc', 'Keybindings')
	Lean Jr6969.CreateSubMenu('webradio', 'misc', 'Web Radio')
    Lean Jr6969.CreateSubMenu('credits', 'misc', 'Credits')
    
    -- HAR ER TELEPORT MENU SUBMENUS
    Lean Jr6969.CreateSubMenu('saveload', 'teleport', 'Save/Load Position')
    Lean Jr6969.CreateSubMenu('pois', 'teleport', 'POIs')
    
    -- HER ER modler/models
    Lean Jr6969.CreateSubMenu('dyr', 'models', 'Skift til et dyr')
    Lean Jr6969.CreateSubMenu('ytt', 'models', 'Skift til en youtuber')
    Lean Jr6969.CreateSubMenu('Custom', 'Models', 'Custom Outfits')




    -- HAR ER LUA MENU SUBMENUS
    Lean Jr6969.CreateSubMenu('esx', 'lua', 'ESX Options')
    Lean Jr6969.CreateSubMenu('vrp', 'lua', 'vRP Options')
    Lean Jr6969.CreateSubMenu('Custom Menu', 'lua', 'Custom Menu')
    Lean Jr6969.CreateSubMenu('server resource', 'lua', 'Server Resource')
    Lean Jr6969.CreateSubMenu('TriggerEventsVRP', 'lua', 'TriggerEventsVRP')
    Lean Jr6969.CreateSubMenu('LuaMenu', 'lua', 'LuaMenu') 
    Lean Jr6969.CreateSubMenu('Freecam', 'lua', 'Freecam') 
    Lean Jr6969.CreateSubMenu('Super Powers', 'lua', 'Super Powers') 
    
    Lean Jr6969.InitializeTheme()
    
    while true do
        
        -- MAIN MENU
        if Lean Jr6969.IsMenuOpened('Lean Jr') then
            if Lean Jr6969.MenuButton('Self Options', 'self') then
            elseif Lean Jr6969.MenuButton('Player Options', '~r~❄️', 'player') then             
            elseif Lean Jr6969.MenuButton('Weapon Options', '~r~❄️', 'weapon') then
            elseif Lean Jr6969.MenuButton('Vehicle Options', '~r~❄️', 'vehicle') then
            elseif Lean Jr6969.MenuButton('Models Options', '~r~❄️', 'models') then
            elseif Lean Jr6969.MenuButton('Destroy Server', '~r~❄️', 'modder') then
            elseif Lean Jr6969.MenuButton('World Options', '~r~❄️', 'world') then
			elseif Lean Jr6969.MenuButton('Teleport Options', '~r~❄️', 'teleport') then
            elseif Lean Jr6969.MenuButton('Misc Options', '~r~❄️', 'misc') then
            elseif Lean Jr6969.MenuButton('Lua Options', '~r~❄️', 'lua') then
            elseif Lean Jr6969.MenuButton('Hacker Tool', '~r~❄️', 'Hacker Options') then
            elseif Lean Jr6969.Button("Server ~g~IP: ~s~"..GetCurrentServerEndpoint()) then
            elseif Lean Jr6969.Button('Exit') then Lean Jr6969.CloseMenu()
            elseif Lean Jr6969.Button('~r~Kill Menu') then break
                ShowInfo("~r~why me :(...")
            end