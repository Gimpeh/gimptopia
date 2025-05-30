# Gimp's Autominer

We all know what we are here for... Level maintaining Ore products... IN SPACE!

----------------------------------------------------

# Setup

## Building the Robot

Robots aren't found in NEI with any recipe.
They are made by placing an opencomputers `Computer Case` in an opencomputers `Electronics Assembler`

![image](https://github.com/user-attachments/assets/71b19cda-bcef-4dd4-9295-83432b40bbf8)

The Electronics Assembler can be powered by connecting to an ME system with AE2 Cable

![image](https://github.com/user-attachments/assets/3e91b8b0-94c9-41a1-be4b-d4a3cb0e5b58)


Or use EU by connecting a **gt _CABLE_ or gt _WIRE_**. **NO TRANSFORMERS, BATTERY BUFFERS, OR ANYTHING ELSE!** although you might use want them upstream from assembler on the wire for actually providing power on the wire.

Yes the wire still needs power.

![image](https://github.com/user-attachments/assets/d75daf9c-0f7c-4112-b2fa-20f42dd40196)

### Robot Component List
**Computer Case (Tier 3)** <-- Put this inside of the electronics Assembler. 

You now have this

![image](https://github.com/user-attachments/assets/61132666-a367-43ae-9ffa-24f5641655b0)

* **Tier 3 Accelerated Processing Unit**
* **EEPROM (Lua Bios)**
* **Keyboard**
* **Screen (Tier 1)**
* **Redstone Card (Tier 2)**
* **Memory Module (Tier 3.5)** *Just the one is fine*
* **Internet Card**
* **Disk Drive**
* **ME Upgrade** ***THE BLUE ONE!!! - #3 - item code 10640:2***
* **Inventory Controller Upgrade**
* **3 x Inventory Upgrade (or more)**
* **Hard Disk Drive (Tier 1)**

------------------------------------

* *Optionally - Linked Card* **If you do this, put the partner card somewhere safe, where you wont lose it. And rename it in an anvil.**
   - Only useful if you're planning on derping with any future systems. This robit is sufficient as a set and forget system as is.

Do what you want in the rest of the slots.. Including nothing. If you don't know what you want but think you want something... 

* Upgrade Container (Tier 3)
* Upgrade Container (Tier 2)


### Finishing Touches
**DOUBLE CHECK THAT YOU HAVE ALL COMPONENTS!**

**All _NECESSARY_ Components** are Included in the image below.

![image](https://github.com/user-attachments/assets/833cdef7-285e-4740-8160-7fb01c3c4b26)
 

Click The Play button in the Electronics Assembler and Let It Craft! *This still takes a little while, so we'll come back for it, don't worry*

## Workspace

### Required Items

Now you need to obtain the following;
* **charger** <-- Of the OpenComputers variety
* **ME Wireless Access Point**
* **Machine Controller Cover**
* **Activity Detector Cover**
* **4x Red Alloy Wire**
* **lever** *or equivelant*

### Required Placements
*recommended if we're being completely honest*

The only thing that is not shown in the pictures below are the covers. The machine controller cover goes on the top side of the block.
The activity detector cover goes on the right side (so that it will output to the red alloy wire on the side)

![image](https://github.com/user-attachments/assets/385fad25-9c17-4779-80e1-3553c2795b60)
![image](https://github.com/user-attachments/assets/8ea9d83d-fd1a-4a81-951f-25ae80999528)

--------------------------

Note the stocking Input Bus In the below Picture.

![image](https://github.com/user-attachments/assets/54330c8b-1f87-4fcf-9a8f-9f4dc07ce682)


-------------------------

### Covers

![image](https://github.com/user-attachments/assets/a187f189-a21e-49d9-80c5-5c46292d7c13)
![image](https://github.com/user-attachments/assets/b06f5fba-037f-439c-8f85-18f8207a6d9b)


------------------------


It can technically be placed in other locations.. but only if you know ***EXACTLY*** you are doing.

**If you decide to go with a different Workspace Configuration, I am not helping you troubleshoot.** 

**I will need a Screenshot of the environment to actually be capable of Troubleshooting most Issues**

--------------



Every object's placement is visible in those pictures. 

Every element contained within the pictures is **required**.

### Required Configurations

The **AE2 Wireless Access Point** needs to be on the ME network you are using to store the level maintained Items.

> [!NOTE]
> **This is the SAME NETWORK the Robot Needs to get added to via an AE Security Terminal**.
> ***YOU MAY NOT REMOVE THE SECURITY TERMINAL AFTER ADDING THE ROBOT TO IT OR IT BECOMES DISCONNECTED***

## Preparing The Robot

### Required Items

* 1 **Paremetrizer Memory Card (Copy Mode)** Per Item you want Maintained.
* 1 **Data Stick** Per Item you want Maintained
* **OpenOs (Operating System)** <-- This is a green floppy disk.
* **Anvil** *or equivelant*

### Linking the Robot to the ME System

This is the same as linking an AE Wireless terminal to the system. Open the Security Terminal and shift right click the Robot.

![image](https://github.com/user-attachments/assets/a013f349-6b40-400e-bc50-bd3e1546904d)

See how the robot is in the output? That means its linked.

>[!IMPORTANT]
>This needs to be done on the same network you are storing fluids on, and have the wireless access point set to.
>*Actually.. It needs to be done on a network with storage Access to the network you are storing the fluids on.*
>*The amount considered to be in stock will be based entirely on what is accessible in the network we connect the robot to however*

### Installing an Operating System

1. Place the Robot in its new Home.

![image](https://github.com/user-attachments/assets/70e3da83-ecd3-4a29-8fb5-e409a9a3ca59)

2. Turn on the charger by activating its lever. Green Crap should start be displayed around the Robot. And the charger lights up.
3. Right click the robot, and shift right click the OpenOS floppy. It should now be here; (without the memory cards at this point)

![image](https://github.com/user-attachments/assets/2afb9e26-5747-465c-8444-1c68c0171c82)

4. Hit the power button, wait for it reach the command line, type **install**, press enter, type **y** at the prompt, press enter.
5. It will ask you if you want to reboot after installing. confirm the reboot. OpenOS is now installed.

### Preparing the Memory Cards

1. Configure the space mining module
2. Right Click the Space Mining Module with one of the Memory Cards in hand. It has now copied the Modules Configurations.
3. Look at the sky so that you aren't going to interact with any Blocks. Shift right click the air with the memory card in hand.
   - it is now in paste mode. you should confirm that it sets the modules configurations at this point.
**THE FOLLOWING NEEDS TO BE EXACT**
4. Rename the Memory Card in an Anvil.
   - This is a case sensitive exact match to what shows up when you highlight over the relevant gas in NEI
   - `<Label of the Item you are trying to keep level maintained>: <amount to keep in stock>`
   - `Iron Ingot: 1000000000`      <-- example. Note that we are probably autoprocessing ores, so it would be silly to try to keep those stocked.
   - the colon comes directly after the gas name, a space, and then the number.
5. Store the memory card in the robot.
6. Configure the stocking input hatch
7. Left click with the data stick.
8. Name the data stick the same thing you named the parametizer card.
9. store the data stick in the robot. 
10. Repeat for each material you desire.

## Install and Run

### Install

```
wget https://raw.githubusercontent.com/Gimpeh/gimptopia/refs/heads/main/Space_Elevator_Controllers/miner/better_miner.lua && install
```
### Run

It can now be run

-------------------------------

```
better_miner
```
