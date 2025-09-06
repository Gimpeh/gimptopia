```
wget https://raw.githubusercontent.com/Gimpeh/gimptopia/refs/heads/main/QFT/setup.lua && setup
```

📌 General Purpose

This script is designed to run on an OpenComputers robot in GT:NH with an internet card and an AE system awareness card.
Its job is to monitor AE2 system stock levels of both fluids and solids.

- If a material falls below the desired stock threshold,
  the robot equips and uses the correct “data stick/card” (kept in its inventory).
- The card triggers the Quantum Field Treader (QFT) or equivalent system to generate more of that resource.
- The robot then waits until the AE system confirms the resource is restocked.

📌 Table Breakdown
tbl (the main table, “tb1”)

This maps card slot numbers (1–21) to lists of automatically tracked materials.
Each entry is either "solid", "fluid", or "mixed" (has both solids + fluids).

For example:

- [1] → Fluids: Molten Silicone Rubber, Molten Styrene-Butadiene Rubber, Molten Polyphenylene Sulfide, Molten Rubber
- [3] → Solids: Thorium-232 Dust, Uranium-233 Dust, Uranium-235 Dust, Plutonium-238 Dust, Plutonium-239 Dust
- [12] → Mixed: Solids (Stemcells) + Fluids (Raw Growth Catalyst Medium)
- [21] → Mixed: Solids (Shirabon Dust) + Fluids (Molten Eternity, Tachyon Rich Temporal Fluid)

👉 Default automatic stock goal = 10,000,000 units (amount = 10000000) for everything in tbl.

tbl2 (manual overrides, “tb12”)

This holds special manual stocking values for certain items.
Each entry overrides the 10M default with its own target stock.

Examples:

- Plutonium 241 Dust → card 3, stock 100,000
- Unknown Particle → card 11, stock 10,000
- Inert Naquadah Dust → card 13, stock 2,000
- Black Body Naquadria Supersolid → card 20, stock 3,000

tbl3 (priority manual fluids)

This handles special-case fluids that are more critical and have huge stock thresholds.

Examples:

- Growth Catalyst Medium → card 12, stock 500,000,000
- Mutated Living Solder → card 15, stock 1,000,000,000
- Xenoxene → card 18, stock 450,000,000
- Molten Radox Polymer → card 18, stock 150,000,000
- Molten Iridium → card 6, stock 1,000,000,000

📌 How the Script Works

1. Main Loop (runs forever)
  - Cycles through each entry in tbl, tbl2, and tbl3.
  - For each item, queries the AE system:
    - If solid → checks with getItemsInNetwork
    - If fluid → checks with getFluidsInNetwork
  - If stock is below the threshold, it:
    1. Finds the correct card number from the robot’s inventory.
    2. Equips & activates it (findCard).
    3. Waits until the AE system shows enough stock (wait_till_done).
2. Error Handling
  - Uses pcall to prevent crashes if something goes wrong.
  - Prints debug logs (e.g., "Not Enough In Stock", "No card found").
3. Cycle Timing
  - After one full loop, the robot sleeps for 300 seconds (5 min).
  - Between retries inside wait_till_done, it sleeps 10 seconds.

📌 Summary of Stocking Rules

- Default auto stock (tbl):
  Every listed solid/fluid = 10,000,000 units

- Manual stock (tbl2):
  Custom thresholds (e.g., 100k Pu-241, 2k inert Naquadah).

- Priority stock (tbl3):
  Huge thresholds (up to 1B) for critical fluids like Living Solder, Xenoxene, Molten Iridium.

✅ In short:
  This program makes the robot into a quantum field trading manager for your AE system. For the Q.F.T.
  It continuously ensures that critical dusts, molten polymers, catalyst fluids, and exotic fuels are always kept above target stock levels.
  The card numbers (1–21) in tbl link to data sticks that define which inputs create those outputs, while tbl2 and tbl3 are manual overrides for special cases. These nay need updated or changed based on new additions/removals of recipes. The code above can be pasted into the robot as needed. 
