

    assert(IsAddOnLoaded'Blizzard_RaidUI', 'Blizzard Raid UI did not load first!')

    local _G = getfenv(0)
    local x  = 3

    local spawn = function()
        local r = 1
        for i = 1, 6 do
            local f = _G['RaidPullout'..i]
            if f then
                if not id then      -- todo: AUTO_GENERATE FRAMES ON RAID ENTER
                    local id = CreateFrame'Frame'
                    id:SetScript('OnLoad', function() id:SetID(i) RaidPullout_GenerateGroupFrame() end)
                end

                f:ClearAllPoints()
                if i == 1 then
                    f:SetPoint('TOPRIGHT', -50, -UIParent:GetHeight()/3)
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

--    local f = CreateFrame'Frame'  -- todo: slash that toggles auto-sort 
--    f:RegisterEvent'RAID_ROSTER_UPDATE'    f:RegisterEvent'PARTY_MEMBERS_CHANGED'
--    f:RegisterEvent'PLAYER_REGEN_DISABLED' f:RegisterEvent'PLAYER_REGEN_ENABLED'
--    f:SetScript('OnEvent', spawn)

    SLASH_RAIDSPAWN1 = '/spawn'
    SlashCmdList['RAIDSPAWN'] = function(arg)
        if tonumber(arg) then
            x = min(max(floor(tonumber(arg)), 1), 12)
            print('modRaid: Pullout spawns with '..x..' frame(s) per column.')
        else
            print'modRaid spawn usage:'
            print'|cffffffff/spawn 1-12|r — Set max frames spawned per column.'
        end
        spawn()
    end


    --
