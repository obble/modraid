

    assert(IsAddOnLoaded'Blizzard_RaidUI', 'Blizzard Raid UI did not load first!')

    local _G = getfenv(0)
    local x  = 2

    local sort = function()
        local r = 1
        for i = 1, 8 do
            local f = _G['RaidPullout'..i]
            if f then
                f:ClearAllPoints()
                if i == 1 then
                    f:SetPoint('TOPRIGHT', -60, -UIParent:GetHeight()/3)
                elseif r == x then
                    f:SetPoint('TOPRIGHT', _G['RaidPullout'..(i - x)], 'TOPLEFT', -20, 0)
                    r = 1
                else
                    f:SetPoint('TOPLEFT', _G['RaidPullout'..(i - 1)], 'BOTTOMLEFT', 0, -20)
                    r = r + 1
                end
            end
        end
    end

    local spawn = function()
        for i = 1,40 do
            if i <= GetNumRaidMembers() then
                local _, _, subgroup = GetRaidRosterInfo(i)
                for k = 1, subgroup do
                    local l = _G['RaidGroup'..k..'Label']
                    l:SetScript('OnShow', function()
                        RaidPullout_GenerateGroupFrame() sort() end)
                    l:Hide() l:Show()
                end
            end
        end
    end

    local despawn = function()
        for i = 1, 8 do
            local f = _G['RaidPullout'..i]
            if f then f:Hide() end
        end
    end

    local e = CreateFrame'Frame'    -- BUILD MORE FRAMES IF 1 IS SHOWN
    function e:Enable()
        e:RegisterEvent'RAID_ROSTER_UPDATE' e:RegisterEvent'PARTY_MEMBERS_CHANGED'
        e:SetScript('OnEvent', function()
            for i = 1, 8 do
                local f = _G['RaidPullout'..i] if f and f:IsShown() then spawn() end
            end
        end)
    end
    function e:Disable() e:UnregisterAllEvents() end

    local enable = CreateFrame('Button', 'modRaidSpawn', RaidFrame, 'UIPanelButtonTemplate')
    enable:SetWidth(100)
    enable:SetHeight(20)
    enable:SetText'Spawn Raid'
    enable:SetFont(STANDARD_TEXT_FONT, 10)
    enable:SetPoint('BOTTOMRIGHT', RaidFrameRaidInfoButton, 'TOPRIGHT', -22, 2)

    local disable = CreateFrame('Button', 'modRaidSpawn', RaidFrame, 'UIPanelButtonTemplate')
    disable:SetWidth(100)
    disable:SetHeight(20)
    disable:SetText'Despawn Raid'
    disable:SetFont(STANDARD_TEXT_FONT, 10)
    disable:SetPoint('BOTTOMRIGHT', RaidFrameRaidInfoButton, 'TOPRIGHT', -22, 2)
    disable:Hide()

    enable:SetScript('OnClick', function() spawn() e:Enable() this:Hide() disable:Show() end)
    disable:SetScript('OnClick', function() despawn() e:Disable() this:Hide() enable:Show() end)

    for i = 1, 8 do
        local f = _G['RaidPullout'..i]
        if f then
            _G['RaidPullout1']:SetScript('OnDragStart', function()
                this:SetFrameStrata'DIALOG' this:StartMoving()
                if IsShiftKeyDown() then f:StartMoving() end
            end)
            _G['RaidPullout1']:SetScript('OnDragStop', function()
                this:SetFrameStrata'BACKGROUND' this:StopMovingOrSizing() ValidateFramePosition(this, 25)
                f:StopMovingOrSizing() ValidateFramePosition(f, 25)
            end)
        end
    end

    SLASH_RAIDSPAWN1 = '/spawn'
    SlashCmdList['RAIDSPAWN'] = function(arg)
        if tonumber(arg) then
            x = min(max(floor(tonumber(arg)), 1), 12)
            print('modRaid: Pullout spawns with '..x..' frame(s) per column.')
        else
            print'modRaid spawn usage:'
            print'|cffffffff/spawn 1-12|r — Set max frames spawned per column.'
        end
        sort()
    end

    --
