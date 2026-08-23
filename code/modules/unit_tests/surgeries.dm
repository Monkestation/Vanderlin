/datum/unit_test/amputation/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)
	var/obj/item/weapon/surgery/saw/saw = allocate(/obj/item/weapon/surgery/saw)

	TEST_ASSERT_EQUAL(patient.get_missing_limbs().len, 0, "Patient is somehow missing limbs before surgery")

	var/datum/surgery_operation/limb/amputate/surgery = GLOB.operations.operations_by_typepath[__IMPLIED_TYPE__]

	UNLINT(surgery.success(patient.get_bodypart(BODY_ZONE_R_ARM), user, saw, list()))

	TEST_ASSERT_EQUAL(patient.get_missing_limbs().len, 1, "Patient did not lose any limbs")
	TEST_ASSERT_EQUAL(patient.get_missing_limbs()[1], BODY_ZONE_R_ARM, "Patient is missing a limb that isn't the one we operated on")

/datum/unit_test/head_transplant/Run()
	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)

	var/mob/living/carbon/human/alice = allocate(/mob/living/carbon/human)
	alice.fully_replace_character_name(null, "Alice")

	var/mob/living/carbon/human/bob = allocate(/mob/living/carbon/human)
	bob.fully_replace_character_name(null, "Bob")

	var/obj/item/bodypart/head/alices_head = alice.get_bodypart(BODY_ZONE_HEAD)
	alices_head.drop_limb()

	var/obj/item/bodypart/head/bobs_head = bob.get_bodypart(BODY_ZONE_HEAD)
	bobs_head.drop_limb()

	TEST_ASSERT_EQUAL(alice.get_bodypart(BODY_ZONE_HEAD), null, "Alice still has a head after dismemberment")
	TEST_ASSERT_EQUAL(alice.get_visible_name(), "Unknown", "Alice's head was dismembered, but they are not Unknown")

	TEST_ASSERT_EQUAL(bobs_head.real_name, "Bob", "Bob's head does not remember that it is from Bob")

	// Put Bob's head onto Alice's body
	var/datum/surgery_operation/limb_replacement/surgery = GLOB.operations.operations_by_typepath[__IMPLIED_TYPE__]
	user.put_in_active_hand(bobs_head)
	UNLINT(surgery.success(alice, user, bobs_head, list()))

	TEST_ASSERT(!isnull(alice.get_bodypart(BODY_ZONE_HEAD)), "Alice has no head after prosthetic replacement")
	TEST_ASSERT_EQUAL(alice.get_visible_name(), "Bob", "Bob's head was transplanted onto Alice's body, but their name is not Bob")

// Ensures that the tend wounds surgery can be started
/datum/unit_test/start_tend_wounds

/datum/unit_test/start_tend_wounds/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)
	var/obj/item/weapon/surgery/hemostat/hemostat = allocate(/obj/item/weapon/surgery/hemostat)

	patient.set_body_position(LYING_DOWN)

	var/obj/item/bodypart/chest/patient_chest = patient.get_bodypart(BODY_ZONE_CHEST)

	var/datum/surgery_operation/basic/tend_wounds/surgery = GLOB.operations.operations_by_typepath[__IMPLIED_TYPE__]
	TEST_ASSERT(!surgery.check_availability(patient, patient, user, hemostat, BODY_ZONE_CHEST), "Tend wounds surgery was available on an undamaged, unoperated patient")

	patient.take_overall_damage(10, 10)
	TEST_ASSERT(!surgery.check_availability(patient, patient, user, hemostat, BODY_ZONE_CHEST), "Tend wounds surgery was available on a damaged but unoperated patient")

	patient_chest.add_surgical_state(SURGERY_SKIN_OPEN|SURGERY_VESSELS_CLAMPED)
	TEST_ASSERT(surgery.check_availability(patient, patient, user, hemostat, BODY_ZONE_CHEST), "Tend wounds surgery was not available on a damaged, operated patient")

