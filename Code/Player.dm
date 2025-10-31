var/list/active_mobs = list()
mob/var
	level=1
	Dmg=5
	Def=5
	HP=200
	MHP=200
	MP=200
	MMP=200

mob/Player/var/tmp/Shield = 0

mob/var/Mexp=50
mob/var/Exp=0
mob/var/Expg=1
mob/var/tmp/listenooc=1
mob/var/tmp/listenhousechat=1
mob/var/gold/gold
mob/var/goldg=1
mob/var/gold/goldinbank

mob/var/tmp/follow=0
mob/var/tmp/away=0
mob/var/tmp/followplayer=0
mob/var/tmp/status=""
mob/var/tmp/here=""
mob/var/Gm=0

obj/var/picon=null
obj/var/tmp/mob/owner

mob/Player/var
	Detention=0
	Rank
	Immortal=0

	MuteOOC=0
	Year

	House
	Tag
	GMTag
	edeaths=0
	ekills=0
	pdeaths=0
	pkills=0

	draganddrop=0
	StatPoints=0
	mute=0

	tmp
		spam=0


mob/Player/proc/onDeath(turf/oldLoc, killerName)
	set waitfor = 0

	filters = null

	pixel_x = 0
	pixel_y = 0

	var/obj/o        = new
	o.screen_loc     = "CENTER,CENTER+3"

	var/randomMessage = pick("Say \"hi\" to Satan for me!",
	                         "Did you trip and fall over like those chicks from horror flicks?",
	                         "YOU ARE DEAD. Sorry, that was a little dramatic. Seriously though, you've died.",
	                         "Well, look at the bright side, now you won't have to do your homework.",
	                         "Theme music from Titanic plays as your screen fades to black...",
	                         "You died! What's that all about?",
	                         "Dang, you were doing so well! Such a shame.",
	                         "I saw that coming...",
	                         Gender == "Female" ? "RIP guuurl, RIP" : "RIP bro, RIP")

	o.maptext        = "<center><span style=\"color:#e50000;font-size:32pt;font-family:'Comic Sans MS';\">You died!</span><br>" +\
	                   "<span style=\"color:#e50000;\">[randomMessage]</span></center>"
	o.maptext_height = 128
	o.alpha          = 0
	o.plane          = 2

	var/pixelsize = length(randomMessage) * 14

	o.maptext_width = pixelsize
	o.maptext_x     = -ceil(pixelsize/2)

	client.screen += o

	var/obj/bed = locate("respawn_" + ckey)
	var/hudobj/respawn/r
	if(bed)
		r = new (null, client, list("maptext_width" = o.maptext_width, "maptext_x" = o.maptext_x ), 1)
		animate(r, alpha = 255, time = 5)

	animate(o, alpha = 255, time = 5)

	nomove = 2
	client.eye = oldLoc
	client.perspective = EYE_PERSPECTIVE

	sleep(20)
	Interface.SetDarknessColor("#000000", 10, 30)

	var/time = 50
	var/spawnLoc = loc
	while(spawnLoc == loc && time-- > 0)
		sleep(1)

	animate(o, alpha = 0, time = 5)
	client.eye = src
	client.perspective = MOB_PERSPECTIVE
	Interface.SetDarknessColor("#000000")
	nomove = 0
	if(r) r.hide()
	sleep(6)
	client.screen -= o

proc/level2year(level)
	if(level < 16) return 1
	if(level < 51) return 2
	if(level < 101) return 3
	if(level < 201) return 4
	if(level < 301) return 5
	if(level < 401) return 6
	if(level < 501) return 7
	return 8

