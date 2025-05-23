// simple is_type and similar inline helpers


#define in_range(source, user) (get_dist(source, user) <= 1 && (get_step(source, 0)?:z) == (get_step(user, 0)?:z))

#define ismovableatom(A) ismovable(A)


#define isatom(A) (isloc(A))

#define isweakref(D) (istype(D, /datum/weakref))

#define isdatum(D) (istype(D, /datum))
//Turfs
//#define isturf(A) (istype(A, /turf)) This is actually a byond built-in. Added here for completeness sake.

GLOBAL_LIST_INIT(turfs_without_ground, typecacheof(list(
	/turf/open/lava,
	/turf/open/water,
	/turf/open/transparent/openspace
	)))

#define isclient(A) istype(A, /client)

#define ismind(A) istype(A, /datum/mind)

#define isgroundlessturf(A) (is_type_in_typecache(A, GLOB.turfs_without_ground))

#define isopenturf(A) (istype(A, /turf/open))

#define isopenspace(A) (istype(A, /turf/open/transparent/openspace))

#define isindestructiblefloor(A) (istype(A, /turf/open/indestructible))

#define isfloorturf(A) (istype(A, /turf/open/floor))

#define isclosedturf(A) (istype(A, /turf/closed))

#define isindestructiblewall(A) (istype(A, /turf/closed/indestructible))

#define iswallturf(A) (istype(A, /turf/closed/wall))

#define ismineralturf(A) (istype(A, /turf/closed/mineral))

#define islava(A) (istype(A, /turf/open/lava))

#define isplatingturf(A) (istype(A, /turf/open/floor/plating))

#define istransparentturf(A) (istype(A, /turf/open/transparent) || istype(A, /turf/closed/transparent))

//Mobs
#define isliving(A) (istype(A, /mob/living))

#define isbrain(A) (istype(A, /mob/living/brain))

//Carbon mobs
#define iscarbon(A) (istype(A, /mob/living/carbon))
#define isroguespirit(A) (istype(A, /mob/living/carbon/spirit)) //underworld spirit
#define ishuman(A) (istype(A, /mob/living/carbon/human))

//Human sub-species
#define ishumanbasic(A) (is_species(A, /datum/species/human))
#define isvampire(A) (is_species(A,/datum/species/vampire))

//RT species
#define ishumannorthern(A) (is_species(A, /datum/species/human/northern))
#define isdwarf(A) (is_species(A, /datum/species/dwarf))
#define isdwarfmountain(A) (is_species(A, /datum/species/dwarf/mountain))
#define iself(A) (is_species(A, /datum/species/elf))
#define isdarkelf(A) (is_species(A, /datum/species/elf/dark))
#define issnowelf(A) (is_species(A, /datum/species/elf/snow))
#define ishalfelf(A) (is_species(A, /datum/species/human/halfelf))
#define istiefling(A) (is_species(A, /datum/species/tieberian))
#define ishalforc(A) (is_species(A, /datum/species/halforc))
#define iskobold(A) (is_species(A, /datum/species/kobold))
#define israkshari(A) (is_species(A, /datum/species/rakshari))
#define isaasimar(A) (is_species(A, /datum/species/aasimar))
#define ishollowkin(A) (is_species(A, /datum/species/demihuman))
#define isharpy(A) (is_species(A, /datum/species/harpy))
#define ishalfdrow(A) (is_species(A, /datum/species/human/halfdrow))

//more carbon mobs
#define ismonkey(A) (istype(A, /mob/living/carbon/monkey))

#define istruedevil(A) (istype(A, /mob/living/carbon/true_devil))

//Simple animals
#define isanimal(A) (istype(A, /mob/living/simple_animal))

#define isshade(A) (istype(A, /mob/living/simple_animal/shade))

#define ismouse(A) (istype(A, /mob/living/simple_animal/mouse))

#define iscow(A) (istype(A, /mob/living/simple_animal/cow))

#define iscat(A) (istype(A, /mob/living/simple_animal/pet/cat))

#define ishostile(A) (istype(A, /mob/living/simple_animal/hostile))

