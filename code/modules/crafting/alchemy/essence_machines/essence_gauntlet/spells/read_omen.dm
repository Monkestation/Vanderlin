/datum/action/cooldown/spell/essence/read_omen
	name = "Read Omen"
	desc = "Draw upon the leylines themselves to reveal secrets of fate itself."
	button_icon_state = "readomen"
	cast_range = 3
	point_cost = 7
	attunements = list(/datum/attunement/fire)
	essences = list(/datum/thaumaturgical_essence/chaos)

/datum/action/cooldown/spell/essence/read_omen/cast(mob/living/cast_on)
	. = ..()
	var/mob/living/user = owner
	user.visible_message(span_info("The eyes of [user] roll back into their head for a moment!"), span_info("Your eyes roll into the back of your head!"))

	var/datum/storyteller/current_storyteller = SSgamemode.current_storyteller

	if(istype(current_storyteller, /datum/storyteller/astrata))
		if(istype(user.patron, /datum/patron/divine/astrata))
			to_chat(user, "<span class='warning'>You know this feeling well. That is the warmth of the sun on your cheeks. Astrata light beams upon you in this moment.</span>")
		else
			to_chat(user, "<span class='warning'>You feel warm for a moment, like you are beginning to get flush from a fever, and then it fades.</span>")

	if(istype(current_storyteller, /datum/storyteller/noc))
		if(istype(user.patron, /datum/patron/divine/noc))
			to_chat(user, "<span class='warning'>With your eyes rolled into the back of you head, a feeling you are familiar with comes to mind. Darkness, the comforting darkness of night.</span>")
		else
			to_chat(user, "<span class='warning'>With your eyes rolled into the back of your head, you don't quite feel anything other than the opressive darkness that is the inside of your skull.</span>")

	if(istype(current_storyteller, /datum/storyteller/abyssor))
		if(istype(user.patron, /datum/patron/divine/abyssor))
			to_chat(user, "<span class='warning'>You concentrate on the spell, and are immediately hit with the familiar feeling of a lucid dream, you know this feeling well.</span>")
		else
			to_chat(user, "<span class='warning'>In your concentration of the spell, you feel yourself drift for a moment, like the feeling right before you are about to fall asleep.</span>")

	if(istype(current_storyteller, /datum/storyteller/dendor))
		if(istype(user.patron, /datum/patron/divine/dendor))
			to_chat(user, "<span class='warning'>The spell takes effect, and you hear it immediately. You hear peaceful nature in your ears, winds billowing through trees, a distant volf bark. It is comforting.</span>")
		else
			to_chat(user, "<span class='warning'>You feel the spell take effect, but cannot notice anything quite different. Though, you swear you hear the sound of a nearby rustling tree.</span>")

	if(istype(current_storyteller, /datum/storyteller/ravox))
		if(istype(user.patron, /datum/patron/divine/ravox))
			to_chat(user, "<span class='warning'>It hits you quickly, this is the feeling you get right before a fight. You feel your body tense for a moment, excitement, duty, honor- before, it fades, that adrenaline quickly draining.</span>")
		else
			to_chat(user, "<span class='warning'>The spell takes effect, but all you feel is that feeling you get right before a fight. That brief jump in adrenaline before nothing once more.</span>")

	if(istype(current_storyteller, /datum/storyteller/eora))
		if(istype(user.patron, /datum/patron/divine/eora))
			to_chat(user, "<span class='warning'>This is the feeling of love, I know it well. Those butterflies in your stomach before you're about to confess, the excitement, the small amount of fear.</span>")
		else
			to_chat(user, "<span class='warning'>You feel something in your stomach, you aren't quite sure how to put it but it's a feeling akin to butterflies.</span>")

	if(istype(current_storyteller, /datum/storyteller/necra))
		if(istype(user.patron, /datum/patron/divine/necra))
			to_chat(user, "<span class='warning'>There is a deathly stillness in the air. You know this feeling and find comfort in it. You stand there and bask in the peacefulness of it for a moment before reality returns.</span>")
		else
			to_chat(user, "<span class='warning'>You swear for a moment you heard something whisper in your ear, perhaps it was the wind?</span>")

	if(istype(current_storyteller, /datum/storyteller/pestra))
		if(istype(user.patron, /datum/patron/divine/pestra))
			to_chat(user, "<span class='warning'>You finish the incantation of the spell and instantly notice the distinct smell of decay, a smell you know oh so well. It fills your mind with all sorts of machinations before the spell finishes.</span>")
		else
			to_chat(user, "<span class='warning'>You struggle for a moment in the silence, trying to concentrate on the spell, but the sound of a damned fly keeps distracting you before you lose concentration entirely.</span>")

	if(istype(current_storyteller, /datum/storyteller/malum))
		if(istype(user.patron, /datum/patron/divine/malum))
			to_chat(user, "<span class='warning'>You enter a state of meditation while you concentrate on the spell. You feel the familiar warmth on your cheeks for a moment, like you just stuck your head infront of a forge or oven.</span>")
		else
			to_chat(user, "<span class='warning'>You sit in silence, not knowing if the spell has actually taken effect, but you can swear you hear the sound of a distant ting from a blacksmith working away.</span>")

	if(istype(current_storyteller, /datum/storyteller/zizo))
		if(istype(user.patron, /datum/patron/inhumen/zizo))
			to_chat(user, "<span class='warning'>You finish the incantations of the spell, but you know the answer already.</span>")
		else
			to_chat(user, "<span class='warning'>As you finish the spell, you are met with a feeling. You can't quite put your thumb on it but, something does not feel right.</span>")

	if(istype(current_storyteller, /datum/storyteller/matthios))
		if(istype(user.patron, /datum/patron/inhumen/matthios))
			to_chat(user, "<span class='warning'>The spell takes effect, and as your eyes are rolled back into your head, you swear you feel someone brush up against you, and instinctively reach for your coin pouch, only to realize that it never happened.</span>")
		else
			to_chat(user, "<span class='warning'>You feel your eyes roll into the back of your head, and begin to question if this was really worth casting. Before you have a chance to focus it's all over, what a ripoff.</span>")

	if(istype(current_storyteller, /datum/storyteller/baotha))
		if(istype(user.patron, /datum/patron/inhumen/baotha))
			to_chat(user, "<span class='warning'>Once you finish the spell, you are hit with absolutely nothing, the same feeling you get after a line of Ozium. Dull and numb.</span>")
		else
			to_chat(user, "<span class='warning'>Your stomach immediately churns, you aren't quite sure if it's guilt, or if it's too much drink. It feels horrible.</span>")

	if(istype(current_storyteller, /datum/storyteller/graggar))
		if(istype(user.patron, /datum/patron/inhumen/graggar))
			to_chat(user, "<span class='warning'>You finish the incantation and feel something well up inside you. Rage, excitement, the thirst you know so well. You snap back to reality, heart beating fast.</span>")
		else
			to_chat(user, "<span class='warning'>You finish the spell, however after a few moments you don't feel much difference, it leaves you frustrated and angry.</span>")

	if(istype(current_storyteller, /datum/storyteller/xylix))
		if(istype(user.patron, /datum/patron/divine/xylix))
			to_chat(user, "<span class='warning'>The spell incantation finishes and you feel a s- no. No that isn't right. That was a trick! Heehee, you can't trick me that easily.</span>")
		else
			var/list/possible_messages = list(
				"<span class='warning'>You feel warm for a moment, like you are beginning to get flush from a fever, and then it fades.</span>",
				"<span class='warning'>With your eyes rolled into the back of your head, you don't quite feel anything other than the opressive darkness that is the inside of your skull.</span>",
				"<span class='warning'>In your concentration of the spell, you feel yourself drift for a moment, like the feeling right before you are about to fall asleep.</span>",
				"<span class='warning'>You feel the spell take effect, but cannot notice anything quite different. Though, you swear you hear the sound of a nearby rustling tree.</span>",
				"<span class='warning'>The spell takes effect, but all you feel is that feeling you get right before a fight. That brief jump in adrenaline before nothing once more.</span>",
				"<span class='warning'>You feel something in your stomach, you aren't quite sure how to put it but it's a feeling akin to butterflies.</span>",
				"<span class='warning'>You swear for a moment you heard something whisper in your ear, perhaps it was the wind?</span>",
				"<span class='warning'>You struggle for a moment in the silence, trying to concentrate on the spell, but the sound of a damned fly keeps distracting you before you lose concentration entirely.</span>",
				"<span class='warning'>You sit in silence, not knowing if the spell has actually taken effect, but you can swear you hear the sound of a distant ting from a blacksmith working away.</span>",
				"<span class='warning'>As you finish the spell, you are met with a feeling. You can't quite put your thumb on it but, something does not feel right.</span>",
				"<span class='warning'>You feel your eyes roll into the back of your head, and begin to question if this was really worth casting. Before you have a chance to focus it's all over, what a ripoff.</span>",
				"<span class='warning'>Your stomach immediately churns, you aren't quite sure if it's guilt, or if it's too much drink. It feels horrible.</span>",
				"<span class='warning'>You finish the spell, however after a few moments you don't feel much difference, it leaves you frustrated and angry.</span>",
				"<span class='warning'>You finish the incantation of the spell, but nothing happens.</span>"
			)
			to_chat(user, pick(possible_messages))
