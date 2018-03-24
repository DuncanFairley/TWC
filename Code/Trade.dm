/*
 * Copyright � 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
trading
	var
		mob/Player/parent
		mob/Player/with
		list/items = list()
		accept = 0
		y = 1

	New(mob/Player/parent, mob/Player/with)
		..()
		src.parent = parent
		src.with   = with
		winset(parent, null, {"Trade.Name1.text="[formatName(parent,0)]";Trade.Name2.text="[formatName(with,0)]";Trade.GoldInput.text=0"})
		winshowCenter(parent, "Trade")

	proc
		Deal(end = 0)

			for(var/obj/O in items)
				O.Move(with)
			items = list()

			if(!end) with.trade.Deal(1)

			parent.Resort_Stacking_Inv()


		Clean(end = 0)
			for(var/obj/O in items)
				O.Move(parent)

			if(!end && with && with.isTrading()) with.trade.Clean(1)

			with = null

			if(parent)
				if(parent.client)
					winset(parent, null, {"Trade.is-visible=false;Trade.grid1.background-color=white;Trade.grid2.background-color=white;Trade.grid1.cells=0x0;Trade.grid2.cells=0x0;Trade.gold1.text=0;Trade.gold2.text=0"})
					parent.Resort_Stacking_Inv()
				parent.trade = null
				parent = null

mob/Player
	var
		tmp/trading/trade
		TradeBlock = 0

	proc
		isTrading()
			return trade && trade.with
	verb
		Trade()
			set src in oview(2)
			set category = null
			var/mob/Player/trader = usr

			if(TradeBlock) //|| ("[formatName(src)]" in blockedpeeps))
				usr << errormsg("[src] does not wish to trade at the moment.")
				return

			if(isTrading())
				usr << errormsg("[src] is already trading.")
				return

			if(trader.isTrading())
				usr << errormsg("You are already trading.")
				return

			trader.trade = new(trader, src)
			trade        = new(src, trader)


		ATrade(action as text)
			set hidden = 1
			if(!trade) return
			if(!trade.with)
				trade.Clean()
				return

			if(action == "Close")
				trade.Clean()

			else if(action == "Done")
				if(trade.accept == 1)
					trade.accept = 0
					winset(src, "Trade.grid1", "background-color=white")
					winset(trade.with, "Trade.grid2", "background-color=white")
				else
					trade.accept = 1
					if(trade.with.trade.accept)
						var/log = FALSE
						var/html = ""
						if(trade.items.len > 0 || trade.with.trade.items.len > 0)
							log = TRUE
							html += "<tr><td><ul>"
							for(var/obj/i in trade.items)
								html += "<li>" + i.name + (istype(i, /obj/items/scroll) ? " (scroll)" : "") + "</li>"

							html += "</ul></td><td>"

							for(var/obj/i in trade.with.trade.items)
								html += "<li>" + i.name + (istype(i, /obj/items/scroll) ? " (scroll)" : "") + "</li>"

							html += "</ul></td></tr>"
						if(log)
							html = {"
<table border="1">
	<tr>
		<td colspan="2"><center>[time2text(world.realtime,"MMM DD YYYY- hh:mm")]</center></td>
	</tr>
		<td>[src]([src.key])([src.client.address])</td>
		<td>[trade.with]([trade.with.key])([trade.with.client.address])</td>
	</tr>
	[html]
</table><br>
"}
							goldlog << html


						trade.Deal()
						trade.Clean()
					else
						winset(src, "Trade.grid1", "background-color=green")
						winset(trade.with, "Trade.grid2", "background-color=green")


obj/items

	MouseDrop(over_object,src_location,over_location,src_control,over_control,params)
		var/mob/Player/P = usr
		if((src in usr) && P.isTrading())
			if(over_control == "Trade.grid1" && !(src in P.trade.items))
				if(!P.trade.accept && !P.trade.with.trade.accept)
					if(dropable)
						if(stack <= 1 && (src in usr:Lwearing))
							src:Equip(usr)
						else if(istype(src, /obj/items/lamps) && src:S)
							var/obj/items/lamps/lamp = src
							lamp.S.Deactivate()

						Unmacro(P)

						var/obj/items/i = stack > 1 ? Split(1) : src

						if("ckeyowner" in i.vars)
							src:ckeyowner = null
						winset(P, null, "Trade.grid1.cells=1x[P.trade.y];Trade.grid1.current-cell=1x[P.trade.y]")
						P << output(i, "Trade.grid1")
						winset(P.trade.with, null, "Trade.grid2.cells=1x[P.trade.y];Trade.grid2.current-cell=1x[P.trade.y]")
						P.trade.with << output(i, "Trade.grid2")
						P.trade.items += i
						P.trade.y++
						P.contents -= i
						P.Resort_Stacking_Inv()
					else
						P << errormsg("This item can't be dropped")
				else
					P << errormsg("You can't change terms of the trade while one of you already accepted.")
		..()

	Click(location,control,params)
		var/mob/Player/P = usr
		if(P.isTrading() && (src in P.trade.items))
			if(!P.trade.accept && !P.trade.with.trade.accept)
				P.trade.y--
				P.trade.items -= src

				Move(P)
				var/list/p = params2list(params)

				var/cell = text2num(findtext(p["drop-cell"], ",") ? copytext(p["drop-cell"], 3) : p["drop-cell"])

				if(P.trade.y-1 == 0)
					winset(P, "Trade.grid1", "cells=0")
					winset(P.trade.with, "Trade.grid2", "cells=0")
				else
					winset(P, null, "Trade.grid1.current-cell=1x[cell];Trade.grid1.cells=1x[P.trade.y-1]")
					winset(P.trade.with, null, "Trade.grid2.current-cell=1x[cell];Trade.grid2.cells=1x[P.trade.y-1]")

					if(cell <= P.trade.items.len)
						P << output(P.trade.items.len == 0 ? null : P.trade.items[P.trade.items.len], "Trade.grid1")
						P.trade.with << output(P.trade.items.len == 0 ? null : P.trade.items[P.trade.items.len], "Trade.grid2")
				P.Resort_Stacking_Inv()
			else
				P << errormsg("You can't change terms of the trade while one of you already accepted.")
		else
			..()


