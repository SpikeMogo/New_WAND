Lua API
=========
 

.. _gameplay:

Game Play
^^^^^^^^^^^

.. function:: Player = GetPlayer()

	:return: a table of player's attributes

		.. code-block:: text

			Player (table)
			├── x (int)
			├── y (int)
			├── level (int)
			├── exp (float)
			├── hp (int)
			├── mp (int)
			├── maxHp (int)
			├── maxMp (int)
			├── ani (int)
			├── Orientation (int)
			├── InAir  (bool)
			├── OnRope (bool)
			└── IsDead (bool)

	:example: 
		.. code-block:: lua

			-- print Player level
			Player = GetPlayer()
			print("Level:", Player.level)
			
---------------------------------------

.. function:: n = GetChannel()

	:return: integer, current channel

---------------------------------------

.. function:: n = GetMapID()

	:return: integer, current map ID
	
---------------------------------------

.. function:: n = GetMobNum()

	:return: integer, number of mobs

---------------------------------------

.. function:: mob = GetMob(arg1)

	:param arg1: index of mob, starts with ``0``
	:type arg1: int 

	:return:  a table of one mob's attributes

		.. code-block:: text
	
			mob (table)
			├── x (int)
			├── y (int)
			└── invisible (bool)

	:example: 
		.. code-block:: lua

			-- print the position of first mob
			mob = GetMob(0)
			print(mob.x," ", mob.y)
	
	:note:
		* Depending on server, ``invisible`` may not be accurate 

---------------------------------------

.. function:: mobs = GetAllMobs()

	:return: a table of mobs

		.. code-block:: text

			mobs (table)
			├── mob (table)
			│   ├── x (int)
			│   ├── y (int)
			│   └── invisible (bool)
			├── mob
			│   ├── x
			│   ├── y
			│   └── invisible
			│ 
			...

	:example: 
		.. code-block:: lua

			-- print mob position
			mobs = GetAllMobs()
			for k, mob in pairs(mobs) do
				print(mob.x," ", mob.y)
			end

	:note:
		* it's recommended to use ``GetAllMobs()`` instead of ``GetMob()``

---------------------------------------

.. function:: n = GetDropNum()

	:return: integer, number of drops on the ground

---------------------------------------

.. function:: item = GetDrop(arg1)

	:param arg1: index of drop, starts with ``0``
	:type arg1: int 

	:return:  a table of attributes for one dropped item

		.. code-block:: text
	
			item (table)
			├── x (int)
			├── y (int)
			├── ID (int)
			├── UID (int)
			└── type (string)

	:example: 
		.. code-block:: lua

			-- print the type of first item on the ground
			item = GetDrop(0)
			print(item.Type)

	:note:
		* Type equals one of: ``"Equip"``, ``"Use"``, ``"Setup"``, ``"Etc"``, ``"Cash"``, ``"Mesos"``
		* for ``"Mesos"``: ``item.ID`` is the amount of Mesos in the bag

---------------------------------------

.. function:: items = GetAllDrops()
	
	:return:  a table of dropped items

		.. code-block:: text
	
			items (table)
			├── item (table)
			│   ├── x (int)
			│   ├── y (int)
			│   ├── ID (int)
			│   ├── UID (int)
			│   └── type (string)
			│
			├── item (table)
			│   ├── x (int)
			│   ├── y (int)
			│   ├── ID (int)
			│   ├── UID (int)
			│   └── type (string)
			...

	:example: 
		.. code-block:: lua

			-- print all items on the ground
			items = GetAllDrops()
			for k, item in pairs(items) do
				print(item.type,": ",item.ID)
			end

---------------------------------------

.. function:: n = GetOtherPlayersCount()

	:return: integer, number of other players

---------------------------------------

.. function:: Players = GetOtherPlayers()
	
	:return: a table of other players

		.. code-block:: text

			Players (table)
			├── player (table)
			│   ├── x (int)
			│   ├── y (int)
			│   ├── UID (int)
			│   └── name (str)
			│
			├── player (table)
			│   ├── x (int)
			│   ├── y (int)
			│   ├── UID (int)
			│   └── name (str)
			│ 
			...

	:example: 
		.. code-block:: lua

			-- print other players' name
			Players = GetOtherPlayers()
			for k, player in pairs(Players) do
				print(player.name)
			end

	:note:
		* This function relies on decoding packets, it's recommended that you CC after the every injection of WAND to setfield. (i.e. If WAND doesn't show correct map name on the UI, that means you need to refresh by changing channel)


---------------------------------------

