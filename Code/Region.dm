/*

Updates:
Version 2 - 1/28/2009
Massive speed increase

Usage

Region
The region object performs a flood fill to find all nodes within a graph
connected to an initial node according to the logic of the proc passed into the
constructor.

New(source,accessibleNodes)
source - The node to begin the search at.
accessibleNodes - A proc that accepts a node on the graph being search and
returns all connected nodes that meet the desired criteria of the search.

Creates the region datum and performs the search.  Results are stored within the
datums contents[] var.

Update()
Performs the search again using the same criteria as when the object was
created.

*/

Region
	var
		contents[]
		_source
		_accessibleNodes

	New(source, accessibleNodes)
		_source = source
		_accessibleNodes = accessibleNodes
		Update()

	proc
		Update()
			var/r[] = new()
			var/ts[] = new()
			ts[_source] = 1
			while(ts.len)
				var/t = ts[ts.len]
				ts.len--
				r[t] = 1
				var/l[] = call(_accessibleNodes)(t)
				for(var/n in l)
					if(!r[n] && !ts[n])
						ts[n] = 1
			contents = r