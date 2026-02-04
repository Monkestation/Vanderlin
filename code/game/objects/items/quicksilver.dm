/obj/item/quicksilver
	name = "quicksilver poultice"
	icon_state = "quicksilver"
	possible_item_intents = list(/datum/intent/use)
	icon = 'icons/roguetown/items/quicksilver.dmi'
	desc = "A daring blend of alchemy, aberrant blood, and divine silver. This panacea fortifies the anointed's body with blessed silverdust, protecting them from the curses of vampyrism and lycanthropy."
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 1
	drop_sound = 'sound/items/gem.ogg'
	resistance_flags = FIRE_PROOF
	var/miracle_use = 0
	var/success = 0

/obj/item/quicksilver/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/quicksilver/luxinfused
	name = "absolving silver"
	icon_state = "quicksilverlux"
	desc = "A daring blend of trace amounts of purifying lux, aberrant blood, and divine silver. This panacea fortifies the anointed's body with blessed silverdust, protecting them from the curses of vampyrism and lycanthropy."

/obj/item/quicksilver/examine(mob/user)
	. = ..()
	if(miracle_use)
		. += span_notice("Through some miraculous happenstance, there is enough for one more use.")

/obj/item/quicksilver/attack(mob/living/carbon/human/M, mob/living/carbon/human/user, list/modifiers)
	if(!istype(M) || !istype(user))
		return ..()

	var/inquisitor = FALSE
	if(!user.mind)
		return

	if(HAS_TRAIT(user, TRAIT_PURITAN))
		inquisitor = TRUE

	if(HAS_TRAIT(user, TRAIT_PACIFISM) && HAS_TRAIT(user, TRAIT_INQUISITION) && HAS_TRAIT(user, TRAIT_SILVER_BLESSED))
		inquisitor = TRUE

	if(!M.mind) //Stopping null lookup runtimes
		to_chat(user, span_warning("[M] does not have the mind to benefit from the holy anointment."))
		return

	if(HAS_TRAIT(M, TRAIT_SILVER_BLESSED))
		to_chat(user, span_warning("Upon closer inspection, [M] is already anointed with quicksilver."))
		return

	if(!inquisitor && !user.get_skill_level(/datum/skill/magic/holy) >= SKILL_EXP_EXPERT)
		to_chat(user, span_warning("I do not have the divine knowledge to properly apply [src]."))
		return

	if(user.patron in typesof(/datum/patron/inhumen))
		to_chat(user, span_warning("This whole anointing stuff seems like TEN nonsense. Why prevent the chaos? Besides, this paste burns my fingers."))
		return

	if(user == M)
		to_chat(user, span_warning("I cannot anoint myself with this. I must find someone else to perform the rites."))
		return

	if(M.stat == DEAD)
		to_chat(user, span_warning("With their heart stilled, the ritual will have no purchase upon them. It would be a waste."))
		return

	var/found = null
	for(var/obj/structure/fluff/psycross/S in oview(5, user))
		found = S
	if(!found)
		to_chat(user, span_warning("I need a holy cross nearby to properly apply this.")) //Like Anastasis
		return

	var/datum/antagonist/werewolf/Were = M.mind.has_antag_datum(/datum/antagonist/werewolf/)
	var/datum/antagonist/werewolf/lesser/Wereless = M.mind.has_antag_datum(/datum/antagonist/werewolf/lesser/)
	var/datum/antagonist/vampire/Vamp = M.mind.has_antag_datum(/datum/antagonist/vampire)

	user.visible_message(span_notice("[user] begins to anoint [M] with [src]."))
	if(do_after(user, 10 SECONDS, target = M))
		if(!Were && !Vamp)
			user.visible_message(span_notice("[user] anoints [M]'s brow with [src]."))
			ADD_TRAIT(M, TRAIT_SILVER_BLESSED, TRAIT_GENERIC)
			success = 1
		else
			to_chat(M, span_userdanger("This silver concoction burns! It threatens to undo me!"))
			M.emote("agony", forced = TRUE)
			M.adjustFireLoss(25)
			M.fire_act(3,3) //Not too bad, but not a single pat to put out.
			user.visible_message(span_danger("[src] bursts into flames on [M]'s brow, yet [user] vies to complete the anointment."))
			if(do_after(user, 10 SECONDS, target = M))
				user.visible_message(span_danger("[user] anoints [M]'s brow with [src]."))
				success = 1
	if(!success)
		return

	//Delete the item, or if you're the inquisitor, you squeeze another dose out of it.
	miracle_use += 1
	if((miracle_use && !inquisitor) || miracle_use > 1)
		to_chat(user, span_notice("That's all of the poultice. Only the binding cloth remains."))
		new /obj/item/natural/cloth(user.loc)
		qdel(src)
	else
		icon_state = "[initial(icon_state)]_half"
		to_chat(user, span_notice("My inquisitorial training leaves just enough of the poultice left for one more anointment."))


	//Werewolf deconversion
	if(Were && !Wereless) //The roundstart elder/alpha werewolf, it cannot be saved
		to_chat(M, span_userdanger("This wretched silver weighs heavy on my brow. Dendor's blessing shall not be quit of me so easily."))
		user.visible_message(span_danger("The silver poultice boils away from [M]'s brow, viscerally rejecting the divine anointment."))
		M.Stun(30)
		M.Knockdown(30)
		return

	else if(Wereless) //A lesser werewolf can be deconverted
		if(Were.transformed == TRUE)
			var/mob/living/carbon/human/I = M.stored_mob
			to_chat(M, span_userdanger("THE FOUL SILVER! MY BODY RENDS ITSELF ASUNDER!"))
			Were.on_removal()
			ADD_TRAIT(I, TRAIT_SILVER_BLESSED, TRAIT_GENERIC)
			I.emote("agony", forced = TRUE)
			I.Stun(30)
			I.Knockdown(30)
			I.adjust_jitter(6 SECONDS)
			return
		else
			M.flash_fullscreen("redflash3")
			M.emote("agony", forced = TRUE)
			to_chat(M, span_userdanger("THE FOUL SILVER! IT BURNS ME TO MY CORE!"))
			Were.on_removal()
			ADD_TRAIT(M, TRAIT_SILVER_BLESSED, TRAIT_GENERIC)
			M.Stun(30)
			M.Knockdown(30)
			M.adjust_jitter(6 SECONDS)
			return

	else if(Vamp) //We're the vampire, we can't be saved.
		to_chat(M, span_userdanger("This wretched silver weighs heavy on my brow. An insult I shall never forget, for as long as I die."))
		user.visible_message(span_danger("The silver poultice boils away from [M]'s brow, viscerally rejecting the divine anointment."))
		M.Stun(30)
		M.Knockdown(30)

