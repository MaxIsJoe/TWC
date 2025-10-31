mob/Player
	proc/ApplyAFKOverlay()
		RemoveAFKOverlay()

		if(!away) return

		if(locate(/obj/items/wearable/afk/pimp_ring) in Lwearing)
			if(House=="Slytherin")
				overlays += image('AFK.dmi', icon_state = "S")
			else if(House=="Gryffindor")
				overlays += image('AFK.dmi', icon_state = "G")
			else if(src.House=="Hufflepuff")
				overlays += image('AFK.dmi', icon_state = "H")
			else
				overlays += image('AFK.dmi', icon_state = "R")
		else if(locate(/obj/items/wearable/afk/hot_chocolate) in Lwearing)
			overlays+=image('AFK.dmi',icon_state="AFK2")
		else if(locate(/obj/items/wearable/afk/heart_ring) in Lwearing)
			overlays+=image('AFK.dmi',icon_state="AFK3")
		else
			overlays+=image('AFK.dmi',icon_state="AFK1")
	verb
		AFK()
			set category = null
			if(!usr.away)
				usr.away = 1
				usr.here=usr.status
				usr.status=" (AFK)"
				Players<<"~ <span style=\"color:red;\">[usr]</span> is <u>AFK</u> ~"
				ApplyAFKOverlay()
			else
				usr.away = 0
				usr.status=usr.here
				Players<<"<span style=\"color:red;\">[usr]</span> is no longer AFK."
			RemoveAFKOverlay()

mob
	proc/RemoveAFKOverlay()
		overlays-=image('AFK.dmi',icon_state="AFK1")
		overlays-=image('AFK.dmi',icon_state="AFK2")
		overlays-=image('AFK.dmi',icon_state="AFK3")
		overlays-=image('AFK.dmi',icon_state="S")
		overlays-=image('AFK.dmi',icon_state="G")
		overlays-=image('AFK.dmi',icon_state="H")
		overlays-=image('AFK.dmi',icon_state="R")