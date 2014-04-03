
Input
	var/mob/Player/parent

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
			p._input = new
			p._input[index] = src
		else
			p._input += src
		parent = p

	Del()
		if(parent._input)
			parent._input -= src
			if(!parent._input.len) parent._input = null
		..()

proc
	IsInputOpen(mob/Player/p, name)
		if(p._input)
			return (name in p._input)
		return 0