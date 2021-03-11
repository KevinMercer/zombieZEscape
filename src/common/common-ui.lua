--[[
	common.lua
	game과 ui 양쪽 모두에서 실행되어야 하는것들을 모아놓는 파일
]]

--------------------------------------------------------------------------------------------------
--[[ 게임 옵션 수정 ]]
--------------------------------------------------------------------------------------------------

Common.UseWeaponInven(true) -- 무기 인벤토리 기능 사용
Common.SetSaveCurrentWeapons(true) -- 현재 장착중인 무기들을 저장하도록 설정
Common.SetSaveWeaponInven(true) -- 무기 인벤토리 내용을 저장하도록 설정(UseWeaponInven이 먼저 설정되어 있어야한다)
Common.SetAutoLoad(true) -- 저장정보 불러오기를 자동으로 수행한다
Common.DisableWeaponParts(true) -- 웨폰파츠 기능 비활성
Common.DisableWeaponEnhance(false) -- 무기강화 기능 비활성
Common.DontGiveDefaultItems(true) -- 게임시작시 기본무기를 지급하지 않게
Common.DontCheckTeamKill(true) -- 팀킬을해도 정상킬로 처리하게끔
Common.UseScenarioBuymenu(true) -- 상점을 시나리오 상점창을 사용하게
Common.SetNeedMoney(true) -- 총을 구매할때 돈이 필요하도록
Common.UseAdvancedMuzzle(true) -- 발사시 muzzle을 새로운 형태로 그린다(scale 무시)
Common.SetMuzzleScale(1) -- 발사시 muzzle 크기 수정
Common.SetBloodScale(-1) -- 피격시 피 이펙트 크기 수정
Common.SetGunsparkScale(5) -- 총알이 벽 등에 맞았을 경우 이펙트 크기 수정
Common.SetHitboxScale(1) -- 히트박스 크기 수정
Common.SetMouseoverOutline(false, { r = 255, g = 0, b = 0 }) -- 몬스터 등의 엔티티에 마우스오버를 할 경우 외곽선이 보이게
Common.SetUnitedPrimaryAmmoPrice(0) -- 모든 주무기의 탄창 한개당 가격을 이 값으로 통일한다
Common.SetUnitedSecondaryAmmoPrice(0) -- 모든 보조무기의 탄창 한개당 가격을 이 값으로 통일한다

--------------------------------------------------------------------------------------------------
--[[ 공통 상수 선언 ]]
--------------------------------------------------------------------------------------------------

-- 실수값 비교시 사용
EPSILON = 0.00001

