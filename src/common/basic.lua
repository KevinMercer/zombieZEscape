layerTable = {}

Class = (function()

    function ZCLOG(Lua_table)
        for k, v in pairs(Lua_table) do
            print(k, v)
        end
    end

    local function TRANSLATE(object)
        local str = {};
        if type(object) == "number" then
            str[#str + 1] = object;
        elseif type(object) == "boolean" then
            str[#str + 1] = tostring(object);
        elseif type(object) == "string" then
            str[#str + 1] = "'" .. object .. "'";
        elseif type(object) == "table" then
            str[#str + 1] = "{";
            for key, value in pairs(object) do
                if type(key) == "string" then
                    str[#str + 1] = "['" .. key .. "']=";
                else
                    str[#str + 1] = "[" .. key .. "]=";
                end
                str[#str + 1] = TRANSLATE(value);
                str[#str + 1] = ",";
            end
            str[#str + 1] = "}";
        end
        return table.concat(str);
    end

    local function SERIALIZE(object)
        local str = { "return {" };
        for key, value in pairs(object) do
            if type(key) == "number" then
                error("不可用数字作为索引")
            end
            str[#str + 1] = "['" .. key .. "']=";
            str[#str + 1] = TRANSLATE(value);
            str[#str + 1] = ",";
        end
        str[#str + 1] = "}";
        return table.concat(str);
    end

    local function UNSERIALIZE(str)
        return load(str)();
    end

    NULL = {};
    local CLASS = setmetatable({}, {
        __newindex = function(object, key, value)
            if object[value.NAME] ~= nil then
                error("类型" .. value.NAME .. "已经定义过了");
            end
            if object.MEMORY ~= nil and Game ~= nil then
                setmetatable(object.MEMORY, {
                    __newindex = function(table, key, value)
                        if table[key] == nil then
                            print(_name ".MEMORY没有索引" .. key)
                        else
                            rawset(table, key, value);
                        end
                    end
                })
                if not Game.Rule:CanSave() then
                    print("该地图无法保存数据");
                    object.SAVE = function()
                    end;
                else
                    local key = "OBJECT[" .. _name .. "]";
                    local value = Game.Rule:GetGameSave(key);
                    if type(value) == "string" then
                        local success, result = pcall(UNSERIALIZE, value);
                        if success then
                            for key, value in pairs(result) do
                                object.MEMORY[key] = result[key];
                            end
                        else
                            print("OBJECT[" .. _name .. "]无法读取MEMORY");
                        end
                    end
                    function object:SAVE()
                        Game.Rule:SetGameSave(key, SERIALIZE(self.MEMORY));
                        if (self.super or {}).MEMORY ~= nil then
                            self.super:SAVE();
                        end
                    end
                end
            end
            rawset(object, key, value);
        end
    });
    CLASS["Object"] = {
        NAME = "Object",
        TABLE = {
            __call = function()
            end,
            __newindex = function(table, key, value)
                if value == nil then
                    error("赋值不能为nil");
                end
                if table[key] ~= nil and type(value) ~= type(table[key]) then
                    error('key:' .. key .. "赋值类型与原类型不相同" .. type(value) .. "~=" .. type(table[key]));
                end
                if table[key] ~= nil then
                    local temp = table;
                    while temp ~= nil do
                        if rawget(temp, key) ~= nil then
                            rawset(temp, key, value);
                            return ;
                        end
                        temp = temp.super;
                    end
                end
                rawset(table, key, value);
            end,
        },
        SUPER = nil,
    }
    local function CREATECLASS(_name, _function, _super)
        _super = (_super or { CLASS = CLASS["Object"] }).CLASS;
        local object = {};
        _function(object);
        CLASS[_name] = {
            NAME = _name,
            TABLE = object,
            SUPER = _super,
        }
        if object.STATIC == true then
            _G[_name] = CLASS[_name].TABLE;
        else
            local classList = { CLASS[_name] };
            while _super ~= nil do
                classList[#classList + 1] = _super;
                _super = _super.SUPER;
            end
            local str = {};
            for i = 1, #classList do
                str[#str + 1] = string.format("local %s = {super=nil,__call =nil,__newindex=nil,__index=nil,", classList[i].NAME)
                for key, _ in pairs(classList[i].TABLE) do
                    str[#str + 1] = string.format("%s = CLASS['%s'].TABLE.%s,", key, classList[i].NAME, key);
                end
                str[#str + 1] = "};"
            end
            for i = 1, #classList do
                if i ~= 1 then
                    str[#str + 1] = string.format("%s.__call=%s.constructor or function() end;", classList[i].NAME, classList[i - 1].NAME);
                end
                if i ~= #classList then
                    if i ~= #classList - 1 then
                        str[#str + 1] = string.format("%s.super=%s;", classList[i].NAME, classList[i + 1].NAME);
                    end
                    str[#str + 1] = string.format("%s.__index=%s;", classList[i].NAME, classList[i].NAME) .. string.format("%s.__newindex=Object.__newindex;", classList[i].NAME) .. string.format("setmetatable(%s,%s);", classList[i].NAME, classList[i + 1].NAME);
                end
            end
            str[#str + 1] = string.format("return %s;", _name);
            CLASS[_name].NEW = load(table.concat(str), "", "t", { rawset = rawset, error = error, type = type, rawget = rawget, getmetatable = getmetatable, setmetatable = setmetatable, CLASS = CLASS })
            local POOL = {};
            _G[_name] = setmetatable({
                CLASS = CLASS[_name],
                RETURNOBJECT = function(self, object)
                    if #POOL < 16 then
                        POOL[#POOL + 1] = object;
                    end
                end
            }, {
                __call = function(self, ...)
                    local object;
                    if #POOL ~= 0 then
                        object = table.remove(POOL, #POOL);
                    else
                        object = self.CLASS.NEW();
                    end
                    object(...);
                    return object;
                end
            });
        end
    end
    return CREATECLASS;
end)();

Class("String", function(String)
    String.STATIC = true;
    function String:charSize(char)
        local seperate = { 0, 0xc0, 0xe0, 0xf0 }
        for i = #seperate, 1, -1 do
            if char >= seperate[i] then
                return i;
            end
        end
        return 1;
    end

    function String:toString(value)
        local array = {};
        local currentIndex = 1;
        while currentIndex <= #value do
            local cs = String:charSize(value[currentIndex]);
            array[#array + 1] = string.char(table.unpack(value, currentIndex, currentIndex + cs - 1));
            currentIndex = currentIndex + cs;
        end
        return table.concat(array);
    end

    function String:toBytes(value)
        local bytes = {};
        if type(value) == "string" then
            value = String:toTable(value);
        end
        for i = 1, #value do
            for j = 1, #value[i], 1 do
                table.insert(bytes, string.byte(value[i], j));
            end
        end
        return bytes;
    end

    function String:toTable(value)
        local currentIndex = 1;
        local array = {};
        while currentIndex <= #value do
            local cs = String:charSize(string.byte(value, currentIndex));
            array[#array + 1] = string.sub(value, currentIndex, currentIndex + cs - 1);
            currentIndex = currentIndex + cs;
        end
        return array;
    end
end);

Class("Listener", function(Listener)
    function Listener:constructor(func)
        self.call = func;
        self.status = 1;
    end

    function Listener:stop()
        self.status = 0;
    end

    function Listener:start()
        self.status = 1;
    end

    function Listener:cancel()
        self.status = -1;
    end
end);

Class("TimerTask", function(TimerTask)
    function TimerTask:constructor(func, time, period)
        self.super(func);
        self.time = time or 0;
        self.period = period or -1;
    end
end, Listener);

Class("Event", function(Event)
    Event.STATIC = true;
    Event.listenerList = {};
    if Game ~= nil then
        Event.listenerList = { "OnPlayerConnect", "OnPlayerDisconnect", "OnRoundStart", "OnRoundStartFinished", "OnPlayerSpawn", "OnPlayerJoiningSpawn", "OnPlayerKilled", "OnKilled", "OnPlayerSignal", "OnUpdate", "OnPlayerAttack", "OnTakeDamage", "CanBuyWeapon", "CanHaveWeaponInHand", "OnGetWeapon", "OnReload", "OnReloadFinished", "OnSwitchWeapon", "PostFireWeapon", "OnGameSave", "OnLoadGameSave", "OnClearGameSave" };
    end
    if UI ~= nil then
        Event.listenerList = { "OnRoundStart", "OnSpawn", "OnKilled", "OnInput", "OnUpdate", "OnChat", "OnSignal", "OnKeyDown", "OnKeyUp" };
    end
    for i = 1, #Event.listenerList do
        Event[Event.listenerList[i]] = {};
        ((UI or Game).Event or (UI or Game).Rule)[Event.listenerList[i]] = function(_, ...)
            local list = Event[Event.listenerList[i]];
            local result;
            for j = #list, 1, -1 do
                if list[j].status == 1 then
                    result = list[j]:call(...);
                elseif list[j].status == -1 then
                    table.remove(list, j);
                end
            end
            return result;
        end
    end

    function Event:addEventListener(event, listener)
        if type(event) == "string" then
            event = self[event];
        end
        if type(listener) == "function" then
            listener = Listener(listener);
        end
        event[#event + 1] = listener;
        return listener;
    end

    function Event:purge(event)
        if type(event) == "string" then
            event = self[event];
        end
        for i = #event, 1, -1 do
            event[i] = nil;
        end
    end
end);

Class("Timer", function(Timer)
    Timer.STATIC = true;

    Timer.task = {};
    Timer.count = 0;
    Event:addEventListener(Event.OnUpdate, function()
        for i = #Timer.task, 1, -1 do
            if Timer.task[i].time <= Timer.count then
                local success, result;
                if Timer.task[i].status == 1 then
                    Timer.task[i]:call();
                    -- success,result = pcall(Timer.task[i].call,Timer.task[i])
                    -- if not success then
                    --     print("Timer中的函数发生了异常");
                    --     print(result)
                    --     Timer.task[i]:cancel();
                    -- end
                end
                if Timer.task[i].period == -1 or Timer.task[i].status == -1 or result == true then
                    TimerTask:RETURNOBJECT(table.remove(Timer.task, i))
                else
                    Timer.task[i].time = Timer.count + Timer.task[i].period;
                end
            end
        end
        Timer.count = Timer.count + 1;
    end);

    function Timer:schedule(call, delay, period)
        self.task[#self.task + 1] = TimerTask(call, self.count + delay, period);
        return self.task[#self.task];
    end

    function Timer:purge()
        self.task = {}
    end
end);

Class("Route", function(Route)
    Route.STATIC = true;

    Route.UI = {};
    Route._UI = {};

    Route.Game = {};
    Route._Game = {};

    function Route:game(name, func)
        self.Game[name] = #self._Game + 1;
        self._Game[#self._Game + 1] = func;
    end

    function Route:ui(name, func)
        self.UI[name] = #self.UI + 1;
        self._UI[#self._UI + 1] = func;
    end

    Route:game("GETNAME", function(player, bytes)
        return String:toBytes(player.name);
    end);

    Route:ui("REQUEST", function(bytes)
        table.remove(NetClient.requestQueue, 1)(bytes);
    end);

end);

Class("Group", function(Group)
    function Group:constructor()

    end
end);

if Game ~= nil then

    Class("NetServer", function(NetServer)
        NetServer.STATIC = true;
        NetServer.receivbBuffer = {};
        NetServer.syncValue = {};
        NetServer.players = {};

        Event:addEventListener(Event.OnPlayerSignal, function(self, player, signal)
            local receivbBuffer = NetServer.receivbBuffer[player.name];
            if receivbBuffer.id == -1 then
                receivbBuffer.id = signal;
            elseif receivbBuffer.length == -1 then
                receivbBuffer.length = signal;
            else
                receivbBuffer.value[#receivbBuffer.value + 1] = signal;
                receivbBuffer.length = receivbBuffer.length - 1;
            end
            if receivbBuffer.length == 0 then
                NetServer:execute(player, Route.UI.REQUEST, Route._Game[receivbBuffer.id](player, receivbBuffer.value) or {});
                NetServer.receivbBuffer[player.name] = {
                    id = -1,
                    length = -1,
                    value = {},
                };
            end
        end);

        Event:addEventListener(Event.OnPlayerConnect, function(self, player)
            NetServer.receivbBuffer[player.name] = {
                id = -1,
                length = -1,
                value = {},
            };
            NetServer.players[player.name] = player;
            NetServer.syncValue[player.name] = {};
        end);

        Event:addEventListener(Event.OnPlayerDisconnect, function(self, player)
            NetServer.receivbBuffer[player.name] = nil;
            NetServer.players[player.name] = nil;
            NetServer.syncValue[player.name] = nil;
        end);

        function NetServer:createSyncValue(player, key, value)
            local sync = Game.SyncValue.Create("[" .. player.name .. "]:" .. key);
            sync.value = value;
            self.syncValue[player.name][key] = sync;
            return sync;
        end

        function NetServer:setSyncValue(player, key, value)
            self.syncValue[player.name][key].value = value;
        end

        function NetServer:execute(player, key, bytes)
            player:Signal(key);
            player:Signal(#bytes);
            for i = 1, #bytes do
                player:Signal(bytes[i]);
            end
        end
    end);
end

if UI ~= nil then

    Class("Request", function(Request)
        function Request:constructor(code, bytes)
            self.code = code;
            self.bytes = bytes or {};
            self.body = { code, #self.bytes, table.unpack(self.bytes) };
        end

        function Request:parser(body)
            self.body = body;
            self.code = body[1];
            self.bytes = {};
            for i = 3, #body - 2 do
                self.bytes[#self.bytes + 1] = body[i];
            end
        end
    end);

    -- Class("NetClient",function(NetClient)
    -- NetClient.STATIC = true;
    -- NetClient.name = "";

    -- NetClient.requestQueue = {};

    -- NetClient.receivbBuffer = {
    -- key = -1,
    -- length = -1,
    -- value = {},
    -- };

    -- Event:addEventListener(Event.OnSignal,function(self,signal)
    -- print("!!!! = ", signal)
    -- if NetClient.receivbBuffer.key == -1 then
    -- NetClient.receivbBuffer.key = signal;
    -- elseif NetClient.receivbBuffer.length == -1 then
    -- NetClient.receivbBuffer.length = signal;
    -- else
    -- NetClient.receivbBuffer.value[#NetClient.receivbBuffer.value+1] = signal;
    -- NetClient.receivbBuffer.length = NetClient.receivbBuffer.length - 1;
    -- end
    -- if NetClient.receivbBuffer.length == 0 then
    -- Route._UI[NetClient.receivbBuffer.key](NetClient.receivbBuffer.value);
    -- NetClient.receivbBuffer = {
    -- key = -1,
    -- length = -1,
    -- value = {},
    -- };
    -- end
    -- end);

    -- function NetClient:createSyncValue(key,call)
    -- local syncValue = UI.SyncValue:Create("["..NetClient.name.."]:"..key);
    -- syncValue.OnSync = call;
    -- return syncValue;
    -- end

    -- function NetClient:request(request,success)
    -- for i = 1,#request.body do
    -- UI.Signal(request.body[i]);
    -- end
    -- self.requestQueue[#self.requestQueue+1] = success or function() end;
    -- end

    -- NetClient:request(Request(Route.Game.GETNAME),function(bytes)
    -- NetClient.name = String:toString(bytes);
    -- end)
    -- end);

    Class("Base64", function(Base64)
        Base64.STATIC = true;
        local charlist = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ<>";
        local charmap = {};
        for i = 1, #charlist do
            charmap[string.sub(charlist, i, i)] = i - 1;
        end

        function Base64:toNumber(...)
            local text = { ... };
            local number = 0;
            for i = 1, #text do
                number = (number << 6) + charmap[text[i]];
            end
            return number;
        end
    end);

    Class("Bitmap", function(Bitmap)
        function Bitmap:constructor(data)
            self.size = 1;
            self.map = {};

            local iterator = string.gmatch(data, "[^ ]+")
            local first = String:toTable(iterator());

            self.width = Base64:toNumber(first[1], first[2]);
            self.height = Base64:toNumber(first[3], first[4]);

            for value in iterator do
                local value = String:toTable(value);
                local color = Base64:toNumber(value[1], value[2], value[3], value[4]);
                local array = {};
                for i = 5, #value, 2 do
                    array[#array + 1] = Base64:toNumber(value[i], value[i + 1]);
                end
                self.map[color] = array;
            end
        end

        function Bitmap:getTable()
            return self.map;
        end

        function Bitmap:getSize()
            return self.width * self.size, self.height * self.size;
        end

    end);

    Class("Keyboard", function(Keyboard)
        Keyboard.TYPE_DOWN = 0;
        Keyboard.TYPE_UP = 1;
        Keyboard.TYPE_INPUT = 2;

        function Keyboard:constructor()
            self.combinationList = {};
            self.enduring = true;
            self.isEnable = false;
        end

        function Keyboard:enable()
            if self.isEnable == false then
                self.isEnable = true;
                self.onKeyDownListener = Event:addEventListener(Event.OnKeyDown, function(listener, inputs)
                    self:detection(Keyboard.TYPE_DOWN, inputs);
                end);

                self.onKeyUpListener = Event:addEventListener(Event.OnKeyUp, function(listener, inputs)
                    self:detection(Keyboard.TYPE_UP, inputs);
                end);

                self.onInputs = {};
                self.onInputListener = Event:addEventListener(Event.OnInput, function(listener, inputs)
                    self.onInputs = inputs;
                    self:detection(Keyboard.TYPE_INPUT, inputs);
                end);
            end
        end

        function Keyboard:disable()
            if self.isEnable == true then
                self.isEnable = false;
                self.onKeyDownListener:cancel();
                self.onKeyUpListener:cancel();
                self.onInputListener:cancel();
            end
        end

        function Keyboard:bind(keys, call)
            local keyList = {};
            for str in string.gmatch(keys, "[^+ ]+") do
                local key;
                local type;
                if string.sub(str, 1, 1) == '_' then
                    key = string.sub(str, 2, #str);
                    type = Keyboard.TYPE_INPUT;
                elseif string.byte(str, 1, 1) >= 65 and string.byte(str, 1, 1) <= 90 then
                    key = str;
                    type = Keyboard.TYPE_DOWN;
                else
                    key = string.upper(str);
                    type = Keyboard.TYPE_UP;
                end
                if UI.KEY[key] == nil then
                    error("按键" .. key .. "不存在");
                end
                key = UI.KEY[key];
                keyList[#keyList + 1] = { key = key, type = type };
            end
            keyList.cursor = 1;
            keyList.call = call;

            local pos = 1;
            for i = 1, #self.combinationList do
                if #keyList > #self.combinationList[i] then
                    pos = i;
                    break ;
                end
            end
            table.insert(self.combinationList, pos, keyList);
            return keyList;
        end

        function Keyboard:unbind(keyList)
            for i = 1, #self.combinationList do
                local flag = true;
                if self.combinationList[i] == keyList then
                    table.remove(self.combinationList, i);
                    return ;
                end
            end
        end

        function Keyboard:detection(type, inputs)
            for i = 1, #self.combinationList do
                local keyList = self.combinationList[i];
                if keyList[keyList.cursor].type == type then
                    if inputs[keyList[keyList.cursor].key] == true then
                        keyList.cursor = keyList.cursor + 1;
                    end
                    if keyList.cursor == #keyList + 1 then
                        for j = 1, #keyList do
                            if keyList[j].type == Keyboard.TYPE_INPUT and self.onInputs[keyList[j].key] ~= true then
                                keyList.cursor = 1;
                                return ;
                            end
                        end
                        keyList.call();
                        if self.enduring then
                            keyList.cursor = 1;
                        else
                            for j = 1, #self.combinationList do
                                self.combinationList[j].cursor = 1;
                            end
                            return ;
                        end
                    end
                end
            end
        end
    end);

    Class("Font", function(Font)
        function Font:constructor(size)
            self.count = 0;
            self.data = {};
            self.map = {
                [' '] = {},
            };
            self.sizeMap = {
            };
        end

        function Font:getChar(c)
            if self.map[c] == nil then
                return {};
            end
            return self.map[c];
        end

        function Font:load(data)
            local iterator = string.gmatch(data, "[^ ]+");
            -- Timer:schedule(function(task)
            for i = 1, 50 do
                local value = iterator();
                if value == nil then
                    print("字体已加载，共:" .. self.count)
                    -- task:cancel();
                    return ;
                end
                self.count = self.count + 1;
                local charArray = String:toTable(value);
                local key = charArray[1];
                local value = {};
                for i = 2, #charArray do
                    value[#value + 1] = Base64:toNumber(charArray[i]);
                end
                self.map[key] = value;
                self.sizeMap[key] = nil;
            end
            -- end,0,1)
        end

        function Font:getCharSize(char, size)
            if self.sizeMap[char] == nil then
                local charArray = self:getChar(char);
                local width = 0;
                local height = 0;

                for j = 1, #charArray, 4 do
                    local _x = charArray[j];
                    local _y = charArray[j + 1];
                    local _width = charArray[j + 2];
                    local _height = charArray[j + 3];
                    if _x + _width > width then
                        width = _x + _width;
                    end
                    if _y + _height > height then
                        height = _y + _height;
                    end
                end

                if char == " " then
                    local w, h = self:getCharSize('A', 1);
                    width = w;
                    height = h;
                end
                self.sizeMap[char] = { width, height };
            end
            return self.sizeMap[char][1] * size, self.sizeMap[char][2] * size;
        end

        function Font:getTextSize(text, size, letterspacing)
            if type(text) == "string" then
                text = String:toTable(text);
            end
            local height = 0;
            local width = 0;
            for i = 1, #text do
                local w, h = self:getCharSize(text[i], size);
                width = width + w + letterspacing;
                if h > height then
                    height = h;
                end
            end
            return width - letterspacing, height;
        end
    end);

    Class("Graphics", function(Graphics)
        Song = Font();

        function Graphics:constructor(layer)
            self.block = {};
            self.color = { 255, 255, 255, 255 };
            self.opacity = 1;

            self.pixelsize = 3;
            self.letterspacing = 3;
            self.font = Song;

            self.width = UI.ScreenSize().width;
            self.height = UI.ScreenSize().height;
        end

        function Graphics:drawRect(x, y, width, height, rect)
            local block = UI.Box.Create();
            if block == nil then
                print("BOX已超过最大限制");
                return ;
            end

            if self.color[4] <= 0 or self.opacity <= 0 then
                return ;
            end
            if rect ~= nil then
                if x > rect[1] + rect[3] then
                    return ;
                end
                if y > rect[2] + rect[4] then
                    return ;
                end
                if x + width < rect[1] or y + height < rect[2] then
                    return ;
                end
                if x < rect[1] then
                    x = rect[1];
                end
                if y < rect[2] then
                    y = rect[2];
                end
                if x + width > rect[1] + rect[3] then
                    width = rect[1] + rect[3] - x;
                end
                if y + height > rect[2] + rect[4] then
                    height = rect[2] + rect[4] - y;
                end
            end
            block:Set({ x = x, y = y, width = width, height = height, r = self.color[1], g = self.color[2], b = self.color[3], a = self.color[4] * self.opacity });
            block:Show();
            self.block[#self.block + 1] = block;
        end;

        function Graphics:drawNumber(x, y, text, rect)
            local block = UI.Text.Create();
            if block == nil then
                print("BOX已超过最大限制");
                return ;
            end

            if self.color[4] <= 0 or self.opacity <= 0 then
                return ;
            end
            local width = self.width;
            local height = self.pixelsize * 25;
            if rect ~= nil then
                if x > rect[1] + rect[3] then
                    return ;
                end
                if y > rect[2] + rect[4] then
                    return ;
                end
                if x + width < rect[1] or y + height < rect[2] then
                    return ;
                end
                if x < rect[1] then
                    x = rect[1];
                end
                if y < rect[2] then
                    y = rect[2];
                end
                if x + width > rect[1] + rect[3] then
                    width = rect[1] + rect[3] - x;
                end
                if y + height > rect[2] + rect[4] then
                    height = rect[2] + rect[4] - y;
                end
            end
            block:Set({ x = x, y = y, width = width, height = height, text = text, font = "large", align = "left", r = self.color[1], g = self.color[2], b = self.color[3], a = self.color[4] * self.opacity });
            block:Show();
            self.block[#self.block + 1] = block;
        end

        function Graphics:drawText(x, y, text, rect)
            if type(text) == "string" then
                text = String:toTable(text);
            end
            local ls = 0;
            for i = 1, #text do
                local c = text[i]
                local boxArray = self.font:getChar(c);
                if c ~= " " and #boxArray == 0 then
                    print("未找到字符:" .. c);
                end
                for j = 1, #boxArray, 4 do
                    local _x = boxArray[j];
                    local _y = boxArray[j + 1];
                    local _width = boxArray[j + 2];
                    local _height = boxArray[j + 3];
                    if i == 1 then
                        self:drawRect(x + _x * self.pixelsize, y + _y * self.pixelsize, _width * self.pixelsize, _height * self.pixelsize, rect);
                    else
                        self:drawRect(x + ls + _x * self.pixelsize, y + _y * self.pixelsize, _width * self.pixelsize, _height * self.pixelsize, rect);
                    end
                end
                local charWidth = self.font:getCharSize(c, self.pixelsize);
                ls = ls + charWidth + self.letterspacing;
            end
            return ls;
        end

        function Graphics:drawBitmap(component, x, y, bitmap, rect)
            local map = bitmap:getTable();
            for key, value in pairs(map) do
                self.color[1] = 0xFF & key;
                self.color[2] = (0xFF00 & key) >> 8;
                self.color[3] = (0xFF0000 & key) >> 16;
                for i = 1, #value, 4 do
                    local _x = value[i];
                    local _y = value[i + 1];
                    local _width = value[i + 2];
                    local _height = value[i + 3];
                    self:drawRect(component, x + _x * bitmap.size, y + _y * bitmap.size, _width * bitmap.size, _height * bitmap.size, rect);
                end
            end
        end

        function Graphics:clean()
            self.block = {};
            collectgarbage("collect");
        end
    end);

    Class("Layer", function(Layer)
        function Layer:constructor(layerName)
            self.components = {};
            self.graphics = Graphics(self);
            self.keyboard = Keyboard();
            self.isvisible = false;
            self.stopplayercontrol = false;
            if layerName ~= nil then
                self.layerName = layerName
                layerTable[layerName] = self
            end
        end

        function Layer:add(component)
            self.components[#self.components + 1] = component;
            component.layer = self;
            component:onLoad();
            if self.isvisible == true and component.isvisible == true then
                self:repaint();
            end
            return self;
        end

        function Layer:remove(component)
            for i = 1, #self.components do
                if self.components[i] == component then
                    table.remove(self.components, i);
                    component.layer = NULL;
                    if component.animation ~= NULL then
                        component.animation:cancel();
                        component.animation = NULL;
                    end
                    if self.isvisible == true and component.isvisible == true then
                        self:repaint();
                    end
                    return ;
                end
            end
            return self;
        end

        function Layer:onKeyDown(inputs)
            for i = #self.components, 1, -1 do
                self.components[i]:onKeyDown(inputs);
            end
        end

        function Layer:onKeyUp(inputs)
            for i = #self.components, 1, -1 do
                self.components[i]:onKeyUp(inputs);
            end
        end

        function Layer:create()
            Frame:append(self);
        end

        function Layer:close()
            layerTable[self.layerName] = nil
            Frame:remove(self);
            showSkillImageBox = true
            drawSkillImageFunc(youAreZombie)
        end

        function Layer:show()
            self.isvisible = true;
            if self.stopplayercontrol == true then
                UI.StopPlayerControl(true);
            end
            self.keyboard:enable();
            for i = #self.components, 1, -1 do
                if self.components[i].isvisible then
                    self.components[i]:paint(self.graphics);
                end
            end
        end

        function Layer:hide()
            if self.stopplayercontrol == true then
                UI.StopPlayerControl(false);
            end
            self.isvisible = false;
            self.keyboard:disable();
            self.graphics:clean();
        end

        function Layer:repaint()
            if self.isvisible then
                self.graphics:clean();
                for i = #self.components, 1, -1 do
                    if self.components[i].isvisible then
                        self.components[i]:paint(self.graphics);
                    end
                end
            end
        end
    end);

    Class("Frame", function(Frame)
        Frame.STATIC = true;

        Frame.width = Graphics.width;
        Frame.height = Graphics.height;

        Frame.mainLayer = Layer();
        Frame.mainLayer:show();

        Frame.layerStack = { Frame.mainLayer };

        Frame.currentPage = Frame.mainLayer;

        Event:addEventListener(Event.OnKeyDown, function(listener, inputs)
            Frame.currentPage:onKeyDown(inputs);
        end);
        Event:addEventListener(Event.OnKeyUp, function(listener, inputs)
            Frame.currentPage:onKeyUp(inputs);
        end);

        function Frame:append(layer)
            self.layerStack[#self.layerStack]:hide();
            self.layerStack[#self.layerStack + 1] = layer;
            self.currentPage = layer;
            layer:show();
        end

        function Frame:remove(layer)
            if layer == self.currentPage then
                layer:hide();
                self.layerStack[#self.layerStack] = nil;
                Frame.currentPage = self.layerStack[#self.layerStack];
                Frame.currentPage:show();
            else
                for i = #self.layerStack - 1, 2, -1 do
                    if self.layerStack[i] == layer then
                        layer:hide();
                        table.remove(self.layerStack, i);
                    end
                end
            end
        end
    end);

    Class("Component", function(Component)
        function Component:constructor(x, y, width, height, attributes)
            self.x = x or 0;
            self.y = y or 0;
            self.width = width or 0;
            self.height = height or 0;

            self.layer = NULL;

            self.isvisible = true;
            self.rect = { self.x, self.y, self.width, self.height };
            self.opacity = 1;
            self.backgroundcolor = { 255, 255, 255, 255 };
            self.border = { 0, 0, 0, 0 };
            self.bordercolor = { 0, 0, 0, 255 };

            self.animation = NULL;

            self.onkeydown = function()
            end;
            self.onkeyup = function()
            end;
        end

        function Component:onKeyDown(inputs)
            self.onkeydown(self, inputs);
        end

        function Component:onKeyUp(inputs)
            self.onkeyup(self, inputs);
        end

        function Component:onLoad()

        end

        function Component:show()
            self.isvisible = true;
            self:repaint();
            showSkillImageBox = false
            if removeSkillImageFuncremoveSkillImageFunc ~= nil then
                removeSkillImageFuncremoveSkillImageFunc(youAreZombie)
            end
        end

        function Component:hide()
            self.isvisible = false;
            self:repaint();
            showSkillImageBox = true
            drawSkillImageFunc(youAreZombie)
        end

        function Component:paint(graphics)
            graphics.color = self.backgroundcolor;
            graphics.opacity = self.opacity;

            graphics:drawRect(self.x, self.y, self.width, self.height);

            graphics.color = self.bordercolor;

            graphics:drawRect(self.x, self.y, self.width, self.border[1]);
            graphics:drawRect(self.x + self.width - self.border[2], self.y, self.border[2], self.height);
            graphics:drawRect(self.x, self.y + self.height - self.border[3], self.width, self.border[3]);
            graphics:drawRect(self.x, self.y, self.border[4], self.height);
        end

        function Component:repaint()
            self.layer:repaint();
        end

        function Component:animate(params, step, callback)
            local style = {};
            for i = 1, #params, 1 do
                local table = params[i].table or self;
                local key = params[i].key;
                local value = params[i].value;
                style[#style + 1] = {
                    table,
                    key,
                    (value - table[key]) / step,
                    value,
                };
            end
            if self.animation ~= NULL then
                self.animation:cancel();
            end
            self.animation = Timer:schedule(function(task)
                if step <= 1 then
                    for i = 1, #style, 1 do
                        style[i][1][style[i][2]] = style[i][4];
                    end
                    self.animation = NULL;
                    task:cancel();
                    self:repaint();
                    if callback ~= nil then
                        callback(self);
                    end
                    return ;
                end
                for i = 1, #style, 1 do
                    style[i][1][style[i][2]] = style[i][1][style[i][2]] + style[i][3];
                end
                step = step - 1;
                self:repaint();
                return false;
            end, 1, 1);
        end
    end);

    Class("Item", function(Item)
        function Item:constructor(name, value)
            self.parent = NULL;
            self.children = {};
            self.call = function()
            end;
            self.name = name;

            self:add(value);
        end

        function Item:add(value, pos)
            if type(value) == "function" then
                self.call = value;
            elseif type(value) == "table" then
                for i = 1, #value, 2 do
                    local item = _G.Item(value[i], value[i + 1]);
                    self:addItem(item, pos);
                end
            end
        end

        function Item:addItem(item, pos)
            pos = pos or #self.children + 1;
            item.parent = self;
            table.insert(self.children, pos, item);
        end

        function Item:removeItem(name)
            for i = #self.children, 1, -1 do
                if self.children[i].name == name then
                    table.remove(self.children, i);
                    return ;
                elseif #self.children[i].children ~= 0 then
                    self.children[i]:remove(name);
                end
            end
        end

        function Item:getItem(name)
            for i = 1, #self.children do
                if self.children[i].name == name then
                    return self.children[i];
                end
            end
            return nil;
        end
    end);


    --僵尸菜单

    Class("ZombieMenu", function(ZombieMenu)
        function ZombieMenu:constructor(itemTree, attributes)
            -- print("走到itemTree这里了 = ", itemTree)
            -- ZCLOG(itemTree)
            -- ZCLOG(attributes)

            self.super(30, 100, 200, 100);
            self.root = Item("ZombieMenu", itemTree);

            self.isvisible = false;

            self.page = 1;
            self.cursor = self.root;

            self.lineheight = 30;
            self.letterspacing = 3;

            self.font = Song;
            self.fontcolor = { 0, 0, 0, 255 };
            self.pixelsize = 2;

            self.hotkey = UI.KEY.M;

            if attributes ~= nil then
                for key, value in pairs(attributes) do
                    if self[key] ~= nil then
                        self[key] = value;
                    end
                end
            end
        end

        function ZombieMenu:add(...)
            self.root:add(...);
        end

        --代码呼叫
        function ZombieMenu:showHostMenu()
            self.fontcolor = { 0, 255, 0, 200 };

            -- Frame.mainLayer:remove(TheZombieMenu);
            -- Frame.mainLayer:add(TheZombieMenu);

            if self.isvisible == true then
                self:hide();
            else
                self.page = 1;
                self.cursor = self.root;
                self:show();
            end
            -- return;


        end

        --按键呼叫
        function ZombieMenu:onKeyDown(inputs)
            if inputs[self.hotkey] == true then

                self.fontcolor = { 0, 255, 0, 200 };

                if self.isvisible == true then
                    self:hide();
                else
                    self.page = 1;
                    self.cursor = self.root;
                    self:show();
                end
                return ;
            end

            if self.isvisible == true then
                local item;
                if inputs[UI.KEY.NUM1] == true then
                    item = self.cursor.children[(self.page - 1) * 7 + 1]
                    self:hide();
                elseif inputs[UI.KEY.NUM2] == true then
                    item = self.cursor.children[(self.page - 1) * 7 + 2]
                    self:hide();
                elseif inputs[UI.KEY.NUM3] == true then
                    item = self.cursor.children[(self.page - 1) * 7 + 3]
                    self:hide();
                elseif inputs[UI.KEY.NUM4] == true then
                    item = self.cursor.children[(self.page - 1) * 7 + 4]
                    self:hide();
                elseif inputs[UI.KEY.NUM5] == true then
                    item = self.cursor.children[(self.page - 1) * 7 + 5]
                    self:hide();
                elseif inputs[UI.KEY.NUM6] == true then
                    item = self.cursor.children[(self.page - 1) * 7 + 6]
                    self:hide();
                elseif inputs[UI.KEY.NUM7] == true then
                    item = self.cursor.children[(self.page - 1) * 7 + 7]
                    self:hide();
                elseif inputs[UI.KEY.NUM8] == true then
                    if self.page ~= 1 then
                        self.page = self.page - 1;
                        self:repaint();
                    end
                elseif inputs[UI.KEY.NUM9] == true then
                    if self.page * 7 < #self.cursor.children then
                        self.page = self.page + 1;
                        self:repaint();
                    end
                elseif inputs[UI.KEY.NUM0] == true then
                    if self.cursor.parent ~= NULL then
                        self.page = 1;
                        self.cursor = self.cursor.parent;
                        self:repaint();
                    end
                end
                if item ~= nil then
                    local success, result = pcall(item.call, item);
                    if not success then
                        Toast:makeText(item.name .. "执行时发生了异常");
                        self:hide();
                    end
                    if result == true then
                        self:hide();
                    end
                    if #item.children ~= 0 then
                        self.cursor = item;
                    end
                    self:repaint();
                end
            end

        end

        --渲染
        function ZombieMenu:paint(graphics)
            graphics.font = self.font;
            graphics.color = self.fontcolor;
            graphics.pixelsize = self.pixelsize;

            local __, height = self.font:getCharSize("A", self.pixelsize);
            height = height + self.lineheight;

            for i = 1, 7 do
                if self.cursor.children[(self.page - 1) * 7 + i] == nil then
                    break ;
                end
                graphics:drawText(self.x, self.y + (i * height), i .. '.' .. self.cursor.children[(self.page - 1) * 7 + i].name);
            end
            if self.page ~= 1 then
                graphics:drawText(self.x, self.y + 10 * height, "8.上一页");
            end

            if self.page * 7 < #self.cursor.children then
                graphics:drawText(self.x, self.y + 11 * height, "9.下一页");
            end

            graphics:drawText(self.x, self.y + 12 * height, "M.关闭");

        end

    end, Component);



    --菜单
    Class("ItemMenu", function(ItemMenu)
        function ItemMenu:constructor(itemTree, attributes)
            self.super(30, 100, 200, 100);

            self.root = Item("ItemMenu", itemTree);

            self.isvisible = false;

            self.page = 1;
            self.cursor = self.root;

            self.lineheight = 30;
            self.letterspacing = 3;

            self.font = Song;
            self.fontcolor = { 0, 0, 0, 255 };
            self.pixelsize = 2;

            -- self.hotkey = UI.KEY.O;

            if attributes ~= nil then
                for key, value in pairs(attributes) do
                    if self[key] ~= nil then
                        self[key] = value;
                    end
                end
            end
        end

        function ItemMenu:add(...)
            self.root:add(...);
        end

        function ItemMenu:onKeyDown(inputs)
            if inputs[self.hotkey] == true then


                if self.isvisible == true then
                    self:hide();
                else
                    self.page = 1;
                    self.cursor = self.root;
                    self:show();
                end
                return ;
            end

            if self.isvisible == true then
                local item;
                if inputs[UI.KEY.NUM1] == true then
                    item = self.cursor.children[(self.page - 1) * 6 + 1]
                elseif inputs[UI.KEY.NUM2] == true then
                    item = self.cursor.children[(self.page - 1) * 6 + 2]
                elseif inputs[UI.KEY.NUM3] == true then
                    item = self.cursor.children[(self.page - 1) * 6 + 3]
                elseif inputs[UI.KEY.NUM4] == true then
                    item = self.cursor.children[(self.page - 1) * 6 + 4]
                elseif inputs[UI.KEY.NUM5] == true then
                    item = self.cursor.children[(self.page - 1) * 6 + 5]
                elseif inputs[UI.KEY.NUM6] == true then
                    item = self.cursor.children[(self.page - 1) * 6 + 6]
                elseif inputs[UI.KEY.NUM7] == true then
                    if self.page ~= 1 then
                        self.page = self.page - 1;
                        self:repaint();
                    end
                elseif inputs[UI.KEY.NUM8] == true then
                    if self.page * 6 < #self.cursor.children then
                        self.page = self.page + 1;
                        self:repaint();
                    end
                elseif inputs[UI.KEY.NUM9] == true then
                    if self.cursor.parent ~= NULL then
                        self.page = 1;
                        self.cursor = self.cursor.parent;
                        self:repaint();
                    end
                end
                if item ~= nil then
                    local success, result = pcall(item.call, item);
                    if not success then
                        Toast:makeText(item.name .. "执行时发生了异常");
                        self:hide();
                    end
                    if result == true then
                        self:hide();
                    end
                    if #item.children ~= 0 then
                        self.cursor = item;
                    end
                    self:repaint();
                end
            end
        end

        function ItemMenu:paint(graphics)
            graphics.font = self.font;
            graphics.color = self.fontcolor;
            graphics.pixelsize = self.pixelsize;

            local __, height = self.font:getCharSize("A", self.pixelsize);
            height = height + self.lineheight;

            for i = 1, 6 do
                if self.cursor.children[(self.page - 1) * 6 + i] == nil then
                    break ;
                end
                graphics:drawText(self.x, self.y + (i * height), i .. '.' .. self.cursor.children[(self.page - 1) * 6 + i].name);
            end
            if self.page ~= 1 then
                graphics:drawText(self.x, self.y + 7 * height, "7.上一页");
            end

            if self.page * 6 < #self.cursor.children then
                graphics:drawText(self.x, self.y + 8 * height, "8.下一页");
            end

            if self.cursor.parent ~= NULL then
                graphics:drawText(self.x, self.y + 9 * height, "9.返回");
            end
        end

    end, Component);

    --僵尸菜单列表
    zombieList = {
        "普通",
        function()
            UI.Signal(SignalToGame.S_Zombie_Model_Normal)
            -- print(self.a)
        end,
        "芭比",
        function()
            UI.Signal(SignalToGame.S_Zombie_Model_Light)
        end,
        "屠夫",
        function()
            UI.Signal(SignalToGame.S_Zombie_Model_Heavy)
        end,
        "迷雾",
        function()
            UI.Signal(SignalToGame.S_Zombie_Model_Phycho)
        end,
        "巫蛊",
        function()
            UI.Signal(SignalToGame.S_Zombie_Model_Voodoo)
        end,
        "恶魔",
        function()
            UI.Signal(SignalToGame.S_Zombie_Model_Deimos)
        end,
        "猎手",
        function()
            UI.Signal(SignalToGame.S_Zombie_Model_Ganymade)
        end,
        "送葬者",
        function()
            UI.Signal(SignalToGame.S_Zombie_Model_Stamper)
        end,
        "女妖",
        function()
            UI.Signal(SignalToGame.S_Zombie_Model_Banshee)
        end,
        "禁卫",
        function()
            UI.Signal(SignalToGame.S_Zombie_Model_Venomguard)
        end,
        "女王",
        function()
            UI.Signal(SignalToGame.S_Zombie_Model_Stingfinger)
        end,
        "傀儡",
        function()
            UI.Signal(SignalToGame.S_Zombie_Model_Chaser)
        end,
        "狂魔",
        function()
            UI.Signal(SignalToGame.S_Zombie_Model_Blotter)
        end,
        "恶灵",
        function()
            UI.Signal(SignalToGame.S_Zombie_Model_Rustywing)
        end,
        "恶鬼",
        function()
            UI.Signal(SignalToGame.S_Zombie_Model_Aksha)
        end,
    }

    --僵尸菜单热键
    zombieMenuHotKey = {
        hotkey = UI.KEY.M
    }

    --僵尸菜单 TheZombieMenu
    TheZombieMenu = ZombieMenu(zombieList, zombieMenuHotKey);

    Frame.mainLayer:add(TheZombieMenu);

    --主要菜单
    MainMenu = ItemMenu(
            { "更多设置", {
                "改变颜色", function()
                    MainMenu.fontcolor = { math.random(255), math.random(255), math.random(255), 255 };
                    return false;
                end,
                "字号加大", function()
                    MainMenu.pixelsize = MainMenu.pixelsize + 1;
                    return false;
                end,
                "字号减小", function()
                    if MainMenu.pixelsize > 1 then
                        MainMenu.pixelsize = MainMenu.pixelsize - 1;
                    end
                    return false;
                end,
                "左移", function()
                    MainMenu.x = MainMenu.x - 10;
                    return false;
                end,
                "右移", function()
                    MainMenu.x = MainMenu.x + 10;
                    return false;
                end,
                "加大行距", function()
                    MainMenu.lineheight = MainMenu.lineheight + 5;
                    return false;
                end,
                "缩小行距", function()
                    MainMenu.lineheight = MainMenu.lineheight - 5;
                    return false;
                end,
                "关闭", function()
                end,
            },
              "动画效果",
              {
                  "改变颜色", function()
                  MainMenu:animate({
                      { table = MainMenu.fontcolor, key = 1, value = math.random(255) },
                      { table = MainMenu.fontcolor, key = 2, value = math.random(255) },
                      { table = MainMenu.fontcolor, key = 3, value = math.random(255) } },
                          120);
                  return false;
              end,
                  "x=300", function()
                  MainMenu:animate({
                      { key = "x", value = 300 } },
                          120);
                  return false;
              end,
                  "x=0", function()
                  MainMenu:animate({
                      { key = "x", value = 0 } },
                          120);
                  return false;
              end,
                  "行高", function()
                  MainMenu:animate({
                      { key = "lineheight", value = math.random(50) } },
                          120);
                  return false;
              end,
                  "随机字号", function()
                  local ran = math.random(2) + 1;
                  MainMenu:animate({
                      { key = "pixelsize", value = ran } },
                          80);
                  return false;
              end,
              },
              "帮助", {
                  "关于", function()
                    Toast:makeText("");
                end,
              },
            }, { hotkey = nil });

    Frame.mainLayer:add(MainMenu);


    --标签
    Class("Lable", function(Lable)
        function Lable:constructor(x, y, width, height, text, attributes)
            self.super(x, y, width, height);
            self.offx = 0;
            self.offy = 0;

            self.font = Song;
            self.pixelsize = 2;
            self.letterspacing = 5;
            self.fontcolor = { 0, 0, 0, 255 };

            self.align = "center" or "left" or "right";
            self.charArray = String:toTable(text or "");
            if attributes ~= nil then
                for key, value in pairs(attributes) do
                    if self[key] ~= nil then
                        self[key] = value;
                    end
                end
            end
        end

        function Lable:paint(graphics)
            self.super:paint(graphics);
            graphics.color = self.fontcolor;
            graphics.font = self.font;
            graphics.pixelsize = self.pixelsize;
            graphics.letterspacing = self.letterspacing;
            local w, h = self.font:getTextSize(self.charArray, self.pixelsize, self.letterspacing);

            if self.align == "center" then
                graphics:drawText(self.x + self.offx + (self.width - w) / 2, self.y + self.offy, self.charArray);
            elseif self.align == "left" then
                graphics:drawText(self.x + self.offx, self.y + self.offy, self.charArray);
            elseif self.align == "right" then
                graphics:drawText(self.x + self.offx + (self.width - w), self.y + self.offy, self.charArray);
            end
        end

        function Lable:getText()
            return table.concat(self.charArray);
        end

        function Lable:setText(text)
            self.charArray = String:toTable(text);
            self:repaint();
        end

    end, Component);

    Class("Input", function(Input)
        function Input:constructor(x, y, width, height, attributes)
            self.super(x, y, width, height);
            self.cursor = 0;
            self.maxlength = 255;
            self.intype = "all";

            self.keyprevious = UI.KEY.LEFT;
            self.keynext = UI.KEY.RIGHT;

            if attributes ~= nil then
                for key, value in pairs(attributes) do
                    if self[key] ~= nil then
                        self[key] = value;
                    end
                end
            end
        end

        function Input:onLoad()
            self.layer.keyboard:bind("_SHIFT+SPACE", function()
                self:backspace();
                self:backspace();
                self:repaint();
            end);
            self.layer.keyboard:bind("LEFT", function()
                if self.cursor > 0 then
                    self.cursor = self.cursor - 1;
                end
                self:repaint();
            end);
            self.layer.keyboard:bind("RIGHT", function()
                if self.cursor < #self.charArray then
                    self.cursor = self.cursor + 1;
                end
                self:repaint();
            end);
        end

        function Input:insert(char)
            table.insert(self.charArray, self.cursor + 1, char);
            self.cursor = self.cursor + 1;
        end

        function Input:backspace()
            if self.cursor > 0 then
                table.remove(self.charArray, self.cursor);
                self.cursor = self.cursor - 1;
            end
        end

        function Input:onKeyDown(inputs)
            self.super:onKeyDown(inputs);
            if self.isvisible == true then
                for key, value in pairs(inputs) do
                    if value == true then
                        if #self.charArray < self.maxlength then
                            if self.intype == "all" or self.intype == "number" then
                                if key >= 0 and key <= 8 then
                                    self:insert(string.char(key + 49));
                                end
                                if key == 9 then
                                    self:insert("0");
                                end
                            end
                            if self.intype == "all" or self.intype == "english" then
                                if key >= 10 and key <= 35 then
                                    self:insert(string.char(key + 87));
                                end
                                if key == 37 then
                                    self:insert(" ");
                                end
                            end
                        end
                    end
                end
                self:repaint();
            end
        end

        function Input:paint(graphics)
            self.super:paint(graphics);

            graphics.color = self.fontcolor;

            local textArray = { table.unpack(self.charArray, 1, self.cursor) };
            local w, h = self.font:getTextSize(textArray, self.pixelsize, self.letterspacing);

            if self.align == "left" then
                graphics:drawRect(self.x + w + self.offx + 1, self.y + self.offy, self.letterspacing / 3 + self.pixelsize, h);
            elseif self.align == "center" then
                local tw, th = self.font:getTextSize(self.charArray, self.pixelsize, self.letterspacing);
                graphics:drawRect(self.x + w + self.offx + (self.width - tw) / 2 + 1, self.y + self.offy, self.letterspacing / 3 + self.pixelsize, h);
            elseif self.align == "right" then
                local tw, th = self.font:getTextSize(self.charArray, self.pixelsize, self.letterspacing);
                graphics:drawRect(self.x + w + self.offx + (self.width - tw) + 1, self.y + self.offy, self.letterspacing / 3 + self.pixelsize, h);
            end
        end

    end, Lable);

    Class("Toast", function(Toast)
        Toast.STATIC = true;
        function Toast:makeText(text, length, x, y, layerName, ps)
            local layer = Layer(layerName);
            local lable = Lable(0, 0, 0, 0);

            layer:add(lable);
            layer:create();

            lable.letterspacing = 5;
            lable.font = Song;
            lable.pixelsize = ps or 2;
            lable:setText(text);

            local w, h = lable.font:getTextSize(text, lable.pixelsize, lable.letterspacing);

            lable.x = x or (UI.ScreenSize().width - w) / 2;
            lable.y = y or UI.ScreenSize().height * 0.8;
            lable.width = w + 3 * lable.pixelsize;
            lable.height = h + 3 * lable.pixelsize;

            lable.backgroundcolor = { 0, 0, 0, 255 };
            lable.opacity = 1;
            lable.fontcolor = { 255, 255, 255, 255 };
            lable:show();
            lable:animate({ { key = "opacity", value = 0 } }, length or 480, function(self)
                layer:close();
            end);
        end

        function Toast:closeToast(layerName)
            local theLayer = layerTable[layerName]
            if theLayer ~= nil then
                theLayer:close();
            end
        end

    end);

    Class("SkillMask", function(SkillMask)
        SkillMask.STATIC = true;
        function SkillMask:makeText(text, length, x, y, layerName)
            -- local layer = Layer(layerName);

            local layer = layerTable[layerName]

            if layer == nil then
                layer = Layer(layerName)
            end

            local lable = Lable(0, 0, 0, 0);

            layer:add(lable);
            layer:create();

            lable.letterspacing = 5;
            lable.font = Song;
            lable.pixelsize = 3;
            lable:setText(text);

            local w, h = lable.font:getTextSize(text, lable.pixelsize, lable.letterspacing);

            lable.x = x or (UI.ScreenSize().width - w) / 2;
            lable.y = y or UI.ScreenSize().height * 0.8;
            lable.width = w + 3 * lable.pixelsize;
            lable.height = h + 3 * lable.pixelsize;

            lable.backgroundcolor = { 0, 0, 0, 255 };
            lable.opacity = 1;
            lable.fontcolor = { 255, 255, 255, 255 };
            lable:show();
            lable:animate({ { key = "opacity", value = 0 } }, length or 480, function(self)
                layer:close();
            end);
        end

        function SkillMask:closeToast(layerName)
            local theLayer = layerTable[layerName]
            if theLayer ~= nil then
                theLayer:close();
            end
        end

    end);

    Class("Editor", function(Editor)
        function Editor:constructor(x, y, width, height)
            self.super(x, y, width, height);

            self.lines = { {} };
            self.lineCursor = 1;

            self.keyup = UI.KEY.UP;
            self.keydown = UI.KEY.DOWN;

            self.showSymbolsList = false;
            self.symbolsList = {
                { '+', '-', '*', '/', '{', '}', '[', ']', '(', ')' },
                { '<', '>', '#', '\'', '\"', ',', '.', '%', '~', '=' },
            }
            self.symbolsListPage = 1;

            self.keywords = {
                ["and"] = true,
                ["break"] = true,
                ["do"] = true,
                ["else"] = true,
                ["elseif"] = true,
                ["end"] = true,
                ["false"] = true,
                ["for"] = true,
                ["function"] = true,
                ["if"] = true,
                ["in"] = true,
                ["local"] = true,
                ["nil"] = true,
                ["not"] = true,
                ["or"] = true,
                ["repeat"] = true,
                ["return"] = true,
                ["then"] = true,
                ["true"] = true,
                ["until"] = true,
                ["while"] = true
            };
            self.symbols = {
                ["+"] = true,
                ["-"] = true,
                ["*"] = true,
                ["/"] = true,
                ["%"] = true,
                ["^"] = true,
                ["~"] = true,
                [">"] = true,
                ["<"] = true,
                ["#"] = true,
                ["("] = true,
                [")"] = true,
                ["{"] = true,
                ["}"] = true,
                ["["] = true,
                ["]"] = true,
                ["'"] = true,
                ["\""] = true,
                ["."] = true,
                [","] = true,
                ["="] = true,
            };
        end

        function Editor:onLoad()
            self.super:onLoad();
            self.layer.keyboard:bind("_SHIFT+NUM1", function()
                self:backspace();
                self:insert(self.symbolsList[self.symbolsListPage][1]);
                self:repaint();
            end);
            self.layer.keyboard:bind("_SHIFT+NUM2", function()
                self:backspace();
                self:insert(self.symbolsList[self.symbolsListPage][2]);
                self:repaint();
            end);
            self.layer.keyboard:bind("_SHIFT+NUM3", function()
                self:backspace();
                self:insert(self.symbolsList[self.symbolsListPage][3]);
                self:repaint();
            end);
            self.layer.keyboard:bind("_SHIFT+NUM4", function()
                self:backspace();
                self:insert(self.symbolsList[self.symbolsListPage][4]);
                self:repaint();
            end);
            self.layer.keyboard:bind("_SHIFT+NUM5", function()
                self:backspace();
                self:insert(self.symbolsList[self.symbolsListPage][5]);
                self:repaint();
            end);
            self.layer.keyboard:bind("_SHIFT+NUM6", function()
                self:backspace();
                self:insert(self.symbolsList[self.symbolsListPage][6]);
                self:repaint();
            end);
            self.layer.keyboard:bind("_SHIFT+NUM7", function()
                self:backspace();
                self:insert(self.symbolsList[self.symbolsListPage][7]);
                self:repaint();
            end);
            self.layer.keyboard:bind("_SHIFT+NUM8", function()
                self:backspace();
                self:insert(self.symbolsList[self.symbolsListPage][8]);
                self:repaint();
            end);
            self.layer.keyboard:bind("_SHIFT+NUM9", function()
                self:backspace();
                self:insert(self.symbolsList[self.symbolsListPage][9]);
                self:repaint();
            end);
            self.layer.keyboard:bind("_SHIFT+NUM0", function()
                self:backspace();
                self:insert(self.symbolsList[self.symbolsListPage][10]);
                self:repaint();
            end);
            self.layer.keyboard:bind("SHIFT", function()
                self.showSymbols = true;
                self:repaint();
            end);

            self.layer.keyboard:bind("shift", function()
                self.showSymbols = false;
                self:repaint();
            end);

            self.layer.keyboard:bind("_SHIFT+RIGHT", function()
                if self.symbolsListPage < #self.symbolsList then
                    self.symbolsListPage = self.symbolsListPage + 1;
                end
                self:repaint();
            end);

            self.layer.keyboard:bind("_SHIFT+LEFT", function()
                if self.symbolsListPage ~= 1 then
                    self.symbolsListPage = self.symbolsListPage - 1;
                end
                self:repaint();
            end);
        end

        function Editor:onKeyDown(inputs)
            if self.isvisible == true then
                self.lines[self.lineCursor] = self.charArray;
                if inputs[self.keyup] == true then
                    if self.lineCursor ~= 1 then
                        self.lineCursor = self.lineCursor - 1;
                        self.cursor = 0;
                    end
                elseif inputs[self.keydown] == true then
                    self.lineCursor = self.lineCursor + 1;
                    if self.lines[self.lineCursor] == nil then
                        self.lines[self.lineCursor] = {};
                    end
                    self.cursor = 0;
                end
                self.charArray = self.lines[self.lineCursor];
            end
            self.super:onKeyDown(inputs);
        end

        function Editor:paint(graphics)
            self.super.super.super:paint(graphics);
            graphics.color = self.backgroundcolor;
            graphics.color = self.fontcolor;
            graphics.pixelsize = self.pixelsize;
            graphics.letterspacing = self.letterspacing;
            local h = 0;
            for i = 1, #self.lines do
                local w = 0;
                local list = {};
                self.lines[i][#self.lines[i] + 1] = " ";
                for j = 1, #self.lines[i] do
                    if self.lines[i][j] == " " or self.symbols[self.lines[i][j]] ~= nil then
                        if self.keywords[table.concat(list)] ~= nil then
                            graphics.color = { 139, 0, 139, 255 };
                        elseif _G[table.concat(list)] ~= nil then
                            graphics.color = { 0, 128, 0, 255 };
                        end
                        w = w + graphics:drawText(self.x + w, self.y + h, list) + self.letterspacing;
                        list = {};
                        graphics.color = { 0, 0, 139, 255 };
                        w = w + graphics:drawText(self.x + w, self.y + h, self.lines[i][j]) + self.letterspacing;
                        graphics.color = self.fontcolor;
                    else
                        list[#list + 1] = self.lines[i][j];
                    end
                end
                self.lines[i][#self.lines[i]] = nil;
                h = h + 35;
            end

            if self.showSymbols == true then
                for i = 1, #self.symbolsList[self.symbolsListPage] do
                    graphics:drawNumber(100 + i * 80, 100, self.symbolsList[self.symbolsListPage][i]);

                    if i == 10 then
                        graphics:drawNumber(100 + i * 80, 180, "0");
                    else
                        graphics:drawNumber(100 + i * 80, 180, i .. "");
                    end
                end
            end
        end
    end, Input);

    Class("MessageBox", function(MessageBox)
        function MessageBox:constructor(x, y, widht, height, title, text)
            self.super(x, y, widht, height);
            self.title = title;
            self.text = text;
            self.pixelsize = 3;
        end

        function MessageBox:onKeyDown(inputs)
            if inputs[UI.KEY.MOUSE1] == true then
                self:hide();
            end
        end

        function MessageBox:paint(graphics)
            self.super:paint(graphics);
            local w = graphics.font:getTextSize(self.title, graphics.pixelsize - 1, graphics.letterspacing);
            graphics.pixelsize = self.pixelsize - 1;
            graphics:drawText(self.x + (self.width - w) / 2, self.y + 10, self.title);
            graphics.pixelsize = self.pixelsize;
            local w = graphics.font:getTextSize(self.text, graphics.pixelsize, graphics.letterspacing);
            graphics:drawText(self.x + (self.width - w) / 2, self.y + self.height / 2, self.text);
        end
    end, Component);

    Class("MessageBoxLayer", function(MessageBoxLayer)
        function MessageBoxLayer:constructor(title, text)
            self.super();
            self:create();
            self:add(MessageBox(300, 300, self.graphics.width - 600, self.graphics.height - 600, title, text));
        end

        function MessageBoxLayer:onKeyDown(inputs)
            if inputs[UI.KEY.MOUSE1] == true then
                self:close();
            end
        end
    end, Layer);

    Class("Dialog", function(Dialog)

        function Dialog:constructor(x, y, widht, height, title, text)
            self.super(x, y, widht, height);
            self.title = title;
            self.text = text;
            self.pixelsize = 3;
            self.letterspacing = 30;

            self.rect = { x, y, 0, height };
        end

        function Dialog:onKeyDown(inputs)
            if self.animation ~= NULL and inputs[UI.KEY.MOUSE1] == true then
                self.animation:cancel();
                self.rect[3] = self.width;
                self:repaint();
            end
        end

        function Dialog:onLoad()
            self:animate({ { table = self.rect, key = 3, value = 500 } }, 1000, function()

            end);
        end

        function Dialog:paint(graphics)
            self.super:paint(graphics);
            local w = graphics.font:getTextSize(self.title, graphics.pixelsize - 1, graphics.letterspacing);
            graphics.pixelsize = self.pixelsize - 1;
            graphics:drawText(self.x + (self.width - w) / 2, self.y + 10, self.title);
            graphics.pixelsize = self.pixelsize;
            local w = graphics.font:getTextSize(self.text, graphics.pixelsize, graphics.letterspacing);
            graphics:drawText(self.x + (self.width - w) / 2, self.y + self.height / 2, self.text, self.rect);
        end
    end, Component);

    Class("InputBox", function(MessageBox)
        function MessageBox:constructor(x, y, widht, height, title, text)
            self.super(x, y, widht, height);
            self.title = title;
            self.text = text;
            self.pixelsize = 3;
        end

        function MessageBox:onKeyDown(inputs)
            if inputs[UI.KEY.MOUSE1] == true then
                self:hide();
            end
        end

        function MessageBox:paint(graphics)
            self.super:paint(graphics);
            local w = graphics.font:getTextSize(self.title, graphics.pixelsize - 1, graphics.letterspacing);
            graphics.pixelsize = self.pixelsize - 1;
            graphics:drawText(self.x + (self.width - w) / 2, self.y + 10, self.title);
            graphics.pixelsize = self.pixelsize;
            local w = graphics.font:getTextSize(self.text, graphics.pixelsize, graphics.letterspacing);
            graphics:drawText(self.x + (self.width - w) / 2, self.y + self.height / 2, self.text);
        end
    end, Component);

    Class("PictureBox", function(PictureBox)
        function PictureBox:constructor(x, y, width, height, bitmap)
            self.super(x, y, width, height);
            self.bitmap = bitmap;
            self.backgroundcolor[4] = 0;
        end

        function PictureBox:paint()
            self.super:paint();
            Graphics:drawBitmap(self, self.x, self.y, self.bitmap, { self.x, self.y, self.width, self.height });
        end

    end, Component);


end


----------------------------------------------------
----------------------------------------------------
----------------------------------------------------




