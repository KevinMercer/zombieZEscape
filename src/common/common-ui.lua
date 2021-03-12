--全局设置
Common.UseWeaponInven(true) -- 使用武器背包
Common.SetSaveCurrentWeapons(true) -- 保存当前装备的所有武器
Common.SetSaveWeaponInven(true) -- 保存武器背包中的武器
Common.SetAutoLoad(true) -- 自动读取储存的信息
Common.DisableWeaponParts(true) -- 禁用武器配件(没什么屌用，武器配件本身就只在生化英雄、生化进化、生化超越还有大灾变中生效)
Common.DisableWeaponEnhance(false) -- 禁用武器强化(例如：毁灭者+8、尤利乌斯+6)
Common.DontGiveDefaultItems(true) -- 不给予默认武器(默认武器是usp45不是海豹短刀)
Common.DontCheckTeamKill(true) -- 不检查团队击杀(助攻)
Common.UseScenarioBuymenu(true) -- 使用大灾变的购买模式
Common.SetNeedMoney(true) -- 购买武器需要金币(可以使用从金币装置中打出来的金币)
Common.UseAdvancedMuzzle(true) -- 使用高级的枪口开火型态
Common.SetMuzzleScale(1) -- 修正枪口效果大小(倍率)
Common.SetBloodScale(-1) -- 修正飞溅血肉的大小(倍率)
Common.SetGunsparkScale(5) -- 修正子弹被墙体阻挡是爆炸的火花大小(倍率)
Common.SetHitboxScale(1) -- 修正准心大小(倍率)
Common.SetMouseoverOutline(false, { r = 255, g = 0, b = 0 }) -- 在没有隐藏鼠标时，允许鼠标高亮选中的游戏实体对象(例如：怪物)
Common.SetUnitedPrimaryAmmoPrice(0) -- 每单位主武器子弹价格(例如：填写200，假设一单位为30发子弹，则每购买30发任意口径的子弹都需要200)
Common.SetUnitedSecondaryAmmoPrice(0) -- 每单位副武器子弹价格(例如：填写100，假设一单位为12发子弹，则每购买12发任意口径的子弹都需要100)


-- 这里是把所有武器都加入到购买列表，有一部分枪可以买出来，但是不在官方文档里的武器属性是不能修改的，只有官方文档里标注了的枪属性才能修改，这些武器已经被我统一写进了data.lua文件里的validateGunsList中意思是生效的武器列表
allGunList = {}
for i = 1, 9999 do
    table.insert(allGunList, i)
end
--设置购买武器列表
Common.SetBuymenuWeaponList(allGunList)

-- 全局武器属性设置函数
function SetOption(weaponid, price, level, grade, red, green, blue)
    option = Common.GetWeaponOption(weaponid) -- 获取武器的选项
    -- 对武器选项option里面的属性进行修改
    -- (注意这里修改的是这一类的所有武器，例如修改了usp45的属性，那么所有人手上的usp45都有这个属性)
    option.price = price -- 修改价格
    option.damage = 1 -- 修正伤害(倍率，如果你后来又在Game.Weapon中修改了damage，那么这两个数值会进行乘法运算，数值越大，伤害越高)
    option.penetration = 1 -- 修正穿透能力(倍率，数值越大，穿透越强)
    option.rangemod = 1 -- 修正武器的距离修正(倍率，听起来好像有些拗口哈哈，我修正你的修正，距离修正表示子弹随着飞行距离伤害降低的程度，数值越大，就表示距离越远伤害越低，数值越小，就表示近距离和远距离伤害差距不大)
    option.cycletime = 1 -- 修正武器的连射性(倍率，数值越大，连射越慢)
    option.reloadtime = 1 -- 修正武器的填弹速度(倍率，数值越大，填弹速度越慢)
    option.accuracy = 1 -- 修正武器的准确度(倍率，数值越大，准确度越高，据多位缔造大佬测试，效果非常不明显)
    option.spread = 1 -- 修正当你有多余动作时，武器的失准度(倍率，例如拿着冲锋枪跳跃，拿着轻机枪边走边打，同时也生效于拿着狙击枪不开镜，数值越大，精准度越低)

    -- option下面有一张user表，这张表里你可以随心所欲设定数值，但是具体这个数值怎么生效还是要看你的代码怎么用这个数值
    option.user.grade = grade -- 这里我根据官方案例声明了这个武器有一个等级限制，实际上这个等级限制根本没效果，但是我在game的代码里用到了这个声明，于是这个声明就生效了
    option.user.level = level -- 同理，我声明这个武器本身有一个品质，品质表具体在data.lua的weaponLevel中可以看到

    if red ~= nil then
        --如果你传入了r g b的值，那么这里会设置武器使用开火射线以及射线的颜色(快去百度你最喜欢的颜色是怎样用rgb表示的吧)
        option:SetBulletColor({
            r = red, -- r值
            g = green, -- g值
            b = blue -- b值
        });
    end
