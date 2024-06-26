
obj/ScreenMapText
	appearance_flags = RESET_COLOR|RESET_TRANSFORM|NO_CLIENT_COLOR|PIXEL_SCALE
	maptext_width = 320
	maptext_y = 8
	maptext_x = -152
	alpha = 50
	pixel_y = -32
	mouse_opacity = 0

obj/hud/ScrollMessage
	screen_loc = "EAST-5,CENTER-10"

	var/tmp/mob/Player/parent
	mouse_opacity = 0

	var/count = 0

	New(Loc, mob/Player/p)

		screen_loc = Loc
		p.client.screen += src
		parent = p

	proc/Display(var/text, var/hex=null, var/state=null, var/time=50, var/prio=1)
		set waitfor = 0

		if(count >= 15 && prio <= 3) return
		if(count >= 10 && prio <= 2) return

		count++

		var/obj/ScreenMapText/o = new
		o.maptext = "<b><span style=\"color:[parent.mapTextColor];\">[text]</span></b>"

		if(hex)
			var/obj/custom/back = new /obj/custom { icon = 'black50.dmi'; icon_state = "white" }
			back.color      = hex

			var/matrix/m = matrix()
			m.Scale(11,1)

			back.transform = m

			o.underlays += back

		for(var/obj/old in vis_contents)
			animate(old, pixel_y = old.pixel_y + 32, time = 6, flags=ANIMATION_PARALLEL)

		vis_contents += o
		animate(o, pixel_y = 0, alpha = 255, time = 6)

		sleep(time+6)

		animate(o, alpha = 0, time = 10, flags=ANIMATION_PARALLEL)
		sleep(10)
		vis_contents -= o
		count--


obj/hud/TextMessage
	screen_loc    = "CENTER,CENTER+5"
	icon          = 'black50.dmi'
	icon_state    = "white"
	color         = "#111"
	mouse_opacity = 0

	var/tmp/count = 5

	New(Loc, mob/Player/p, message, time=30)
		set waitfor = 0

		p << infomsg(message)

		var/obj/o = new
		o.appearance_flags = RESET_COLOR|RESET_TRANSFORM|NO_CLIENT_COLOR|PIXEL_SCALE
		o.layer = layer + 1
		o.plane = 2

		if(p.mapTextColor != "#ffffff")
			o.maptext = {"<b style="font-size:12px;color:[p.mapTextColor]">[message]</b>"}

			var/rr = 255 - hex2value(copytext(p.mapTextColor, 2, 4))
			var/gg = 255 - hex2value(copytext(p.mapTextColor, 4, 6))
			var/bb = 255 - hex2value(copytext(p.mapTextColor, 6, 8))
			color = rgb(rr, gg, bb)
		else
			o.maptext = {"<b style="font-size:12px">[message]</b>"}

		var/pixelsize = length(message) * 11

		o.maptext_width = pixelsize
		o.maptext_x     = -ceil(pixelsize/3)
		o.maptext_y     = 6

		var/matrix/m = matrix()
		m.Scale(ceil(pixelsize / 32), 1)

		transform = m

		var/list/l = list()
		for(var/obj/hud/TextMessage/t in p.client.screen)
			if(count == t.count)
				count++
			else
				l += t.count
		while(count in l)
			count++

		if(count > 10) return

		screen_loc = "CENTER,CENTER+[count]:[count*4]"

		src.overlays += o
		p.client.screen += src

		alpha = 0
		animate(src, alpha = 255, time = 4)

		sleep(time + 4)
		if(p)
			animate(src, alpha = 0, time = 4)
			sleep(4)
			if(p) p.client.screen -= src

obj/hud/TextMessageExp
	screen_loc = "WEST+1,CENTER"
	icon       = 'hud.dmi'
	mouse_opacity = 0

	appearance_flags = RESET_COLOR|RESET_TRANSFORM|NO_CLIENT_COLOR|PIXEL_SCALE

	var/tmp/count = 0

	New(Loc, mob/Player/p, message, state, time=4)
		set waitfor = 0

		icon_state = state

		if(p.mapTextColor != "#ffffff")
			maptext = {"<b style="font-size:12px;color:[p.mapTextColor]">[message]</b>"}
		else
			maptext = {"<b style="font-size:12px">[message]</b>"}

		var/pixelsize = length(message) * 11

		maptext_width = pixelsize
		maptext_x     = 32
		maptext_y     = 5

		var/list/l = list()
		for(var/obj/hud/TextMessageExp/t in p.client.screen)
			if(count == t.count)
				count++
				if(count > 8) return
			else
				l += t.count
		while(count in l)
			count++

		screen_loc = "WEST+1,CENTER+[count]:[count*4]"

		p.client.screen += src

		alpha = 0
		animate(src, alpha = 255, time = 4)

		sleep(time + 4)
		if(p)
			animate(src, alpha = 0, time = 4)
			sleep(4)
			if(p) p.client.screen -= src

