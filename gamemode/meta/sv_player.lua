
local k_notify_massive = {}
function PLAYER:Notify(str, delay, dietime)
    if !k_notify_massive[self:EntIndex()..str] then
        k_notify_massive[self:EntIndex()..str] = {CurTime() + delay}
    end

    if k_notify_massive[self:EntIndex()..str][1] < CurTime() then
        self:SendLua([=[local a = vgui.Create("BREACH.TextScreen"); a:SetDT("]=]..str..[=[", ]=]..dietime..[=[)]=])
        k_notify_massive[self:EntIndex()..str] = {CurTime() + delay}
    end
end

local k_buffer  = {
    [1] = {'br_keycards_classic_lvl1', {1}},
    [2] = {'br_keycards_classic_lvl2', {1, 2}},
    [3] = {'br_keycards_classic_lvl3', {1, 2, 3}},
    [4] = {'br_keycards_classic_lvl4', {1, 2, 3, 4}},
    [5] = {'br_keycards_classic_lvl5', {1, 2, 3, 4, 5}},
    [6] = {'br_keycards_classic_consul', {1, 2, 3, 4, 5, 6}}
}

function PLAYER:HasKeyLevel(lvl)
    local status = false
    local aw = self:GetActiveWeapon() if !aw || !IsValid(aw) || aw.GetClass == nil then return false end
    if !aw.Deployed then return false end
    for i = 1, #k_buffer do
        if k_buffer[i][1] == aw:GetClass() then
            if table.HasValue(k_buffer[i][2], lvl) then
                status = true
                break
            end
        end
    end
    return status
end

local k_del_massive = {}
function ENTITY:EmitDelayedSound(snd, delay)
    if !k_del_massive[self:EntIndex()..snd] then
        k_del_massive[self:EntIndex()..snd] = {CurTime() + delay}
    end

    if k_del_massive[self:EntIndex()..snd][1] < CurTime() then
        self:EmitSound(snd)
        k_del_massive[self:EntIndex()..snd] = {CurTime() + delay}
    end
end

function PLAYER:EnableSpectator()
    self:StripWeapons()
    self:StripAmmo()

    self:SetTeam(TEAM_SPECTATOR)
    self:Spectate(OBS_MODE_FIXED)
    self:SetMoveType(MOVETYPE_NOCLIP)
    self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)

    self:SetNoDraw(true)
    self:SetNotSolid(true)
    self:DrawWorldModel(false)
    self:DrawShadow(false)
    self:SetNoTarget(true)
    self:GodEnable()
end

function PLAYER:DisableSpectator()
    self:SetTeam(TEAM_UNASSIGNED)
    self:SetMoveType(MOVETYPE_WALK)
    self:SetCollisionGroup(COLLISION_GROUP_NONE)

    self:SetNoDraw(false)
    self:SetNotSolid(false)
    self:DrawWorldModel(true)
    self:DrawShadow(false)
    self:SetNoTarget(false)
    self:GodDisable()
end
