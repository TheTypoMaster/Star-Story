--[[
**********************************************
  
  BrainDroid.lua
  (c) Jeroen Broks, 2015, All Rights Reserved.
  
  This file contains material that is related 
  to a storyline that is which is strictly
  copyrighted to Jeroen Broks.
  
  This file may only be used in an unmodified
  form with an unmodified version of the 
  software this file belongs to.
  
  You may use this file for your study to see
  how I solved certain things in the creation
  of this project to see if you find valuable
  leads for the creation of your own.
  
  Mostly this file comes along with a project
  that is for most part released under an
  open source license and that means that if
  you use that code with this file removed
  from it, you can use it under that license.
  Please check out the other files to find out
  which license applies.
  This file comes 'as-is' and in no possible
  way the author can be held responsible of
  any form of damages that may occur due to 
  the usage of this file
  
  
 **********************************************
 
version: 15.09.14
]]


-- Version 15.09.14



Data = {
	Name = "Mother Brain",
	Desc = "This droid has control over all other droids in the region",
	ImageFile = "Boss/Brain.png",
	AI = "Default",
	Boss = true,
	Stat = {
		["Strength"] = {25,27},
		["Defense"] = {10,10},
		["Will"] = {14,15},
		["Resistance"] = {10,10},
		["Agility"] = {9,10},
		["Accuracy"] = {15,20},
		["Evasion"] = {3,4},
		["HP"] = {300,305},
		["AP"] = {0,0},
		["LevelRange"] = {20,21},
	},
	Acts = {}, -- Data itself defined below
	ActMinLevel = {}, -- Data itself defined below
	ItemDrop = {}, -- Data itself defined below
	ItemSteal = {} -- Data itself definded below
}


local temp


Data.ActMinLevel["Sys.Attack"] = 1		for ak=1,5 do table.insert(Data.Acts,"Sys.Attack") end
Data.ActMinLevel["Abl.ABL_FOE_PHOTON"] = 1		for ak=1,1 do table.insert(Data.Acts,"Abl.ABL_FOE_PHOTON") end
temp = { ITM='ITM_ADHBANDAGE', LVL=1, VLT=false }
for ak=1,10 do table.insert(Data.ItemDrop ,temp) end
for ak=1,10 do table.insert(Data.ItemSteal,temp) end
temp = { ITM='ITM_BANDAGE', LVL=5, VLT=false }
for ak=1,5 do table.insert(Data.ItemDrop ,temp) end
for ak=1,15 do table.insert(Data.ItemSteal,temp) end
temp = { ITM='ITM_VLUGZOUT', LVL=6, VLT=false }
for ak=1,5 do table.insert(Data.ItemDrop ,temp) end
for ak=1,10 do table.insert(Data.ItemSteal,temp) end


return Data