end

-- 函数使用方式：
-- SetOption(武器的id, 武器购买的价格, 武器的品质, 武器解锁等级, 武器射线颜色rgb中的r值, 武器射线颜色rgb中的g值, 武器射线颜色rgb中的b值)
-- 注意：武器品质和武器解锁等级本身无效，需要后续写代码使用这两个属性才能生效，函数的每个参数隔开的逗号要用英文输入法，否则脚本编译会报错

-- 手枪 pistol
SetOption(Common.WEAPON.DualBeretta, 0, weaponLevel.normal, 0, 80, 80, 80) -- 双枪(假深渊精英)
SetOption(Common.WEAPON.FiveSeven, 0, weaponLevel.normal, 0, 80, 80, 80) -- 57式手枪
SetOption(Common.WEAPON.Glock18C, 0, weaponLevel.normal, 0, 80, 80, 80) -- 格洛克18式手枪(传统竞技模式T阵营默认)
SetOption(Common.WEAPON.USP45, 0, weaponLevel.normal, 0, 80, 80, 80) -- usp45手枪(传统竞技模式CT阵营默认)
SetOption(Common.WEAPON.DesertEagle50C, 0, weaponLevel.normal, 0, 80, 80, 80) -- 沙漠之鹰(在众多游戏里都是柯尔特蟒蛇型手枪的死敌)
SetOption(Common.WEAPON.DualInfinity, 0, weaponLevel.normal, 0, 80, 80, 80) -- 恒宇双星
SetOption(Common.WEAPON.DualInfinityCustom, 0, weaponLevel.normal, 0, 80, 80, 80) -- 星红双子
SetOption(Common.WEAPON.DualInfinityFinal, 0, weaponLevel.normal, 0, 80, 80, 80) -- 金红双蝎
SetOption(Common.WEAPON.SawedOffM79, 0, weaponLevel.normal, 0, 80, 80, 80) -- 爆焰旋风M79(榴弹手枪)
SetOption(Common.WEAPON.Cyclone, 0, weaponLevel.normal, 8, 80, 80, 80) -- 死亡射线
SetOption(Common.WEAPON.AttackM950, 0, weaponLevel.normal, 0, 80, 80, 80) -- 黯夜流光
SetOption(Common.WEAPON.DesertEagle50CGold, 0, weaponLevel.normal, 0, 80, 80, 80) -- 荒漠金鹰
SetOption(Common.WEAPON.ThunderGhostWalker, 0, weaponLevel.normal, 0, 80, 80, 80) -- 幽影(雷鬼行者？)
SetOption(Common.WEAPON.PythonDesperado, 0, weaponLevel.normal, 0, 80, 80, 80) -- 永恒蟒蛇(双持柯尔特蟒蛇型手枪，不愧是你仙侠风格第一人称设射击游戏CSO)
SetOption(Common.WEAPON.DesertEagleCrimsonHunter, 0, weaponLevel.normal, 0, 80, 80, 80) -- 血契沙鹰
SetOption(Common.WEAPON.DualBerettaGunslinger, 0, weaponLevel.normal, 0, 80, 80, 80) -- 深渊精英