.. function:: MobIDs = GetMobIDinMap()

	:return: a table of IDs for current mobs

		{ID_1, ID_2, ID_3, ...}


	:example: 
		.. code-block:: lua

			-- print every ID of mobs
			MobIDs = GetMobIDinMap()
			for _, ID in ipairs(MobIDs) do
				print(ID)
			end

	:note:
		* Similar to ``GetOtherPlayers()``, this function relies on decoding packets, it's recommended that you CC after the every injection of WAND to setfield. 
		* You can use this function to check if any strange mob is spawned by GM


---------------------------------------

.. function:: Buffs = GetBuffandDebuff()

	:return: tables of buffs and debuffs

		.. code-block:: text

			│
			├── Buff (table)
			│   ├── Buff
			│   │   ├──ID (int)
			│   │   └──time_remain (float, in second)
			│   │ 
			│   ├── Buff
			│   │   ├──ID (int)
			│   │   └──time_remain (float, in second)
			│
			│
			└── Debuff (table)
				├── Debuff
				│   └──name (string)
				│ 
				├── Debuff
				│   └──name (string)
			  
			...

	:example: 
		.. code-block:: lua

			-- print player' buff
			Buffs = GetBuffandDebuff()
			for k, buff in pairs(Buffs.Buff) do
				print(buff.ID," time_remain: ",buff.time_remain)
			end

	:note:
		* The names of debuffs: ``"seal"``, ``"slow"``, ``"stun"``, ``"curse"``, ``"seduce"``, ``"poison"``, ``"weaken"``, ``"zombify"``, ``"confuse"``, ``"darkness"``.


---------------------------------------

.. function:: portal = FindNextPortal(arg1)

	:param arg1: destination map ID
	:type arg1: int

	:return: a portal object

		.. code-block:: text

				portal (table)
				├── nextMap (int)
				├── x (int)
				├── y (int)
				├── portalName (string)
				└── type (string)

	:example: 
		.. code-block:: lua

			-- print the portal you should take at current map to Hunting Ground I
			portal = FindNextPortal(104040000)
			print(string.format("take the portal at: [%d,%d]",portal.x,portal.y))

	:note:
		* ``portal.type`` =  ``"manual"`` or ``"game"``. ``"manual"`` means this portal is added manually.
		* use ``portal.type`` and  ``portal.portalName`` together, you can customize the connections you added, e.g. taking the taxi.
		* About adding manual portals, please check :ref:`supplement_maplist`.

---------------------------------------

.. function:: RefreshInventory(arg1)
	
	:param arg1: a table of string, contains any of these four options: ``"Equip"``, ``"Use"``, ``"Etc"``, ``"Cash"``
	:type arg1: table
	:return: none
	:example:
		.. code-block:: lua

			-- Refresh Equip only
			RefreshInventory({"Equip"})

			-- Refresh All
			RefreshInventory({"Equip", "Use", "Etc", "Cash"})

	:note:
		* This function is packet-based and takes about half sec, please don't call it too frequently 
		* Depending on server, the results may not be accurate

---------------------------------------

.. function:: Inventory = GetFullInventory()

	:param arg1: a table of string, contains any of these four options: ``"Equip"``, ``"Use"``, ``"Etc"``, ``"Cash"``
	:type arg1: table

	:return: inventory info according to the input

		.. code-block:: text

			│
			├── tab (table)
			│   ├── Item (table)
			│   │   ├──ID (int)
			│   │   └──...
			│   │ 
			│   ├── Item
			│   │   ├──ID 
			│   │   └──...
			│
			│
			└── tab 
			    ├── Item
			    │   ├──ID
			    │   └──...
			   ...

		if tab = ``Equip``

		.. code-block:: text

			Item
			├── ID
			├── Name
			├── Avail_Upgrades
			├── Scrolled
			├── Str
			├── Dex
			├── Int
			├── Luk
			├── Hp
			├── Mp
			├── Watk
			├── Matk
			├── Wdef
			├── Mdef
			├── Acc
			├── Avoid
			├── Speed
			└── Jump

		if tab = ``Use`` or ``Etc`` or ``Cash``

		.. code-block:: text

			Item
			├── ID
			├── Name
			└── Num




	:example:
		.. code-block:: lua

			-- Refresh
			RefreshInventory({"Equip", "Use", "Etc"})

			-- Get
			Inventory = GetFullInventory({"Equip", "Use", "Etc"})
			for slot,item in pairs(Inventory.Equip) do
				print("Slot: ", slot, " Name: ", item.Name)

	:note:
		* ``GetFullInventory()`` should be paired with ``RefreshInventory()`` with same inputs
		* Depending on server, the results may not be accurate

---------------------------------------

