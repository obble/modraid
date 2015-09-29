

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
                    _G['RaidGroup'..k..'Label']:SetScript('OnShow', function()
                        RaidPullout_GenerateGroupFrame() sort() end)
                end
            end
        end
    end

    local f = CreateFrame'Frame'  -- todo: slash that toggles auto-sort
    f:RegisterEvent'RAID_TARGET_UPDATE'
    f:RegisterEvent'RAID_ROSTER_UPDATE'    f:RegisterEvent'PARTY_MEMBERS_CHANGED'
    f:RegisterEvent'PLAYER_REGEN_DISABLED' f:RegisterEvent'PLAYER_REGEN_ENABLED'
    f:SetScript('OnEvent', spawn)

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

    spawn()


    --
