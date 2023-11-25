# Keydex

Keydex converts each Mythic+ run into a CSV format and presents that information at the end of the dungeon via a pop-up text box that will allow the user to copy-paste the string into their spreadsheet of choice. Currently the add-on is very limited and there are many features (persistent database, table customization, in-game GUI) that have yet to be implemented.

 
## Get Started

To get started install the add-on by either unzipping the file in your Add-ons folder (World of Warcraft\/_retail_\Interface\Addons) or by using an addon manager such as the Curse Forge desktop application (recommended).

Once in game, simply run a Mythic+ key and at the end of the run a box will pop-up with a string in CSV format that will allow you to copy that runs information that you can then paste into your preferred spreadsheet.

Pasting into Google Sheets puts all the data into the same cell, to split the data into individual cells go to `Data` -> `Split text to columns` and it will separate the CSV into the proper columns.

The format of the CSV is currently static and are as follows:
1. Current Date
2. Player Name
3. Dungeon Name
4. Keystone Level
5. Affix 1 (if key below 6)
6. Affix 2 (if key above 6 but less than 13 or blank)
7. Affix 3 (13 and up or blank)
8. Key Result (Timed/Deplete/Abandon)
9. Tank Spec
10. Healer Spec
11. First Dps Spec
12. Second Dps Spec
13 Third Dps Spec

#### Note: Eventually the placement of the fields in the CSV output will be changeable by the user via the GUI.



