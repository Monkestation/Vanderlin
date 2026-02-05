
///books that teach things (intrinsic actions like bar flinging, spells like fireball or smoke, or martial arts)///

/obj/item/book/granter
	due_date = 0 // Game time in deciseconds
	unique = 1   // 0  Normal book, 1  Should not be treated as normal book, unable to be copied, unable to be modified
	var/list/remarks = list() //things to read about while learning.
	var/pages_to_mastery = 3 //Essentially controls how long a mob must keep the book in his hand to actually successfully learn
	var/reading = FALSE //sanity
	var/oneuse = TRUE //default this is true, but admins can var this to 0 if we wanna all have a pass around of the rod form book
	var/used = FALSE //only really matters if oneuse but it might be nice to know if someone's used it for admin investigations perhaps

/obj/item/book/granter/proc/turn_page(mob/user)
	playsound(user, pick('sound/blank.ogg'), 30, TRUE)
	if(do_after(user, 5 SECONDS))
		if(remarks.len)
			to_chat(user, "<span class='notice'>[pick(remarks)]</span>")
		else
			to_chat(user, "<span class='notice'>I keep reading...</span>")
		return TRUE
	return FALSE

/obj/item/book/granter/proc/recoil(mob/user) //nothing so some books can just return

/obj/item/book/granter/proc/already_known(mob/user)
	return FALSE

/obj/item/book/granter/proc/on_reading_start(mob/user)
	to_chat(user, "<span class='notice'>I start reading [name]...</span>")

/obj/item/book/granter/proc/on_reading_stopped(mob/user)
	to_chat(user, "<span class='notice'>I stop reading...</span>")

/obj/item/book/granter/proc/on_reading_finished(mob/user)
	to_chat(user, "<span class='notice'>I finish reading [name]!</span>")

/obj/item/book/granter/proc/onlearned(mob/user)
	used = TRUE

/obj/item/book/granter/dropped(mob/user, silent)
	. = ..()
	reading = FALSE

/obj/item/book/granter/attack_self(mob/user, list/modifiers)
	if(user.mind?.has_studied == TRUE)
		to_chat(user, span_notice("I struggle to study my arcane notes more. Perhaps a good rest would help."))
		return FALSE
	if(reading)
		to_chat(user, span_notice("I am already reading this!"))
		return FALSE
	if(!user.can_read(src))
		return FALSE
	if(already_known(user))
		return FALSE
	if(used)
		if(oneuse)
			recoil(user)
		return FALSE
	on_reading_start(user)
	reading = TRUE
	for(var/i=1, i<=pages_to_mastery, i++)
		if(!turn_page(user))
			on_reading_stopped()
			reading = FALSE
			return
	if(do_after(user, 5 SECONDS))
		on_reading_finished(user)
		reading = FALSE
	return TRUE

///ACTION BUTTONS///

/obj/item/book/granter/action
	var/granted_action
	var/actionname = "catching bugs" //might not seem needed but this makes it so you can safely name action buttons toggle this or that without it fucking up the granter, also caps

/obj/item/book/granter/action/already_known(mob/user)
	if(!granted_action)
		return TRUE
	for(var/datum/action/A in user.actions)
		if(A.type == granted_action)
			to_chat(user, "<span class='warning'>I already know all about [actionname]!</span>")
			return TRUE
	return FALSE

/obj/item/book/granter/action/on_reading_start(mob/user)
	to_chat(user, "<span class='notice'>I start reading about [actionname]...</span>")

/obj/item/book/granter/action/on_reading_finished(mob/user)
	to_chat(user, "<span class='notice'>I feel like you've got a good handle on [actionname]!</span>")
	var/datum/action/G = new granted_action
	G.Grant(user)
	onlearned(user)

//Crafting Recipe books

/obj/item/book/granter/crafting_recipe
	var/list/crafting_recipe_types = list()

/obj/item/book/granter/crafting_recipe/on_reading_finished(mob/user)
	. = ..()
	if(!user.mind)
		return
	for(var/datum/blueprint_recipe/R as anything in crafting_recipe_types)
		user.mind.teach_crafting_recipe(R)
		to_chat(user,"<span class='notice'>I learned how to make [initial(R.name)].</span>")

//! --MAGICK SCROLLS-- !/

/obj/item/book/granter/spell
	grid_width = 64
	grid_height = 32

	var/datum/action/cooldown/spell/spell
	var/spellname = "conjure bugs"

/obj/item/book/granter/spell/already_known(mob/living/user)
	if(!spell)
		return TRUE
	if(user.get_spell(spell))
		to_chat(user,"<span class='warning'>You've already read this one!</span>")
		return TRUE
	return FALSE

/obj/item/book/granter/spell/on_reading_start(mob/user)
	to_chat(user, "<span class='notice'>I start reading about casting [spellname]...</span>")

