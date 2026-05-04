//injury helpers
/obj/item/bodypart/proc/get_injury_type(type, damage)
	if(is_organic_limb())
		switch(type)
			if(WOUND_SLASH)
				switch(damage)
					if(70 to INFINITY)
						return /datum/injury/slash/massive
					if(60 to 70)
						return /datum/injury/slash/gaping_big
					if(50 to 60)
						return /datum/injury/slash/gaping
					if(25 to 50)
						return /datum/injury/slash/flesh
					if(15 to 25)
						return /datum/injury/slash/deep
					if(0 to 15)
						return /datum/injury/slash/small
			if(WOUND_PIERCE)
				switch(damage)
					if(60 to INFINITY)
						return /datum/injury/puncture/massive
					if(50 to 60)
						return /datum/injury/puncture/gaping_big
					if(30 to 50)
						return /datum/injury/puncture/gaping
					if(15 to 30)
						return /datum/injury/puncture/flesh
					if(0 to 15)
						return /datum/injury/puncture/small
			if(WOUND_BLUNT)
				switch(damage)
					if(80 to INFINITY)
						return /datum/injury/bruise/monumental
					if(50 to 80)
						return /datum/injury/bruise/huge
					if(25 to 50)
						return /datum/injury/bruise/large
					if(10 to 25)
						return /datum/injury/bruise/moderate
					if(0 to 10)
						return /datum/injury/bruise/small
			if(WOUND_BURN)
				switch(damage)
					if(50 to INFINITY)
						return /datum/injury/burn/carbonised
					if(40 to 50)
						return /datum/injury/burn/deep
					if(30 to 40)
						return /datum/injury/burn/severe
					if(15 to 30)
						return /datum/injury/burn/large
					if(0 to 15)
						return /datum/injury/burn/moderate
			if(WOUND_LASH)
				switch(damage)
					if(50 to INFINITY)
						return /datum/injury/lash/flayed
					if(40 to 50)
						return /datum/injury/lash/deep
					if(30 to 40)
						return /datum/injury/lash/severe
					if(15 to 30)
						return /datum/injury/lash/lash
					if(0 to 15)
						return /datum/injury/lash/welt
			if(WOUND_BITE)
				switch(damage)
					if(70 to INFINITY)
						return /datum/injury/bite/massive
					if(60 to 70)
						return /datum/injury/bite/gaping_big
					if(50 to 60)
						return /datum/injury/bite/gaping
					if(25 to 50)
						return /datum/injury/bite/flesh
					if(15 to 25)
						return /datum/injury/bite/deep
					if(0 to 15)
						return /datum/injury/bite/small
			if(WOUND_INTERNAL_BRUISE)
				switch(damage)
					if(50 to INFINITY)
						return /datum/injury/internal_bruise/catastrophic
					if(40 to 50)
						return /datum/injury/internal_bruise/critical
					if(30 to 40)
						return /datum/injury/internal_bruise/severe
					if(15 to 30)
						return /datum/injury/internal_bruise/moderate
					if(0 to 15)
						return /datum/injury/internal_bruise/minor
			if(WOUND_DIVINE)
				switch(damage)
					if(50 to INFINITY)
						return /datum/injury/divine/condemned
					if(40 to 50)
						return /datum/injury/divine/wrath
					if(30 to 40)
						return /datum/injury/divine/severe
					if(15 to 30)
						return /datum/injury/divine/brand
					if(0 to 15)
						return /datum/injury/divine/smite

	else
		switch(type)
			if(WOUND_SLASH)
				switch(damage)
					if(70 to INFINITY)
						return /datum/injury/slash/massive/mechanical
					if(60 to 70)
						return /datum/injury/slash/gaping_big/mechanical
					if(50 to 60)
						return /datum/injury/slash/gaping/mechanical
					if(25 to 50)
						return /datum/injury/slash/flesh/mechanical
					if(15 to 25)
						return /datum/injury/slash/deep/mechanical
					if(0 to 15)
						return /datum/injury/slash/small/mechanical
			if(WOUND_PIERCE)
				switch(damage)
					if(60 to INFINITY)
						return /datum/injury/puncture/massive/mechanical
					if(50 to 60)
						return /datum/injury/puncture/gaping_big/mechanical
					if(30 to 50)
						return /datum/injury/puncture/gaping/mechanical
					if(15 to 30)
						return /datum/injury/puncture/flesh/mechanical
					if(0 to 15)
						return /datum/injury/puncture/small/mechanical
			if(WOUND_BLUNT)
				switch(damage)
					if(80 to INFINITY)
						return /datum/injury/bruise/monumental/mechanical
					if(50 to 80)
						return /datum/injury/bruise/huge/mechanical
					if(30 to 50)
						return /datum/injury/bruise/large/mechanical
					if(10 to 20)
						return /datum/injury/bruise/moderate/mechanical
					if(0 to 10)
						return /datum/injury/bruise/small/mechanical
			if(WOUND_BURN)
				switch(damage)
					if(50 to INFINITY)
						return /datum/injury/burn/carbonised/mechanical
					if(40 to 50)
						return /datum/injury/burn/deep/mechanical
					if(30 to 40)
						return /datum/injury/burn/severe/mechanical
					if(15 to 30)
						return /datum/injury/burn/large/mechanical
					if(0 to 15)
						return /datum/injury/burn/moderate/mechanical
			if(WOUND_LASH)
				switch(damage)
					if(50 to INFINITY)
						return /datum/injury/lash/flayed/mechanical
					if(40 to 50)
						return /datum/injury/lash/deep/mechanical
					if(30 to 40)
						return /datum/injury/lash/severe/mechanical
					if(15 to 30)
						return /datum/injury/lash/lash/mechanical
					if(0 to 15)
						return /datum/injury/lash/welt/mechanical
			if(WOUND_BITE)
				switch(damage)
					if(70 to INFINITY)
						return /datum/injury/bite/massive/mechanical
					if(60 to 70)
						return /datum/injury/bite/gaping_big/mechanical
					if(50 to 60)
						return /datum/injury/bite/gaping/mechanical
					if(25 to 50)
						return /datum/injury/bite/flesh/mechanical
					if(15 to 25)
						return /datum/injury/bite/deep/mechanical
					if(0 to 15)
						return /datum/injury/bite/small/mechanical
			if(WOUND_INTERNAL_BRUISE)
				switch(damage)
					if(50 to INFINITY)
						return /datum/injury/internal_bruise/catastrophic/mechanical
					if(40 to 50)
						return /datum/injury/internal_bruise/critical/mechanical
					if(30 to 40)
						return /datum/injury/internal_bruise/severe/mechanical
					if(15 to 30)
						return /datum/injury/internal_bruise/moderate/mechanical
					if(0 to 15)
						return /datum/injury/internal_bruise/minor/mechanical
			if(WOUND_DIVINE)
				switch(damage)
					if(50 to INFINITY)
						return /datum/injury/divine/condemned/mechanical
					if(40 to 50)
						return /datum/injury/divine/wrath/mechanical
					if(30 to 40)
						return /datum/injury/divine/severe/mechanical
					if(15 to 30)
						return /datum/injury/divine/brand/mechanical
					if(0 to 15)
						return /datum/injury/divine/smite/mechanical

	return //no injury
