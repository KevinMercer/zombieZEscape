print("导入game_rule.lua")
--初始游戏设置
Game.Rule.respawnable = gameInitializeData.respawnable
Game.Rule.respawnTime = gameInitializeData.respawnTime
Game.Rule.enemyfire = gameInitializeData.enemyfire
Game.Rule.friendlyfire = gameInitializeData.friendlyfire
Game.Rule.breakable = gameInitializeData.breakable

-- 同步变量
scoreGoal = Game.SyncValue:Create('goal') --总回合
scoreHuman = Game.SyncValue:Create("human") --人类获胜回合
scoreZombie = Game.SyncValue:Create("zombie") --僵尸获胜回合
scoreGoal.value = gameInitializeData.totalRoundNumber -- 总回合值
scoreHuman.value = 0 -- 人类获胜回合值
scoreZombie.value = 0 -- 僵尸获胜回合值
speedPanelTable = {} --速度栏表
timePanel = Game.SyncValue:Create('timePanel') --时间栏
damagePanelTable = {} --伤害栏表
skillPointTable = {} --技能点表

-- 游戏初始值设定
READY_TIME = gameInitializeData.readyTime -- 游戏准备时间(母体出现时间)
ROUND_TIME = gameInitializeData.roundTime -- 每回合持续时间
TOTAL_GAME_TIME = gameInitializeData.totalGameTime -- 总游戏时间
ROUND_NEED_WIN = gameInitializeData.roundNeedWin -- 是否只计算胜利回合

-- 一些计时器的定义
roundTimer = GameTimer() -- 每回合计时器
escapeTimer = GameTimer() -- 逃脱计时器
totalGameTimer = GameTimer() -- 总游戏时长计时器
totalGameTimer:Start(TOTAL_GAME_TIME) -- 总游戏时长计时器开始启动

--人类技能在回合开始前不能使用
theHumanSkillCDTime = Game.GetTime()

--母体已经出现后人类不能中途加入复活
hostShow = false

--升级所需要的经验
PLAYER_LEVEL_UP_EXP = gameInitializeData.playerLevelUpExp

--定义回合信息
state = STATE.READY --回合状态
roundEndTime = nil --回合结束时间
currentRoundHumanPlayerList = {} --本回合目前人类玩家列表
currentRoundZombiePlayerList = {} --本回合目前僵尸玩家列表

-- 玩家表
players = {}
for i = 1, 24 do
    players[i] = nil
end

--游戏规则
--玩家断开连接
function Game.Rule:OnPlayerDisconnect(player)
    local pUser = player.user
    local theIndex = player.index
    players[theIndex] = nil
    speedPanelTable[theIndex] = nil
    damagePanelTable[theIndex] = nil
    skillPointTable[theIndex] = nil
    if pUser.zombie == true then
        currentRoundZombiePlayerList[theIndex] = nil
    else
        currentRoundHumanPlayerList[theIndex] = nil
    end
end

