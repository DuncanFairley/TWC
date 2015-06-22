
mob/TalkNPC/merchant

	New()
		..()

		var/f = pick("Soxlax", "Zotold", "Noik", "Nixelee", "Zotgbles", "Jarex", "Filax", "Rizlax", "Zeeard", "Zeemo")
		var/l = pick("", " Goldnose", " Silvernose", " Saltmine", " Scrollgrinder", " Moneygear", " Saltytongue", " Steamrocket", " Sharpfingers", " Boomknob")

		name = "[f][l]"

		icon_state = "goblin[rand(1,3)]"

	Talk()
		set src in oview(3)
		var/mob/Player/p = usr
		p.auctionOpen()

proc
	init_auction()
		var/Event/Auction/e = new
		scheduler.schedule(e, world.tick_lag * 3 * 600)

	auctionBidTime()
		if(auctionItems)
			for(var/auction/a in auctionItems)
				if(!a.item)
					auctionItems -= a
					continue
				if(world.realtime - a.time >= 2592000 || !a.item.canAuction) // 3 days
					if(a.bid && a.bidder)
						mail(a.bidder, infomsg("Auction: You won the auction for the [a.item.name]."),     a.item)
						mail(a.owner,  infomsg("Auction: Your [a.item.name] was sold during an auction."), a.minPrice)

						goldlog << "[time2text(world.realtime,"MMM DD - hh:mm")]: (Bid) [a.owner] sold [a.item.name] to [a.bidder] for [a.minPrice]<br />"
					else
						mail(a.owner,  errormsg("Auction: The [a.item.name] auction expired."), a.item)
					a.item = null
					auctionItems -= a
					if(!auctionItems.len) auctionItems = null

var/list
	mailTracker
	auctionItems

mail
	var
		message
		content

	New(i_Message, i_Content)
		..()
		content = i_Content
		message = i_Message

	proc/send(mob/Player/i_Player)
		if(message)
			i_Player << message
		if(content)
			if(isnum(content))
				i_Player << infomsg("[comma(content)] gold was sent to your bank.")
				i_Player.goldinbank += content
			else
				var/obj/o = content
				i_Player << infomsg("[o.name] was sent to you.")
				o.loc = i_Player
				i_Player.Resort_Stacking_Inv()



proc/mail(i_Ckey, i_Message, i_Content)
	var/mail/m = new/mail(i_Message, i_Content)

	for(var/mob/Player/p in Players)
		if(p.ckey == i_Ckey)
			m.send(p)
			return

	if(!mailTracker) mailTracker = list()

	if(i_Ckey in mailTracker)
		if(islist(mailTracker[i_Ckey]))
			mailTracker[i_Ckey] += m
		else
			mailTracker[i_Ckey] = list(mailTracker[i_Ckey], m)
	else
		mailTracker[i_Ckey] = m

mob/Player/proc/checkMail()
	if(ckey in mailTracker)
		if(islist(mailTracker[ckey]))
			for(var/mail/m in mailTracker[ckey])
				m.send(src)
		else
			var/mail/m = mailTracker[ckey]
			m.send(src)
		mailTracker -= ckey

auction
	var

		bid
		bidder
		buyout
		minPrice
		buyoutPrice
		obj/items/item
		time
		owner



	Topic(href, href_list[])
		.=..()
		var/mob/Player/p = usr
		if(!(src in auctionItems)) return

		if(!src || !p) return
		if(!src.item)
			auctionItems -= src
			if(bidder)
				mail(bidder, errormsg("<b>Auction:</b> The auction for the [item.name] was cancelled."), minPrice)

			return


		if(href_list["action"] == "bidAuction")

			if(bid && owner != p.ckey && bidder != p.ckey)
				var/price = max(round(minPrice + (minPrice/10), 1), 1)
				if(p.gold >= price)

					if(bidder)
						mail(bidder, errormsg("<b>Auction:</b> You were outbid for the [item.name] auction."), minPrice)

					bid++
					bidder   = p.ckey
					minPrice = price
					p.gold  -= price
					p.auctionBuild()
				else
					p << errormsg("You don't have enough money, the item costs [comma(price)] gold, you need [comma(price)] more gold.")

		else if(href_list["action"] == "buyoutAuction")
			if(buyout && owner != p.ckey)

				if(p.gold >= buyoutPrice)
					p.gold -= buyoutPrice

					if(bid && bidder)
						mail(bidder, errormsg("<b>Auction:</b> The [item.name] auction was bought out at the auction, your bid is cancelled."), minPrice)

					var/taxedGold = round(buyoutPrice - (buyoutPrice/20), 1)
					mail(owner, infomsg("<b>Auction:</b> [item.name] was bought at the auction."), taxedGold)
					goldlog << "[time2text(world.realtime,"MMM DD - hh:mm")]: (Buyout) [owner] sold [item.name] to [p.name] ([p.ckey]) ([p.client.address]) for [buyoutPrice]<br />"

					auctionItems -= src
					if(!auctionItems.len) auctionItems = null
					p << infomsg("<b>Auction:</b> You bought [item.name] for [buyoutPrice] gold.")
					item.loc = p
					item = null
					p.Resort_Stacking_Inv()
					p.auctionBuild()
				else
					p << errormsg("You don't have enough money, the item costs [comma(buyoutPrice)] gold, you need [comma(buyoutPrice - p.gold)] more gold.")


		else if(href_list["action"] == "removeAuction")
			if(owner == p.ckey)
				auctionItems -= src
				if(!auctionItems.len) auctionItems = null

				if(bid && bidder)
					mail(bidder, errormsg("<b>Auction:</b> The auction for the [item.name] was cancelled."), minPrice)

				p << infomsg("<b>Auction:</b> You removed [item.name] from auction.")
				p.auctionBuild()
				item.loc = p
				item = null
				p.Resort_Stacking_Inv()



