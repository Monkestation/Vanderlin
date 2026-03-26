/proc/browser_input_list(mob/user, message, title = "VANDERLIN", list/items, default, timeout = 0)
	if(!user)
		user = usr
	if(!length(items))
		return null
	if(!istype(user))
		if(isclient(user))
			var/client/client = user
			user = client.mob
		else
			return null

	if(isnull(user.client))
		return null

	var/datum/browser/modal/input_list/input = new(user, message, html_tag("center", title), items, default, timeout)
	input.open()
	input.wait()
	if(input)
		. = input.choice
		qdel(input)

/datum/browser/modal/input_list
	var/list/results = list()

/datum/browser/modal/input_list/New(mob/user, message, title, list/items, default, timeout = 0)
	if(!user)
		closed = TRUE
		return

	if(!length(items))
		closed = TRUE
		return

	if(isnull(default))
		default = items[1]

	set_head_content({"
		<style>
			form {
				display: flex;
				flex-direction: column;
			}

			form * {
				user-select: none;
				-ms-user-select: none;
			}

			label {
				display: block;
				width: 100%;
			}

			label:hover {
				background-color: ["#131212"];
			}
			[NULLABLE(text2num(user.client.player_details.byond_version) >= 516) && @{"
				input[type='radio']{
					display: none;
				}

				label:has(input[type='radio']:checked) {
					background-color: #251919;
				}

			"}]

			.input_list_options {
				flex-grow: 1;
				padding: 4px;
				margin: 0.25em 0;
				border: 1px solid ["#7b5353"];
				overflow-y: auto;
			}
		</style>

		<script type="text/javascript">
			document.addEventListener("DOMContentLoaded", function(){
				const optionsList = document.querySelector("#options");

				const searchBar = document.querySelector("input\[type='text']");
				if(searchBar !== null){
					searchBar.addEventListener("input", function(event){
						const term = event.target.value.toLowerCase();

						const options = optionsList.getElementsByTagName("label");
						let tabI = 0;
						for(let i = 0; i < options.length; i++){
							const label = options\[i];
							console.log(label);
							const child = label.querySelector("input");
							const found = (!term || (child.value.toLowerCase().indexOf(term) !== -1));
							if(found){
								console.log("has");
								label.style.display = "";
								child.disabled = false;
							}
							else {
								console.log("does not have");
								label.style.display = "none";
								child.disabled = true;
							}
						}
					})
				}

				addEventListener("keydown", function(event){
					switch(event.which){
						case 38: [/* UP */]
						case 40: [/* DOWN */]
							event.preventDefault();

							const activeRadios = optionsList.querySelectorAll("input:not(\[disabled])");
							const currentRadio = optionsList.querySelector("input:checked") || activeRadios\[0];
							if(!currentRadio) {return;}

							const currentRadioIndex = Array.prototype.indexOf.call(activeRadios, currentRadio);
							let desiredRadioIndex = (currentRadioIndex + ((event.which === 38) ? -1 : 1));
							[/* modulo does not work for negative numbers */]
							if(desiredRadioIndex >= activeRadios.length){
								desiredRadioIndex = 0;
							}
							else if(desiredRadioIndex <= -1){
								desiredRadioIndex = activeRadios.length-1;
							}

							console.log(desiredRadioIndex);
							const desiredRadio = activeRadios\[desiredRadioIndex];
							desiredRadio.click();
							desiredRadio.scrollIntoView(false);

							break;
					}
				})
			})
		</script>
	"})

	// Gets rid of illegal characters (thank you Lemon)
	var/static/regex/whitelistedWords = regex(@{"([^\u0020-\u8000]+)"})
	var/list/choices = list()
	for(var/item in items)
		if(!item)
			continue
		var/form_key = whitelistedWords.Replace("[item]", "")
		results[form_key] = item
		choices += {"
			<label>
				<input type='radio' name='choice' value='[html_encode(form_key)]' required [NULLABLE("[default]" == "[item]") && "checked"] />
				[item]
			</label>"}

	..(user, ckey("[user]-[message]-[title]-[world.time]-[rand(1,10000)]"), title, 350, 350, src, TRUE, timeout)
	set_content({"
	<form style="width: 100%; height: 100%;" action="byond://">
		<input type="hidden" name="src" value="[REF(src)]">

		<center><b>[message]</b></center>
		<div id="options" class="input_list_options">[choices.Join("\n")]
		</div>

		[NULLABLE(length(choices) > 9) && \
		"<input style='margin: 0.25em 0; z-index: 5' id='searchbar' type='text' placeholder='Find...' autofocus/>"]
		<div style="display: flex; margin-top: auto; justify-content: space-between; text-align: center;">
			<button type="submit" name="submit" value="[TRUE]">[CHOICE_CONFIRM]</button>
			<button type="submit" name="cancel" value="[TRUE]" formnovalidate>[CHOICE_CANCEL]</button>
		</div>
	</form>"})

/datum/browser/modal/input_list/Topic(href, href_list)
	. = ..()
	if(href_list["submit"])
		set_choice(href_list["choice"])

	closed = TRUE
	close()

/datum/browser/modal/input_list/set_choice(choice)
	if(!(choice in results))
		CRASH("user gave impossible response [choice]")

	src.choice = results[choice]

/*-----------------------*/

/datum/browser/modal/listpicker
	var/list/valueslist = list()

/datum/browser/modal/listpicker/New(User,Message,Title,Button1="Ok",Button2,Button3,StealFocus = 1, Timeout = FALSE,list/values,inputtype="checkbox", width, height, slidecolor)
	if (!User)
		return

	var/output =  {"<form><input type="hidden" name="src" value="[REF(src)]"><ul class="sparse">"}
	if (inputtype == "checkbox" || inputtype == "radio")
		for (var/i in values)
			var/div_slider = slidecolor
			if(!i["allowed_edit"])
				div_slider = "locked"
			output += {"<li>
						<div style='width: 100%'>
						<label class="switch">
							<input type="[inputtype]" value="1" name="[i["name"]]"[i["checked"] ? " checked" : ""][i["allowed_edit"] ? "" : " onclick='return false' onkeydown='return false'"]>
								<div class="slider [div_slider ? "[div_slider]" : ""]"></div>
						</label>
						<span>[i["name"]]</span>
						</div>
						</li>"}
	else
		for (var/i in values)
			output += {"<li><input id="name="[i["name"]]"" style="width: 50px" type="[type]" name="[i["name"]]" value="[i["value"]]">
			<label for="[i["name"]]">[i["name"]]</label></li>"}
	output += {"</ul><div style="text-align:center">
		<button type="submit" name="button" value="1" style="font-size:large;float:[( Button2 ? "left" : "right" )]">[Button1]</button>"}

	if (Button2)
		output += {"<button type="submit" name="button" value="2" style="font-size:large;[( Button3 ? "" : "float:right" )]">[Button2]</button>"}

	if (Button3)
		output += {"<button type="submit" name="button" value="3" style="font-size:large;float:right">[Button3]</button>"}

	output += {"</form></div>"}
	..(User, ckey("[User]-[Message]-[Title]-[world.time]-[rand(1,10000)]"), Title, width, height, src, StealFocus, Timeout)
	set_content(output)

/datum/browser/modal/listpicker/Topic(href,href_list)
	if (href_list["close"] || !user || !user.client)
		closed = TRUE
		return
	if (href_list["button"])
		var/button = text2num(href_list["button"])
		if (button <= 3 && button >= 1)
			choice = button
	for (var/item in href_list)
		switch(item)
			if ("close", "button", "src")
				continue
			else
				valueslist[item] = href_list[item]
	closed = TRUE
	close()

/proc/presentpicker(mob/User,Message, Title, Button1="Ok", Button2, Button3, StealFocus = 1,Timeout = 6000,list/values, inputtype = "checkbox", width, height, slidecolor)
	if (!istype(User))
		if (istype(User, /client/))
			var/client/C = User
			User = C.mob
		else
			return
	var/datum/browser/modal/listpicker/A = new(User, Message, Title, Button1, Button2, Button3, StealFocus,Timeout, values, inputtype, width, height, slidecolor)
	A.open()
	A.wait()
	if(A.choice)
		return list("button" = A.choice, "values" = A.valueslist)

/proc/input_bitfield(mob/User, title, bitfield, current_value, nwidth = 350, nheight = 350, nslidecolor, allowed_edit_list = null)
	if (!User || !(bitfield in GLOB.bitfields))
		return
	var/list/pickerlist = list()
	for (var/i in GLOB.bitfields[bitfield])
		var/can_edit = 1
		if(!isnull(allowed_edit_list) && !(allowed_edit_list & GLOB.bitfields[bitfield][i]))
			can_edit = 0
		if (current_value & GLOB.bitfields[bitfield][i])
			pickerlist += list(list("checked" = 1, "value" = GLOB.bitfields[bitfield][i], "name" = i, "allowed_edit" = can_edit))
		else
			pickerlist += list(list("checked" = 0, "value" = GLOB.bitfields[bitfield][i], "name" = i, "allowed_edit" = can_edit))
	var/list/result = presentpicker(User, "", title, Button1="Save", Button2 = "Cancel", Timeout=FALSE, values = pickerlist, width = nwidth, height = nheight, slidecolor = nslidecolor)
	if (islist(result))
		if (result["button"] == 2) // If the user pressed the cancel button
			return
		. = 0
		for (var/flag in result["values"])
			. |= GLOB.bitfields[bitfield][flag]
	else
		return