.. function:: size = GetMapDimension()

	:return: a size object

		.. code-block:: text

				size (table)
				├── left (int)
				├── right (int)
				├── top (int)
				└── bottom (int)


---------------------------------------

.. function:: map = GetMapStructure()

	:return: tables of footholds and ropes

		.. code-block:: text

			│
			├── Foothold (table)
			│   ├── foothold
			│   │   ├──ID (int)
			│   │   ├──x1 (int)
			│   │   ├──y1 (int)
			│   │   ├──x2 (int)
			│   │   └──y2 (int)
			│   │ 
			│   ├── foothold
			│   │   ├──ID
			│       ├──x1
			│       ├──y1
			│       ├──x2
			│       └──y2
			│
			│
			└── RopeLadder (table)
				├── Rope
				│   ├──ID (int)
				│   ├──x  (int)
				│   ├──y1 (int)
				│   └──y2 (int)
				│ 
				├── Rope
				│   ├──ID (int)
				│   ├──x  (int)
				│   ├──y1 (int)
				│   └──y2 (int)
			  
			...

	:note:
		* This function returns the structure of current map.
		* Ropes and ladders are vertical, so only one value ``x`` is return.


.. function:: n = ItemLocationInStore(arg1)

	:param arg1: item ID
	:type arg1: int 

	:return:  location of item in the store


	:note:
		* Item list is loaded at ``open_store`` action. Use this function after store is opened
		* Location of item starts with ``0``


.. function:: n = NumOnQuickSlot(arg1)

	:param arg1: key code
	:type arg1: int 

	:return:  number of item on the key



	:example:
		.. code-block:: lua

			-- Get item number on the Delete key
			print(NumOnQuickSlot(46))

	:note:
		* This functions only works for eight ``quick slots``
			.. code-block:: text
			
				-----------------------------
				| Shift |  Ins  | Hm  | Pup |
				-----------------------------
				| Ctrl  |  Del  | End | Pdn |
				-----------------------------

		* Virtual-Key_ Codes 
			.. _Virtual-Key: https://docs.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes



.. _input:

Input
^^^^^^^^^^^

.. function:: SendKey(arg1, arg2=1)

	:param arg1: key code
	:type arg1: int 

	:param arg2: repeat (optional, default = ``1`` )
	:type arg2: int 

	:return:  none



	:example:
		.. code-block:: lua

			-- Send space key 
			SendKey(32)

			-- Send Up key four times
			SendKey(38, 4)

	:note:
		* This function calls ``PostMessageA`` (winuser.h), with two consecutive messages: WM_KEYDOWN and WM_KEYUP.
		* In text box, this function may trigger two key-presses instead of one, if you want to sendkey in maple text box (e.g. chatbox), please use ``SendKey2()`` function
		* This function works in ``background``, that means, the maple window doesn't need to be focused. However, background key-press may not be working for some skills. Tests are needed.
		* Virtual-Key_ Codes
			.. _Virtual-Key: https://docs.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes


.. function:: SendKey2(arg1, arg2=1)

	:param arg1: key code
	:type arg1: int 

	:param arg2: repeat (optional, default = ``1`` )
	:type arg2: int 

	:return:  none


	:note:
		* Same as ``SendKey()`` function. But this function post one message: WM_KEYDOWN.

		* You can use this function if you need to input in textbox, or need to hold a key for skills like ``BigBang``.


.. function:: HoldKey(arg1, arg2)

	:param arg1: key code
	:type arg1: int 

	:param arg2: state,  ``0`` or ``1`` 
	:type arg2: int 

	:return:  none


	:example:
		.. code-block:: lua

			-- Hold Left key for 4 sec and release
			SendKey(37, 1)
			Delay(4000)
			SendKey(37, 0)

	:note:
		* This function only works for ``left``, ``right``, ``up`` and ``down`` keys.
		* Virtual-Key_ Codes 
			.. _Virtual-Key: https://docs.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes



.. function:: LeftClickOnScreen(arg1,arg2)
	
	:param arg1: x
	:type arg1: int 

	:param arg2: y
	:type arg2: int 

	:return:  none

	:note:
		* This function works in ``background``
		* ``(x, y)`` is the position of cursor in screen coordinate.



.. function:: LeftClickOnWindow(arg1,arg2)
	
	:param arg1: x
	:type arg1: int 

	:param arg2: y
	:type arg2: int 

	:return:  none

	:note:
		* This function works in ``background``
		* ``(x, y)`` is the position of cursor respect to the Maple window (upper-left corner is ``(0,0)``).


.. _control:

Control
^^^^^^^^^^^