-- 从game中发送的，将会被ui接受的信号
SignalToGame = {
    modelRestore = 0, --模型复原
    update = 1, --每帧更新
    toggleView = 2, --视角切换
    jump = 3, --跳跃
    move = 4, --移动
    icarus = 5, --伊卡洛斯
    switchWeapon = 6, --切换武器
    getSkill = 7, --获取技能
    openWeaponInven = 8, --打开背包
    gKeyUsed = 9, --G键技能
    sneakReload = 10, --透明换弹显示
    healthRecover = 11, --恢复生命 对应ui的最后一次攻击
    infect = 12, --被感染
    rounderReset = 13, --回合重置
    land = 14, --落地
    sprint = 15, --极速飞奔
    critical = 16, --致命打击
    --技能获得
    hpPlusSkillGet = 17, --恢复强化
    rehydrationSkillGet = 18, --生命补液
    ironChestSkillGet = 19, --钢铁铠甲
    deflectArmorSkillGet = 20, --倾斜装甲
    ironHelmetSkillGet = 21, --钢铁头盔
    sufferMemorySkillGet = 22, -- 痛苦记忆
    ironClawSkillGet = 23, --合金利爪
    touchInfectSkillGet = 24, --接触感染
    evolutionSkillGet = 25, --进化论
    adaptabilitySkillGet = 26, --适应力
    mammothSkillGet = 27, --猛犸
    repairSkillGet = 28, --组织再生
    sneakReloadSkillGet = 29, --透明换弹
    quickReloadSkillGet = 30, --高速填装
    backClipSkillGet = 31, --备弹补充
    recycleSkillGet = 32, --弹夹回收
    kangarooSkillGet = 33, --袋鼠
    cheetahSkillGet = 34, --猎豹
    assaultSkillGet = 35, --正面突击
    forwardSkillGet = 36, --冲锋推进
    sprintSkillGet = 37, --极速飞奔
    criticalSkillGet = 38, --致命打击
    heroSkillGet = 39, --英雄出现
    edgeSkillGet = 40, --利刃
    shooterSkillGet = 41, --神枪手
    --技能获得结束
    quickReload = 42, --高速填装
    sneakQuickReloadSuspend = 43, --透明换弹或高速填装特效中止
    shooterCrosshairShow = 44, --神枪手准心显示
    shooterCrosshairHide = 45, --神枪手准心隐藏
    icarusSkillGet = 46, --男性僵尸伊卡洛斯
    doubleJumpSkillGet = 47, --女性僵尸二段跳
    chosenHero = 48, --选为英雄
    --僵尸代号 50开始
    S_Zombie_Model_Normal = 50, --普通僵尸(30)
    S_Zombie_Model_Light = 51, --暗影芭比
    S_Zombie_Model_Heavy = 52, --憎恶屠夫
    S_Zombie_Model_Phycho = 53, --迷雾鬼影
    S_Zombie_Model_Voodoo = 54, --巫蛊术尸
    S_Zombie_Model_Deimos = 55, --恶魔之子
    S_Zombie_Model_Ganymade = 56, --恶魔猎手
    S_Zombie_Model_Stamper = 57, --送葬者
    S_Zombie_Model_Banshee = 58, --嗜血女妖
    S_Zombie_Model_Venomguard = 59, --腐败暴君
    S_Zombie_Model_Stingfinger = 60, --痛苦女王
    S_Zombie_Model_Metatron = 61, --暴虐钢骨
    S_Zombie_Model_Lilith = 62, --幻痛夜魔
    S_Zombie_Model_Chaser = 63, --追猎傀儡
    S_Zombie_Model_Blotter = 64, --爆弹狂魔
    S_Zombie_Model_Rustywing = 65, --断翼恶灵
    S_Zombie_Model_Aksha = 66, --赤炎恶鬼(46)
    --僵尸代号结束
    --僵尸技能
    induration = 67, --硬化
    lurk = 68, --潜伏
    ghostHand = 69, --鬼手
    cure = 70, --治愈
    shock = 71, --震荡
    firmly = 72, --坚定向前
    impact = 73, --冲击
    trap = 74, --诱捕
    feedback = 75, --反馈
    leap = 76, --飞跃
    undying = 77, --免死
    hidden = 78, --缠身
    --僵尸技能结束
    --僵尸技能获得
    indurationSkillGet = 79, --硬化
    lurkSkillGet = 80, --潜伏
    ghostHandSkillGet = 81, --鬼手
    cureSkillGet = 82, --治愈
    shockSkillGet = 83, --震荡
    firmlySkillGet = 84, --坚定向前
    impactSkillGet = 85, --冲击
    trapSkillGet = 86, --诱捕
    feedbackSkillGet = 87, --反馈
    leapSkillGet = 88, --飞跃
    undyingSkillGet = 89, --免死
    hiddenSkillGet = 90, --缠身
    destructionSkillGet = 91, --自爆
    --僵尸技能获得结束
    undyingLoseControl = 92, --免死技能时失去控制权
    undyingGetControl = 93, --免死技能时获得控制权
    escapeSuccess = 94, --逃脱成功
    escapeFail = 95, --逃脱失败
}

