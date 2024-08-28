These are robot scripts for controlling the Space Miner Modules and Space Pump modules of the Space Elevator Multiblock.
Designed for the Gregtech New Horizons Modpack.

Normally, there is no way for a computer to set configurations on these modules. 
Meaning that for example, Using one Pump module to pump every fluid would be impossible without manually changing the configuration values yourself.

Then a very wise and clever deity gave us https://discord.com/channels/181078474394566657/1266797319974813747 that we might better ourselves.

My implentation is based completely the linked script. Providing the same type of functionality, and requiring basically the same setup. Modified slightly for items vs its fluid counterpart.
Mine deals with the miner which requires an additional cover on the bottom of the controller set to emit redstone when not running (To signal the robot that its safe to change the configurations)
Each tech tech memory card requires a paired applied energistics memory card with the same exact name. The ae memory card is for setting the requisite items for miner operations in a stocking input bus. 
Naming conventions are the same. As are the names requirements.
You can use the same robot as specified in the linked pumps description.
However, consider stacking additional inventory_upgrades, as there are way more ores than fluids.


This script is brand new and as of this writing, never even been parsed in an opencomputers environment. Use at your own risk! It could fail completely.

It will be extensively tested and properly documented in the near future.
