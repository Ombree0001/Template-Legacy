local NykxxxMenuPerso = {
  Accessories = {'oreille', 'lunette', 'casque', 'masque'},
  Clothes = {'torso', 'pants', 'shoes', 'bag', 'bproof', 'watches'},
  Filtres = {'normal', 'améliorees', 'amplifiees', 'noir/blanc'},
  fctr = {},
  ItemSlct = {},
  ItemIndex = {},
}

local NykxxIndex = {
  actionjob = 1,
  actiongrade = 1,
  checkbox = false,
  heritage = 0.5,
  slider = 50,
  list1 = 1,
  list2 = 1,
  list3 = 1,
  listinventory = 1,
  listitle = 1,
  descolor = "~r~Avertissement SYSTEM ~s~!\n\nSi vous supprimer votre Cache FiveM vous risque de devoirs reconfigurer la Couleur ."
}


local colors = {0, 128, 255},

print("NykxxxMenuPerso is ^2ON")

-- Menu
RMenu.Add('nPersonal', 'main', RageUI.CreateMenu("Menu Personnel", "~b~Menu ~w~Personnel"))

-- inventaire
RMenu.Add('nPersonal', 'inventaire', RageUI.CreateSubMenu(RMenu:Get('nPersonal', 'main'), "Inventaire", "Inventaire"))

-- Portefeuille
RMenu.Add('nPersonal', 'portefeuille', RageUI.CreateSubMenu(RMenu:Get('nPersonal', 'main'), "Portefeuille", "Portefeuille"))
RMenu.Add('nPersonal', 'money/job', RageUI.CreateSubMenu(RMenu:Get('nPersonal', 'main'), "Argent/Metiers", "Argent / Metiers"))

-- Vetements / Accessoires 
RMenu.Add('nPersonal', 'clothesbase', RageUI.CreateSubMenu(RMenu:Get('nPersonal', 'main'), "Tenue", "Vêtements / Accessoire"))
RMenu.Add('nPersonal', 'clothes', RageUI.CreateSubMenu(RMenu:Get('nPersonal', 'main'), "Vêtements", "Vêtements"))
RMenu.Add('nPersonal', 'accessories', RageUI.CreateSubMenu(RMenu:Get('nPersonal', 'main'), "Accessoire", "Accessoire"))

-- Facture
RMenu.Add('nPersonal', 'bill', RageUI.CreateSubMenu(RMenu:Get('nPersonal', 'main'), "Facture", "Facture impayée"))

-- Divers
RMenu.Add('nPersonal', 'divers', RageUI.CreateSubMenu(RMenu:Get('nPersonal', 'main'), "Menu Divers", "Divers"))
RMenu.Add('nPersonal', 'filtre', RageUI.CreateSubMenu(RMenu:Get('nPersonal', 'main'), "Filtres", "Divers"))

RMenu.Add('nPersonal', 'colors', RageUI.CreateSubMenu(RMenu:Get('nPersonal', 'main'), "Couleurs Menu", "Couleurs"))

