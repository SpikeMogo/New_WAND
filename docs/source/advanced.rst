Advanced
===========

.. _discord_bot: 

Discord bot installation
--------------------------

.. _Discord: https://discord.com/developers/applications

- ``Step 1:`` Copy the contents of the folder ``discord_bot_dependency`` into the Maplestory directory.

- ``Step 2:`` Create/Signin to your Discord_ Developers Portal and create a new application, give it a name.

    - .. image:: https://i.imgur.com/oVMs9cQ.png
    - .. image:: https://i.imgur.com/ZOGn35t.png

- ``Step 3:`` Once on the application dashboard, you can name the bot, upload a DP, description for the application if you wish.


    - .. image:: https://i.imgur.com/PMCOVcU.png
- Then Navigate to the **Bot** settings and create the bot, after you create the bot you will be presented with it's dashboard.
    
    
                       - .. image:: https://i.imgur.com/5D8ma8Z.png





- ``Step 4:`` Navigate to the **O2Auth** setting page, then sub-page **URL Generator**. Under **Bot permissions** either give it the **Administrator** permission or at least the **Read/Send Messages** permission. 


                       - .. image:: https://i.imgur.com/Y7jeLJN.png
                       
                       
.. note:: 
	before proceeding make sure you have created a new server to host the discord bot.
                       
----------------         
	 
	- then copy the **generated url** down the bottom, paste it into your browser and invite the bot. (sign into Discord on your browser)
         
                      - .. image:: https://i.imgur.com/ChdaUFZ.png
         
         
         
                        - .. image:: https://i.imgur.com/CYNT9Ak.png
                        
                        
                        - .. image:: https://i.imgur.com/YOXNVgd.png
                        
- ``Step 5:`` Run the Maplestory client, inject **WAND_disc.dll**, open the Discord bot settings in the bottom right hand corner.

      - .. image:: https://i.imgur.com/51kad4v.png
      - .. image:: https://i.imgur.com/Qj2wHlj.png
      
- Go back to the **Bot's setting** page on the Discord application dashboard and grab the Bot's token, place it into the **Bot Token** input. 

      - .. image:: https://i.imgur.com/alPtwUG.png
      
- then grab the channel ID that you want the bot to operate in, place it into the **Channel ID** input.

      - .. image:: https://i.imgur.com/OFI2Xeo.png
      
- ``Step 6:`` Click **Start** and the Bot will (provided you have set it up correctly) connect to the WAND dll and send a message to the Discord channel notifying you it is online.

      - .. image:: https://i.imgur.com/3MSfMTn.png

- Once you are in-game, you can issue commands to the bot on Discord.

``!help`` returns a list of avaliable commands for you to issue with the bot which are self-explanatory

      - .. image:: https://i.imgur.com/pTmMrCY.png
      - .. image:: https://i.imgur.com/C92sDVN.png
      - .. image:: https://i.imgur.com/sUFflp1.png
      - .. image:: https://i.imgur.com/yvFh1cm.png
      

.. _supplement_maplist:


Supplement maplist
--------------------

There are two sets of Maplists in WAND, one is from Royal_2021 (a mixture of v.62 and v.83), another one is from Dream_2021 (close to v.83). 

The Maplist of WAND contains maps (ID, name) and portals (location, name, type). Maplist is **not** a complete set of all maps and portals you may find in a server. For example, some portals are controlled by server-side scripts, or are NPC-related.

Therefore, WAND provides a way to supplement the Maplist.

Add missing connection
^^^^^^^^^^^^^^^^^^^^^^^

- ``Step 1:`` Check the Maplist when a path cannot be found in WAND

  - .. image:: https://raw.githubusercontent.com/SpikeMogo/New_WAND/main/docs/resource/Maplist_list.png

  - from the figure above, you can see that there is no portal goes from ``Subway Ticketing Booth`` to ``Line 1``.


- ``Step 2:`` Add connection

  - .. image:: https://raw.githubusercontent.com/SpikeMogo/New_WAND/main/docs/resource/Maplist_sub.png
    :width: 200

  - let's stand in the portal and record the location of the portal

  - add one line in the ``ManualPortal.dat`` (Map toMap x y name):

    .. code-block:: Batch

      103000100 103000101 201 187  to_line1

    this means there is a portal which warps you from ``103000100`` to ``103000101``, at location ```(195,190)``, and you want to call it ``to_line1``


- ``Step 3:`` Re-inject WAND to make the change effective

.. note:: 

  the portal location may vary from server to server, please check on your server

Add NPC portal
^^^^^^^^^^^^^^^^^^^^^^^

Imagine you need to talk with a NPC to go somewhere, for example, a taxi or a tour guide.

.. image:: https://raw.githubusercontent.com/SpikeMogo/New_WAND/main/docs/resource/Maplist_hotel.png

This picture is taken from ``Sleepywoond Hotel``, you need to talk to this Lady to go into the ``Regular Sauna`` map.

- ``Step 1:`` Add connection

    - let's stand close to the NPC and record the location of the NPC

    - add one line in the ``ManualPortal.dat`` (Map toMap x y name):

    .. code-block:: Batch

      105040400 105040401 -240 111 to_Sauna


- ``Step 2:`` In the ``walk.lua`` script_ , you need to add instructions about how to talk to the NPC step by step.

  .. _script: https://github.com/SpikeMogo/New_WAND/blob/main/Release/Script/scriptlib/walk.lua


  .. code-block:: lua
  
    local function ManualPort(Player, portal)

      print("Use Manually Added Portal: ", portal.portalName)
      -- chat with NPC and go to regular Sauna
      if portal.portalName=="to_Sauna" then
          for i=1,3 do
              SendKey(module.NPCChatKey) Delay(500)
          end
          SendKey(vk.VK_RIGHT) Delay(500)
          SendKey(module.NPCChatKey)  Delay(2000)
          return 
      end

      -- if no special move, still use portal
      StopMove()
      SendKey(vk.VK_UP,4)
      Delay(2000)
    end

  In the code block above, the code sees that the portal is manually added and the name is ``to_Sauna``, it will execute the 5 key-presses to enter the map.


- ``Step 3:`` Re-inject WAND to make the change effective


.. note:: 

  portal name is given by you. You need to use the name in Lua script to code special instructions.

.. note:: 

  please also check the ``FindNextPortal()`` in :ref:`gameplay`


.. _read_bmp:

Read bmp
--------------------
To use 