-- 突击步枪 rifle
SetOption(Common.WEAPON.FAMAS, 0, weaponLevel.normal, 0, 255, 0, 0) -- 法玛斯突击步枪(对标T阵营的galil自动步枪)
SetOption(Common.WEAPON.Galil, 0, weaponLevel.normal, 0, 255, 0, 0) -- 加利尔突击步枪(外号咖喱，对标CT阵营的famas自动步枪)
SetOption(Common.WEAPON.M4A1, 0, weaponLevel.normal, 0, 255, 0, 0) -- m4a1卡宾枪(对标T阵营的ak47自动步枪)
SetOption(Common.WEAPON.AK47, 0, weaponLevel.normal, 0, 255, 0, 0) -- ak47(对标CT阵营的m4a1卡宾枪)
SetOption(Common.WEAPON.AUG, 0, weaponLevel.normal, 0, 255, 0, 0) -- aug(对标T阵营的sg552)
SetOption(Common.WEAPON.SG552, 0, weaponLevel.normal, 0, 255, 0, 0) -- 帅哥552(有多帅就不解释了，对标CT阵营的aug自动步枪)
SetOption(Common.WEAPON.M16A4, 0, weaponLevel.normal, 0, 255, 0, 0) -- m16a4(三连发，对标T阵营的an94)
SetOption(Common.WEAPON.AN94, 0, weaponLevel.normal, 0, 255, 0, 0) -- an94(双连发，对标CT阵营的M16A4)
SetOption(Common.WEAPON.HK416, 0, weaponLevel.normal, 0, 255, 0, 0) -- hk416(换皮m4a1，对标T阵营的akm)
SetOption(Common.WEAPON.AKM, 0, weaponLevel.normal, 0, 255, 0, 0) -- akm(号称ak47改进型，对标CT阵营的hk416)
SetOption(Common.WEAPON.L85A2, 0, weaponLevel.normal, 0, 255, 0, 0) -- l85a2(垃圾武器，对标T阵营的ak74u)
SetOption(Common.WEAPON.AK74U, 0, weaponLevel.normal, 0, 255, 0, 0) -- ak74u(对标CT阵营的l85a2)
SetOption(Common.WEAPON.FNFNC, 0, weaponLevel.normal, 0, 255, 0, 0) -- fnfnc
SetOption(Common.WEAPON.TAR21, 0, weaponLevel.normal, 0, 255, 0, 0) -- 塔沃尔
SetOption(Common.WEAPON.SCAR, 0, weaponLevel.normal, 0, 255, 0, 0) -- scar(不是fa)
SetOption(Common.WEAPON.SKULL4, 0, weaponLevel.normal, 0, 255, 0, 0) -- 死亡骑士(远古版本"骑士"系列连狙之一)
SetOption(Common.WEAPON.OICW, 0, weaponLevel.normal, 0, 255, 0, 0) -- 尖端勇士(尖端跳)
SetOption(Common.WEAPON.PlasmaGun, 0, weaponLevel.normal, 0, 255, 0, 0) -- 破晓黎明(你若后方激情)
SetOption(Common.WEAPON.StunRifle, 0, weaponLevel.normal, 0, 255, 0, 0) -- 雷电风暴(杨永信狂喜)
SetOption(Common.WEAPON.StarChaserAR, 0, weaponLevel.normal, 0, 255, 0, 0) -- 璀璨星辰(萌新乍一看这特效以为这是年度神器)
SetOption(Common.WEAPON.CompoundBow, 0, weaponLevel.normal, 0, 255, 0, 0) -- 鹰眼(蹭"妇联"的热度)
SetOption(Common.WEAPON.LightningAR2, 0, weaponLevel.normal, 0, 255, 0, 0) -- D小调协奏曲
SetOption(Common.WEAPON.LightningAR1, 0, weaponLevel.normal, 0, 255, 0, 0) -- 战乐灵弦
SetOption(Common.WEAPON.Ethereal, 0, weaponLevel.normal, 0, 255, 0, 0) -- 尘埃之光
SetOption(Common.WEAPON.F2000, 0, weaponLevel.normal, 0, 255, 0, 0) -- f2000(假的暮光f2000)
SetOption(Common.WEAPON.Crossbow, 0, weaponLevel.normal, 0, 255, 0, 0) -- 追月连弩
SetOption(Common.WEAPON.CrossbowAdvance, 0, weaponLevel.normal, 0, 255, 0, 0) -- 追月连弩Ex
SetOption(Common.WEAPON.M4A1DarkKnight, 0, weaponLevel.normal, 0, 255, 0, 0) -- 邪皇m4a1
SetOption(Common.WEAPON.AK47Paladin, 0, weaponLevel.normal, 0, 255, 0, 0) -- 圣帝ak47
SetOption(Common.WEAPON.ARX160, 0, weaponLevel.normal, 0, 255, 0, 0) -- 风暴勇士

