--初始游戏设置
Game.Rule.respawnable = false
Game.Rule.respawnTime = 0
Game.Rule.enemyfire = true
Game.Rule.friendlyfire = false
Game.Rule.breakable = false



-- 同步变量
scoreGoal = Game.SyncValue:Create('goal') --总回合
scoreHuman = Game.SyncValue:Create("human") --人类获胜回合
scoreZombie = Game.SyncValue:Create("zombie") --僵尸获胜回合

scoreGoal.value = 5
scoreHuman.value = 0
scoreZombie.value = 0

speedPanelTable = {} --速度栏表
skillPanel = Game.SyncValue:Create('skillPanel') --技能栏改成时间栏
skillPanelKeyboard = Game.SyncValue:Create('skillPanelKeyboard') --技能栏改成时间栏
damagePanelTable = {} --伤害栏表
skillPointTable = {} --技能点表

-- 每回合时间
READY_TIME = 21
ROUND_TIME = 480
TOTAL_GAME_TIME = 2500
roundtimer = Timer:new()
escapeTimer = Timer:new()
totalGameTimer = Timer:new()
totalGameTimer:Start(TOTAL_GAME_TIME)

theHumanSkillCDTime = Game.GetTime() --人类技能在回合开始前不能使用

--母体已经出现人类不能中途加入复活
hostShow = false


--二代僵尸技能总表
zombieSkillTableEx = {
    {
        "hpPlus",
        10,
        "恢复强化：一段时间没有受到伤害后开始回复生命值。",
        SignalToUI.hpPlusSkillGet,
        1
    },
    {
        "rehydration",
        10,
        "生命补液：拥有更高的生命值上限。",
        SignalToUI.rehydrationSkillGet,
        -1
    },
    {
        "ironChest",
        15,
        "钢铁铠甲：降低受到的非致命打击伤害。",
        SignalToUI.ironChestSkillGet,
        1
    },
    {
        "deflectArmor",
        5,
        "倾斜装甲：装配光滑并且带有一定倾斜角度的装甲使得你有概率反弹子弹，免伤并且使攻击者受到伤害惩罚。",
        SignalToUI.deflectArmorSkillGet,
        -1
    },
    {
        "ironHelmet",
        5,
        "钢铁头盔：降低受到的致命打击伤害。",
        SignalToUI.ironHelmetSkillGet,
        1
    },
    {
        "sufferMemory",
        5,
        "痛苦记忆：极大幅度降低上次击杀你的玩家对你造成的伤害。",
        SignalToUI.sufferMemorySkillGet,
        -1
    },
    {
        "ironClaw",
        10,
        "合金利爪：对英雄的伤害翻倍。",
        SignalToUI.ironClawSkillGet,
        1
    },
    {
        "touchInfect",
        1,
        "接触感染：与你发生身体碰撞的人类玩家会立刻死亡并感染，但这并不会算作你的击杀。",
        SignalToUI.touchInfectSkillGet,
        -1
    },
    {
        "evolution",
        5,
        "进化论：受到伤害时获得的经验值更多，且你被赋予成为英雄僵尸的可能性。",
        SignalToUI.evolutionSkillGet,
        1
    },
    {
        "adaptability",
        4,
        "适应力：可以随时切换僵尸模型。",
        SignalToUI.adaptabilitySkillGet,
        -1
    },
    {
        "mammoth",
        15,
        "猛犸：移动速度较低时降低受到的伤害。",
        SignalToUI.mammothSkillGet,
        0
    },
    {
        "repair",
        15,
        "组织再生：受到攻击时概率恢复护甲值。",
        SignalToUI.repairSkillGet,
        0
    }
}
--二代人类技能总表
humanSkillTableEx = {
    {
        "sneakReload",
        5,
        "透明换弹：装弹过程中保持隐身。",
        SignalToUI.sneakReloadSkillGet,
        1
    },
    {
        "quickReload",
        15,
        "高速填装：换弹过程中移动速度增加。",
        SignalToUI.quickReloadSkillGet,
        -1
    },
    {
        "backClip",
        15,
        "备弹补充：使用常规弹夹的武器拥有无限备弹。",
        SignalToUI.backClipSkillGet,
        1
    },
    {
        "recycle",
        5,
        "弹夹回收：使用特殊子弹的武器有概率回收子弹。",
        SignalToUI.recycleSkillGet,
        -1
    },
    {
        "kangaroo",
        8,
        "袋鼠：拥有更出色的重力参数。",
        SignalToUI.kangarooSkillGet,
        1
    },
    {
        "cheetah",
        8,
        "猎豹：拥有更出色的移动速度。",
        SignalToUI.cheetahSkillGet,
        -1
    },
    {
        "assault",
        10,
        "正面突击：突击步枪拥有更高的伤害能力，霰弹枪拥有更强的击退能力。",
        SignalToUI.assaultSkillGet,
        1
    },
    {
        "forward",
        5,
        "冲锋推进：冲锋枪拥有更快的移动速度，轻机枪拥有更好的定身能力。",
        SignalToUI.forwardSkillGet,
        -1
    },
    {
        "sprint",
        5,
        "极速飞奔：5键激活，一段时间内提高移动速度。",
        SignalToUI.sprintSkillGet,
        1
    },
    {
        "critical",
        5,
        "致命打击：6键激活，一段时间内造成四倍伤害。",
        SignalToUI.criticalSkillGet,
        -1
    },
    {
        "hero",
        2,
        "英雄出现：有概率被选为英雄。",
        SignalToUI.heroSkillGet,
        0
    },
    {
        "edge",
        8,
        "利刃：近战武器造成额外伤害。",
        SignalToUI.edgeSkillGet,
        0
    },
    {
        "shooter",
        9,
        "神枪手：当你的背包里拥有狙击步枪时，你不需要开镜也能获得一个准心。",
        SignalToUI.shooterSkillGet,
        0
    }
}

