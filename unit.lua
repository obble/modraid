

    assert(IsAddOnLoaded'Blizzard_RaidUI', 'Blizzard Raid UI did not load first!')

    local _G = getfenv(0)
    local sb = [[Interface\AddOns\modui\modsb\texture\sb.tga]]
    local orig = {}

    local skin = function()
        for i = 1, 6 do
            local raid = _G['RaidPullout'..i]
            local bg   = _G['RaidPullout'..i..'MenuBackdrop']
            if raid then
                raid:SetScale(.9)
                raid:SetBackdrop({ bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
                                   insets = {left = 2, right = 2, top = 2, bottom = 2} })
                raid:SetBackdropColor(0, 0, 0, .5)
                modSkin(raid, 22)
                modSkinDraw(raid, 'OVERLAY')
                modSkinColor(raid, .2, .2, .2)
                bg:Hide()
            end
            for k = 1, 5 do
                local bu   = _G['RaidPullout'..i..'Button'..k]
                local hp   = _G['RaidPullout'..i..'Button'..k..'HealthBar']
                local pp   = _G['RaidPullout'..i..'Button'..k..'ManaBar']
                local name = _G['RaidPullout'..i..'Button'..k..'Name']
                if bu then
                    bu:ClearAllPoints()
                    bu:SetPoint('TOP',
                                k == 1 and raid or _G['RaidPullout'..i..'Button'..(k-1)],
                                0,
                                k == 1 and -2 or -32)
                    bu:SetWidth(58)
                    bu:SetHeight(40) --!
                    local a = bu:GetRegions() a:Hide()

                    hp:SetStatusBarTexture(sb)
                    hp:SetHeight(18)
                    hp:SetFrameStrata'MEDIUM'
                    hp:SetBackdrop({ bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
                                     insets = {left = -1, right = -1, top = -1, bottom = -1} })
                    hp:SetBackdropColor(0, 0, 0, 1)
                    pp:SetBackdrop({ bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
                                     insets = {left = -1, right = -1, top = -1, bottom = -1} })
                    pp:SetBackdropColor(0, 0, 0, 1)

                    name:SetFont(STANDARD_TEXT_FONT, 11)
                    name:SetParent(hp)
                    name:ClearAllPoints() name:SetPoint('CENTER', hp)

                    for j = 1, 4 do
                        local icon = _G['RaidPullout'..i..'Button'..k..'Debuff'..j]
                        -- modSkin(icon, 13.5)
                    end
                end
            end
        end
    end

    local colour = function()
        for i = 1, 6 do
            for k = 1, 5 do
                local bu   = _G['RaidPullout'..i..'Button'..k]
                local hp   = _G['RaidPullout'..i..'Button'..k..'HealthBar']
                local name = _G['RaidPullout'..i..'Button'..k..'Name']
                if bu then
                    local r, g, b = name:GetTextColor() hp:SetStatusBarColor(r, g, b)
                    name:SetText(string.sub(name:GetText(), 1, 6))
                end
            end
        end
    end

    orig.RaidPullout_GenerateGroupFrame = RaidPullout_GenerateGroupFrame
    orig.RaidPullout_GenerateClassFrame = RaidPullout_GenerateClassFrame
    function RaidPullout_GenerateGroupFrame(f)
        orig.RaidPullout_GenerateGroupFrame() skin()
    end
    function RaidPullout_GenerateClassFrame(f)
        orig.RaidPullout_GenerateClassFrame() skin()
    end

    local f = CreateFrame'Frame'
    f:RegisterEvent'RAID_ROSTER_UPDATE'
    f:SetScript('OnEvent', function() skin() colour() end)

    local co = CreateFrame'Frame'
    co:RegisterEvent'UNIT_HEALTH' co:RegisterEvent'UNIT_AURA'
    co:SetScript('OnEvent', colour)

    --