-- 冲锋枪 submachine gun
SetOption(Common.WEAPON.MAC10, 0, weaponLevel.normal, 0, 128, 255, 255) -- mac10(垃圾武器，对标T阵营的tmp)
SetOption(Common.WEAPON.TMP, 0, weaponLevel.normal, 0, 128, 255, 255) -- tmp(垃圾武器，对标CT阵营的mac10)
SetOption(Common.WEAPON.MP5, 0, weaponLevel.normal, 0, 128, 255, 255) -- mp5(经典武器里的神器)
SetOption(Common.WEAPON.UMP45, 0, weaponLevel.normal, 0, 128, 255, 255) -- ump45(垃圾)
SetOption(Common.WEAPON.P90, 0, weaponLevel.normal, 0, 128, 255, 255) -- p90(垃圾)
SetOption(Common.WEAPON.MP7A1ExtendedMag, 0, weaponLevel.normal, 0, 128, 255, 255) -- m7a1强化版(垃圾)
SetOption(Common.WEAPON.DualKriss, 0, weaponLevel.normal, 0, 128, 255, 255) -- 致命双刺(曾经的氪金武器，现在的垃圾)
SetOption(Common.WEAPON.KrissSuperV, 0, weaponLevel.normal, 0, 128, 255, 255) -- 致命蝎刺(vector短剑冲锋枪，垃圾)
SetOption(Common.WEAPON.Tempest, 0, weaponLevel.normal, 0, 128, 255, 255) -- 疾风之翼(痛苦积分收割者)
SetOption(Common.WEAPON.TMPDragon, 0, weaponLevel.normal, 0, 128, 255, 255) -- tmp金龙(集齐7个召唤大金龙)
SetOption(Common.WEAPON.P90Lapin, 0, weaponLevel.normal, 0, 128, 255, 255) -- p90兔耳(虚假的兔年神器：加特林，真实的兔年神器：p90兔耳)
SetOption(Common.WEAPON.DualUZI, 0, weaponLevel.normal, 0, 128, 255, 255) -- 尤利乌斯(+6后妥妥的新经典T1级别武器)
SetOption(Common.WEAPON.Needler, 0, weaponLevel.normal, 0, 128, 255, 255) -- 千针(欠揍的武器)
SetOption(Common.WEAPON.InfinityLaserFist, 0, weaponLevel.normal, 0, 128, 255, 255) -- 无限机械臂铠(有限弟弟臂铠)