mob/proc/Death_Check(mob/killer = src)
	if(src.HP<1)
		if(isplayer(src))
			var/mob/Player/p = src
			Check_Death_Drop()
			for(var/turf/duelsystemcenter/T in duelsystems)
				if(T.D)
					if(T.D.player1 == src)
						range(8,T) << "<i>[T.D.player1] has lost the duel. [T.D.player2] is the winner!</i>"
						del T.D
					else if(T.D.player2 == src)
						range(8,T) << "<i>[T.D.player2] has lost the duel. [T.D.player1] is the winner!</i>"
						del T.D
			for(var/obj/items/portduelsystem/T in duelsystems)
				if(T.D)
					if(T.D.player1 == src)
						range(8,T) << "<i>[T.D.player1] has lost the duel. [T.D.player2] is the winner!</i>"
						del T.D
					else if(T.D.player2 == src)
						range(8,T) << "<i>[T.D.player2] has lost the duel. [T.D.player1] is the winner!</i>"
						del T.D
			if(src.arcessoing == 1)
				hearers() << "[src] stops waiting for a partner."
				p.arcessoing = 0
			else if(ismob(arcessoing))
				hearers() << "[src] pulls out of the spell."
				stop_arcesso()
			if(p.Detention)
				return
			if(p.Immortal==1 && (p.admin || !istype(killer, /mob/Enemies)))
				p<<"[killer] tried to knock you out, but you are immortal."
				killer<<"<span style=\"color:blue;\"><b>[src] is immortal and cannot die.</b></span>"
				return
			var/area/a = loc.loc
			if(istype(a,/area/hogwarts/Duel_Arenas) || a.respawnPoint)
				p.followplayer=0
				p.HP=p.MHP
				p.MP=p.MMP
				p.updateHPMP()
				p.FlickState("m-black",8,'Effects.dmi')

				if(a.respawnPoint)
					p.Transfer(locate(a.respawnPoint))
				else
					switch(src.loc.loc.type)
						if(/area/hogwarts/Duel_Arenas/Main_Arena_Bottom)
							p.Transfer(locate("DuelArena_Death"))
						if(/area/hogwarts/Duel_Arenas/Matchmaking/Main_Arena_Top)
							var/obj/o = pick(worldData.duel_chairs)
							p.Transfer(o.loc)
						if(/area/hogwarts/Duel_Arenas/Slytherin)
							p.Transfer(locate("Slyth_Death"))
						if(/area/hogwarts/Duel_Arenas/Gryffindor)
							p.Transfer(locate("Gryffin_Death"))
						if(/area/hogwarts/Duel_Arenas/Ravenclaw)
							p.Transfer(locate("Raven_Death"))
						if(/area/hogwarts/Duel_Arenas/Hufflepuff)
							p.Transfer(locate("Huffle_Death"))
						if(/area/hogwarts/Duel_Arenas/Matchmaking/Duel_Class)
							p.Transfer(locate("DuelClass_Death"))
						if(/area/hogwarts/Duel_Arenas/Defence_Against_the_Dark_Arts)
							p.Transfer(locate("DADA_Death"))
						if(/area/hogwarts/Duel_Arenas/Main_Arena_Lobby)
							var/obj/Bed/B = pick(Beds)
							p.Transfer(B.loc)
							src.dir = SOUTH
				src<<"<i>You were knocked out by <b>[killer]</b>!</i>"
				if(src.removeoMob) spawn()src:Permoveo()
				src.sight &= ~BLIND
				return
			if(src.loc.loc.type == /area/hogwarts/Hospital_Wing)
				p.HP=p.MHP
				p.updateHP()
				return
			if(src.loc.loc.type in typesof(/area/arenas/MapThree/WaitingArea))
				killer << "Do not attack in the waiting area.."
				p.HP = p.MHP
				return

			if(p.Summons)
				for(var/obj/summon/s in p.Summons)
					s.Dispose()

			if(src.loc.loc.type in typesof(/area/arenas/MapThree/PlayArea))
				if(worldData.currentArena)
					var/list/players = range(8,worldData.currentArena.speaker)|worldData.currentArena.players
					if(killer != src)
						players << "<b>Arena</b>: [killer] killed [src]."
					else
						players << "<b>Arena</b>: [killer] killed themself."
					worldData.currentArena.players.Remove(src)
					p.HP=p.MHP
					p.MP=p.MMP
					p.updateHPMP()
					if(worldData.currentArena.players.len < 2)
						var/mob/winner
						if(worldData.currentArena.players.len != 0)
							winner = worldData.currentArena.players[1]
							var/turf/T = pick(MapThreeWaitingAreaTurfs)
							winner.loc = T
							winner.density = 1
						else
							winner = src
						players << "<b>Arena</b>: [winner] wins the round!"
						for(var/mob/Z in view(8,worldData.currentArena.speaker))
							Z << "<b>You can leave at any time when a round hasn't started by <a href=\"byond://?src=\ref[Z];action=arena_leave\">clicking here.</a></b>"

						var/RandomEvent/FFA/e = locate() in worldData.events
						if(e)
							e.winner = winner

						del(worldData.currentArena)
					else
						new /obj/corpse (loc, src, 0)
					var/turf/T = pick(MapThreeWaitingAreaTurfs)
					src.loc = T
					density = 1
					return
				else
					killer << "Do not attack before a round has started."
					src.HP = src.MHP
					return
			/////HOUSE WARS/////
			if((src.loc.loc.type in typesof(/area/arenas/MapOne)) && isplayer(killer))
				if(p.House != killer:House)
					if(worldData.currentArena)
						if(worldData.currentArena.roundtype == HOUSE_WARS && worldData.currentArena.started)
							worldData.currentArena.Add_Point(killer:House,1)
							src << "You were killed by [killer] of [killer:House]"
							killer << "You killed [src] of [p.House]"
				else if(src == killer)
					src << "You killed yourself!"
				else
					src << "You were killed by [killer], from your own team!"
					killer << "You killed [src] of your own team!"
				if(worldData.currentArena)
					if(worldData.currentArena.plyrSpawnTime > 0)
						src << "<i>You must wait [worldData.currentArena.plyrSpawnTime] seconds until you respawn.</i>"
				var/obj/Bed/B
				switch(p.House)
					if("Gryffindor")
						B = pick(Map1Gbeds)
					if("Hufflepuff")
						B = pick(Map1Hbeds)
					if("Slytherin")
						B = pick(Map1Sbeds)
					if("Ravenclaw")
						B = pick(Map1Rbeds)
				src.loc = B.loc
				src.dir = SOUTH
				if(worldData.currentArena)
					worldData.currentArena.handleSpawnDelay(src)

				p.HP=p.MHP
				p.MP=p.MMP
				p.updateHPMP()
				return
			var/obj/Bed/B
			if(p.prevname)
				if(p.guild == worldData.majorChaos)
					B = pick(DEBeds)
				else if(p.guild == worldData.majorPeace)
					B = pick(AurorBeds)
				else
					B = pick(Beds)
			else
				B = pick(Beds)
			if(!p.Detention)
				if(killer != p && !p.rankedArena)
					if(killer.client && client && killer.loc.loc.name != "outside")
						if(killer:prevname)
							if(p.prevname)
								file("Logs/kill_log.html") << "[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]: [killer:prevname](DE robed) killed [p.prevname](DE robed): [src.loc.loc](<a href='?action=teleport;x=[src.x];y=[src.y];z=[src.z]'>Teleport</a>)<br>"
							else
								file("Logs/kill_log.html") << "[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]: [killer:prevname](DE robed) killed [src]: [src.loc.loc](<a href='?action=teleport;x=[src.x];y=[src.y];z=[src.z]'>Teleport</a>)<br>"
						else
							if(p.prevname)
								file("Logs/kill_log.html") << "[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]: [killer] killed [p.prevname](DE robed): [src.loc.loc](<a href='?action=teleport;x=[src.x];y=[src.y];z=[src.z]'>Teleport</a>)<br>"
							else
								file("Logs/kill_log.html") << "[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]: [killer] killed [src]: [src.loc.loc](<a href='?action=teleport;x=[src.x];y=[src.y];z=[src.z]'>Teleport</a>)<br>"
					if(killer.client && get_dist(src, killer) == 1 && get_dir(src, killer) == turn(src.dir,180))
						src << "<i>You were knocked out by <b>someone from behind</b> and sent to the Hospital Wing!</i>"
					else
						src << "<i>You were knocked out by <b>[killer]</b> and sent to the Hospital Wing!</i>"

				src:nofly()
				if(src.removeoMob) spawn()src:Permoveo()

				src.followplayer=0
				p.HP=p.MHP
				p.MP=p.MMP
				p.updateHPMP()

				if(!src:rankedArena)
					var/obj/items/wearable/resurrection_stone/resurrect = locate() in p.Lwearing
					if(resurrect)
						if(prob(resurrect.chance))
							p << errormsg("Upon being resurrected you lost your resurrection stone.")
							if(resurrect.Consume())
								resurrect.Equip(p, 1)
						new /obj/corpse (loc, src, -1)
					else if(p.resurrect)
						p.resurrect = 0
						new /obj/corpse (loc, src, -1)
					else
						if(src.level < lvlcap)
							src.Exp = round(src.Exp * 0.8)

						var/goldLoss
						if(SHIELD_GOLD in p.passives)
							goldLoss = 0
						else
							var/gold/g = new(src)
							goldLoss = g.toNumber() * 0.2
							g.change(src, bronze=-goldLoss)
						new /obj/corpse (loc, src, goldLoss)

					p.onDeath(loc, resurrect)

					src.sight &= ~BLIND
					src:Transfer(B.loc)
					src.dir = SOUTH
					src.FlickState("Orb",12,'Effects.dmi')
					p.lastHostile = 0
			if(isplayer(killer))
				p.pdeaths+=1
				if(p.rankedArena)
					p.rankedArena.death(src)
				if(killer != src)
					if(clanwars)
						if(p.getRep() < -100)
							clanwars_event.add_auror(1)

						else if(p.getRep() > 100)
							clanwars_event.add_de(1)

					killer:pkills+=1
					displayKills(killer, 1, 1)

					var/spamKilled      = killer.findStatusEffect(/StatusEffect/KilledPlayer)
					var/spamKilledQuest = killer.findStatusEffect(/StatusEffect/KilledPlayerQuest)

					var/rndexp = round(src.level * 1.5) + rand(-200,200)
					if(rndexp < 0) rndexp = rand(20,30)

					if(killer:House == worldData.housecupwinner)
						rndexp *= 1.5

					if(spamKilled)
						rndexp = rndexp * 0.1
					else if(killer.level >= lvlcap)
						new /StatusEffect/KilledPlayer (killer, 40)
						rndexp *= 6

					rndexp = round(rndexp, 1)

					if(!spamKilledQuest)
						new /StatusEffect/KilledPlayerQuest (killer, 20)
						killer:checkQuestProgress("Kill Player")

					killer:addExp(rndexp)
					if(killer:wand)
						var/obj/items/wearable/wands/w = killer:wand
						w.addExp(killer, round(rndexp / 30))

					if(killer:pet)
						var/obj/items/wearable/pets/pet = killer:pet.item
						pet.addExp(killer, round(rndexp / 30))

					if(killer.level < lvlcap)
						killer << infomsg("You knocked [src] out and gained [rndexp] exp.")
					else
						var/gold/g = new(bronze=rndexp)
						g.give(killer)
						killer<<infomsg("You knocked [src] out and gained [g.toString()].")
				else
					src<<"You knocked yourself out!"
			else
				p.edeaths+=1


		else
			if(isplayer(killer) && !killer:Immortal)
				if(istype(src, /mob/Enemies))
					if(!istype(src, /mob/Enemies/Summoned) && src.name == initial(src.name))
						killer.AddKill(src.name)
					killer:checkQuestProgress("Kill [src.name]")
					if(src:isElite)
						killer:checkQuestProgress("Kill Elites")

				killer:ekills+=1
				displayKills(killer, 1, 2)
				var/gold2give = (rand(6,14)/10)*gold
				var/exp2give  = (rand(6,14)/10)*Expg

				if((SWORD_ANIMAGUS in killer:passives) && killer:Animagus && killer:animagusPower < 100 + killer:Animagus.level && prob(39 + killer:passives[SWORD_ANIMAGUS]))
					killer:animagusPower++

				if(killer.level > src.level && !killer:hardmode)
					gold2give -= gold2give * ((killer.level-src.level)/150)
					exp2give  -= exp2give  * ((killer.level-src.level)/150)

				if(killer:House == worldData.housecupwinner)
					gold2give *= 1.5
					exp2give  *= 1.5

				exp2give *= worldData.expModifier

				var/StatusEffect/Lamps/Gold/gold_rate = killer.findStatusEffect(/StatusEffect/Lamps/Gold)
				var/StatusEffect/Lamps/Exp/exp_rate   = killer.findStatusEffect(/StatusEffect/Lamps/Exp)

				if(gold_rate) gold2give *= gold_rate.rate
				if(exp_rate)  exp2give  *= exp_rate.rate

				if(killer:guild) exp2give *= 1 + killer:getGuildAreas() * 0.1

				gold2give = round(gold2give)
				var/gold/g = new(bronze=gold2give)

				if(exp2give > 0 && killer.level < lvlcap)
					killer:expAlert(exp2give, "Level")

				if(killer.MonsterMessages)
					if(gold2give > 0)
						killer << "<i><small>You knocked [src] out and gained [g.toString()].</small></i>"
					else
						killer << "<i><small>You knocked [src] out!</small></i>"

				if(gold2give > 0)
					g.give(killer)
				if(exp2give > 0)
					if(killer:party)
						killer:party.addExp(exp2give, killer, exp_rate ? exp_rate.rate : 1)
					else
						killer:addExp(exp2give, !killer.MonsterMessages)

					if(killer:wand)
						var/obj/items/wearable/wands/w = killer:wand
						w.addExp(killer, round(exp2give / 50))

					if(killer:pet)
						var/obj/items/wearable/pets/pet = killer:pet.item
						pet.addExp(killer, round(exp2give / 50))

			if(istype(src, /mob/Enemies))
				src:Death(killer)
			src.loc=null
			Respawn(src, killer)