mob/Player
	var/tmp
		auction/auctionInfo
		auctionCount = 0

	proc
		auctionBuild()
			auctionCount = 0
			var/count = 2
			if(auctionItems)

				winset(src, null, "Auction.gridAuction.cells=6x[auctionItems.len + 2];Auction.gridAuction.style='body{text-align:center;background-color:#cceeff;color:#6f81ff;}'")
				if(!auctionItems) return

				var/list/filters = list("Auction.buttonClothing" = /obj/items/wearable,
				                        "Auction.buttonShoes"    = /obj/items/wearable/shoes,
				                        "Auction.buttonScarves"  = /obj/items/wearable/scarves,
				                        "Auction.buttonWands"    = /obj/items/wearable/wands,
				                        "Auction.buttonTitle"    = /obj/items/wearable/title,
				                        "Auction.buttonOther",
				                        "Auction.buttonOwned",
				                        "Auction.buttonNotOwned")

				var/qry = ""
				for(var/f in filters)
					qry += "[f];"

				var/list/options = params2list(winget(src, qry, "is-checked"))

				var/option
				for(var/i = 1 to 6)
					var/o = options[i]
					if(options[o] == "true")
						option = copytext(o, 1, -11)
						break

				for(var/i = 1 to auctionItems.len)
					var/auction/a = auctionItems[i]
					if(!a.item) continue
					if(a.owner == ckey)
						auctionCount++

					if(option)
						if(option == "Auction.buttonOther")
							if(istype(a.item, /obj/items/wearable)) continue
						else if(!istype(a.item, filters[option]))   continue

					if(options["Auction.buttonOwned.is-checked"]    == "false" && a.owner == ckey) continue
					if(options["Auction.buttonNotOwned.is-checked"] == "false" && a.owner != ckey) continue

					count++

					src << output(a.item,      "Auction.gridAuction:1,[count]")
					src << output(a.item.desc, "Auction.gridAuction:2,[count]")

					if(a.buyout)
						src << output("<a href=\"?src=\ref[a];action=buyoutAuction\">Buyout</a> [comma(a.buyoutPrice)]", "Auction.gridAuction:3,[count]")
					else
						src << output(null, "Auction.gridAuction:3,[count]")

					if(a.bid)
						if(a.bidder == ckey)
							src << output("You're at lead bidding [comma(a.minPrice)] gold. (Bids: [a.bid - 1])", "Auction.gridAuction:4,[count]")
						else
							src << output("<a href=\"?src=\ref[a];action=bidAuction\">Bid</a> [comma(round(a.minPrice + (a.minPrice / 10), 1))] (Bids: [a.bid - 1])", "Auction.gridAuction:4,[count]")
					else
						src << output(null, "Auction.gridAuction:4,[count]")

					var/days = round((2592000 - (world.realtime - a.time)) / 864000, 1)
					src << output("[days] days remaining", "Auction.gridAuction:5,[count]")

					if(a.owner == ckey)
						src << output("<a href=\"?src=\ref[a];action=removeAuction\">Remove</a>", "Auction.gridAuction:6,[count]")
					else
						src << output(null, "Auction.gridAuction:6,[count]")

				winset(src, null, "Auction.gridAuction.cells=6x[count]")

			if(count < 3)
				winset(src, null, "Auction.gridAuction.cells=6x2")

		auctionOpen()
			auctionInfo = new(src)
			auctionBuild()

			src << output(null, "Auction.gridAuctionAddItem")

			winset(src, "Auction.gridAuction", "style='body{text-align:center;background-color:#0b81ff;color:#a8e2ff;}'")
			src << output("<b>Item</b>", "Auction.gridAuction:1,1")
			src << output("<b>Description</b>", "Auction.gridAuction:2,1")
			src << output("<b>Buyout (Click Buyout to buy)</b>", "Auction.gridAuction:3,1")
			src << output("<b>Bid (Click Bid to bid)</b>", "Auction.gridAuction:4,1")
			src << output("<b>Time Remaining</b>", "Auction.gridAuction:5,1")
			src << output(null, "Auction.gridAuction:6,1")


			winshow(src, "Auction", 1)

		auctionError(var/msg)

			winset(src, "Auction.labelError", "text=\"[msg]\"")


	verb
		auctionAdd()
			set name = ".auctionAdd"

			if(auctionInfo && auctionInfo.item)
				var/list/options = params2list(winget(src, "Auction.buttonBid;Auction.buttonBuyout;Auction.inputMinPrice;Auction.inputBuyoutPrice;Auction.button2Days;", "is-checked;text;"))

				var/bid         = options["Auction.buttonBid.is-checked"]    == "true"
				var/buyout      = options["Auction.buttonBuyout.is-checked"] == "true"

				if(bid + buyout == 0)
					auctionError("You to select either bid, buyout or both.")
					return

				var/minPrice
				var/buyoutPrice

				if(bid)
					minPrice    = text2num(options["Auction.inputMinPrice.text"])

					if(!minPrice || !isnum(minPrice) || minPrice < 0 || minPrice > 1000000000)
						auctionError("Invalid minimum price.")
						return
					minPrice = round(minPrice, 1)

				if(buyout)
					buyoutPrice = text2num(options["Auction.inputBuyoutPrice.text"])

					if(!buyoutPrice || !isnum(buyoutPrice) || buyoutPrice < 0 || buyoutPrice > 1000000000)
						auctionError("Invalid buyout price.")
						return
					buyoutPrice = round(buyoutPrice, 1)

				auctionInfo.bid         = bid
				auctionInfo.buyout      = buyout
				auctionInfo.minPrice    = minPrice
				auctionInfo.buyoutPrice = buyoutPrice
				auctionInfo.time        = world.realtime
				auctionInfo.owner       = ckey

				if(options["Auction.button2Days.is-checked"] == "true")
					auctionInfo.time -= 864000

				if(auctionItems)
					auctionItems += auctionInfo
				else
					auctionItems = list(auctionInfo)

				auctionInfo = new(src)
				src << output(null, "Auction.gridAuctionAddItem")
				auctionError("")
				auctionBuild()

		auctionClosed()
			set name = ".auctionClosed"
			if(auctionInfo)
				if(auctionInfo.item)
					contents += auctionInfo.item
					auctionInfo.item = null
					Resort_Stacking_Inv()

				auctionInfo = null


		auctionRefresh()
			set name = ".auctionRefresh"
			if(auctionInfo)
				auctionBuild()


obj/items
	var/canAuction = TRUE

	MouseDrop(over_object,src_location,over_location,src_control,over_control,params)
		.=..()
		var/mob/Player/P = usr
		if((src in usr) && P.auctionInfo)
			if(over_control == "Auction.gridAuctionAddItem" && src != P.auctionInfo.item)
				if(dropable && canAuction)

					if(P.auctionInfo.item)
						P.contents += P.auctionInfo.item

					if(src in usr:Lwearing)
						src:Equip(usr)
					else if(istype(src, /obj/items/lamps) && src:S)
						var/obj/items/lamps/lamp = src
						lamp.S.Deactivate()

					if("ckeyowner" in vars)
						src:ckeyowner = null
					P << output(src, "Auction.gridAuctionAddItem")
					P.auctionInfo.item = src
					P.contents -= src
					P.Resort_Stacking_Inv()
				else
					P << errormsg("This item can't be used in auction.")

	Click(location,control,params)
		var/mob/Player/P = usr
		if(P.auctionInfo && P.auctionInfo.item == src)
			P << output(null, "Auction.gridAuctionAddItem")
			P.auctionInfo.item = null
			P.contents += src
			P.Resort_Stacking_Inv()
		else
			..()
