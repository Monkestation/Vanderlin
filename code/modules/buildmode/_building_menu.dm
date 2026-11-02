
/**
 * Open the item browser with the current category
 */
/datum/buildmode/proc/open_item_browser()
	switch_state = BM_SWITCHSTATE_ITEMS
	if(item_browser)
		item_browser.close()

	var/list/dat = list()
	dat += "<div class='buildmode-browser'>"
	dat += "<h3>BuildMode Item Selection</h3>"

	// Add category tabs
	dat += "<div class='tabs'>"
	dat += "<a class='tab [current_category == BM_CATEGORY_TURF ? "active" : ""]' href='byond://?src=[REF(src)];category=[BM_CATEGORY_TURF]'>Turfs</a>"
	dat += "<a class='tab [current_category == BM_CATEGORY_OBJ ? "active" : ""]' href='byond://?src=[REF(src)];category=[BM_CATEGORY_OBJ]'>Objects</a>"
	dat += "<a class='tab [current_category == BM_CATEGORY_MOB ? "active" : ""]' href='byond://?src=[REF(src)];category=[BM_CATEGORY_MOB]'>Mobs</a>"
	dat += "<a class='tab [current_category == BM_CATEGORY_ITEM ? "active" : ""]' href='byond://?src=[REF(src)];category=[BM_CATEGORY_ITEM]'>Items</a>"
	dat += "<a class='tab [current_category == BM_CATEGORY_WEAPON ? "active" : ""]' href='byond://?src=[REF(src)];category=[BM_CATEGORY_WEAPON]'>Weapons</a>"
	dat += "<a class='tab [current_category == BM_CATEGORY_CLOTHING ? "active" : ""]' href='byond://?src=[REF(src)];category=[BM_CATEGORY_CLOTHING]'>Clothing</a>"
	dat += "<a class='tab [current_category == BM_CATEGORY_FOOD ? "active" : ""]' href='byond://?src=[REF(src)];category=[BM_CATEGORY_FOOD]'>Food</a>"
	dat += "<a class='tab [current_category == BM_CATEGORY_REAGENT_CONTAINERS ? "active" : ""]' href='byond://?src=[REF(src)];category=[BM_CATEGORY_REAGENT_CONTAINERS]'>Liquid Vessels</a>"
	dat += "</div>"

	dat += "<div class='search-container'>"
	dat += "<input type='text' class='search-bar' id='item-search' placeholder='Search items...'>"
	dat += "</div>"

	dat += {"
	<script type='text/javascript'>
	(function setupListeners() {
		if (window.buildmodeScriptLoaded) return;
		window.buildmodeScriptLoaded = true;

		var input = document.getElementById('item-search');
		if (input) {
			input.addEventListener('keyup', function() {
				var filter = input.value.toUpperCase();
				var grid = document.getElementById('item-grid');
				if (!grid) return;

				var items = grid.getElementsByClassName('item');
				for (var i = 0; i < items.length; i++) {
					var itemName = items\[i\].getElementsByClassName('item-name')\[0\];
					var itemPath = items\[i\].getAttribute('data-path') || '';
					if (itemName) {
						if (
							itemName.innerHTML.toUpperCase().indexOf(filter) > -1 ||
							itemPath.toUpperCase().indexOf(filter) > -1
						) {
							items\[i\].style.display = '';
						} else {
							items\[i\].style.display = 'none';
						}
					}
				}
			});
		}

		let shiftWasDown = false;

		function sendTogglePixel(toggled) {
			var a = document.createElement('a');
			a.href='byond://?src=[REF(src)]&toggle_pixel=' + toggled;
			document.body.appendChild(a);
			a.click();
			document.body.removeChild(a);
		}

		document.addEventListener('keydown', function(event) {
			if (event.key === 'Shift' && !shiftWasDown) {
				shiftWasDown = true;
				sendTogglePixel(1);
			}
		});

		document.addEventListener('keyup', function(event) {
			if (event.key === 'Shift') {
				shiftWasDown = false;
				sendTogglePixel(0);
			}
		});
	})();
	</script>
	"}



	dat += "<div class='item-grid' id='item-grid'>"

	switch(current_category)
		if(BM_CATEGORY_TURF)
			dat += generate_turf_list()
		if(BM_CATEGORY_OBJ)
			dat += generate_obj_list()
		if(BM_CATEGORY_MOB)
			dat += generate_mob_list()
		if(BM_CATEGORY_ITEM)
			dat += generate_item_list()
		if(BM_CATEGORY_WEAPON)
			dat += generate_weapon_list()
		if(BM_CATEGORY_CLOTHING)
			dat += generate_clothing_list()
		if(BM_CATEGORY_REAGENT_CONTAINERS)
			dat += generate_reagentcontainer_list()
		if(BM_CATEGORY_FOOD)
			dat += generate_food_list()
		else
			current_category = BM_CATEGORY_TURF
			dat += generate_turf_list()

	dat += "</div>"

	dat += "</div>"

	var/datum/browser/popup = new(holder.mob, "buildmode_browser", "BuildMode Items", 600, 800)
	popup.set_content(dat.Join())
	popup.add_stylesheet("buildmodestyle", 'html/browser/buildmode.css')
	popup.set_window_options("can_close=1;can_minimize=0;can_maximize=0;can_resize=1")
	popup.open()

	item_browser = popup

/**
 * Close the item browser
 */
/datum/buildmode/proc/close_item_browser()
	switch_state = BM_SWITCHSTATE_NONE
	if(item_browser)
		item_browser.close()
		item_browser = null

/**
 * Handle Topic calls from the item browser
 *
 * @param {datum} href_list - The href list from the browser
 */
/datum/buildmode/Topic(href, href_list)
	if(!holder || !holder.mob || QDELETED(holder.mob))
		return

	if(href_list["category"])
		var/new_category = text2num(href_list["category"])
		if(new_category)
			change_category(new_category)
			return TRUE

	if(href_list["item"])
		var/path = text2path(href_list["item"])
		if(ispath(path))
			select_item(path)
			return TRUE

	if(href_list["toggle_pixel"])
		var/toggled = text2num(href_list["toggle_pixel"])
		toggle_pixel_positioning_mode(toggled)
		return TRUE

	return FALSE

/**
 * Select an item to build with
 *
 * @param {path} item_path - The path of the item to select
 */
/datum/buildmode/proc/select_item(item_path)
	if(!ispath(item_path))
		return
	selected_item = item_path
	create_preview_appearance(item_path)

	var/name_to_show = ""
	if(ispath(item_path, /turf))
		var/turf/T = item_path
		name_to_show = initial(T.name)
	else if(ispath(item_path, /obj))
		var/obj/O = item_path
		name_to_show = initial(O.name)
	else if(ispath(item_path, /mob))
		var/mob/M = item_path
		name_to_show = initial(M.name)

	to_chat(holder.mob, "<span class='notice'>Selected [name_to_show] for building.</span>")
