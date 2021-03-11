--是否持续按下Space
spaceHolding = false
holdingTime = nil

--技能栏键盘


if UI then


    screen = UI.ScreenSize()
    center = { x = screen.width / 2, y = screen.height / 2 }

    -- Frame.mainLayer:add(Dialog((UI.ScreenSize().width - 800)/2,UI.ScreenSize().height * 0.8,800,100,"提示","+M"));

    --实例化一个按键监听器
    local keyboard = Keyboard();
    --启用按键监听器
    keyboard:enable();


    --绑定一个组合键
    --按键名大写表示按下事件，小写表示抬起事件
    --按键名前加'_'符号表示持续按下
    keyboard:bind("V", function()
        UI.Signal(SignalToGame.toggleView)
    end);

    keyboard:bind("SPACE", function()
        UI.Signal(SignalToGame.jump)
    end);

    keyboard:bind("_SPACE", function()
        if not spaceHolding then
            spaceHolding = true
            holdingTime = UI.GetTime() + 0.5
        end

        if holdingTime <= UI.GetTime() then
            UI.Signal(SignalToGame.icarus)
            spaceHolding = false
        end
    end);

    keyboard:bind("O", function()
        --查看伊卡洛斯或二段跳
        typeSkillDescribe(6)
        -- toastTest()
    end);

    keyboard:bind("U", function()
        --查看当前选择的僵尸的技能
        typeSkillDescribe(7)
    end);

    keyboard:bind("_L+NUM1", function()
        --查看当前技能栏第一个技能说明
        typeSkillDescribe(1)
    end)

    keyboard:bind("_L+NUM2", function()
        --查看当前技能栏第二个技能说明
        typeSkillDescribe(2)
    end)

    keyboard:bind("_L+NUM3", function()
        --查看当前技能栏第三个技能说明
        typeSkillDescribe(3)
    end)

    keyboard:bind("_L+NUM4", function()
        --查看当前技能栏第四个技能说明
        typeSkillDescribe(4)
    end)

    keyboard:bind("_L+NUM5", function()
        --查看当前技能栏第五个技能说明
        typeSkillDescribe(5)
    end)

    keyboard:bind("K", function()
        --取消查看技能说明
        removeSkillDescribe()
    end);

    keyboard:bind("Z", function()
        UI.Signal(SignalToGame.getSkill)
    end);

    keyboard:bind("B", function()
        UI.Signal(SignalToGame.openWeaponInven)
    end);

    keyboard:bind("G", function()
        UI.Signal(SignalToGame.gKeyUsed)
    end);

    keyboard:bind("NUM5", function()
        UI.Signal(SignalToGame.sprint)
    end)

    keyboard:bind("NUM6", function()
        UI.Signal(SignalToGame.critical)
    end)

end

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