-- 从ui中发送的，将会被game接受的信号
SignalToUI = {
    modelRestore = 0, --模型复原
    update = 1, --每帧更新
    toggleView = 2, --视角切换
    jump = 3, --跳跃
    move = 4, --移动
    icarus = 5, --伊卡洛斯
    switchWeapon = 6, --切换武器
    getSkill = 7, --获取技能
    openWeaponInven = 8, --打开背包
    gKeyUsed = 9, --G键技能
    sneakReload = 10, --透明换弹
    lastAttack = 11, --最后一次被攻击 对应game的恢复生命
    infect = 12, --被感染
    rounderReset = 13, --回合重置
    land = 14, --落地
    sprint = 15, --极速飞奔
    critical = 16, --致命打击
    --技能获得
    hpPlusSkillGet = 17, --恢复强化
    rehydrationSkillGet = 18, --生命补液
    ironChestSkillGet = 19, --钢铁铠甲
    deflectArmorSkillGet = 20, --倾斜装甲
    ironHelmetSkillGet = 21, --钢铁头盔
    sufferMemorySkillGet = 22, -- 痛苦记忆
    ironClawSkillGet = 23, --合金利爪
    touchInfectSkillGet = 24, --接触感染
    evolutionSkillGet = 25, --进化论
    adaptabilitySkillGet = 26, --适应力
    mammothSkillGet = 27, --猛犸
    repairSkillGet = 28, --组织再生
    sneakReloadSkillGet = 29, --透明换弹
    quickReloadSkillGet = 30, --高速填装
    backClipSkillGet = 31, --备弹补充
    recycleSkillGet = 32, --弹夹回收
    kangarooSkillGet = 33, --袋鼠
    cheetahSkillGet = 34, --猎豹
    assaultSkillGet = 35, --正面突击
    forwardSkillGet = 36, --冲锋推进
    sprintSkillGet = 37, --极速飞奔
    criticalSkillGet = 38, --致命打击
    heroSkillGet = 39, --英雄出现
    edgeSkillGet = 40, --利刃
    shooterSkillGet = 41, --神枪手
    --技能获得结束
    quickReload = 42, --高速填装
    sneakQuickReloadSuspend = 43, --透明换弹或高速填装特效中止
    shooterCrosshairShow = 44, --神枪手准心显示
    shooterCrosshairHide = 45, --神枪手准心隐藏
    icarusSkillGet = 46, --男性僵尸伊卡洛斯
    doubleJumpSkillGet = 47, --女性僵尸二段跳
    chosenHero = 48, --选为英雄
    --僵尸代号 50开始
    S_Zombie_Model_Normal = 50, --普通僵尸(30)
    S_Zombie_Model_Light = 51, --暗影芭比
    S_Zombie_Model_Heavy = 52, --憎恶屠夫
    S_Zombie_Model_Phycho = 53, --迷雾鬼影
    S_Zombie_Model_Voodoo = 54, --巫蛊术尸
    S_Zombie_Model_Deimos = 55, --恶魔之子
    S_Zombie_Model_Ganymade = 56, --恶魔猎手
    S_Zombie_Model_Stamper = 57, --送葬者
    S_Zombie_Model_Banshee = 58, --嗜血女妖
    S_Zombie_Model_Venomguard = 59, --腐败暴君
    S_Zombie_Model_Stingfinger = 60, --痛苦女王
    S_Zombie_Model_Metatron = 61, --暴虐钢骨
    S_Zombie_Model_Lilith = 62, --幻痛夜魔
    S_Zombie_Model_Chaser = 63, --追猎傀儡
    S_Zombie_Model_Blotter = 64, --爆弹狂魔
    S_Zombie_Model_Rustywing = 65, --断翼恶灵
    S_Zombie_Model_Aksha = 66, --赤炎恶鬼(46)
    --僵尸代号结束
    --僵尸技能
    induration = 67, --硬化
    lurk = 68, --潜伏
    cure = 69, --治愈
    firmly = 70, --坚定向前
    impact = 71, --冲击
    feedback = 72, --反馈
    ghostHand = 73, --鬼手
    undying = 74, --免死
    shock = 75, --震荡
    trap = 76, --诱捕
    hidden = 77, --缠身
    leap = 78, --飞跃
    --僵尸技能结束
    --僵尸技能获得
    indurationSkillGet = 79, --硬化
    lurkSkillGet = 80, --潜伏
    ghostHandSkillGet = 81, --鬼手
    cureSkillGet = 82, --治愈
    shockSkillGet = 83, --震荡
    firmlySkillGet = 84, --坚定向前
    impactSkillGet = 85, --冲击
    trapSkillGet = 86, --诱捕
    feedbackSkillGet = 87, --反馈
    leapSkillGet = 88, --飞跃
    undyingSkillGet = 89, --免死
    hiddenSkillGet = 90, --缠身
    destructionSkillGet = 91, --自爆
    --僵尸技能获得结束
    undyingLoseControl = 92, --免死技能时失去控制权
    undyingGetControl = 93, --免死技能时获得控制权
    escapeSuccess = 94, --逃脱成功
    escapeFail = 95, --逃脱失败
}