--游戏更新
function Game.Rule:OnUpdate (time)

    -- 没次游戏更新都重置一下游戏规则避免外挂捣乱破坏游戏规则
    Game.Rule.respawnable = gameInitializeData.respawnable
    Game.Rule.respawnTime = gameInitializeData.respawnTime
    Game.Rule.enemyfire = gameInitializeData.enemyfire
    Game.Rule.friendlyfire = gameInitializeData.friendlyfire
    Game.Rule.breakable = gameInitializeData.breakable

    --玩家信息
    for i = 1, 24 do
        if players[i] then

            --通用模块
            local player = players[i]
            local pUser = players[i].user

            --发枪
            if pUser.firstJoin == true then
                if pUser.giveGunTime ~= nil and pUser.giveGunTime <= time then
                    pUser.giveGunTime = nil
                    giveInitialGun(player)
                end
            end

            --玩家地速开始
            pUser.speed = getSpeed(player)
            if speedPanelTable[i] ~= nil then
                speedPanelTable[i].value = getSpeed(player)
            end

            --玩家地速结束

            --致命打击结束
            if pUser.criticaling == true then
                if pUser.criticalDurationTime <= time then
                    pUser.criticaling = false
                    player:SetRenderFX(playerRenderFx.normal)
                    pUser.renderFx = playerRenderFx.normal
                end
            end
            --极速飞奔结束
            if pUser.sprinting == true and pUser.speedRateBeforeSprint ~= nil then
                if pUser.sprintDurationTime <= time then
                    pUser.sprinting = false
                    speedReduction(player, 0.2)
                    pUser.speedRateBeforeSprint = nil
                    player:SetRenderFX(playerRenderFx.normal)
                    pUser.renderFx = playerRenderFx.normal
                end
            end

        end
    end
    --玩家信息结束

    --僵尸模块
    for i = 1, 24 do
        if currentRoundZombiePlayerList[i] ~= nil then
            local player = currentRoundZombiePlayerList[i]
            local pUser = player.user
            --僵尸模块
            if pUser.zombie == true then
                --二段跳开始
                if pUser.jumpLevel ~= nil and pUser.jumpLevel > 1 then
                    if player.velocity.z == 0 then
                        pUser.jumped = 0    --落地重置
                        pUser.isUp = false
                    else
                        if player.velocity.z > 0 then
                            pUser.isUp = true
                        end
                        if pUser.jumped == 0 then
                            --但没有计算第一次跳跃
                            pUser.jumped = 1
                            pUser.jumpCD = time + 0.2
                        end
                    end
                end
                --二段跳结束

                --伊卡洛斯开始
                if pUser.canIcraus and pUser.zombie then

                    if player.velocity.z == 0 then

                        pUser.icarus = true --落地重置
                        pUser.isUp = false
                        if not pUser.icarusCDMark then
                            pUser.icarusCDMark = true
                            pUser.icarusCD = time + 3
                        end
                    else
                        if player.velocity.z > 0 then
                            pUser.isUp = true
                        end
                    end
                end
                --伊卡洛斯结束

                --呼吸回血
                if pUser.recover and pUser.zombie then
                    if player.health <= player.maxhealth and pUser.recoverTime ~= nil and pUser.recoverTime <= time then
                        if player.health + 500 <= player.maxhealth then
                            player.health = player.health + 500
                        else
                            player.health = player.maxhealth
                        end
                        pUser.recoverTime = time + 1
                    end
                end
                --呼吸回血结束

                --恢复玩家渲染方式
                if pUser.renderFx ~= playerRenderFx.normal then
                    if pUser.zombie == true and pUser.zombieExclusiveSkillDuration ~= nil and pUser.zombieExclusiveSkillDuration <= time then
                        player:SetRenderFX(playerRenderFx.normal)
                        pUser.renderFx = playerRenderFx.normal
                        player:Signal(SignalToUI.modelRestore)
                        if pUser.zombieExclusiveSkill == 36 then
                            player.knockback = 1.5
                        end
                    else
                    end
                end

                --芭比隐身
                if pUser.zombieExclusiveSkill == 31 then
                    if pUser.zombieExclusiveSkillDuration ~= nil and pUser.zombieExclusiveSkillDuration >= time then
                        if pUser.speed <= 150 then
                            player:SetRenderFX(playerRenderFx.sneak)
                            pUser.renderFx = playerRenderFx.sneak
                            player:Signal(SignalToUI.gKeyUsed)
                        else
                            player:SetRenderFX(playerRenderFx.normal)
                            pUser.renderFx = playerRenderFx.normal
                            player:Signal(SignalToUI.modelRestore)
                        end
                    end
                end
                --芭比隐身结束
                --巫蛊术尸恢复生命
                if pUser.zombieExclusiveSkill == 34 then
                    if pUser.zombieExclusiveSkillDuration ~= nil and pUser.zombieExclusiveSkillDuration >= time then
                        if player.health + 50 >= player.maxhealth then
                            player.health = player.maxhealth
                        else
                            player.health = player.health + 50
                        end
                    end
                end
                --巫蛊术尸恢复生命结束

                --接触感染
                if pUser.touchInfect == true then
                    for j = 1, 24 do
                        local touchHuman = currentRoundHumanPlayerList[j]
                        if touchHuman ~= nil then
                            local touchHumanUser = touchHuman.user
                            if touchHuman.position.x == player.position.x and touchHuman.position.y == player.position.y and (touchHuman.position.z == player.position.z or touchHuman.position.z == (player.position.z + 1)) then
                                touchHumanUser.zombie = true
                                touchHumanUser.useInfectionPosition = true
                                touchHumanUser.infectionPosition = touchHuman.position
                                touchHuman:Kill()
                                touchHuman:Kill()
                                touchHuman:Kill()
                                touchHuman:Kill()
                                touchHuman:Respawn()
                            end
                        end
                    end
                end
                --接触感染结束

                --免死开始
                if pUser.undying == true and pUser.undyingTime <= time then
                    player:Signal(SignalToUI.undyingGetControl)
                    pUser.undying = false
                end
                --免死结束
            end
            --僵尸模块结束
        end
    end
    --僵尸模块结束

    --回合信息

    --确定回合时间
    if state == STATE.READY then
        if roundTimer:IsElapsed() then
            escapeTimer:Start(ROUND_TIME)
            roundEndTime = time + ROUND_TIME
            state = STATE.PLAYING
        end
    end

    --倒计时
    if roundEndTime ~= nil and roundEndTime >= time then
        timePanel.value = math.floor(roundEndTime - time)
    else
        timePanel.value = gameInitializeData.roundTime
    end

    --检查胜利机制
    if state == STATE.PLAYING then
        checkWinCondition(time)
    end


end

--玩家连接
function Game.Rule:OnPlayerConnect(player)
    local theIndex = player.index
    local pUser = player.user
    local gameTime = Game.GetTime()
    player.team = Game.TEAM.CT
    pUser.zombie = false
    pUser.spawnable = true
    pUser.wait = false
    pUser.static = true --是否静止
    pUser.staticTime = Game.GetTime() + 2 --静止时间
    pUser.useInfectionPosition = false
    pUser.useHiddenRespawnPosition = false
    pUser.useHostZombieRespawnPosition = false
    pUser.infectionPosition = nil
    pUser.lastRecordPosition = nil
    pUser.detectionPosition = nil
    pUser.hiddenRespawnPosition = nil
    if hostRespawnEntityBlock then
        pUser.hostZombieRespawnPosition = hostRespawnEntityBlock.position
    end
    pUser.sprintDurationTime = gameTime
    pUser.criticalDurationTime = gameTime
    pUser.sprintCoolDownTime = theHumanSkillCDTime
    pUser.criticalCoolDownTime = theHumanSkillCDTime
    pUser.currentLevel = 1 --等级
    pUser.currentExp = 0 --经验值
    pUser.skillPoint = 1 --当前技能点
    pUser.currentSkillNumber = 0
    pUser.zombieSkillPoint = false --false获取人类技能 true获取僵尸技能

    player:SetLevelUI(pUser.currentLevel, calculateExpPercent(pUser.currentExp))
    players[theIndex] = player
    speedPanelTable[theIndex] = Game.SyncValue:Create("speedPanel" .. tostring(theIndex))
    damagePanelTable[theIndex] = Game.SyncValue:Create("damagePanel" .. tostring(theIndex))
    skillPointTable[theIndex] = Game.SyncValue:Create("skillPoint" .. tostring(theIndex))
