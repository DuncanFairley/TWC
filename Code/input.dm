
Input
	proc
		Alert(Usr=usr,Message,Title,Button1="Ok",Button2,Button3)
			return alert(Usr,Message,Title,Button1,Button2,Button3)

		InputText(Usr=usr,Message,Title,Default)
			return input(Usr,Message,Title,Default) as text

		InputList(Usr=usr,Message,Title,Default,List)
			return input(Usr,Message,Title,Default) as null|anything in List