/datum/unit_test/tend_wounds/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	patient.take_overall_damage(100, 100)

	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)
	var/obj/item/weapon/surgery/hemostat/hemostat = allocate(/obj/item/weapon/surgery/hemostat)

	// Test that tending wounds actually lowers damage
	var/datum/surgery_operation/basic/tend_wounds/surgery = GLOB.operations.operations_by_typepath[__IMPLIED_TYPE__]
	UNLINT(surgery.success(patient, user, hemostat, list("[OPERATION_BRUTE_HEAL]" = 10, "[OPERATION_BRUTE_MULTIPLIER]" = 0.1)))
	TEST_ASSERT(patient.getBruteLoss() < 100, "Tending brute wounds didn't lower brute damage ([patient.getBruteLoss()])")

/// Checks all operations have a name and description
/datum/unit_test/verify_surgery_setup

/datum/unit_test/verify_surgery_setup/Run()
	for(var/datum/surgery_operation/operation as anything in GLOB.operations.get_instances_from(subtypesof(/datum/surgery_operation)))
		if (isnull(operation.name))
			TEST_FAIL("Surgery operation [operation.type] has no name set")
		if (isnull(operation.desc))
			TEST_FAIL("Surgery operation [operation.type] has no description set")

/// Tests that make incision shows up when expected
/datum/unit_test/incision_check

/datum/unit_test/incision_check/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/surgeon = allocate(/mob/living/carbon/human)

	var/obj/item/weapon/surgery/scalpel/scalpel = allocate(/obj/item/weapon/surgery/scalpel)
	var/obj/item/bodypart/chest/chest = patient.get_bodypart(BODY_ZONE_CHEST)
	var/list/operations

	surgeon.put_in_active_hand(scalpel)
	operations = surgeon.get_available_operations(patient, scalpel, BODY_ZONE_CHEST)
	TEST_ASSERT_EQUAL(length(operations), 0, "Surgery operations were available on a standing patient")

	patient.set_body_position(LYING_DOWN)
	operations = surgeon.get_available_operations(patient, scalpel, BODY_ZONE_CHEST)
	if(length(operations) > 1)
		TEST_FAIL("More operations than expected were available on the patient")
		return

	if(length(operations) == 1)
		var/list/found_operation_data = operations[operations[1]]
		var/datum/surgery_operation/operation = found_operation_data[1]
		var/atom/movable/operating_on = found_operation_data[2]
		TEST_ASSERT_EQUAL(operation.type, /datum/surgery_operation/limb/incise_skin, "The available surgery operation was not \"make incision\"")
		TEST_ASSERT_EQUAL(operating_on, patient.get_bodypart(BODY_ZONE_CHEST), "The available surgery operation was not on the chest bodypart")
		return

	TEST_ASSERT_EQUAL(patient.body_position, LYING_DOWN, "Patient is not lying down as expected")

	var/datum/surgery_operation/incise_operation = GLOB.operations.operations_by_typepath[/datum/surgery_operation/limb/incise_skin]
	var/atom/movable/operate_on = incise_operation.get_operation_target(patient, BODY_ZONE_CHEST)
	TEST_ASSERT_EQUAL(operate_on, patient.get_bodypart(BODY_ZONE_CHEST), "Incise skin operation did not return the chest bodypart as a valid operation target")

	if(incise_operation.check_availability(patient, operate_on, surgeon, scalpel, BODY_ZONE_CHEST))
		TEST_FAIL("Make incision operation was not found among available operations despite being available")
	else
		TEST_FAIL("Make incision operation was not available when it should have been")

/// Tests surgeries which just modify basic surgical states
/datum/unit_test/state_surgeries

