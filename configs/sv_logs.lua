webhooks = {
    ['drop'] = '',
    ['pickup'] = '',
    ['give'] = '',
    ['stash'] = '',
    ['trunk'] = '',
    ['glovebox'] = '',
}
hooks = {
    ['drop'] = {
        from = 'player',
        to = 'drop',
        callback = function(payload)
            local playerName = GetPlayerName(payload.source)
            local playerIdentifiers = GetPlayerIdentifiers(payload.source)
            local playerDiscordID = 'N/A'
    
            -- Loop through identifiers to find Discord ID
            for _, identifier in ipairs(playerIdentifiers) do
                if string.find(identifier, "discord:") then
                    playerDiscordID = identifier:gsub("discord:", "") -- Remove 'discord:' prefix
                    break
                end
            end
    
            local playerCoords = GetEntityCoords(GetPlayerPed(payload.source))
            sendWebhook('drop', {
                {
                    title = 'Drop',
                    description = ('**Player Name:** `%s` \n **Discord ID:** `%s` \n **Player ID:** `%s` \n **Item Name:** `%s` \n **Count:** `x%s` \n **Metadata:** `%s` \n **Coordinates:** `%s`')
                        :format(
                            playerName,
                            playerDiscordID,
                            payload.source,
                            payload.fromSlot.name,
                            payload.fromSlot.count,
                            json.encode(payload.fromSlot.metadata),
                            ('%s, %s, %s'):format(playerCoords.x, playerCoords.y, playerCoords.z)
                        ),
                    color = 0x00ff00
                }
            })
        end
    },
    ['pickup'] = {
        from = 'drop',
        to = 'player',
        callback = function(payload)
            local playerName = GetPlayerName(payload.source)
            local playerIdentifiers = GetPlayerIdentifiers(payload.source)
            local playerDiscordID = 'N/A'
    
            -- Loop through identifiers to find Discord ID
            for _, identifier in ipairs(playerIdentifiers) do
                if string.find(identifier, "discord:") then
                    playerDiscordID = identifier:gsub("discord:", "") -- Remove 'discord:' prefix
                    break
                end
            end
    
            local playerCoords = GetEntityCoords(GetPlayerPed(payload.source))
            sendWebhook('pickup', {
                {
                    title = 'Pickup',
                    description = ('**Player Name:** `%s` \n **Discord ID:** `%s` \n **Player ID:** `%s` \n **Item Name:** `%s` \n **Count:** `x%s` \n **Metadata:** `%s` \n **Coordinates:** `%s`')
                        :format(
                            playerName,
                            playerDiscordID,
                            payload.source,
                            payload.fromSlot.name,
                            payload.fromSlot.count,
                            json.encode(payload.fromSlot.metadata),
                            ('%s, %s, %s'):format(playerCoords.x, playerCoords.y, playerCoords.z)
                        ),
                    color = 0x00ff00
                }
            })
        end
    },
    ['give'] = {
        from = 'player',
        to = 'player',
        callback = function(payload)
            if payload.fromInventory == payload.toInventory then return end
            
            local playerName = GetPlayerName(payload.source)
            local targetSource = payload.toInventory
            local targetName = GetPlayerName(targetSource)
    
            local playerIdentifiers = GetPlayerIdentifiers(payload.source)
            local targetIdentifiers = GetPlayerIdentifiers(targetSource)
    
            local playerDiscordID = 'N/A'
            local targetDiscordID = 'N/A'
    
            -- Get Discord ID for source player
            for _, identifier in ipairs(playerIdentifiers) do
                if string.find(identifier, "discord:") then
                    playerDiscordID = identifier:gsub("discord:", "")
                    break
                end
            end
    
            -- Get Discord ID for target player
            for _, identifier in ipairs(targetIdentifiers) do
                if string.find(identifier, "discord:") then
                    targetDiscordID = identifier:gsub("discord:", "")
                    break
                end
            end
    
            local playerCoords = GetEntityCoords(GetPlayerPed(payload.source))
            local targetCoords = GetEntityCoords(GetPlayerPed(targetSource))
    
            sendWebhook('give', {
                {
                    title = 'Transfer of items between players',
                    description = ('**Player Name:** `%s` \n **Discord ID:** `%s` \n **Player ID:** `%s` \n **Item Name:** `%s` \n **Count:** `x%s` \n **Metadata:** `%s` \n **Coordinates:** `%s`')
                        :format(
                            playerName,
                            playerDiscordID,
                            payload.source,
                            targetName,
                            targetDiscordID,
                            targetSource,
                            payload.fromSlot.name,
                            payload.fromSlot.count,
                            json.encode(payload.fromSlot.metadata),
                            ('%s, %s, %s'):format(playerCoords.x, playerCoords.y, playerCoords.z),
                            ('%s, %s, %s'):format(targetCoords.x, targetCoords.y, targetCoords.z)
                        ),
                    color = 0x00ff00
                }
            })
        end
    },
    
    ['stash_pick'] = {
        from = 'player',
        to = 'stash',
        callback = function(payload)
            local playerName = GetPlayerName(payload.source)
            local playerIdentifiers = GetPlayerIdentifiers(payload.source)
            local playerDiscordID = 'N/A'
    
            -- Get Discord ID
            for _, identifier in ipairs(playerIdentifiers) do
                if string.find(identifier, "discord:") then
                    playerDiscordID = identifier:gsub("discord:", "")
                    break
                end
            end
    
            local playerCoords = GetEntityCoords(GetPlayerPed(payload.source))
    
            sendWebhook('stash', {
                {
                    title = 'Stash Add Item',
                    description = ('**Player Name:** `%s` \n **Discord ID:** `%s` \n **Player ID:** `%s` \n **Item Name:** `%s` \n **Count:** `x%s` \n **Metadata:** `%s` \n **Coordinates:** `%s`')
                        :format(
                            playerName,
                            playerDiscordID,
                            payload.source,
                            payload.fromSlot.name,
                            payload.fromSlot.count,
                            json.encode(payload.fromSlot.metadata),
                            payload.toInventory,
                            ('%s, %s, %s'):format(playerCoords.x, playerCoords.y, playerCoords.z)
                        ),
                    color = 0x00ff00
                }
            })
        end
    },
    
    ['stash'] = {
        from = 'stash',
        to = 'player',
        callback = function(payload)
            local playerName = GetPlayerName(payload.source)
            local playerIdentifiers = GetPlayerIdentifiers(payload.source)
            local playerDiscordID = 'N/A'
    
            -- Get Discord ID
            for _, identifier in ipairs(playerIdentifiers) do
                if string.find(identifier, "discord:") then
                    playerDiscordID = identifier:gsub("discord:", "")
                    break
                end
            end
    
            local playerCoords = GetEntityCoords(GetPlayerPed(payload.source))
    
            sendWebhook('stash', {
                {
                    title = 'Stash Remove Item',
                    description = ('**Player Name:** `%s` \n **Discord ID:** `%s` \n **Player ID:** `%s` \n **Item Name:** `%s` \n **Count:** `x%s` \n **Metadata:** `%s` \n **Coordinates:** `%s`')
                        :format(
                            playerName,
                            playerDiscordID,
                            payload.source,
                            payload.fromSlot.name,
                            payload.fromSlot.count,
                            json.encode(payload.fromSlot.metadata),
                            payload.fromInventory,
                            ('%s, %s, %s'):format(playerCoords.x, playerCoords.y, playerCoords.z)
                        ),
                    color = 0x00ff00
                }
            })
        end
    },
    
    ['trunk_add'] = {
        from = 'player',
        to = 'trunk',
        callback = function(payload)
            local playerName = GetPlayerName(payload.source)
            local playerIdentifiers = GetPlayerIdentifiers(payload.source)
            local playerDiscordID = 'N/A'
    
            -- Get Discord ID
            for _, identifier in ipairs(playerIdentifiers) do
                if string.find(identifier, "discord:") then
                    playerDiscordID = identifier:gsub("discord:", "")
                    break
                end
            end
    
            local playerCoords = GetEntityCoords(GetPlayerPed(payload.source))
    
            sendWebhook('trunk', {
                {
                    title = 'Trunk Add Item',
                    description = ('**Player Name:** `%s` \n **Discord ID:** `%s` \n **Player ID:** `%s` \n **Item Name:** `%s` \n **Count:** `x%s` \n **Metadata:** `%s` \n **Trunk ID:** `%s` \n **Coordinates:** `%s`')
                        :format(
                            playerName,
                            playerDiscordID,
                            payload.source,
                            payload.fromSlot.name,
                            payload.fromSlot.count,
                            json.encode(payload.fromSlot.metadata),
                            payload.toInventory,
                            ('%s, %s, %s'):format(playerCoords.x, playerCoords.y, playerCoords.z)
                        ),
                    color = 0x00ff00
                }
            })
        end
    },
    
    ['trunk_remove'] = {
        from = 'trunk',
        to = 'player',
        callback = function(payload)
            local playerName = GetPlayerName(payload.source)
            local playerIdentifiers = GetPlayerIdentifiers(payload.source)
            local playerDiscordID = 'N/A'
    
            -- Get Discord ID
            for _, identifier in ipairs(playerIdentifiers) do
                if string.find(identifier, "discord:") then
                    playerDiscordID = identifier:gsub("discord:", "")
                    break
                end
            end
    
            local playerCoords = GetEntityCoords(GetPlayerPed(payload.source))
    
            sendWebhook('trunk', {
                {
                    title = 'Trunk Remove Item',
                    description = ('**Player Name:** `%s` \n **Discord ID:** `%s` \n **Player ID:** `%s` \n **Item Name:** `%s` \n **Count:** `x%s` \n **Metadata:** `%s` \n **Trunk ID:** `%s` \n **Coordinates:** `%s`')
                        :format(
                            playerName,
                            playerDiscordID,
                            payload.source,
                            payload.fromSlot.name,
                            payload.fromSlot.count,
                            json.encode(payload.fromSlot.metadata),
                            payload.fromInventory,
                            ('%s, %s, %s'):format(playerCoords.x, playerCoords.y, playerCoords.z)
                        ),
                    color = 0x00ff00
                }
            })
        end
    },
    
    ['add'] = {
        from = 'player',
        to = 'glovebox',
        callback = function(payload)
            local playerName = GetPlayerName(payload.source)
            local playerIdentifiers = GetPlayerIdentifiers(payload.source)
            local playerDiscordID = 'N/A'
    
            -- Get Discord ID
            for _, identifier in ipairs(playerIdentifiers) do
                if string.find(identifier, "discord:") then
                    playerDiscordID = identifier:gsub("discord:", "")
                    break
                end
            end
    
            local playerCoords = GetEntityCoords(GetPlayerPed(payload.source))
    
            sendWebhook('glovebox', {
                {
                    title = 'Glovebox Add Item',
                    description = ('**Player Name:** `%s` \n **Discord ID:** `%s` \n **Player ID:** `%s` \n **Item Name:** `%s` \n **Count:** `x%s` \n **Metadata:** `%s` \n **Glovebox ID:** `%s` \n **Coordinates:** `%s`')
                        :format(
                            playerName,
                            playerDiscordID,
                            payload.source,
                            payload.fromSlot.name,
                            payload.fromSlot.count,
                            json.encode(payload.fromSlot.metadata),
                            payload.toInventory,
                            ('%s, %s, %s'):format(playerCoords.x, playerCoords.y, playerCoords.z)
                        ),
                    color = 0x00ff00
                }
            })
        end
    },
    
    ['glovebox_remove'] = {
        from = 'glovebox',
        to = 'player',
        callback = function(payload)
            local playerName = GetPlayerName(payload.source)
            local playerIdentifiers = GetPlayerIdentifiers(payload.source)
            local playerDiscordID = 'N/A'
    
            -- Get Discord ID
            for _, identifier in ipairs(playerIdentifiers) do
                if string.find(identifier, "discord:") then
                    playerDiscordID = identifier:gsub("discord:", "")
                    break
                end
            end
    
            local playerCoords = GetEntityCoords(GetPlayerPed(payload.source))
    
            sendWebhook('glovebox', {
                {
                    title = 'Glovebox Remove Item',
                    description = ('**Player Name:** `%s` \n **Discord ID:** `%s` \n **Player ID:** `%s` \n **Item Name:** `%s` \n **Count:** `x%s` \n **Metadata:** `%s` \n **Glovebox ID:** `%s` \n **Coordinates:** `%s`')
                        :format(
                            playerName,
                            playerDiscordID,
                            payload.source,
                            payload.fromSlot.name,
                            payload.fromSlot.count,
                            json.encode(payload.fromSlot.metadata),
                            payload.fromInventory,
                            ('%s, %s, %s'):format(playerCoords.x, playerCoords.y, playerCoords.z)
                        ),
                    color = 0x00ff00
                }
            })
        end
    },            
}
