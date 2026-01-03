#define GET_TARGET_PRONOUN(target, pronoun, gender) call(target, ALL_PRONOUNS[pronoun])(gender)

//pronoun procs, for getting pronouns without using the text macros that only work in certain positions
//datums don't have gender, but most of their subtypes do!
/datum/proc/p_they(capitalized, temp_gender)
	. = "it"
	if(capitalized)
		. = capitalize(.)

/datum/proc/p_their(capitalized, temp_gender)
	. = "its"
	if(capitalized)
		. = capitalize(.)

/datum/proc/p_them(capitalized, temp_gender)
	. = "it"
	if(capitalized)
		. = capitalize(.)

/datum/proc/p_have(temp_gender)
	. = "has"

/datum/proc/p_are(temp_gender)
	. = "is"

/datum/proc/p_were(temp_gender)
	. = "was"

/datum/proc/p_do(temp_gender)
	. = "does"

/datum/proc/p_theyve(capitalized, temp_gender)
	. = p_they(capitalized, temp_gender) + "'" + copytext(p_have(temp_gender), 3)

/datum/proc/p_theyre(capitalized, temp_gender)
	. = p_they(capitalized, temp_gender) + "'" + copytext(p_are(temp_gender), 2)

/datum/proc/p_s(temp_gender) //is this a descriptive proc name, or what?
	. = "s"

/datum/proc/p_es(temp_gender)
	. = "es"

/// A proc to replace pronouns in a string with the appropriate pronouns for a target atom.
/// Uses associative list access from a __DEFINE list, since associative access is slightly
/// faster
/datum/proc/replace_pronouns(target_string, atom/targeted_atom, targeted_gender = null)
	/// If someone specifies targeted_gender we choose that,
	/// otherwise we go off the gender of our object
	var/gender
	if(targeted_gender)
		if(!istext(targeted_gender) || !(targeted_gender in list(MALE, FEMALE, PLURAL, NEUTER)))
			stack_trace("REPLACE_PRONOUNS called with improper parameters.")
			return
		gender = targeted_gender
	else
		gender = targeted_atom.get_visible_gender()
	///The pronouns are ordered by their length to avoid %PRONOUN_Theyve being translated to "Heve" instead of "He's", for example
	var/regex/pronoun_regex = regex("%PRONOUN(_(theirs|Theirs|theyve|Theyve|theyre|Theyre|their|Their|they|They|them|Them|have|were|are|do|es|s))")
	while(pronoun_regex.Find(target_string))
		target_string = pronoun_regex.Replace(target_string, GET_TARGET_PRONOUN(targeted_atom, pronoun_regex.match, gender))
	return target_string

