--屏幕分辨率
screen = UI.ScreenSize()
center = { x = screen.width / 2, y = screen.height / 2 }

--被感染提示
layerNameInfect = "被感染提示"
--回合准备时间
READY_TIME = 20
--是否是首局游戏
thisIsYourFirstRound = true
--是否有toast展示
isToast = false
--展示toast的层名称
toastLayerName = nil
--预定好toast消失的时间
toastFadeTime = UI.GetTime()
--是否显示技能图标
showSkillImageBox = true
--技能显示是否被占用
skillDescOccupation = false

--是否持续按下Space
spaceHolding = false
holdingTime = nil
--技能栏键盘
--实例化一个按键监听器
local keyboard = Keyboard();
--启用按键监听器
keyboard:enable();




--总计分同步变量
--同步变量
scoreGoal = UI.SyncValue:Create('goal')
scoreHuman = UI.SyncValue:Create("human")
scoreZombie = UI.SyncValue:Create("zombie")
--绘制ui
scoreBG = UI.Box.Create()
scoreBG:Set({ x = center.x - 135, y = 5, width = 270, height = 50, r = 10, g = 10, b = 10, a = 180 })
goalBG = UI.Box.Create()
goalBG:Set({ x = center.x - 35, y = 5, width = 70, height = 50, r = 0, g = 0, b = 0, a = 180 })
goalLabel = UI.Text.Create()
goalLabel:Set({ text = '00', font = 'medium', align = 'center', x = center.x - 50, y = 17, width = 100, height = 50, r = 255, g = 255, b = 255 })

humanLabel = UI.Text.Create()
humanLabel:Set({ text = '00', font = 'large', align = 'left', x = center.x - 127, y = 18, width = 100, height = 50, r = 100, g = 100, b = 255 })

zombieLabel = UI.Text.Create()
zombieLabel:Set({ text = '00', font = 'large', align = 'right', x = center.x + 26, y = 18, width = 100, height = 50, r = 255, g = 80, b = 80 })

--包裹地速栏和时间栏
userPanelBox = UI.Box.Create()
userPanelBox:Set({ x = 20, y = screen.height - 100, width = 150, height = 50, r = 50, g = 50, b = 50, a = 200 })
--地速栏
speedPanel = UI.SyncValue:Create('speedPanel' .. tostring(UI.PlayerIndex()))
speedPanelLable = UI.Text.Create()
speedPanelLable:Set({ text = "0", font = 'small', align = 'center', x = 10, y = screen.height - 85, width = 100, height = 20, r = 0, g = 150, b = 250 })

--伤害栏
damagePanel = UI.SyncValue:Create("damagePanel" .. tostring(UI.PlayerIndex()))
damageLabel = UI.Text.Create()
roundTotalDamageLabel = UI.Text.Create()
damageLabel:Set({ text = "0", font = "small", align = "center", x = 80, y = screen.height - 85, width = 100, height = 20, r = 244, g = 164, b = 96 })
roundTotalDamageLabel:Set({ text = "0", font = "small", align = "center", x = 80, y = screen.height - 65, width = 100, height = 20, r = 220, g = 50, b = 25 })

--时间栏
timePanel = UI.SyncValue:Create('timePanel')
timePanelLabel = UI.Text.Create()
timePanelLabel:Set({ text = '00', font = 'medium', align = 'center', x = center.x - 50, y = 20, width = 100, height = 150, r = 255, g = 255, b = 255 })

--技能点栏
skillPoint = UI.SyncValue:Create("skillPoint" .. tostring(UI.PlayerIndex()))
skillPointBox = UI.Box.Create()
skillPointBox:Set({ x = 170, y = screen.height - 100, width = 50, height = 50, r = 50, g = 50, b = 50, a = 200 })
skillPointLabel = UI.Text.Create()
skillPointLabel:Set({ text = '01', font = 'medium', align = 'left', x = 170, y = screen.height - 80, width = 50, height = 35, r = 124, g = 252, b = 0 })



--ui game 交互变量
youAreZombie = false
roundTotalDamage = 0
stopControlTime = UI.GetTime()
stopControlStatus = false
--极速飞奔
sprintCDTime = UI.GetTime() --冷却时间
sprintDurationTime = UI.GetTime() --持续时间
sprintCoolDownReady = true --是否冷却完毕
sprintImageIndexInTable = nil --在技能表里的下标
--致命打击
criticalCDTime = UI.GetTime() --冷却时间
criticalDurationTime = UI.GetTime() --持续时间
criticalCoolDownReady = true --是否冷却完毕
criticalImageIndexInTable = nil --在技能表里的下标

--高速填装和透明换弹
sneakReloadImageIndexInTable = nil --透明换弹在技能表里的下标
sneakReloadCoolDownTime = UI.GetTime() --透明换弹冷却时间
sneakReloadCoolDownReady = true
quickReloadImageIndexInTable = nil --高速填装在技能表里的下标
quickReloadCoolDownTime = UI.GetTime() --高速填装冷却时间
quickReloadCoolDownReady = true

icarusCoolDownReady = true --伊卡洛斯冷却完毕
icarusCoolDownTime = UI.GetTime() --伊卡洛斯冷却时间
zombieSpecialSkillCoolDownReady = true --僵尸技能冷却完毕
zombieSpecialSkillDurationTime = UI.GetTime() --僵尸技能持续时间
zombieSpecialSkillCoolDownTime = UI.GetTime() --僵尸技能冷却时间

speedChangedImpactTime = UI.GetTime() --冲击减速时间
speedChangedGhostHandTime = UI.GetTime() --冲击减速时间
--ui game 交互变量

