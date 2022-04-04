fx_version 'adamant'

game 'gta5'

description 'ESX Service'

version 'legacy'

shared_script '@es_extended/imports.lua'

server_scripts {
	'@async/async.lua',
	'@es_extended/imports.lua',
	'@mysql-async/lib/MySQL.lua',
	'service/server.lua',
	'license/server.lua',
	'datastore/classes/datastore.lua',
	'datastore/main.lua',
	'addoninventory/classes/addoninventory.lua',
	'addoninventory/main.lua',
	'addonaccount/classes/addonaccount.lua',
	'addonaccount/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'service/client.lua',
	'scripts/client.lua'
}

dependency 'es_extended'