-- 게임에서 쓰일 무기 등급
WeaponGrade = {
    normal = 1,
    rare = 2,
    unique = 3,
    legend = 4,
    END = 4
}

-- 상점 무기 리스트
BuymenuWeaponList = {
    Common.WEAPON.P228,
    Common.WEAPON.DualBeretta,
    Common.WEAPON.FiveSeven,
    Common.WEAPON.Glock18C,
    Common.WEAPON.USP45,
    Common.WEAPON.DesertEagle50C,
    Common.WEAPON.DualInfinity,
    Common.WEAPON.Galil,
    Common.WEAPON.FAMAS,
    Common.WEAPON.M4A1,
    Common.WEAPON.AK47,
    Common.WEAPON.OICW,
    Common.WEAPON.MAC10,
    Common.WEAPON.UMP45,
    Common.WEAPON.MP5,
    Common.WEAPON.TMP,
    Common.WEAPON.P90,
    Common.WEAPON.MP7A1ExtendedMag,
    Common.WEAPON.Needler,
    Common.WEAPON.M3,
    Common.WEAPON.XM1014,
    Common.WEAPON.DoubleBarrelShotgun,
    Common.WEAPON.WinchesterM1887,
    Common.WEAPON.USAS12,
    Common.WEAPON.FireVulcan,
    Common.WEAPON.M249,
    Common.WEAPON.MG3,
    Common.WEAPON.M134Minigun,
    Common.WEAPON.K3,
    Common.WEAPON.QBB95,
    Common.WEAPON.M32MGL,
    Common.WEAPON.Leviathan,
    Common.WEAPON.Salamander,
    Common.WEAPON.RPG7
}

-- 상점 무기 리스트 설정 (UseScenarioBuymenu 설정 필요)


