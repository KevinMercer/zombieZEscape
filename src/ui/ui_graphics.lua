print("导入ui_graphics.lua")
-- 绘图工具
UIGraphics = (function()
    local UIGraphics = {
        id = 1,
        root = {},
        color = { 255, 255, 255, 255 },
    };

    function UIGraphics:DrawRect(x, y, width, height)
        local box = UI.Box.Create();
        if box == nil then
            print("无法绘制矩形:已超过最大限制");
            return ;
        end
        box:Set({ x = x, y = y, width = width, height = height, r = self.color[1], g = self.color[2], b = self.color[3], a = self.color[4] });
        box:Show();
        self.root[#self.root + 1] = { self.id, { box } };
        self.id = self.id + 1;
        return self.id - 1;
    end

    function UIGraphics:DrawText(x, y, size, letterspacing, text)
        local str = {
            array = {},
            length = 0,
            charAt = function(self, index)
                if index > 0 and index <= self.length then
                    return self.array[index];
                end
                print("数组下标越界");
            end,
        };
        local currentIndex = 1;
        while currentIndex <= #text do
            local cs = 1;
            local seperate = { 0, 0xc0, 0xe0, 0xf0 };
            for i = #seperate, 1, -1 do
                if string.byte(text, currentIndex) >= seperate[i] then
                    cs = i;
                    break ;
                end
            end
            str.array[#str.array + 1] = string.sub(text, currentIndex, currentIndex + cs - 1);
            currentIndex = currentIndex + cs;
            str.length = str.length + 1;
        end
        self.root[#self.root + 1] = { self.id, {} };
        for i = 1, str.length do
            local char = str:charAt(i)
            if Font[char] == nil then
                char = "?";
            end
            for j = 1, #Font[char], 4 do
                local _x = Font[char][j];
                local _y = Font[char][j + 1];
                local width = Font[char][j + 2];
                local height = Font[char][j + 3];

                local box = UI.Box.Create();
                if box == nil then
                    print("无法绘制矩形:已超过最大限制");
                    return ;
                end
                if i == 1 then
                    box:Set({ x = x + _x * size, y = y + _y * size, width = width * size, height = height * size, r = self.color[1], g = self.color[2], b = self.color[3], a = self.color[4] });
                else
                    box:Set({ x = x + (i - 1) * letterspacing + _x * size, y = y + _y * size, width = width * size, height = height * size, r = self.color[1], g = self.color[2], b = self.color[3], a = self.color[4] });
                end
                (self.root[#self.root][2])[#self.root[#self.root][2] + 1] = box;
                box:Show();
            end
        end
        self.id = self.id + 1;
        return self.id - 1;
    end

    function UIGraphics:DrawImage(x, y, size, image)
        self.root[#self.root + 1] = { self.id, {} };
        for i = 1, #image, 5 do
            local _x = image[i];
            local _y = image[i + 1];
            local width = image[i + 2];
            local height = image[i + 3];

            self.color[1] = 0xFF & image[i + 4];
            self.color[2] = (0xFF00 & image[i + 4]) >> 8;
            self.color[3] = (0xFF0000 & image[i + 4]) >> 16;

            local box = UI.Box.Create();
            if box == nil then
                print("无法绘制矩形:已超过最大限制");
                return ;
            end
            box:Set({ x = x + _x * size, y = y + _y * size, width = width * size, height = height * size, r = self.color[1], g = self.color[2], b = self.color[3], a = self.color[4] });
            (self.root[#self.root][2])[#self.root[#self.root][2] + 1] = box;
            box:Show();
        end
        self.id = self.id + 1;
        return self.id - 1;
    end

    function UIGraphics:Remove(id)
        for i = 1, #self.root do
            if self.root[i][1] == id then
                table.remove(self.root, i);
                collectgarbage("collect");
                return ;
            end
        end
    end

    function UIGraphics:Show(id)
        for i = 1, #self.root do
            if self.root[i][1] == id then
                for j = 1, #self.root[i][2] do
                    self.root[i][2][j]:Show();
                end
                return ;
            end
        end
    end

    function UIGraphics:Hide(id)
        for i = 1, #self.root do
            if self.root[i][1] == id then
                for j = 1, #self.root[i][2] do
                    self.root[i][2][j]:Hide();
                end
                return ;
            end
        end
    end

    function UIGraphics:Clean()
        self.root = {};
        collectgarbage("collect");
    end

    return UIGraphics;
end)();

------------------------------------------------------------------
