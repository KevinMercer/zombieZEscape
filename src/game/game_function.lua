print("导入game_function.lua")
-- 游戏计时器类
Class("GameTimer", function(GameTimer)
    function GameTimer:constructor()
        self.valid = false
        self.timer = Game.GetTime()
    end

    --游戏计时器初始化函数
    function GameTimer:Init()
        self.valid = false
        self.timer = 0
    end

    --游戏计时器是否还有效
    function GameTimer:IsValid()
        return self.valid
    end

    --启动游戏计时器
    function GameTimer:Start(duration)
        self.valid = true
        self.timer = Game.GetTime() + duration
    end

    --游戏计时器是否失效
    function GameTimer:IsElapsed()
        if self.valid == false then
            return false
        end
        return self.timer < Game.GetTime()
    end

end)

--玩家进入观察者
function goToSpectator(player)
    local pUser = player.user
    if pUser.wait == true then
        pUser.respawnable = false
        player:Kill()
        player:Kill()
        player:Kill()
        player:Kill()
        pUser.firstJoin = true
        pUser.giveGunTime = nil
        currentRoundHumanPlayerList[player.index] = nil
        pUser.respawnable = false
    else
        pUser.respawnable = true
    end
end

--出生发枪
function giveInitialGun(player)
    if player == nil then
        return
    end
    local pUser = player.user
    if pUser.firstJoin == true then
        local SPM4 = Game.Weapon:CreateAndDrop(78, player.position)
        local SPM3 = Game.Weapon:CreateAndDrop(45, player.position)
        SPM3:AddClip1(999)
        SPM4.infiniteclip = true
        SPM3.infiniteclip = false
        pUser.firstJoin = false
    else
        returnWeapons(player)
    end

end

-- 武器掉落
function dropGun(call)

    if call then
        if validateGunsList ~= nil then
            local theCaller = Game.GetScriptCaller()
            if theCaller ~= nil then
                local weaponMaxNumber = ZCLOGLength(validateGunsList)
                local weaponNumber = math.random(1, weaponMaxNumber)
                local theGun = Game.Weapon:CreateAndDrop(validateGunsList[weaponNumber], theCaller.position)
                spWeapon(theGun)
            end
        end
    end

end

--归还主副武器
function returnWeapons(player)

    if player ~= nil then
        local pUser = player.user
        --主武器
        if pUser.lastPrimaryWeapon ~= nil then
            local theLastPrimaryWeapon = pUser.lastPrimaryWeapon
            local theWeaponId = 45
            if theLastPrimaryWeapon.weaponid ~= 0 then
                theWeaponId = theLastPrimaryWeapon.weaponid
            end
            local returnPrimaryWeapon = Game.Weapon:CreateAndDrop(theWeaponId, player.position)
            returnPrimaryWeapon.color = theLastPrimaryWeapon.color
            returnPrimaryWeapon.damage = theLastPrimaryWeapon.damage
            returnPrimaryWeapon.speed = theLastPrimaryWeapon.speed
            returnPrimaryWeapon.knockback = theLastPrimaryWeapon.knockback
            returnPrimaryWeapon.flinch = theLastPrimaryWeapon.flinch
            returnPrimaryWeapon.criticalrate = theLastPrimaryWeapon.criticalrate
            returnPrimaryWeapon.criticaldamage = theLastPrimaryWeapon.criticaldamage
            returnPrimaryWeapon.bloodsucking = theLastPrimaryWeapon.bloodsucking
            returnPrimaryWeapon.infiniteclip = theLastPrimaryWeapon.infiniteclip
            returnPrimaryWeapon:AddClip1(999)
        end
        --副武器
        if pUser.lastSecondaryWeapon ~= nil then
            local theLastSecondaryWeapon = pUser.lastSecondaryWeapon
            local theWeaponId = 78
            if theLastSecondaryWeapon.weaponid ~= 0 then
                theWeaponId = theLastSecondaryWeapon.weaponid
            end
            local returnSecondaryWeapon = Game.Weapon:CreateAndDrop(theWeaponId, player.position)
            returnSecondaryWeapon.color = theLastSecondaryWeapon.color
            returnSecondaryWeapon.damage = theLastSecondaryWeapon.damage
            returnSecondaryWeapon.speed = theLastSecondaryWeapon.speed
            returnSecondaryWeapon.knockback = theLastSecondaryWeapon.knockback
            returnSecondaryWeapon.flinch = theLastSecondaryWeapon.flinch
            returnSecondaryWeapon.criticalrate = theLastSecondaryWeapon.criticalrate
            returnSecondaryWeapon.criticaldamage = theLastSecondaryWeapon.criticaldamage
            returnSecondaryWeapon.bloodsucking = theLastSecondaryWeapon.bloodsucking
            returnSecondaryWeapon.infiniteclip = true
            returnSecondaryWeapon:AddClip1(999)
        end
    end

