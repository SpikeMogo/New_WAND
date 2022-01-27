Get started
===============

.. _gather_files:

Gather files
------------

First, download the whole Release_ folder.

.. _Release: https://github.com/SpikeMogo/New_WAND/tree/main/Release/

You will get 

.. code-block:: text

	Release
	│
	├── Script
	├── bmps
	├── sound
	├── discord_bot_dependency
	├── ManualPortal.dat
	├── WAND_Disc.dll
	└── WAND_No_Disc.dll
	


In the folder structure above:

- ``Script`` contains example legit botting lua scripts
- ``bmps`` should contain .bmp files used in imagine recognition 
- ``sound`` contains few sound effect the WAND uses
- ``discord_bot_dependency`` contains dependencies for discord_bot integration
- ``ManualPortal.dat`` is where you add maplist/portal supplements
- ``WAND_Disc.dll`` is the WAND with discord_bot integration
- ``WAND_No_Disc.dll`` is the WAND without discord_bot integration


.. _installation:

Install
----------------
	
- Put ``bmps`` folder **inside** the game folder
- Put ``sound`` folder **inside** the game folder
- Put ``ManualPortal.dat`` file **inside** the game folder
- If you are going to use the ``discord_bot`` module, you need to copy all **DLLs** from the ``discord_bot_dependency`` folder to the game folder
- Put ``Script`` folder anywhere, but it's recommend to put it in the game folder
- Put ``WAND_Disc.dll`` and ``WAND_No_Disc.dll`` anywhere

.. note::

	``dlls`` in the ``discord_bot_dependency`` folder are from the D++ Extremely Lightweight C++ Discord Library: DPP_. You can find the dependencies here_.
			.. _DPP:  https://github.com/brainboxdotcc/DPP
			.. _here: https://github.com/brainboxdotcc/windows-bot-template

Injection
----------------

tool
^^^^^^^^^

It's recommend to use Extreme_Injector_ 
	.. _Extreme_Injector: https://github.com/master131/ExtremeInjector/releases


inject
^^^^^^^^^^
	- Open Extreme Injector in administrator mode
	- Select maple window process
	- Select ``WAND_Disc.dll`` or ``WAND_No_Disc.dll``
	- If you are injecting ``WAND_Disc.dll``, you can choose ``Standard Injection`` and ``Stealth Inject`` in the injector Settings. **Please note that you need to have discord_bot dependency dlls in the game folder**.
	- If you are injecting ``WAND_No_Disc.dll``, you can use same setting, and you can also choose ``Manual Map`` for improved security.

	.. warning::

		please don't check ``Hide Module`` and ``Erase PE`` in the Settings.

	.. note::
		``Manual Map`` may not work on some clients.


.. _Run:

Run
----------------

Inject WAND, play around a bit, choose your script and hit run.



.. note::

	Please check :ref:`script_example` and learn how to start trying example script


.. note::

	Please check :ref:`discord_bot` and learn how to use the discord bot integration

.. note::

	Please check :ref:`supplement_maplist` and learn how to add maplist supplements

.. note::

	Please run client(s) in Windows 7 compatability mode if packet decoder fails to hook


Enjoy!
----------------


