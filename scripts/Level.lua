Level = {}
currentLevel = 1

-- Level 1 --
local level1 = {}
level1.introText 	= "Safe your uBoot! - Level 1"
level1.waterStart	= 10 -- Starthöhe des Wasser
level1.timeFactor 	= 3 
level1.taskGoal 	= 2 -- gesamt benötigte Tasks für nächstes Level: taskGoal*player
Level[1]  = level1

-- Level 2 --
local level2 = {}
level2.introText 	= "Radar defect, keep cool! - Level 2"
level2.waterStart 	= 25 -- Starthöhe des Wasser
level2.timeFactor 	= 2
level2.taskGoal 	= 3 -- gesamt benötigte Tasks für nächstes Level: taskGoal*player
Level[2]  = level2

-- Level 3 --
local level3 = {}
level3.introText 	= "Water in freight room, hurry up! - Level 3"
level3.waterStart 	= 40 -- Starthöhe des Wasser
level3.timeFactor 	= 1
level3.taskGoal 	= 4 -- gesamt benötigte Tasks für nächstes Level: taskGoal*player
Level[3]  = level3

-- Level 4 --
local level4 = {}
level4.introText 	= "PIRATES, GNARR! - Level 4"
level4.waterStart	= 50 -- Starthöhe des Wasser
level4.timeFactor 	= 0.9
level4.taskGoal 	= 5 -- gesamt benötigte Tasks für nächstes Level: taskGoal*player
Level[4]  = level4

-- Level 5 --
local level5 = {}
level5.introText 	= "Herbert Groenemeyer at the backdoor.. - Level 5"
level5.waterStart	= 50 -- Starthöhe des Wasser
level5.timeFactor 	= 0.9
level5.taskGoal 	= 6 -- gesamt benötigte Tasks für nächstes Level: taskGoal*player
Level[5]  = level5

-- Level 6 --
local level6 = {}
level6.introText 	= "Anblasen abblasen! - Level 6"
level6.waterStart	= 50 -- Starthöhe des Wasser
level6.timeFactor 	= 0.5
level6.taskGoal 	= 99 -- gesamt benötigte Tasks für nächstes Level: taskGoal*player
Level[6]  = level6