.. function:: n = MoveTo(arg1, arg2, arg3)

	:param arg1: x
	:type arg1: int 

	:param arg2: y
	:type arg2: int 

	:param arg3: type (optional, default = ``0``)
	:type arg3: int 

	:return:  n: ``1`` = moving; ``2`` = path_not_found; ``3`` = wrong_map

	:example:
		.. code-block:: lua

			-- move the player
			while(1) do
				MoveTo(100,200)
			end

	:note:
		* This function walks the player to the position ``(x,y)`` in current map
		* type = ``1`` means moving to a portal, type = ``2`` means moving to a drop. Using type > 0 will invoke some special treatment in dll (bigger torrence). For most of time in hunting, type can be ignored.
		* For continuous movement, this function must be put in a loop.

.. function:: SetMapData(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9)

	:param arg1: Max jump
	:type arg1: int 

	:param arg2: Step size
	:type arg2: int 

	:param arg3: Jump key
	:type arg3: int 

	:param arg4: Magic teleport key
	:type arg4: int 

	:param arg5: Magic teleport distance
	:type arg5: int 

	:param arg6: if use teleport skill of Mage
	:type arg6: bool

	:param arg7: if use in_map portals
	:type arg7: bool

	:param arg8: if use teleport hack
	:type arg8: bool

	:param arg9: if jump down tile
	:type arg9: bool


	:note: 
		* You can tell the bot what's your jump key and what is the teleport skill key if you are Mage
		* Max jump distance for beginner is normally 80
		* Step size is around 5 ~ 6
		* Changing maxjump and stepsize will adjust the player's movement
		* ``arg8`` : if use teleport hack. This means when path to the target is not found, the bot will try to use ``teleport hack`` to move player. Enable this only when you are confident that teleport hack is safe
		* Call this function at the beginning of the script, parameters stay effective for all maps during the lifetime of script.

.. function:: StopMove()

	:return:  none

	:note: 

		* Stop player's movement


.. function:: StopScript()
	
	:return:  none

	:note: 
		* Stop the script
		* Call it anywhere in script will stop the Lua thread.
		



.. _hack:

Hack
^^^^^^^^^^^

.. function:: SetMobFilter(arg1,arg2)

	:param arg1: table of IDs
	:type arg1: int

	:param arg2: enable = ``true`` or ``false``
	:type arg2: bool 

	:return:  none

	:example:
		.. code-block:: lua

			-- enable
			SetMobFilter({1234567,7654321}, true)

			-- disable
			SetMobFilter({}, false)

	:note:
		* Risky

.. function:: SetItemFilter(arg1,arg2)

	:param arg1: table of IDs
	:type arg1: int

	:param arg2: enable = ``true`` or ``false``
	:type arg2: bool 

	:return:  none

	:example:
		.. code-block:: lua

			-- enable
			SetItemFilter({1234567,7654321}, true)

			-- disable
			SetItemFilter({}, false)

	:note:
		* Risky

.. function:: EnableHacks(arg1)

	:param arg1: table of indices
	:type arg1: int

	:return:  none

	:example:
		.. code-block:: lua

			-- enable hacks no.1 no.2 no.3
			EnableHacks({1,2,3})

	:note:
		* Please check the ``Hack`` page for index of each hack
	


.. function:: DisableHacks(arg1)

	:param arg1: table of indices
	:type arg1: int

	:return:  none

	:example:
		.. code-block:: lua

			-- disable hacks no.1 no.2 no.3
			DisableHacks({1,2,3})

	:note:
		* Please check the ``Hack`` page for index of each hack

.. function:: DisableAllHacks()

	:return:  none

	:note:
		* Disable all hacks


.. function:: MapRush(arg1, arg2)

	:param arg1: mapID
	:type arg1: int

	:param arg1: method = ``0``, or ``1``, or ``2``  
	:type arg1: int

	:return:  none

	:example:
		.. code-block:: lua

			-- Rush to map 104040000, with method 0
			MapRush({104040000,0})

	:note:
		* Method: ``0`` uses Spawn control; ``1`` uses packet; ``2`` uses VIP-Rock (make sure you have rocks)
		* Not all methods are working on every v83 server
		* It's recommend to use method = ``0``


.. _utility:

Utility
^^^^^^^^^^^

.. function:: Delay(arg1)
	
	:param arg1: millisecond
	:type arg1: int
	:return: none

	:example:
		.. code-block:: lua

			-- lua thread sleeps for 1 sec
			Delay(1000)

---------------------------------------

.. function:: SendPacket(arg1)

	:param arg1: raw packet
	:type arg1: string
	:return: none
	:example:
		.. code-block:: lua

			-- change to channel 2
			SendPacket("27 00 01 00 00 00 00")

