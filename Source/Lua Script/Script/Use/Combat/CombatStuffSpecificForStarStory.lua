--[[
**********************************************
  
  CombatStuffSpecificForStarStory.lua
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
 
version: 15.09.16
]]
-- @IF IGNORE
VicCheck = {}
-- @FI

function UpPoint(i,amount)
if not Fighters.Hero[i] then return end
local f = FighterTag("Hero",i)
if RPGStat.Points(f,"HP").Have==0 then return end -- Don't deal with the deadif RPGStat.Points(f)
RPGStat.Points(f,"AP").Inc(amount or 1)
local ak
for ak=3,5 do
    f = RPGStat.PartyTag(ak)
    if f~="" then RPGStat.Points(f,"AP").Inc(amount or 1) end
    if f=="Crystal" then RPGStat.Points(f,"HP").Inc(amount or 1) end
    end
end


function GameSpecificPerformAction(ft,i,fv)
if ft=="Hero" and rand(0,skill)==1 then UpPoint(i) end
local ak
for ak=1,3 do UpPoint(ak) end    
end

function GiveItem(ch,item,vault)
-- DrawScreen()
-- DarkText("Configuring Data",400,300,2,2,255,255,255)
-- Flip()
-- Let's find a spot first to place the item in
   local spot = nil
   local ak
   local putinvault
   if left ( item,4 )~="ITM_" then return CSay("WARNING! "..item.." may not be an item, or at least not one I can process!") end
   -- First we're gonna look for a socket having the same item, but with enough space to carry another
   for ak=1,InventorySockets do
       -- CSay("Spot: "..ak.."; have: "..RPGChar.Stat(ch,"INVAMNT"..ak).." max: "..InventoryMaxStack) -- debug
       if (not spot) and item=="ITM_"..RPGChar.Data(ch,"INVITEM"..ak) and RPGChar.Stat(ch,"INVAMNT"..ak)<InventoryMaxStack then spot = spot or ak end
       --CSay("Spot: "..ak.."; have: "..RPGChar.Stat(ch,"INVAMNT"..ak).." max: "..InventoryMaxStack.." spot: "..sval(spot)) -- debug
       end
   -- Now we'll do the same for an empty socket if no filled socket matched our requiments before    
   for ak=1,InventorySockets do
       if (not spot) and RPGChar.Stat(ch,"INVAMNT"..ak)==0 then spot = spot or ak end
       end
-- If we got no socket reaching the required conditions, we must either reject the item or throw it into the vault (if the latter is allowed for this item)
if not spot then
   if not vault then return end -- If the item cannot be thrown into the vault, let's just ignore the item and we won't even talk about it any more
   putinvault = PutInVault(item)
   if not putinvault then return end -- and if the item also could not be placed in the vault, let's ignore it anyway and also not even talk about it any more.
   inc("%VAULT."..item)    
else
   RPGChar.SetData(ch,"INVITEM"..spot,right(item,len(item)-4))
   RPGChar.IncStat(ch,"INVAMNT"..spot)        
   end       
-- Right oh, if the script is still being processed it means the item was accepted one way or another. Let's report that to the player.
CSay(ch.." receives "..item)
MINI(RPGChar.GetName(ch).." gets a "..ItemName(item),0,180,255)
if not spot then 
   MINI("however "..heshe[ch].." could not carry that any more since "..hisher[ch].." inventory is full",255,180,180)
   if putinvault then MINI("so the item has been put in the vault in stead") end
   end   
if not Done("&TUT.ITEMSINBATTLE") then Tutorial("Occasionally when an enemy dies\nit may drop an item which a random character will pick up\nHowever only if he or she has room in his or her inventory for that item\n\n\nIf an item is vital and the character who finds it cannot pick it up it will be dropped\nin the vault in stead. This will however ONLY\nhappen with VITAL items and not common items!") end   
end


function KillFoe(idx,myfoe)
local f = upper(myfoe.File)
Dbg("Let's kill foe #"..idx.."> "..sval(myfoe.Tag))
inc("%COMBATSTAT.KILLS")
NumAchAward("KILL",CVV("%COMBATSTAT.KILLS"))
Bestiary[f] = (Bestiary[f] or 0) + 1
local maxfactor = 250
local enemylevel = RPGStat.Stat(myfoe.Tag,"Level")
local herotag,herolevel,gainexp
-- Hero experience
for i=0,5 do
    herotag = RPGStat.PartyTag(i)
    if herotag and herotag~="" then
       herolevel = RPGStat.Stat(herotag,"Level")
       gainexp = math.floor((enemylevel/herolevel)*maxfactor)
       if RPGStat.Points(herotag,"HP").Have==0 then
          ({
           function() end,
           function() gainexp = gainexp / 2 end,
           function() gainexp = 0 end})[skill]()          
          end
       RPGStat.Points(herotag,"EXP").Inc(gainexp)
       end
    end
