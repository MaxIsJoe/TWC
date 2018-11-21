#define MAXFOOD
#define MAXPOTIONS
var/readfortune = 0

proc/EatMessage(src as text)
	var/randomEatingMessage = pick("<font color=#00FFFF>[usr] hungrily starts eating the [src]</font>",
	                     	"<font color=#00FFFF>[usr] nibbles on the [src]</font>",
	                     	"<font color=#00FFFF>[usr] finishes eating [src] in one bite! what a beast!</font>",
	                     	"<font color=#00FFFF>[usr] enjoys their [src]</font>",
	                     	"<font color=#00FFFF>[usr] starts eating the [src]</font>")
	hearers()<< "[randomEatingMessage]"

proc/DrinkMessage(src as text)
	var/randomDrinkingMessage = pick("<font color=#00FFFF>[usr] starting drinking [src]</font>",
	                     	"<font color=#00FFFF>[usr] drinks [src] in one go</font>",
	                     	"<font color=#00FFFF>[usr] drinks [src] and spills abit of liqud on their uniform, oh no.</font>",
	                     	"<font color=#00FFFF>[usr] enjoys their [src]</font>")
	hearers()<< "[randomDrinkingMessage]"



obj/maxfood
	verb
		Grab()
			set src in oview(1)
			hearers()<< "<i>[usr] grabs the [src].</i>"
			Move(usr)
		Drop()
			usr << "You drop the [src]."
			Move(usr.loc)
	fortune_cookie
		icon = 'FoodMax.dmi'
		icon_state = "FoodBiscuit"
		name = "Fortune Cookie"
		verb
			Eat()
				var/maxMP = usr.MMP + usr.extraMMP
				if(usr.MP <= maxMP)
					EatMessage(src)
					usr.MP += 10
					usr.updateHPMP()
					new /obj/maxfood/fortune_scroll(usr.loc)
					usr << "<font color=green>The cookie drops a small scroll from it's other end after you bit it!</font>"
					del src
				if(usr.MP >= maxMP)
					usr << "<font color=red>you don't feel like eating anything right now.."
	fortune_scroll
		icon = 'Scroll.dmi'
		name = "Fortune scroll"
		verb
			read()
				if(!readfortune)
					usr << pick("You will die soon.",
	                     	"You will earn 10 silver by the end of the day.",
	                     	"It will rain today, stay indoors!",
	                     	"The dark lord is coming for you.",
	                     	"A student will make you miss up your potion during potions class.",
	                     	"The person who will loot your corpse is your best friend.",
	                     	"Ravenclaw will win the next house cup and your hard work will vanish.",
	                     	"A laddy selling fortune cookies has her eyes on you for some reason.",
	                     	"A guardian is looking after you.",
	                     	"Your shoes will make you happy today.",
	                     	"LIFE CONSISTS NOT IN HOLDING GOOD CARDS, BUT IN PLAYING THOSE YOU HOLD WELL.",
	                     	"A dream you have will come true.",
	                     	"You learn from your mistakes... You will learn a lot today.",
	                     	"Our deeds determine us, as much as we determine our deeds.",
	                     	"You already know the answer to the questions lingering inside your head.",
	                     	"Joys are often the shadows, cast by sorrows.",
	                     	"It's better to be alone sometimes.",
	                     	"A new voyage will fill your life with untold memories.",
	                     	"Be on the lookout for coming events; They cast their shadows beforehand.",
	                     	"The greatest risk is not taking one.",
	                     	"Jealousy doesn't open doors, it closes them!",
	                     	"Its amazing how much good you can do if you dont care who gets the credit.",
	                     	"It is now, and in this world, that we must live.")
					readfortune=1
					sleep(120)
					usr << "<font color=red>The small scroll vanishes!</font>"
					readfortune=0
					del src
				else
					usr << "You cannot read the words on the scroll again for some reason."
	Bread
		icon = 'FoodMax.dmi'
		icon_state = "FoodBread"
		verb
			Eat()
				var/maxMP = usr.MMP + usr.extraMMP
				if(usr.MP < maxMP)
					EatMessage(src)
					usr.MP += 25
					usr.HP += 100
					usr.updateHPMP()
					del src
				if(usr.MP >= maxMP)
					usr << "<font color=red>You don't feel like eating anything right now.."
	Fish
		icon = 'Food.dmi'
		icon_state = "food16"
		verb
			Eat()
				var/maxMP = usr.MMP + usr.extraMMP
				if(usr.MP < maxMP)
					EatMessage(src)
					usr.MP += 300
					usr.HP += 95
					usr.updateHPMP()
					del src
				if(usr.MP >= maxMP)
					usr << "<font color=red>You don't feel like eating anything right now.."
	Ale
		icon = 'FoodMax.dmi'
		icon_state = "FoodAle"
		verb
			Drink()
				var/maxMP = usr.MMP + usr.extraMMP
				if(usr.MP < maxMP)
					DrinkMessage(src)
					usr.MP += 60
					usr.updateHPMP()
					del src
				if(usr.MP >= maxMP)
					usr << "<font color=red>You don't feel like drinking anything right now.."
	CookedMeat
		name = "Meat"
		icon = 'FoodMax.dmi'
		icon_state = "CookedMeat"
		verb
			Eat()
				var/maxMP = usr.MMP + usr.extraMMP
				if(usr.MP < maxMP)
					EatMessage(src)
					usr.MP += 115
					usr.HP += 115
					usr.updateHPMP()
					del src
				if(usr.MP >= maxMP)
					usr << "<font color=red>You don't feel like eating anything right now.."
	RawMeat
		name = "Raw Meat"
		icon = 'FoodMax.dmi'
		icon_state = "RawMeat"
		verb
			Eat()
				usr << "<font color=red>You can't eat it raw..</font>"
	Cheese
		icon = 'FoodMax.dmi'
		icon_state = "Cheese"
		verb
			Eat()
				var/maxMP = usr.MMP + usr.extraMMP
				if(usr.MP < maxMP)
					EatMessage(src)
					usr.MP += 120
					usr.HP += 50
					usr.updateHPMP()
					del src
				if(usr.MP >= maxMP)
					usr << "<font color=red>You don't feel like eating anything right now.."
	Pie
		name = "Slice Of Pie"
		icon = 'FoodMax.dmi'
		icon_state = "SliceOPie"
		verb
			Eat()
				var/maxMP = usr.MMP + usr.extraMMP
				if(usr.MP < maxMP)
					EatMessage(src)
					usr.MP += 90
					usr.HP += 50
					usr.updateHPMP()
					del src
				if(usr.MP >= maxMP)
					usr << "<font color=red>You don't feel like eating anything right now.."
	Sundae
		name = "Sundae"
		icon = 'Food.dmi'
		icon_state = "Sundae"
		verb
			Eat()
				var/maxMP = usr.MMP + usr.extraMMP
				if(usr.MP < maxMP)
					EatMessage(src)
					usr.MP += 190
					usr.HP += 20
					usr.updateHPMP()
					del src
				if(usr.MP >= maxMP)
					usr << "<font color=red>You don't feel like eating anything right now.."


