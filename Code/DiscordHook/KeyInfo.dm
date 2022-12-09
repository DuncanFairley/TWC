/* Key info is the data you see when you go to the format=text page of a BYOND key.

	Example of format=text: my own key info.

		http://www.byond.com/members/Kaiochao&format=text
*/
key_info

	/* Takes the key that you want to get info of.
	*/
	New(key)
		..()
		_key = key
		_is_guest = 1 == findtextEx(key, "Guest")
		_data = new

	var
		/* Time it takes before a reload happens.
			This is just to avoid fetching the hub too often.
		*/
		reload_cooldown = 600

		/* Key of the info being retrieved.
		*/
		_key

		/* True if this is a guest key.
		*/
		_is_guest

		/* Key info is given by the hub in the same format as savefile.ExportText().
		*/
		savefile/_data

		/* Time since the last reload.
		*/
		_last_reload = -1#INF

		/* True if currently loading.
		*/
		_loading

	proc
		/* Get the value of a field in your key data.
		*/
		Get(field)
			if(_is_guest)
				return
			CheckReload()
			return _data["general/[field]"]

		/* Gets the URL of member icon, or the non-member icon for guests/non-members.
		*/
		IconURL(var/defaultIcon)
			if(defaultIcon) return !_is_guest && Get("is_member") ? Get("icon") : defaultIcon
			return !_is_guest && Get("is_member") ? Get("icon") : "http://www.byond.com/rsc/nonmember_avatar.png"

		/* Reloads if it has been long enough since the last reload.
		*/
		CheckReload()
			if(_is_guest)
				return
			if(!_loading)
				var timestamp = world.timeofday
				if(timestamp > _last_reload + reload_cooldown)
					_loading = TRUE
					Reload()
					_loading = FALSE
					_last_reload = world.timeofday

		/* Reload key info from the hub.
			May take some time.
		*/
		Reload()
			if(_is_guest)
				return
			var list/http = world.Export("http://www.byond.com/members/[ckeyEx(_key)]&format=text")
			if(http)
				var content = file2text(http["CONTENT"])
				if(content)
					_data.ImportText("/", content)
