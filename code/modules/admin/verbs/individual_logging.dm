/proc/show_individual_logging_panel(client/user, mob/M, source = LOGSRC_CLIENT, type = INDIVIDUAL_ATTACK_LOG)
	if (!M || !ismob(M))
		return

	var/ntype = text2num(type)
	var/dat = ""
	dat += user?.prefs.get_ui_theme_stylesheet()

	if (M.client)
		dat += {"
		<div style='text-align: center;'>
			<h3>Client</h3>
			<div>
				[individual_logging_panel_link(M, INDIVIDUAL_ATTACK_LOG, LOGSRC_CLIENT, "Attack Log", source, ntype)] |
				[individual_logging_panel_link(M, INDIVIDUAL_SAY_LOG, LOGSRC_CLIENT, "Say Log", source, ntype)] |
				[individual_logging_panel_link(M, INDIVIDUAL_EMOTE_LOG, LOGSRC_CLIENT, "Emote Log", source, ntype)] |
				[individual_logging_panel_link(M, INDIVIDUAL_COMMS_LOG, LOGSRC_CLIENT, "Comms Log", source, ntype)] |
				[individual_logging_panel_link(M, INDIVIDUAL_OOC_LOG, LOGSRC_CLIENT, "OOC Log", source, ntype)] |
				[individual_logging_panel_link(M, INDIVIDUAL_LOOC_LOG, LOGSRC_MOB, "LOOC Log", source, ntype)] |
				[individual_logging_panel_link(M, INDIVIDUAL_SHOW_ALL_LOG, LOGSRC_CLIENT, "Show All", source, ntype)]
			</div>
		</div>
			"}
	else
		dat += "<p style='text-align: center; color: red;'>No client attached to mob</p>"

	dat += "<hr style='border-top: 1px solid black;'>"

	dat += {"
	<div style='text-align: center;'>
		<h3>Mob</h3>
		<div>
			[individual_logging_panel_link(M, INDIVIDUAL_ATTACK_LOG, LOGSRC_MOB, "Attack Log", source, ntype)] |
			[individual_logging_panel_link(M, INDIVIDUAL_SAY_LOG, LOGSRC_MOB, "Say Log", source, ntype)] |
			[individual_logging_panel_link(M, INDIVIDUAL_EMOTE_LOG, LOGSRC_MOB, "Emote Log", source, ntype)] |
			[individual_logging_panel_link(M, INDIVIDUAL_COMMS_LOG, LOGSRC_MOB, "Comms Log", source, ntype)] |
			[individual_logging_panel_link(M, INDIVIDUAL_OOC_LOG, LOGSRC_MOB, "OOC Log", source, ntype)] |
			[individual_logging_panel_link(M, INDIVIDUAL_LOOC_LOG, LOGSRC_CLIENT, "LOOC Log", source, ntype)] |
			[individual_logging_panel_link(M, INDIVIDUAL_SHOW_ALL_LOG, LOGSRC_MOB, "Show All", source, ntype)]
		</div>
	</div>
	"}

	dat += "<hr style='border-top: 1px solid black;'>"

	var/log_source = M.logging
	if (source == LOGSRC_CLIENT && M.client)
		log_source = M.client.player_details.logging

	var/list/concatenated_logs = list()
	for (var/log_type in log_source)
		var/nlog_type = text2num(log_type)
		if (nlog_type & ntype)
			var/list/all_the_entrys = log_source[log_type]
			for (var/entry in all_the_entrys)
				concatenated_logs += "<b>[entry]</b><br>[all_the_entrys[entry]]"

	if (length(concatenated_logs))
		sortTim(concatenated_logs, cmp = GLOBAL_PROC_REF(cmp_text_dsc))
		dat += "<div style='font-size: 12px;'>" + concatenated_logs.Join("<br>") + "</div>"

	dat += "</html>"

	usr << browse(dat, "window=individual_logging_[key_name(M)];size=600x480")

/proc/individual_logging_panel_link(mob/M, log_type, log_src, label, selected_src, selected_type)
	var/slabel = label
	if(selected_type == log_type && selected_src == log_src)
		slabel = "<b>\[[label]\]</b>"

	return "<a href='byond://?_src_=holder;[HrefToken()];individuallog=[REF(M)];log_type=[log_type];log_src=[log_src]'>[slabel]</a>"