mob/Player/proc/screenAlert(message, time=30)

	var/c
	if(mapTextColor != "#ffffff")
		var/rr = 255 - hex2value(copytext(mapTextColor, 2, 4))
		var/gg = 255 - hex2value(copytext(mapTextColor, 4, 6))
		var/bb = 255 - hex2value(copytext(mapTextColor, 6, 8))
		c = rgb(rr, gg, bb)
	else
		c = "#111"
	Interface.levelMessage.Display("<span style=\"text-align:center\">[message]</span>", hex=c, state=null, time=time)
//	new /obj/hud/TextMessage(null, src, message, time)

mob/Player
	var/tmp/list/expMessages

	proc/expAlert(amount, state, time=4)
		set waitfor = 0

		if(expMessages)
			expMessages[state] += amount
			return

		expMessages = list()
		expMessages[state] = amount

		sleep(time)
		for(var/m in expMessages)
			new /obj/hud/TextMessageExp(null, src, "[m] +[expMessages[m]]", m, time)
		expMessages = null


Input
	var/mob/Player/parent
	var/index

	proc
		Alert(Usr=parent,Message,Title,Button1="Ok",Button2,Button3)
			return alert(Usr,Message,Title,Button1,Button2,Button3)

		InputText(Usr=parent,Message,Title,Default)
			return input(Usr,Message,Title,Default) as text

		InputList(Usr=parent,Message,Title,Default,List)
			return input(Usr,Message,Title,Default) as null|anything in List


	New(mob/Player/p, index = "")
		..()

		if(!p._input)
			p._input = list()
		src.index = index
		p._input[index] = src
		parent = p

	Del()
		if(parent && parent._input)
			try
				parent._input -= index
				if(!parent._input.len) parent._input = null
			catch
				parent._input = null
		..()

proc
	IsInputOpen(mob/Player/p, name)
		if(p._input)
			return (name in p._input)
		return 0