Citizen.CreateThread(function()
    while (true) do
        Citizen.Wait(1.0)
        if IsControlJustPressed(0,318) then
        RageUI.Visible(RMenu:Get('nPersonal', 'main'), not RageUI.Visible(RMenu:Get('nPersonal', 'main')))
        end

        RageUI.IsVisible(RMenu:Get('nPersonal', 'main'), function()

        RageUI.Button(_U('inventaire_titre'), nil, { RightLabel = "→→" }, true, {
        }, RMenu:Get("nPersonal", "inventaire"))
        RageUI.Button(_U('portefeuille_titre'), nil, { RightLabel = "→→" }, true, {
				}, RMenu:Get("nPersonal", "portefeuille"))
				RageUI.Button(_U('clothes'), nil, { RightLabel = "→→" }, true, {
        }, RMenu:Get("nPersonal", "clothesbase"))
        RageUI.Button(_U('divers'), nil, { RightLabel = "→→" }, true, {
        }, RMenu:Get("nPersonal", "divers"))
  end)
    
    RageUI.IsVisible(RMenu:Get('nPersonal', 'inventaire'), function()
      ESX.PlayerData = ESX.GetPlayerData()
      local elements, currentWeight = {}, 0
      local playerPed = PlayerPedId()
      for k,v in ipairs(ESX.PlayerData.inventory) do
        if v.count > 0 then
          currentWeight = currentWeight + (v.weight * v.count)
          table.insert(elements, {
            label = ('%s x%s'):format(v.label, v.count),
            count = v.count,
            type = 'item_standard',
            value = v.name,
            usable = v.usable,
            rare = v.rare,
            canRemove = v.canRemove
          })
    end
  end
  RageUI.Nykxx(_U('inventaire_poids', currentWeight, ESX.PlayerData.maxWeight), nil, {}, true, {
  })
      for i = 1, #ESX.PlayerData.inventory, 1 do
        if ESX.PlayerData.inventory[i].count > 0 then
          local invCount = {}
  
          for i = 1, ESX.PlayerData.inventory[i].count, 1 do
            table.insert(invCount, i)
          end

          RageUI.List(ESX.PlayerData.inventory[i].label .. ' [~b~' .. ESX.PlayerData.inventory[i].count .. '~s~]', {
            { Name = "Utilliser", Value = 1 },
            { Name = "Donner", Value = 2 },
          }, NykxxIndex.listinventory, nil, {}, true, {
            onListChange = function(Index, Item)
              NykxxIndex.listinventory = Index;
            end,
            onSelected = function(Index, Item)
              NykxxxMenuPerso.ItemSlct = ESX.PlayerData.inventory[i]
              NykxxxMenuPerso.ItemIndex[ESX.PlayerData.inventory[i].name] = Index
              NykxxIndex.listinventory = Index;

              if Index == 1 then
                if NykxxxMenuPerso.ItemSlct.usable then
                  TriggerServerEvent('esx:useItem', NykxxxMenuPerso.ItemSlct.name)
                else
                  ESX.ShowNotification(_U('non_utilisable', NykxxxMenuPerso.ItemSlct.label))
                end
             elseif Index == 2 then
              local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestDistance ~= -1 and closestDistance <= 3 then
						local closestPed = GetPlayerPed(closestPlayer)

						if IsPedOnFoot(closestPed) then
							if NykxxxMenuPerso.ItemIndex[NykxxxMenuPerso.ItemSlct.name] ~= nil and NykxxxMenuPerso.ItemSlct.count > 0 then
								TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_standard', NykxxxMenuPerso.ItemSlct.name, NykxxxMenuPerso.ItemIndex[NykxxxMenuPerso.ItemSlct.name])
								RageUI.CloseAll()
							else
								ESX.ShowNotification(_U('amount_invalid'))
							end
						else
							ESX.ShowNotification(_U('donner_vehicule', NykxxxMenuPerso.ItemSlct.label))
						end
					else
            ESX.ShowNotification(_U('players_nearby'))
          end
        end

            end,
          })
        end
      end
        end)

    RageUI.IsVisible(RMenu:Get('nPersonal', 'clothesbase'), function()
      RageUI.Button(_U('clothes'), nil, { RightLabel = "→" }, true, {
      }, RMenu:Get("nPersonal", "clothes"))
      RageUI.Button(_U('accessories'), nil, { RightLabel = "→" }, true, {
      }, RMenu:Get("nPersonal", "accessories"))
    end)

    RageUI.IsVisible(RMenu:Get('nPersonal', 'clothes'), function()
      for i = 1, #NykxxxMenuPerso.Clothes, 1 do
				RageUI.Button(_U(('clothes_%s'):format(NykxxxMenuPerso.Clothes[i])), nil, {}, true, {
					onSelected = function()
            vetements(NykxxxMenuPerso.Clothes[i], plyPed)
          end,
				})
         end
    end)
      RageUI.IsVisible(RMenu:Get('nPersonal', 'accessories'), function()
        for i = 1, #NykxxxMenuPerso.Accessories, 1 do
				RageUI.Button(_U(('accessories_%s'):format(NykxxxMenuPerso.Accessories[i])), nil, {}, true, {
					onSelected = function()
						accessories(NykxxxMenuPerso.Accessories[i], plyPed)
					end,
				})
         end
    end)

    RageUI.IsVisible(RMenu:Get('nPersonal', 'portefeuille'), function()
      RageUI.Button(_U('money/jobs'), nil, { RightLabel = "→" }, true, {
      }, RMenu:Get("nPersonal", "money/job"))
      RageUI.Button(_U('bills'), nil, { RightLabel = "→" }, true, {
      }, RMenu:Get("nPersonal", "bill"))
      
      RageUI.List('Carte d\'identité', {
        { Name = "Regarder", Value = 1 },
        { Name = "Montrer", Value = 2 },
    }, NykxxIndex.list1, nil, {}, true, {
        onListChange = function(Index, Item)
          NykxxIndex.list1 = Index;
        end,
        onSelected = function(Index, Item)
          NykxxIndex.list1 = Index;
          if Index == 1 then
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))

          elseif Index == 2 then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestDistance ~= -1 and closestDistance <= 3.0 then
						TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
					else
						ESX.ShowNotification(_U('players_nearby'))
          end
        end
        end,
    })

    RageUI.List('Permis de conduire', {
      { Name = "Regarder", Value = 1 },
      { Name = "Montrer", Value = 2 },
  }, NykxxIndex.list2, nil, {}, true, {
      onListChange = function(Index, Item)
        NykxxIndex.list2 = Index;
      end,
      onSelected = function(Index, Item)
        NykxxIndex.list2 = Index;
        if Index == 1 then
          TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')

        elseif Index == 2 then
          local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

        if closestDistance ~= -1 and closestDistance <= 3.0 then
          TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'driver')
        else
          ESX.ShowNotification(_U('players_nearby'))
        end
      end
      end,
  })

  RageUI.List('Permis de Port d\'arme', {
    { Name = "Regarder", Value = 1 },
    { Name = "Montrer", Value = 2 },
}, NykxxIndex.list3, nil, {}, true, {
    onListChange = function(Index, Item)
      NykxxIndex.list3 = Index;
    end,
    onSelected = function(Index, Item)
      NykxxIndex.list3 = Index;
      if Index == 1 then
        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')

      elseif Index == 2 then
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

      if closestDistance ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'weapon')
      else
        ESX.ShowNotification(_U('players_nearby'))
      end
    end
    end,
})
    end)
    
      RageUI.IsVisible(RMenu:Get('nPersonal', 'bill'), function()
        for i = 1, #NykxxxMenuPerso.fctr, 1 do
          RageUI.Button(NykxxxMenuPerso.fctr[i].label, nil, {RightLabel = '$' .. ESX.Math.GroupDigits(NykxxxMenuPerso.fctr[i].amount)}, true, {
            onSelected = function()
              ESX.TriggerServerCallback('esx_billing:payBill', function()
                ESX.TriggerServerCallback('Nykxx:billing', function(bills) NykxxxMenuPerso.fctr = bills end)
              end, NykxxxMenuPerso.fctr[i].id)
            end,
          })
           end
        end)