mob/Player/proc/Auto_Mute(timer=15, reason="spammed")
	if(mute==0)
		mute=1
		Players << "\red <b>[src] has been silenced.</b>"

		if(reason)
			src << "<b>You've been muted because you [reason].</b>"

		if(timer==0)
			Log_admin("[src] has been muted automatically")
		else
			Log_admin("[src] has been muted automatically for [timer] minutes")
			timerMute = timer
			if(timer != 0)
				src << "<u>You've been muted for [timer] minute[timer==1 ? "" : "s"].</u>"
			mute_countdown()

		spawn()sql_add_plyr_log(ckey,"si",reason,timer)


mob/Player/proc/resetStatPoints()
	StatPoints = level - 1
	Dmg = level + 4
	Def = level + 4
	cooldownModifier = 1
	MPRegen = 0
	resetMaxHP()
	if(level > 1 && !(locate(/hudobj/UseStatpoints) in client.screen))
		new /hudobj/UseStatpoints(null, client, null, show=1)

	if(level == lvlcap && rankLevel)
		StatPoints += rankLevel.level


mob/Player/proc/resetMaxHP()
	MHP = 4 * (level - 1) + 200 + 2 * (Def + clothDef)
	if(HP > MHP)
		HP = MHP
	if(hpBar)
		updateHP()

