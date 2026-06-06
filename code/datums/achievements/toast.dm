#define ACHIEVEMENT_TOAST_HOLD_TIME		3.5 SECONDS
#define ACHIEVEMENT_TOAST_SLIDE_TIME	3
#define ACHIEVEMENT_TOAST_FADE_TIME		5
#define ACHIEVEMENT_TOAST_SLIDE_OFFSET	240

/atom/movable/screen/achievement_toast
	name = "achievement_toast"
	plane = ABOVE_HUD_PLANE
	appearance_flags = KEEP_APART | RESET_ALPHA | RESET_COLOR | RESET_TRANSFORM
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = BACKHUD_LAYER + 0.4

/proc/show_achievement_toast(mob/user, datum/award/achievement/award)
	if(!user?.client)
		return
	var/client/C = user.client
	var/atom/movable/screen/achievement_toast/toast = new()

	var/mutable_appearance/bg = new()
	bg.icon = 'icons/hud/achievement_toast.dmi'
	bg.icon_state = "toast_bg"
	bg.plane = ABOVE_HUD_PLANE
	bg.layer = BACKHUD_LAYER
	toast.add_overlay(bg)

	var/mutable_appearance/border = new()
	border.icon = 'icons/hud/achievement_toast.dmi'
	border.icon_state = "toast_border"
	border.plane = ABOVE_HUD_PLANE
	border.layer = BACKHUD_LAYER + 0.1
	toast.add_overlay(border)

	var/mutable_appearance/achievement_icon = new()
	achievement_icon.icon = 'icons/achievements.dmi'
	achievement_icon.icon_state = award.icon
	achievement_icon.pixel_y = 16
	achievement_icon.pixel_x = 19
	achievement_icon.plane = ABOVE_HUD_PLANE
	achievement_icon.layer = BACKHUD_LAYER + 0.2
	toast.add_overlay(achievement_icon)

	var/mutable_appearance/achievement_icon_frame = new()
	achievement_icon_frame.icon = 'icons/hud/achievement_toast.dmi'
	achievement_icon_frame.icon_state = "toast_frame"
	achievement_icon_frame.plane = ABOVE_HUD_PLANE
	achievement_icon_frame.layer = BACKHUD_LAYER + 0.3
	toast.add_overlay(achievement_icon_frame)

	toast.maptext_width = 118
	toast.maptext_height = 60
	toast.maptext_x = 128
	toast.maptext_y = 32
	toast.maptext = MAPTEXT("<font color='#d4af37'><small>Achievement Unlocked!</small></font><br><b><font color='#f1f5f9'>[award.name]</font></b>")

	if(award.award_flags & AWARD_FLAG_REWARD)
		var/reward_str = award.return_reward_string()
		if(reward_str)
			var/mutable_appearance/reward_text = new()
			reward_text.maptext_width = 118
			reward_text.maptext_height = 16
			reward_text.maptext_x = 128
			reward_text.maptext_y = 10
			reward_text.maptext = MAPTEXT("<font color='#a78bfa'>[reward_str]</font>")
			reward_text.plane = ABOVE_HUD_PLANE
			reward_text.layer = BACKHUD_LAYER + 0.4
			toast.add_overlay(reward_text)
	var/image/holder = image(
		icon = 'icons/effects/effects.dmi',
		icon_state = "nothing",
		loc = user,
		layer = ABOVE_HUD_PLANE
	)
	holder.plane = ABOVE_HUD_PLANE
	holder.appearance_flags = KEEP_APART | RESET_ALPHA | RESET_COLOR | RESET_TRANSFORM
	holder.vis_contents += toast
	toast.pixel_y = -ACHIEVEMENT_TOAST_SLIDE_OFFSET
	toast.pixel_x = -162
	toast.alpha = 0
	C.images += holder
	animate(toast, pixel_y = -180, alpha = 255, time = ACHIEVEMENT_TOAST_SLIDE_TIME, easing = EASE_OUT)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(_achievement_toast_begin_fadeout), toast, holder, C), ACHIEVEMENT_TOAST_HOLD_TIME)

/proc/_achievement_toast_begin_fadeout(atom/movable/screen/achievement_toast/toast, image/holder, client/C)
	if(!C)
		return
	animate(toast, alpha = 0, time = ACHIEVEMENT_TOAST_FADE_TIME, easing = EASE_IN)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(_achievement_toast_cleanup), holder, C), ACHIEVEMENT_TOAST_FADE_TIME * 0.1 SECONDS)

/proc/_achievement_toast_cleanup(image/holder, client/C)
	if(C)
		C.images -= holder

#undef ACHIEVEMENT_TOAST_HOLD_TIME
#undef ACHIEVEMENT_TOAST_SLIDE_TIME
#undef ACHIEVEMENT_TOAST_FADE_TIME
#undef ACHIEVEMENT_TOAST_SLIDE_OFFSET

/client/proc/test_achievement_toast()
	set name = "Test Achievement Toast"
	set category = "Debug"

	var/datum/award/achievement/boss/deep/test_award = new()

	show_achievement_toast(usr, test_award)
	qdel(test_award)
