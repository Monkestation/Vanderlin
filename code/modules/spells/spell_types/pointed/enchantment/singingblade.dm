/datum/action/cooldown/spell/enchantment/singingblade
	name = "Singing Blade"
	desc = "Enchant a weapon with a dancing ember, using the cantrip that warms your cold, cold heart."
	button_icon_state = "enchant_weapon"

	enchantment_duration = 2 MINUTES
	click_to_activate = FALSE
	cooldown_time = 3 MINUTES
	attunements = list(
		/datum/attunement/fire = 0.4,
	)

	charge_required = FALSE
	spell_cost = 10
	spell_flags = SPELL_STAMINA
	enchantment = SINGING_BLADE_ENCHANT

/datum/action/cooldown/spell/enchantment/singingblade/cast(mob/living/cast_on)
	. = ..()
	var/mob/living/target = cast_on
	if(ismob(target))
		playsound(target, 'sound/magic/singingblade.ogg', 100, FALSE)
		cast_on.visible_message(span_info("[cast_on] erupts in flames..! OH GODS!"), span_notice("I'm on fire..! It burns so GOOD!"))
		target.adjust_fire_stacks(10) // This is gonna hurt.
		target.IgniteMob()
		target.emote("rage", forced = TRUE);
		pick(cast_on.say("I... BLESS... YOU..!"), cast_on.say("BUCKLE UP BOYS AND GIRLS!"), cast_on.say("EVIL DIES TODAY."), cast_on.say("I WILL NEVER KNEEL BEFORE THE LIKES OF YOU."), cast_on.say("I'LL TAKE YOU WITH ME!"), cast_on.say("HERE'S A TASTE OF WHAT AWAITS YOU!"), cast_on.say("IN A FEW SECONDS IT WILL ALL BE OVER!"), cast_on.say("I'LL BURN THE SIN OUT."), cast_on.say("FLAME ON!"), cast_on.say("NO MORE GAMES!"), cast_on.say("YOU WERE NEVER GOING TO WIN."), cast_on.say("WELCOME TO MY WORLD, BOYS AND GIRLS!"), cast_on.say("LEAVING THIS WORLD IS NOT AS SCARY AS IT SOUNDS."))