mob/Player/proc/resetMaxMP()
	MMP = 6 * level + 194 + extraMP + ( MPRegen / 4 )
	if(MP > MMP)
		MP = MMP
	updateMP()

mob/Player
	proc
		LvlCheck(var/nomsg=0)
			if(level >= lvlcap)
				Exp = 0
				return
			if(src.Exp>=src.Mexp)
				level++
				Dmg+=1
				Def+=1
				resetMaxHP()
				resetMaxMP()
				HP=MHP
				MP=MMP
				updateHPMP()
				Exp=0

				StatPoints++
				if(level % 20 == 0)
					spellpoints += 1
					src << "You have gained a <b>Spell Point!</b> You now have [spellpoints] Spell Points."

				lvlGlow()


				if(!(locate(/hudobj/UseStatpoints) in client.screen))
					new /hudobj/UseStatpoints(null, client, null, show=1)

				if(!nomsg)
					screenAlert("You are now level [level]!")
					src<<"You have gained a statpoint, click + next to your health bar."

				var/currentyear = (Year == "Hogwarts Graduate" ? 8 : text2num(copytext(Year, 1, 2)))
				var/theiryear = level2year(level)

				if(theiryear > currentyear)

					for(var/i=currentyear+1 to theiryear)
						if(i == 2)
							src.Year="2nd Year"
							src<<"<b>Congratulations, [src]! You are now a 2nd Year!</b>"
							verbs += /mob/Spells/verb/Episky
						else if(i == 3)
							Year="3rd Year"
							src<<"<b>Congratulations, [src]! You are now a 3rd Year!</b>"
							src<<infomsg("You learned how to cancel transfigurations!")
							verbs += /mob/Spells/verb/Episky
							verbs += /mob/Spells/verb/Self_To_Human
						else if(i == 4)
							Year="4th Year"
							src<<"<b>Congratulations, [src]! You are now a 4th Year!</b>"
							verbs += /mob/Spells/verb/Self_To_Dragon
							src<<infomsg("You learned how to Transfigure yourself into a fearsome Dragon!")
						else if(i == 5)
							src.Year="5th Year"
							src<<"<b>Congratulations, [src]! You are now a 5th Year!</b>"
						else if(i == 6)
							src.Year="6th Year"
							src<<"<b>Congratulations, [src]! You are now a 6th Year!</b>"
						else if(i == 7)
							src.Year="7th Year"
							src<<"<b>Congratulations, [src]! You are now a 7th Year!</b>"
						else if(i == 8)
							Year="Hogwarts Graduate"
							src<<"<b>Congratulations, [src]! You have graduated from Hogwarts and attained the rank of Hogwarts Graduate.</b>"
							src<<infomsg("You can now view your damage & defense stats in the stats tab.")

							startQuest("Amato Animo Animato Animagus")


				var/obj/items/wearable/seal_bracelet/seal = locate() in Lwearing
				if(seal)
					if(seal.level > level) seal.exp += Mexp

					if(level == lvlcap) seal.Equip(src)

				if(level <= 600)
					Mexp += 50 * theiryear + 60 * (theiryear - 1)
				else
					var/tier = round(level / 50)
					Mexp += 100 * tier

				if(level == lvlcap && rankLevel)
					StatPoints += rankLevel.level

					if(seal)
						rankLevel.add(round(seal.exp / 10, 1), src)

mob/proc/Check_Death_Drop()
	usr=src
	for(var/obj/drop_on_death/O in src)
		O.Drop()