--玩家渲染方式
playerRenderFx = {
    normal = 0,
    tic = 15,
    shake = 16,
    sneak = 18,
    glowShell = 19,
    dark = 21,
    color = 22,
    colorEx = 23
}

-- 游戏状态
STATE = {
    READY = 1, -- 准备就绪
    PLAYING = 2, -- 回合进行中
    END = 3, -- 回合结算中
}

--升级需要经验
playerLevelUpExp = 5000

-- 玩家表
players = {}
for i = 1, 24 do
    players[i] = nil
end

--定义回合信息
state = STATE.READY --回合状态
roundEndTime = nil --回合结束时间
roundRunning = false --回合是否正在进行
currentRoundHumanPlayerList = {} --本回合目前人类玩家列表
currentRoundZombiePlayerList = {} --本回合目前僵尸玩家列表

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

    --玩家信息
    for i = 1, 24 do
        if players[i] then

            --通用模块
            local thePlayer = players[i]
            local pUser = players[i].user

            --发枪
            if pUser.firstJoin == true then
                if pUser.giveGunTime ~= nil and pUser.giveGunTime <= time then
                    pUser.giveGunTime = nil
                    giveInitialGun(thePlayer)
                end
            end

            --玩家地速开始
            pUser.speed = getSpeed(thePlayer)
            if speedPanelTable[i] ~= nil then
                speedPanelTable[i].value = getSpeed(thePlayer)
            end

            --玩家地速结束

            --玩家恢复控制权
            if pUser.static == true and pUser.staticTime ~= nil then
                if pUser.staticTime >= time then
                    playerSpeedStatic(thePlayer)
                else
                    pUser.static = false
                end
            end
            --玩家恢复控制权结束

            --致命打击结束
            if pUser.criticaling == true then
                if pUser.criticalDurationTime <= time then
                    pUser.criticaling = false
                    thePlayer:SetRenderFX(playerRenderFx.normal)
                    pUser.renderFx = playerRenderFx.normal
                end
            end
            --极速飞奔结束
            if pUser.sprinting == true and pUser.speedRateBeforeSprint ~= nil then
                if pUser.sprintDurationTime <= time then
                    pUser.sprinting = false
                    speedReduction(thePlayer, 0.2)
                    pUser.speedRateBeforeSprint = nil
                    thePlayer:SetRenderFX(playerRenderFx.normal)
                    pUser.renderFx = playerRenderFx.normal
                end
            end

        end
    end
    --玩家信息结束

    --僵尸模块
    for i = 1, 24 do
        if currentRoundZombiePlayerList[i] ~= nil then
            local thePlayer = currentRoundZombiePlayerList[i]
            local pUser = thePlayer.user
            --僵尸模块
            if pUser.zombie == true then
                --二段跳开始
                if pUser.jumpLevel ~= nil and pUser.jumpLevel > 1 then
                    if thePlayer.velocity.z == 0 then
                        pUser.jumped = 0    --落地重置
                        pUser.isUp = false
                    else
                        if thePlayer.velocity.z > 0 then
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

                    if thePlayer.velocity.z == 0 then

                        pUser.icarus = true --落地重置
                        pUser.isUp = false
                        if not pUser.icarusCDMark then
                            pUser.icarusCDMark = true
                            pUser.icarusCD = time + 3
                        end
                    else
                        if thePlayer.velocity.z > 0 then
                            pUser.isUp = true
                        end
                    end
                end
                --伊卡洛斯结束

                --呼吸回血
                -- if pUser.recover and pUser.zombie then
                -- if thePlayer.health <= thePlayer.maxhealth and pUser.recoverTime ~= nil and pUser.recoverTime <= time then
                -- if thePlayer.health + 500 <= thePlayer.maxhealth then
                -- thePlayer.health = thePlayer.health + 500
                -- else
                -- thePlayer.health = thePlayer.maxhealth
                -- end
                -- pUser.recoverTime = time + 1
                -- end
                -- end
                --呼吸回血结束

                --恢复玩家渲染方式
                if pUser.renderFx ~= playerRenderFx.normal then
                    if pUser.zombie == true and pUser.zombieExclusiveSkillDuration ~= nil and pUser.zombieExclusiveSkillDuration <= time then
                        thePlayer:SetRenderFX(playerRenderFx.normal)
                        pUser.renderFx = playerRenderFx.normal
                        thePlayer:Signal(SignalToUI.modelRestore)
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
                            thePlayer:SetRenderFX(playerRenderFx.sneak)
                            pUser.renderFx = playerRenderFx.sneak
                            thePlayer:Signal(SignalToUI.gKeyUsed)
                        else
                            thePlayer:SetRenderFX(playerRenderFx.normal)
                            pUser.renderFx = playerRenderFx.normal
                            thePlayer:Signal(SignalToUI.modelRestore)
                        end
                    end
                end
                --芭比隐身结束
                --巫蛊术尸恢复生命
                if pUser.zombieExclusiveSkill == 34 then
                    if pUser.zombieExclusiveSkillDuration ~= nil and pUser.zombieExclusiveSkillDuration >= time then
                        if thePlayer.health + 50 >= thePlayer.maxhealth then
                            thePlayer.health = thePlayer.maxhealth
                        else
                            thePlayer.health = thePlayer.health + 50
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
                            if touchHuman.position.x == thePlayer.position.x and touchHuman.position.y == thePlayer.position.y and (touchHuman.position.z == thePlayer.position.z or touchHuman.position.z == (thePlayer.position.z + 1)) then
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
                    thePlayer:Signal(SignalToUI.undyingGetControl)
                    pUser.undying = false
                end
                --免死结束
            end
            --僵尸模块结束
        end
    end
    --僵尸模块结束
    --人类模块
    for i = 1, 24 do
        local thePlayer = currentRoundHumanPlayerList[i]
        if thePlayer ~= nil then
            local pUser = thePlayer.user
            if pUser.speedImpact == true and pUser.speedImpactTime ~= nil then
                if pUser.speedImpactTime >= time then
                    playerSpeedImpact(thePlayer)
                else
                    pUser.speedImpact = false
                end
            end
        end
    end
    --人类模块结束

    --回合信息

    --确定回合时间
    if state == STATE.READY then
        if roundtimer:IsElapsed() then
            escapeTimer:Start(ROUND_TIME)
            roundEndTime = time + ROUND_TIME
            state = STATE.PLAYING
        end
    end

    --倒计时
    if roundEndTime ~= nil and roundEndTime >= time then
        skillPanel.value = math.floor(roundEndTime - time)
    else
        skillPanel.value = 480
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
    pUser.hostZombieRespawnPosition = hostRespawnEntityBlock.position
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

    if roundtimer:IsElapsed() == true or hostShow then
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
    -- returnWeapons(player)
    -- player:ShowBuymenu()