---------------------------------------


.. function:: RecvPacket(arg1)

	:param arg1: raw packet
	:type arg1: string
	:return: none
	:example:
		.. code-block:: lua

			-- Buff Magic Guard Client-side
			RecvPacket("20 00 00 00 00 00 00 00 00 00 00 00 00 00 02 00 00
			 00 28 00 6B 88 1E 00 80 1A 06 00 00 00 00 00 00 28 00 00 00")

	:note: 
		* This function posts a packet to client, so server will not know
		* If you use this function for buffing, added buff will never die. However, this doesn't work for some buffs and may be risky for att-adding buffs

.. function:: InsertBlockPacket(arg1,arg2)

	:param arg1: table of strings
	:type arg1: string

	:param arg2: type = ``Send`` or ``Recv``
	:type arg2: string 

	:return:  none

	:example:
		.. code-block:: lua

			InsertBlockPacket({"003D", "001A 00 01"}, "Send")

	:note:
		* Block Packets
		* Please use this format for the packet: "xxxx xx xx ..." the first two bytes are the Opcode.
		* It will block any packet that equals or starts with your input string


.. function:: RemoveBlockPacket(arg1,arg2)

	:param arg1: table of strings
	:type arg1: string

	:param arg2: type = ``Send`` or ``Recv``
	:type arg2: string 

	:return:  none

	:example:
		.. code-block:: lua

			RemoveBlockPacket({"003D", "001A 00 01"}, "Send")

	:note:
		* Remove strings from the blocklist

.. function:: ChangeChannel()

	:param arg1: channel 
	:type arg1: int

	:return:  none

	:example:
		.. code-block:: lua

			-- cc4
			ChangeChannel(4)

	:note:
		* This method is packet based

.. function:: AssignAP(arg1,arg2,arg3,arg4)

	:param arg1: Str
	:type arg1: int
	:param arg2: Dex
	:type arg2: int
	:param arg3: Int
	:type arg3: int
	:param arg4: Luk
	:type arg4: int

	:return:  none

	:example:
		.. code-block:: lua

			-- add 4 str and 1 dex
			AssignAP(4,1,0,0)

.. function:: AutoLogin(arg1)

	:param arg1: username@slot
	:type arg1: string

	:return:  none

	:example:
		.. code-block:: lua

			-- login with username admin and character slot 1
			AutoLogin("admin@1")

	:note:
		* Your must have saved account profile
		* Make sure the password box is activated and no other UI is blocking the client


.. function:: table = ReadInput()
	
	:return:  table of numbers

	:example:
		.. code-block:: lua

			-- read one number from user
			print("type 1 to continue the script")
			x = ReadInput()
			if x[1]==1 then
    			print("yes")
			else 
    			StopScript()
			end

		.. code-block:: lua

			-- read multiple numbers from user and print
			x = ReadInput()
			for _, i in pairs(x) do 
    			print(i)
			end

	:note:
		* Only accepts numbers, separate them with ``space``
		* This function will pause the Lua thread until you cancel or enter inputs
		* You can control the script in real time by using this function


.. function:: x, y = FindBMP(arg1)

	:param arg1: name_of_bmp
	:type arg1: string

	:return: position of the BMP in window coordinate

	:example:
		.. code-block:: lua

			-- Find and click
			x,y = FindBMP("my_bmp")
			LeftClickOnWindow(x,y)


	:note:
		* You must use ``24 bit`` bmp 
		* You need to put bmps in the ``bmps`` folder


.. function:: PlayWav(arg1)

	:param arg1: name_of_wav (optional)
	:type arg1: string

	:return: none

	:example:
		.. code-block:: lua

			-- Play default alert sound
			PlayWav()

			-- Play custom sound
			PlayWav("my_wav")

	:note:
		* You must use ``.wav`` 
		* For custom sound, you need to put sound file in the ``sound`` folder


.. function:: x = ReadPointerLua(arg1, arg2)
	
	:param arg1: base address
	:type arg1: int

	:param arg2: offset
	:type arg2: int

	:return: signed int

	:example:
		.. code-block:: lua

			-- read mapID
			n = ReadPointerLua(0xBED788, 0x668)


.. function:: ReadMultiPointerSigned(arg1, arg2,...)
	
	:param arg1: base address
	:type arg1: int

	:param arg2-arg8: offsets, maximum 7 offsets are allowed

	:type arg2-arg8: int



	

	:return: signed int

	:example:
		.. code-block:: lua

			-- read first pet's HP
			fullness = ReadMultiPointerSigned(0x00BF6860, 0x14, 0x10, 0xAC)


	:note:
		* Maximum ``7`` offsets are allowed