mob/Player/var/tmp/list/obj/stackobj/stackobjects

obj/var/useTypeStack = 0
obj/var/stackName

mob/Player/proc/Resort_Stacking_Inv()

	if(Lfavorites)
		for(var/obj/o in src:Lfavorites)
			if(o.loc != src)
				Lfavorites -= o

		if(Lfavorites.len == 0) Lfavorites = null

	var/list/counts = list()

	for(var/obj/O in contents)
		if(istype(O,/obj/stackobj))
			O.loc = null
		else
			var/T
			if(O.useTypeStack == 0)
				T = O.type
			else if(O.useTypeStack == 1)
				T = O.parent_type
			else
				T = O.useTypeStack

			if(!(T in counts)) counts[T] = list()
			counts[T] += O

	if(length(counts))
		var/list/obj/stackobj/tmpstackobjects = list()
		for(var/V in counts)
			var/list/l = counts[V]
			if(l.len > 1)
				var/obj/stackobj/stack = new
				var/obj/tmpV = new V
				stack.containstype = V
				if(src:stackobjects)
					if(src:stackobjects[V])
						var/obj/stackobj/tmpstack = src:stackobjects[V]
						stack.isopen = tmpstack.isopen
				stack.icon = tmpV.icon
				stack.icon_state = tmpV.icon_state
				stack.name = tmpV.stackName ? tmpV.stackName : tmpV.name
				contents += stack

				stack.contains = l
				var/c = 0
				for(var/obj/items/i in stack.contains)
					c += i.stack
				stack.suffix = "<span style=\"color:red;\">(x[c])</span>"
				stack.count = c
				tmpstackobjects[V] = stack
		src:stackobjects = tmpstackobjects
	else
		src:stackobjects = null

proc/getMasteryRank(var/uses)
	var/i = round(log(10, uses))
	if(i >= 6) return "Grandmaster"
	if(i >= 5) return "Master"
	if(i >= 4) return "Professional"
	if(i >= 3) return "Skilled"
	if(i >= 2) return "Apprentice"
	if(i >= 1) return "Beginner"
	return "Clueless"

