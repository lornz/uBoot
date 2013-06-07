_W = display.contentWidth/2
_H = display.contentHeight/2

Command = {}

function setupCommandBase(group)
	 commandBase = display.newImage("media/gfx/kommandozeile.png")
     commandBase:setReferencePoint(display.CenterReferencePoint)
     commandBase.x = _W -- huch, warum nicht _W/2 ??? irgendwas passt hier grad nicht... später - hauptsache das element wird richtig angezeigt grad
     commandBase.y = 39 --irgendwie passt der abstand so am besten
     commandBase.command = display.newText("Engage Megaquark!", 0, 0, native.systemFont, 32)
     commandBase.command:setReferencePoint(display.CenterReferencePoint)
     commandBase.command.x = commandBase.x
     commandBase.command.y = commandBase.y
     commandBase.command:setTextColor(0,255,0)
     group:insert(commandBase)
     group:insert(commandBase.command)
     return commandBase
end