end

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

function giveTheGuns(call)
    if call then
        for i = 1, 24 do
            local player = players[i]
            if player ~= nil then
                giveInitialGun(player)
            end
        end
    end
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
                    kUser.static = true
                    kUser.staticTime = gameTime + 3
                elseif vUser.zombieExclusiveSkill == 35 then
                    --震荡
                    killer:RemoveWeapon()
                elseif vUser.zombieExclusiveSkill == 37 then
                    --冲击
                    kUser.speedImpact = true
                    kUser.speedImpactTime = gameTime + 8
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

--玩家或怪物死亡
function Game.Rule:OnKilled(victim, killer)
end

--播放惨叫
function playScreamSound()
    Game.SetTrigger("playScreamSound", true)
end

--初始化玩家
function InitPlayer(player)
    -- playScreamSound()
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
                pUser.zombieExclusiveSkill = player.model
                player.maxhealth = 40000
                if pUser.rehydration == true then
                    player.maxhealth = player.maxhealth + 20000
                end
                player.maxarmor = 8000
                player.health = math.floor(player.maxhealth * hpRate)
                player.armor = math.floor(player.maxarmor * armorRate)
                player.flinch = 1.0
                player.knockback = 1.0
                player.maxspeed = 1.0
                pUser.jumpRate = 1.3
                pUser.speedRate = 1.05
                pUser.jumpLevel = 1
                pUser.resistance = 1.0
                pUser.canIcraus = true
                pUser.hostMenu = true --母体菜单
                player:Signal(SignalToUI.infect) --发送感染信号
                player:Signal(SignalToUI.icarusSkillGet) --发送男性僵尸伊卡洛斯信号
                player:Signal(SignalToUI.indurationSkillGet)
            elseif heroZombieNumber <= 7 then
                --男英雄僵尸
                player.model = 41
                player.maxhealth = 80000
                if pUser.rehydration == true then
                    player.maxhealth = player.maxhealth + 20000
                end
                player.maxarmor = 8000
                player.health = math.floor(player.maxhealth * hpRate)
                player.armor = math.floor(player.maxarmor * armorRate)
                player.flinch = 0.8
                player.knockback = 0.8
                player.maxspeed = 1.0
                pUser.jumpRate = 1.3
                pUser.speedRate = 1.06
                pUser.jumpLevel = 1
                pUser.resistance = 0.5
                pUser.canIcraus = true
                pUser.hostMenu = true --母体菜单
                player:Signal(SignalToUI.infect) --发送感染信号
                player:Signal(SignalToUI.icarusSkillGet)
                player:Signal(SignalToUI.undyingSkillGet)
            else
                --女英雄僵尸
                player.model = 42
                player.maxhealth = 40000
                if pUser.rehydration == true then
                    player.maxhealth = player.maxhealth + 20000
                end
                player.maxarmor = 4000
                player.health = math.floor(player.maxhealth * hpRate)
                player.armor = math.floor(player.maxarmor * armorRate)
                player.flinch = 0.5
                player.knockback = 1.2
                player.maxspeed = 1
                pUser.jumpRate = 1.35
                pUser.speedRate = 1.08
                pUser.jumpLevel = 2
                pUser.resistance = 2.0
                pUser.canIcraus = false
                pUser.hostMenu = true --母体菜单
                player:Signal(SignalToUI.infect) --发送感染信号
                player:Signal(SignalToUI.doubleJumpSkillGet)
                player:Signal(SignalToUI.hiddenSkillGet)
                --幻痛夜魔
            end

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
        -- player:ShowBuymenu()
    end
