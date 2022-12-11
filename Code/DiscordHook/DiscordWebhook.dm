
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


proc/pollForDiscord()
	set waitfor = 0

	var/id = -1
	while(1)

		if(id == -1)
			var/list/headers = list("Content-Type" = "text/plain")
			id = rustg_http_request_async(RUSTG_HTTP_METHOD_POST, discord_bot_url, discord_bot_pass, json_encode(headers), "{}")
		else
			var/response = rustg_http_check_request(id)


			if(response != RUSTG_JOB_NO_RESULTS_YET)
				id = -1

				if(!findtext(response, "error sending request for url"))
					var/list/res = json_decode(response)

					if(res["status_code"] == 200)

						var/list/body = json_decode(res["body"])

						var/msg = check(body["content"])
						var/name = body["name"]

						Players << "<b><a style=\"font-size:1;font-family:'Comic Sans MS';text-decoration:none;color:green;\">OOC></a><span style=\"font-size:2; color:#3636F5;\">[name]:</span></b> <span style=\"color:white; font-size:2;\"> [msg]</span>"

		sleep(3)