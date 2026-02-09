/*

Usage:
Override /Run() to run your test code

Call Fail() to fail the test (You should specify a reason)

You may use /New() and /Destroy() for setup/teardown respectively

You can use the run_loc_bottom_left and run_loc_top_right to get turfs for testing

*/

GLOBAL_DATUM(current_test, /datum/unit_test)
GLOBAL_VAR_INIT(failed_any_test, FALSE)
GLOBAL_VAR(test_log)
/// When unit testing, all logs sent to log_mapping are stored here and retrieved in log_mapping unit test.
GLOBAL_LIST_EMPTY(unit_test_mapping_logs)

/// The name of the test that is currently focused.
/// Use the PERFORM_ALL_TESTS macro instead.
GLOBAL_VAR_INIT(focused_test, focused_test())
/// Global assoc list of required mapping items, [item typepath] to [required item datum].
GLOBAL_LIST_EMPTY(required_map_items)

/proc/focused_test()
	for(var/datum/unit_test/unit_test as anything in subtypesof(/datum/unit_test))
		if(initial(unit_test.focus))
			return unit_test
	return null

/datum/unit_test
	//Bit of metadata for the future maybe
	var/list/procs_tested

	/// The bottom left floor turf of the testing zone
	var/turf/run_loc_floor_bottom_left
	/// The top right floor turf of the testing zone
	var/turf/run_loc_floor_top_right

	///The priority of the test, the larger it is the later it fires
	var/priority = TEST_DEFAULT

	//internal shit
	var/list/allocated
	var/focus = FALSE
	var/succeeded = TRUE
	var/list/fail_reasons

	/// List of atoms that we don't want to ever initialize in an agnostic context, like for Create and Destroy. Stored on the base datum for usability in other relevant tests that need this data.
	var/static/list/uncreatables = null

	var/static/datum/space_level/reservation

/proc/cmp_unit_test_priority(datum/unit_test/a, datum/unit_test/b)
	return initial(a.priority) - initial(b.priority)

/datum/unit_test/New()
	if(isnull(reservation))
		var/datum/map_template/unit_tests/template = new
		reservation = template.load_new_z()

	if(isnull(uncreatables))
		uncreatables = build_list_of_uncreatables()

	allocated = new
	run_loc_floor_bottom_left = get_turf(locate(/obj/effect/landmark/unit_test_bottom_left) in GLOB.landmarks_list)
	run_loc_floor_top_right = get_turf(locate(/obj/effect/landmark/unit_test_top_right) in GLOB.landmarks_list)

	TEST_ASSERT(isfloorturf(run_loc_floor_bottom_left), "run_loc_floor_bottom_left was not a floor ([run_loc_floor_bottom_left])")
	TEST_ASSERT(isfloorturf(run_loc_floor_top_right), "run_loc_floor_top_right was not a floor ([run_loc_floor_top_right])")

/datum/unit_test/Destroy()
	QDEL_LIST(allocated)
	// clear the test area
	for(var/turf/turf in Z_TURFS(run_loc_floor_bottom_left.z))
		for(var/content in turf.contents)
			if(istype(content, /obj/effect/landmark))
				continue
			qdel(content)
	return ..()

/datum/unit_test/proc/Run()
	Fail("Run() called parent or not implemented")

/datum/unit_test/proc/Fail(reason = "No reason", file = "OUTDATED_TEST", line = 1)
	succeeded = FALSE

	if(!istext(reason))
		reason = "FORMATTED: [reason != null ? reason : "NULL"]"

	LAZYADD(fail_reasons, list(list(reason, file, line)))

/// Allocates an instance of the provided type, and places it somewhere in an available loc
/// Instances allocated through this proc will be destroyed when the test is over
/datum/unit_test/proc/allocate(type, ...)
	var/list/arguments = args.Copy(2)
	if(ispath(type, /atom))
		if (!arguments.len)
			arguments = list(run_loc_floor_bottom_left)
		else if (arguments[1] == null)
			arguments[1] = run_loc_floor_bottom_left
	var/instance
	// Byond will throw an index out of bounds if arguments is empty in that arglist call. Sigh
	if(length(arguments))
		instance = new type(arglist(arguments))
	else
		instance = new type()
	allocated += instance
	return instance

/datum/unit_test/proc/log_for_test(text, priority, file, line)
	var/map_name = SSmapping.config?.map_name

	// Need to escape the text to properly support newlines.
	var/annotation_text = replacetext(text, "%", "%25")
	annotation_text = replacetext(annotation_text, "\n", "%0A")

	log_world("::[priority] file=[file],line=[line],title=[map_name]: [type]::[annotation_text]")