mob/Player/var/tmp/ScreenText/screen_text
ScreenText

	var
		obj/hud/input

			Text/displayText
	//		Text/text_shadow
			Background/background
			Image/displayImage
			Button
				button1
				button2
				button3

		mob/Player/owner

		list/queue

		tmp
			isBusy     = FALSE
			isDisposed = FALSE
			isWaiting  = FALSE
			Result

	New(mob/Player/i_Player, atom/i_Image = null, i_Button1 = "OK", i_Button1Color = "#2299d0", i_Button2 = null, i_Button2Color = "#ff0000", i_Button3 = null, i_Button3Color = "#00ff00")
		..()

		owner = i_Player
		if(owner.screen_text)
			owner.screen_text.Dispose()

		owner.screen_text = src

		displayText = new
	//	text_shadow = new
		background  = new

		if(i_Button1)
			button1 = new(src, i_Button1, i_Button1Color, "CENTER:24-1,CENTER-2")
		if(i_Button2)
			button2 = new(src, i_Button2, i_Button2Color, "CENTER:29-4,CENTER-2")
		if(i_Button3)
			button3 = new(src, i_Button3, i_Button3Color, "CENTER:18+2,CENTER-2")

		if(i_Image)
			displayImage = new
			SetImage(i_Image, FALSE)
			displayImage.name = i_Image.name
			owner.client.screen += displayImage


	//	shadowedMapText(text, text_shadow, 1, SOUTH)

		owner.client.screen += background
		owner.client.screen += displayText
	//	owner.client.screen += text_shadow

	proc
		SetImage(atom/a, animate=TRUE)
			set waitfor = 0
			if(isDisposed) return

			if(!displayImage)
				displayImage = new
				animate      = FALSE
				owner.client.screen += displayImage

			if(animate)
				displayImage.Hide(5)
				sleep(5)

			displayImage.appearance = a.appearance
			displayImage.transform *= 6.5
			displayImage.underlays  = null
			displayImage.layer      = 18
			displayImage.appearance_flags |= PIXEL_SCALE

			if(animate)
				displayImage.Show(5)

		AddImage(atom/a)
			if(isDisposed) return
			if(!queue)
				SetImage(a)
			else
				queue += a


		SetText(t, soundID, animate = TRUE)
			set waitfor = 0
			if(isDisposed) return

			if(animate)
				displayText.Hide(5)
				sleep(5)

			displayText.maptext = "<b><span style=\"color:white;\">[t]</span></b>"


			if(displayImage)
				if(ismob(src))
					owner << npcsay("[displayImage.name]: [t]")
				else
					owner << infomsg("[t]")

			if(animate) displayText.Show(5)

	//		text_shadow.maptext = "<b><span style=\"color:black;\">[t]</span></b>"

	//		if(owner.playSounds && soundID)
	//			owner << sound(file("Sound/[soundID].ogg"), 0, 0, 9)

		AddText(t, soundID = null)
			if(isDisposed) return
			if(displayText.maptext == null)
				SetText(t, soundID, FALSE)
			else
				if(!queue) queue = list()

				queue[t] = soundID

		SetButtons(i_Button1 = null, i_Button1Color = "#2299d0", i_Button2 = null, i_Button2Color = "#ff0000", i_Button3 = null, i_Button3Color = "#00ff00")
			if(isDisposed) return

			if(i_Button1)
				if(button1)
					animate(button1)
					button1.invisibility = 10 // workaround for animate not changing colors
					button1.Set(i_Button1, i_Button1Color)
				else
					button1 = new(src, i_Button1, i_Button1Color, "CENTER:24-1,CENTER-2")

			else if(button1)
				button1.Hide()

			if(i_Button2)
				if(button2)
					button2.Set(i_Button2, i_Button2Color)
				else
					button2 = new(src, i_Button2, i_Button2Color, "CENTER:29-4,CENTER-2")

			else if(button2)
				button2.Hide()

			if(i_Button3)
				if(button3)
					button3.Set(i_Button3, i_Button3Color)
				else
					button3 = new(src, i_Button3, i_Button3Color, "CENTER:18+2,CENTER-2")

			else if(button3)
				button3.Hide()



		AddButtons(i_Button1 = null, i_Button1Color = "#2299d0", i_Button2 = null, i_Button2Color = "#ff0000", i_Button3 = null, i_Button3Color = "#00ff00")
			if(isDisposed) return
			if(!queue) queue = list()
		//		SetButtons(i_Button1, i_Button1Color, i_Button2, i_Button2Color, i_Button3, i_Button3Color)
		//	else
			queue           += 0
			queue[queue.len] = list(i_Button1, i_Button1Color, i_Button2, i_Button2Color, i_Button3, i_Button3Color)

		process()
			set waitfor = 0
			if(isDisposed) return
			var/q = queue[1]

			if(istype(q, /atom/movable))
				SetImage(q)
				queue -= q

				if(!queue.len) queue = null



		Next(i_buttonName)
			if(isBusy)     return
			if(isDisposed) return

			Result = i_buttonName

			if(!queue)
				if(isWaiting)
					isWaiting = FALSE
				else
					Dispose()
			else
				isBusy = TRUE

				var/q = queue[1]

				if(islist(q))

					var
						list/buttonData = q
						b1
						bc1
						b2
						bc2
						b3
						bc3

					if(buttonData.len > 0) b1  = buttonData[1]
					if(buttonData.len > 1) bc1 = buttonData[2]
					if(buttonData.len > 2) b2  = buttonData[3]
					if(buttonData.len > 3) bc2 = buttonData[4]
					if(buttonData.len > 4) b3  = buttonData[5]
					if(buttonData.len > 5) bc3 = buttonData[6]

					SetButtons(b1, bc1, b2, bc2, b3, bc3)

					queue.Cut(1,2)

					if(queue.len)
						q = queue[1]
					else
						q     = null
						queue = null

				if(q)
					SetText(q, queue[q])
					queue -= q

					if(!queue.len)
						queue = null
					else
						process()

				sleep(10)
				isBusy = FALSE

		Wait(next = TRUE)
			if(isDisposed) return
			isWaiting = TRUE

			var/sleepCount = 0
			while(owner && !isDisposed && isWaiting)
				sleepCount++
				sleep(1)

			if(!sleepCount)
				sleep(1)

			if(owner)
				if(!isWaiting)
					if(next) spawn() Next()
					return 1

			else if(!isDisposed)
				Dispose()

		WaitEnd()
			if(isDisposed) return
			while(owner && !isDisposed)
				sleep(10)

			if(owner)
				return queue ? 0 : 1

			else if(!isDisposed)
				Dispose()

		Dispose()
			set waitfor = FALSE

			if(isDisposed) return

			isBusy = TRUE

			background.Hide(10)
			displayText.Hide(10)
		//	text_shadow.Hide(10)

			if(button1) button1.Hide(10)
			if(button2) button2.Hide(10)
			if(button3) button3.Hide(10)

			if(displayImage)
				displayImage.Hide(10)

			if(owner)
				owner.screen_text = null
				owner << sound(null, 0, 0, 9)

			if(button1)	button1.parent = null
			if(button2)	button2.parent = null
			if(button3)	button3.parent = null


			isDisposed = TRUE

			sleep(10)

			if(owner)
				owner.client.screen -= background
				owner.client.screen -= displayText
		//		owner.client.screen -= text_shadow

				if(button1)		 owner.client.screen -= button1
				if(button2)		 owner.client.screen -= button2
				if(button3)		 owner.client.screen -= button3
				if(displayImage) owner.client.screen -= displayImage

				owner = null

			displayImage = null
			displayText  = null
	//		text_shadow  = null
			background   = null
			button1      = null
			button2      = null
			button3      = null