-- 게임에서 쓰일 모든 무기 리스트
WeaponList = {
    -- 보조무기 리스트 Pistol
    Common.WEAPON.P228,
    Common.WEAPON.DualBeretta,
    Common.WEAPON.FiveSeven,
    Common.WEAPON.Glock18C,
    Common.WEAPON.USP45,
    Common.WEAPON.DesertEagle50C,
    Common.WEAPON.DualInfinity,
    Common.WEAPON.DualInfinityCustom,
    Common.WEAPON.DualInfinityFinal,
    Common.WEAPON.SawedOffM79,
    Common.WEAPON.Cyclone,
    Common.WEAPON.AttackM950,
    Common.WEAPON.DesertEagle50CGold,
    Common.WEAPON.ThunderGhostWalker,
    Common.WEAPON.PythonDesperado,
    Common.WEAPON.DesertEagleCrimsonHunter,
    Common.WEAPON.DualBerettaGunslinger,
    -- 소총 리스트 Rifle
    Common.WEAPON.Galil,
    Common.WEAPON.FAMAS,
    Common.WEAPON.M4A1,
    Common.WEAPON.SG552,
    Common.WEAPON.AK47,
    Common.WEAPON.AUG,
    Common.WEAPON.AN94,
    Common.WEAPON.M16A4,
    Common.WEAPON.HK416,
    Common.WEAPON.AK74U,
    Common.WEAPON.AKM,
    Common.WEAPON.L85A2,
    Common.WEAPON.FNFNC,
    Common.WEAPON.TAR21,
    Common.WEAPON.SCAR,
    Common.WEAPON.SKULL4,
    Common.WEAPON.OICW,
    Common.WEAPON.PlasmaGun,
    Common.WEAPON.StunRifle,
    Common.WEAPON.StarChaserAR,
    Common.WEAPON.CompoundBow,
    Common.WEAPON.LightningAR2,
    Common.WEAPON.Ethereal,
    Common.WEAPON.LightningAR1,
    Common.WEAPON.F2000,
    Common.WEAPON.Crossbow,
    Common.WEAPON.CrossbowAdvance,
    Common.WEAPON.M4A1DarkKnight,
    Common.WEAPON.AK47Paladin,
    Common.WEAPON.ARX160,
    -- 기관단총 리스트 Submachine
    Common.WEAPON.MAC10,
    Common.WEAPON.UMP45,
    Common.WEAPON.MP5,
    Common.WEAPON.TMP,
    Common.WEAPON.P90,
    Common.WEAPON.MP7A1ExtendedMag,
    Common.WEAPON.DualKriss,
    Common.WEAPON.KrissSuperV,
    Common.WEAPON.Tempest,
    Common.WEAPON.TMPDragon,
    Common.WEAPON.P90Lapin,
    Common.WEAPON.DualUZI,
    Common.WEAPON.Needler,
    Common.WEAPON.InfinityLaserFist,
    -- 샷건 리스트 Shotgun
    Common.WEAPON.M3,
    Common.WEAPON.XM1014,
    Common.WEAPON.DoubleBarrelShotgun,
    Common.WEAPON.WinchesterM1887,
    Common.WEAPON.USAS12,
    Common.WEAPON.JackHammer,
    Common.WEAPON.TripleBarrelShotgun,
    Common.WEAPON.SPAS12Maverick,
    Common.WEAPON.FireVulcan,
    Common.WEAPON.BALROGXI,
    Common.WEAPON.BOUNCER,
    Common.WEAPON.FlameJackhammer,
    Common.WEAPON.RailCannon,
    Common.WEAPON.LightningSG1,
    Common.WEAPON.USAS12CAMO,
    Common.WEAPON.WinchesterM1887Gold,
    Common.WEAPON.UTS15PinkGold,
    Common.WEAPON.Volcano,
    -- 기관총 리스트 Machine
    Common.WEAPON.M249,
    Common.WEAPON.MG3,
    Common.WEAPON.M134Minigun,
    Common.WEAPON.MG36,
    Common.WEAPON.MK48,
    Common.WEAPON.K3,
    Common.WEAPON.QBB95,
    Common.WEAPON.QBB95AdditionalMag,
    Common.WEAPON.BALROGVII,
    Common.WEAPON.MG3CSOGSEdition,
    Common.WEAPON.CHARGER7,
    Common.WEAPON.ShiningHeartRod,
    Common.WEAPON.Coilgun,
    Common.WEAPON.Aeolis,
    Common.WEAPON.BroadDivine,
    Common.WEAPON.LaserMinigun,
    Common.WEAPON.M249Phoenix,
    -- 장비무기 리스트 Equipment
    Common.WEAPON.M32MGL,
    Common.WEAPON.PetrolBoomer,
    Common.WEAPON.Slasher,
    Common.WEAPON.Eruptor,
    Common.WEAPON.Leviathan,
    Common.WEAPON.Salamander,
    Common.WEAPON.RPG7,
    Common.WEAPON.M32MGLVenom,
    Common.WEAPON.Stinger,
    Common.WEAPON.MagnumDrill,
    Common.WEAPON.GaeBolg,
    Common.WEAPON.Ripper,
    Common.WEAPON.BlackDragonCannon,
    Common.WEAPON.Guillotine,
    -- Sniper
    Common.WEAPON.SG550Commando,
    Common.WEAPON.G3SG1,
    Common.WEAPON.Scout,
    Common.WEAPON.APW,
    Common.WEAPON.M24,
    Common.WEAPON.BarrettM95
}

