Client = {}

function Client:new(uuid)
	local client = {}
	-- board
	client.board = Board:new()
	client.uuid = uuid
	-- task
	-- id
	return client
end