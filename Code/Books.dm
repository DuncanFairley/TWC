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
	canAuction = FALSE
	verb
		Read_()
			set src in view(2)
			usr<<browse("<body bgcolor=black><p><p><font color=white><FONT SIZE=6> <center>Basic COMC Textbook </center> </FONT><font color=red><font size=3>Max Quickstaff</font></font> <br><br> <Font size=4> This book is on the few, but powerful spells of COMC, or Care of Magical Creatures.  As you might guess,  this class deals with the various creatures found through out this game. <br><br>The spells: <br><br><Font size=3>Repellium- Kills the closest snake.  You receive no exp for using this spell to kill a snake.  This spell will not work on Summoned Snakes.<br><br>Serpensortia- Summons a snake.  WARNING: Don’t cast this spell in school, and don’t spam it.<br><br>Expecto Patronum- Kills the closest dementor.  You receive no exp for using this spell to kill a dementor.  This spell will not work on summoned Dementors.<br><br>Dementia- Summons a Dementor.  WARNING: Don’t cast this spell in school, and don’t spam it. <p><title>Care of Magical Creatures</title>","window=1")

obj/items/MonBookMon
	name = "Monster book of Monsters"
	icon='Books.dmi'
	icon_state="monsters"
	canAuction = FALSE
	verb
		Read_()
			set src in view(2)

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