end

--玩家连接后初次出生
function Game.Rule:OnPlayerJoiningSpawn(player)

    local pUser = player.user
    local gameTime = Game.GetTime()

    --初次连接属性
    player.team = 2
    pUser.static = true --是否静止
    pUser.staticTime = gameTime + 2 --静止时间

    --基础属性表
    pUser.speedRate = 1.0 --僵尸模型速度倍率 数值越高 速度越快
    pUser.zombieJump = false --僵尸跳跃(只在第一次z轴速度大于0时生效)
    pUser.jumpRate = 1.0 --跳跃倍率 数值越低 跳跃越强
    pUser.jumpLevel = 1 --跳跃等级 多段跳
    pUser.jumped = 0 --是否跳跃
    pUser.jumpCD = gameTime --跳跃冷却
    pUser.isUp = false --是否上升
    pUser.viewToggle = true --视角开关
    pUser.canIcraus = false --是否拥有伊卡洛斯技能
    pUser.icarus = true --是否达成伊卡洛斯条件
    pUser.icarusCDMark = true --伊卡洛斯是否冷却
    pUser.icarusCD = gameTime --伊卡洛斯冷却时间
    pUser.lastAttackTime = gameTime --最后一次受击时间
    pUser.recoverTime = player.user.lastAttackTime + 5 --再生时间
    pUser.resistance = 1.0 --伤害值比例
    pUser.damageRate = 1.0

    --特征表
    pUser.infectionPosition = nil --被感染的位置
    pUser.useInfectionPosition = false --是否使用感染复活
    pUser.lastRecordPosition = nil --记录点位置
    pUser.renderFx = 0 --模型渲染模式
    pUser.lastKillerName = nil --上次击杀你的对手名称
    pUser.isHero = false --是否是英雄

    --技能表
    pUser.humanSkillTable = {} --当前拥有的人类技能表
    pUser.zombieSkillTable = {} --当前拥有的僵尸技能表

    --人类技能属性
    pUser.sneakReload = false --透明换弹
    pUser.edge = false --利刃
    pUser.backClip = false --备弹补充(无限备弹)
    pUser.clipRecycle = false --特殊子弹回收
    pUser.kangaroo = false --袋鼠
    pUser.cheetah = false --猎豹
    pUser.quickReload = false --高速填装
    pUser.hero = false --英雄出现
    pUser.assault = false --正面突击
    pUser.forward = false --冲锋推进
    pUser.sprint = false --极速飞奔
    pUser.sprinting = false --极速飞奔激活
    pUser.sprintDurationTime = gameTime --极速飞奔持续时间
    pUser.sprintCoolDownTime = gameTime --极速飞奔冷却时间
    pUser.critical = false --致命打击
    pUser.criticaling = false --致命打击激活
    pUser.criticalDurationTime = gameTime --致命打击持续时间
    pUser.criticalCoolDownTime = gameTime --致命打击冷却时间
    pUser.shooter = false --神枪手

    --僵尸技能属性
    pUser.recover = false --hpPlus恢复强化
    pUser.ironChest = false --钢铁铠甲
    pUser.ironHelmet = false --钢铁头盔
    pUser.ironClaw = false --合金利爪
    pUser.touchInfect = false --接触感染
    pUser.mammoth = false --猛犸
    pUser.evolution = false --进化论
    pUser.thorns = false --deflectArmor倾斜装甲
    pUser.rehydration = false --生命补液
    pUser.adaptability = false --适应力
    pUser.sufferMemory = false --痛苦记忆
    pUser.repair = false --组织再生

    --僵尸专属技能
    pUser.zombieExclusiveSkill = 0 --数值对应模型枚举整数
    pUser.zombieExclusiveSkillDuration = gameTime
    pUser.zombieExclusiveSkillCDTime = gameTime
    --二段跳:所有女性僵尸角色通用技能 跳跃后可以在空中再跳跃一次
    --伊卡洛斯:所有男性僵尸角色通用技能 持续按住跳跃键可在跳跃后进行小段距离的高速滑翔
    --普通僵尸、迷雾鬼影减伤 硬化:一段时间减伤30%伤害与其他减伤方式按乘法算式叠加
    --暗影芭比 潜伏:移动速度低于150时模型隐形
    --痛苦女王、追猎傀儡、断翼恶灵弹跳 飞跃:瞬间获得较高的跳跃速度
    --憎恶屠夫 鬼手:定身击败你的对手3秒
    --恶魔猎手 坚定向前:一段时间获得极大幅度的抗击退能力
    --巫蛊术尸 治愈:持续回复一定的生命值
    --送葬者 冲击:减速击败你的对手8秒
    --恶魔之子 震荡:缴械击败你的对手
    --嗜血女妖 诱捕:击败你的对手将被传送至你死亡的位置
    --暴虐钢骨 免死:死亡替换为眩晕8秒
    --幻痛夜魔 缠身:被玩家击杀后复活至击杀你的玩家的位置
    --腐化禁卫、爆弹狂魔、赤炎恶鬼 反馈:弹飞杀死你的对手


    pUser.firstJoin = true --是否首次进入游戏
    pUser.giveGunTime = gameTime + 0.2 --发枪时间
    pUser.roundStartModelChange = false --是否属于回合开始，如果是就要给小刀

    if roundTimer:IsElapsed() == true or hostShow then
        pUser.wait = true --是否让玩家等待
    else
        pUser.wait = false --是否让玩家等待
    end
    pUser.respawnable = true --是否允许复活
    --初次连接属性结束
    goToSpectator(player)

end