end

--播放惨叫
function playScreamSound()
    Game.SetTrigger("playScreamSound", true)
end

--初始化玩家
function InitPlayer(player)
    local pUser = player.user
    if pUser.zombie == true then
        -- playScreamSound()
        local heroZombieNumber = 3
        if pUser.evolution == true then
            heroZombieNumber = math.random(0, 9)
        end
        player.team = Game.TEAM.TR
        player:SetRenderFX(playerRenderFx.normal)
        pUser.renderFx = playerRenderFx.normal
        if player.model < 30 then
            local hpRate = 1
            local armorRate = 1
            currentRoundZombiePlayerList[player.index] = player
            currentRoundHumanPlayerList[player.index] = nil
            pUser.lastPrimaryWeapon = player:GetPrimaryWeapon() --记录上一局的主武器
            pUser.lastSecondaryWeapon = player:GetSecondaryWeapon() --记录上一局的副武器
            --尸变
            if heroZombieNumber <= 3 then
                --普通母体
                player.model = 30
            elseif heroZombieNumber <= 7 then
                --男英雄僵尸
                player.model = 41
                --暴虐钢骨
            else
                --女英雄僵尸
                player.model = 42
                --幻痛夜魔
            end
            local theZombieDatas = zombieTable[player.model - 29]
            if theZombieDatas == nil then
                theZombieDatas = zombieTable[1]
            end
            player.maxhealth = theZombieDatas.maxhealth
            if pUser.rehydration == true then
                player.maxhealth = player.maxhealth + 20000
            end
            player.maxarmor = theZombieDatas.maxarmor
            player.health = math.floor(player.maxhealth * hpRate)
            player.armor = math.floor(player.maxarmor * armorRate)
            player.flinch = theZombieDatas.flinch
            player.knockback = theZombieDatas.knockback
            player.maxspeed = theZombieDatas.maxspeed
            pUser.jumpRate = theZombieDatas.jumpRate
            pUser.speedRate = theZombieDatas.speedRate
            pUser.jumpLevel = theZombieDatas.jumpLevel
            pUser.resistance = theZombieDatas.resistance
            pUser.canIcraus = theZombieDatas.canIcraus
            pUser.hostMenu = true --母体菜单
            player:Signal(SignalToUI.infect) --发送感染信号
            player:Signal(theZombieDatas.skillOneSignal)
            player:Signal(theZombieDatas.skillTwoSignal)
        end
        --普通僵尸
    else
        if pUser.firstJoin == true or pUser.roundStartModelChange == true then
            if pUser.firstJoin == true then
                pUser.giveGunTime = Game.GetTime() + 0.2
            end
            player.model = 13
            pUser.roundStartModelChange = false
        end
        currentRoundZombiePlayerList[player.index] = nil
        currentRoundHumanPlayerList[player.index] = player
        player.model = 0
        player.team = Game.TEAM.CT
        player.maxhealth = 1000
        player.maxarmor = 1000
        if pUser.isHero == true then
            player.maxhealth = 10000
            player.maxarmor = 5000
            player.model = 12
            player:Signal(SignalToUI.chosenHero)
        end
        player.health = player.maxhealth
        player.armor = player.maxarmor
        pUser.zombieExclusiveSkill = 0
        player.knockback = 1.0
        player.maxspeed = 1.0
        pUser.jumpRate = 1.0
        pUser.speedRate = 1.0
        pUser.jumpLevel = 1
        pUser.resistance = 1
        pUser.canIcraus = false --普通僵尸伊卡洛斯
        pUser.hostMenu = false --母体菜单
        pUser.zombie = false
    end
end

--感染复活
function infectionRespawn(player)
    if player ~= nil then
        player:Respawn()
    end
end

--逃脱成功
function escapeSuccess(call)
    local exitGame = false
    if call then
        if state == STATE.PLAYING then
            if (scoreHuman.value + scoreZombie.value) >= scoreGoal.value or totalGameTimer:IsElapsed() then
                exitGame = true
            end
            scoreHuman.value = scoreHuman.value + 1
            Game.Rule:Win(Game.TEAM.CT, exitGame)
            state = STATE.END
            sendRoundEndSignal(true)
        end
    end
end

