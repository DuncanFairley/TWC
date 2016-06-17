The Wizards' Chronicles - README
http://wizardschronicles.com
--------------------------------------------------------------------------------
The Wizards' Chronicles is a 2D RPG written with the BYOND engine 
(http://byond.com). 

License
--------------------------------------------------------------------------------
The Wizards' Chronicles is Copyright © 2014 Duncan Fairley, and is licensed
under the GNU Affero General Public License, version 3. The full license is
included in the distribution. For an easier understanding of what the license
entails, see:
http://www.tldrlegal.com/license/gnu-affero-general-public-license-v3-(agpl-3.0)
If you have any questions about the license, email
murrawhip at wizardschronicles.com


Requirements
--------------------------------------------------------------------------------
BYOND (http://www.byond.com/download/)
The following libraries:
http://www.byond.com/developer/Stephen001.EventScheduling
http://www.byond.com/developer/Audeuro.INIReader2
http://www.byond.com/developer/Theodis.Pathfinder
http://www.byond.com/developer/Deadron.Basecamp
http://www.byond.com/developer/Rotem12.ColorMatrix

Ensure you put the source in a folder named TWC, as your DME name must match the
name of the folder it's in.


Notes
--------------------------------------------------------------------------------
LummoxJR.DmiFontsPlus, LummoxJR.SwapMaps, Theodis.Region and Dantom.DB are
included in the distribution due to modifications required and are copyright
their respective owners.

Clans are currently not available as parts of the online component need to be
made secure.
Certain logging features inside TWC such as player logs, associated keys,
event logs, etc. require a MySQL database. If you do not want these features,
leave mysql_enabled set to false in the config.ini.
The MySQL table schema is in schema.sql.