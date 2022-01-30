Script Snippet
===============

Here, we post some useful example snippets for script development, you should have a basic understanding of the script layout.


Feeding Pet Via Pointer
^^^^^^^^^^^^^^^^^^^^^^^^^^^

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
     
     
