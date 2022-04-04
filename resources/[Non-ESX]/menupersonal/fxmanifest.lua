fx_version 'adamant'
games { 'gta5' };


client_scripts {
    "rui/RMenu.lua",
    "rui/menu/RageUI.lua",
    "rui/menu/Menu.lua",
    "rui/menu/MenuController.lua",

    "rui/components/*.lua",

    "rui/menu/elements/*.lua",

    "rui/menu/items/*.lua",

}

client_scripts {
    '@es_extended/locale.lua',
    'fr.lua',
    'config.lua',
    'cl/cl_personal.lua',
    'cl/function.lua'
    }

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'fr.lua',
	'config.lua',
	'sv/sv_personal.lua'
}

dependency 'es_extended'