--仅限ui交互变量
skillTableToShow = {
    {
        "hpPlus", --名称
        20, --权重
        "僵尸技能-恢复强化：一段时间没有受到伤害后开始回复生命值。", --描述
        SignalToUI.hpPlusSkillGet, --信号值
        imageHpPlus, --对应图标
        false, --是否有冷却时间
        0 --冷却时长
    },
    {
        "rehydration",
        20,
        "僵尸技能-生命补液：拥有更高的生命值上限。",
        SignalToUI.rehydrationSkillGet,
        imageRehydration,
        false,
        0
    },
    {
        "ironChest",
        10,
        "僵尸技能-钢铁铠甲：降低受到的非致命打击伤害。",
        SignalToUI.ironChestSkillGet,
        imageIronChest,
        false,
        0
    },
    {
        "deflectArmor",
        10,
        "僵尸技能-倾斜装甲：装配光滑并且带有一定倾斜角度的装甲使得你有概率反弹子弹，免伤并且使攻击者受到伤害惩罚。",
        SignalToUI.deflectArmorSkillGet,
        imageDeflectArmor,
        false,
        0
    },
    {
        "ironHelmet",
        10,
        "僵尸技能-钢铁头盔：降低受到的致命打击伤害。",
        SignalToUI.ironHelmetSkillGet,
        imageIronHelmet,
        false,
        0
    },
    {
        "sufferMemory",
        10,
        "僵尸技能-痛苦记忆：极大幅度降低上次击杀你的玩家对你造成的伤害。",
        SignalToUI.sufferMemorySkillGet,
        imageSufferMemory,
        false,
        0
    },
    {
        "ironClaw",
        20,
        "僵尸技能-合金利爪：对英雄的伤害翻倍。",
        SignalToUI.ironClawSkillGet,
        imageIronClaw,
        false,
        0
    },
    {
        "touchInfect",
        5,
        "僵尸技能-接触感染：与你发生身体碰撞的人类玩家会立刻死亡并感染，但这并不会算作你的击杀。",
        SignalToUI.touchInfectSkillGet,
        imageTouchInfect,
        false,
        0
    },
    {
        "evolution",
        20,
        "僵尸技能-进化论：受到伤害时获得的经验值更多，且你被赋予成为英雄僵尸的可能性。",
        SignalToUI.evolutionSkillGet,
        imageEvolution,
        false,
        0
    },
    {
        "adaptability",
        5,
        "僵尸技能-适应力：可以随时切换僵尸模型。",
        SignalToUI.adaptabilitySkillGet,
        imageAdaptability,
        false,
        0
    },
    {
        "mammoth",
        15,
        "僵尸技能-猛犸：移动速度较低时降低受到的伤害。",
        SignalToUI.mammothSkillGet,
        imageMammoth,
        false,
        0
    },
    {
        "repair",
        15,
        "僵尸技能-组织再生：受到攻击时概率恢复护甲值。",
        SignalToUI.repairSkillGet,
        imageRepair,
        false,
        0
    },
    {
        "sneakReload",
        5,
        "人类技能-透明换弹：装弹过程中保持隐身。",
        SignalToUI.sneakReloadSkillGet,
        imageSneakReload,
        true,
        15
    },
    {
        "quickReload",
        15,
        "人类技能-高速填装：换弹过程中移动速度增加。",
        SignalToUI.quickReloadSkillGet,
        imageQuickReload,
        true,
        10
    },
    {
        "backClip",
        15,
        "人类技能-备弹补充：使用常规弹夹的武器拥有无限备弹。",
        SignalToUI.backClipSkillGet,
        imageBackClip,
        false,
        0
    },
    {
        "recycle",
        5,
        "人类技能-弹夹回收：使用特殊子弹的武器有概率回收子弹。",
        SignalToUI.recycleSkillGet,
        imageRecycle,
        false,
        0
    },
    {
        "kangaroo",
        10,
        "人类技能-袋鼠：拥有更出色的重力参数。",
        SignalToUI.kangarooSkillGet,
        imageKangaroo,
        false,
        0
    },
    {
        "cheetah",
        10,
        "人类技能-猎豹：拥有更出色的移动速度。",
        SignalToUI.cheetahSkillGet,
        imageCheetah,
        false,
        0
    },
    {
        "assault",
        10,
        "人类技能-正面突击：突击步枪拥有更高的伤害能力，霰弹枪拥有更强的击退能力。",
        SignalToUI.assaultSkillGet,
        imageAssault,
        false,
        0
    },
    {
        "forward",
        10,
        "人类技能-冲锋推进：冲锋枪拥有更快的移动速度，轻机枪拥有更好的定身能力。",
        SignalToUI.forwardSkillGet,
        imageForward,
        false,
        0
    },
    {
        "sprint",
        5,
        "人类技能-极速飞奔：5键激活，一段时间内提高移动速度。",
        SignalToUI.sprintSkillGet,
        imageSprint,
        true,
        60
    },
    {
        "critical",
        5,
        "人类技能-致命打击：6键激活一段时间内造成四倍伤害。",
        SignalToUI.criticalSkillGet,
        imageCritical,
        true,
        60
    },
    {
        "hero",
        2,
        "人类技能-英雄出现：有概率被选为英雄。",
        SignalToUI.heroSkillGet,
        imageHero,
        false,
        0
    },
    {
        "edge",
        8,
        "人类技能-利刃：近战武器造成额外伤害。",
        SignalToUI.edgeSkillGet,
        imageEdge,
        false,
        0
    },
    {
        "shooter",
        5,
        "人类技能-神枪手：当你的背包里拥有狙击步枪时，你不需要开镜也能获得一个准心。",
        SignalToUI.shooterSkillGet,
        imageShooter,
        false,
        0
    }
}
zombieSkillTableToShow = {
    {
        "二段跳", --名称
        0, --权重
        "二段跳：跳跃后，使用空格键可以再获得一次上升速度。", --描述
        0, --信号值
        imageDoubleJump, --对应图标
        false, --是否有冷却时间
        0 --冷却时长
    }, {
        "伊卡洛斯",
        0,
        "伊卡洛斯：持续按住空格可以在跳跃后进行小段距离的高速滑翔。",
        SignalToUI.icarus,
        imageICarusGreen,
        true,
        3

    }, {
        "硬化",
        0,
        "硬化：G键激活，激活后一段时间内大幅减少受到的伤害。",
        SignalToUI.induration,
        imageInduration,
        true,
        20

    }, {
        "潜伏",
        0,
        "潜伏：G键激活，激活后一段时间内移动速度低于150时模型隐形。",
        SignalToUI.lurk,
        imageLurk,
        true,
        20
    }, {
        "鬼手",
        0,
        "鬼手：G键激活，若激活期间死亡则定身击败你的对手3秒。",
        SignalToUI.ghostHand,
        imageGhostHand,
        true,
        20
    }, {
        "治愈",
        0,
        "治愈：G键激活，激活后一段时间内持续回复生命值。",
        SignalToUI.cure,
        imageCure,
        true,
        20
    }, {
        "震荡",
        0,
        "震荡：G键激活，若激活期间死亡则缴械击败你的对手。",
        SignalToUI.shock,
        imageShock,
        true,
        20
    }, {
        "坚定向前",
        0,
        "坚定向前：G键激活，激活后一段时间内获得极大幅度的抗击退能力。",
        SignalToUI.firmly,
        imageFirmly,
        true,
        20
    }, {
        "冲击",
        0,
        "冲击：G键激活，若激活期间死亡则减速击败你的对手8秒。",
        SignalToUI.impact,
        imageImpact,
        true,
        20
    }, {
        "诱捕",
        0,
        "诱捕：G键激活，若激活期间死亡则将击败你的对手传送至你死亡的位置。",
        SignalToUI.trap,
        imageTrap,
        true,
        20
    }, {
        "反馈",
        0,
        "反馈：G键激活，若激活期间死亡则虚弱杀死你的对手8秒。",
        SignalToUI.feedback,
        imageFeedBack,
        true,
        20
    }, {
        "飞跃",
        0,
        "飞跃：G键激活，激活后瞬间获得较高的跳跃速度。",
        SignalToUI.leap,
        imageLeap,
        true,
        20
    }, {
        "免死",
        0,
        "免死：G键激活，若激活期间死亡则免除死亡替换为眩晕2秒。",
        SignalToUI.undying,
        imageUndying,
        true,
        20
    }, {
        "缠身",
        0,
        "缠身：G键激活，若激活期间死亡则复活至击杀你的玩家处。",
        SignalToUI.hidden,
        imageHidden,
        true,
        20
    }, {
        "自爆",
        0,
        "自爆：被动触发，死亡时发生范围爆炸。",
        0,
        imageDestruction,
        false,
        0
    }
}
yourZombieSkillTable = {}
yourHumanSkillTable = {}
--仅限ui交互变量结束

