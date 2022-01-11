Lua API
=========

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

.. function:: mobs = GetAllMobs()

	:return: a table of mobs

		.. code-block:: text

			mobs
			├── mob
			│   ├── x
			│   ├── y
			│   └── invisble
			├── mob
			│   ├── x
			│   ├── y
			│   └── invisble
			│ 
			│ 

	:example: 
		.. code-block:: lua

			-- print mob position
			mobs = GetAllMobs()
			for k, mob in paris(mobs) do
				print(mob.x," ", mob.y)
			end

---------------------------------------

.. function:: RefreshInventory(arg1)
	
	:param arg1: a table of string, contains any of these four options: "Equip", "Use", "Etc", "Cash"
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


