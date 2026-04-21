/datum/book_entry/mana_sources
	name = "Mana Sources"

/datum/book_entry/mana_sources/inner_book_html(mob/user)
	return {"
		<div>
		<h2>What are ways you can get mana passively?</h2>
		For a regular person they do not have any way to passively absorb mana.<br>
		For a mage they can passively absorb the mana from leylines by being near them. <br>
		For liches they need to absorb souls to regain mana. <br>
		Foci restore mana by being near either Pylons or Leylines.
		</div>
		<br>

		<div>
		<h2> What are mana pylons </h2>
		Mana Pylons are ways to move mana from leylines to a central point, they can store more mana then a leyline can so its good to set them up. <br>
		They will automatically push mana out into arcyne structures like the Mana Fountain. <br>
		If you have a foci on you they will absorb mana from the Leyline on your behalf, so making a loop around your domain is ideal.<br>
		Using a gem on a pylon will create a network with that gem, preventing anything without a matching network id from using it, <br>
		this means that if you want to restrict the mana from being absorbed you'd want to attune the pylons outside and leave un-attuned <br>
		pylons inside so that only you can absorb without an attunement in a specific location.
		</div>
		<br>

		<div>
		<h2> Mana Fountain </h2>
		The Mana Fountain converts mana in the air into Liquid Mana. <br>
		This is most useful for performing a Mana Baptism on someone so they can absorb mana from leyline passively. <br>
		They also act as a source of Weak Mana Potions.
		</div>
	"}