--僵尸技能以及透明换弹提示Box
skillBox = nil
function skillBoxTip(red, green, blue, alpha)
    if skillBox == nil then
        skillBox = UI.Box.Create()
    end
    skillBox:Set({
        x = 0,
        y = 0,
        width = screen.width,
        height = screen.height,
        r = red or 255,
        g = green or 0,
        b = blue or 0,
        a = alpha or 100
    })
    skillBox:Show()
end
--技能提示Box结束
--致命打击和极速飞奔技能提示
sprintBox = nil
criticalBox = nil
function sprintBoxTip(red, green, blue, alpha)
    if sprintBox == nil then
        sprintBox = UI.Box.Create()
    end
    sprintBox:Set({
        x = 0,
        y = 0,
        width = screen.width,
        height = screen.height,
        r = red or 200,
        b = blue or 200,
        g = green or 200,
        a = alpha or 150
    })
    sprintBox:Show()
end
--致命打击
function criticalBoxTip(red, green, blue, alpha)
    if criticalBox == nil then
        criticalBox = UI.Box.Create()
    end
    criticalBox:Set({
        x = 0,
        y = 0,
        width = screen.width,
        height = screen.height,
        r = red or 245,
        b = blue or 245,
        g = green or 220,
        a = alpha or 150
    })
    criticalBox:Show()
end
--神枪手准心
shooterCrosshairBox = nil
function shooterCrosshairBoxTip(show)
    if shooterCrosshairBox == nil then
        shooterCrosshairBox = UI.Box.Create()
    end
    shooterCrosshairBox:Set({
        x = center.x - 2,
        y = center.y - 2,
        width = 4,
        height = 4,
        r = 0,
        g = 255,
        b = 0,
        a = 255
    })
    if show == true then
        shooterCrosshairBox:Show()
    else
        shooterCrosshairBox:Hide()
    end
end

--总局数
function scoreGoal:OnSync()
    local str = string.format("%02d", self.value)
    goalLabel:Set({ text = str })
end
--人类获胜回合
function scoreHuman:OnSync()
    local str = string.format("%02d", self.value)
    humanLabel:Set({ text = str })