end

--感染复活
function infectionRespawn(player)
    if player ~= nil then
        player:Respawn()
    end
end

--回合开始
function Game.Rule:OnRoundStart()
    hostShow = false
    roundtimer:Start(READY_TIME)
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

--测试CT直接获胜
function CTWin(call)
    if call then
        Game.Rule:Win(Game.TEAM.CT, false)

        breakableBlock:Event({
            action = "reset"
        })
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


--检测回合胜利标准
function checkWinCondition(time)

    if state == STATE.PLAYING then

        local humanNumber, zombieNumber = getHumanLiveNumber()
        local exitGame = false

        -- humanNumber = 1
        -- zombieNumber = 1

        if humanNumber <= 0 then
            --人类全部被抓
            if (scoreHuman.value + scoreZombie.value) >= scoreGoal.value or totalGameTimer:IsElapsed() then
                exitGame = true
            end
            scoreZombie.value = scoreZombie.value + 1
            Game.Rule:Win(Game.TEAM.TR, exitGame)
            state = STATE.END
            sendRoundEndSignal(false)
        elseif zombieNumber <= 0 then
            --僵尸被打自闭全部退光
            if (scoreHuman.value + scoreZombie.value) >= scoreGoal.value or totalGameTimer:IsElapsed() then
                exitGame = true
            end
            scoreHuman.value = scoreHuman.value + 1
            Game.Rule:Win(Game.TEAM.CT, exitGame)
            state = STATE.END
            sendRoundEndSignal(true)
        elseif escapeTimer:IsElapsed() then
            --时间结束
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

--僵尸复活前往死亡时的位置
function zombieRespawnPositionRecover(call)
    if call then
        local tempPlayer = Game.GetTriggerEntity()
        if tempPlayer:IsPlayer() then
            local player = tempPlayer:ToPlayer()
            local pUser = player.user
            -- if pUser.zombie and pUser.infectionPosition ~= nil then
            -- end
            if pUser.useInfectionPosition == true and pUser.infectionPosition ~= nil then
                pUser.useInfectionPosition = false
                player.position = pUser.infectionPosition
            elseif pUser.lastRecordPosition ~= nil then
                player.position = pUser.lastRecordPosition
            end
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