/datum/unit_test/state_surgeries/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/surgeon = allocate(/mob/living/carbon/human)

	var/obj/item/weapon/surgery/scalpel/scalpel = allocate(/obj/item/weapon/surgery/scalpel)
	var/obj/item/weapon/surgery/retractor/retractor = allocate(/obj/item/weapon/surgery/retractor)
	var/obj/item/weapon/surgery/saw/saw = allocate(/obj/item/weapon/surgery/saw)
	var/obj/item/weapon/surgery/hemostat/hemostat = allocate(/obj/item/weapon/surgery/hemostat)
	var/obj/item/weapon/surgery/cautery/cautery = allocate(/obj/item/weapon/surgery/cautery)
	var/obj/item/weapon/surgery/bonesetter/bonesetter = allocate(/obj/item/weapon/surgery/bonesetter)

	var/obj/item/bodypart/chest/chest = patient.get_bodypart(BODY_ZONE_CHEST)

	var/datum/surgery_operation/limb/incise_skin/isurgery = GLOB.operations.operations_by_typepath[__IMPLIED_TYPE__]
	UNLINT(isurgery.success(chest, surgeon, scalpel, list()))

	TEST_ASSERT(LIMB_HAS_SURGERY_STATE(chest, SURGERY_SKIN_CUT), "Making an incision did not apply the skin cut surgical state")
	TEST_ASSERT(LIMB_HAS_SURGERY_STATE(chest, SURGERY_VESSELS_UNCLAMPED), "Making an incision did not apply the vessels unclamped surgical state")

	var/datum/surgery_operation/limb/retract_skin/rsurgery = GLOB.operations.operations_by_typepath[__IMPLIED_TYPE__]
	UNLINT(rsurgery.success(chest, surgeon, retractor, list()))

	TEST_ASSERT(!LIMB_HAS_SURGERY_STATE(chest, SURGERY_SKIN_CUT), "Retracting skin did not remove the skin cut surgical state")
	TEST_ASSERT(LIMB_HAS_SURGERY_STATE(chest, SURGERY_SKIN_OPEN), "Retracting skin did not apply the skin open surgical state")
	TEST_ASSERT(LIMB_HAS_SURGERY_STATE(chest, SURGERY_VESSELS_UNCLAMPED), "Retracting skin removed the vessels unclamped surgical state unexpectedly")

	var/datum/surgery_operation/limb/clamp_bleeders/csurgery = GLOB.operations.operations_by_typepath[__IMPLIED_TYPE__]
	UNLINT(csurgery.success(chest, surgeon, hemostat, list()))

	TEST_ASSERT(!LIMB_HAS_SURGERY_STATE(chest, SURGERY_VESSELS_UNCLAMPED), "Clamping bleeders did not remove the vessels unclamped surgical state")
	TEST_ASSERT(LIMB_HAS_SURGERY_STATE(chest, SURGERY_VESSELS_CLAMPED), "Clamping bleeders did not apply the vessels clamped surgical state")

	var/datum/surgery_operation/limb/saw_bones/ssurgery = GLOB.operations.operations_by_typepath[__IMPLIED_TYPE__]
	UNLINT(ssurgery.success(chest, surgeon, saw, list()))

	TEST_ASSERT(LIMB_HAS_SURGERY_STATE(chest, SURGERY_BONE_SAWED), "Sawing bones did not apply the bone sawed surgical state")
	TEST_ASSERT(LIMB_HAS_SURGERY_STATE(chest, SURGERY_VESSELS_CLAMPED), "Sawing bones removed the vessels clamped surgical state unexpectedly")
	TEST_ASSERT(LIMB_HAS_SURGERY_STATE(chest, SURGERY_SKIN_OPEN), "Sawing bones removed the skin open surgical state unexpectedly")

	var/datum/surgery_operation/limb/fix_bones/bsurgery = GLOB.operations.operations_by_typepath[__IMPLIED_TYPE__]
	UNLINT(bsurgery.success(chest, surgeon, bonesetter, list()))

	TEST_ASSERT(!LIMB_HAS_SURGERY_STATE(chest, SURGERY_BONE_SAWED), "Fixing bones did not remove the bone sawn surgery state")

	chest.remove_embedded_object(retractor)

	TEST_ASSERT(!LIMB_HAS_SURGERY_STATE(chest, SURGERY_SKIN_OPEN), "Removing retractor did not remove the open surgical state")

	chest.remove_embedded_object(hemostat)

	TEST_ASSERT(!LIMB_HAS_SURGERY_STATE(chest, SURGERY_VESSELS_CLAMPED), "Removing hemostat did not remove the clamped surgical state")

	var/datum/surgery_operation/limb/close_skin/msurgery = GLOB.operations.operations_by_typepath[__IMPLIED_TYPE__]
	UNLINT(msurgery.success(chest, surgeon, cautery, list()))

	TEST_ASSERT(!LIMB_HAS_ANY_SURGERY_STATE(chest, ALL), "Closing surgery did not remove all surgical states applied during surgery")
