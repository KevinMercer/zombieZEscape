-- 游戏初始化数值设定
gameInitializeData = {
    -- 在这里设定你想要一回合游戏持续多久，单位是秒(例如填480，即表示每一回合持续时间480秒，也就是8分钟，不包括开局选母体的时间)
    roundTime = 480,
    -- 在这里设定你想要多久选出母体，单位是秒(注意，这里甜的时间要和游戏里时间装置方块里填的时间数值相等)
    readyTime = 20,
    -- 在这里设定你想要游戏时间持续多久，单位是秒
    totalGameTime = 1800,
    -- 在这里设定最高回合数是多少
    totalRoundNumber = 5,
    -- 在这里设定是否只计算胜利的回合数(true 或者 false)
    -- (Q：这是什么意思呢？A：意思是如果值为true则只计算胜利回合数，也就是一定要人类或者僵尸任意一方胜利局数大于总局数，游戏才会结束，如果值为false，那么只要游戏回合数超过总回合数，游戏就结束)
    roundNeedWin = false,
    -- 在这里设定升级所需的经验值
    playerLevelUpExp = 5000
}

-- 购买列表包含的武器(同时也是你能获取到id并且修改属性的武器，不包含在这里的武器可能可以在游戏里拿出来，但是属性不能修改)
validateGunsList = {
    Common.WEAPON.P228,
    Common.WEAPON.Scout,
    Common.WEAPON.XM1014,
    Common.WEAPON.MAC10,
    Common.WEAPON.AUG,
    Common.WEAPON.DualBeretta, --elite
    Common.WEAPON.FiveSeven,
    Common.WEAPON.UMP45,
    Common.WEAPON.SG550Commando,
    Common.WEAPON.Galil,
    Common.WEAPON.FAMAS,
    Common.WEAPON.USP45,
    Common.WEAPON.AWP,
    Common.WEAPON.MP5,
    Common.WEAPON.M249,
    Common.WEAPON.M3,
    Common.WEAPON.M4A1,
    Common.WEAPON.TMP,
    Common.WEAPON.G3SG1,
    Common.WEAPON.DesertEagle50C, --沙鹰
    Common.WEAPON.SG552,
    Common.WEAPON.AK47,
    Common.WEAPON.P90,
    Common.WEAPON.SCAR,
    Common.WEAPON.USAS12,
    Common.WEAPON.QBB95,
    Common.WEAPON.MG3,
    Common.WEAPON.DesertEagle50CGold, --金沙鹰
    Common.WEAPON.WinchesterM1887,
    Common.WEAPON.M134Minigun, --M134
    Common.WEAPON.F2000,
    Common.WEAPON.WinchesterM1887Gold,
    Common.WEAPON.LightningAR1, --吉他
    Common.WEAPON.M24,
    Common.WEAPON.DualInfinity, --恒宇双星
    Common.WEAPON.DualInfinityCustom, --星红双子
    Common.WEAPON.QBB95AdditionalMag, --QBB95暴龙
    Common.WEAPON.MP7A1ExtendedMag, --单持MP7A1
    Common.WEAPON.SawedOffM79, --手炮
    Common.WEAPON.DualInfinityFinal, --金红双蝎
    Common.WEAPON.Crossbow, --追月连弩
    Common.WEAPON.USAS12CAMO, --迷彩USA12
    Common.WEAPON.DoubleBarrelShotgun, --破碎炙炎
    Common.WEAPON.KrissSuperV, --致命蝎刺
    Common.WEAPON.TAR21, --塔沃尔
    Common.WEAPON.BarrettM95, --巴雷特
    Common.WEAPON.DualKriss, --致命双蝎
    Common.WEAPON.AN94,
    Common.WEAPON.M16A4,
    Common.WEAPON.P90Lapin, --P90兔耳
    Common.WEAPON.Volcano, --加特林
    Common.WEAPON.MG36,
    Common.WEAPON.Salamander, --焚尽者
    Common.WEAPON.LightningSG1, --画梅
    Common.WEAPON.Tempest, --疾风之翼
    Common.WEAPON.BlackDragonCannon, --龙炮
    Common.WEAPON.TMPDragon, --TMP金龙
    Common.WEAPON.MK48,
    Common.WEAPON.FNFNC, --步枪
    Common.WEAPON.L85A2, --步枪
    Common.WEAPON.AKM, --步枪
    Common.WEAPON.HK416,
    Common.WEAPON.LightningAR2, --尘埃之光
    Common.WEAPON.Ethereal, --小提琴
    Common.WEAPON.M32MGL, --铁血重炮
    Common.WEAPON.BALROGVII, --炎魔机枪
    Common.WEAPON.TripleBarrelShotgun, --三管
    Common.WEAPON.Ripper, --电锯
    Common.WEAPON.K3,
    Common.WEAPON.Needler, --千针
    Common.WEAPON.SKULL4,
    Common.WEAPON.BALROGXI, --龙炎
    Common.WEAPON.AK74U,
    Common.WEAPON.PlasmaGun, --破晓黎明
    Common.WEAPON.Leviathan, --冰冻水加农
    Common.WEAPON.UTS15PinkGold, --金炎剃刀
    Common.WEAPON.CompoundBow, --鹰眼
    Common.WEAPON.ARX160,
    Common.WEAPON.Cyclone, --死亡射线
    Common.WEAPON.SPAS12Maverick, --战魂SPAS-12
    Common.WEAPON.Aeolis, --炙热蒸汽
    Common.WEAPON.PetrolBoomer, --暴风烈焰
    Common.WEAPON.RailCannon, --电浆轨道炮
    Common.WEAPON.Eruptor, --尿壶炮
    Common.WEAPON.Slasher, --死神使者（小电锯）
    Common.WEAPON.RPG7,
    Common.WEAPON.Guillotine, --盘龙血煞
    Common.WEAPON.CrossbowAdvance, --追月连弩EX
    Common.WEAPON.FireVulcan, --格林炮
    Common.WEAPON.JackHammer, --气锤MK3A1
    Common.WEAPON.Coilgun, --雷霆破灭者
    Common.WEAPON.DualUZI, --尤里乌斯
    Common.WEAPON.LaserMinigun, --爆能终结者
    Common.WEAPON.M4A1DarkKnight, --邪皇M4A1
    Common.WEAPON.AK47Paladin, --圣帝AK47
    Common.WEAPON.AttackM950, --暗夜流光
    Common.WEAPON.MagnumDrill, --怒海狂鲨
    Common.WEAPON.DesertEagleCrimsonHunter, --血契D.Eagle
    Common.WEAPON.FlameJackhammer, --爆炎气锤
    Common.WEAPON.SG552Lycanthrope, --狼魂SG552
    Common.WEAPON.BroadDivine, --冰瀑毁灭
    Common.WEAPON.PythonDesperado, --永恒
    Common.WEAPON.CHARGER7, --雷暴charger7
    Common.WEAPON.BOUNCER, --破灭光雷
    Common.WEAPON.StunRifle, --雷电风暴（杨永信）
    Common.WEAPON.DualBerettaGunslinger, --深渊
    Common.WEAPON.M249Phoenix, --朱雀M249
    Common.WEAPON.StarChaserAR, --璀璨星辰（AUG）
    Common.WEAPON.M32MGLVenom, --腐化重炮
    Common.WEAPON.MG3CSOGSEdition, --十年典藏MG3
    Common.WEAPON.ThunderGhostWalker, --幽影
    Common.WEAPON.InfinityLaserFist, --机械臂铠
    Common.WEAPON.ShiningHeartRod, --红宝石之心

    Common.WEAPON.Stinger, --小海皇
    Common.WEAPON.GaeBolg, -- 海皇
    Common.WEAPON.OICW  --尖端
}