RageUI.IsVisible(RMenu:Get('nPersonal', 'divers'), function()
  RageUI.Button(_U('filtre'), nil, { RightLabel = "→" }, true, {
  }, RMenu:Get("nPersonal", "filtre"))
  RageUI.Button(_U('colors'), nil, { RightLabel = "→" }, true, {
  }, RMenu:Get("nPersonal", "colors"))
  RageUI.List('Titre Style', {
    { Name = "Normal", Value = 1 },
    { Name = "GTA", Value = 2 },
    { Name = "Classique", Value = 3 },
}, NykxxIndex.listitle, nil, {}, true, {
    onListChange = function(Index, Item)
      NykxxIndex.listitle = Index;
      if Index == 1 then
        for name, menu in pairs(RMenu['nPersonal']) do
          RMenu:Get('nPersonal', name).TitleFont = 1
      end
      end
      if Index == 2 then
        for name, menu in pairs(RMenu['nPersonal']) do
          RMenu:Get('nPersonal', name).TitleFont = 7
      end
      end
      if Index == 3 then
        for name, menu in pairs(RMenu['nPersonal']) do
          RMenu:Get('nPersonal', name).TitleFont = 4
      end
      end
    end,
    onSelected = function(Index, Item)
      NykxxIndex.listitle = Index;
    end,
})

RageUI.UISliderHeritage('Taille Titre', NykxxIndex.heritage, nil, {
  onSliderChange = function(Float, Index)
    NykxxIndex.heritage = Index;
    for name, menu in pairs(RMenu['nPersonal']) do
      RMenu:Get('nPersonal', name).TitleScale = Float
    end
  end,
})
end)