--僵尸触碰范围逃脱方块则逃脱失败
if escapeEntityBlock then
    function escapeEntityBlock:OnTouch(player)
        if player ~= nil then
            local pUser = player.user
            local exitGame = false
            if pUser.zombie == true then
                if state == STATE.PLAYING then
                    if (scoreHuman.value + scoreZombie.value) >= scoreGoal.value or totalGameTimer:IsElapsed() then
                        exitGame = true
                    end
                    scoreZombie.value = scoreZombie.value + 1
                    Game.Rule:Win(Game.TEAM.TR, exitGame)
                    state = STATE.END
                    sendRoundEndSignal(false)
                end
            end
        end
    end
end

--检测回合胜利标准
function checkWinCondition(time)
    --只有在游戏状态为正在游戏中才能判断是否胜利
    if state == STATE.PLAYING then
        local humanNumber, zombieNumber = getHumanLiveNumber()
        local exitGame = false

        -- humanNumber = 1
        -- zombieNumber = 1

        if humanNumber <= 0 then
            --人类全部被抓
            if ROUND_NEED_WIN == true then
                if scoreZombie.value >= scoreGoal.value or scoreHuman.value >= scoreGoal.value or totalGameTimer:IsElapsed() then
                    exitGame = true
                end
            else
                if (scoreHuman.value + scoreZombie.value) >= scoreGoal.value or totalGameTimer:IsElapsed() then
                    exitGame = true
                end
            end
            scoreZombie.value = scoreZombie.value + 1
            Game.Rule:Win(Game.TEAM.TR, exitGame)
            state = STATE.END
            sendRoundEndSignal(false)
        elseif zombieNumber <= 0 then
            --僵尸被打自闭全部退光
            if ROUND_NEED_WIN == true then
                if scoreHuman.value >= scoreGoal.value or scoreZombie.value >= scoreGoal.value or totalGameTimer:IsElapsed() then
                    exitGame = true
                end
            else
                if (scoreHuman.value + scoreZombie.value) >= scoreGoal.value or totalGameTimer:IsElapsed() then
                    exitGame = true
                end
            end
            scoreHuman.value = scoreHuman.value + 1
            Game.Rule:Win(Game.TEAM.CT, exitGame)
            state = STATE.END
            sendRoundEndSignal(true)
        elseif escapeTimer:IsElapsed() then
            --时间结束
            if ROUND_NEED_WIN then
                if scoreHuman.value >= scoreGoal.value or scoreZombie.value >= scoreGoal.value or totalGameTimer:IsElapsed() then
                    exitGame = true
                end
            else
                if (scoreHuman.value + scoreZombie.value) >= scoreGoal.value or totalGameTimer:IsElapsed() then
                    exitGame = true
                end
            end
            scoreZombie.value = scoreZombie.value + 1
            Game.Rule:Win(Game.TEAM.TR, exitGame)
            state = STATE.END
            sendRoundEndSignal(false)
        end

    end

end

--复活前往指定的位置
function respawnPositionRecover(player)
    local pUser = player.user
    if pUser.useInfectionPosition == true then
        if pUser.infectionPosition ~= nil then
            player.position = pUser.infectionPosition
            pUser.useInfectionPosition = false
            pUser.infectionPosition = nil
        end
    elseif pUser.useHostZombieRespawnPosition == true then
        player.position = pUser.hostZombieRespawnPosition
    elseif pUser.useHiddenRespawnPosition == true then
        if pUser.hiddenRespawnPosition ~= nil then
            player.position = pUser.hiddenRespawnPosition
            pUser.useHiddenRespawnPosition = false
            pUser.hiddenRespawnPosition = nil
        end
    else
        if pUser.detectionPosition ~= nil then
            player.position = pUser.detectionPosition
            pUser.useInfectionPosition = false
            pUser.useHiddenRespawnPosition = false
        end
    end
    -- player:Kill()
end

