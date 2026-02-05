/**
 * Tests that actions assigned to a mob's mind
 * are successfuly transferred when their mind is transferred to a new mob.
 */
/datum/unit_test/actions_moved_on_mind_transfer

/datum/unit_test/actions_moved_on_mind_transfer/Run()

	var/mob/living/carbon/human/wizard = allocate(/mob/living/carbon/human)
	var/mob/living/simple_animal/pet/cat/wizard_cat = allocate(/mob/living/simple_animal/pet/cat/black)
	wizard.mind_initialize()

	var/datum/action/cooldown/spell/projectile/fireball/fireball = new(wizard.mind)
	fireball.Grant(wizard)
	var/datum/action/cooldown/spell/aoe/knock/knock = new(wizard.mind)
	knock.Grant(wizard)
	var/datum/action/cooldown/spell/undirected/jaunt/ethereal_jaunt/jaunt = new(wizard.mind)
	jaunt.Grant(wizard)

	var/datum/mind/wizard_mind = wizard.mind
	wizard_mind.transfer_to(wizard_cat)

	TEST_ASSERT_EQUAL(wizard_cat.mind, wizard_mind, "Mind transfer failed to occur, which invalidates the test.")

	for(var/datum/action/cooldown/spell/remaining_spell in wizard.actions)
		TEST_FAIL("Spell: [remaining_spell] failed to transfer minds when a mind transfer occured.")

	qdel(fireball)
	qdel(knock)
	qdel(jaunt)