/obj/item/book/granter/spell/on_reading_finished(mob/living/user)
	to_chat(user, "<span class='notice'>I feel like you've experienced enough to cast [spellname]!</span>")
	user.add_spell(spell)
	user.log_message("learned the spell [spellname]", LOG_ATTACK, color="orange")
	onlearned(user)

/obj/item/book/granter/spell/recoil(mob/user)
	user.visible_message("<span class='warning'>[src] glows in a black light!</span>")

/obj/item/book/granter/spell/onlearned(mob/user)
	..()
	if(oneuse)
		user.visible_message("<span class='warning'>[src] glows dark for a second!</span>")

/obj/item/book/granter/spell/magick/
	desc = "A scroll of potential known only to those that can decipher its secrets."
	icon = 'icons/roguetown/items/misc.dmi'
	oneuse = TRUE
	drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
	pickup_sound =  'sound/blank.ogg'

/obj/item/book/granter/spell/magick/onlearned(mob/living/carbon/user)
	..()
	if(oneuse == TRUE)
		name = "siphoned scroll"
		desc = "A scroll once inscribed with magical scripture. The surface is now barren of knowledge, siphoned by someone else. It's utterly useless."
		icon_state = "scroll"
		user.visible_message(span_warning("[src] has had its magic ink ripped from the scroll!"))

/obj/item/book/granter/spell/magick/fireball
	name = "Scroll of Fireball"
	spell = /datum/action/cooldown/spell/projectile/fireball
	spellname = "fireball"
	icon_state = "scrollred"
	remarks = list("Ignis et oleum..", "Flammam continere ad momentum..", "Flammam iactare..", "Sit flamma constructum..")

/obj/item/book/granter/spell/magick/greaterfireball
	name = "Scroll of Greater Fireball"
	spell =  /datum/action/cooldown/spell/projectile/fireball/greater
	spellname = "greater fireball"
	icon_state = "scrolldarkred"
	remarks = list("Ignis et oleum..", "Flammam continere ad momentum..", "Flammam iactare..", "Sit flamma constructum..")

/obj/item/book/granter/spell/magick/lightning
	name = "Scroll of Lightning"
	spell =  /datum/action/cooldown/spell/projectile/lightning
	spellname = "lightning"
	icon_state = "scrollyellow"
	remarks = list("Essentia fulgurum digitorum..", "Fulgur de nubibus desuper..", "Fulgur eiecit digitos..", "Praecipe intus aedificatur..")

/obj/item/book/granter/spell/magick/fetch
	name = "Scroll of Fetch"
	spell =  /datum/action/cooldown/spell/projectile/fetch
	spellname = "fetch"
	icon_state = "scrollpurple"
	remarks = list("Returnus Revico..", "Manus de reverti..", "Menus de returnus..")

/obj/item/book/granter/spell/magick/blindness
	name = "Scroll of Blindness"
	spell = /datum/action/cooldown/spell/blindness
	spellname = "blindness"
	icon_state = "scrollpurple"
	remarks = list("Occultare oculos..", "Vivus amoevtar..", "Visioner removan..")

/obj/item/book/granter/spell/magick/invisibility
	name = "Scroll of Invisibility"
	spell = /datum/action/cooldown/spell/status/invisibility
	spellname = "invisibility"
	icon_state = "scrollpurple"
	remarks = list("Pallium nihilum..", "Occultare veritatem..", "Veritatem removan menor..")

//scroll for giving the reader a spell point, this should be dungeon loot
/obj/item/book/granter/spell_points
	name = "Arcyne Insight"
	icon_state = "scrollpurple"
	icon = 'icons/roguetown/items/misc.dmi'
	oneuse = TRUE
	drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
	pickup_sound =  'sound/blank.ogg'

/obj/item/book/granter/spell_points/on_reading_finished(mob/living/user)
	var/arcaneskill = user.get_skill_level(/datum/skill/magic/arcane)
	if(arcaneskill >= SKILL_LEVEL_NOVICE) //Required arcane skill of NOVICE or higher to use the granter
		to_chat(user, span_notice("I absorb the insights on the scroll, and feel more adept at spellcraft!"))
		user.adjust_spell_points(1)
		onlearned(user)
	else
		to_chat(user, span_notice("I don't know what to make of this."))

/obj/item/book/granter/spell_points/onlearned(mob/living/carbon/user)
	..()
	if(oneuse == TRUE)
		name = "siphoned scroll"
		desc = "A scroll once inscribed with magical scripture. The surface is now barren of knowledge, siphoned by someone else. It's utterly useless."
		icon_state = "scroll"
		user.visible_message(span_warning("[src] has had its magic ink ripped from the scroll!"))
