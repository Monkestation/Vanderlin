/datum/book_entry/smithing_repair
	name = "The Art of Metal Repair"
	category = "Smithing"
/datum/book_entry/smithing_repair/inner_book_html(mob/user)
	return {"
		<div style="text-align: left;">
			<h2>Repairing Metalwork</h2>
			All metal items suffer wear and damage over time. A skilled smith knows that maintaining equipment is just as important as forging it. There are two distinct stages of metal repair: restoring integrity through hammering, and restoring lost maximum integrity through melding with new material.<br>
			<br>
			<h2>Hammering Out Damage</h2>
			When a metal item has taken damage but has not broken, it can be repaired by striking it with a hammer. Simply place the item on the ground and strike it with your hammer. Working over an anvil will double the effectiveness of your repairs.<br>
			<br>
			The quality of the repair depends heavily on your skill. Novice smiths may fumble and cause further damage, while experienced smiths will restore significant integrity with each strike. Those with no formal training still have a chance at minor repairs, though the risk of making things worse is considerable.<br>
			<br>
			<h2>Restoring a Broken Item</h2>
			When an item has broken entirely, it can still be repaired with a hammer alone. Place the broken item on the ground and strike it. The item will be restored to function, though it will never be quite as strong as it once was. The break leaves a permanent mark, and the integrity lost depends on your skill. An inexperienced smith will see far greater loss than a seasoned one.<br>
			<br>
			Working over an anvil will improve the repair, as with all hammer work. Those with no formal training may still attempt a broken repair, though the results are unpredictable and the item may suffer further damage in the process.<br>
			<br>
			<h2>Melding</h2>
			Even after repair, a damaged item's maximum integrity may be reduced from years of use and past repairs. Through melding, a smith can work new material into the item to restore some of what was lost. Heat an ingot of the appropriate material in a forge, grip it with your tongs, and strike the item with your hammer while holding the tongs in your offhand.<br>
			<br>
			The ingot will be consumed in the process. The amount restored depends on your skill level, and each meld is less effective than the last as the metal becomes less receptive to new material. Melding requires at least some formal training — those without skill cannot work new material into old metal.<br>
			<br>
			<h2>Diminishing Returns</h2>
			Metal can only be re-melded so many times before it will no longer accept new material. Each restoration reduces the effectiveness of the next. A piece that has been melded three times is at its limit and no further restoration is possible. Choose carefully when and what to meld.<br>
			<br>
			<h2>Skill and Repair Quality</h2>
			<b>Master:</b> Minimal integrity loss on broken repairs. Near-full restoration per meld.<br>
			<b>Journeyman:</b> Moderate integrity loss. Reliable repairs with consistent results.<br>
			<b>Apprentice:</b> Noticeable integrity loss. Repairs are rough but functional.<br>
			<b>Novice:</b> Heavy integrity loss. Broken repairs leave items significantly weakened.<br>
			<b>Untrained:</b> 30% chance of a minor fumbled repair. 70% chance of further damage.<br>
		</div>
	"}

/datum/book_entry/sewing_repair
	name = "Mending and Melding, A Guide to Fabric Repair"
	category = "Domestic"
/datum/book_entry/sewing_repair/inner_book_html(mob/user)
	return {"
		<div style="text-align: left;">
			<h2>The Needle and its Uses</h2>
			A needle and thread are the primary tools of fabric repair. With steady hands and a practiced eye, even heavily damaged cloth and leather goods can be restored to serviceable condition. The needle has two distinct uses in repair: mending damaged goods, and melding new material into worn ones.<br>
			<br>
			<h2>Mending Damaged Items</h2>
			When a cloth or leather item has taken damage but has not broken, it can be repaired by placing it on a table and working it with a threaded needle. The amount restored with each pass depends on your sewing skill. Novices risk damaging the item further, while practiced sewers will restore meaningful integrity with each attempt.<br>
			<br>
			Those with no formal training still have a small chance of minor repairs, though fumbling is common and may worsen the item's condition.<br>
			<br>
			<h2>Repairing Broken Items</h2>
			When an item has broken entirely, it can still be repaired with a needle alone. No additional material is needed. Place the broken item on a table and work it carefully with your needle. The item will be restored to function, though the break leaves its mark. Skill determines how much integrity is lost in the process.<br>
			<br>
			Those with no formal training may still attempt a broken repair, though the results are unpredictable and the item may suffer further damage in the process.<br>
			<br>
			<h2>Melding</h2>
			Over time and through repeated repairs, an item's maximum integrity diminishes. Melding allows a sewer to work fresh material into the fabric, restoring some of what was lost. To meld an item, place the appropriate salvage material on the same surface as the item and apply your needle. The material will be consumed in the process.<br>
			<br>
			Melding requires at least some formal training. Those without skill cannot coax new material into old fabric. The amount restored depends on skill and how many times the item has already been melded, with each meld being less effective than the last.<br>
			<br>
			<h2>Diminishing Returns</h2>
			Fabric, like metal, has its limits. An item that has been melded three times will no longer accept new material. The weave is simply too set in its ways. Plan your repairs accordingly and do not squander meld attempts on lightly damaged goods.<br>
			<br>
			<h2>Thread and Needle Care</h2>
			A needle's thread is consumed through use. Failed repairs and fumbles may use thread even when no progress is made. Keep your needle supplied with fresh fiber and it will serve you well. A needle with no thread left is useless for repair work until restocked.<br>
			<br>
			<h2>Skill and Repair Quality</h2>
			<b>Master:</b> Minimal integrity loss on broken repairs. Near-full restoration per meld.<br>
			<b>Journeyman:</b> Moderate integrity loss. Clean repairs with little wasted thread.<br>
			<b>Apprentice:</b> Noticeable integrity loss. Repairs hold but show the work.<br>
			<b>Novice:</b> Heavy integrity loss. Broken repairs leave items significantly weakened.<br>
			<b>Untrained:</b> 30% chance of a minor fumbled repair. 70% chance of further damage.<br>
		</div>
	"}