--玩家出生
function Game.Rule:OnPlayerSpawn (player)
    InitPlayer(player)
    respawnPositionRecover(player)
    goToSpectator(player)
end

--玩家死亡
function Game.Rule:OnPlayerKilled(victim, killer)
    if victim == nil then
        return
    end

    if killer == nil then
        victim:Respawn()
    else
        local gameTime = Game.GetTime()
        local vUser = victim.user
        local kUser = killer.user
        local killerName = killer.name
        --记录上一个杀死你的人名
        vUser.lastKillerName = killerName
        if kUser.zombie == true then
            vUser.infectionPosition = victim.position
            vUser.useInfectionPosition = true
            vUser.zombie = true
            vUser.hostMenu = true
        elseif vUser.zombie == true then
            if vUser.renderFx == playerRenderFx.colorEx then
                if vUser.zombieExclusiveSkill == 32 then
                    --鬼手
                    --kUser.static = true
                    --kUser.staticTime = gameTime + 3
                    kUser.Signal(SignalToUI.speedChangedGhostHand)
                elseif vUser.zombieExclusiveSkill == 35 then
                    --震荡
                    killer:RemoveWeapon()
                elseif vUser.zombieExclusiveSkill == 37 then
                    --冲击
                    --kUser.speedImpact = true
                    --kUser.speedImpactTime = gameTime + 8
                    kUser.Signal(SignalToUI.speedChangedImpact)
                elseif vUser.zombieExclusiveSkill == 38 then
                    --诱捕
                    killer.position = victim.position
                elseif vUser.zombieExclusiveSkill == 44 or vUser.zombieExclusiveSkill == 46 then
                    --反馈
                    killer.velocity = { x = 0, y = 0, z = 5000 }
                elseif vUser.zombieExclusiveSkill == 35 then
                    --缠身
                    vUser.useHiddenRespawnPosition = true
                    vUser.hiddenRespawnPosition = killer.position
                end
            end
        end
        --僵尸报复结束
        victim:Respawn()
    end

end

--回合开始
function Game.Rule:OnRoundStart()
    hostShow = false
    roundTimer:Start(READY_TIME)
    state = STATE.READY
    roundEndTime = nil
    for i = 1, 24 do
        local p = players[i]
        if p ~= nil then
            local pUser = p.user
            p:Signal(SignalToUI.rounderReset)
            p.team = Game.TEAM.CT
            pUser.zombie = false
            pUser.spawnable = true
            pUser.wait = false
            pUser.static = true --是否静止
            pUser.staticTime = Game.GetTime() + 2 --静止时间
            pUser.useInfectionPosition = false
            pUser.infectionPosition = nil
            pUser.lastRecordPosition = nil
            pUser.detectionPosition = nil
            pUser.roundStartModelChange = true
            pUser.giveGunTime = Game.GetTime() + 2
        end
    end
end

--回合开始代码执行结束
function Game.Rule.OnRoundStartFinished()
    state = STATE.READY
    playZEMusic()
    hostZombieTimer(true)
    roundEndTime = nil
    local gameTime = Game.GetTime()
    theHumanSkillCDTime = gameTime + READY_TIME
    for i = 1, 24 do
        local p = players[i]
        if p ~= nil then
            local pUser = p.user
            p:Signal(SignalToUI.rounderReset)
            pUser.sprintDurationTime = gameTime
            pUser.criticalDurationTime = gameTime
            pUser.sprintCoolDownTime = theHumanSkillCDTime
            pUser.criticalCoolDownTime = theHumanSkillCDTime
            pUser.giveGunTime = gameTime + 2
            -- returnWeapons(p)
            if pUser.hero == true then
                local heroNumber = math.random(1, 5)
                if heroNumber >= 3 then
                    pUser.isHero = true
                else
                    pUser.isHero = false
                end
            end
        end
    end
end

--装填事件
function Game.Rule:OnReload(player, weapon, time)
    local pUser = player.user
    local gameTime = Game.GetTime()
    --透明换弹
    if pUser.sneakReload == true then
        if pUser.sneakCdTime == nil or gameTime >= pUser.sneakCdTime then
            --如果游戏时间小于角色隐身CD时间，角色不能隐身
            pUser.sneakCdTime = gameTime + 10
            player:SetRenderFX(playerRenderFx.sneak)
            pUser.renderFx = playerRenderFx.sneak
            player:Signal(SignalToUI.sneakReload)
        end
    end
    --透明换弹结束
    --高速填装
    if pUser.quickReload == true then
        if pUser.quickReloadCDTime == nil or gameTime >= pUser.quickReloadCDTime then
            pUser.quickReloadCDTime = gameTime + 10
            pUser.speedRateBeforeQuickReload = player.maxspeed
            player.maxspeed = player.maxspeed + 0.1
            player:Signal(SignalToUI.quickReload)
        end
    end
    --高速填装结束
end

--装填结束事件
function Game.Rule:OnReloadFinished(player, weapon)
    local pUser = player.user
    --透明换弹
    if pUser.renderFx == playerRenderFx.sneak then
        player:SetRenderFX(playerRenderFx.normal)
        pUser.renderFx = playerRenderFx.normal
    end
    --透明换弹结束
    --高速填装
    if pUser.speedRateBeforeQuickReload ~= nil then
        speedReduction(player, 0.1)
        pUser.speedRateBeforeQuickReload = nil
    end
    --高速填装结束
    player:Signal(SignalToUI.sneakQuickReloadSuspend)
end

