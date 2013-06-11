Level = {}

-- Level 1 --
local level1 = {}
level1.introText 	= "Safe your uBoot! - Level 1"
level1.timeFactor 	= 3 
level1.taskGoal 	= 2 -- gesamt benötigte Tasks für nächstes Level: taskGoal*player
Level[1]  = level1

-- Level 2 --
local level2 = {}
level2.introText 	= "Radar defect, keep cool! - Level 2"
level2.timeFactor 	= 1
level2.taskGoal 	= 3 -- gesamt benötigte Tasks für nächstes Level: taskGoal*player
Level[2]  = level2

-- Level 3 --
local level3 = {}
level3.introText 	= "Water in freight room, hurry up! - Level 3"
level3.timeFactor 	= 0.5
level3.taskGoal 	= 5 -- gesamt benötigte Tasks für nächstes Level: taskGoal*player
Level[3]  = level3

-- Level 4 --
local level4 = {}
level4.introText 	= "PIRATES, GNARR! - Level 4"
level4.timeFactor 	= 0.5
level4.taskGoal 	= 99 -- gesamt benötigte Tasks für nächstes Level: taskGoal*player
Level[4]  = level4

currentLevel = 1