mob/Player
	var/tmp
		obj/favorites/objFavorites = new
		list/mousehelper = list()
		showItems = 0

		backpackOpen = 0

	proc/InitMouseHelper()

		mousehelper["Fire"]            = new /obj/mousehover/Fire
		mousehelper["Water"]           = new /obj/mousehover/Water
		mousehelper["Earth"]           = new /obj/mousehover/Earth
		mousehelper["Ghost"]           = new /obj/mousehover/Ghost
		mousehelper["Taming"]          = new /obj/mousehover/Taming
		mousehelper["Gathering"]       = new /obj/mousehover/Gathering
		mousehelper["Animagus"]        = new /obj/mousehover/Animagus
		mousehelper["Alchemy"]         = new /obj/mousehover/Alchemy
		mousehelper["Summoning"]       = new /obj/mousehover/Summoning
		mousehelper["Spellcrafting"]   = new /obj/mousehover/Spellcrafting
		mousehelper["TreasureHunting"] = new /obj/mousehover/Treasure_Hunting
		mousehelper["Slayer"]          = new /obj/mousehover/Slayer


	Stat()
		if(statpanel("Character"))
			stat("Name:",src.name)
			stat("Year:",src.Year)
			stat("House:",src.House)
			stat("Level:",src.level)
			stat("HP:","[src.HP]/[src.MHP]")
			if(Shield > 0)
				stat("Shield:","[Shield]")
			stat("MP:","[src.MP]/[src.MMP]")
			stat("Damage:","[Dmg] ([Dmg - (level + 4)])")
			stat("Defense:","[Def] ([(Def - (level + 4))/3])")
			stat("Cooldown Reduction:","[round(1000 - (cooldownModifier+extraCDR)*1000, 1)/10]%")
			stat("MP Regeneration:", "[50 + round(level/10)*2 + MPRegen + extraMPRegen]")
			stat("Armor:", "[Armor]")
			stat("Monster Damage:", "[monsterDmg]%")
			stat("Monster Defense:", "[monsterDef]%")
			stat("Summon Limit:", "[1 + extraLimit + round(Summoning.level / 10)]")
			if(level >= lvlcap && rankLevel)
				var/percent = round((rankLevel.exp / rankLevel.maxExp) * 100)
				stat("Experience Rank: ", "[rankLevel.level]   Exp: [comma(rankLevel.exp)]/[comma(rankLevel.maxExp)] ([percent]%)")
				stat("\icon[getRankIcon()]")
			else
				var/percent = round((Exp / Mexp) * 100)
				stat("EXP:", "[comma(src.Exp)]/[comma(src.Mexp)] ([percent]%)")
			if(wand && (wand.exp + wand.quality > 0))
				var/maxExp = MAX_WAND_EXP(wand)
				var/percent = round((wand.exp / maxExp) * 100)
				stat("Wand:", "Level: [wand.quality]   Exp: [comma(wand.exp)]/[comma(maxExp)] ([percent]%)")
			if(pet)
				if(pet.item.exp + pet.item.quality > 0)
					var/maxExp = MAX_PET_EXP(pet.item)
					var/percent = round((pet.item.exp / maxExp) * 100)
					stat("[pet.name]:", "Level: [pet.item.quality]   Exp: [comma(pet.item.exp)]/[comma(maxExp)] ([percent]%)")

					percent = min(round(pet.stepCount / 10, 1), 100)
					stat("",            "Happiness: [percent]%")
				else
					var/percent = min(round(pet.stepCount / 10, 1), 100)
					stat("[pet.name]:", "Happiness: [percent]%")
			stat("Stat points:", StatPoints)
			stat("Spell points:", spellpoints)
			stat("Threads:", threads)
			if(learning)
				stat("Learning:", learning.name)
				stat("Uses required:", learning.uses)

		if(statpanel("Skills"))
			if(Fire)
				var/percent = round((Fire.exp / Fire.maxExp) * 100)
				var/obj/o = mousehelper["Fire"]
				o.name = "Level: [Fire.level]   Exp: [comma(Fire.exp)]/[comma(Fire.maxExp)] ([percent]%)"
			if(Earth)
				var/percent = round((Earth.exp / Earth.maxExp) * 100)
				var/obj/o = mousehelper["Earth"]
				o.name = "Level: [Earth.level]   Exp: [comma(Earth.exp)]/[comma(Earth.maxExp)] ([percent]%)"
			if(Water)
				var/percent = round((Water.exp / Water.maxExp) * 100)
				var/obj/o = mousehelper["Water"]
				o.name = "Level: [Water.level]   Exp: [comma(Water.exp)]/[comma(Water.maxExp)] ([percent]%)"
			if(Ghost)
				var/percent = round((Ghost.exp / Ghost.maxExp) * 100)
				var/obj/o = mousehelper["Ghost"]
				o.name = "Level: [Ghost.level]   Exp: [comma(Ghost.exp)]/[comma(Ghost.maxExp)] ([percent]%)"
			if(animagusState && Animagus)
				var/percent = round((Animagus.exp / Animagus.maxExp) * 100)
				var/obj/o = mousehelper["Animagus"]
				o.name = "Level: [Animagus.level]   Exp: [comma(Animagus.exp)]/[comma(Animagus.maxExp)] ([percent]%)"
			if(Gathering)
				var/percent = round((Gathering.exp / Gathering.maxExp) * 100)
				var/obj/o = mousehelper["Gathering"]
				o.name = "Level: [Gathering.level]   Exp: [comma(Gathering.exp)]/[comma(Gathering.maxExp)] ([percent]%)"
			if(Taming)
				var/percent = round((Taming.exp / Taming.maxExp) * 100)
				var/obj/o = mousehelper["Taming"]
				o.name = "Level: [Taming.level]   Exp: [comma(Taming.exp)]/[comma(Taming.maxExp)] ([percent]%)"
			if(Alchemy)
				var/percent = round((Alchemy.exp / Alchemy.maxExp) * 100)
				var/obj/o = mousehelper["Alchemy"]
				o.name = "Level: [Alchemy.level]   Exp: [comma(Alchemy.exp)]/[comma(Alchemy.maxExp)] ([percent]%)"
			if(Slayer)
				var/percent = round((Slayer.exp / Slayer.maxExp) * 100)
				var/obj/o = mousehelper["Slayer"]
				o.name = "Level: [Slayer.level]   Exp: [comma(Slayer.exp)]/[comma(Slayer.maxExp)] ([percent]%)"
				if(Slayer.level >= 10)
					o.name += "\n\n"
					var/end = round(min(10, Slayer.level / 10))
					for(var/i = 0 to end)
						var/txt = hardmode == i ? "\[[i]]" : "[i]"
						if(i == end)
							o.name += " [txt]\n"
						else
							o.name += " [txt] |"
			if(Summoning)
				var/percent = round((Summoning.exp / Summoning.maxExp) * 100)
				var/obj/o = mousehelper["Summoning"]
				o.name = "Level: [Summoning.level]   Exp: [comma(Summoning.exp)]/[comma(Summoning.maxExp)] ([percent]%)"

				if(Slayer.level >= 30)
					o.name += "\n\n"
					var/end = 1 + round(min(5, Summoning.level / 30))
					for(var/i = 1 to end)
						var/txt = summonsMode == i ? "\[[i]]" : "[i]"
						if(i == end)
							o.name += " [txt]\n"
						else
							o.name += " [txt] |"

			if(Spellcrafting)
				var/percent = round((Spellcrafting.exp / Spellcrafting.maxExp) * 100)
				var/obj/o = mousehelper["Spellcrafting"]
				o.name = "Level: [Spellcrafting.level]   Exp: [comma(Spellcrafting.exp)]/[comma(Spellcrafting.maxExp)] ([percent]%)"
			if(TreasureHunting)
				var/percent = round((TreasureHunting.exp / TreasureHunting.maxExp) * 100)
				var/obj/o = mousehelper["TreasureHunting"]
				o.name = "Level: [TreasureHunting.level]   Exp: [comma(TreasureHunting.exp)]/[comma(TreasureHunting.maxExp)] ([percent]%)"

			stat(mousehelper)

		if(istype(loc, /turf/buildable) && statpanel("Blueprints"))
			for(var/obj/items/wearable/blueprint/b in contents)
				stat(b)

		if(statpanel("Mastery"))
			for(var/spellName in SpellUses)
				var/uses = SpellUses[spellName]
				stat("[spellName]:", "[getMasteryRank(uses)] ([num2text(uses, 8)])")

		if(statpanel("Info"))
			if(admin)
				stat("CPU:", world.cpu)
				stat("Map CPU:", world.map_cpu)
				stat("Date:", time2text(world.realtime, "DDD MMM DD hh:mm:ss YYYY"))
			stat("---House points---")
			stat("Gryffindor",worldData.housepointsGSRH[1])
			stat("Slytherin",worldData.housepointsGSRH[2])
			stat("Ravenclaw",worldData.housepointsGSRH[3])
			stat("Hufflepuff",worldData.housepointsGSRH[4])
			stat("","")

			// Show current day/night phase and time until the next state
			if(current_state)
				var/remaining = day_phase_ends - world.time
				if(remaining < 0) remaining = 0
				stat("Time of day:", current_state.name)
				stat("Until next:", ticks2time(remaining))

			if(worldData.passives)
				stat("Global Passives:","")
				for(var/i in worldData.passives)
					var/cap = uppertext(copytext(i,1,2)) + copytext(i,2)
					stat(cap)

			if(worldData.currentEvents)
				stat("Current Events:","")
				for(var/RandomEvent/e in worldData.currentEvents)
					if(e.desc)
						stat("", "[e.name] - [e.desc]")
					else if(e.endTime)
						stat("", "[e.name] - [ticks2time(e.endTime - world.time)]")
					else
						stat("", e.name)
			if(worldData.currentArena)
				if(worldData.currentArena.roundtype == HOUSE_WARS)
					stat("Arena:")
					stat("Gryffindor",worldData.currentArena.teampoints["Gryffindor"])
					stat("Slytherin",worldData.currentArena.teampoints["Slytherin"])
					stat("Hufflepuff",worldData.currentArena.teampoints["Hufflepuff"])
					stat("Ravenclaw",worldData.currentArena.teampoints["Ravenclaw"])
				else if(worldData.currentArena.roundtype == FFA_WARS)
					stat("Arena: (Players Alive)")
					for(var/mob/M in worldData.currentArena.players)
						stat("-",M.name)
			if(worldData.currentMatches.arenas)
				stat("Matchmaking:", "(Click to spectate. Click again to stop.)")
				for(var/arena/a in worldData.currentMatches.arenas)
					stat(a.spectateObj)

		if(statpanel("Backpack"))
			if(!backpackOpen)
				backpackOpen = 1
				winset(src, "backpack", "is-visible=true")
		else
			if(backpackOpen)
				backpackOpen = 0
				winset(src, "backpack", "is-visible=false")

		if(showItems || contents.len > BACKPACK_ROWS * BACKPACK_COLS)
			if(statpanel("Items"))

				var/list/money = list()
		//		var/list/stacked
				var/list/other = list()

				for(var/obj/O in src.contents)
					if(istype(O, /obj/items/money))
						money += O
			//		else if(istype(O,/obj/stackobj))

			//			if(!stacked) stacked = list()
			//			stacked += O

					else
						if(Lfavorites && (O in Lfavorites)) continue

						other += O

			//			var/t
			//			if(O.useTypeStack == 0)
			//				t = O.type
			//			else if(O.useTypeStack == 1)
			//				t = O.parent_type
			//			else
			//				t = O.useTypeStack
			//			if(!src:stackobjects || !(src:stackobjects.Find(t))) //If there's NOT a stack object for this obj type, print it
			//				if(!other) other = list()
			//				other += O


				if(money)
					stat("Money:")
					stat(money)

				stat(objFavorites.isopen ? "-" : "+", objFavorites)
				if(objFavorites.isopen && Lfavorites)
					stat(Lfavorites)

				stat("Items:")
				if(other)
					stat(other)

	/*		if(stacked)
				stat("Click to expand stacked items.")
				for(var/obj/stackobj/s in stacked)
					stat("+", s)
					if(s.isopen)
						for(var/obj/B in s.contains)
							if(Lfavorites && (B in Lfavorites)) continue
							stat("-", B)*/