--掉枪试验
function dropGun(call)

    if call then
        if totalGunsList ~= nil then
            local theCaller = Game.GetScriptCaller()
            if theCaller ~= nil then
                local weaponMaxNumber = ZCLOGLength(totalGunsList)
                local weaponNumber = math.random(1, weaponMaxNumber)
                local theGun = Game.Weapon:CreateAndDrop(totalGunsList[weaponNumber], theCaller.position)
                spWeapon(theGun)
            end
        end
    end

end

--测试武器列表
function testWeaponList(call)
    if call then
        local tempPlayer = Game.GetTriggerEntity()
        if tempPlayer:IsPlayer() then
            local player = tempPlayer:ToPlayer()
            local weaponList = player:GetWeaponInvenList()
            -- weaponList[1] = weaponList[2]
            -- ZCLOG(weaponList)
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

--武器检测
function checkPlayerWeapon(call)
    if call then

        local tempPlayer = Game.GetTriggerEntity()
        if tempPlayer:IsPlayer() then

            local player = tempPlayer:ToPlayer()
            local weapon = player:GetPrimaryWeapon()
            if weapon ~= nil then
            end

        end

    end
end

--备弹事件
function backClip(call)

    if call then
        local tempPlayer = Game.GetTriggerEntity()
        if tempPlayer:IsPlayer() then
            local truePlayer = tempPlayer:ToPlayer()
            local thePrimaryWeapon = truePlayer:GetPrimaryWeapon()
            if thePrimaryWeapon ~= nil then
                truePlayer:GetPrimaryWeapon():AddClip1(1)
            end
        end
    end

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


    if state ~= STATE.PLAYING then
        return 0
    end

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
            local thePlayer = tempPlayer:ToPlayer()
            thePlayer.maxspeed = 1.2
            thePlayer.gravity = 0.725
            thePlayer.infiniteclip = true
        end
    end


end

--玩家地速获取并处理
function getSpeed(player)
    local pUser = player.user
    if pUser.zombie == true then
        if player.velocity.z == 0 then
            if math.sqrt((player.velocity.x * player.velocity.x) + (player.velocity.y * player.velocity.y)) <= 290 * pUser.speedRate then
                player.velocity = { x = player.velocity.x * 1.01, y = player.velocity.y * 1.01 }
            end
        end
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

--移除武器测试
function removeWeapon(call)
    if call then
        local tempPlayer = Game.GetTriggerEntity()
        if tempPlayer:IsPlayer() then
            local player = tempPlayer:ToPlayer()
            player:RemoveWeapon()
        end
    end
end