RageUI.IsVisible(RMenu:Get('nPersonal', 'filtre'), function()
  for i = 1, #NykxxxMenuPerso.Filtres, 1 do
    RageUI.Button(_U(('filtre_%s'):format(NykxxxMenuPerso.Filtres[i])), nil, {}, true, {
      onSelected = function()
        Filtres(NykxxxMenuPerso.Filtres[i], plyPed)
      end,
    })
     end
end)

RageUI.IsVisible(RMenu:Get('nPersonal', 'colors'), function()

RageUI.SliderProgress('Red = [~r~R~s~]', colors[1], 255, nil, {
  ProgressBackgroundColor = { R = 255, G = 255, B = 255, A = 255 },
  ProgressColor = { R = 255, G = 0, B = 0, A = 0.8 },
}, true, {
  onSliderChange = function(Index)
    colors[1] = Index
    colors[1] = Index
    for name, menu in pairs(RMenu['nPersonal']) do
      RMenu:Get('nPersonal', name):SetRectangleBanner(colors[1], colors[2], colors[3], 255)
  end
  end,
})
RageUI.SliderProgress('Green = [~g~G~s~]', colors[2], 255, nil, {
  ProgressBackgroundColor = { R = 255, G = 255, B = 255, A = 255 },
  ProgressColor = { R = 0, G = 255, B = 0, A = 255 },
}, true, {
  onSliderChange = function(Index)
    colors[2] = Index
    colors[2] = Index
    for name, menu in pairs(RMenu['nPersonal']) do
      RMenu:Get('nPersonal', name):SetRectangleBanner(colors[1], colors[2], colors[3], 255)
  end
  end,
})

RageUI.SliderProgress('Blue = [~b~B~s~]', colors[3], 255, nil, {
  ProgressBackgroundColor = { R = 255, G = 255, B = 255, A = 255 },
  ProgressColor = { R = 0, G = 0, B = 255, A = 0.8 },
}, true, {
  onSliderChange = function(Index)
    colors[3] = Index
    colors[3] = Index
    for name, menu in pairs(RMenu['nPersonal']) do
      RMenu:Get('nPersonal', name):SetRectangleBanner(colors[1], colors[2], colors[3], 255)
  end
  end,
})

RageUI.Button('Enregistrer la Couleur', NykxxIndex.descolor, {}, true, {
  onSelected = function()
    SetResourceKvpInt("colorRED", colors[1])
    SetResourceKvpInt("colorGREEN", colors[2])
    SetResourceKvpInt("colorBLUE", colors[3])
  end,
})
end)

    RageUI.IsVisible(RMenu:Get('nPersonal', 'money/job'), function()
      RageUI.Button(_U('portefeuille_job_b', ESX.PlayerData.job.label, ESX.PlayerData.job.grade_label), nil, {}, true, {
      })
      for i = 1, #ESX.PlayerData.accounts, 1 do
       if ESX.PlayerData.accounts[i].name == 'money' then
      RageUI.Button(_U('cash', ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money)), nil, {}, true, {
      })
      for i = 1, #ESX.PlayerData.accounts, 1 do
        if ESX.PlayerData.accounts[i].name == 'black_money' then
      RageUI.Button(_U('cash_sale', ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money)), nil, {}, true, {
      })
    end
  end
end
end
end)
end
end)

AddEventHandler('playerSpawned', function()
	colors[1]  = GetResourceKvpInt("colorRED")
	colors[2]  = GetResourceKvpInt("colorGREEN")
	colors[3]  = GetResourceKvpInt("colorBLUE")
	for name, menu in pairs(RMenu['nPersonal']) do
	  RMenu:Get('nPersonal', name):SetPageCounter("")
  end
  
  if not colors[1] or not colors[2] or not colors[3] then
	  for name, menu in pairs(RMenu['nPersonal']) do
		  RMenu:Get('nPersonal', name):SetRectangleBanner(0, 128, 255, 255)
	  end
  else
	  for name, menu in pairs(RMenu['nPersonal']) do
		  RMenu:Get('nPersonal', name):SetRectangleBanner(colors[1], colors[2], colors[3], 255)
	  end
  end
  end)