require ("pubnub")

multiplayer = pubnub.new({
    publish_key   = "pub-c-0a08fcd9-9f7f-4d08-8d4e-2268d802db02",
    subscribe_key = "sub-c-2ad01006-cc6b-11e2-ba80-02ee2ddab7fe",
    secret_key    = "sec-c-ZmE0YWFjYTUtMzg0My00NWNiLWIwYTUtNDllM2VjN2U3M2M5",
    ssl           = nil,
    origin        = "pubsub.pubnub.com"
})


local player = {}
local partnerNumber = 1
local function addPlayer(partnerID)
	if (player[partnerID] == nil) then
		player[partnerID] = { partnerID = partnerID, partnerNumber = partnerNumber}
		partnerNumber = partnerNumber + 1
		print("partner added")
	else
		print("partner already in list")
	end
end

local function receiveMessage(content,mode,senderUUID)
    	-- Eigene Nachrichten ignorieren
    	print("message: "..content)
    	--print("message mode: "..mode)
    	if (mode == "connect") then
    		if(content == "ping") then
    			sendStuff("pong","connect",gameChannel)
    			addPlayer(senderUUID)
    		elseif(content == "pong") then
    			addPlayer(senderUUID)
    		end
    	end
end

function subscribe(channel)
    multiplayer:subscribe({
        channel = channel,
        connect = function()
            print("Connected to ".. channel)
            uuid = multiplayer:UUID()

            sendStuff("ping","connect",gameChannel)
        end,
        callback = function(message)
        	-- message received -> do something
        	if not (message.uuid == uuid) then
        		-- eigene Nachrichten ignorieren
        		receiveMessage(message.content,message.mode,message.uuid)
        	end
        end,
        errorback = function()
            print("Network Connection Lost")
        end
    })
end

function sendStuff(content,mode,channel)
	multiplayer:publish({
	    channel  = channel,
	    message  = { content = content, mode = mode, uuid = uuid,},
	    callback = function(info)
	        -- WAS MESSAGE DELIVERED?
	        if info[1] then
	            --print("MESSAGE DELIVERED SUCCESSFULLY!")
	        else
	            print("MESSAGE FAILED BECAUSE -> " .. info[2])
	        end
	    end
	})
end