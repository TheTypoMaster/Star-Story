--[[
**********************************************
  
  Cyborg Gunner.lua
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
	Name = "Cyborg Gunner",
	Desc = "An expert with a photon gun.",
	ImageFile = "Reg/Cyborg Gunner.png",
	AI = "Default",
	Stat = {
		["Strength"] = {24,30},
		["Defense"] = {18,20},
		["Will"] = {19,40},
		["Resistance"] = {17,80},
		["Agility"] = {10,15},
		["Accuracy"] = {14,20},
		["Evasion"] = {3,5},
		["HP"] = {65,70},
		["AP"] = {20,25},
		["LevelRange"] = {5,10},
	},
	Acts = {}, -- Data itself defined below
	ActMinLevel = {}, -- Data itself defined below
	ItemDrop = {}, -- Data itself defined below
	ItemSteal = {} -- Data itself definded below
}


local temp


Data.ActMinLevel["Abl.ABL_FOE_PHOTON"] = 0		for ak=1,100 do table.insert(Data.Acts,"Abl.ABL_FOE_PHOTON") end
temp = { ITM='ITM_ADHBANDAGE', LVL=1, VLT=false }
for ak=1,1 do table.insert(Data.ItemDrop ,temp) end
for ak=1,1 do table.insert(Data.ItemSteal,temp) end
temp = { ITM='ITM_BANDAGE', LVL=6, VLT=false }
for ak=1,6 do table.insert(Data.ItemDrop ,temp) end
for ak=1,6 do table.insert(Data.ItemSteal,temp) end
temp = { ITM='ITM_HEALINGCAPSULE', LVL=8, VLT=false }
for ak=1,8 do table.insert(Data.ItemDrop ,temp) end
for ak=1,8 do table.insert(Data.ItemSteal,temp) end
temp = { ITM='ITM_VLUGZOUT', LVL=2, VLT=false }
for ak=1,6 do table.insert(Data.ItemDrop ,temp) end
for ak=1,4 do table.insert(Data.ItemSteal,temp) end


return Data
