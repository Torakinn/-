fx_version 'cerulean'
game 'gta5'

author 'Torakinn'
description 'QB-Core Cayo Perico Heist Script'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'locales/ja.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/CircleZone.lua',
    'client/main.lua',
    'client/hacking.lua',
    'client/zones.lua',
    'client/guards.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/callbacks.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

dependencies {
    'qb-core',
    'ox_lib',
    'ox_inventory',
    'ox_target',
    'PolyZone'
}