obj/hud

	input
		layer = 20
		Background
			icon = 'MMBackground.dmi'
			screen_loc = "CENTER:28-4,CENTER-2"
			layer = 19
			alpha = 75

		Image
			icon = 'Matchmaking.dmi'
			screen_loc = "CENTER:14,CENTER+2"
			layer = 18

		Text
			screen_loc = "CENTER:2-3,CENTER:16-1"
			maptext_width  = 250
			maptext_height = 128
			layer = 20

		Button
			icon = 'MMButtons.dmi'
			icon_state = "button"
			screen_loc = "CENTER:27-1,CENTER-2"
			mouse_over_pointer = MOUSE_HAND_POINTER
			color = "#2299d0"

			alpha         = 220
			maptext_x     = 26
			maptext_width = 72
			maptext_y     = 6
			layer         = 20
			mouse_opacity = 2

			MouseEntered()
				if(alpha)
					alpha = 254
			MouseExited()
				if(alpha == 254)
					alpha = initial(alpha)

			var/ScreenText/parent

			New(ScreenText/parent, text, color, screenLoc = "CENTER:24-1,CENTER-2")

				src.parent = parent
				screen_loc = screenLoc
				Set(text, color)

				parent.owner.client.screen += src

				..()

			proc
				Set(text, color)
					maptext    = "<span style=\"color:white;\">[text]</span>"
					src.color  = color
					name       = text

					maptext_x = 33 - (3 * length(text))

					if(invisibility) Show()

			Click()
				..()
				if(parent && alpha > 0 && invisibility == 0)
					parent.Next(name)

		New()
			..()

		/*	var/px = width  / 2
			var/py = height / 2

			var/tx = round(px / 32, 1)
			var/ty = round(py / 32, 1)

			px = px % 32
			py = py % 32

			if(px)
				tx++
				px = 32 - px

			if(py)
				ty++
				py = 32 - py*/

			Show(10)

		proc
			Hide(t = 5)
				set waitfor = 0
				if(invisibility) return

				animate(src, alpha = 0, time = t)

				sleep(t)
				alpha = initial(alpha)
				invisibility = 10

			Show(t = 5)
				var/a        = alpha
				alpha        = 0
				invisibility = 0

				animate(src, alpha = a, time = t)


/*proc/shadowedMapText(atom/a, shadow_object = null, offset = 1, shadow_dir = SOUTH)

	var/obj/o = shadow_object ? shadow_object : new

	o.maptext_width  = a.maptext_width
	o.maptext_height = a.maptext_height

	o.maptext_x = a.maptext_x + ((shadow_dir & (EAST  | WEST))  ? ((shadow_dir & EAST  && offset) || -offset) : (0))
	o.maptext_y = a.maptext_y + ((shadow_dir & (NORTH | SOUTH)) ? ((shadow_dir & NORTH && offset) || -offset) : (0))

	o.layer = a.layer - 1

	return o*/