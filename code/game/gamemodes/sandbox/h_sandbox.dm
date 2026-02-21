GLOBAL_VAR_INIT(hsboxspawn, TRUE)

/mob/proc/CanBuild()
	sandbox = new/datum/hSB
	sandbox.owner = src.ckey
	if(src.client.holder)
		sandbox.admin = 1
	add_verb(src, new/mob/proc/sandbox_panel)
/mob/proc/sandbox_panel()
	set name = "Sandbox Panel"
	if(sandbox)
		sandbox.update()

/datum/hSB
	var/owner = null
	var/admin = 0

	var/static/clothinfo = null
	var/static/reaginfo = null
	var/static/objinfo = null
	var/canisterinfo = null
	var/hsbinfo = null
	//items that shouldn't spawn on the floor because they would bug or act weird
	var/static/list/spawn_forbidden = list(
		/obj/projectile)

/datum/hSB/proc/update()
	var/static/list/hrefs = list(
			"Space Gear",

			"Standard Tools",
			"Spawn Torch"					= "hsbspawn&path=[/obj/item/flashlight/flare/torch]")



	if(!hsbinfo)
		hsbinfo = "<center><b>Sandbox Panel</b></center><hr>"
		if(admin)
			hsbinfo += "<b>Administration</b><br>"
			hsbinfo += "- <a href='byond://?src=[REF(src)];hsb=hsbtobj'>Toggle Object Spawning</a><br>"
			hsbinfo += "- <a href='byond://?src=[REF(src)];hsb=hsbtac'>Toggle Item Spawn Panel Auto-close</a><br>"
		else
			hsbinfo += "<i>Some item spawning may be disabled by the administrators.</i><br>"
			hsbinfo += "<i>Only administrators may spawn dangerous canisters.</i><br>"
		for(var/T in hrefs)
			var/href = hrefs[T]
			if(href)
				hsbinfo += "- <a href='?[REF(src)];hsb=[hrefs[T]]'>[T]</a><br>"
			else
				hsbinfo += "<br><b>[T]</b><br>"
		hsbinfo += "<hr>"
		hsbinfo += "- <a href='?[REF(src)];hsb=hsbcloth'>Spawn Clothing...</a><br>"
		hsbinfo += "- <a href='?[REF(src)];hsb=hsbreag'>Spawn Reagent Container...</a><br>"
		hsbinfo += "- <a href='?[REF(src)];hsb=hsbobj'>Spawn Other Item...</a><br><br>"

	usr << browse(hsbinfo, "window=hsbpanel")

/datum/hSB/Topic(href, href_list)
	if(!usr || !src || !(src.owner == usr.ckey))
		if(usr)
			usr << browse(null,"window=sandbox")
		return

	if(href_list["hsb"])
		switch(href_list["hsb"])
			//
			// Admin: toggle spawning
			//
			if("hsbtobj")
				if(!admin) return
				if(GLOB.hsboxspawn)
					to_chat(world, "<span class='boldannounce'>Sandbox:</span> <b>\black[usr.key] has disabled object spawning!</b>")
					GLOB.hsboxspawn = FALSE
					return
				else
					to_chat(world, "<span class='boldnotice'>Sandbox:</span> <b>\black[usr.key] has enabled object spawning!</b>")
					GLOB.hsboxspawn = TRUE
					return
			//
			// Admin: Toggle auto-close
			//
			if("hsbtac")
				if(!admin) return
				var/sbac = CONFIG_GET(flag/sandbox_autoclose)
				if(sbac)
					to_chat(world, "<span class='boldnotice'>Sandbox:</span> <b>\black [usr.key] has removed the object spawn limiter.</b>")
				else
					to_chat(world, "<span class='danger'>Sandbox:</span> <b>\black [usr.key] has added a limiter to object spawning. The window will now auto-close after use.</b>")
				CONFIG_SET(flag/sandbox_autoclose, !sbac)
				return
			//
			// Object spawn window
			//

			// Clothing
			if("hsbcloth")
				if(!GLOB.hsboxspawn) return

				if(!clothinfo)
					clothinfo = "<b>Clothing</b> <a href='?[REF(src)];hsb=hsbreag'>(Reagent Containers)</a> <a href='?[REF(src)];hsb=hsbobj'>(Other Items)</a><hr><br>"
					var/list/all_items = subtypesof(/obj/item/clothing)
					for(var/typekey in spawn_forbidden)
						all_items -= typesof(typekey)
					for(var/O in reverseRange(all_items))
						clothinfo += "<a href='byond://?src=[REF(src)];hsb=hsb_safespawn&path=[O]'>[O]</a><br>"

				usr << browse(clothinfo,"window=sandbox")

			// Reagent containers
			if("hsbreag")
				if(!GLOB.hsboxspawn) return

				if(!reaginfo)
					reaginfo = "<b>Reagent Containers</b> <a href='?[REF(src)];hsb=hsbcloth'>(Clothing)</a> <a href='?[REF(src)];hsb=hsbobj'>(Other Items)</a><hr><br>"
					var/list/all_items = subtypesof(/obj/item/reagent_containers)
					for(var/typekey in spawn_forbidden)
						all_items -= typesof(typekey)
					for(var/O in reverseRange(all_items))
						reaginfo += "<a href='byond://?src=[REF(src)];hsb=hsb_safespawn&path=[O]'>[O]</a><br>"

				usr << browse(reaginfo,"window=sandbox")

			// Other items
			if("hsbobj")
				if(!GLOB.hsboxspawn) return

				if(!objinfo)
					objinfo = "<b>Other Items</b> <a href='?[REF(src)];hsb=hsbcloth'>(Clothing)</a> <a href='?[REF(src)];hsb=hsbreag'>(Reagent Containers)</a><hr><br>"
					var/list/all_items = subtypesof(/obj/item/) - typesof(/obj/item/clothing) - typesof(/obj/item/reagent_containers)
					for(var/typekey in spawn_forbidden)
						all_items -= typesof(typekey)

					for(var/O in reverseRange(all_items))
						objinfo += "<a href='byond://?src=[REF(src)];hsb=hsb_safespawn&path=[O]'>[O]</a><br>"

				usr << browse(objinfo,"window=sandbox")

			//
			// Safespawn checks to see if spawning is disabled.
			//
			if("hsb_safespawn")
				if(!GLOB.hsboxspawn)
					usr << browse(null,"window=sandbox")
					return

				var/typepath = text2path(href_list["path"])
				if(!typepath)
					to_chat(usr, "Bad path: \"[href_list["path"]]\"")
					return
				new typepath(usr.loc)

				if(CONFIG_GET(flag/sandbox_autoclose))
					usr << browse(null,"window=sandbox")
			//
			// For everything else in the href list
			//
			if("hsbspawn")
				var/typepath = text2path(href_list["path"])
				if(!typepath)
					to_chat(usr, "Bad path: \"[href_list["path"]]\"")
					return
				new typepath(usr.loc)

				if(CONFIG_GET(flag/sandbox_autoclose))
					usr << browse(null,"window=sandbox")
