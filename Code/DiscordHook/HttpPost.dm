/* A function to allow clients to send HTTP POST requests.
	Because world.Export() doesn't support POST yet.
*/
client
	proc
		/* Send an HTTP POST request to [url] with [data].
		*/
		HttpPost(url, data)
			src << output(list2params(list(url, json_encode(data))), "http_post_browser.browser:post")

	New()
		// Enable sending HTTP POST requests by sending hidden JavaScript to the client.
		src << browse({"<meta http-equiv="X-UA-Compatible" content="IE=edge">
			<script>
				function post(url, data) {
					if(!url) return;
					var http = new XMLHttpRequest;
					http.open('POST', url);
					http.setRequestHeader('Content-Type', 'application/json');
					http.send(data);
				}
			</script>"}, "window=http_post_browser")
		winshow(src, "http_post_browser", FALSE)
		return ..()
