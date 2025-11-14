local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

local moduleOptions = {}
local options = {
    type = 'group',
    args = {
        general = {
            type = 'group',
            inline = true,
            name = '通用选项',
            args = {
                unlock = {
                    type = 'execute',
                    name = '无操作',
                    desc = '无任何操作',
                    func = function()
                        DF:Print('不要按我，我什么都不做！')
                    end,
                    order = 69
                }
            }
        }
    }
}

function DF:SetupOptions()
    self.optFrames = {}
    
    -- Register main options
    LibStub('AceConfigRegistry-3.0'):RegisterOptionsTable('DragonflightUI', options)
    self.optFrames['DragonflightUI'] = 
        LibStub('AceConfigDialog-3.0'):AddToBlizOptions('DragonflightUI', 'DragonflightUI')
    
    -- Register profiles options separately
    local profiles = LibStub('AceDBOptions-3.0'):GetOptionsTable(self.db)
    profiles.order = 666
    profiles.name = "配置文件"  -- Explicitly set name to Chinese
    LibStub('AceConfigRegistry-3.0'):RegisterOptionsTable('DragonflightUI_Profiles', profiles)
    self.optFrames['DragonflightUI_Profiles'] = 
        LibStub('AceConfigDialog-3.0'):AddToBlizOptions('DragonflightUI_Profiles', '配置文件', 'DragonflightUI')
end

-- 模块名称翻译表
local moduleTranslations = {
    ['Actionbar'] = '动作条',
    ['Castbar'] = '施法条',
    ['Chat'] = '聊天',
    ['Minimap'] = '小地图',
    ['Unitframe'] = '单位框体',
    ['Professions'] = '专业'
}

function DF:RegisterModuleOptions(name, options)
    --self:Print('RegisterModuleOptions()', name, options)
    moduleOptions[name] = options
    -- function AceConfigDialog:AddToBlizOptions(appName, name, parent, ...)
    LibStub('AceConfigRegistry-3.0'):RegisterOptionsTable('DragonflightUI_' .. name, options)

    local translatedName = moduleTranslations[name] or name
    self.optFrames[name] = 
        LibStub('AceConfigDialog-3.0'):AddToBlizOptions('DragonflightUI_' .. name, translatedName, 'DragonflightUI')
end

function DF:RegisterSlashCommands()
    self:RegisterChatCommand('df', 'SlashCommand')
    self:RegisterChatCommand('dragonflight', 'SlashCommand')
end

function DF:SlashCommand(msg)
    --self:Print('Slash: ' .. msg)
    InterfaceOptionsFrame_OpenToCategory('DragonflightUI')
    InterfaceOptionsFrame_OpenToCategory('DragonflightUI')
end
