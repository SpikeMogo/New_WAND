Use script
=============




.. note::

	Please check :doc:`api` for the usage of Lua API.


.. _script_structure:

Script structure
------------------

In the Script_ folder.

.. _Script: https://github.com/SpikeMogo/New_WAND/tree/main/Release/Script

.. code-block:: text

	Script
	│
	├── scriptlib
	│	├── global.lua
	│	├── virtualkey.lua
	│	├── hunt.lua
	│	├── loot.lua
	│	├── store.lua
	│	├── walk.lua
	│	└── maple.lua
	│
	└──Bootstrap.lua


- ``Bootstrap.lua`` is where you customize botting parameters.

- You **only** need to select and run the ``Bootstrap.lua`` script. It will include all the modules in ``scriptlib`` automatically.

- ``scriptlib`` contains different modules like hunt, loot, walk, and store. For most of time you don't need to change those.

.. note:: 
		We encourage you to read all scripts in the ``Script`` folder. 

.. note:: 
		Please also share your scripts and ideas in our discord server. 


.. _script_example:

Example 
------------------

we provide 5 different example scripts in the ``Script`` folder. If you are new to WAND, please create a new account and try the first example below.


- ``Example_Begin_1_8.lua:``

	- this script is designed for ``MapleRoyals``.

	- it will try to hunt in map ``40000`` (please note that some servers don't have this map, change to the beginner map accordingly)

		.. code-block:: lua

			-- append hunt map ID, and SafeSpot here
			maple.HuntMapList =  { {ID=40000,SafeSpot={41, 275}},} 

	- auto_buff, auto_pot, and store function is disabled 

		.. code-block:: lua

			IfAutoBuff=false,    
		.. code-block:: lua

			IfAutoPot=false,  
		.. code-block:: lua
    	
			store.IfStore = false, 

	- disabled auto_ap, and script stops at lvl 8

		.. code-block:: lua

			maple.StopAtLevel = 8              -- stop at level = x
			maple.AutoAp = {str=0, dex=0, int = 0, luk = 0}  --auto ap


- ``Example_Warrior_10_30.lua:``

	.. warning::
 		This script will try to auto buy ``600`` orange pots and ``500`` blue pots. Make sure you have enough mesos, or lower the numbers.
	
	- bot will rotate between two hunt maps near ``Henesys``

		.. code-block:: lua

			maple.HuntMapList = {   
			{ID=100020000,SafeSpot={6, 65}}, 
			{ID=100030000,SafeSpot={-4096, -63}}, } 

	- it checks inventory every ``4`` mins and go to store when Equips are more than ``55``

		.. code-block:: lua
			
			store.CheckInventoryInterval = 4        

		.. code-block:: lua

			store.SellWhenEquipsMoreThan=55   


	- it will go to store when it's necessary, map = ``100000102``
      
		.. code-block:: lua

			store.StoreMap=100000102                    
			store.NPCLocation = {-351, 224}          

	- it will auto buy blue potion and orange potion at store

		.. code-block:: lua
			
			BuyPotionList={
         		HP={ID=2000001,BuyNum=600, LowerLimit = 20},  -- go the store if pot is below the LowerLimit
         		MP={ID=2000003,BuyNum=500, LowerLimit = 20},}

    - it will auto add ap, and script stops at lvl30

		.. code-block:: lua

			maple.StopAtLevel = 30              -- stop at level = x
			maple.AutoAp = {str=4, dex=1, int =0, luk = 0}  --auto ap


	.. note:: 
		Please read and try to understand all parameters!


- ``Example_Begin_Cleric_40+.lua:``


	.. note:: 

		Please read :ref:`supplement_maplist` about adding necessary manual portal for ``subway`` 

	- bot will rotate between two hunt maps in ``subway``

		.. code-block:: lua

			maple.HuntMapList = {
				{ID=103000104,SafeSpot={197, 74}},
				{ID=103000105,SafeSpot={-94, 13}}, } 

	- bot will use ``magic teleport`` skill and the key is set to ``SHIFT``.

		.. code-block:: lua

			TeleportKey = vk.VK_SHIFT,
			MagicTeleport = true,

    - it will go back to store by using ``return scroll`` (make sure you have plenty)

    	.. code-block:: lua

			maple.IfUseScrollToTown=true       -- use return scroll back to town 
			ReturnScrollID = 2030000            -- return scroll item ID

    - it will auto buff ``Magic Armor`` and ``Magic Guard`` at key ``A`` and ``D``

    	.. code-block:: lua

			IfAutoBuff=true,     
			CanBuffOnRope=true,             -- if you can buff on rope
			ReBuffAdvanceSec = 5,           --rebuff x sec before buff dies
			Buff={
				{ID=2001002, key =vk.VK_A}, 
				{ID=2001003, key =vk.VK_D}, }

    - it will not buy HP potion, because ``BuyNum=-1`` and ``LowerLimit=-1``. Instead, the ``Heal`` skill is put on ``Delete`` key and will be used.

    	.. code-block:: lua

			HpOnKey = vk.VK_DELETE,    
			MpOnKey = vk.VK_END,       -- only support QuickSlot (8 keys in total)
     
     	.. code-block:: lua

			BuyPotionList= {
				HP={ID=0000000,BuyNum=-1,  LowerLimit = -1},  
				MP={ID=2000006,BuyNum=800, LowerLimit = 20},}