obj
	Potions_Kit
		icon ='items.dmi'
		icon_state="cabinet"
		layer = 3
		verb


			Get()
				set src in oview(1)
				src.loc = usr
			set_up()
				var/number = 0
				var/obj/Desk/O
				if(usr.Kit.len == 1) return
				for(O in view(1,usr.loc))
					if(O)
						if(number) break
						var/obj/X= new/obj/Potions_Kit(O.loc)
						usr.Kit.Add(X)
						O.owner = usr.name
						number += 1
						usr.MK = 1
						usr <<"<font color = green> You setup your cauldron on the nearest table"
					else
						usr <<"<font color = red> You don't see a Desk to setup your cauldron on"




mob
	var
		MK

	var/list/Kit = list()



client
	Del()
		var/obj/Potions_Kit/O
		if(usr.Kit.len == 1) //////
			for(O in usr.Kit)
				usr.Kit -= O
				del(O)
	..()
	Move(loc,dir)
		var/obj/Potions_Kit/O
		if(usr.Kit.len == 1)
			for(O in usr.Kit)
				usr.Kit -= O
				del(O)

			usr <<" as you step away your Potion Kit dissapears."
		..()



/* Code Above adds the kit to a list when set up and placed on a desk in front of you or the closest in your view
When you step away or logout the Kit is deleted and removed with you. */
=======
obj/maxpotions
	verb
		Drop()
			usr << "You drop the [src]."
			Move(usr.loc)
		Grab()
			set src in oview(1)
			hearers()<< "<i>[usr] grabs the [src].</i>"
			Move(usr)
	Health_Potion_Small
		icon = 'Food.dmi'
		icon_state = "food16"
		verb
			Drink()
				spawn _SoundEngine('potion_drink.wav', usr , range = 5, volume=90)
				var/maxHP = usr.MHP + usr.extraMHP
				if(usr.HP < maxHP)
					EatMessage(src)
					usr.HP += 250
					usr.updateHPMP()
					del src
				if(usr.HP >= maxHP)
					usr << "<font color=red>You don't feel like drinking it right now.."
	Health_Potion_Medium
		icon = 'Food.dmi'
		icon_state = "food16"
		verb
			Drink()
				spawn _SoundEngine('potion_drink.wav', usr , range = 5, volume=90)
				var/maxHP = usr.MHP + usr.extraMHP
				if(usr.HP < maxHP)
					EatMessage(src)
					usr.HP += 850
					usr.updateHPMP()
					del src
				if(usr.HP >= maxHP)
					usr << "<font color=red>You don't feel like drinking it right now.."


	Health_Potion_Large
		icon = 'Food.dmi'
		icon_state = "food16"
		verb
			Drink()
				spawn _SoundEngine('potion_drink.wav', usr , range = 5, volume=90)
				var/maxHP = usr.MHP + usr.extraMHP
				if(usr.HP < maxHP)
					EatMessage(src)
					usr.HP += 1200
					usr.updateHPMP()
					del src
				if(usr.HP >= maxHP)
					usr << "<font color=red>You don't feel like drinking it right now.."
	Health_Potion_Special
		icon = 'Food.dmi'
		icon_state = "food16"
		verb
			Drink()
				spawn _SoundEngine('potion_drink.wav', usr , range = 5, volume=90)
				var/maxHP = usr.HP + usr.extraMHP
				for()
					if(meditateWait >= 0)
						if(usr.HP < maxHP)
							usr.HP = min(maxHP, usr.HP + maxHP*0.05)
						//	updateHPMP() //Broken for some reason
							meditateWait -= 10
						if(meditateWait == 0)
							break
						if(usr.HP >= maxHP)
							break;
					sleep(meditateDelay)
				sleep(meditateWait)
	Mana_Potion_Small
		icon = 'FoodMax.dmi'
		icon_state = "FoodAle"
		verb
			Drink()
				spawn _SoundEngine('potion_drink.wav', usr , range = 5, volume=90)
				var/maxMP = usr.MMP + usr.extraMMP
				if(usr.MP < maxMP)
					DrinkMessage(src)
					usr.MP += 250
					usr.updateHPMP()
					del src
				if(usr.MP >= maxMP)
					usr << "<font color=red>You don't feel like drinking anything right now.."
	ManaPotion_Medium
		icon = 'FoodMax.dmi'
		icon_state = "FoodAle"
		verb
			Drink()
				spawn _SoundEngine('potion_drink.wav', usr , range = 5, volume=90)
				var/maxMP = usr.MMP + usr.extraMMP
				if(usr.MP < maxMP)
					DrinkMessage(src)
					usr.MP += 650
					usr.updateHPMP()
					del src
				if(usr.MP >= maxMP)
					usr << "<font color=red>You don't feel like drinking anything right now.."
	Mana_Potion_Large
		icon = 'FoodMax.dmi'
		icon_state = "FoodAle"
		verb
			Drink()
				spawn _SoundEngine('potion_drink.wav', usr , range = 5, volume=90)
				var/maxMP = usr.MMP + usr.extraMMP
				if(usr.MP < maxMP)
					DrinkMessage(src)
					usr.MP += 1500
					usr.updateHPMP()
					del src
				if(usr.MP >= maxMP)
					usr << "<font color=red>You don't feel like drinking anything right now.."
	Mana_Potion_Speical
		icon = 'FoodMax.dmi'
		icon_state = "FoodAle"
		verb
			Drink()
				spawn _SoundEngine('potion_drink.wav', usr , range = 5, volume=90)
				var/maxMP = usr.MMP + usr.extraMMP
				for()
					if(meditateWait >= 0)
						if(usr.MP < maxMP)
							usr.MP = min(maxMP, usr.MP + maxMP*0.12)
							//updateHPMP()
							meditateWait -= 10
						if(meditateWait == 0)
							break
						if(usr.MP >= maxMP)
							break;
					sleep(meditateDelay)
				sleep(meditateWait)
				overlays-=/image/meditate
				meditateWait = 50
