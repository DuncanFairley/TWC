mob/GM/verb
	Change_Area()
		set hidden = 1

	Acid()
		set category="Server"
		set hidden = 1

mob/Quidditch/verb
	Add_Spectator(mob/Player/P as mob in world)
		set hidden = 1
	Remove_Spectator()
		set hidden = 1

mob/verb/Convert()
	set hidden = 1