//		if(statpanel("Info"))
/*			stat("Name:",src.name)
			stat("Year:",src.Year)
			stat("House:",src.House)
			stat("Level:",src.level)
			stat("HP:","[src.HP]/[src.MHP]")
			stat("MP:","[src.MP]/[src.MMP]")
			stat("Damage:","[Dmg] ([Dmg - (level + 4)])")
			stat("Defense:","[Def] ([(Def - (level + 4))/3])")
			stat("Cooldown Reduction:","[round(1000 - cooldownModifier*1000, 1)/10]%")
			stat("MP Regeneration:", "[50 + round(level/10)*2 + MPRegen]")
			stat("","")

			if(Fire)
				var/percent = round((Fire.exp / Fire.maxExp) * 100)
				var/obj/o = mousehelper["Fire"]
				o.name = "Level: [Fire.level]   Exp: [comma(Fire.exp)]/[comma(Fire.maxExp)] ([percent]%)"
			if(Earth)
				var/percent = round((Earth.exp / Earth.maxExp) * 100)
				var/obj/o = mousehelper["Earth"]
				o.name = "Level: [Earth.level]   Exp: [comma(Earth.exp)]/[comma(Earth.maxExp)] ([percent]%)"
			if(Water)
				var/percent = round((Water.exp / Water.maxExp) * 100)
				var/obj/o = mousehelper["Water"]
				o.name = "Level: [Water.level]   Exp: [comma(Water.exp)]/[comma(Water.maxExp)] ([percent]%)"
			if(Ghost)
				var/percent = round((Ghost.exp / Ghost.maxExp) * 100)
				var/obj/o = mousehelper["Ghost"]
				o.name = "Level: [Ghost.level]   Exp: [comma(Ghost.exp)]/[comma(Ghost.maxExp)] ([percent]%)"
			if(animagusState && Animagus)
				var/percent = round((Animagus.exp / Animagus.maxExp) * 100)
				var/obj/o = mousehelper["Animagus"]
				o.name = "Level: [Animagus.level]   Exp: [comma(Animagus.exp)]/[comma(Animagus.maxExp)] ([percent]%)"
			if(Gathering)
				var/percent = round((Gathering.exp / Gathering.maxExp) * 100)
				var/obj/o = mousehelper["Gathering"]
				o.name = "Level: [Gathering.level]   Exp: [comma(Gathering.exp)]/[comma(Gathering.maxExp)] ([percent]%)"
			if(Taming)
				var/percent = round((Taming.exp / Taming.maxExp) * 100)
				var/obj/o = mousehelper["Taming"]
				o.name = "Level: [Taming.level]   Exp: [comma(Taming.exp)]/[comma(Taming.maxExp)] ([percent]%)"
			if(Alchemy)
				var/percent = round((Alchemy.exp / Alchemy.maxExp) * 100)
				var/obj/o = mousehelper["Alchemy"]
				o.name = "Level: [Alchemy.level]   Exp: [comma(Alchemy.exp)]/[comma(Alchemy.maxExp)] ([percent]%)"
			if(Slayer)
				var/percent = round((Slayer.exp / Slayer.maxExp) * 100)
				var/obj/o = mousehelper["Slayer"]
				o.name = "Level: [Slayer.level]   Exp: [comma(Slayer.exp)]/[comma(Slayer.maxExp)] ([percent]%)"
			if(Summoning)
				var/percent = round((Summoning.exp / Summoning.maxExp) * 100)
				var/obj/o = mousehelper["Summoning"]
				o.name = "Level: [Summoning.level]   Exp: [comma(Summoning.exp)]/[comma(Summoning.maxExp)] ([percent]%)"
			if(Spellcrafting)
				var/percent = round((Spellcrafting.exp / Spellcrafting.maxExp) * 100)
				var/obj/o = mousehelper["Spellcrafting"]
				o.name = "Level: [Spellcrafting.level]   Exp: [comma(Spellcrafting.exp)]/[comma(Spellcrafting.maxExp)] ([percent]%)"
			if(TreasureHunting)
				var/percent = round((TreasureHunting.exp / TreasureHunting.maxExp) * 100)
				var/obj/o = mousehelper["TreasureHunting"]
				o.name = "Level: [TreasureHunting.level]   Exp: [comma(TreasureHunting.exp)]/[comma(TreasureHunting.maxExp)] ([percent]%)"

			stat("---Skills---")
			stat(mousehelper)
			stat("","")

			if(level >= lvlcap && rankLevel)
				var/percent = round((rankLevel.exp / rankLevel.maxExp) * 100)
				stat("Experience Rank: ", "[rankLevel.level]   Exp: [comma(rankLevel.exp)]/[comma(rankLevel.maxExp)] ([percent]%)")
				stat("\icon[getRankIcon()]")
			else
				var/percent = round((Exp / Mexp) * 100)
				stat("EXP:", "[comma(src.Exp)]/[comma(src.Mexp)] ([percent]%)")
			if(wand && (wand.exp + wand.quality > 0))
				var/maxExp = MAX_WAND_EXP(wand)
				var/percent = round((wand.exp / maxExp) * 100)
				stat("Wand:", "Level: [wand.quality]   Exp: [comma(wand.exp)]/[comma(maxExp)] ([percent]%)")
			if(pet)
				if(pet.item.exp + pet.item.quality > 0)
					var/maxExp = MAX_PET_EXP(pet.item)
					var/percent = round((pet.item.exp / maxExp) * 100)
					stat("[pet.name]:", "Level: [pet.item.quality]   Exp: [comma(pet.item.exp)]/[comma(maxExp)] ([percent]%)")

					percent = min(round(pet.stepCount / 10, 1), 100)
					stat("",            "Happiness: [percent]%")
				else
					var/percent = min(round(pet.stepCount / 10, 1), 100)
					stat("[pet.name]:", "Happiness: [percent]%")
			stat("Stat points:", StatPoints)
			stat("Spell points:", spellpoints)
			stat("Threads:", threads)
			if(learning)
				stat("Learning:", learning.name)
				stat("Uses required:", learning.uses)
			if(admin)
				stat("CPU:", world.cpu)
				stat("Date:", time2text(world.realtime, "DDD MMM DD hh:mm:ss YYYY"))
			stat("---House points---")
			stat("Gryffindor",worldData.housepointsGSRH[1])
			stat("Slytherin",worldData.housepointsGSRH[2])
			stat("Ravenclaw",worldData.housepointsGSRH[3])
			stat("Hufflepuff",worldData.housepointsGSRH[4])
			stat("","")
			if(worldData.currentEvents)
				stat("Current Events:","")
				for(var/RandomEvent/e in worldData.currentEvents)
					if(e.desc)
						stat("", "[e.name] - [e.desc]")
					else if(e.endTime)
						stat("", "[e.name] - [ticks2time(e.endTime - world.time)]")
					else
						stat("", e.name)
			if(worldData.currentArena)
				if(worldData.currentArena.roundtype == HOUSE_WARS)
					stat("Arena:")
					stat("Gryffindor",worldData.currentArena.teampoints["Gryffindor"])
					stat("Slytherin",worldData.currentArena.teampoints["Slytherin"])
					stat("Hufflepuff",worldData.currentArena.teampoints["Hufflepuff"])
					stat("Ravenclaw",worldData.currentArena.teampoints["Ravenclaw"])
				else if(worldData.currentArena.roundtype == FFA_WARS)
					stat("Arena: (Players Alive)")
					for(var/mob/M in worldData.currentArena.players)
						stat("-",M.name)
			if(worldData.currentMatches.arenas)
				stat("Matchmaking:", "(Click to spectate. Click again to stop.)")
				for(var/arena/a in worldData.currentMatches.arenas)
					stat(a.spectateObj)*/


mob/Login()
	..()
	active_mobs += src

mob/Logout()
	..()
	active_mobs -= src 

world/New()
    ..()
    spawn() GlobalMobProcessor()

proc/GlobalMobProcessor()
    while(TRUE)
        for(var/mob/Player/M in active_mobs)
            M.ProcessTick()
        sleep(15)

mob/Player/proc/ProcessTick()