local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local mName = 'Chat'
local Module = DF:NewModule(mName, 'AceConsole-3.0')

local db, getOptions

local defaults = {
    profile = {
        scale = 1,
        x = 42,
        y = 35,
        sizeX = 460,
        sizeY = 207
    }
}
local function getDefaultStr(key)
    return ' (Default: ' .. tostring(defaults.profile[key]) .. ')'
end

local function setDefaultValues()
    for k, v in pairs(defaults.profile) do
        Module.db.profile[k] = v
    end
    Module.ApplySettings()
end

-- db[info[#info] = VALUE
local function getOption(info)
    return db[info[#info]]
end

local function setOption(info, value)
    local key = info[1]
    Module.db.profile[key] = value
    Module.ApplySettings()
end

local options = {
    type = 'group',
    name = 'DragonflightUI - 聊天框',
    get = getOption,
    set = setOption,
    args = {
        toggle = {
            type = 'toggle',
            name = '启用',
            get = function()
                return DF:GetModuleEnabled(mName)
            end,
            set = function(info, v)
                DF:SetModuleEnabled(mName, v)
            end,
            order = 1
        },
        reload = {
            type = 'execute',
            name = '/reload',
            desc = '重新加载界面',
            func = function()
                ReloadUI()
            end,
            order = 1.1
        },
        defaults = {
            type = 'execute',
            name = '默认值',
            desc = '将配置重置为默认值',
            func = setDefaultValues,
            order = 1.1
        },
        config = {
            type = 'header',
            name = '配置 - 聊天框',
            order = 100
        },
        scale = {
            type = 'range',
            name = '缩放',
            desc = '' .. getDefaultStr('scale'),
            min = 0.2,
            max = 1.5,
            bigStep = 0.025,
            order = 101,
            disabled = true
        },
        x = {
            type = 'range',
            name = 'X轴',
            desc = '相对于屏幕底部左侧的X坐标' .. getDefaultStr('x'),
            min = 0,
            max = 3500,
            bigStep = 0.50,
            order = 102
        },
        y = {
            type = 'range',
            name = 'Y轴',
            desc = '相对于屏幕底部左侧的Y坐标' .. getDefaultStr('y'),
            min = 0,
            max = 3500,
            bigStep = 0.50,
            order = 102
        },
        sizeX = {
            type = 'range',
            name = '宽度',
            desc = '聊天框宽度' .. getDefaultStr('sizeX'),
            min = 0,
            max = 1000,
            bigStep = 0.50,
            order = 103
        },
        sizeY = {
            type = 'range',
            name = '高度',
            desc = '聊天框高度' .. getDefaultStr('sizeY'),
            min = 0,
            max = 1000,
            bigStep = 0.50,
            order = 103
        }
    }
}

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)
    db = self.db.profile

    self:SetEnabledState(DF:GetModuleEnabled(mName))
    DF:RegisterModuleOptions(mName, options)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    if DF.Wrath then
        Module.Wrath()
    else
        Module.Era()
    end
    Module:ApplySettings()
end

function Module:OnDisable()
end

function Module:ApplySettings()
    db = Module.db.profile

    ChatFrame1:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', db.x, db.y)
    ChatFrame1:SetSize(db.sizeX, db.sizeY)
end

local frame = CreateFrame('FRAME', 'DragonflightUIChatFrame', UIParent)

function Module.ChangeSizeAndPosition()
    ChatFrame1:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 42, 35)
    ChatFrame1:SetSize(420 + 40, 200 + 7)
end

function frame:OnEvent(event, arg1)
    --print('event', event)
    if event == 'PLAYER_ENTERING_WORLD' then
        --Module.ChangeSizeAndPosition()
        Module:ApplySettings()
    end
end
frame:SetScript('OnEvent', frame.OnEvent)

function Module.Wrath()
    Module.ChangeSizeAndPosition()

    frame:RegisterEvent('PLAYER_ENTERING_WORLD')
end

function Module.Era()
    Module.Wrath()
end
