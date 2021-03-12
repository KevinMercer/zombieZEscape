--是否持续按下Space
spaceHolding = false
holdingTime = nil

--技能栏键盘
--实例化一个按键监听器
local keyboard = Keyboard();
--启用按键监听器
keyboard:enable();

--绑定一个组合键
keyboard:bind(keyboardKeyList.toggleView, function()
    UI.Signal(SignalToGame.toggleView)
end);

keyboard:bind(keyboardKeyList.jump, function()
    UI.Signal(SignalToGame.jump)
end);

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

keyboard:bind(keyboardKeyList.checkZombieSkillOne, function()
    --查看伊卡洛斯或二段跳
    typeSkillDescribe(6)
end);

keyboard:bind(keyboardKeyList.checkZombieSkillTwo, function()
    --查看当前选择的僵尸的技能
    typeSkillDescribe(7)
end);

keyboard:bind(keyboardKeyList.checkCurrentSkillOne, function()
    --查看当前技能栏第一个技能说明
    typeSkillDescribe(1)
end)

keyboard:bind(keyboardKeyList.checkCurrentSkillTwo, function()
    --查看当前技能栏第二个技能说明
    typeSkillDescribe(2)
end)

keyboard:bind(keyboardKeyList.checkCurrentSkillThree, function()
    --查看当前技能栏第三个技能说明
    typeSkillDescribe(3)
end)

keyboard:bind(keyboardKeyList.checkCurrentSkillFour, function()
    --查看当前技能栏第四个技能说明
    typeSkillDescribe(4)
end)

keyboard:bind(keyboardKeyList.checkCurrentSkillFive, function()
    --查看当前技能栏第五个技能说明
    typeSkillDescribe(5)
end)

keyboard:bind(keyboardKeyList.closeSkillDescribeKLayer, function()
    --取消查看技能说明
    removeSkillDescribe()
end);

keyboard:bind(keyboardKeyList.getSkill, function()
    UI.Signal(SignalToGame.getSkill)
end);

keyboard:bind(keyboardKeyList.toggleWeaponInventory, function()
    UI.Signal(SignalToGame.openWeaponInven)
end);

keyboard:bind(keyboardKeyList.activeZombieSkill, function()
    UI.Signal(SignalToGame.gKeyUsed)
end);

keyboard:bind(keyboardKeyList.sprintSkill, function()
    UI.Signal(SignalToGame.sprint)
end)

keyboard:bind(keyboardKeyList.criticalSkill, function()
    UI.Signal(SignalToGame.critical)
end)


--toast测试函数
function toastTest()
    Toast:closeToast(toastLayerName)
    isToast = false
    toastLayerName = nil
    local layerNameSkillGet = "获得技能"
    Toast:makeText("6键激活:你将永远留在这里", nil, nil, screen.height * 0.5 - 100, layerNameSkillGet, 5)
    isToast = true
    toastLayerName = layerNameSkillGet
    toastFadeTime = UI.GetTime() + 5
end