/datum/unit_test/proc/final/build_list_of_uncreatables()
	var/list/ignore = list(
		//Never meant to be created, errors out the ass for mobcode reasons
		/mob/living/carbon,
		//Needs a seed passed, but subtypes set one by default
		/obj/item/grown,
		/obj/item/reagent_containers/food/snacks/grown,
		//Template type
		/obj/effect/mob_spawn,
		//Singleton
		/mob/dview,
		//Template type
		/obj/item/bodypart,
		//template types
		//template type again
		/obj/item/storage/fancy,
		//needs a mob passed to view it
		/atom/movable/screen/credit,
		// requires a pod passed
		/obj/effect/DPfall,
		/obj/effect/DPtarget,
		// prompts loc for input
		/obj/item/clothing/shirt/grenzelhoft,
		// Sets usr on initialise,
		/obj/item/sendingstonesummoner,
		// sets all it's shit on initialize
		/obj/effect/temp_visual/offered_item_effect,
		// This should be obvious
		/obj/merge_conflict_marker,
		///this object exists purely to create a template spawning it in is nah
		/obj/effect/landmark/house_spot,
		/// stuff in this sets everyting in initialize args
		/obj/effect/fuse,
		///shit that calls explosion() should probably not be called in empty space
		/obj/effect/temp_visual/target/meteor,
		/obj/structure/meatvine/papameat,
		/obj/effect/meatvine_controller,
	)
	///this does some wonky things that we don't want in a test area
	ignore += typesof(/obj/structure/stockpile_storage,)
	//these are VERY situational and need info passed
	ignore += typesof(/obj/effect/abstract)
	//needs a lich passed
	ignore += typesof(/obj/item/phylactery)
	//cba to fix hitscans erroring in Destroy, so just ignore all projectiles
	ignore += typesof(/obj/projectile)
	//Say it with me now, type template
	ignore += typesof(/obj/effect/mapping_helpers)
	//This turf existing is an error in and of itself
	ignore += typesof(/turf/baseturf_skipover)
	ignore += typesof(/turf/baseturf_bottom)
	//We have a baseturf limit of 10, adding more than 10 baseturf helpers will kill CI, so here's a future edge case to fix.
	ignore += typesof(/obj/effect/baseturf_helper)
	//Expects a mob to holderize, we have nothing to give
	ignore += typesof(/obj/item/mob_holder)
	//Needs cards passed into the initilazation args
	ignore += typesof(/obj/item/toy/cards/cardhand)
	//needs multiple atoms passed
	ignore += typesof(/obj/effect/buildmode_line)
	//runtimes without a landmark to spawn on
	ignore += typesof(/obj/structure/industrial_lift)
	//will delay the test a LOT and cause a ton of spawns
	ignore += typesof(/obj/effect/landmark/mapGenerator)

	ignore += typesof(/obj/effect/spawner)
	ignore += typesof(/atom/movable/screen)
	ignore += typesof(/obj/abstract)

	return ignore

/proc/RunUnitTests()
	CHECK_TICK

	var/list/tests_to_run = subtypesof(/datum/unit_test)
	var/list/focused_tests = list()
	for(var/datum/unit_test/test_to_run as anything in tests_to_run)
		if (initial(test_to_run.focus))
			focused_tests += test_to_run
	if(length(focused_tests))
		tests_to_run = focused_tests

	sortTim(tests_to_run, GLOBAL_PROC_REF(cmp_unit_test_priority))

	var/list/test_results = list()

	//Hell code, we're bound to end the round somehow so let's stop if from ending while we work
	SSticker.delay_end = TRUE
	for(var/unit_path in tests_to_run)
		CHECK_TICK //We check tick first because the unit test we run last may be so expensive that checking tick will lock up this loop forever
		RunUnitTest(unit_path, test_results)
	SSticker.delay_end = FALSE

	var/file_name = "data/unit_tests.json"
	fdel(file_name)
	file(file_name) << json_encode(test_results)

	SSticker.force_ending = 1
	//We have to call this manually because del_text can preceed us, and SSticker doesn't fire in the post game
	SSticker.declare_completion()

/proc/RunUnitTest(datum/unit_test/test_path, list/test_results)
	if(ispath(test_path, /datum/unit_test/focus_only))
		return

	if(initial(test_path.abstract_type) == test_path)
		return

	var/datum/unit_test/test = new test_path

	GLOB.current_test = test
	var/duration = REALTIMEOFDAY
	var/skip_test = (test_path in SSmapping.config?.skipped_tests)
	var/test_output_desc = "[test_path]"
	var/message = ""

	log_world("::group::[test_path]")

	if(skip_test)
		log_world("SKIPPED Skipped run on map [SSmapping.config?.map_name].")

	else

		test.Run()

		duration = REALTIMEOFDAY - duration
		GLOB.current_test = null
		GLOB.failed_any_test |= !test.succeeded

		var/list/log_entry = list()
		var/list/fail_reasons = test.fail_reasons
		var/map_name = SSmapping.config.map_name

		for(var/reasonID in 1 to LAZYLEN(fail_reasons))
			var/text = fail_reasons[reasonID][1]
			var/file = fail_reasons[reasonID][2]
			var/line = fail_reasons[reasonID][3]

			test.log_for_test(text, "error", file, line)

			// Normal log message
			log_entry += "\tFAILURE #[reasonID]: [text] at [file]:[line] on [map_name]"

		if(length(log_entry))
			message = log_entry.Join("\n")
			log_test(message)

		test_output_desc += " [duration / 10]s"
		if (test.succeeded)
			log_world("PASS [test_output_desc]")

	log_world("::endgroup::")

	if (!test.succeeded && !skip_test)
		log_world("::error::FAIL [test_output_desc]")

	var/final_status = skip_test ? UNIT_TEST_SKIPPED : (test.succeeded ? UNIT_TEST_PASSED : UNIT_TEST_FAILED)
	test_results[test_path] = list("status" = final_status, "message" = message, "name" = test_path)

	qdel(test)

/datum/map_template/unit_tests
	name = "Unit Tests Zone"
	mappath = "_maps/templates/unit_tests.dmm"