--武器切换事件
function Game.Rule:OnSwitchWeapon (player)
    local pUser = player.user
    --透明换弹
    if pUser.renderFx == playerRenderFx.sneak then
        player:SetRenderFX(playerRenderFx.normal)
        pUser.renderFx = playerRenderFx.normal
    end
    --透明换弹结束
    --高速填装
    if pUser.speedRateBeforeQuickReload ~= nil then
        speedReduction(player, 0.1)
        pUser.speedRateBeforeQuickReload = nil
    end
    --高速填装结束
    player:Signal(SignalToUI.sneakQuickReloadSuspend)
end

--开火事件
function Game.Rule:PostFireWeapon(player, weapon, time)
    local pUser = player.user
    if weapon ~= nil then
        local weaponType = weapon:GetWeaponType()
        if pUser.forward == true then
            --冲锋推进
            if weaponType == Game.WEAPONTYPE.SUBMACHINEGUN then
                weapon.speed = 1.05
            elseif weaponType == Game.WEAPONTYPE.MACHINEGUN then
                weapon.flinch = 1.2
            end
        elseif pUser.assault == true then
            --正面突击
            if weaponType == Game.WEAPONTYPE.RIFLE then
                weapon.damage = 1.5
            elseif weapontype == Game.WEAPONTYPE.SHOTGUN then
                weapon.knockback = 2.0
            end
        else
            weapon.speed = 1
            weapon.flinch = 1
            weapon.damage = 1
            weapon.knockback = 2
        end
        --弹夹回收
        if pUser.recycle == true then
            if weaponType == Game.WEAPONTYPE.EQUIPMENT then
                local recycleNumber = math.random(1, 5)
                if recycleNumber >= 3 then
                    weapon:AddClip1(1)
                end
            end
        end
    end
end

--玩家攻击事件
function Game.Rule:OnPlayerAttack(victim, attacker, damage, weapontype, hitbox)
    --游戏未开始不受伤害
    if state ~= STATE.PLAYING then
        return 0
    end
    --受害者为空不受伤害
    if victim == nil then
        return 0
    end

    --实际受到的伤害返回值
    local gameTime = Game.GetTime()
    local actuallyDamage = math.floor(damage)
    local vUser = victim.user
    --模型伤害效果
    if vUser.resistance ~= nil then
        actuallyDamage = math.floor(actuallyDamage * vUser.resistance)
    end
    --模型伤害效果结束

    --呼吸回血时间设置
    vUser.lastAttackTime = gameTime
    vUser.recoverTime = vUser.lastAttackTime + 5
    victim:Signal(SignalToUI.lastAttack)
    --呼吸回血时间设置结束
    if attacker == nil then
        return actuallyDamage
    end

    --玩家间伤害逻辑
    local aUser = attacker.user
    vUser.respawnable = true
    aUser.respawnable = true
    --优先级最低：玩家增伤
    if aUser.damageRate ~= nil then
        actuallyDamage = math.floor(actuallyDamage * aUser.damageRate)
    end

    --致命打击
    if aUser.criticaling == true then
        actuallyDamage = math.floor(actuallyDamage * 4)
    end

    --组织再生(受到攻击有概率恢复护甲值)
    if vUser.repair == true then
        local repairNum = Game.RandomInt(0, 9)
        if repairNum == 0 then
            if victim.armor + 500 <= victim.maxarmor then
                victim.armor = victim.armor + 500
            else
                victim.armor = victim.maxarmor
            end
        end
    end
    --组织再生结束

    --利刃
    if aUser.edge == true then
        if weapontype == 1 then
            actuallyDamage = math.floor(actuallyDamage * 10)
        end
    end

    --硬化 普通优先级
    if (vUser.zombieExclusiveSkill == 30 or vUser.zombieExclusiveSkill == 33) and vUser.renderFx == playerRenderFx.glowShell then
        actuallyDamage = math.floor(actuallyDamage * 0.7)
    end
    --硬化结束

    --钢铁铠甲
    if vUser.ironChest == true and hitbox ~= Game.HITBOX.HEAD then
        actuallyDamage = math.floor(actuallyDamage * 0.8)
    end
    --钢铁铠甲结束
    --钢铁头盔
    if vUser.ironHelmet == true and hitbox == Game.HITBOX.HEAD then
        actuallyDamage = math.floor(actuallyDamage * 0.5)
    end
    --钢铁头盔结束
    --猛犸
    if vUser.mammoth == true and getSpeed(victim) <= 150 then
        actuallyDamage = math.floor(actuallyDamage * 0.5)
    end
    --猛犸结束
    --痛苦记忆
    if vUser.sufferMemory == true then
        if attacker.name == vUser.lastKillerName then
            actuallyDamage = math.floor(actuallyDamage * 0.1)
        end
    end
    --痛苦记忆结束


    --荆棘现已改为倾斜装甲 次高优先级
    if vUser.thorns == true then
        local thornsNum = Game.RandomInt(0, 4)
        if thornsNum == 0 then
            local thornsDamage = math.floor(actuallyDamage / 5)
            -- local thornsDamage = math.floor(damage)
            if attacker.health - thornsDamage <= 0 then
                attacker:Kill()
                attacker:Respawn()
            else
                attacker.health = attacker.health - thornsDamage
            end
            actuallyDamage = 0
            attacker:ShowOverheadDamage(thornsDamage, attacker.index)
        end
    end

    --免死技能
    if vUser.zombie == true then
        if vUser.zombieExclusiveSkill == 41 and vUser.renderFx == playerRenderFx.colorEx then
            if actuallyDamage >= victim.health then
                victim:Signal(SignalToUI.undyingLoseControl)
                vUser.undying = true
                vUser.undyingTime = gameTime + 3
                victim.health = victim.maxhealth
                victim.armor = victim.maxarmor
            end
        end
    end
    --免死技能

    --僵尸感染 最高优先级
    if vUser.zombie == false and aUser.zombie == true then
        if aUser.ironClaw == true then
            --合金利爪
            actuallyDamage = 2000
        else
            actuallyDamage = 1000
        end
    end
    --僵尸感染结束

    --伤害值上限为9999
    if actuallyDamage >= 9999 then
        actuallyDamage = 9999
    end

    victim:ShowOverheadDamage(actuallyDamage, victim.index)
    if damagePanelTable[attacker.index] ~= nil then
        damagePanelTable[attacker.index].value = actuallyDamage
    end

    --攻击者加经验值
    local appendExp = actuallyDamage
    if appendExp >= 1000 then
        appendExp = 1000
    end
    addPlayerExp(attacker, appendExp)
    --受害者加经验值
    if vUser.evolution == true then
        addPlayerExp(victim, math.floor(appendExp * 0.4))
    else
        addPlayerExp(victim, math.floor(appendExp * 0.2))
    end

    return actuallyDamage
    --测试时先秒杀
    -- return 10000

