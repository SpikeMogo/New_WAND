Script Snippet
===============

Here, we post some useful example snippets for script development, you should have a basic understanding of the script layout.



Feeding Pet Via Pointer
^^^^^^^^^^^^^^^^^^^^^^^^^^^
(author:  XTEAC)

- ``Step 1:`` Open your maple.lua (if you have read the guide you will know what is in this file) which contains the user functions. Copy+Paste this in the function area

  .. note::

    Pet feed pointer apparently isn't the same for everyone, if the one provided doesn't work you will have to find it for yourself.



  .. code-block:: lua


      local function feedviapointer()
      fullness = ReadMultiPointerSigned(0x00BF6860, 0x14, 0x10, 0xAC)

       if fullness==0 then --required because pointer sometimes returns nill value
        return
        end
         if module.PetFeed==true then
        if fullness<module.MinFullness and os.clock()-__PetFeedTick>module.PetFeedDelay then           
            print("Pet Fullness level: ",fullness,", feeding pet")
            SendKey(module.petfoodkey)
            __PetFeedTick=os.clock()
            end
            end
        end


- ``Step 2:`` Scroll down to ``function module.Run()`` and call the function during script run.


- ``Step 3:`` Add ``__PetFeedTick`` to the tick area, add ``PetFeedDelay`` , ``MinFullness`` , ``Pet Feed``, and ``petfoodkey`` in your module section up top, you can just set the values at as 0 (or true/false for Petfeed) as you will be defining them in the bootstrap.

  .. code-block:: lua

         
       PetFeed = true,
       MinFullness = 30,
       petfoodkey = vk.VK_Y,
       PetFeedDelay = 1, --1 second


- ``Step 4:`` in your bootstrap file, you now want to reference the new modules in it's module section.

  .. code-block:: lua

    
     maple.PetFeed = true -- 
     maple.petfoodkey = vk.VK_Y -- pet food key
     maple.MinFullness = 30 --min pet fullness level
     maple.PetFeedDelay = 1 --1 second
     
     

Edge detection while hunting
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(author: XTEAC, Spike)


- Everything is done in hunt.lua

- ``Step 1:``  

  Replace

  .. code-block:: lua


      local FailCount=0;
      function module.Run()         
  
  With

  .. code-block:: lua


      local FailCount=0;
      local Edge=false;
      function module.Run()
      
      
- ``Step 2:``

  Replace

  .. code-block:: lua
  
  
       local attackable = TryAttack(moblist)
       
       
  With
  
  
  .. code-block:: lua
       
       
       if Edge then
        local attackable = false
       else
       local attackable = TryAttack(moblist)
       end

- ``Step 3:``

  Replace

  .. code-block:: lua
  
  
        last_target = FindNextPos(moblist)  
        --print(last_target.x, ",", last_target.y,", ", Player.x,",",Player.y)
         if last_target ~= nil then      

        local dst = math.abs(last_target.x-Player.x) + math.abs(last_target.y-Player.y)
        
        local ms=MoveTo(last_target.x,last_target.y)
       
       
  With
  
  
  .. code-block:: lua
       
       
     last_target = FindNextPos(moblist)  
    --print(last_target.x, ",", last_target.y,", ", Player.x,",",Player.y)
     if last_target ~= nil then      
        local tolerance=100
        local xP=last_target.x
        xmin,  xmax  = PlatformEdges(Player.x, Player.y)
        xminM, xmaxM = PlatformEdges(last_target.x, last_target.y)
        local dst = math.abs(last_target.x-Player.x) + math.abs(last_target.y-Player.y)
        
        Edge=false
        if xmin==xminM and xmax==xmaxM and xmaxM-xminM>3*tolerance and Player.x-xmin<tolerance then
            xP=Player.x+tolerance
            Edge=true
        end
        if xmin==xminM and xmax==xmaxM and xmaxM-xminM>3*tolerance and -Player.x+xmax<tolerance then
            xP=Player.x-tolerance
            Edge=true
        end


        local ms=MoveTo(xP,last_target.y)
              


Finding Single NPC (store) X/Y using pointer.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(author:  XTEAC)

.. note:: This only points to the first NPC on the map, so it will only work on maps with single NPC's(other NPC X/Y's contained further up in pointer path)
          Set Store X/Y to 1,1 (we are comparing invalid location to correct NPC location.



- ``Step 1:`` Go to store.lua and add in

   
   
  .. code-block:: lua
       
       
        ---Find Sale NPC X/Y by pointer---
        NPCX = ReadMultiPointerSigned(0x00BED780, 0x2C, 0x10, 0x150)
        NPCY = ReadMultiPointerSigned(0x00BED780, 0x2C, 0x10, 0x154)
        if module.GrabNPC==true and GetMapID()==module.StoreMap and module.NPCLocation[1]~=NPCX and module.NPCLocation[2]~=NPCY then
        module.NPCLocation[1] = NPCX
        module.NPCLocation[2] = NPCY
        print("Set store location  X: ",NPCX," Y: ",NPCY,"")
        end
        ---Find Sale NPC X/Y by pointer---
        
  
  
  Below
  
  
  .. code-block:: lua
       
        function module.Sell(Player)
        
        
        
        
        
  You can also adjust tolerance at this line.
  
  
  .. code-block:: lua
       
       
        if global.Distance(Player.x, Player.y, module.NPCLocation[1], module.NPCLocation[2])
        
        
        
        
        
- ``Step 2:`` Add module to control on/off
 
 
 
  .. code-block:: lua
       
       
        GrabNPC = true,
        
        
        
        
- ``Step 3:`` Then add to bootstrap so you can control it there.
 
 
 
  .. code-block:: lua
       
       
        store.GrabNPC = true
        




Manual Platforms
^^^^^^^^^^^^^^^^^^^^^^^^^^^
(author:  XTEAC, Spike)

- Everything is done in hunt.lua

- ``Step 1:`` Open your hunt.lua, find the moblist area near

  
  .. code-block:: lua
       
       
       function module.Run()
       


replace it with


.. code-block:: lua
       
       
      local index=1;
      local FailCount=0;
      local Edge=false; --only if you use edge detection
      function module.Run()
      local PlatY = module.ManuPlats[index*2] --set manuplats in module
      local PlatX = module.ManuPlats[index*2-1]
      local Player = GetPlayer();
      local c=1
      local moblist ={}
      local Mobs = GetAllMobs()

      if Mobs==nil then
      print("No Mob in the Map!")
      return 0
      end
      if module.ManuPlat==false then
      for k, mob in pairs(Mobs) do
      if  mob.invisible==false then 
      moblist[c]={}       
      moblist[c].x=mob.x
      moblist[c].y=mob.y
      c=c+1
      end
      end
      end

      if module.ManuPlat==true then
      for k, mob in pairs(Mobs) do
      if  mob.invisible==false then
      if mob.y == PlatY and  mob.x < PlatX+2000  and  mob.x > PlatX-2000 then    
      moblist[c]={}       
      moblist[c].x=mob.x
      moblist[c].y=mob.y
      c=c+1
      end
      end
      end
      end


      if c==1 then
      index= (index)%module.PlatCount+1
      end
      
      
- ``Step 2:`` Add modules up the top of hunt.lua and in your bootstrap as well.

.. code-block:: lua
       
    PlatCount = 2,
    ManuPlat = true,
    ManuPlats = {635, 305, 667, -235}, --X/Y
    