end
--僵尸获胜回合
function scoreZombie:OnSync()
    local str = string.format("%02d", self.value)
    zombieLabel:Set({ text = str })
end

--地速栏
function speedPanel:OnSync()
    local speedValue = self.value
    -- speedPanelLable:Set({text = string.sub(speedString, ((UI.PlayerIndex() - 1) * 4) + 1, UI.PlayerIndex() * 4)})
    speedPanelLable:Set({ text = string.format("%d", speedValue) })
end

--时间栏
function timePanel:OnSync()
    local minute = math.floor(self.value / 60)
    local second = math.floor(self.value % 60)
    local minuteString = string.format("%02d", minute)
    local secondString = string.format("%02d", second)
    timePanelLabel:Set({ text = minuteString .. ":" .. secondString })
end

--伤害栏
function damagePanel:OnSync()
    local damageValue = self.value
    damageLabel:Set({
        text = string.format("%d", damageValue)
    })
    roundTotalDamage = roundTotalDamage + damageValue
    roundTotalDamageLabel:Set({
        text = string.format("%d", roundTotalDamage)
    })
end

--技能点栏
function skillPoint:OnSync()
    local theValue = self.value
    local theValueString = ""
    if theValue == 0 then
        if skillPointBox ~= nil then
            skillPointBox:Hide()
        end
    else
        if skillPointBox ~= nil then
            skillPointBox:Show()
        end
        theValueString = string.format("%02d", theValue)
    end
    if skillPointLabel ~= nil then
        skillPointLabel:Set({
            text = theValueString
        })
    end
end

local skillOneImageId = nil
local skillTwoImageId = nil
local skillThreeImageId = nil
local skillFourImageId = nil
local skillFiveImageId = nil
local zombieSkillOneImageId = nil
local zombieSkillTwoImageId = nil

--技能图标id表
yourCurrentSkillImageIdTable = {
    skillOneImageId,
    skillTwoImageId,
    skillThreeImageId,
    skillFourImageId,
    skillFiveImageId,
    zombieSkillOneImageId,
    zombieSkillTwoImageId
}

--技能文字描述id表
yourCurrentSkillTypeLayerNameTable = {}

--box绘图id
--绘图坐标
skillPosition = {
    screen.width - 640,
    screen.height - 64,
    screen.width - 560,
    screen.height - 64,
    screen.width - 480,
    screen.height - 64,
    screen.width - 400,
    screen.height - 64,
    screen.width - 320,
    screen.height - 64,
    screen.width / 2 - 240,
    screen.height - 64,
    screen.width / 2 - 160,
    screen.height - 64,
}
--绘图坐标结束

--技能绘图
--框架
skillOneBG = UI.Box.Create()
skillTwoBG = UI.Box.Create()
skillThreeBG = UI.Box.Create()
skillFourBG = UI.Box.Create()
skillFiveBG = UI.Box.Create()
zombieSkillOneBG = UI.Box.Create()
zombieSkillTwoBG = UI.Box.Create()
if youAreZombie == false then
    zombieSkillOneBG:Hide()
    zombieSkillTwoBG:Hide()
end

--技能冷却幕布
skillCoolDonwBGTable = {
}

skillOneBG:Set({ x = skillPosition[1], y = skillPosition[2], width = 64, height = 64, r = 100, g = 100, b = 100, a = 180 })
skillTwoBG:Set({ x = skillPosition[3], y = skillPosition[4], width = 64, height = 64, r = 100, g = 100, b = 100, a = 180 })
skillThreeBG:Set({ x = skillPosition[5], y = skillPosition[6], width = 64, height = 64, r = 100, g = 100, b = 100, a = 180 })
skillFourBG:Set({ x = skillPosition[7], y = skillPosition[8], width = 64, height = 64, r = 100, g = 100, b = 100, a = 180 })
skillFiveBG:Set({ x = skillPosition[9], y = skillPosition[10], width = 64, height = 64, r = 100, g = 100, b = 100, a = 180 })
zombieSkillOneBG:Set({ x = skillPosition[11], y = skillPosition[12], width = 64, height = 64, r = 100, g = 100, b = 100, a = 180 })
zombieSkillTwoBG:Set({ x = skillPosition[13], y = skillPosition[14], width = 64, height = 64, r = 100, g = 100, b = 100, a = 180 })
--框架结束
--技能绘图结束

