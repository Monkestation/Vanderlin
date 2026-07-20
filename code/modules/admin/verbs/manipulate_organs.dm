/client/proc/manipulate_organs(mob/living/carbon/C as anything in GLOB.carbon_list)
	set name = "Manipulate Organs"
	set category = "Debug"
	var/operation = input("Select organ operation.", "Organ Manipulation", "cancel") as null|anything in list("add organ", "drop organ", "remove organ", "cancel")
	if (!operation)
		return

	var/list/organs = list()
	switch(operation)
		if("add organ")
			for(var/path in subtypesof(/obj/item/organ))
				var/dat = replacetext("[path]", "/obj/item/organ/", ":")
				organs[dat] = path

			var/obj/item/organ/organ = input("Select organ type:", "Organ Manipulation", null) as null|anything in organs
			if(!organ)
				return
			organ = organs[organ]
			organ = new organ
			organ.Insert(C)
			log_admin("[key_name(usr)] has added organ [organ.type] to [key_name(C)]")
			message_admins("[key_name_admin(usr)] has added organ [organ.type] to [ADMIN_LOOKUPFLW(C)]")

		if("drop organ", "remove organ")
			for(var/obj/item/organ/I as anything in C.internal_organs)
				organs["[I.name] ([I.type])"] = I

			var/obj/item/organ = input("Select organ/implant:", "Organ Manipulation", null) as null|anything in organs
			if(!organ)
				return
			organ = organs[organ]
			if(!organ)
				return
			var/obj/item/organ/O

			log_admin("[key_name(usr)] has removed [organ.type] from [key_name(C)]")
			message_admins("[key_name_admin(usr)] has removed [organ.type] from [ADMIN_LOOKUPFLW(C)]")

			if(isorgan(organ))
				O = organ
				O.Remove(C)

			organ.forceMove(get_turf(C))

			if(operation == "remove organ/implant")
				qdel(organ)