--魔改武器
function spWeapon(weapon)

    if weapon ~= nil then
        local theRandomNumber = math.random(0, 100)

        if theRandomNumber <= 50 then
            weapon.color = Game.WEAPONCOLOR.GREEN
            weapon.criticalrate = 0.1
            weapon.bloodsucking = 0.1
            weapon.criticaldamage = 1.2
        elseif theRandomNumber <= 75 then
            weapon.color = Game.WEAPONCOLOR.BLUE
            weapon.criticalrate = 0.2
            weapon.bloodsucking = 0.5
            weapon.criticaldamage = 1.4
        elseif theRandomNumber <= 90 then
            weapon.color = Game.WEAPONCOLOR.RED
            weapon.criticalrate = 0.3
            weapon.bloodsucking = 0.8
            weapon.criticaldamage = 1.6
        elseif theRandomNumber <= 97 then
            weapon.color = Game.WEAPONCOLOR.YELLOW
            weapon.criticalrate = 0.5
            weapon.bloodsucking = 1.0
            weapon.criticaldamage = 2.0
        else
            weapon.color = Game.WEAPONCOLOR.ORANGE
            weapon.criticalrate = 0.8
            weapon.bloodsucking = 1.5
            weapon.criticaldamage = 2.5
        end

        weapon:AddClip1(999)
        if weapon:GetWeaponType() == Game.WEAPONTYPE.PISTOL then
            weapon.infiniteclip = true
        end

    end

end

--魔改人物属性
function changeSpeed(call)

    if call then
        local tempPlayer = Game.GetTriggerEntity()
        if tempPlayer:IsPlayer() then
            local player = tempPlayer:ToPlayer()
            player.maxspeed = 1.2
            player.gravity = 0.725
            player.infiniteclip = true
        end
    end


end

--玩家地速获取并处理
function getSpeed(player)
    local pUser = player.user
    if pUser.zombie == true then
        --if player.velocity.z == 0 then
        local theSpeedRate = pUser.speedRate
        if math.sqrt((player.velocity.x * player.velocity.x) + (player.velocity.y * player.velocity.y)) <= 290 * theSpeedRate then
            player.velocity = { x = player.velocity.x * theSpeedRate, y = player.velocity.y * theSpeedRate }
        end
        --end
        if player.velocity.z > 200 then
            if pUser.zombieJump == nil or pUser.zombieJump == false then
                pUser.zombieJump = true
                player.velocity = { z = 200 * pUser.jumpRate }
            end
        elseif player.velocity.z == 0 then
            pUser.zombieJump = false
        end
    end
    local v
    v = math.sqrt((player.velocity.x * player.velocity.x) + (player.velocity.y * player.velocity.y))
    if (v * 10) % 10 >= 5 then
        v = v + 1
    end
    if v >= 9999 then
        v = 9999
    end
    return math.floor(v)
end

--召唤测试怪物
function summonMonster(call)

    if call then
        local callPosition = Game.GetScriptCaller().position
        local monster = Game.Monster:Create(Game.MONSTERTYPE.NORMAL0, callPosition)

        if monster then
            monster.health = 10000
            monster.damage = 0
            monster.speed = 0.2
            monster.applyKnockback = true
        end

    end

end

--启动母体倒计时
function hostZombieTimer(condition)
    Game.SetTrigger("hostZombieTimer", condition)
end

--代码击杀测试
function codeKill(call)
    if call then
        local tempPlayer = Game.GetTriggerEntity()
        if tempPlayer:IsPlayer() then
            local player = tempPlayer:ToPlayer()
            player:Kill()
        end
    end
end

--定义母体数量
function CalcMaxZombie()
    local numPlr = 0
    for i = 1, 24 do
        local p = players[i]
        if p ~= nil then
            numPlr = numPlr + 1
        end
    end

    if numPlr > 20 then
        return 3
    elseif numPlr > 10 then
        return 2
    else
        return 1
    end
end

--生成母体
function showHostZombie(call)
    if call then
        playScreamSound()
        local list = {}
        for i = 1, 24 do
            list[i] = i
        end
        for i = 1, 24 do
            local n = math.random(1, 24)
            local temp = list[n]
            list[n] = list[i]
            list[i] = temp
        end

        local numZombie = 0
        local maxZombie = CalcMaxZombie()
        for i = 1, 24 do
            local index = list[i]
            if players[index] ~= nil then
                players[index].user.zombie = true
                InitPlayer(players[index])
                numZombie = numZombie + 1
            end

            if numZombie == maxZombie then
                return
            end
        end
        hostShow = true
    end
end

-- 选择性复制技能表
function copyTableExcludeTable(copy, exclude)
    local copyType = type(copy)
    local excludeType = type(exclude)
    if copyType ~= "table" or excludeType ~= "table" then
        return nil
    end
    local result = copyTable(copy)
    local copyLength = ZCLOGLength(copy)
    local excludeLength = ZCLOGLength(exclude)
    local removedNumbers = 0
    for i = 1, copyLength do
        if excludeLength > 0 then
            local removed = false
            for j = 1, ZCLOGLength(exclude) do
                if copy[i][4] == exclude[j][4] and removed == false then
                    if result[i - removedNumbers][5] == 1 then
                        table.remove(result, i - removedNumbers)
                        table.remove(result, i - removedNumbers)
                        removedNumbers = removedNumbers + 2
                    elseif result[i - removedNumbers][5] == -1 then
                        table.remove(result, i - removedNumbers - 1)
                        table.remove(result, i - removedNumbers - 1)
                        removedNumbers = removedNumbers + 2
                    else
                        table.remove(result, i - removedNumbers)
                        removedNumbers = removedNumbers + 1
                    end
                    removed = true
                end
            end
        end
    end
    return result