--玩家武器解锁
function unlockWeapon(call)
    if call then
        local tempPlayer = Game.GetTriggerEntity()
        if tempPlayer:IsPlayer() then
            local player = tempPlayer:ToPlayer()
            local playerWeaponList = player:GetWeaponInvenList()

            for i = 1, 30 do
                if playerWeaponList[i] then
                    player:SetWeaponInvenLockedUI(playerWeaponList[i], false)
                end
            end
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
            local hpRate = player.health / player.maxhealth
            local armorRate = player.armor / player.maxarmor
            player.model = theModelNumber
            pUser.zombieExclusiveSkill = player.model
            local modelSwitch = {
                [30] = function()
                    player.maxhealth = 40000
                    if pUser.rehydration == true then
                        player.maxhealth = player.maxhealth + 20000
                    end
                    player.maxarmor = 8000
                    player.health = math.floor(player.maxhealth * hpRate)
                    player.armor = math.floor(player.maxarmor * armorRate)
                    player.flinch = 1.0
                    player.knockback = 1.0
                    player.maxspeed = 1.0
                    pUser.jumpRate = 1.3
                    pUser.speedRate = 1.05
                    pUser.jumpLevel = 1
                    pUser.resistance = 1.0
                    pUser.canIcraus = true
                    player:Signal(SignalToUI.icarusSkillGet)
                    player:Signal(SignalToUI.indurationSkillGet)
                    --普通僵尸
                end,
                [31] = function()
                    player.maxhealth = 20000
                    if pUser.rehydration == true then
                        player.maxhealth = player.maxhealth + 20000
                    end
                    player.maxarmor = 4000
                    player.health = math.floor(player.maxhealth * hpRate)
                    player.armor = math.floor(player.maxarmor * armorRate)
                    player.flinch = 1.0
                    player.knockback = 2.0
                    player.maxspeed = 1
                    pUser.jumpRate = 1.45
                    pUser.speedRate = 1.1
                    pUser.jumpLevel = 2
                    pUser.resistance = 2.0
                    pUser.canIcraus = false
                    player:Signal(SignalToUI.doubleJumpSkillGet)
                    player:Signal(SignalToUI.lurkSkillGet)
                    --暗影芭比
                end,
                [32] = function()
                    player.maxhealth = 60000
                    if pUser.rehydration == true then
                        player.maxhealth = player.maxhealth + 20000
                    end
                    player.maxarmor = 10000
                    player.health = math.floor(player.maxhealth * hpRate)
                    player.armor = math.floor(player.maxarmor * armorRate)
                    player.flinch = 0.5
                    player.knockback = 0.5
                    player.maxspeed = 1
                    pUser.jumpRate = 1.2
                    pUser.speedRate = 1
                    pUser.jumpLevel = 1
                    pUser.resistance = 0.5
                    pUser.canIcraus = true
                    player:Signal(SignalToUI.icarusSkillGet)
                    player:Signal(SignalToUI.ghostHandSkillGet)
                    --憎恶屠夫
                end,
                [33] = function()
                    player.maxhealth = 30000
                    if pUser.rehydration == true then
                        player.maxhealth = player.maxhealth + 20000
                    end
                    player.maxarmor = 6000
                    player.health = math.floor(player.maxhealth * hpRate)
                    player.armor = math.floor(player.maxarmor * armorRate)
                    player.flinch = 1.0
                    player.knockback = 0.8
                    player.maxspeed = 1.0
                    pUser.jumpRate = 1.33
                    pUser.speedRate = 1
                    pUser.jumpLevel = 1
                    pUser.resistance = 0.8
                    pUser.canIcraus = true
                    player:Signal(SignalToUI.icarusSkillGet)
                    player:Signal(SignalToUI.indurationSkillGet)
                    --迷雾鬼影
                end,
                [34] = function()
                    player.maxhealth = 30000
                    if pUser.rehydration == true then
                        player.maxhealth = player.maxhealth + 20000
                    end
                    player.maxarmor = 6000
                    player.health = math.floor(player.maxhealth * hpRate)
                    player.armor = math.floor(player.maxarmor * armorRate)
                    player.flinch = 0.8
                    player.knockback = 1.5
                    player.maxspeed = 1.1
                    pUser.jumpRate = 1.28
                    pUser.speedRate = 1.05
                    pUser.jumpLevel = 1
                    pUser.resistance = 1.3
                    pUser.canIcraus = true
                    player:Signal(SignalToUI.icarusSkillGet)
                    player:Signal(SignalToUI.cureSkillGet)
                    --巫蛊术尸
                end,
                [35] = function()
                    player.maxhealth = 25000
                    if pUser.rehydration == true then
                        player.maxhealth = player.maxhealth + 20000
                    end
                    player.maxarmor = 6000
                    player.health = math.floor(player.maxhealth * hpRate)
                    player.armor = math.floor(player.maxarmor * armorRate)
                    player.flinch = 0.8
                    player.knockback = 0.8
                    player.maxspeed = 1.15
                    pUser.jumpRate = 1.29
                    pUser.speedRate = 1.06
                    pUser.jumpLevel = 1
                    pUser.resistance = 1.2
                    pUser.canIcraus = true
                    player:Signal(SignalToUI.icarusSkillGet)
                    player:Signal(SignalToUI.shockSkillGet)
                    --恶魔之子
                end,
                [36] = function()
                    player.maxhealth = 45000
                    if pUser.rehydration == true then
                        player.maxhealth = player.maxhealth + 20000
                    end
                    player.maxarmor = 8000
                    player.health = math.floor(player.maxhealth * hpRate)
                    player.armor = math.floor(player.maxarmor * armorRate)
                    player.flinch = 0.8
                    player.knockback = 1.5
                    player.maxspeed = 1
                    pUser.jumpRate = 1.32
                    pUser.speedRate = 1.04
                    pUser.jumpLevel = 1
                    pUser.resistance = 0.9
                    pUser.canIcraus = true
                    player:Signal(SignalToUI.icarusSkillGet)
                    player:Signal(SignalToUI.firmlySkillGet)
                    --恶魔猎手
                end,
                [37] = function()
                    player.maxhealth = 55000
                    if pUser.rehydration == true then
                        player.maxhealth = player.maxhealth + 20000
                    end
                    player.maxarmor = 8000
                    player.health = math.floor(player.maxhealth * hpRate)
                    player.armor = math.floor(player.maxarmor * armorRate)
                    player.flinch = 0.8
                    player.knockback = 1.5
                    player.maxspeed = 1.0
                    pUser.jumpRate = 1.27
                    pUser.speedRate = 1.02
                    pUser.jumpLevel = 1
                    pUser.resistance = 0.6
                    pUser.canIcraus = true
                    player:Signal(SignalToUI.icarusSkillGet)
                    player:Signal(SignalToUI.impactSkillGet)
                    --送葬者
                end,
                [38] = function()
                    player.maxhealth = 25000
                    if pUser.rehydration == true then
                        player.maxhealth = player.maxhealth + 20000
                    end
                    player.maxarmor = 8000
                    player.health = math.floor(player.maxhealth * hpRate)
                    player.armor = math.floor(player.maxarmor * armorRate)
                    player.flinch = 0.8
                    player.knockback = 1.2
                    player.maxspeed = 1.1
                    pUser.jumpRate = 1.36
                    pUser.speedRate = 1.06
                    pUser.jumpLevel = 2
                    pUser.resistance = 1.5
                    pUser.canIcraus = false
                    player:Signal(SignalToUI.doubleJumpSkillGet)
                    player:Signal(SignalToUI.trapSkillGet)
                    --嗜血女妖
                end,
                [39] = function()
                    player.maxhealth = 35000
                    if pUser.rehydration == true then
                        player.maxhealth = player.maxhealth + 20000
                    end
                    player.maxarmor = 8000
                    player.health = math.floor(player.maxhealth * hpRate)
                    player.armor = math.floor(player.maxarmor * armorRate)
                    player.flinch = 0.7
                    player.knockback = 0.7
                    player.maxspeed = 1.0
                    pUser.jumpRate = 1.36
                    pUser.speedRate = 1.05
                    pUser.jumpLevel = 1
                    pUser.resistance = 1.5
                    pUser.canIcraus = true
                    player:Signal(SignalToUI.icarusSkillGet)
                    player:Signal(SignalToUI.destructionSkillGet)
                    --腐败暴君
                end,
                [40] = function()
                    player.maxhealth = 25000
                    if pUser.rehydration == true then
                        player.maxhealth = player.maxhealth + 20000
                    end
                    player.maxarmor = 4000
                    player.health = math.floor(player.maxhealth * hpRate)
                    player.armor = math.floor(player.maxarmor * armorRate)
                    player.flinch = 0.8
                    player.knockback = 1.5
                    player.maxspeed = 1.1
                    pUser.jumpRate = 1.4
                    pUser.speedRate = 1.07
                    pUser.jumpLevel = 2
                    pUser.resistance = 1.8
                    pUser.canIcraus = false
                    player:Signal(SignalToUI.doubleJumpSkillGet)
                    player:Signal(SignalToUI.leapSkillGet)
                    --痛苦女王
                end,
                [41] = function()
                    player.maxhealth = 80000
                    if pUser.rehydration == true then
                        player.maxhealth = player.maxhealth + 20000
                    end
                    player.maxarmor = 8000
                    player.health = math.floor(player.maxhealth * hpRate)
                    player.armor = math.floor(player.maxarmor * armorRate)
                    player.flinch = 0.8
                    player.knockback = 0.8
                    player.maxspeed = 1.0
                    pUser.jumpRate = 1.3
                    pUser.speedRate = 1.06
                    pUser.jumpLevel = 1
                    pUser.resistance = 0.5
                    pUser.canIcraus = true
                    player:Signal(SignalToUI.icarusSkillGet)
                    player:Signal(SignalToUI.undyingSkillGet)
                    --暴虐钢骨
                end,
                [42] = function()
                    player.maxhealth = 40000
                    if pUser.rehydration == true then
                        player.maxhealth = player.maxhealth + 20000
                    end
                    player.maxarmor = 4000
                    player.health = math.floor(player.maxhealth * hpRate)
                    player.armor = math.floor(player.maxarmor * armorRate)
                    player.flinch = 0.5
                    player.knockback = 1.2
                    player.maxspeed = 1
                    pUser.jumpRate = 1.35
                    pUser.speedRate = 1.08
                    pUser.jumpLevel = 2
                    pUser.resistance = 2.0
                    pUser.canIcraus = false
                    player:Signal(SignalToUI.doubleJumpSkillGet)
                    player:Signal(SignalToUI.hiddenSkillGet)
                    --幻痛夜魔
                end,
                [43] = function()
                    player.maxhealth = 25000
                    if pUser.rehydration == true then
                        player.maxhealth = player.maxhealth + 20000
                    end
                    player.maxarmor = 2000
                    player.health = math.floor(player.maxhealth * hpRate)
                    player.armor = math.floor(player.maxarmor * armorRate)
                    player.flinch = 0.5
                    player.knockback = 1.5
                    player.maxspeed = 1.2
                    pUser.jumpRate = 1.42
                    pUser.speedRate = 1.09
                    pUser.jumpLevel = 2
                    pUser.resistance = 0.8
                    pUser.canIcraus = false
                    player:Signal(SignalToUI.doubleJumpSkillGet)
                    player:Signal(SignalToUI.leapSkillGet)
                    --追猎傀儡
                end,
                [44] = function()
                    player.maxhealth = 45000
                    if pUser.rehydration == true then
                        player.maxhealth = player.maxhealth + 20000
                    end
                    player.maxarmor = 5000
                    player.health = math.floor(player.maxhealth * hpRate)
                    player.armor = math.floor(player.maxarmor * armorRate)
                    player.flinch = 0.7
                    player.knockback = 1.5
                    player.maxspeed = 1.1
                    pUser.jumpRate = 1.35
                    pUser.speedRate = 1.07
                    pUser.jumpLevel = 1
                    pUser.resistance = 1.4
                    pUser.canIcraus = true
                    player:Signal(SignalToUI.icarusSkillGet)
                    player:Signal(SignalToUI.feedbackSkillGet)
                    --爆弹狂魔
                end,
                [45] = function()
                    player.maxhealth = 30000
                    if pUser.rehydration == true then
                        player.maxhealth = player.maxhealth + 20000
                    end
                    player.maxarmor = 5000
                    player.health = math.floor(player.maxhealth * hpRate)
                    player.armor = math.floor(player.maxarmor * armorRate)
                    player.flinch = 0.5
                    player.knockback = 1.6
                    player.maxspeed = 1.1
                    pUser.jumpRate = 1.43
                    pUser.speedRate = 1.09
                    pUser.jumpLevel = 2
                    pUser.resistance = 1.5
                    pUser.canIcraus = false
                    player:Signal(SignalToUI.doubleJumpSkillGet)
                    player:Signal(SignalToUI.leapSkillGet)
                    --断翼恶灵
                end,
                [46] = function()
                    player.maxhealth = 50000
                    if pUser.rehydration == true then
                        player.maxhealth = player.maxhealth + 20000
                    end
                    player.maxarmor = 10000
                    player.health = math.floor(player.maxhealth * hpRate)
                    player.armor = math.floor(player.maxarmor * armorRate)
                    player.flinch = 0.8
                    player.knockback = 0.5
                    player.maxspeed = 1.0
                    pUser.jumpRate = 1.25
                    pUser.speedRate = 1.03
                    pUser.jumpLevel = 1
                    pUser.resistance = 0.7
                    pUser.canIcraus = true
                    player:Signal(SignalToUI.icarusSkillGet)
                    player:Signal(SignalToUI.feedbackSkillGet)
                    --赤炎恶鬼
                end,
            }

            local modelSwitchFunc = modelSwitch[theModelNumber]
            if modelSwitchFunc then
                modelSwitchFunc()
            else
                playermaxhealth = 1000
                playermaxarmor = 1000
                playerhealth = 1000
                playerarmor = 1000
                playerflinch = 1.0
                playerknockback = 1.0
                playermaxspeed = 1.0
                pUserjumpRate = 1.0
                pUserspeedRate = 1.0
                pUserjumpLevel = 1
                pUsercanIcraus = false
            end
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

    --呼吸回血
    if signal == SignalToGame.healthRecover then
        if pUser.zombie and pUser.recover then
            if player.health + 500 <= player.maxhealth then
                player.health = player.health + 500
            else
                player.health = player.maxhealth
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

    -- 현재 플레이어 수에 따라 좀비 수 결정
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

