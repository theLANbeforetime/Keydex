# Keydex

Keydex converts each Mythic+ run into a CSV format and presents that information at the end of the dungeon via a pop-up text box that will allow the user to copy-paste the string into their spreadsheet of choice. Currently the add-on is very limited and there are many features (persistent database, table customization, in-game GUI) that have yet to be implemented.

In-Game pop-up post dungeon run:
 ![Example Pop-up](https://i.imgur.com/X4ec283.png)
 
## Get Started

To get started install the add-on by either unzipping the file in your Add-ons folder (World of Warcraft\/_retail_\Interface\Addons) or by using an addon manager such as the Curse Forge desktop application (recommended).

Once in game, simply run a Mythic+ key and at the end of the run a box will pop-up with a string in CSV format that will allow you to copy that runs information that you can then paste into your preferred spreadsheet.

Pasting into Google Sheets puts all the data into the same cell, to split the data into individual cells go to `Data` -> `Split text to columns` and it will separate the CSV into the proper columns.

Here is a template that will work as plug & play after you make a your own copy: [M+ Keydex Template](https://docs.google.com/spreadsheets/d/1zfLHkkAbd7d9lMAfayiqEU-79U6GN5YUMAq6N0X-LvM/edit?usp=sharing)

The format of the CSV is currently static and is as follows:
1. Current Date
2. Player Name
3. Dungeon Name
4. Keystone Level
5. Affix 1 (Xalatath's Bargain / Guile)
6. Affix 2 (Fortified or Tyrannical)
7. Affix 3 (Fortified or Tyrannical)
8. Affix 4 (Challenger's Peril)
9. Key Result (Timed/Deplete/Abandon)
10. Tank Spec
11. Healer Spec
12. First Dps Spec
13. Second Dps Spec
14. Third Dps Spec
15. IO at the Start
16. IO at the End

#### Note: Eventually the placement of the fields in the CSV output will be changeable by the user via the GUI.



