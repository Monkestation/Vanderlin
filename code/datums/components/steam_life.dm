/datum/component/steam_life
	var/steam_charge = 100
	var/max_steam_charge = 100
	///this to be easier to understand is how much should be drained per minute
	var/steam_drain_rate = 4
	var/mob/living/carbon/human/host
	var/tmp/needs_particles = TRUE

/datum/component/steam_life/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	host = parent
	host?.hud_used?.initialize_bloodpool()
	host?.hud_used?.bloodpool.set_fill_color("#dcdddb")
	host.hud_used?.bloodpool?.name = "Steam"
	host.hud_used?.bloodpool?.desc = "Charge: [steam_charge]/[max_steam_charge]"

	RegisterSignal(host, COMSIG_ATOM_STEAM_INCREASE, PROC_REF(recharge_steam))
	RegisterSignal(host, COMSIG_MOB_FOOD_EAT, PROC_REF(try_consume_fuel))
	START_PROCESSING(SSobj, src)

/datum/component/steam_life/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/datum/component/steam_life/process()
	if(!host)
		return
	steam_charge = max(0, steam_charge - (steam_drain_rate / 60))

	if(steam_charge <= 0)
		host.Unconscious(20)
		if(prob(10))
			host.emote("shutdown", forced = TRUE)
			to_chat(host, span_danger("CRITICAL POWER FAILURE - ENTERING DORMANT MODE"))
	else if(steam_charge <= 20)
		if(prob(5))
			host.emote("malfunction", forced = TRUE)
			to_chat(host, span_warning("WARNING: POWER RESERVES CRITICALLY LOW"))
	update_steam()

/datum/component/steam_life/proc/update_steam()
	if(host.hud_used && !host.hud_used?.bloodpool)
		host?.hud_used?.initialize_bloodpool()
	host.hud_used?.bloodpool?.name = "Steam"
	host.hud_used?.bloodpool?.desc = "Charge: [steam_charge]/[max_steam_charge]"
	if(steam_charge <= 0)
		host.remove_shared_particles("steam")
		needs_particles = TRUE
		host?.hud_used?.bloodpool?.set_value(0, 1 SECONDS)
	else
		if(needs_particles)
			host.add_shared_particles(/particles/smoke/cig/big/steam, "steam")
			needs_particles = FALSE
		host?.hud_used?.bloodpool?.set_value((100 / (max_steam_charge / steam_charge)) / 100, 1 SECONDS)

/datum/component/steam_life/proc/recharge_steam(datum/source, steam_amount)
	SIGNAL_HANDLER

	steam_charge = min(max_steam_charge, steam_charge + steam_amount)
	to_chat(host, span_notice("STEAM RESERVES REPLENISHED: [steam_charge]/[max_steam_charge]"))

	if(steam_charge >= max_steam_charge)
		return FALSE

	return TRUE

/datum/component/steam_life/proc/try_consume_fuel(mob/living/user, obj/item/source)
	SIGNAL_HANDLER

	if(user.cmode)
		return FALSE

	if(!istype(source, /obj/item/ore/coal) && !istype(source, /obj/item/grown/log/tree))
		return FALSE

	var/fuel_amount = 0
	if(istype(source, /obj/item/ore/coal))
		fuel_amount = 30
		user.visible_message(
			span_notice("[user] feeds the coal into their furnace with a hiss of steam."),
			span_notice("I consume the coal for fuel. Power: [steam_charge]/[max_steam_charge]")
		)
	else if(istype(source, /obj/item/grown/log/tree))
		fuel_amount = 15
		user.visible_message(
			span_notice("[user] stuffs the wood into their furnace, flames licking at the bark."),
			span_notice("I consume the wood for fuel. Power: [steam_charge]/[max_steam_charge]")
		)

	steam_charge = min(max_steam_charge, steam_charge + fuel_amount)

	playsound(user, 'sound/items/firelight.ogg', 50, TRUE)
	return TRUE
