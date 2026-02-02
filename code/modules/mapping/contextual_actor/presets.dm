/obj/effect/contextual_actor/preset
	var/text_to_replace_with = "nothing."

/obj/effect/contextual_actor/preset/Initialize(mapload)
	. = ..()
	if(!islist(text_to_replace_with))
		text_to_replace_with = list(text_to_replace_with)
	for(var/html_num in 1 to length(raw_html_to_pick_from))
		raw_html_to_pick_from[html_num] = replacetext(raw_html_to_pick_from[html_num], "%TEXT_TO_REPLACE_WITH", pick(text_to_replace_with))

/obj/effect/contextual_actor/preset/flickering
	raw_html_to_pick_from = \
	"\
	<style>\
		.scary-text {\
			font-size: 20px;\
			text-shadow: 0 0 10px red;\
			color: darkred;\
			animation: flicker 0.5s infinite alternate;\
			white-space: pre;\
			text-align: center;\
		}\
		\
		@keyframes flicker {\
			0% { opacity: 0.8; }\
			100% { opacity: 1; }\
		}\
	</style>\
	<div class=\"scary-text\">\
		%TEXT_TO_REPLACE_WITH\
	</div>\
	"

	/// text to replace with in the raw htmls, where %TEXT_TO_REPLACE_WITH is
	text_to_replace_with = "\
	YOU LOOK AROUND<br>\
	YOU ARE SURROUNDED BY GOBLINS!\
	"

/obj/effect/contextual_actor/preset/other
	raw_html_to_pick_from = \
	"\
	<style>\
		\
		.scary-text {\
			background-color: #111;\
			color: #8B0000;\
			font-size: 28px;\
			text-shadow: 1px 1px 3px #300000;\
			animation: pulse 3s infinite alternate;\
			white-space: pre;\
			letter-spacing: 1px;\
			padding: 40px;\
			border: 1px solid #400000;\
			background-color: rgba(20, 10, 5, 0.7);\
			line-height: 1.5;\
			text-align: center;\
		}\
		\
		@keyframes pulse {\
		0% { opacity: 0.8; text-shadow: 0 0 5px #FF0000; }\
		100% { opacity: 1; text-shadow: 0 0 15px #FF0000, 0 0 20px #800000; }\
		}\
	</style>\
	<div class=\"scary-text\">\
		%TEXT_TO_REPLACE_WITH\
	</div>\
	"