end

--玩家或怪物攻击事件
function Game.Rule:OnTakeDamage (victim, attacker, damage, weapontype, hitbox)
end

--获得武器事件
function Game.Rule:OnGetWeapon(player, weaponid, weapon)
    local pUser = player.user
    if weapon ~= nil then
        local weaponType = weapon:GetWeaponType()
        if pUser.forward == true then
            --冲锋推进
            if weaponType == Game.WEAPONTYPE.SUBMACHINEGUN then
                weapon.speed = 1.05
            elseif weaponType == Game.WEAPONTYPE.MACHINEGUN then
                weapon.flinch = 1.2
            end
        elseif pUser.assault == true then
            --正面突击
            if weaponType == Game.WEAPONTYPE.RIFLE then
                weapon.damage = 1.5
            elseif weapontype == Game.WEAPONTYPE.SHOTGUN then
                weapon.knockback = 2.0
            end
        else
            weapon.speed = 1
            weapon.flinch = 1
            weapon.damage = 1
            weapon.knockback = 1
        end
        if pUser.backClip == true then
            --备弹补充
            weapon.infiniteclip = true
        else
            if weaponType ~= Game.WEAPONTYPE.PISTOL then
                weapon.infiniteclip = false
            end
        end
    end
end

--武器变更事件
function Game.Rule:OnDeployWeapon(player, weapon)
    local pUser = player.user
    --获得你手持的武器
    local yourWeapon = player:GetPrimaryWeapon()
    local yourWeaponType = nil
    if yourWeapon ~= nil then
        yourWeaponType = yourWeapon:GetWeaponType()
    end
    --透明换弹
    if pUser.renderFx == playerRenderFx.sneak then
        player:SetRenderFX(playerRenderFx.normal)
        pUser.renderFx = playerRenderFx.normal
    end
    --透明换弹结束
    --高速填装
    if pUser.speedRateBeforeQuickReload ~= nil then
        speedReduction(player, 0.1)
        pUser.speedRateBeforeQuickReload = nil
    end
    --高速填装结束
    player:Signal(SignalToUI.sneakQuickReloadSuspend)

    if weapon ~= nil then
        local weaponType = weapon:GetWeaponType()
        --冲锋推进
        if pUser.forward == true then
            --冲锋枪部分
            if weaponType == Game.WEAPONTYPE.SUBMACHINEGUN then
                weapon.speed = 1.05
            end
            --机关枪部分
            if weaponType == Game.WEAPONTYPE.MACHINEGUN then
                weapon.flinch = 1.2
            end
        else
            weapon.speed = 1
            weapon.flinch = 1
        end
        --正面突击
        if pUser.assault == true then
            --突击步枪部分
            if weaponType == Game.WEAPONTYPE.RIFLE then
                weapon.damage = 1.5
            end
            if weaponType == Game.WEAPONTYPE.SHOTGUN then
                weapon.knockback = 2.0
            end
        else
            weapon.damage = 1
            weapon.knockback = 1
        end

        --神枪手
        if pUser.shooter == true and yourWeaponType == Game.WEAPONTYPE.SNIPERRIFLE then
            player:Signal(SignalToUI.shooterCrosshairShow)
        else
            player:Signal(SignalToUI.shooterCrosshairHide)
        end
    end
end