--游戏更新
function UI.Event:OnUpdate(time)
    --导入僵尸菜单宋体字
    if zombieMenuSongLoad == false then
        zombieMenuSongLoad = true
        Song:load(zombieMenuSong)
    end
    --导入字体部分0
    if fontPartZeroLoad == false then
        fontPartZeroLoad = true
        Song:load(fontPartZero)
    end
    --导入字体部分1
    if fontPartOneLoad == false then
        fontPartOneLoad = true
        Song:load(fontPartOne)
    end
    --导入字体部分2
    if fontPartTwoLoad == false then
        fontPartTwoLoad = true
        Song:load(fontPartTwo)
    end
    --导入字体部分3
    if fontPartThreeLoad == false then
        fontPartThreeLoad = true
        Song:load(fontPartThree)
    end
    --导入字体部分4
    if fontPartFourLoad == false then
        fontPartFourLoad = true
        Song:load(fontPartFour)
    end
    --导入字体部分5
    if fontPartFiveLoad == false then
        fontPartFiveLoad = true
        Song:load(fontPartFive)
    end
    --导入字体部分6
    if fontPartSixLoad == false then
        fontPartSixLoad = true
        Song:load(fontPartSix)
    end
    --导入字体部分7
    if fontPartSevenLoad == false then
        fontPartSevenLoad = true
        Song:load(fontPartSeven)
    end
    --导入字体部分8
    if fontPartEightLoad == false then
        fontPartEightLoad = true
        Song:load(fontPartEight)
    end
    --导入字体部分9
    if fontPartNineLoad == false then
        fontPartNineLoad = true
        Song:load(fontPartNine)
    end
    --导入字体部分10
    if fontPartTenLoad == false then
        fontPartTenLoad = true
        Song:load(fontPartTen)
    end


    --toast提示框关闭
    if isToast == true then
        if time >= toastFadeTime then
            closeToastOnScreen()
            drawSkillImageFunc(youAreZombie)
        end
    end

    --僵尸模块
    if youAreZombie == true then
        --伊卡洛斯冷却
        if icarusCoolDownReady == false then
            local theIcarusCoolDownBG = skillCoolDonwBGTable[6]
            if theIcarusCoolDownBG == nil then
                theIcarusCoolDownBG = UI.Box.Create()
                skillCoolDonwBGTable[6] = theIcarusCoolDownBG
                theIcarusCoolDownBG:Set(getSkillBgArgs(6))
            end
            if icarusCoolDownTime >= time then
                theIcarusCoolDownBG:Set({
                    height = math.floor(64 * (icarusCoolDownTime - time) / 3)
                })
            else
                theIcarusCoolDownBG:Set({
                    height = 0
                })
                icarusCoolDownReady = true
            end
        end
        -- 伊卡洛斯结束
        --僵尸技能冷却
        if zombieSpecialSkillCoolDownReady == false then
            --技能提示幕布
            if zombieSpecialSkillDurationTime <= time then
                if skillBox ~= nil then
                    skillBox:Hide()
                end
            end
            local theZombieSpecialSkillCoolDownBG = skillCoolDonwBGTable[7]
            if theZombieSpecialSkillCoolDownBG == nil then
                theZombieSpecialSkillCoolDownBG = UI.Box.Create()
                skillCoolDonwBGTable[7] = theZombieSpecialSkillCoolDownBG
                theZombieSpecialSkillCoolDownBG:Set(getSkillBgArgs(7))
            end
            if zombieSpecialSkillCoolDownTime >= time then
                theZombieSpecialSkillCoolDownBG:Set({
                    height = math.floor(64 * (zombieSpecialSkillCoolDownTime - time) / 20)
                })
            else
                theZombieSpecialSkillCoolDownBG:Set({
                    height = 0
                })
                zombieSpecialSkillCoolDownReady = true
            end
        end
        --僵尸技能冷却结束
    end

    --人类有冷却时间的技能
    if skillBox ~= nil then
        if youAreZombie == false then
            --透明换弹冷却进度
            if sneakReloadCoolDownReady == false and sneakReloadImageIndexInTable ~= nil then
                local theSneakReloadCoolDownBG = skillCoolDonwBGTable[sneakReloadImageIndexInTable]
                if theSneakReloadCoolDownBG == nil then
                    theSneakReloadCoolDownBG = UI.Box.Create()
                    skillCoolDonwBGTable[sneakReloadImageIndexInTable] = theSneakReloadCoolDownBG
                    theSneakReloadCoolDownBG:Set(getSkillBgArgs(sneakReloadImageIndexInTable))
                end
                if sneakReloadCoolDownTime >= time then
                    theSneakReloadCoolDownBG:Set({
                        height = math.floor(64 * (sneakReloadCoolDownTime - time) / 10)
                    })
                else
                    theSneakReloadCoolDownBG:Set({
                        height = 0
                    })
                    sneakReloadCoolDownReady = true
                end
            end

            --高速填装冷却进度
            if quickReloadCoolDownReady == false and quickReloadImageIndexInTable ~= nil then
                local theQuickReloadCoolDownBG = skillCoolDonwBGTable[quickReloadImageIndexInTable]
                if theQuickReloadCoolDownBG == nil then
                    theQuickReloadCoolDownBG = UI.Box.Create()
                    skillCoolDonwBGTable[quickReloadImageIndexInTable] = theQuickReloadCoolDownBG
                    theQuickReloadCoolDownBG:Set(getSkillBgArgs(quickReloadImageIndexInTable))
                end
                if quickReloadCoolDownTime >= time then
                    theQuickReloadCoolDownBG:Set({
                        height = math.floor(64 * (quickReloadCoolDownTime - time) / 10)
                    })
                else
                    theQuickReloadCoolDownBG:Set({
                        height = 0
                    })
                    quickReloadCoolDownReady = true
                end
            end

        end
    end

    --极速飞奔冷却进度
    if sprintBox ~= nil then
        if sprintBox:IsVisible() == true then
            if sprintDurationTime <= time then
                sprintBox:Hide()
            end
        end
        if sprintCoolDownReady == false and sprintImageIndexInTable ~= nil then
            local theCoolDownBG = skillCoolDonwBGTable[sprintImageIndexInTable]
            if theCoolDownBG == nil then
                theCoolDownBG = UI.Box.Create()
                skillCoolDonwBGTable[sprintImageIndexInTable] = theCoolDownBG
                theCoolDownBG:Set(getSkillBgArgs(sprintImageIndexInTable))
            end
            if sprintCDTime >= time then
                theCoolDownBG:Set({
                    height = math.floor(64 * (sprintCDTime - time) / 60)
                })
            else
                theCoolDownBG:Set({
                    height = 0
                })
                sprintCoolDownReady = true
            end
        end
    end

    --致命打击冷却进度
    if criticalBox ~= nil then
        if criticalBox:IsVisible() == true then
            if criticalDurationTime <= time then
                criticalBox:Hide()
            end
        end
        if criticalCoolDownReady == false and criticalImageIndexInTable ~= nil then
            local theCoolDownBG = skillCoolDonwBGTable[criticalImageIndexInTable]
            if theCoolDownBG == nil then
                theCoolDownBG = UI.Box.Create()
                skillCoolDonwBGTable[criticalImageIndexInTable] = theCoolDownBG
                theCoolDownBG:Set(getSkillBgArgs(criticalImageIndexInTable))
            end
            if criticalCDTime >= time then
                theCoolDownBG:Set({
                    height = math.floor(64 * (criticalCDTime - time) / 60)
                })
            else
                theCoolDownBG:Set({
                    height = 0
                })
                criticalCoolDownReady = true
            end
        end
    end

    --冲击减速
    if time <= speedChangedImpactTime then
        UI.Signal(SignalToGame.speedChangedImpact)
    end

    --鬼手定身
    if time <= speedChangedGhostHandTime then
        UI.Signal(SignalToGame.speedChangedGhostHand)
    end

    -- 回合开始时静止
    if stopControlStatus == true then
        if time <= stopControlTime then
            UI.StopPlayerControl(true)
        else
            UI.StopPlayerControl(false)
            stopControlStatus = false
        end
    end