totalGunsList = {
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

testGunList = {}

-- for i = 4000, 4063 do
-- table.insert(totalGunsList, i)
-- end

for i = 1, 9999 do
    table.insert(testGunList, i)
end

-- table.insert(totalGunsList, 4)

-- Common.SetBuymenuWeaponList(totalGunsList)
Common.SetBuymenuWeaponList(testGunList)
--------------------------------------------------------------------------------------------------
--[[ 무기종류별 속성 수정 ]]
--------------------------------------------------------------------------------------------------

-- 보조무기 속성 
-- option = Common.GetWeaponOption(Common.WEAPON.M249)
-- option.price = 1000 -- 무기 구매가격
-- option.damage = 1.0 -- Weapon 클래스와 함께 설정할 경우 둘다 곱연산
-- option.penetration = 1.0 -- 관통력
-- option.rangemod = 1.0 -- 거리에 따른 데미지 감쇠율
-- option.cycletime = 1 -- 연사 속도
-- option.reloadtime = 1.0 -- 장전 속도
-- option.accuracy = 1.0 -- 정확도
-- option.spread = 1.0 -- 동작을 수행할때 정확도가 떨어지는 정도
-- option:SetBulletColor({r = 255, g = 255, b = 50}); -- 총 발사시 지정한 색상의 발사 경로가 나온다
-- option.user.grade = WeaponGrade.normal  -- 무기종류별 최소 등급을 미리 정의
-- option.user.level = 1 -- 무기 구매시 레벨 제한

-- 무기 속성 상세 설정 무기id, 가격, 등급, 사용가능 레벨, R, G, B
function SetOption(weaponid, price, grade, level, red, green, blue)
    option = Common.GetWeaponOption(weaponid)
    option.price = price
    option.penetration = 2.0
    option.spread = 0.1
    -- option.reloadtime = 0.1
    option.accuracy = 1
    if grade == 0 then
        option.spread = 0.1
    end
    option.user.level = level

    if red ~= nil then
        option:SetBulletColor({ r = red, g = green, b = blue });
    end
end

SetOption(Common.WEAPON.DualBeretta, 0, WeaponGrade.normal, 0, 80, 80, 80)
SetOption(Common.WEAPON.FiveSeven, 0, WeaponGrade.normal, 0, 80, 80, 80)
SetOption(Common.WEAPON.Glock18C, 0, WeaponGrade.normal, 0, 80, 80, 80)
SetOption(Common.WEAPON.USP45, 0, WeaponGrade.normal, 0, 80, 80, 80)
SetOption(Common.WEAPON.DesertEagle50C, 0, WeaponGrade.normal, 0, 80, 80, 80)
SetOption(Common.WEAPON.DualInfinity, 0, WeaponGrade.normal, 0, 80, 80, 80)
SetOption(Common.WEAPON.DualInfinityCustom, 0, WeaponGrade.normal, 0, 80, 80, 80)
SetOption(Common.WEAPON.DualInfinityFinal, 0, WeaponGrade.normal, 0, 80, 80, 80)
SetOption(Common.WEAPON.SawedOffM79, 0, WeaponGrade.normal, 0, 80, 80, 80)
SetOption(Common.WEAPON.Cyclone, 0, WeaponGrade.normal, 8, 80, 80, 80)
SetOption(Common.WEAPON.AttackM950, 0, WeaponGrade.normal, 0, 80, 80, 80)
SetOption(Common.WEAPON.DesertEagle50CGold, 0, WeaponGrade.normal, 0, 80, 80, 80)
SetOption(Common.WEAPON.ThunderGhostWalker, 0, WeaponGrade.normal, 0, 80, 80, 80)
SetOption(Common.WEAPON.PythonDesperado, 0, WeaponGrade.normal, 0, 80, 80, 80)
SetOption(Common.WEAPON.DesertEagleCrimsonHunter, 0, WeaponGrade.normal, 0, 80, 80, 80)
SetOption(Common.WEAPON.DualBerettaGunslinger, 0, WeaponGrade.normal, 0, 80, 80, 80)

-- 소총 속성
SetOption(Common.WEAPON.Galil, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.FAMAS, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.M4A1, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.SG552, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.AK47, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.AUG, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.AN94, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.M16A4, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.HK416, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.AK74U, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.AKM, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.L85A2, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.FNFNC, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.TAR21, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.SCAR, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.SKULL4, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.OICW, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.PlasmaGun, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.StunRifle, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.StarChaserAR, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.CompoundBow, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.LightningAR2, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.Ethereal, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.LightningAR1, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.F2000, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.Crossbow, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.CrossbowAdvance, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.M4A1DarkKnight, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.AK47Paladin, 0, WeaponGrade.normal, 0, 255, 0, 0)
SetOption(Common.WEAPON.ARX160, 0, WeaponGrade.normal, 0, 255, 0, 0)

-- 기관단총 속성
SetOption(Common.WEAPON.MAC10, 0, WeaponGrade.normal, 0, 128, 255, 255)
SetOption(Common.WEAPON.UMP45, 0, WeaponGrade.normal, 0, 128, 255, 255)
SetOption(Common.WEAPON.MP5, 0, WeaponGrade.normal, 0, 128, 255, 255)
SetOption(Common.WEAPON.TMP, 0, WeaponGrade.normal, 0, 128, 255, 255)
SetOption(Common.WEAPON.P90, 0, WeaponGrade.normal, 0, 128, 255, 255)
SetOption(Common.WEAPON.MP7A1ExtendedMag, 0, WeaponGrade.normal, 0, 128, 255, 255)
SetOption(Common.WEAPON.DualKriss, 0, WeaponGrade.normal, 0, 128, 255, 255)
SetOption(Common.WEAPON.KrissSuperV, 0, WeaponGrade.normal, 0, 128, 255, 255)
SetOption(Common.WEAPON.Tempest, 0, WeaponGrade.normal, 0, 128, 255, 255)
SetOption(Common.WEAPON.TMPDragon, 0, WeaponGrade.normal, 0, 128, 255, 255)
SetOption(Common.WEAPON.P90Lapin, 0, WeaponGrade.normal, 0, 128, 255, 255)
SetOption(Common.WEAPON.DualUZI, 0, WeaponGrade.normal, 0, 128, 255, 255)
SetOption(Common.WEAPON.Needler, 0, WeaponGrade.normal, 0, 128, 255, 255)
SetOption(Common.WEAPON.InfinityLaserFist, 0, WeaponGrade.normal, 0, 128, 255, 255)

-- 샷건 속성
SetOption(Common.WEAPON.M3, 0, WeaponGrade.normal, 0, 180, 0, 180)
SetOption(Common.WEAPON.XM1014, 0, WeaponGrade.normal, 0, 180, 0, 180)
SetOption(Common.WEAPON.DoubleBarrelShotgun, 0, WeaponGrade.normal, 0, 180, 0, 180)
SetOption(Common.WEAPON.WinchesterM1887, 0, WeaponGrade.normal, 0, 180, 0, 180)
SetOption(Common.WEAPON.USAS12, 0, WeaponGrade.normal, 0, 180, 0, 180)
SetOption(Common.WEAPON.JackHammer, 0, WeaponGrade.normal, 0, 180, 0, 180)
SetOption(Common.WEAPON.TripleBarrelShotgun, 0, WeaponGrade.normal, 0, 180, 0, 180)
SetOption(Common.WEAPON.SPAS12Maverick, 0, WeaponGrade.normal, 0, 180, 0, 180)
SetOption(Common.WEAPON.FireVulcan, 0, WeaponGrade.normal, 0, 180, 0, 180)
SetOption(Common.WEAPON.BALROGXI, 0, WeaponGrade.normal, 0, 180, 0, 180)
SetOption(Common.WEAPON.BOUNCER, 0, WeaponGrade.normal, 0, 180, 0, 180)
SetOption(Common.WEAPON.FlameJackhammer, 0, WeaponGrade.normal, 0, 180, 0, 180)
SetOption(Common.WEAPON.RailCannon, 0, WeaponGrade.normal, 0, 180, 0, 180)
SetOption(Common.WEAPON.LightningSG1, 0, WeaponGrade.normal, 0, 180, 0, 180)
SetOption(Common.WEAPON.USAS12CAMO, 0, WeaponGrade.normal, 0, 180, 0, 180)
SetOption(Common.WEAPON.WinchesterM1887Gold, 0, WeaponGrade.normal, 0, 180, 0, 180)
SetOption(Common.WEAPON.UTS15PinkGold, 0, WeaponGrade.normal, 0, 180, 0, 180)
SetOption(Common.WEAPON.Volcano, 0, WeaponGrade.normal, 0, 180, 0, 180)


-- 기관총 속성
SetOption(Common.WEAPON.M249, 0, WeaponGrade.normal, 0, 255, 255, 0)
SetOption(Common.WEAPON.MG3, 0, WeaponGrade.normal, 0, 255, 255, 0)
SetOption(Common.WEAPON.M134Minigun, 0, WeaponGrade.normal, 0, 255, 255, 0)
SetOption(Common.WEAPON.MG36, 0, WeaponGrade.normal, 0, 255, 255, 0)
SetOption(Common.WEAPON.MK48, 0, WeaponGrade.normal, 0, 255, 255, 0)
SetOption(Common.WEAPON.K3, 0, WeaponGrade.normal, 0, 255, 255, 0)
SetOption(Common.WEAPON.QBB95, 0, WeaponGrade.normal, 0, 255, 255, 0)
SetOption(Common.WEAPON.QBB95AdditionalMag, 0, WeaponGrade.normal, 0, 255, 255, 0)
SetOption(Common.WEAPON.BALROGVII, 0, WeaponGrade.normal, 0, 255, 255, 0)
SetOption(Common.WEAPON.MG3CSOGSEdition, 0, WeaponGrade.normal, 0, 255, 255, 0)
SetOption(Common.WEAPON.CHARGER7, 0, WeaponGrade.normal, 0, 255, 255, 0)
SetOption(Common.WEAPON.ShiningHeartRod, 0, WeaponGrade.normal, 0, 255, 255, 0)
SetOption(Common.WEAPON.Coilgun, 0, WeaponGrade.normal, 0, 255, 255, 0)
SetOption(Common.WEAPON.Aeolis, 0, WeaponGrade.normal, 0, 255, 255, 0)
SetOption(Common.WEAPON.BroadDivine, 0, WeaponGrade.normal, 0, 255, 255, 0)
SetOption(Common.WEAPON.LaserMinigun, 0, WeaponGrade.normal, 0, 255, 255, 0)
SetOption(Common.WEAPON.M249Phoenix, 0, WeaponGrade.normal, 0, 255, 255, 0)


-- 장비무기 속성
SetOption(Common.WEAPON.M32MGL, 0, WeaponGrade.normal, 0, 50, 50, 255)
SetOption(Common.WEAPON.PetrolBoomer, 0, WeaponGrade.normal, 0, 50, 50, 255)
SetOption(Common.WEAPON.Slasher, 0, WeaponGrade.normal, 0, 50, 50, 255)
SetOption(Common.WEAPON.Eruptor, 0, WeaponGrade.normal, 0, 50, 50, 255)
SetOption(Common.WEAPON.Leviathan, 0, WeaponGrade.normal, 0, 50, 50, 255)
SetOption(Common.WEAPON.Salamander, 0, WeaponGrade.normal, 0, 50, 50, 255)
SetOption(Common.WEAPON.RPG7, 0, WeaponGrade.normal, 0, 50, 50, 255)
SetOption(Common.WEAPON.M32MGLVenom, 0, WeaponGrade.normal, 0, 50, 50, 255)
SetOption(Common.WEAPON.Stinger, 0, WeaponGrade.normal, 0, 50, 50, 255)
SetOption(Common.WEAPON.MagnumDrill, 0, WeaponGrade.normal, 0, 50, 50, 255)
SetOption(Common.WEAPON.GaeBolg, 0, WeaponGrade.normal, 0, 50, 50, 255)
SetOption(Common.WEAPON.Ripper, 0, WeaponGrade.normal, 0, 50, 50, 255)
SetOption(Common.WEAPON.BlackDragonCannon, 0, WeaponGrade.normal, 0, 50, 50, 255)
SetOption(Common.WEAPON.Guillotine, 0, WeaponGrade.normal, 0, 50, 50, 255)

-- Sniper
SetOption(Common.WEAPON.SG550Commando, 0, 0, 0, 255, 0, 0)
SetOption(Common.WEAPON.G3SG1, 0, 0, 0, 255, 0, 0)
SetOption(Common.WEAPON.Scout, 0, 0, 0, 255, 0, 0)
SetOption(Common.WEAPON.AWP, 0, 0, 0, 255, 0, 0)
SetOption(Common.WEAPON.M24, 0, 0, 0, 255, 0, 0)
SetOption(Common.WEAPON.BarrettM95, 0, 0, 0, 255, 0, 0)




-- if UI then
-- print("CSO");
-- local kb = keyboard();
-- end

