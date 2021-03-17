print("导入game_block.lua")
--你的地图中位置监测方块的坐标
--示例：在你的地图上放置一个位置检测方块，然后使用V键菜单打开显示坐标
--用缔造者复制器选中你的位置监测方块，此时屏幕上会出现三个用逗号隔开的数，从左至右分别按照这个格式{x = 1, y = 1, z = 1}填写
positionCheckEntityBlockTable = {
    --1 这里表示上面的号码是1的位置检测方块
    { x = -162, y = -162, z = 4 },
    { x = -164, y = -177, z = 0 },
    { x = -160, y = -154, z = 3 },
    { x = -161, y = -154, z = 3 },
    { x = -162, y = -154, z = 3 },
    { x = -163, y = -154, z = 3 },
    --2
    { x = -150, y = -132, z = -2 },
    { x = -150, y = -133, z = -2 },
    { x = -150, y = -134, z = -2 },
    { x = -150, y = -135, z = -2 },
    { x = -150, y = -136, z = -2 },
    { x = -150, y = -141, z = -2 },
    { x = -150, y = -142, z = -2 },
    { x = -150, y = -143, z = -2 },
    { x = -150, y = -144, z = -2 },
    { x = -150, y = -145, z = -2 },
    { x = -150, y = -132, z = 0 },
    { x = -150, y = -133, z = 0 },
    { x = -150, y = -134, z = 0 },
    { x = -150, y = -135, z = 0 },
    { x = -150, y = -136, z = 0 },
    { x = -150, y = -141, z = 0 },
    { x = -150, y = -142, z = 0 },
    { x = -150, y = -143, z = 0 },
    { x = -150, y = -144, z = 0 },
    { x = -150, y = -145, z = 0 },
    --3
    { x = -71, y = -146, z = -14 },
    { x = -71, y = -145, z = -14 },
    { x = -71, y = -144, z = -14 },
    { x = -71, y = -143, z = -14 },
    { x = -71, y = -142, z = -14 },
    { x = -71, y = -141, z = -14 },
    { x = -71, y = -140, z = -14 },
    { x = -71, y = -133, z = -14 },
    { x = -71, y = -132, z = -14 },
    --4
    { x = -65, y = -147, z = -12 },
    { x = -64, y = -147, z = -12 },
    { x = -63, y = -147, z = -12 },
    { x = -62, y = -147, z = -12 },
    { x = -65, y = -147, z = -14 },
    { x = -64, y = -147, z = -14 },
    { x = -63, y = -147, z = -14 },
    { x = -62, y = -147, z = -14 },
    { x = -59, y = -148, z = -11 },
    --5
    { x = -50, y = -150, z = -36 },
    { x = -50, y = -149, z = -36 },
    { x = -50, y = -148, z = -36 },
    { x = -50, y = -147, z = -36 },
    { x = -50, y = -150, z = -38 },
    { x = -50, y = -149, z = -38 },
    { x = -50, y = -148, z = -38 },
    { x = -50, y = -147, z = -38 },
    --6
    { x = -6, y = -152, z = -40 },
    { x = -6, y = -151, z = -40 },
    { x = -6, y = -150, z = -40 },
    { x = -6, y = -149, z = -40 },
    { x = -6, y = -148, z = -40 },
    { x = -6, y = -147, z = -40 },
    { x = -6, y = -146, z = -40 },
    { x = -6, y = -145, z = -40 },
    { x = -6, y = -151, z = -38 },
    { x = -6, y = -150, z = -38 },
    { x = -6, y = -149, z = -38 },
    { x = -6, y = -148, z = -38 },
    { x = -6, y = -147, z = -38 },
    { x = -6, y = -146, z = -38 },
    { x = -3, y = -160, z = -44 },
    { x = -3, y = -159, z = -44 },
    { x = -3, y = -158, z = -44 },
    { x = -3, y = -160, z = -46 },
    { x = -3, y = -159, z = -46 },
    { x = -3, y = -158, z = -46 },
    --7
    { x = 3, y = -152, z = -40 },
    { x = 3, y = -151, z = -40 },
    { x = 3, y = -150, z = -40 },
    { x = 3, y = -149, z = -40 },
    { x = 3, y = -148, z = -40 },
    { x = 3, y = -147, z = -40 },
    { x = 3, y = -146, z = -40 },
    { x = 3, y = -145, z = -40 },
    { x = 3, y = -152, z = -38 },
    { x = 3, y = -151, z = -38 },
    { x = 3, y = -150, z = -38 },
    { x = 3, y = -149, z = -38 },
    { x = 3, y = -148, z = -38 },
    { x = 3, y = -147, z = -38 },
    { x = 3, y = -146, z = -38 },
    { x = 3, y = -145, z = -38 },
    { x = 14, y = -154, z = -46 },
    { x = 13, y = -154, z = -46 },
    { x = 12, y = -154, z = -46 },
    --8
    { x = 15, y = -108, z = -49 },
    { x = 14, y = -108, z = -49 },
    { x = 13, y = -108, z = -49 },
    { x = 12, y = -108, z = -49 },
    { x = 11, y = -108, z = -49 },
    { x = 10, y = -108, z = -49 },
    --9
    { x = 15, y = -95, z = -28 },
    { x = 14, y = -95, z = -28 },
    { x = 13, y = -95, z = -28 },
    { x = 12, y = -95, z = -28 },
    { x = 11, y = -95, z = -28 },
    { x = 10, y = -95, z = -28 },
    { x = 15, y = -95, z = -30 },
    { x = 14, y = -95, z = -30 },
    { x = 13, y = -95, z = -30 },
    { x = 12, y = -95, z = -30 },
    { x = 11, y = -95, z = -30 },
    { x = 10, y = -95, z = -30 },
    { x = 20, y = -95, z = -28 },
    { x = 19, y = -95, z = -28 },
    { x = 18, y = -95, z = -28 },
    { x = 17, y = -95, z = -28 },
    { x = 20, y = -95, z = -30 },
    { x = 19, y = -95, z = -30 },
    { x = 18, y = -95, z = -30 },
    { x = 17, y = -95, z = -30 },
    --10
    { x = 22, y = -71, z = -30 },
    { x = 23, y = -71, z = -30 },
    { x = 24, y = -71, z = -30 },
    { x = 25, y = -71, z = -30 },
    { x = 22, y = -71, z = -28 },
    { x = 23, y = -71, z = -28 },
    { x = 24, y = -71, z = -28 },
    { x = 25, y = -71, z = -28 },
    --11
    { x = 28, y = -23, z = -28 },
    { x = 27, y = -23, z = -28 },
    { x = 26, y = -23, z = -28 },
    { x = 25, y = -23, z = -28 },
    { x = 24, y = -23, z = -28 },
    { x = 23, y = -23, z = -28 },
    { x = 22, y = -23, z = -28 },
    { x = 21, y = -23, z = -28 },
    { x = 20, y = -23, z = -28 },
    { x = 19, y = -23, z = -28 },
    { x = 28, y = -23, z = -30 },
    { x = 27, y = -23, z = -30 },
    { x = 26, y = -23, z = -30 },
    { x = 25, y = -23, z = -30 },
    { x = 24, y = -23, z = -30 },
    { x = 23, y = -23, z = -30 },
    { x = 22, y = -23, z = -30 },
    { x = 21, y = -23, z = -30 },
    { x = 20, y = -23, z = -30 },
    { x = 19, y = -23, z = -30 },
    --12
    { x = 40, y = -2, z = -21 },
    { x = 39, y = -2, z = -21 },
    { x = 38, y = -2, z = -21 },
    { x = 37, y = -2, z = -21 },
    { x = 36, y = -2, z = -21 },
    { x = 35, y = -2, z = -21 },
    { x = 40, y = -2, z = -23 },
    { x = 39, y = -2, z = -23 },
    { x = 38, y = -2, z = -23 },
    { x = 37, y = -2, z = -23 },
    { x = 36, y = -2, z = -23 },
    { x = 35, y = -2, z = -23 },
    { x = 40, y = -2, z = -25 },
    { x = 39, y = -2, z = -25 },
    { x = 38, y = -2, z = -25 },
    { x = 37, y = -2, z = -25 },
    { x = 36, y = -2, z = -25 },
    { x = 35, y = -2, z = -25 },
    --13
    { x = 39, y = 26, z = -23 },
    { x = 38, y = 26, z = -23 },
    { x = 37, y = 26, z = -23 },
    { x = 36, y = 26, z = -23 },
    { x = 39, y = 26, z = -25 },
    { x = 38, y = 26, z = -25 },
    { x = 37, y = 26, z = -25 },
    { x = 36, y = 26, z = -25 },
    --14
    { x = 60, y = 53, z = -23 },
    { x = 59, y = 53, z = -23 },
    { x = 58, y = 53, z = -23 },
    { x = 57, y = 53, z = -23 },
    { x = 56, y = 53, z = -23 },
    { x = 60, y = 53, z = -25 },
    { x = 59, y = 53, z = -25 },
    { x = 58, y = 53, z = -25 },
    { x = 57, y = 53, z = -25 },
    { x = 56, y = 53, z = -25 },
    --15
    { x = 63, y = 105, z = -19 },
    { x = 63, y = 106, z = -19 },
    { x = 63, y = 107, z = -19 },
    { x = 63, y = 108, z = -19 },
    { x = 63, y = 109, z = -19 },
    { x = 63, y = 105, z = -21 },
    { x = 63, y = 106, z = -21 },
    { x = 63, y = 107, z = -21 },
    { x = 63, y = 108, z = -21 },
    { x = 63, y = 109, z = -21 },
    --16
    { x = 107, y = 105, z = -18 },
    { x = 107, y = 106, z = -18 },
    { x = 107, y = 107, z = -18 },
    { x = 107, y = 108, z = -18 },
    { x = 107, y = 109, z = -18 },
    { x = 107, y = 105, z = -20 },
    { x = 107, y = 106, z = -20 },
    { x = 107, y = 107, z = -20 },
    { x = 107, y = 108, z = -20 },
    { x = 107, y = 109, z = -20 },
    { x = 107, y = 105, z = -22 },
    { x = 107, y = 106, z = -22 },
    { x = 107, y = 107, z = -22 },
    { x = 107, y = 108, z = -22 },
    { x = 107, y = 109, z = -22 },
    --17
    { x = 118, y = 116, z = -24 },
    { x = 118, y = 115, z = -24 },
    { x = 117, y = 116, z = -24 },
    { x = 117, y = 115, z = -24 },
    { x = 118, y = 116, z = -27 },
    { x = 118, y = 115, z = -27 },
    { x = 117, y = 116, z = -27 },
    { x = 117, y = 115, z = -27 },
    --18
    { x = 65, y = 151, z = -39 },
    { x = 65, y = 150, z = -39 },
    { x = 65, y = 149, z = -39 },
    { x = 65, y = 151, z = -41 },
    { x = 65, y = 150, z = -41 },
    { x = 65, y = 149, z = -41 },
    { x = 65, y = 151, z = -43 },
    { x = 65, y = 150, z = -43 },
    { x = 65, y = 149, z = -43 },
    { x = 65, y = 155, z = -43 },
    { x = 65, y = 154, z = -43 },
    { x = 65, y = 153, z = -43 },
    { x = 65, y = 147, z = -43 },
    { x = 65, y = 146, z = -43 },
    { x = 65, y = 145, z = -43 },
    --19
    --20
}

