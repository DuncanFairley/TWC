/* Demonstrates using a Discord Webhook to forward chat messages from your game to a Discord text channel.

	Discord's Intro to Webhooks:
		https://support.discordapp.com/hc/en-us/articles/228383668-Intro-to-Webhooks

	Discord's dev docs for webhooks:
		https://discordapp.com/developers/docs/resources/webhook

	* Discord rate-limits webhooks, so messages will fail to send if used too frequently.
		This can be worked around; you can modify HttpPost to get the response which includes
		rate limit info when it occurs. But I won't be doing that here.

		Rate limits doc:
			https://discordapp.com/developers/docs/topics/rate-limits
*/

WorldData/var/discordHookKey

client
	// I made key_info literally just to grab your member icon URL from the hub.
	var key_info/key_info

	New()
		key_info = new(key)
		return ..()


mob/Player/proc/SendDiscord(var/message)
	if(!worldData.discordHookKey) return

	var/defaultIcon

	if(House == "Gryffindor")
		defaultIcon = "https://e1.pngegg.com/pngimages/542/343/png-clipart-harry-potter-gryffindor-logo-thumbnail.png"
	else if(House == "Ravenclaw")
		defaultIcon = "https://www.clipartmax.com/png/middle/264-2649292_ravenclaw-crest-harry-potter-ravenclaw-crest.png"
	else if(House == "Slytherin")
	 	defaultIcon = "https://toppng.com/uploads/preview/slytherin-crest-slytherin-crest-clipart-harry-potter-slytherin-crest-11562871434vbfa2qke9n.png"
	else if(House == "Hufflepuff")
		defaultIcon = "https://www.kindpng.com/imgv/hJJJwmR_hufflepuff-crest-harry-potter-banner-harry-potter-hufflepuff/"

	client.HttpPost(
		/* Replace this with the webhook URL that you can Copy in Discord's Edit Webhook panel.
		It's best to use a global const for this and keep it secret so others can't use it.
		*/
		worldData.discordHookKey,

		/*
		[content] is required and can't be blank.
		It's the message posted by the webhook.

		[avatar_url] and [username] are optional.
		They're taken from your key.
		They override the webhook's name and avatar for the post.
		*/
		list(
			content = message,
			avatar_url = client.key_info.IconURL(),
			username = name
			)
		)