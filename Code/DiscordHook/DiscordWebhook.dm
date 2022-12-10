
mob/Player/proc/SendDiscord(var/message, var/dest)
	if(!dest) dest = discord_ooc_hook
	if(!dest) return

	var/defaultIcon

	if(House == "Gryffindor")
		defaultIcon = "https://e1.pngegg.com/pngimages/542/343/png-clipart-harry-potter-gryffindor-logo-thumbnail.png"
	else if(House == "Ravenclaw")
		defaultIcon = "https://www.clipartmax.com/png/middle/264-2649292_ravenclaw-crest-harry-potter-ravenclaw-crest.png"
	else if(House == "Slytherin")
		defaultIcon = "https://toppng.com/uploads/preview/slytherin-crest-slytherin-crest-clipart-harry-potter-slytherin-crest-11562871434vbfa2qke9n.png"
	else if(House == "Hufflepuff")
		defaultIcon = "https://www.kindpng.com/imgv/hJJJwmR_hufflepuff-crest-harry-potter-banner-harry-potter-hufflepuff/"
	else
		defaultIcon = "https://www.kindpng.com/picc/m/19-198867_transparent-harry-potter-hogwarts-crest-hd-png-download.png"

	var/fixedName

	if(prevname) fixedName = prevname
	else if(pname) fixedName = pname
	else fixedName = name

	var/list/headers = list("Content-Type" = "application/json")


	var/body = list(content = html_decode(message),
			avatar_url = defaultIcon,
			username = fixedName)

	rustg_http_request_async(RUSTG_HTTP_METHOD_POST, dest, json_encode(body), json_encode(headers), "{}")