positionCheckEntityBlockList = {}

--你的地图中母体复活点方块的坐标 最好也是一个位置检测方块 这样正好注册了这个母体复活点就在这个位置检测方块这里
hostRespawnPosition = { x = -164, y = -177, z = 0 }
hostRespawnEntityBlock = Game.EntityBlock.Create(hostRespawnPosition)

--你的地图中人类集合点方块的坐标 最好也是一个位置检测方块 这样正好注册了这个母体复活点就在这个位置检测方块这里
humanGatherPosition = { x = -162, y = -162, z = 4 }
humanGatherEntityBlock = Game.EntityBlock.Create(humanGatherPosition)

--你的地图中范围逃脱方块的坐标(缔造者游戏模式中范围逃脱方块无效，请用范围触发方块代替形成逃脱范围，连接一个倒计时装置形成逃脱时间)
escapePosition = { x = 29, y = 150, z = -46 }
escapeEntityBlock = Game.EntityBlock.Create(escapePosition)

--为你注册的可触碰方块(也就是上面的位置检测方块、母体复活方块、人类集合点方块、范围逃脱方块)注册函数
function createEntityBlockFunc()
    for i = 1, ZCLOGLength(positionCheckEntityBlockTable) do
        local theEntityBlock = Game.EntityBlock.Create(positionCheckEntityBlockTable[i])
        table.insert(positionCheckEntityBlockList, theEntityBlock)
    end

    if positionCheckEntityBlockList == nil then
        return
    end

    for i = 1, ZCLOGLength(positionCheckEntityBlockList) do
        if positionCheckEntityBlockList[i] ~= nil then
            local theEntityBlock = positionCheckEntityBlockList[i]
            function theEntityBlock:OnTouch(player)
                if player ~= nil then
                    local pUser = player.user
                    pUser.useHostZombieRespawnPosition = false
                    pUser.detectionPosition = self.position
                end
            end
        end
    end
end

--获得table长度

createEntityBlockFunc()
