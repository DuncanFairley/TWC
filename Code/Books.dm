/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

obj/items/COMCText
	name = "Care of Magical Creatures"
	icon='Books.dmi'
	icon_state="COMC"
	verb
		Read_()
			set src in view(2)
			usr<<browse("<body bgcolor=black><p><p><font color=white><FONT SIZE=6> <center>Basic COMC Textbook </center> </FONT><font color=red><font size=3>Max Quickstaff</font></font> <br><br> <Font size=4> This book is on the few, but powerful spells of COMC, or Care of Magical Creatures.  As you might guess,  this class deals with the various creatures found through out this game. <br><br>The spells: <br><br><Font size=3>Repellium- Kills the closest snake.  You receive no exp for using this spell to kill a snake.  This spell will not work on Summoned Snakes.<br><br>Serpensortia- Summons a snake.  WARNING: Don’t cast this spell in school, and don’t spam it.<br><br>Expecto Patronum- Kills the closest dementor.  You receive no exp for using this spell to kill a dementor.  This spell will not work on summoned Dementors.<br><br>Dementia- Summons a Dementor.  WARNING: Don’t cast this spell in school, and don’t spam it. <p><title>Care of Magical Creatures</title>","window=1")

obj/items/MonBookMon
	name = "Monster book of Monsters"
	icon='Books.dmi'
	icon_state="monsters"
	verb
		Read_()
			set src in view(2)
			//usr<<browse("<font size=6><font color=Green>Monster Book of Monsters</font><br><font size=4><font color=green><u>By: Max Quickstaff</u></font></font><br><br><font size=4><font color=red> This book serves as a basic guide for the monsters you will find throughout this world.  It will give their location, HP, and what you get for killing it.</font><br><br><font size=3>Puppy- Found just outside Hogwarts; 10HP; Gives 2 exp and 5 gold.<br><br>Wolf- Found in Student Housing, Forbidden Forest, Hogsmeade, Silverblood; 10 HP; Gives 2 exp and 5 gold.<br><br>Pixie- Found in Student Housing, Pixie Pit, upper section of the Forbidden Forest, Silverblood; 10HP; Gives 10 exp and 10 gold.<br><br>Troll- Found in Student Housing, Upper section of the Forbidden Forest; 200 HP; Gives 50 exp and 50 gold.<br><br>Demon Rat- Found in the Chamber of Secrets.; 100 HP; Gives 25 exp and 25 gold.<br><br>Snake- Found in Silverblood, Hogsmeade; 300HP; Gives 75 exp or the combined exp of what it’s killed and the amount of gold carried by what it‘s killed*.<br><br>Acromantula- Found in the Forbidden Forest; 500HP; Gives 70 exp and 70 gold.<br><br>Dementor- Found in the Forbidden Forest; 500HP; Gives 75 exp or the combined exp of whatever it’s killed and 75 gold + the gold of what it‘s killed.*<br><br>Fire Bat-  Found outside Silverblood; 600HP; Gives 80 exp and 80 gold; Shoots fire.<br><br>Fire Golem- Found outside Silverblood; 1000HP; Gives 85 exp and 85 gold; Shoots fire.<br><br>Basilisk- (A.K.A. Bassy)  Found in the Chamber of Secrets;  100k  HP; Gives 5k exp and 300 gold.<br><br><br>Summoned Creatures- Right now 2 creatures can be summoned, Dementors are summoned by Dementia and Snakes are summoned by Serpensortia.  Summoned Dementors and Summoned Snakes are not effected by their various instant kill spells (Expecto Patronum and Repellium, respectively).  If summoned snakes or dementors kill other creatures, they will become more powerful and give more exp when killed.  The summoned creatures start with the same HP as their wild counterparts. <br><br>Also, students will soon have a  new spell Avis.  This spell summons a bird which heals people around it.  The bird has 10k HP and is worth 1 exp and 75 gold. <br><br><br>*How snakes and dementors work- For the exp, if they haven‘t killed anything, the exp is their base value.  If they‘ve killed stuff, you add up the exp value of what they‘ve killed, but not their base value.  For gold, You add their base gold (for snakes it‘s 0) to the amount of gold dropped by whatever it‘s killed.  Eg.  If a dementor kills a troll and 3 pixies, you would get 80 exp (50+10+10+10) and 155 gold.  (75+50+10+10+10) </font> <p><title>Monster book of Monsters</title>","window=1")
			var/const/monsterbook = {" <html>   <head>      <title>Monsters Book of Monsters</title>   </head>   <body style="background-color:black;color:white;">      <center>         <h1 style="color:green;">Monster Book of Monsters</h1>         <table border="0" cellspacing="10">            <tr style="color:red;font-weight:bold;">               <td>Name:</td>               <td>Level:</td>               <td>Gold:</td>               <td>Experience:</td>               <td>Where to find:</td>	<td>Special Ability:</td>            </tr>
			<tr>               <td>Rat</td>               <td>10</td>               <td>12</td>               <td>36</td>               <td>Forbidden Forest, Tom's Cellar</td>            </tr>
			<tr>               <td>Demon Rat</td>               <td>50</td>               <td>24</td>               <td>37</td>               <td>Chamber of Secrets</td>            </tr>
			<tr>				<td>Pixie</td>               <td>100</td>               <td>60</td>               <td>65</td>               <td>Pixie Pit, Forbidden Forest</td>            </tr>
			<tr>               <td>Dog</td>               <td>150</td>               <td>42</td>               <td>40</td>               <td>Forbidden Forest</td>            </tr>
			<tr>               <td>Snake</td>               <td>200</td>               <td>36</td>               <td>39</td>               <td>Graveyard, Forbidden Forest</td>            </tr>
			<tr>               <td>Wolf</td>               <td>300</td>               <td>51</td>               <td>50</td>               <td>Forbidden Forest</td>            </tr>
			<tr>               <td>Troll</td>               <td>350</td>               <td>175</td>               <td>310</td>               <td>Graveyard</td>            </tr>
			<tr>               <td>Fire Bat</td>               <td>400</td>               <td>111</td>               <td>89</td>               <td>Silverblood</td>            </tr>
			<tr>               <td>Fire Golem</td>               <td>450</td>               <td>132</td>               <td>115</td>               <td>Silverblood</td>            </tr>
			<tr>               <td>Archangel</td>               <td>500</td>               <td>189</td>               <td>420</td>               <td>Silverblood's Maze</td>            </tr>
			<tr>               <td>Water Elemental</td>               <td>550</td>               <td>195</td>               <td>510</td>               <td>Silverblood's Maze</td>            </tr>
			<tr>               <td>Fire Elemental</td>               <td>600</td>               <td>204</td>               <td>530</td>               <td>Silverblood's Maze</td>            </tr>
			<tr>               <td>Wyvern</td>               <td>650</td>               <td>222</td>               <td>620</td>               <td>Silverblood's Maze</td>            </tr>
			<tr>               <td>Acromantula</td>               <td>700</td>               <td>90</td>               <td>76</td>               <td>Forbidden Forest</td>            </tr>
			<tr>               <td>Floating Eyes</td>               <td>800</td>               <td>165</td>               <td>209</td>               <td>Desert</td>		<td>Death Ball</td>	</tr>
			<tr>               <td>Basilisk</td>               <td>2000</td>               <td>6000</td>               <td>12000</td>               <td>Chamber of Secrets</td>		<td>Freeze</td>            </tr>
			<tr>               <td colspan="5" style="color:#FF8000;"><b> *Note: Gold and Experience values are approximate.</b></td>            </tr>         </table>      </center>   </body></html>"}
			usr << browse(monsterbook)

obj/Book_Shelf_
	icon='Desk.dmi'
	icon_state="1"
	density=1
	dontsave=1

	New()
		..()
		spawn(1)
			for(var/mob/Player/p in Players)
				if(p.Gm)
					Players << "Special teleport bookshelf found in [x],[y],[z] on [loc]. Please delete it."