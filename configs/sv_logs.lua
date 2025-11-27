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
            local transferred = payload.amount or payload.count or 1
            sendWebhook('drop', {
                {
                    title = 'Drop',
                    description = ('**Player Name:** `%s` \n **Discord ID:** `%s` \n **Player ID:** `%s` \n **Item Name:** `%s` \n **Count:** `x%s` \n **Metadata:** `%s` \n **Coordinates:** `%s`')
                        :format(
                            playerName,
                            playerDiscordID,
                            payload.source,
                            payload.fromSlot.name,
                            transferred,
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
            local transferred = payload.amount or payload.count or 1
            sendWebhook('pickup', {
                {
                    title = 'Pickup',
                    description = ('**Player Name:** `%s` \n **Discord ID:** `%s` \n **Player ID:** `%s` \n **Item Name:** `%s` \n **Count:** `x%s` \n **Metadata:** `%s` \n **Coordinates:** `%s`')
                        :format(
                            playerName,
                            playerDiscordID,
                            payload.source,
                            payload.fromSlot.name,
                            transferred,
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

            -- Get Discord for source
            for _, identifier in ipairs(playerIdentifiers) do
                if identifier:find("discord:") then
                    playerDiscordID = identifier:gsub("discord:", "")
                    break
                end
            end

            -- Get Discord for target
            for _, identifier in ipairs(targetIdentifiers) do
                if identifier:find("discord:") then
                    targetDiscordID = identifier:gsub("discord:", "")
                    break
                end
            end

            local playerCoords = GetEntityCoords(GetPlayerPed(payload.source))
            local targetCoords = GetEntityCoords(GetPlayerPed(targetSource))

            local transferred = payload.amount or payload.count or 1

            sendWebhook('give', {
                {
                    title = 'Transfer of items between players',
                    description = (
                        '**From Player:**\n' ..
                        'Name: `%s`\n' ..
                        'Discord: `%s`\n' ..
                        'Player ID: `%s`\n\n' ..

                        '**To Player:**\n' ..
                        'Name: `%s`\n' ..
                        'Discord: `%s`\n' ..
                        'Player ID: `%s`\n\n' ..

                        '**Item Info:**\n' ..
                        'Item Name: `%s`\n' ..
                        'Count: `x%s`\n' ..     -- <<< FIXED HERE
                        'Metadata: `%s`\n\n' ..

                        '**Coordinates:**\n' ..
                        'From Player: `%s, %s, %s`\n' ..
                        'To Player: `%s, %s, %s`'
                    ):format(
                        playerName,
                        playerDiscordID,
                        payload.source,

                        targetName,
                        targetDiscordID,
                        targetSource,

                        payload.fromSlot.name,
                        transferred, 
                        json.encode(payload.fromSlot.metadata),

                        playerCoords.x, playerCoords.y, playerCoords.z,
                        targetCoords.x, targetCoords.y, targetCoords.z
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
            local transferred = payload.amount or payload.count or 1
    
            sendWebhook('stash', {
                {
                    title = 'Stash Add Item',
                    description = ('**Player Name:** `%s` \n **Discord ID:** `%s` \n **Player ID:** `%s` \n **Item Name:** `%s` \n **Count:** `x%s` \n **Metadata:** `%s` \n **Coordinates:** `%s`')
                        :format(
                            playerName,
                            playerDiscordID,
                            payload.source,
                            payload.fromSlot.name,
                            transferred,
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
            local transferred = payload.amount or payload.count or 1
    
            sendWebhook('stash', {
                {
                    title = 'Stash Remove Item',
                    description = ('**Player Name:** `%s` \n **Discord ID:** `%s` \n **Player ID:** `%s` \n **Item Name:** `%s` \n **Count:** `x%s` \n **Metadata:** `%s` \n **Coordinates:** `%s`')
                        :format(
                            playerName,
                            playerDiscordID,
                            payload.source,
                            payload.fromSlot.name,
                            transferred,
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
            local transferred = payload.amount or payload.count or 1
    
            sendWebhook('trunk', {
                {
                    title = 'Trunk Add Item',
                    description = ('**Player Name:** `%s` \n **Discord ID:** `%s` \n **Player ID:** `%s` \n **Item Name:** `%s` \n **Count:** `x%s` \n **Metadata:** `%s` \n **Trunk ID:** `%s` \n **Coordinates:** `%s`')
                        :format(
                            playerName,
                            playerDiscordID,
                            payload.source,
                            payload.fromSlot.name,
                            transferred,
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
            local transferred = payload.amount or payload.count or 1
    
            sendWebhook('trunk', {
                {
                    title = 'Trunk Remove Item',
                    description = ('**Player Name:** `%s` \n **Discord ID:** `%s` \n **Player ID:** `%s` \n **Item Name:** `%s` \n **Count:** `x%s` \n **Metadata:** `%s` \n **Trunk ID:** `%s` \n **Coordinates:** `%s`')
                        :format(
                            playerName,
                            playerDiscordID,
                            payload.source,
                            payload.fromSlot.name,
                            transferred,
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
            local transferred = payload.amount or payload.count or 1
    
            sendWebhook('glovebox', {
                {
                    title = 'Glovebox Add Item',
                    description = ('**Player Name:** `%s` \n **Discord ID:** `%s` \n **Player ID:** `%s` \n **Item Name:** `%s` \n **Count:** `x%s` \n **Metadata:** `%s` \n **Glovebox ID:** `%s` \n **Coordinates:** `%s`')
                        :format(
                            playerName,
                            playerDiscordID,
                            payload.source,
                            payload.fromSlot.name,
                            transferred,
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
            local transferred = payload.amount or payload.count or 1
    
            sendWebhook('glovebox', {
                {
                    title = 'Glovebox Remove Item',
                    description = ('**Player Name:** `%s` \n **Discord ID:** `%s` \n **Player ID:** `%s` \n **Item Name:** `%s` \n **Count:** `x%s` \n **Metadata:** `%s` \n **Glovebox ID:** `%s` \n **Coordinates:** `%s`')
                        :format(
                            playerName,
                            playerDiscordID,
                            payload.source,
                            payload.fromSlot.name,
                            transferred,
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