//like clients, which do have gender.
/client/p_they(capitalized, temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "they"
	switch(temp_gender)
		if(FEMALE)
			. = "she"
		if(MALE)
			. = "he"
	if(capitalized)
		. = capitalize(.)

/client/p_their(capitalized, temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "their"
	switch(temp_gender)
		if(FEMALE)
			. = "her"
		if(MALE)
			. = "his"
	if(capitalized)
		. = capitalize(.)

/client/p_them(capitalized, temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "them"
	switch(temp_gender)
		if(FEMALE)
			. = "her"
		if(MALE)
			. = "him"
	if(capitalized)
		. = capitalize(.)

/client/p_have(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "has"
	if(temp_gender == PLURAL || temp_gender == NEUTER)
		. = "have"

/client/p_are(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "is"
	if(temp_gender == PLURAL || temp_gender == NEUTER)
		. = "are"

/client/p_were(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "was"
	if(temp_gender == PLURAL || temp_gender == NEUTER)
		. = "were"

/client/p_do(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "does"
	if(temp_gender == PLURAL || temp_gender == NEUTER)
		. = "do"

/client/p_s(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	if(temp_gender != PLURAL && temp_gender != NEUTER)
		. = "s"

/client/p_es(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	if(temp_gender != PLURAL && temp_gender != NEUTER)
		. = "es"

//mobs(and atoms but atoms don't really matter write your own proc overrides) also have gender!
/mob/p_they(capitalized, temp_gender, ignore_pronouns = FALSE)
	if(!temp_gender)
		temp_gender = gender
	. = "it"
	if(pronouns && !ignore_pronouns)
		switch(pronouns)
			if(HE_HIM)
				. = "he"
			if(SHE_HER)
				. = "she"
			if(THEY_THEM)
				. = "they"
			if(IT_ITS)
				. = "it"
	else
		switch(temp_gender)
			if(FEMALE)
				. = "she"
			if(MALE)
				. = "he"
			if(PLURAL)
				. = "they"
	if(capitalized)
		. = capitalize(.)

/mob/p_their(capitalized, temp_gender, ignore_pronouns = FALSE)
	if(!temp_gender)
		temp_gender = gender
	. = "its"
	if(pronouns && !ignore_pronouns)
		switch(pronouns)
			if (HE_HIM)
				. = "his"
			if(SHE_HER)
				. = "her"
			if(THEY_THEM)
				. = "their"
			if(IT_ITS)
				. = "its"
	else
		switch(temp_gender)
			if(FEMALE)
				. = "her"
			if(MALE)
				. = "his"
			if(PLURAL)
				. = "their"
	if(capitalized)
		. = capitalize(.)

/mob/p_them(capitalized, temp_gender, ignore_pronouns = FALSE)
	if(!temp_gender)
		temp_gender = gender
	. = "it"
	if(pronouns && !ignore_pronouns)
		switch(pronouns)
			if(HE_HIM)
				. = "him"
			if(SHE_HER)
				. = "her"
			if(THEY_THEM)
				. = "them"
			if(IT_ITS)
				. = "it"
	else
		switch(temp_gender)
			if(FEMALE)
				. = "her"
			if(MALE)
				. = "him"
			if(PLURAL)
				. = "them"
	if(capitalized)
		. = capitalize(.)

/mob/p_have(temp_gender, ignore_pronouns = FALSE)
	if(!temp_gender)
		temp_gender = gender
	. = "has"
	if(temp_gender == PLURAL || (!ignore_pronouns && pronouns == THEY_THEM))
		. = "have"

/mob/p_are(temp_gender, ignore_pronouns = FALSE)
	if(!temp_gender)
		temp_gender = gender
	. = "is"
	if(temp_gender == PLURAL || (!ignore_pronouns && pronouns == THEY_THEM))
		. = "are"

/mob/p_were(temp_gender, ignore_pronouns = FALSE)
	if(!temp_gender)
		temp_gender = gender
	. = "was"
	if(temp_gender == PLURAL || (!ignore_pronouns && pronouns == THEY_THEM))
		. = "were"

/mob/p_do(temp_gender, ignore_pronouns = FALSE)
	if(!temp_gender)
		temp_gender = gender
	. = "does"
	if(temp_gender == PLURAL || (!ignore_pronouns && pronouns == THEY_THEM))
		. = "do"

/mob/p_s(temp_gender, ignore_pronouns = FALSE)
	if(!temp_gender)
		temp_gender = gender
	if(temp_gender != PLURAL || (!ignore_pronouns && pronouns != THEY_THEM))
		. = "s"

/mob/p_es(temp_gender, ignore_pronouns = FALSE)
	if(!temp_gender)
		temp_gender = gender
	if(temp_gender != PLURAL || (!ignore_pronouns && pronouns != THEY_THEM))
		. = "es"

/// Reports what gender this atom appears to be
/atom/proc/get_visible_gender()
	return gender

/mob/living/carbon/human/get_visible_gender()
	var/obscured = check_obscured_slots()
	var/skipface = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))
	if((obscured & ITEM_SLOT_PANTS) && skipface)
		return PLURAL
	return gender

//humans need special handling, because they can have their gender hidden
/mob/living/carbon/human/p_they(capitalized, temp_gender, ignore_pronouns = FALSE)
	temp_gender ||= get_visible_gender()
	return ..()

/mob/living/carbon/human/p_their(capitalized, temp_gender, ignore_pronouns = FALSE)
	temp_gender ||= get_visible_gender()
	return ..()

/mob/living/carbon/human/p_them(capitalized, temp_gender, ignore_pronouns = FALSE)
	temp_gender ||= get_visible_gender()
	return ..()

/mob/living/carbon/human/p_have(temp_gender, ignore_pronouns = FALSE)
	temp_gender ||= get_visible_gender()
	return ..()

/mob/living/carbon/human/p_are(temp_gender, ignore_pronouns = FALSE)
	temp_gender ||= get_visible_gender()
	return ..()

/mob/living/carbon/human/p_were(temp_gender, ignore_pronouns = FALSE)
	temp_gender ||= get_visible_gender()
	return ..()

/mob/living/carbon/human/p_do(temp_gender, ignore_pronouns = FALSE)
	temp_gender ||= get_visible_gender()
	return ..()

/mob/living/carbon/human/p_s(temp_gender, ignore_pronouns = FALSE)
	temp_gender ||= get_visible_gender()
	return ..()

/mob/living/carbon/human/p_es(temp_gender, ignore_pronouns = FALSE)
	temp_gender ||= get_visible_gender()
	return ..()