-- 霰弹枪(散弹枪) shotgun
SetOption(Common.WEAPON.M3, 0, weaponLevel.normal, 0, 180, 0, 180) -- m3(假的天龙m3)
SetOption(Common.WEAPON.XM1014, 0, weaponLevel.normal, 0, 180, 0, 180) -- xm1014(连喷)
SetOption(Common.WEAPON.DoubleBarrelShotgun, 0, weaponLevel.normal, 0, 180, 0, 180) -- 破碎炙炎(双管猎枪)
SetOption(Common.WEAPON.WinchesterM1887, 0, weaponLevel.normal, 0, 180, 0, 180) -- 退魔圣焰(温彻斯特1887)
SetOption(Common.WEAPON.USAS12, 0, weaponLevel.normal, 0, 180, 0, 180) -- usas12 (垃圾，涂个12周年喷漆有点好看)
SetOption(Common.WEAPON.JackHammer, 0, weaponLevel.normal, 0, 180, 0, 180) -- 气锤
SetOption(Common.WEAPON.TripleBarrelShotgun, 0, weaponLevel.normal, 0, 180, 0, 180) -- 破碎炙炎TripleBarrel(三管猎枪)
SetOption(Common.WEAPON.SPAS12Maverick, 0, weaponLevel.normal, 0, 180, 0, 180) -- 战魂spas12
SetOption(Common.WEAPON.FireVulcan, 0, weaponLevel.normal, 0, 180, 0, 180) -- 格林炮(小加特林)
SetOption(Common.WEAPON.BALROGXI, 0, weaponLevel.normal, 0, 180, 0, 180) -- 龙炎(人送外号生化Z前期狗神)
SetOption(Common.WEAPON.BOUNCER, 0, weaponLevel.normal, 0, 180, 0, 180) -- 破灭光雷
SetOption(Common.WEAPON.FlameJackhammer, 0, weaponLevel.normal, 0, 180, 0, 180) -- 爆炎气锤
SetOption(Common.WEAPON.RailCannon, 0, weaponLevel.normal, 0, 180, 0, 180) -- 电浆轨道炮
SetOption(Common.WEAPON.LightningSG1, 0, weaponLevel.normal, 0, 180, 0, 180) -- 画梅(伞装退魔圣焰)
SetOption(Common.WEAPON.USAS12CAMO, 0, weaponLevel.normal, 0, 180, 0, 180) -- 迷彩usas12
SetOption(Common.WEAPON.WinchesterM1887Gold, 0, weaponLevel.normal, 0, 180, 0, 180) -- 退魔金焰
SetOption(Common.WEAPON.UTS15PinkGold, 0, weaponLevel.normal, 0, 180, 0, 180) -- 金焰剃刀(地速最快的霰弹枪)
SetOption(Common.WEAPON.Volcano, 0, weaponLevel.normal, 0, 180, 0, 180) -- 加特林


-- 轻机枪 light machine gun
SetOption(Common.WEAPON.M249, 0, weaponLevel.normal, 0, 255, 255, 0) -- m249(b51)
SetOption(Common.WEAPON.MG3, 0, weaponLevel.normal, 0, 255, 255, 0) -- 毁灭者mg3(远古版本"者"系列轻机枪之一，那一天，小奥门终于想起被毁灭者支配的恐惧)
SetOption(Common.WEAPON.M134Minigun, 0, weaponLevel.normal, 0, 255, 255, 0) -- 终结者(远古版本"者"系列轻机枪之一，一直搞不懂这玩意实用性不如毁灭者为什么卖的比毁灭者贵)
SetOption(Common.WEAPON.MG36, 0, weaponLevel.normal, 0, 255, 255, 0) -- 开拓者(远古版本"者"系列轻机枪之一，这稳定的弹道，这极致的定身，i了i了)
SetOption(Common.WEAPON.MK48, 0, weaponLevel.normal, 0, 255, 255, 0) -- 劫掠者(远古版本"者"系列轻机枪之一，没有神器之前地速最快的轻机枪)
SetOption(Common.WEAPON.K3, 0, weaponLevel.normal, 0, 255, 255, 0) -- k3
SetOption(Common.WEAPON.QBB95, 0, weaponLevel.normal, 0, 255, 255, 0) -- qbb95(国产轻机枪)
SetOption(Common.WEAPON.QBB95AdditionalMag, 0, weaponLevel.normal, 0, 255, 255, 0) -- qbb95暴龙(迄今为止，新经典武器中总载弹量最多的轻机枪)
SetOption(Common.WEAPON.BALROGVII, 0, weaponLevel.normal, 0, 255, 255, 0) -- 炎魔(此炎魔非彼炎魔)
SetOption(Common.WEAPON.MG3CSOGSEdition, 0, weaponLevel.normal, 0, 255, 255, 0) -- 十周年mg3
SetOption(Common.WEAPON.CHARGER7, 0, weaponLevel.normal, 0, 255, 255, 0) -- 雷暴
SetOption(Common.WEAPON.ShiningHeartRod, 0, weaponLevel.normal, 0, 255, 255, 0) -- 红宝石之心(姐姐的玩具)
SetOption(Common.WEAPON.Coilgun, 0, weaponLevel.normal, 0, 255, 255, 0) -- 雷霆破灭者
SetOption(Common.WEAPON.Aeolis, 0, weaponLevel.normal, 0, 255, 255, 0) -- 炙热蒸汽
SetOption(Common.WEAPON.BroadDivine, 0, weaponLevel.normal, 0, 255, 255, 0) -- 冰瀑毁灭者
SetOption(Common.WEAPON.LaserMinigun, 0, weaponLevel.normal, 0, 255, 255, 0) -- 爆能终结者
SetOption(Common.WEAPON.M249Phoenix, 0, weaponLevel.normal, 0, 255, 255, 0) -- 朱雀m249


