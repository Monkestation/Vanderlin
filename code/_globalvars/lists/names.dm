GLOBAL_LIST_INIT(commando_names, file2list("strings/names/death_commando.txt"))
GLOBAL_LIST_INIT(first_names, file2list("strings/names/first.txt"))
GLOBAL_LIST_INIT(first_names_male, file2list("strings/names/first_male.txt"))
GLOBAL_LIST_INIT(first_names_female, file2list("strings/names/first_female.txt"))
GLOBAL_LIST_INIT(last_names, file2list("strings/names/last.txt"))
GLOBAL_LIST_INIT(lizard_names_male, file2list("strings/names/lizard_male.txt"))
GLOBAL_LIST_INIT(lizard_names_female, file2list("strings/names/lizard_female.txt"))
GLOBAL_LIST_INIT(ethereal_names, file2list("strings/names/ethereal.txt"))

GLOBAL_LIST_INIT(verbs, file2list("strings/names/verbs.txt"))
GLOBAL_LIST_INIT(ing_verbs, file2list("strings/names/ing_verbs.txt"))
GLOBAL_LIST_INIT(adverbs, file2list("strings/names/adverbs.txt"))
GLOBAL_LIST_INIT(adjectives, file2list("strings/names/adjectives.txt"))
GLOBAL_LIST_INIT(dream_strings, file2list("strings/dreamstrings.txt"))

GLOBAL_LIST_INIT(ooctitle, file2list("strings/names/roguetown/ooctitle.txt"))

GLOBAL_LIST_INIT(preferences_custom_names, list(
	"human" = list("pref_name" = "Backup Human", "qdesc" = "backup human name, used in the event you are assigned a command role as another species", "allow_numbers" = FALSE , "group" = "backup_human", "allow_null" = FALSE),
	"clown" = list("pref_name" = "Clown" , "qdesc" = "clown name", "allow_numbers" = FALSE , "group" = "fun", "allow_null" = FALSE),
	"mime" = list("pref_name" = "Mime", "qdesc" = "mime name" , "allow_numbers" = FALSE , "group" = "fun", "allow_null" = FALSE),
	"cyborg" = list("pref_name" = "Cyborg", "qdesc" = "cyborg name (Leave empty to use default naming scheme)", "allow_numbers" = TRUE , "group" = "silicons", "allow_null" = TRUE),
	"ai" = list("pref_name" = "AI", "qdesc" = "ai name", "allow_numbers" = TRUE , "group" = "silicons", "allow_null" = FALSE),
	"religion" = list("pref_name" = "Chaplain religion", "qdesc" = "religion" , "allow_numbers" = TRUE , "group" = "chaplain", "allow_null" = FALSE),
	"deity" = list("pref_name" = "Chaplain deity", "qdesc" = "deity", "allow_numbers" = TRUE , "group" = "chaplain", "allow_null" = FALSE)
	))
