Client = {}

function Client:new(uuid)
	local client = {}
	-- board
	client.board = Board:new()
	client.uuid = uuid
	-- task
	-- id
	Client[uuid] = client
		return client
end