end

--玩家信号
function UI.Event:OnSignal(signal)

    local uiTime = UI.GetTime()

    --回合重置
    if signal == SignalToUI.rounderReset then
        youAreZombie = false --恢复成人类状态
        --技能提示(透明换弹、高速填装)
        if skillBox ~= nil then
            skillBox:Hide()
        end
        --透明换弹、高速填装CD时间
        sneakReloadCoolDownTime = uiTime + READY_TIME
        quickReloadCoolDownTime = uiTime + READY_TIME

        --极速飞奔还原
        if sprintBox ~= nil then
            sprintBox:Hide()
        end
        sprintDurationTime = uiTime
        sprintCDTime = uiTime + READY_TIME
        --致命打击还原
        if criticalBox ~= nil then
            criticalBox:Hide()
        end
        criticalDurationTime = uiTime
        criticalCDTime = uiTime + READY_TIME

        --技能幕布绘制
        if thisIsYourFirstRound == true then
            thisIsYourFirstRound = false
        end
        --技能幕布绘制结束

        --绘制技能图标
        drawSkillImageFunc(youAreZombie)
        zombieSkillOneBG:Hide()
        zombieSkillTwoBG:Hide()
        --绘制技能图标结束

        --伤害还原
        damageLabel:Set({ text = "0" })
        roundTotalDamageLabel:Set({ text = "0" })
        stopControlStatus = true
        stopControlTime = uiTime + 2
    end

    --消除所有改变模型状态的图标
    if signal == SignalToUI.modelRestore then
        --技能提示
        if skillBox ~= nil then
            skillBox:Hide()
        end
        --致命打击和极速飞奔技能提示
        if sprintBox ~= nil then
            sprintBox:Hide()
        end
        if criticalBox ~= nil then
            criticalBox:Hide()
        end
    end

    --消除透明换弹和高速填装模型状态图标
    if signal == SignalToUI.sneakQuickReloadSuspend then
        --技能提示
        if skillBox ~= nil then
            skillBox:Hide()
        end
    end

    --显示透明换弹技能提示
    if signal == SignalToUI.sneakReload then
        skillBoxTip(0, 100, 100, 50)
        sneakReloadCoolDownTime = uiTime + 10
        sneakReloadCoolDownReady = false
    end

    --显示高速填装技能提示
    if signal == SignalToUI.quickReload then
        skillBoxTip(65, 150, 225, 50)
        quickReloadCoolDownTime = uiTime + 10
        quickReloadCoolDownReady = false
    end

    --G键技能
    if signal == SignalToUI.gKeyUsed then
        skillBoxTip(255, 25, 50, 50)
    end
    if signal >= SignalToUI.induration and signal <= SignalToUI.leap then
        local theSignal = signal
        skillBoxTip(255, 25, 50, 50)
        zombieSpecialSkillCoolDownTime = uiTime + 20
        zombieSpecialSkillCoolDownReady = false
        if theSignal >= SignalToUI.induration and signal <= SignalToUI.feedback then
            --持续时长为10秒的僵尸技能
            zombieSpecialSkillDurationTime = uiTime + 10
        elseif theSignal >= SignalToUI.ghostHand and theSignal <= SignalToUI.hidden then
            --持续时长为3秒的僵尸技能
            zombieSpecialSkillDurationTime = uiTime + 3
        else
            --持续时长为1秒的僵尸技能
            zombieSpecialSkillDurationTime = uiTime + 1
        end

    end

    --僵尸感染
    if signal == SignalToUI.infect then
        youAreZombie = true

        closeToastOnScreen()
        makeToastOnScreen("感染后首次M切换僵尸。", 2, nil, nil, nil, layerNameInfect, nil)

        zombieSkillOneBG:Show()
        zombieSkillTwoBG:Show()
    end

    --伊卡洛斯
    if signal == SignalToUI.icarusSkillGet then
        yourZombieSkillTable[6] = zombieSkillTableToShow[2]
        drawSkillImageFunc(youAreZombie)
    end
    --二段跳
    if signal == SignalToUI.doubleJumpSkillGet then
        yourZombieSkillTable[6] = zombieSkillTableToShow[1]
        drawSkillImageFunc(youAreZombie)
    end

    --僵尸技能获得
    if signal >= SignalToUI.indurationSkillGet and signal <= SignalToUI.destructionSkillGet then
        --76
        print(signal)
        yourZombieSkillTable[7] = zombieSkillTableToShow[signal - 76]
        drawSkillImageFunc(youAreZombie)
    end

    --伊卡洛斯滑翔
    if signal == SignalToUI.icarus then
        icarusCoolDownReady = false
        icarusCoolDownTime = uiTime + 3
    end

    --落地
    if signal == SignalToUI.land then
    end

    --极速飞奔
    if signal == SignalToUI.sprint then
        sprintBoxTip(200, 200, 200, 100)
        sprintDurationTime = uiTime + 10
        sprintCDTime = uiTime + 60
        sprintCoolDownReady = false
    end

    --致命打击
    if signal == SignalToUI.critical then
        criticalBoxTip(250, 250, 210, 100)
        criticalDurationTime = uiTime + 10
        criticalCDTime = uiTime + 60
        criticalCoolDownReady = false
    end

    --获得技能
    if signal >= SignalToUI.hpPlusSkillGet and signal <= SignalToUI.shooterSkillGet then

        closeToastOnScreen()

        local layerNameSkillGet = "获得技能"
        local skillSortNumber = signal - 16
        makeToastOnScreen(skillTableToShow[skillSortNumber][3], 2, nil, nil, nil, layerNameSkillGet, nil)

        if signal <= SignalToUI.repairSkillGet then
            table.insert(yourZombieSkillTable, skillTableToShow[skillSortNumber])
        else
            table.insert(yourHumanSkillTable, skillTableToShow[skillSortNumber])
        end

        --移除技能图标
        removeSkillImageFuncremoveSkillImageFunc(youAreZombie)
    end
    --神枪手准心
    if signal == SignalToUI.shooterCrosshairShow then
        shooterCrosshairBoxTip(true)
    end
    if signal == SignalToUI.shooterCrosshairHide then
        shooterCrosshairBoxTip(false)
    end
    --神枪手准心结束

    --英雄出现
    if signal == SignalToUI.chosenHero then
        closeToastOnScreen()
        makeToastOnScreen("你被选定为英雄。", 2, nil, nil, nil, "英雄出现", nil)
    end

    --免死技能
    if signal == SignalToUI.undyingLoseControl then
        UI.StopPlayerControl(true)
        skillBoxTip(0, 0, 0, 150)
    end
    if signal == SignalToUI.undyingGetControl then
        UI.StopPlayerControl(false)
        if skillBox ~= nil then
            skillBox:Hide()
        end
    end


    --回合结束
    if signal == SignalToUI.escapeSuccess then
        if youAreZombie == true then
            closeToastOnScreen()
            makeToastOnScreen("追捕失败：你的猎物逃跑了", 2, nil, nil, (screen.height * 0.5) - 100, "回合结束", 5)
        else
            closeToastOnScreen()
            makeToastOnScreen("逃脱成功：终于重见天日", 2, nil, nil, (screen.height * 0.5) - 100, "回合结束", 5)
        end
    end
    if signal == SignalToUI.escapeFail then
        if youAreZombie == true then
            closeToastOnScreen()
            makeToastOnScreen("追捕成功：尽情享受你的猎物吧", 2, nil, nil, (screen.height * 0.5) - 100, "回合结束", 5)
        else
            closeToastOnScreen()
            makeToastOnScreen("逃脱失败：你将永远留在这里", 2, nil, nil, (screen.height * 0.5) - 100, "回合结束", 5)
        end
    end

    --冲击减速
    if signal == SignalToUI.speedChangedImpact then
        speedChangedImpactTime = uiTime + 8
    end
    --鬼手定身
    if signal == SignalToUI.speedChangedGhostHand then
        speedChangedGhostHandTime = uiTime + 3
    end

