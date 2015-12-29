
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
		if(parent._input)
			parent._input -= index
			if(!parent._input.len) parent._input = null
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

			Text/text
	//		Text/text_shadow
			Background/background
			Image/image
			Button/button

		mob/Player/owner

		list/queue

		tmp
			isBusy     = FALSE
			isDisposed = FALSE

	New(mob/Player/p, atom/a = null)
		..()

		owner             = p
		owner.screen_text = src

		text        = new
	//	text_shadow = new
		background  = new
		button      = new(src)


		if(a)
			image = new
			image.appearance = a.appearance
			image.transform *= 6.5
			image.underlays  = null

			p.client.screen += image

	//	shadowedMapText(text, text_shadow, 1, SOUTH)

		p.client.screen += background
		p.client.screen += text
	//	p.client.screen += text_shadow
		p.client.screen += button

	proc
		SetText(t, soundID)
			text.maptext        = "<b><font color=white>[t]</font></b>"
	//		text_shadow.maptext = "<b><font color=black>[t]</font></b>"

			if(owner.playSounds && soundID)
				owner << sound(file("Sound/[soundID].ogg"), 0, 0, 9)

		AddText(t, soundID = null)

			if(text.maptext == null)
				SetText(t, soundID)
			else
				if(!queue) queue = list()

				queue[t] = soundID

		Next()
			if(isBusy) return

			if(!queue)
				Dispose()
			else
				isBusy = TRUE

				animate(text, alpha = 0, time = 5)
				sleep(5)

				SetText(queue[1], queue[queue[1]])
				queue -= queue[1]

				animate(text, alpha = 255, time = 5)

				if(!queue.len) queue = null

				sleep(5)
				isBusy = FALSE

		Dispose()
			set waitfor = FALSE

			if(isDisposed) return

			isBusy = TRUE

			animate(background,  alpha = 0, time = 10)
			animate(text,        alpha = 0, time = 10)
		//	animate(text_shadow, alpha = 0, time = 10)
			animate(button,      alpha = 0, time = 10)

			if(image)
				animate(image,  alpha = 0, time = 10)

			if(owner)
				owner.screen_text = null
				owner << sound(null, 0, 0, 9)

			button.parent = null
			isDisposed = TRUE

			sleep(10)

			if(owner)
				owner.client.screen -= background
				owner.client.screen -= text
		//		owner.client.screen -= text_shadow
				owner.client.screen -= button

				if(image)
					owner.client.screen -= image

				owner = null

			image       = null
			text        = null
	//		text_shadow = null
			background  = null
			button      = null

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
			screen_loc = "CENTER:17,CENTER+2"


		Text
			screen_loc = "CENTER:2-3,CENTER:16-1"
			maptext_width  = 250
			maptext_height = 128

		Button
			icon = 'MMButtons.dmi'
			icon_state = "button"
			screen_loc = "CENTER:27-1,CENTER-2"
			mouse_over_pointer = MOUSE_HAND_POINTER
			color = "#2299d0"

			alpha     = 235
			maptext   = "<font color=white>OK</font>"
			maptext_x = 26
			maptext_y = 6

			var/ScreenText/parent

			New(ScreenText/parent)
				..()

				src.parent = parent

			Click()
				..()
				if(parent)
					parent.Next()

		New()
			..()

			var/a = alpha
			alpha = 0

			animate(src, alpha = a, time = 10)


/*proc/shadowedMapText(atom/a, shadow_object = null, offset = 1, shadow_dir = SOUTH)

	var/obj/o = shadow_object ? shadow_object : new

	o.maptext_width  = a.maptext_width
	o.maptext_height = a.maptext_height

	o.maptext_x = a.maptext_x + ((shadow_dir & (EAST  | WEST))  ? ((shadow_dir & EAST  && offset) || -offset) : (0))
	o.maptext_y = a.maptext_y + ((shadow_dir & (NORTH | SOUTH)) ? ((shadow_dir & NORTH && offset) || -offset) : (0))

	o.layer = a.layer - 1

	return o*/