--table转字符串
function tableToString(luaTable)
    local tableString = "";
    for k, v in pairs(luaTable) do
        tableString = tableString .. v
    end
    return tableString
end

--递归遍历table
function ZCLOG(Lua_table)
    for k, v in pairs(Lua_table) do
        if type(v) == "table" then
            for kk, vv in pairs(v) do
                print(kk, " = ", vv)
                -- log(kk, " = ", vv)
            end
        else
            print(k, " = ", v)
            log(k, " = ", v)
        end
    end
end

--获得table长度
function ZCLOGLength(Lua_table)
    local length = 0
    for k, v in pairs(Lua_table) do
        length = length + 1
    end
    return length
end

--复制table
function copyTable(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == "table" then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[copyTable(orig_key)] = copyTable(orig_value)
        end
    else
        -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

--选择性复制技能表
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
    if pUser.currentExp >= playerLevelUpExp then
        pUser.currentExp = pUser.currentExp - playerLevelUpExp
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
    return theExp / playerLevelUpExp or 0
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
            local thePlayer = players[i]
            local pUser = thePlayer.user
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
                human.position = humanGatherEntityBlock.position
            end
            if zombie ~= nil then
                zombie.position = hostRespawnEntityBlock.position
            end
        end
    end
end

--播放生化大逃杀准备音乐
function playZEMusic()
    Game.SetTrigger("playZEMusic", true)
end