end



--暂停2秒

-- UI.StopPlayerControl(true)

--暂停2秒

--删除技能图标
function removeSkillImageFuncremoveSkillImageFunc(youAreZombie)
    local theDrawImageTable = nil
    if youAreZombie == true then
        theDrawImageTable = yourZombieSkillTable
    else
        theDrawImageTable = yourHumanSkillTable
    end
    for i = 1, 7 do
        --删除之前的图标
        if yourCurrentSkillImageIdTable[i] ~= nil then
            UIGraphics:Remove(yourCurrentSkillImageIdTable[i])
            yourCurrentSkillImageIdTable[i] = nil
        end
    end
end
--删除技能图标结束

--绘制技能图标
function drawSkillImageFunc(youAreZombie)
    local theDrawImageTable = nil
    if youAreZombie == true then
        theDrawImageTable = yourZombieSkillTable

    else
        theDrawImageTable = yourHumanSkillTable
    end
    for i = 1, 7 do
        --删除之前的图标
        if yourCurrentSkillImageIdTable[i] ~= nil then
            UIGraphics:Remove(yourCurrentSkillImageIdTable[i])
            yourCurrentSkillImageIdTable[i] = nil
        end

        --重画一遍
        if theDrawImageTable[i] ~= nil and showSkillImageBox == true then
            if i == 7 then
                yourCurrentSkillImageIdTable[i] = UIGraphics:DrawImage(
                        skillPosition[(i * 2) - 1] + 4, skillPosition[i * 2] + 4, 1, theDrawImageTable[i][5]
                )
            else
                yourCurrentSkillImageIdTable[i] = UIGraphics:DrawImage(
                        skillPosition[(i * 2) - 1], skillPosition[i * 2], 1, theDrawImageTable[i][5]
                )
            end

            local theSkillName = theDrawImageTable[i][1]
            if theSkillName == "sneakReload" then
                sneakReloadImageIndexInTable = i
            elseif theSkillName == "quickReload" then
                quickReloadImageIndexInTable = i
            elseif theSkillName == "sprint" then
                sprintImageIndexInTable = i
            elseif theSkillName == "critical" then
                criticalImageIndexInTable = i
            end
        end
    end