-- 武器品质
weaponLevel = {
    normal = 0, -- 普通品质
    good = 1, -- 精良品质
    rare = 2, -- 稀有品质
    epic = 3, -- 史诗品质
    legend = 4, -- 传奇品质
    divine = 5 -- 神圣品质
}

-- 按键设置
keyboardKeyList = {
    toggleView = "V", -- 切换视角模式(第一人称、第三人称)
    jump = "SPACE", -- 跳跃键
    icarus = "_SPACE", -- 伊卡洛斯键(下划线表示持续按下)
    checkZombieSkillOne = "O", -- 查看僵尸技能一的按键(男性僵尸是伊卡洛斯，女性僵尸是二段跳)
    checkZombieSkillTwo = "U", -- 查看僵尸专属技能的按键(随僵尸模型绑定)
    checkCurrentSkillOne = "_L+NUM1", -- 查看当前生效的技能一(当前是人类就显示人类技能一，是僵尸就显示僵尸技能一，以此类推)
    checkCurrentSkillTwo = "_L+NUM2", -- 查看当前生效的技能二
    checkCurrentSkillThree = "_L+NUM3", -- 查看当前生效的技能三
    checkCurrentSkillFour = "_L+NUM4", -- 查看当前生效的技能四
    checkCurrentSkillFive = "_L+NUM5", -- 查看当前生效的技能五
    closeSkillDescribeKLayer = "K", -- 关闭查看技能页面
    getSkill = "Z", -- 消耗技能点获得技能
    toggleWeaponInventory = "B", -- 开关武器背包
    activeZombieSkill = "G", -- 僵尸状态下使用技能(啥？人类状态会发生什么？丢枪啊，你傻了啊。)
    sprintSkill = "NUM5", -- 如果人类有极速飞奔技能，并且处于冷却状态，可以使用这个键激活
    criticalSkill = "NUM6" -- 如果人类有致命打击技能，并且处于冷却状态，可以使用这个键激活
}


