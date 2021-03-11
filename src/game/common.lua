param = {
    blue = {
        team = Game.TEAM.CT,
        model = Game.MODEL.SEAL,
        hp = 1000,
        armor = 1000,
        flinch = 1.0,
        knockback = 1.0
    },
    red = {
        team = Game.TEAM.TR,
        model = Game.MODEL.GUERILLA,
        hp = 1000,
        armor = 1000,
        flinch = 1.0,
        knockback = 1.0
    }
}

Timer = { valid = false, timer = 0 }

function Timer:Init()
    self.valid = false
    self.timer = 0
end

function Timer:IsValid()
    return self.valid
end

function Timer:Start(duration)
    self.valid = true
    self.timer = Game.GetTime() + duration
end

function Timer:IsElapsed()
    if self.valid == false then
        return false
    end

    return self.timer < Game.GetTime()
end

function Timer:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end


-- local keyboard = keyboard();

-- keyboard:bind("SHIFT+N", function ()

-- );


