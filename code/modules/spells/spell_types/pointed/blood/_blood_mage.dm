/datum/outfit/blood_mage
	name = "Blood Mage (Magic Skill)"

/datum/outfit/blood_mage/pre_equip(mob/living/carbon/human/blood_mage)
	..()
	ADD_TRAIT(blood_mage, TRAIT_SORCERER, INNATE_TRAIT)
	ADD_TRAIT(blood_mage, TRAIT_BLOOD_MAGE, INNATE_TRAIT)
	blood_mage.adjust_technique_mastery_points(5)
	blood_mage.adjust_form_mastery_points(6)
	blood_mage.add_spell(/datum/action/cooldown/spell/projectile/blood_steal, mastery_spell = TRUE)