--玩家信号
function Game.Rule:OnPlayerSignal(player, signal)

    local pUser = player.user
    local gameTime = Game.GetTime()

    --切换视角
    if signal == SignalToGame.toggleView then
        if pUser.viewToggle then
            player:SetThirdPersonView(100, 300)
        else
            player:SetFirstPersonView()
        end
        pUser.viewToggle = not player.user.viewToggle
    end

    --二段跳
    if signal == SignalToGame.jump then
        if pUser.isUp == true then
            if pUser.jumped < pUser.jumpLevel and pUser.jumpCD <= gameTime then
                --多段跳还没完成
                player.velocity = { z = 200 * pUser.jumpRate }
                pUser.jumped = pUser.jumped + 1
                pUser.jumpCD = gameTime + 0.2
            end
        end
    end

    --伊卡洛斯
    if signal == SignalToGame.icarus then

        if pUser.canIcraus and pUser.icarusCD <= gameTime then
            if pUser.icarus and pUser.isUp then
                local speed = getSpeed(player)
                if speed > 0 then
                    local sin = player.velocity.x / speed
                    local cos = player.velocity.y / speed
                    player.velocity = { x = 500 * sin, y = 500 * cos }
                    pUser.icarusCDMark = false
                    player:Signal(SignalToUI.icarus)
                end
            end
        end

    end

    --适应力
    if pUser.adaptability or pUser.hostMenu then
        if signal >= SignalToGame.S_Zombie_Model_Normal and signal <= SignalToGame.S_Zombie_Model_Aksha then
            pUser.hostMenu = false
            local theModelNumber = signal - 20
            local theZombieTableIndex = theModelNumber - 29
            local hpRate = player.health / player.maxhealth
            local armorRate = player.armor / player.maxarmor
            player.model = theModelNumber
            pUser.zombieExclusiveSkill = player.model
            -- 设置僵尸属性
            local theZombieData = zombieTable[theZombieTableIndex]
            if theZombieData == nil then
                theZombieData = zombieTable[1]
            end
            player.maxhealth = theZombieData.maxhealth
            if pUser.rehydration == true then
                player.maxhealth = player.maxhealth + 20000
            end
            player.maxarmor = theZombieData.maxarmor
            player.health = math.floor(player.maxhealth * hpRate)
            player.armor = math.floor(player.maxarmor * armorRate)
            player.flinch = theZombieData.flinch
            player.knockback = theZombieData.knockback
            player.maxspeed = theZombieData.maxspeed
            player.gravity = theZombieData.gravity
            pUser.jumpRate = theZombieData.jumpRate
            pUser.speedRate = theZombieData.speedRate
            pUser.jumpLevel = theZombieData.jumpLevel
            pUser.resistance = theZombieData.resistance
            player:Signal(SignalToUI.infect)
            player:Signal(theZombieData.skillOneSignal)
            player:Signal(theZombieData.skillTwoSignal)
            pUser.zombie = true
            player.team = Game.TEAM.TR
        end
    end

    --获得技能
    if signal == SignalToGame.getSkill then

        if pUser.currentLevel == nil then
            pUser.currentLevel = 1
            pUser.skillPoint = 1
            pUser.currentSkillNumber = 0
        end

        if pUser.skillPoint >= 1 and pUser.currentSkillNumber <= 9 then
            local theSkillTableWillBeCopy = {}
            local theExcludeTable = {}
            if pUser.zombieSkillPoint == true then
                theSkillTableWillBeCopy = zombieSkillTableEx
                theExcludeTable = pUser.zombieSkillTable
            else
                theSkillTableWillBeCopy = humanSkillTableEx
                theExcludeTable = pUser.humanSkillTable
            end

            local copyZombieSkillTable = copyTableExcludeTable(theSkillTableWillBeCopy, theExcludeTable)

            if ZCLOGLength(copyZombieSkillTable) == 0 or ZCLOGLength(pUser.zombieSkillTable) == 5 then
                return
            end

            local tempSkillTable = {}
            for i, t in ipairs(copyZombieSkillTable) do
                for j = 1, copyZombieSkillTable[i][2] do
                    table.insert(tempSkillTable, { copyZombieSkillTable[i][1], copyZombieSkillTable[i][2], copyZombieSkillTable[i][3], copyZombieSkillTable[i][4] })
                end
            end
            local randomSkillNumber = math.random(1, ZCLOGLength(tempSkillTable))
            local theSkillYouGet = tempSkillTable[randomSkillNumber]

            if pUser.zombieSkillPoint == true then
                table.insert(pUser.zombieSkillTable, theSkillYouGet)
                pUser.zombieSkillPoint = false
            else
                table.insert(pUser.humanSkillTable, theSkillYouGet)
                pUser.zombieSkillPoint = true
            end

            player:Signal(theSkillYouGet[4])
            local theGetSkillName = theSkillYouGet[1]
            pUser[theGetSkillName] = true

            if theGetSkillName == "cheetah" then
                --猎豹
                player.maxspeed = player.maxspeed + 0.05
            elseif theGetSkillName == "kangaroo" then
                --袋鼠
                player.gravity = 0.725
            elseif theGetSkillName == "shooter" then
                --神枪手
                local yourWeaponList = player:GetWeaponInvenList()
                table.insert(yourWeaponList, player:GetPrimaryWeapon())
                for k, v in ipairs(yourWeaponList) do
                    if v:GetWeaponType() == Game.WEAPONTYPE.SNIPERRIFLE then
                        player:Signal(SignalToUI.shooterCrosshairShow)
                    end
                end
            elseif theGetSkillName == "backClip" then
                --备弹补充
                local yourWeaponList = player:GetWeaponInvenList()
                table.insert(yourWeaponList, player:GetPrimaryWeapon())
                for k, v in ipairs(yourWeaponList) do
                    v.infiniteclip = true
                end
            end

            pUser.skillPoint = pUser.skillPoint - 1
            pUser.currentSkillNumber = pUser.currentSkillNumber + 1
        end
        if skillPointTable[player.index] ~= nil then
            skillPointTable[player.index].value = pUser.skillPoint
        end
    end

    --打开背包
    if signal == SignalToGame.openWeaponInven then
        player:ToggleWeaponInven()
    end

    --使用G键
    if signal == SignalToGame.gKeyUsed then
        if pUser.zombieExclusiveSkill ~= 0 and pUser.zombieExclusiveSkillCDTime ~= nil and pUser.zombieExclusiveSkillCDTime <= gameTime then
            -- player:Signal(SignalToUI.gKeyUsed)
            local theZombieExclusiveSkillNumber = pUser.zombieExclusiveSkill
            pUser.zombieExclusiveSkillCDTime = gameTime + 20
            if theZombieExclusiveSkillNumber == 30 or theZombieExclusiveSkillNumber == 33 then
                --普通僵尸、迷雾鬼影
                pUser.zombieExclusiveSkillDuration = gameTime + 10
                player:SetRenderFX(playerRenderFx.glowShell)
                player:SetRenderColor({ r = 255, g = 0, b = 0 })
                pUser.renderFx = playerRenderFx.glowShell
                player:Signal(SignalToUI.induration)
            elseif theZombieExclusiveSkillNumber == 31 then
                --暗影芭比
                pUser.zombieExclusiveSkillDuration = gameTime + 10
                player:Signal(SignalToUI.lurk)
            elseif theZombieExclusiveSkillNumber == 32 then
                --憎恶屠夫
                pUser.zombieExclusiveSkillDuration = gameTime + 3
                player:SetRenderFX(playerRenderFx.colorEx)
                player:SetRenderColor({ r = 151, g = 241, b = 41 })
                pUser.renderFx = playerRenderFx.colorEx
                player:Signal(SignalToUI.ghostHand)
            elseif theZombieExclusiveSkillNumber == 34 then
                --巫蛊术尸
                pUser.zombieExclusiveSkillDuration = gameTime + 10
                player:SetRenderFX(playerRenderFx.glowShell)
                player:SetRenderColor({ r = 255, g = 255, b = 0 })
                pUser.renderFx = playerRenderFx.glowShell
                player:Signal(SignalToUI.cure)
            elseif theZombieExclusiveSkillNumber == 35 then
                --恶魔之子
                pUser.zombieExclusiveSkillDuration = gameTime + 3
                player:SetRenderFX(playerRenderFx.colorEx)
                player:SetRenderColor({ r = 50, g = 154, b = 254 })
                pUser.renderFx = playerRenderFx.colorEx
                player:Signal(SignalToUI.shock)
            elseif theZombieExclusiveSkillNumber == 36 then
                --恶魔猎手
                pUser.zombieExclusiveSkillDuration = gameTime + 10
                player:SetRenderFX(playerRenderFx.glowShell)
                player:SetRenderColor({ r = 0, g = 255, b = 200 })
                pUser.renderFx = playerRenderFx.glowShell
                player:Signal(SignalToUI.firmly)
                player.knockback = 0.0
            elseif theZombieExclusiveSkillNumber == 37 then
                --送葬者
                pUser.zombieExclusiveSkillDuration = gameTime + 10
                player:SetRenderFX(playerRenderFx.colorEx)
                player:SetRenderColor({ r = 140, g = 100, b = 54 })
                pUser.renderFx = playerRenderFx.colorEx
                player:Signal(SignalToUI.impact)
            elseif theZombieExclusiveSkillNumber == 38 then
                --嗜血女妖
                pUser.zombieExclusiveSkillDuration = gameTime + 3
                player:SetRenderFX(playerRenderFx.colorEx)
                player:SetRenderColor({ r = 200, g = 154, b = 200 })
                pUser.renderFx = playerRenderFx.colorEx
                player:Signal(SignalToUI.trap)
            elseif theZombieExclusiveSkillNumber == 44 or theZombieExclusiveSkillNumber == 46 then
                --爆弹狂魔、赤炎恶鬼
                pUser.zombieExclusiveSkillDuration = gameTime + 10
                player:SetRenderFX(playerRenderFx.colorEx)
                player:SetRenderColor({ r = 65, g = 85, b = 105 })
                pUser.renderFx = playerRenderFx.colorEx
                player:Signal(SignalToUI.feedback)
            elseif theZombieExclusiveSkillNumber == 41 then
                --暴虐钢骨
                pUser.zombieExclusiveSkillDuration = gameTime + 10
                player:SetRenderFX(playerRenderFx.colorEx)
                player:SetRenderColor({ r = 255, g = 0, b = 255 })
                pUser.renderFx = playerRenderFx.colorEx
                player:Signal(SignalToUI.undying)
            elseif theZombieExclusiveSkillNumber == 42 then
                --幻痛夜魔
                pUser.zombieExclusiveSkillDuration = gameTime + 3
                player:SetRenderFX(playerRenderFx.colorEx)
                player:SetRenderColor({ r = 255, g = 0, b = 255 })
                pUser.renderFx = playerRenderFx.colorEx
                player:Signal(SignalToUI.hidden)
            elseif theZombieExclusiveSkillNumber == 40 or theZombieExclusiveSkillNumber == 43 or theZombieExclusiveSkillNumber == 45 then
                --痛苦女王、追猎傀儡、断翼恶灵
                player.velocity = { z = 600 }
                player:Signal(SignalToUI.leap)
            end
        end
    end

    --极速飞奔
    if signal == SignalToGame.sprint and pUser.sprint == true then
        if pUser.sprintCoolDownTime <= gameTime and pUser.sprinting == false then
            player:Signal(SignalToUI.sprint)
            pUser.sprinting = true
            pUser.speedRateBeforeSprint = player.maxspeed
            player.maxspeed = player.maxspeed + 0.2
            player:SetRenderFX(playerRenderFx.colorEx)
            player:SetRenderColor({ r = 50, g = 205, b = 50 })
            pUser.renderFx = playerRenderFx.colorEx
            pUser.sprintDurationTime = gameTime + 10
            pUser.sprintCoolDownTime = gameTime + 60
        end
    end

    --致命打击
    if signal == SignalToGame.critical and pUser.critical == true then
        if pUser.criticalCoolDownTime <= gameTime and pUser.criticaling == false then
            player:Signal(SignalToUI.critical)
            pUser.criticaling = true
            player:SetRenderFX(playerRenderFx.colorEx)
            player:SetRenderColor({ r = 218, g = 165, b = 32 })
            pUser.renderFx = playerRenderFx.colorEx
            pUser.criticalDurationTime = gameTime + 10
            pUser.criticalCoolDownTime = gameTime + 60
        end
    end

    --冲击减速
    if signal == SignalToGame.speedChangedImpact then
        playerSpeedImpact(player)
    end

    --鬼手定身
    if signal == SignalToGame.speedChangedGhostHand then
        playerSpeedStatic(player)
    end

end