-- 装备类武器 equipment
SetOption(Common.WEAPON.M32MGL, 0, weaponLevel.normal, 0, 50, 50, 255) -- 铁血重炮
SetOption(Common.WEAPON.PetrolBoomer, 0, weaponLevel.normal, 0, 50, 50, 255) -- 暴风烈焰(视觉污染)
SetOption(Common.WEAPON.Slasher, 0, weaponLevel.normal, 0, 50, 50, 255) -- 死神使者(送分使者)
SetOption(Common.WEAPON.Eruptor, 0, weaponLevel.normal, 0, 50, 50, 255) -- 龙击炮(豌豆炮)
SetOption(Common.WEAPON.Leviathan, 0, weaponLevel.normal, 0, 50, 50, 255) -- 极冻水加农(取自利维坦海怪)
SetOption(Common.WEAPON.Salamander, 0, weaponLevel.normal, 0, 50, 50, 255) -- 焚烬者
SetOption(Common.WEAPON.RPG7, 0, weaponLevel.normal, 0, 50, 50, 255) -- rpg(我喜欢玩rpg游戏)
SetOption(Common.WEAPON.M32MGLVenom, 0, weaponLevel.normal, 0, 50, 50, 255) -- 腐化重炮
SetOption(Common.WEAPON.Stinger, 0, weaponLevel.normal, 0, 50, 50, 255) -- 血猎重弩(木海皇)
SetOption(Common.WEAPON.MagnumDrill, 0, weaponLevel.normal, 0, 50, 50, 255) -- 怒海狂鲨
SetOption(Common.WEAPON.GaeBolg, 0, weaponLevel.normal, 0, 50, 50, 255) -- 海皇之怒(海皇跳)
SetOption(Common.WEAPON.Ripper, 0, weaponLevel.normal, 0, 50, 50, 255) -- 生命收割者
SetOption(Common.WEAPON.BlackDragonCannon, 0, weaponLevel.normal, 0, 50, 50, 255) -- 黑龙炮(全体起立)
SetOption(Common.WEAPON.Guillotine, 0, weaponLevel.normal, 0, 50, 50, 255) -- 盘龙血煞(血滴子)

-- 狙击枪 sniper rifle
SetOption(Common.WEAPON.SG550Commando, 0, weaponLevel.normal, 0, 255, 0, 0) -- 帅哥550(有多帅我就不解释了，对标T阵营的g3sg1)
SetOption(Common.WEAPON.G3SG1, 0, weaponLevel.normal, 0, 255, 0, 0) -- g3sg1(对标CT阵营的sg550)
SetOption(Common.WEAPON.Scout, 0, weaponLevel.normal, 0, 255, 0, 0) -- scout(小鸟)
SetOption(Common.WEAPON.AWP, 0, weaponLevel.normal, 0, 255, 0, 0) -- awp(大鸟)
SetOption(Common.WEAPON.M24, 0, weaponLevel.normal, 0, 255, 0, 0) -- m24(小蛇)
SetOption(Common.WEAPON.BarrettM95, weaponLevel.normal, 0, 0, 255, 0, 0) -- 巴雷特m95(大炮)