end

--增加经验值
function addPlayerExp(player, theExp)
    if player == nil or theExp == nil then
        return
    end
    local pUser = player.user
    if pUser.currentExp == nil then
        pUser.currentExp = 0
    end
    if pUser.currentLevel == nil then
        pUser.currentLevel = 1
    end
    pUser.currentExp = pUser.currentExp + theExp
    if pUser.currentExp >= PLAYER_LEVEL_UP_EXP then
        pUser.currentExp = pUser.currentExp - PLAYER_LEVEL_UP_EXP
        pUser.currentLevel = pUser.currentLevel + 1
        pUser.skillPoint = pUser.skillPoint + 1
        if pUser.skillPoint >= 10 then
            pUser.skillPoint = 10
        end
    end
    if pUser.currentLevel <= 10 then
        player:SetLevelUI(pUser.currentLevel, calculateExpPercent(pUser.currentExp))
    else
        player:SetLevelUI(10, 1)
    end
    if skillPointTable[player.index] ~= nil then
        skillPointTable[player.index].value = pUser.skillPoint
    end
end

--计算经验条百分比
function calculateExpPercent(theExp)
    return theExp / PLAYER_LEVEL_UP_EXP or 0
end

--获得加速后的还原速度
function speedReduction(player, reduce)
    if player ~= nil then
        local speedRestore = player.maxspeed - reduce
        if speedRestore <= 1 then
            speedRestore = 1
        end
        player.maxspeed = speedRestore
    end
end
--获得减速后的还原速度
function speedIncrease(player, append)
    if player ~= nil then
        local speedRestore = player.maxspeed + append
        if speedRestore <= 1 then
            speedRestore = 1
        end
        player.maxspeed = speedRestore
    end
end

--鬼手
function playerSpeedStatic(player)
    if player ~= nil then
        player.velocity = { x = 0, y = 0 }
    end
end

--冲击
function playerSpeedImpact(player)
    if player ~= nil then
        player.velocity = { x = player.velocity.x * 0.3, y = player.velocity.y * 0.3 }
    end
end

--获得当前局人类数量
function getHumanLiveNumber()
    local humanNumber = 0
    local zombieNumber = 0
    for i = 1, 24 do
        if players[i] ~= nil then
            local player = players[i]
            local pUser = player.user
            if pUser.respawnable == true then
                if pUser.zombie == true then
                    zombieNumber = zombieNumber + 1
                else
                    humanNumber = humanNumber + 1
                end
            end
        end
    end

    return humanNumber, zombieNumber
end

--发送回合结束信号
function sendRoundEndSignal(condition)
    --condition值true为逃脱成功false为逃脱失败
    for i = 1, 24 do
        local p = players[i]
        if p ~= nil then
            local pUser = p.user
            p.team = Game.TEAM.CT
            if pUser.zombie == false then
                pUser.lastPrimaryWeapon = p:GetPrimaryWeapon() --记录上一局的主武器
                pUser.lastSecondaryWeapon = p:GetSecondaryWeapon() --记录上一局的副武器
            end
            pUser.zombie = false
            pUser.spawnable = true
            pUser.wait = false
            if condition == true then
                p:Signal(SignalToUI.escapeSuccess)
            else
                p:Signal(SignalToUI.escapeFail)
            end
        end
    end
end

--场景重置
function resetScene()
    Game.SetTrigger("resetScene", true)
end

--玩家集结
function playerGather(call)
    if call then
        resetScene()
        for i = 1, 24 do
            local human = currentRoundHumanPlayerList[i]
            local zombie = currentRoundZombiePlayerList[i]
            if human ~= nil then
                if humanGatherEntityBlock then
                    human.position = humanGatherEntityBlock.position
                end
            end
            if zombie ~= nil then
                if hostRespawnEntityBlock then
                    zombie.position = hostRespawnEntityBlock.position
                end
            end
        end
    end
end

--播放生化大逃杀准备音乐
function playZEMusic()
    Game.SetTrigger("playZEMusic", true)
end

