print("导入data_typical.lua")
-- 从game中发送的，将会被ui接受的信号 如果你有lua基础，你可以酌情修改，如果你没有lua基础，请尽量不要动下面这个表的内容
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
    speedChangedImpact = 96, --冲击减速
    speedChangedGhostHand = 97 --鬼手定身
}

-- 从ui中发送的，将会被game接受的信号 如果你有lua基础，你可以酌情修改，如果你没有lua基础，请尽量不要动下面这个表的内容
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
    speedChangedImpact = 96, --冲击减速
    speedChangedGhostHand = 97 --鬼手定身
}

-- 玩家渲染表
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

-- 公共函数 获取表长度
function ZCLOGLength(Lua_table)
    local length = 0
    for k, v in pairs(Lua_table) do
        length = length + 1
    end
    return length
end

-- 公共函数 复制table
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

-- 公共函数 递归遍历table
function ZCLOG(Lua_table)
    for k, v in pairs(Lua_table) do
        if type(v) == "table" then
            for kk, vv in pairs(v) do
                print(kk, " = ", vv)
            end
        else
            print(k, " = ", v)
        end
    end
end

-- 公共函数 table转字符串
function tableToString(luaTable)
    local tableString = "";
    for k, v in pairs(luaTable) do
        tableString = tableString .. v
    end
    return tableString
end