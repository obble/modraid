

    assert(IsAddOnLoaded'Blizzard_RaidUI', 'Blizzard Raid UI did not load first!')

    local _G = getfenv(0)
    local sb = [[Interface\AddOns\modui\modsb\texture\sb.tga]]
    local orig = {}

    local skin = function()
        for i = 1, 8 do
            local raid = _G['RaidPullout'..i]
            local bg   = _G['RaidPullout'..i..'MenuBackdrop']
            if raid then
                raid:SetScale(.9)
                if IsAddOnLoaded'modui' then
                    raid:SetBackdrop({ bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
                                       insets = {left = 2, right = 2, top = 2, bottom = 2} })
                    raid:SetBackdropColor(0, 0, 0, .5)
                    modSkin(raid, 22)
                    modSkinDraw(raid, 'OVERLAY')
                    modSkinColor(raid, .2, .2, .2)
                    bg:Hide()
                end
            end
            for k = 1, 5 do
                local bu   = _G['RaidPullout'..i..'Button'..k]
                local c    = _G['RaidPullout'..i..'Button'..k..'ClearButton']
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
                    bu:SetHeight(40)
                    local a = bu:GetRegions() a:Hide()

                    local t = hp:CreateFontString(nil, 'OVERLAY', nil, 7)
                    t:SetFont(STANDARD_TEXT_FONT, 18, 'OUTLINE')
                    t:SetText'>'
                    t:SetTextColor(0, 1, .3)
                    t:SetPoint('RIGHT', c, 'LEFT')
                    t:Hide()

                    c:SetWidth(58)
                    c:SetHeight(40)
                    c:SetScript('OnEnter', function() t:Show() RaidGroupButton_OnEnter() end)
                    c:SetScript('OnLeave', function() t:Hide() GameTooltip:Hide() end)

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

                    hp:EnableMouse(false) pp:EnableMouse(false)
                    for j = 1, 4 do
                        local icon = _G['RaidPullout'..i..'Button'..k..'Debuff'..j]
                        if j == 1 then
                            icon:ClearAllPoints()
                            icon:SetPoint('TOPLEFT', hp, 'TOPRIGHT', 5, 0)
                        end
                    end
                end
            end
        end
    end

    local colour = function()
        for i = 1, 8 do
            for k = 1, 5 do
                local bu   = _G['RaidPullout'..i..'Button'..k]
                local c    = _G['RaidPullout'..i..'Button'..k..'ClearButton']
                local hp   = _G['RaidPullout'..i..'Button'..k..'HealthBar']
                local name = _G['RaidPullout'..i..'Button'..k..'Name']
                if bu then
                    local r, g, b = name:GetTextColor() hp:SetStatusBarColor(r, g, b)
                    c:SetWidth(58)
                    c:SetHeight(40)
                    name:SetText(string.sub(name:GetText(), 1, 6))
                end
            end
        end
    end

    orig.RaidPullout_GenerateGroupFrame = RaidPullout_GenerateGroupFrame
    orig.RaidPullout_GenerateClassFrame = RaidPullout_GenerateClassFrame

    function RaidPullout_GenerateGroupFrame(f)
        orig.RaidPullout_GenerateGroupFrame() skin() colour()
    end
    function RaidPullout_GenerateClassFrame(f)
        orig.RaidPullout_GenerateClassFrame() skin() colour()
    end


    local f = CreateFrame'Frame'
    f:RegisterEvent'RAID_ROSTER_UPDATE' f:RegisterEvent'PARTY_MEMBERS_CHANGED'
    f:SetScript('OnEvent', function() skin() colour() end)

    local co = CreateFrame'Frame'
    co:RegisterEvent'UNIT_HEALTH' co:RegisterEvent'UNIT_AURA'
    co:SetScript('OnEvent', colour)

    --