#define isclown(A) (istype(A, /mob/living/simple_animal/hostile/retaliate/clown))


//Misc mobs
#define isobserver(A) (istype(A, /mob/dead/observer))

#define isrogueobserver(A) (istype(A, /mob/dead/observer/rogue))

#define isdead(A) (istype(A, /mob/dead))

#define isnewplayer(A) (istype(A, /mob/dead/new_player))

#define isovermind(A) (istype(A, /mob/camera/blob))

#define iscameramob(A) (istype(A, /mob/camera))

//Objects
#define isobj(A) istype(A, /obj) //override the byond proc because it returns true on children of /atom/movable that aren't objs

#define isitem(A) (istype(A, /obj/item))

#define isidcard(I) (istype(I, /obj/item/card/id))

#define isstructure(A) (istype(A, /obj/structure))

#define ismachinery(A) (istype(A, /obj/machinery))

#define is_cleanable(A) (istype(A, /obj/effect/decal/cleanable)) //if something is cleanable

#define isorgan(A) (istype(A, /obj/item/organ))

#define isclothing(A) (istype(A, /obj/item/clothing))

#define iscash(A) (istype(A, /obj/item/stack/spacecash) || istype(A, /obj/item/holochip))

GLOBAL_LIST_INIT(pointed_types, typecacheof(list(
	/obj/item/kitchen/fork)))

#define is_pointed(W) (is_type_in_typecache(W, GLOB.pointed_types))

#define isbodypart(A) (istype(A, /obj/item/bodypart))

#define isprojectile(A) (istype(A, /obj/projectile))

#define isgun(A) (istype(A, /obj/item/gun))


#define iseffect(O) (istype(O, /obj/effect))

#define isblobmonster(O) (istype(O, /mob/living/simple_animal/hostile/blob))

GLOBAL_LIST_INIT(RATS_DONT_EAT, typecacheof(list(
	/obj/item/reagent_containers/food/snacks/smallrat,
	/obj/item/reagent_containers/food/snacks/produce/vegetable/onion,
	/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry/poison
	)))

// Jobs
// Meta\Unsorted
	//#define is__job(job_type) (istype(job_type, /datum/job/)) //template for easy filling in
	#define is_unassigned_job(job_type) (istype(job_type, /datum/job/unassigned))
// Nobility
	#define is_lord_job(job_type) (istype(job_type, /datum/job/lord))
	#define is_consort_job(job_type) (istype(job_type, /datum/job/consort))
	#define is_merchant_job(job_type) (istype(job_type, /datum/job/merchant))
	#define is_steward_job(job_type) (istype(job_type, /datum/job/steward))
// Garrison
// Church
	#define is_priest_job(job_type) (istype(job_type, /datum/job/priest))
	#define is_monk_job(job_type) (istype(job_type, /datum/job/monk))
	#define is_inquisitor_job(job_type) (istype(job_type, /datum/job/inquisitor))
	#define is_adept_job(job_type) (istype(job_type, /datum/job/adept))
// Serfs
	#define is_gaffer_job(job_type) (istype(job_type, /datum/job/gaffer))
// Peasantry
	#define is_adventurer_job(job_type) (istype(job_type, /datum/job/adventurer))
	#define is_mercenary_job(job_type) (istype(job_type, /datum/job/mercenary))
	#define is_pilgrim_job(job_type) (istype(job_type, /datum/job/pilgrim))
	#define is_vagrant_job(job_type) (istype(job_type, /datum/job/vagrant))
//  Apprentices
	#define is_gaffer_assistant_job(job_type) (istype(job_type, /datum/job/gaffer_assistant))
// Villains
	#define is_skeleton_job(job_type) (istype(job_type, /datum/job/skeleton))
		#define is_skeleton_knight_job(job_type) (istype(job_type, /datum/job/skeleton/knight))
	#define is_rousman_job(job_type) (istype(job_type, /datum/job/rousman))
	#define is_goblin_job(job_type) (istype(job_type, /datum/job/goblin))

// seemingly deprecated:
//"Preacher" //as a job, there is an equivalent class
