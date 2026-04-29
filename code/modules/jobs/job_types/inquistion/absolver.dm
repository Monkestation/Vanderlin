/datum/attribute_holder/sheet/job/absolver
	raw_attribute_list = list(
		STAT_ENDURANCE = 3,
		STAT_SPEED = -2,
		STAT_CONSTITUTION = 7,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/sewing = 30,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/craft/cooking = 30,
		/datum/attribute/skill/labor/fishing = 30,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/craft/crafting = 30,
		/datum/attribute/skill/magic/holy = 20
	)

/datum/job/absolver
	title = JOB_ABSOLVER
	department_flag = INQUISITION
	faction = "Station"
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	total_positions = 1 // THE ONE.
	spawn_positions = 1
	allowed_races = list(SPEC_ID_HUMEN)
	//You MUST have a Psydonite character to start. Just so people don't get japed into Oops Suddenly Psydon!
	allowed_patrons = list(/datum/patron/psydon) // no e. psydon, according to ook
	tutorial = "The Oratorium claims you are naught more than a 'cleric', but you know the truth; you are a sacrificial lamb. Your hands, unmarred through prayer and pacifism, have been gifted with the power to manipulate blood - to siphon away the wounds of others, so that you may endure in their stead. Let your censer's light shepherd the Inquisitor's retinue forth, lest they're led astray by wrath and temptation."
	selection_color = JCOLOR_INQUISITION
	outfit = /datum/outfit/absolver
	bypass_lastclass = TRUE
	display_order = JDO_ABSOLVER
	give_bank_account = 15
	cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'
	antag_role = /datum/antagonist/purishep

	job_bitflag = BITFLAG_CHURCH

	mind_traits = list(
		TRAIT_KNOW_INQUISITION_DOORS
	)
	traits = list(
		TRAIT_NOPAINSTUN,
		TRAIT_PACIFISM,
		TRAIT_EMPATH,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_STEELHEARTED,
		TRAIT_INQUISITION,
		TRAIT_SILVER_BLESSED,
		TRAIT_PSYDONIAN_GRIT,
		TRAIT_PSYDONITE,
		TRAIT_FOREIGNER,
	)

	spells = list(
		/datum/action/cooldown/spell/psydonlux_tamper,
		/datum/action/cooldown/spell/psydonabsolve,
		/datum/action/cooldown/spell/diagnose,
	)

	attribute_sheet = /datum/attribute_holder/sheet/job/absolver

	languages = list(/datum/language/oldpsydonic, /datum/language/newpsydonic)

	exp_type = list(EXP_TYPE_INQUISITION)
	exp_types_granted = list(EXP_TYPE_INQUISITION)
	exp_requirements = list(
		EXP_TYPE_INQUISITION = 600
	)
	verbs = list(
		/mob/living/carbon/human/proc/view_inquisition
	)


// REMEMBER FLAGELLANT? REMEMBER LASZLO? THIS IS HIM NOW. FEEL OLD YET?

/datum/job/absolver/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	GLOB.inquisition.add_member_to_school(spawned, "Sanctae", 0, "Absolver")

	spawned.hud_used?.shutdown_bloodpool()
	spawned.hud_used?.initialize_bloodpool()
	spawned.hud_used?.bloodpool.set_fill_color("#dcdddb")
	spawned.hud_used?.bloodpool?.name = "Psydon's Grace: [spawned.bloodpool]"
	spawned.hud_used?.bloodpool?.desc = "Devotion: [spawned.bloodpool]/[spawned.maxbloodpool]"
	spawned.maxbloodpool = 1000

	var/datum/species/species = spawned.dna?.species
	if(!species)
		return
	species.native_language = "Old Psydonic"
	species.accent_language = species.get_accent(species.native_language)

/datum/job/absolver/remove_job(mob/living/carbon/human/spawned)
	. = ..()
	if(.)
		spawned.hud_used?.shutdown_bloodpool()
		spawned.maxbloodpool = initial(spawned.maxbloodpool)

/datum/outfit/absolver
	name = JOB_ABSOLVER
	wrists = /obj/item/clothing/wrists/bracers/psythorns
	gloves = /obj/item/clothing/gloves/leather/otavan/inqgloves
	beltr = /obj/item/flashlight/flare/torch/lantern/psycenser
	beltl = /obj/item/storage/belt/pouch/coins/rich
	neck = /obj/item/clothing/neck/psycross/silver
	cloak = /obj/item/clothing/cloak/absolutionistrobe
	backr = /obj/item/storage/backpack/satchel/otavan
	belt = /obj/item/storage/belt/leather
	pants = /obj/item/clothing/pants/trou/leather/advanced/colored/duelpants
	armor = /obj/item/clothing/armor/cuirass/psydon
	shirt = /obj/item/clothing/armor/gambeson/heavy/inq
	shoes = /obj/item/clothing/shoes/psydonboots
	mask = /obj/item/clothing/head/helmet/blacksteel/psythorns
	head = /obj/item/clothing/head/helmet/heavy/absolver
	ring = /obj/item/clothing/ring/signet/silver
	backpack_contents = list(
		/obj/item/book/bibble/psy = 1,
		/obj/item/natural/bundle/cloth = 2,
		/obj/item/reagent_containers/glass/bottle/healthpot = 2,
		/obj/item/paper/inqslip/arrival/abso = 1,
		/obj/item/needle = 1,
		/obj/item/natural/worms/leech = 1,
		/obj/item/key/inquisition = 1,
		)
