#define ARMORID "armor-[blunt]-[slash]-[stab]-[piercing]-[fire]-[acid]-[magic]"

/proc/getArmor(blunt = 0, slash = 0, stab = 0, piercing = 0, fire = 0, acid = 0, magic = 0)
	. = locate(ARMORID)
	if (!.)
		. = new /datum/armor(blunt, slash, stab, piercing, fire, acid, magic)

/datum/armor
	datum_flags = DF_USE_TAG
	/// better defined as area pressure melee
	var/blunt
	/// better defined as line pressure melee
	var/slash
	/// better defined as point pressure melee
	var/stab
	/// basically projectiles
	var/piercing
	/// protection against burning
	var/fire
	/// protection against pools of acid
	var/acid
	/// protection against magical attacks (make this adjustable via rune enchantments or something)
	var/magic

/datum/armor/New(blunt = 0, slash = 0, stab = 0, piercing = 0, fire = 0, acid = 0, magic = 0)
	src.blunt = blunt
	src.slash = slash
	src.stab = stab
	src.piercing = piercing
	src.fire = fire
	src.acid = acid
	src.magic = magic
	tag = ARMORID

/datum/armor/proc/modifyRating(blunt = 0, slash = 0, stab = 0, piercing = 0, fire = 0, acid = 0, magic = 0)
	return getArmor(src.blunt+blunt, src.slash+slash, src.stab+stab, src.piercing+piercing,src.fire+fire, src.acid+acid, src.magic+magic)

/datum/armor/proc/modifyAllRatings(modifier = 0)
	return getArmor(blunt+modifier, slash+modifier, stab+modifier, piercing+modifier,fire+modifier, acid+modifier, magic+modifier)

//TODO! PORT BLACKSTONE BLUNT/SLASH/STAB ARMOR DEFINES!!!!!!
/datum/armor/proc/multiplymodifyAllRatings(modifier = 0)
	return getArmor(blunt*modifier, slash*modifier, stab*modifier, piercing*modifier, fire*modifier, acid*modifier, magic*modifier)

/datum/armor/proc/setRating(blunt, slash, stab, piercing, fire, acid, magic)
	return getArmor((isnull(blunt) ? src.blunt : blunt),\
					(isnull(slash) ? src.slash : slash),\
					(isnull(stab) ? src.stab : stab),\
					(isnull(piercing) ? src.piercing : piercing),\
					(isnull(fire) ? src.fire : fire),\
					(isnull(acid) ? src.acid : acid),\
					(isnull(magic) ? src.magic : magic))

/datum/armor/proc/getRating(rating)
	return vars[rating]

/datum/armor/proc/getList()
	return list("blunt" = blunt, "slash" = slash, "stab" = stab, "piercing" = piercing, "fire" = fire, "acid" = acid, "magic" = magic)

/datum/armor/proc/attachArmor(datum/armor/AA)
	return getArmor(blunt+AA.blunt, slash+AA.slash, stab+AA.stab, piercing+AA.piercing, fire+AA.fire, acid+AA.acid, magic+AA.magic)

/datum/armor/proc/detachArmor(datum/armor/AA)
	return getArmor(blunt-AA.blunt, slash-AA.slash, stab-AA.stab, piercing-AA.piercing, fire-AA.fire, acid-AA.acid, magic-AA.magic)

/datum/armor/vv_edit_var(var_name, var_value)
	if (var_name == NAMEOF(src, tag))
		return FALSE
	. = ..()
	tag = ARMORID // update tag in case armor values were edited

#undef ARMORID

/// Gets the rating of armor for the specified rating
/datum/armor/proc/get_rating(rating) as num
	// its not that I dont trust coders, its just that I don't trust coders
	if(!(rating in ARMOR_LIST_ALL()))
		CRASH("Attempted to get a rating '[rating]' that doesnt exist")
	return vars[rating]

/**
 * Returns the client readable name of an armor type
 *
 * Arguments:
 * * armor_type - The type to convert
 */
/proc/armor_to_protection_name(armor_type)
	switch(armor_type)
		if(BLUNT)
			return "BLUNT"
		if(SLASH)
			return "SLASH"
		if(STAB)
			return "STAB"
		if(PIERCE)
			return "PIERCING"
		if(FIRE)
			return "FIRE"
		if(ACID)
			return "ACID"
		if(MAGIC)
			return "MAGIC"
	CRASH("Unknown armor type '[armor_type]'")

/**
 * Arguments:
 * * armor_value - Number we're converting
 */
/proc/armor_to_color(armor_value)
	if(armor_value >= 100)
		return "#1F3FBF"
	if(armor_value >= 75)
		return "#00FF00"
	if(armor_value >= 50)
		return "#7CFF7C"
	if(armor_value >= 25)
		return "#fffb00"
	if(armor_value > 0)
		return "#ff8800"
	else
		return "#FF0000"

/**
 * Arguments:
 * * armor_value - Number we're converting
 */
/proc/armor_to_protection_class(armor_value)
	if(armor_value >= 100)
		return "(IMMUNE)"
	if(armor_value >= 75)
		return "(RESISTANT)"
	if(armor_value >= 50)
		return "(ENDURED)"
	if(armor_value >= 25)
		return "(NORMAL)"
	if(armor_value > 0)
		return "(WEAK)"
	else
		return "(VULNERABLE)"