--二代僵尸技能总表
zombieSkillTableEx = {
    {
        "hpPlus", -- 技能名称，技能的唯一标识，技能名称不能重复，没有lua基础请不要改动
        10, -- 技能权重 这个数值代表这个技能在所有技能中的比重
        -- 计算方式为：比重 = 这个技能的权重值 / 所有技能权重值之和 比重越大，被获取的概率越大
        -- 注意： 权重值之和别太大，太大了会影响代码运行效率
        "恢复强化：一段时间没有受到伤害后开始回复生命值。", -- 技能描述
        SignalToUI.hpPlusSkillGet, -- 与这个技能相对应的信号值，这个信号会发送给ui 没有lua基础的请不要轻易修改
        1 -- 是否与下一个技能相冲突 0为不冲突，1为与下一个冲突
        -- 注意：如果这里是1，则下一个一定要是-1，同理如果这里是-1，上一个一定要是1
        -- 如果嫌麻烦看不懂请不要改或者全部设置为0
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
        "sneakReload", --这里的结构和二代僵尸技能总表是一模一样的
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

-- 僵尸表
zombieTable = {
    {
        -- 普通僵尸 水泥工
        name = "普通", -- 水泥工在僵尸菜单中显示的名称
        func = function()
            UI.Signal(SignalToGame.S_Zombie_Model_Normal)
        end, -- 水泥工在僵尸菜单中生效的函数
        maxhealth = 40000, -- 水泥工的最高生命值
        maxarmor = 8000, -- 水泥工的最高护甲值
        flinch = 1, -- 水泥工的定身系数(倍率，越高定身越不明显)
        knockback = 1, -- 水泥工的击退系数(倍率，越高越南被击退)
        maxspeed = 1.1, -- 水泥工的最高地速(倍率，越高地速越快，当前版本没用，僵尸模型地速都是默认290)
        gravity = 0.725, -- 水泥工的重力参数(倍率，越高跳跃高度越低，当前版本没用，僵尸模型跳跃高度都是一样的)
        jumpRate = 1.3, -- 水泥工的跳跃倍率(倍率，自定义的数值，数值越大跳得越高)
        speedRate = 1.05, -- 水泥工的移速倍率(倍率，数值越大，移速越高，加速越快，越难刹车)
        jumpLevel = 1, -- 水泥工的跳跃等级(代表一个跳跃周期能获得几次升空速度，1则代表普通的一次跳跃，2就是二段跳，3就是三段跳)
        resistance = 1, -- 水泥工的伤害抗性(倍率，数值越高受到的伤害越高)
        -- 注意从这里开始以下三项请你务必掌握一定的lua基础再修改，否则会出现文不对题的状况
        -- 如果修改错误，可能会出现你的界面显示你有二段跳的技能，但实际上你没有，你可能是有伊卡洛斯的技能
        canIcarus = true, -- 水泥工是否有伊卡洛斯(true 有 false 无)
        skillOneSignal = SignalToUI.icarusSkillGet, -- 发送水泥工获得了伊卡洛斯的信号
        skillTwoSignal = SignalToUI.indurationSkillGet -- 发送水泥工获得了模型绑定的硬化技能的信号
    }, {
        -- 暗影芭比
        name = "芭比",
        func = function()
            UI.Signal(SignalToGame.S_Zombie_Model_Light)
        end,
        maxhealth = 20000,
        maxarmor = 4000,
        flinch = 1,
        knockback = 2,
        maxspeed = 1.2,
        gravity = 0.675,
        jumpRate = 1.45,
        speedRate = 1.1,
        jumpLevel = 2,
        resistance = 2,
        -- 注意从这里开始以下三项请你务必掌握一定的lua基础再修改，否则会出现文不对题的状况
        -- 如果修改错误，可能会出现你的界面显示你有二段跳的技能，但实际上你没有，你可能是有伊卡洛斯的技能
        canIcarus = false,
        skillOneSignal = SignalToUI.doubleJumpSkillGet,
        skillTwoSignal = SignalToUI.lurkSkillGet -- 芭比潜伏技能
    }, {
        -- 憎恶屠夫 达叔
        name = "屠夫",
        func = function()
            UI.Signal(SignalToGame.S_Zombie_Model_Heavy)
        end,
        maxhealth = 60000,
        maxarmor = 10000,
        flinch = 1,
        knockback = 2,
        maxspeed = 1.05,
        gravity = 0.8,
        jumpRate = 1.2,
        speedRate = 1,
        jumpLevel = 1,
        resistance = 0.5,
        -- 注意从这里开始以下三项请你务必掌握一定的lua基础再修改，否则会出现文不对题的状况
        -- 如果修改错误，可能会出现你的界面显示你有二段跳的技能，但实际上你没有，你可能是有伊卡洛斯的技能
        canIcarus = true,
        skillOneSignal = SignalToUI.icarusSkillGet,
        skillTwoSignal = SignalToUI.ghostHandSkillGet -- 胖子鬼手技能
    }, {
        -- 迷雾鬼影 懒狗僵尸
        name = "迷雾",
        func = function()
            UI.Signal(SignalToGame.S_Zombie_Model_Phycho)
        end,
        maxhealth = 30000,
        maxarmor = 6000,
        flinch = 1,
        knockback = 0.8,
        maxspeed = 1.08,
        gravity = 0.72,
        jumpRate = 1.33,
        speedRate = 1.05,
        jumpLevel = 1,
        resistance = 0.8,
        -- 注意从这里开始以下三项请你务必掌握一定的lua基础再修改，否则会出现文不对题的状况
        -- 如果修改错误，可能会出现你的界面显示你有二段跳的技能，但实际上你没有，你可能是有伊卡洛斯的技能
        canIcarus = true,
        skillOneSignal = SignalToUI.icarusSkillGet,
        skillTwoSignal = SignalToUI.lurkSkillGet -- 和水泥工一样的硬化技能
    }, {
        -- 巫蛊术尸 男妈妈
        name = "巫蛊",
        func = function()
            UI.Signal(SignalToGame.S_Zombie_Model_Voodoo)
        end,
        maxhealth = 30000,
        maxarmor = 6000,
        flinch = 0.8,
        knockback = 1.5,
        maxspeed = 1.1,
        gravity = 0.755,
        jumpRate = 1.28,
        speedRate = 1.05,
        jumpLevel = 1,
        resistance = 1.3,
        -- 注意从这里开始以下三项请你务必掌握一定的lua基础再修改，否则会出现文不对题的状况
        -- 如果修改错误，可能会出现你的界面显示你有二段跳的技能，但实际上你没有，你可能是有伊卡洛斯的技能
        canIcarus = true,
        skillOneSignal = SignalToUI.icarusSkillGet,
        skillTwoSignal = SignalToUI.cureSkillGet -- 男妈妈咒愈技能
    }, {
        -- 恶魔之子 小表弟
        name = "恶魔",
        func = function()
            UI.Signal(SignalToGame.S_Zombie_Model_Deimos)
        end,
        maxhealth = 25000,
        maxarmor = 6000,
        flinch = 0.8,
        knockback = 0.8,
        maxspeed = 1.15,
        gravity = 0.695,
        jumpRate = 1.29,
        speedRate = 1.06,
        jumpLevel = 1,
        resistance = 1.2,
        -- 注意从这里开始以下三项请你务必掌握一定的lua基础再修改，否则会出现文不对题的状况
        -- 如果修改错误，可能会出现你的界面显示你有二段跳的技能，但实际上你没有，你可能是有伊卡洛斯的技能
        canIcarus = true,
        skillOneSignal = SignalToUI.icarusSkillGet,
        skillTwoSignal = SignalToUI.shockSkillGet -- 小表弟震荡技能
    }, {
        -- 恶魔猎手 大表哥
        name = "猎手",
        func = function()
            UI.Signal(SignalToGame.S_Zombie_Model_Ganymade)
        end,
        maxhealth = 45000,
        maxarmor = 8000,
        flinch = 0.8,
        knockback = 1.5,
        maxspeed = 1.15,
        gravity = 0.69,
        jumpRate = 1.32,
        speedRate = 1.04,
        jumpLevel = 1,
        resistance = 0.9,
        -- 注意从这里开始一下三项请你务必掌握一定的lua基础再修改，否则会出现文不对题的状况
        -- 如果修改错误，可能会出现你的界面显示你有二段跳的技能，但实际上你没有，你可能是有伊卡洛斯的技能
        canIcarus = true,
        skillOneSignal = SignalToUI.icarusSkillGet,
        skillTwoSignal = SignalToUI.firmlySkillGet -- 大表哥坚定向前技能
    }, {
        -- 送葬者 棺材
        name = "送葬",
        func = function()
            UI.Signal(SignalToGame.S_Zombie_Model_Stamper)
        end,
        maxhealth = 55000,
        maxarmor = 8000,
        flinch = 0.8,
        knockback = 1.5,
        maxspeed = 1,
        gravity = 0.8,
        jumpRate = 1.27,
        speedRate = 1.02,
        jumpLevel = 1,
        resistance = 0.6,
        -- 注意从这里开始一下三项请你务必掌握一定的lua基础再修改，否则会出现文不对题的状况
        -- 如果修改错误，可能会出现你的界面显示你有二段跳的技能，但实际上你没有，你可能是有伊卡洛斯的技能
        canIcarus = true,
        skillOneSignal = SignalToUI.icarusSkillGet,
        skillTwoSignal = SignalToUI.impactSkillGet -- 棺材冲击技能
    }, {
        -- 嗜血女妖 奶奶
        name = "女妖",
        func = function()
            UI.Signal(SignalToGame.S_Zombie_Model_Banshee)
        end,
        maxhealth = 25000,
        maxarmor = 8000,
        flinch = 0.8,
        knockback = 1.2,
        maxspeed = 1.1,
        gravity = 0.71,
        jumpRate = 1.36,
        speedRate = 1.06,
        jumpLevel = 2,
        resistance = 1.5,
        -- 注意从这里开始一下三项请你务必掌握一定的lua基础再修改，否则会出现文不对题的状况
        -- 如果修改错误，可能会出现你的界面显示你有二段跳的技能，但实际上你没有，你可能是有伊卡洛斯的技能
        canIcarus = false,
        skillOneSignal = SignalToUI.doubleJumpSkillGet,
        skillTwoSignal = SignalToUI.trapSkillGet -- 奶奶诱捕技能
    }, {
        -- 腐化禁卫 肿瘤崽
        name = "禁卫",
        func = function()
            UI.Signal(SignalToGame.S_Zombie_Model_Venomguard)
        end,
        maxhealth = 35000,
        maxarmor = 8000,
        flinch = 0.7,
        knockback = 0.7,
        maxspeed = 1.12,
        gravity = 0.71,
        jumpRate = 1.36,
        speedRate = 1.05,
        jumpLevel = 1,
        resistance = 1.5,
        -- 注意从这里开始一下三项请你务必掌握一定的lua基础再修改，否则会出现文不对题的状况
        -- 如果修改错误，可能会出现你的界面显示你有二段跳的技能，但实际上你没有，你可能是有伊卡洛斯的技能
        canIcarus = true,
        skillOneSignal = SignalToUI.icarusSkillGet,
        skillTwoSignal = SignalToUI.destructionSkillGet -- 肿瘤崽自爆技能
    }, {
        -- 痛苦女王 长手
        name = "女王",
        func = function()
            UI.Signal(SignalToGame.S_Zombie_Model_Stingfinger)
        end,
        maxhealth = 25000,
        maxarmor = 4000,
        flinch = 0.8,
        knockback = 1.5,
        maxspeed = 1.2,
        gravity = 0.685,
        jumpRate = 1.4,
        speedRate = 1.07,
        jumpLevel = 2,
        resistance = 1.8,
        -- 注意从这里开始一下三项请你务必掌握一定的lua基础再修改，否则会出现文不对题的状况
        -- 如果修改错误，可能会出现你的界面显示你有二段跳的技能，但实际上你没有，你可能是有伊卡洛斯的技能
        canIcarus = false,
        skillOneSignal = SignalToUI.doubleJumpSkillGet,
        skillTwoSignal = SignalToUI.leapSkillGet -- 女王飞跃技能
    }, {
        -- 暴虐钢骨 男英雄僵尸
        name = "钢骨",
        func = function()
            UI.Signal(SignalToGame.S_Zombie_Model_Metatron)
        end,
        maxhealth = 80000,
        maxarmor = 8000,
        flinch = 0.8,
        knockback = 0.8,
        maxspeed = 1,
        gravity = 0.8,
        jumpRate = 1.3,
        speedRate = 1.06,
        jumpLevel = 1,
        resistance = 0.5,
        -- 注意从这里开始一下三项请你务必掌握一定的lua基础再修改，否则会出现文不对题的状况
        -- 如果修改错误，可能会出现你的界面显示你有二段跳的技能，但实际上你没有，你可能是有伊卡洛斯的技能
        canIcarus = true,
        skillOneSignal = SignalToUI.icarusSkillGet,
        skillTwoSignal = SignalToUI.undyingSkillGet -- 男英雄僵尸不朽技能
    }, {
        -- 幻痛夜魔 女英雄僵尸
        name = "夜魔",
        func = function()
            UI.Signal(SignalToGame.S_Zombie_Model_Lilith)
        end,
        maxhealth = 40000,
        maxarmor = 4000,
        flinch = 0.5,
        knockback = 1.2,
        maxspeed = 1.1,
        gravity = 0.72,
        jumpRate = 1.35,
        speedRate = 1.08,
        jumpLevel = 2,
        resistance = 2,
        -- 注意从这里开始一下三项请你务必掌握一定的lua基础再修改，否则会出现文不对题的状况
        -- 如果修改错误，可能会出现你的界面显示你有二段跳的技能，但实际上你没有，你可能是有伊卡洛斯的技能
        canIcarus = false,
        skillOneSignal = SignalToUI.doubleJumpSkillGet,
        skillTwoSignal = SignalToUI.hiddenSkillGet -- 女英雄僵尸缠身技能
    }, {
        -- 追猎傀儡 凳子骑
        name = "傀儡",
        func = function()
            UI.Signal(SignalToGame.S_Zombie_Model_Chaser)
        end,
        maxhealth = 25000,
        maxarmor = 2000,
        flinch = 0.5,
        knockback = 1.5,
        maxspeed = 1.2,
        gravity = 0.68,
        jumpRate = 1.42,
        speedRate = 1.09,
        jumpLevel = 2,
        resistance = 0.8,
        -- 注意从这里开始一下三项请你务必掌握一定的lua基础再修改，否则会出现文不对题的状况
        -- 如果修改错误，可能会出现你的界面显示你有二段跳的技能，但实际上你没有，你可能是有伊卡洛斯的技能
        canIcarus = false,
        skillOneSignal = SignalToUI.doubleJumpSkillGet,
        skillTwoSignal = SignalToUI.leapSkillGet -- 凳子骑飞跃技能
    }, {
        -- 爆弹狂魔 蔡徐坤
        name = "狂魔",
        func = function()
            UI.Signal(SignalToGame.S_Zombie_Model_Blotter)
        end,
        maxhealth = 45000,
        maxarmor = 5000,
        flinch = 0.7,
        knockback = 1.5,
        maxspeed = 1.1,
        gravity = 0.725,
        jumpRate = 1.35,
        speedRate = 1.07,
        jumpLevel = 1,
        resistance = 1.4,
        -- 注意从这里开始一下三项请你务必掌握一定的lua基础再修改，否则会出现文不对题的状况
        -- 如果修改错误，可能会出现你的界面显示你有二段跳的技能，但实际上你没有，你可能是有伊卡洛斯的技能
        canIcarus = true,
        skillOneSignal = SignalToUI.icarusSkillGet,
        skillTwoSignal = SignalToUI.feedbackSkillGet -- 蔡徐坤反馈技能
    }, {
        -- 断翼恶灵 蔡依林
        name = "恶灵",
        func = function()
            UI.Signal(SignalToGame.S_Zombie_Model_Rustywing)
        end,
        maxhealth = 30000,
        maxarmor = 5000,
        flinch = 0.5,
        knockback = 1.6,
        maxspeed = 1.15,
        gravity = 0.68,
        jumpRate = 1.43,
        speedRate = 1.09,
        jumpLevel = 2,
        resistance = 1.5,
        -- 注意从这里开始一下三项请你务必掌握一定的lua基础再修改，否则会出现文不对题的状况
        -- 如果修改错误，可能会出现你的界面显示你有二段跳的技能，但实际上你没有，你可能是有伊卡洛斯的技能
        canIcarus = false,
        skillOneSignal = SignalToUI.doubleJumpSkillGet,
        skillTwoSignal = SignalToUI.leapSkillGet -- 蔡依林飞跃技能
    }, {
        -- 赤炎恶鬼 赤酱
        name = "恶鬼",
        func = function()
            UI.Signal(SignalToGame.S_Zombie_Model_Aksha)
        end,
        maxhealth = 50000,
        maxarmor = 10000,
        flinch = 0.8,
        knockback = 0.5,
        maxspeed = 1.05,
        gravity = 0.825,
        jumpRate = 1.25,
        speedRate = 1.03,
        jumpLevel = 1,
        resistance = 0.7,
        -- 注意从这里开始一下三项请你务必掌握一定的lua基础再修改，否则会出现文不对题的状况
        -- 如果修改错误，可能会出现你的界面显示你有二段跳的技能，但实际上你没有，你可能是有伊卡洛斯的技能
        canIcarus = true,
        skillOneSignal = SignalToUI.icarusSkillGet,
        skillTwoSignal = SignalToUI.feedbackSkillGet -- 赤酱反馈技能
    }
}