//A letter to give info on how to make this thing.
/obj/item/paper/inquisition_poultice_info
	name = "Inquisitorial Missive"
	desc = "A letter from the Grand Cathedral in the Oratorium. It reeks of zig smoke."
	info = "<font face=\"Segoe Script\" color=#00000>Greetings to ye, distant missionaries in Azuria<br><br>This missive serves to inform of a breakthrough of alchemy. Enclosed is a substance, <b>Quicksilver</b>, that may be of keen use in the preservation of life against those unholy creechers that are repelled by divine silver. We speak of the werevolf and the vampyre. Herein lies the method.<br><br>Gather an ore of silver, a vessel of blessed water- a bottle's worth shall suffice, and a simple strip of cloth to add structure to the poultice. Take the warm bud of a fyritius flower, and immerse it in the bleeding wound of an unholy creecher. The warmth of the bud will congeal this foul ichor- but make haste, as it doth soon burn itself to ash. Induce the bloodied flower to your materials- grind the silver ore into dust via the mortar and pestle. Any expert of the craft of alchemy may intuit the process.<br><br>The ritual anointment is complex, and must be performed by a learned holy cleric in proximity of a cross of the pantheon. Inquisitor, your training doth empower you, as well. When the work is finished, the recipient now is inundated with holy silver- and shall be fortified against the fell turning of these unholy creechers.<br><br>Take heed! This act may also salvage the life of unfortunate souls who have recently been turned to beast. Their body's accursed resistance excites the Quicksilver to fire- but complete the rite, and they too are saved. All, except the eldest of Vampyre and Werevolf- we ascertain even this method cannot save them, and it will be a waste! (Albeit humbling.)<br><br>Share of this missive with any agents or employs that need direction in this rite.<br><br><b>PSYDON ENDURES,</b><br><i>Holy Fellowship of Research, the Grand Cathedral, the Oratorium Throni Vacui.</i></font>"