end
--绘制技能图标结束

--删除技能文字描述
function removeSkillDescribe()
    SkillMask:closeToast("skillTypeLayer")
    showSkillImageBox = true
    drawSkillImageFunc(youAreZombie)
    skillDescOccupation = false
end
--删除技能文字描述结束

--绘制技能文字描述
function typeSkillDescribe(index)
    if index ~= nil and skillDescOccupation == false then
        SkillMask:closeToast("skillTypeLayer")
        local theTypeTable = nil
        if youAreZombie == true then
            theTypeTable = yourZombieSkillTable
        else
            theTypeTable = yourHumanSkillTable
        end
        if theTypeTable[index] ~= nil then
            removeSkillImageFuncremoveSkillImageFunc(youAreZombie)
            showSkillImageBox = false
            if index > 0 then
                skillDescOccupation = true
                SkillMask:makeText("技能" .. index .. "-" .. theTypeTable[index][3] .. "(K键关闭)", nil, nil, screen.height * 0.5 - 100, "skillTypeLayer")
            end
            if index == 0 then
                --伊卡洛斯
                skillDescOccupation = true
            end
            if index == -1 then
                --二段跳
                skillDescOccupation = true
            end
        end
    end
end
--绘制技能文字描述结束

--技能幕布统一属性
function getSkillBgArgs(index)
    if index == nil then
        return {}
    end
    return {
        x = skillPosition[(index * 2) - 1],
        y = skillPosition[index * 2],
        width = 64,
        height = 0,
        r = 30,
        g = 35,
        b = 40,
        a = 200
    }
end

--关闭toast
function closeToastOnScreen()
    Toast:closeToast(toastLayerName)
    isToast = false
    toastLayerName = nil
    showSkillImageBox = true
    drawSkillImageFunc(youAreZombie)
end

--toast显示
function makeToastOnScreen(text, duration, length, x, y, layerName, ps)
    Toast:makeText(text, length, x, y, layerName, ps)
    isToast = true
    toastLayerName = layerName
    toastFadeTime = UI.GetTime() + duration
    showSkillImageBox = false
    removeSkillImageFuncremoveSkillImageFunc(youAreZombie)
end

-- 键盘
--绑定一个组合键、
-- 切换视角按键绑定
keyboard:bind(keyboardKeyList.toggleView, function()
    UI.Signal(SignalToGame.toggleView)
end);

-- 跳跃按键绑定
keyboard:bind(keyboardKeyList.jump, function()
    UI.Signal(SignalToGame.jump)
end);

-- 伊卡洛斯按键绑定
keyboard:bind(keyboardKeyList.icarus, function()
    if not spaceHolding then
        spaceHolding = true
        holdingTime = UI.GetTime() + 0.5
    end

    if holdingTime <= UI.GetTime() then
        UI.Signal(SignalToGame.icarus)
        spaceHolding = false
    end
end);

-- 查看伊卡洛斯或二段跳按键绑定
keyboard:bind(keyboardKeyList.checkZombieSkillOne, function()
    typeSkillDescribe(6)
end);

-- 查看当前选择的僵尸的技能按键绑定
keyboard:bind(keyboardKeyList.checkZombieSkillTwo, function()
    typeSkillDescribe(7)
end);

-- 查看当前技能栏第一个技能说明按键绑定
keyboard:bind(keyboardKeyList.checkCurrentSkillOne, function()
    typeSkillDescribe(1)
end)

-- 查看当前技能栏第二个技能说明按键绑定
keyboard:bind(keyboardKeyList.checkCurrentSkillTwo, function()
    typeSkillDescribe(2)
end)

-- 查看当前技能栏第三个技能说明按键绑定
keyboard:bind(keyboardKeyList.checkCurrentSkillThree, function()
    typeSkillDescribe(3)
end)

-- 查看当前技能栏第四个技能说明按键绑定
keyboard:bind(keyboardKeyList.checkCurrentSkillFour, function()
    typeSkillDescribe(4)
end)

-- 查看当前技能栏第五个技能说明按键绑定
keyboard:bind(keyboardKeyList.checkCurrentSkillFive, function()
    typeSkillDescribe(5)
end)

-- 取消查看技能说明按键绑定
keyboard:bind(keyboardKeyList.closeSkillDescribeKLayer, function()
    removeSkillDescribe()
end);

-- 获得技能按键绑定
keyboard:bind(keyboardKeyList.getSkill, function()
    UI.Signal(SignalToGame.getSkill)
end);

-- 打开背包按键绑定
keyboard:bind(keyboardKeyList.toggleWeaponInventory, function()
    UI.Signal(SignalToGame.openWeaponInven)
end);

-- 激活僵尸技能按键绑定
keyboard:bind(keyboardKeyList.activeZombieSkill, function()
    UI.Signal(SignalToGame.gKeyUsed)
end);

-- 极速飞奔技能按键绑定
keyboard:bind(keyboardKeyList.sprintSkill, function()
    UI.Signal(SignalToGame.sprint)
end)

-- 致命打击技能按键绑定
keyboard:bind(keyboardKeyList.criticalSkill, function()
    UI.Signal(SignalToGame.critical)
end)