-- Get an Aurina?
herolevel = AVGLevel("Hero")
if rand(0,enemylevel)>rand(0,herolevel*skill) then
   inc("%AURINAS")
   MINI("You found an Aurina")
   if not Done("&TUT.AURINA") then Tutorial("If you are lucky an enemy will drop an Aurina.\nThey are very important.\nSome businessmen throughout the universe will pay you money for them.") end
   end
-- Item Drop
local gip = rand(1,3) -- Who will get the item
local gpc = {25,12,4}
local gii
if Fighters.Hero[gip] and Fighters.Hero[gip].Tag~="" and Fighters.Hero[gip].Tag~="Briggs" and RPGStat.Points(Fighters.Hero[gip].Tag,"HP").Have>0 and rand(1,100)<gpc[skill] and #myfoe.ItemDrop>0 then
   gii = rand(1,#myfoe.ItemDrop)
   -- DBGSerialize(myfoe)
   GiveItem(Fighters.Hero[gip].Tag,myfoe.ItemDrop[gii].ITM,myfoe.ItemDrop[gii].VLT)
   end
-- Count enemies for characters who gain something by that (front row only, he he)
local ch
for ak=0,2 do
    ch = RPGChar.PartyTag(ak)
    if XCharKill[ch] then XCharKill[ch]() end   
    end
-- Remove the enemy from memory           
Fighters.Foe[idx] = nil
if RPGChar.CharExists(myfoe.Tag)==1 then RPGStat.DelChar(myfoe.Tag) else CSay("!! WARNING !! Tried to destroy non-existent foe: "..myfoe.Tag) end
end

function VicCheck.YaqirpaBrain()
local f 
if not BrainTag then
   for f in each(Fighters.Foe) do
       BrainTag = f.Tag 
       BrainFoe = f
       CSay("BrainTag = "..BrainTag)
       end
   end
RPGChar.Points(BrainTag,"HP").Minimum = 1 -- Now we cannot accidentally kill the boss, as this would spook the script up a little.
if BrainFoe.x<300 then BrainFoe.x=BrainFoe.x+2 end
if BrainFoe.y<400 then BrainFoe.y=BrainFoe.y+2 end
if RPGChar.Points(BrainTag,"HP").Have==1 then
   GrantExperienceOnLevel(20)
   DrawScreen()
   GrantEventExperience(6)
   DrawScreen()
   -- DelEnemies()
   LAURA.Flow("FIELD")
   end   
end

function RunVictory()
ywscale = ywscale or 0
ywtimer = ywtimer or 150
local cosdeg = (360-ywscale)
local cosres = math.cos(cosdeg/9); if cosdeg<=0 then cosres=1 end
local genscale = math.ceil((ywscale/360)*100)
local i,ch   
Image.ScalePC(genscale,genscale*cosres)
Image.LoadNew("YOUWIN","GFX/Combat/YouWin.png"); Image.HotCenter("YOUWIN")
White()
Image.Show("YOUWIN",400,150)
Image.ScalePC(100,100)
if ywscale<360 then 
   ywscale = ywscale + 2
   else
   ywtimer = ywtimer - 1
   if ywtimer<=0 then 
      PullMusic()
      inc('%COMBATSTAT.VICTORIES')
      NumAchAward("VICTORY",CVV("%COMBATSTAT.VICTORIES"))
      for i=0,5 do
          ch = RPGChar.PartyTag(i)
          if ch~="" and RPGChar.Points(ch,"HP").Have<=0 then RPGChar.Points(ch,"HP").Have=1 end
          end
      if FlawlessVictory then
         FlawlessStreak = FlawlessStreak + 1
         FlawlessVictories = FlawlessVictories + 1
         NumAchAward("PERFECTVICTORY",FlawlessVictories)
         NumAchAward("PERFECTSTREAK",FlawlessStreak)
         CSay("Flawless: "..FlawlessVictories)
         CSay("Streak:   "..FlawlessStreak)
      else
         FlawlessStreak = 0 
         end
      LAURA.Flow(CombatData.RETURNFLOW or "FIELD") 
      end
   end
end

DefeatedFunctions = { 
      Default = function()
                MS.Load("GAMEOVER","Script/Flow/GameOver.Lua")
                LAURA.Flow("GAMEOVER")
                end
  }
   

function RunDefeated()
DefeatedFunctions[CombatData.Defeated or 'Default']()
end
