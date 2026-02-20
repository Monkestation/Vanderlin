/obj/structure/bounty_board
	name = "bounty board"
	desc = "A weathered wooden board covered in various contracts and notices. Dark stains suggest not all jobs end well."
	icon = 'icons/obj/bounty_board.dmi'
	icon_state = "bounty_board"
	anchored = TRUE
	density = FALSE
	SET_BASE_PIXEL(0, 32)
	var/list/active_contracts = list()
	var/list/completed_contracts = list()
	var/total_bounty_pool = 0
	var/last_harlequin_spawn = 0
	COOLDOWN_DECLARE(bounty_marker)

/obj/structure/bounty_board/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!COOLDOWN_FINISHED(src, bounty_marker))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	COOLDOWN_START(src, bounty_marker, 30 SECONDS)
	new /obj/item/bounty_marker(get_turf(src))
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/bounty_board/Initialize()
	. = ..()
	LAZYADD(GLOB.bounty_boards, src)

/obj/structure/bounty_board/Destroy()
	LAZYREMOVE(GLOB.bounty_boards, src)
	for(var/datum/bounty_contract/contract as anything in (active_contracts + completed_contracts))
		qdel(contract)
	active_contracts = null
	completed_contracts = null
	return ..()

/obj/structure/bounty_board/proc/check_harlequin_injection()
	var/mammons_since_last = total_bounty_pool - last_harlequin_spawn
	if(prob(mammons_since_last * 0.1))
		SSmigrants.set_current_wave(/datum/migrant_wave/harlequinn, 1 MINUTES)
		last_harlequin_spawn = total_bounty_pool

/obj/structure/bounty_board/proc/get_reputation(mob/user)
	if(!user.ckey)
		return 0
	return GLOB.bounty_rep[user.ckey] || 0

/obj/structure/bounty_board/proc/modify_reputation(mob/user, amount)
	if(!user.ckey)
		return
	var/current = get_reputation(user)
	GLOB.bounty_rep[user.ckey] = current + amount

	var/new_rep = GLOB.bounty_rep[user.ckey]
	var/rep_text = get_reputation_text(new_rep)
	to_chat(user, span_notice("Your reputation has [amount > 0 ? "increased" : "decreased"] to [new_rep] ([rep_text])"))

/obj/structure/bounty_board/proc/get_reputation_text(rep_value)
	switch(rep_value)
		if(-INFINITY to -50)
			return "Pariah"
		if(-49 to -20)
			return "Untrustworthy"
		if(-19 to -5)
			return "Questionable"
		if(-4 to 4)
			return "Unknown"
		if(5 to 19)
			return "Reliable"
		if(20 to 49)
			return "Respected"
		if(50 to INFINITY)
			return "Legendary"

/obj/structure/bounty_board/interact(mob/user)
	var/html = get_bounty_board_html(user)
	user << browse(html, "window=bounty_board;size=900x700;titlebar=1;can_minimize=1;can_resize=1")
	onclose(user, "bounty_board")

/obj/structure/bounty_board/proc/get_bounty_board_html(mob/user)
	var/is_bountyhunter = is_bounty_hunter(user)
	var/location_options = ""
	var/contraband_options = ""
	var/contract_types = ""

	for(var/obj/effect/landmark/bounty_location/loc as anything in GLOB.bounty_locations)
		location_options += "<option value=\"[loc.location_name]\">[loc.location_name]</option>"

	for(var/pack_name in GLOB.contraband_packs)
		contraband_options += "<option value=\"[pack_name]\">[pack_name]</option>"

	for(var/contract_type in GLOB.bounty_contract_types)
		contract_types += "<option value=\"[contract_type]\">[GLOB.bounty_contract_types[contract_type]]</option>"

	user << browse_rsc('html/book.png')
	user << browse_rsc('html/tiled_wood.jpg')
	var/html = {"
<!DOCTYPE html>
<html>
<head>
	<title>Bounty Board</title>
	<style>
		@import url('https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700&family=Cinzel+Decorative:wght@700&display=swap');

		* {
			margin: 0;
			padding: 0;
			box-sizing: border-box;
		}

		body {
			background: linear-gradient(135deg, #2d1810 0%, #1a0e08 100%);
			color: #d4c4a0;
			font-family: 'Cinzel', serif;
			height: 100vh;
			overflow: hidden;
		}

		.container {
			width: 100vw;
			height: 100vh;
			display: flex;
			flex-direction: column;
		}

		.board-frame {
			background: url('tiled_wood.jpg'); background-repeat: repeat;
			border: 6px solid #5d4e37;
			border-radius: 12px;
			margin: 8px;
			padding: 20px;
			box-shadow: inset 0 0 15px rgba(0,0,0,0.5), 0 8px 25px rgba(0,0,0,0.8);
			position: relative;
			flex: 1;
			display: flex;
			flex-direction: column;
			min-height: 0;
		}

		.header {
			text-align: center;
			margin-bottom: 15px;
			flex-shrink: 0;
		}

		.title {
			font-family: 'Cinzel Decorative', serif;
			color: #ffd700;
			font-size: 2.5em;
			margin: 0;
			text-shadow: 2px 2px 4px rgba(0,0,0,0.8);
			letter-spacing: 2px;
		}

		.subtitle {
			color: #d4c4a0;
			font-style: italic;
			margin: 5px 0;
			font-size: 1em;
		}

		.main-content {
			display: flex;
			flex: 1;
			min-height: 0;
			gap: 20px;
		}

		.contracts-section {
			flex: 1;
			display: flex;
			flex-direction: column;
			min-height: 0;
		}

		.section-header {
			display: flex;
			justify-content: space-between;
			align-items: center;
			margin-bottom: 15px;
			flex-shrink: 0;
		}

		.section-title {
			color: #ffd700;
			margin: 0;
			font-size: 1.6em;
			font-weight: 600;
			text-shadow: 2px 2px 4px rgba(0,0,0,0.6);
		}

		.btn {
			background: linear-gradient(145deg, #8B4513 0%, #654321 100%);
			color: #ffd700;
			border: 2px solid #5d4e37;
			padding: 10px 20px;
			border-radius: 6px;
			cursor: pointer;
			font-family: 'Cinzel', serif;
			font-weight: 600;
			text-transform: uppercase;
			letter-spacing: 1px;
			transition: all 0.3s ease;
			box-shadow: 0 3px 6px rgba(0,0,0,0.3);
			font-size: 0.9em;
		}

		.btn:hover {
			background: linear-gradient(145deg, #a0522d 0%, #8B4513 100%);
			transform: translateY(-1px);
			box-shadow: 0 4px 8px rgba(0,0,0,0.4);
		}

		.btn-small {
			padding: 6px 12px;
			font-size: 0.75em;
		}

		.btn-accept { background: linear-gradient(145deg, #228B22 0%, #006400 100%); }
		.btn-accept:hover { background: linear-gradient(145deg, #32CD32 0%, #228B22 100%); }

		.btn-verify { background: linear-gradient(145deg, #4169E1 0%, #0000CD 100%); }
		.btn-verify:hover { background: linear-gradient(145deg, #6495ED 0%, #4169E1 100%); }

		.btn-reject { background: linear-gradient(145deg, #DC143C 0%, #8B0000 100%); }
		.btn-reject:hover { background: linear-gradient(145deg, #FF6347 0%, #DC143C 100%); }

		#contracts-list {
			flex: 1;
			overflow-y: auto;
			padding-right: 10px;
			display: grid;
			grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
			gap: 15px;
			align-content: start;
		}

		#contracts-list::-webkit-scrollbar {
			width: 10px;
		}

		#contracts-list::-webkit-scrollbar-track {
			background: rgba(139, 69, 19, 0.2);
			border-radius: 5px;
		}

		#marker-target-group small {
			display: block;
			margin-top: 5px;
			font-size: 0.8em;
			color: #888;
			font-style: italic;
		}

		#contracts-list::-webkit-scrollbar-thumb {
			background: linear-gradient(145deg, #8B4513, #654321);
			border-radius: 5px;
		}

		.bounty-note {
			background: url('book.png');
			border: 2px solid #1a0e08;
			border-radius: 0;
			padding: 20px 18px 15px 18px;
			color: #8b7355;
			box-shadow:
				0 6px 12px rgba(0,0,0,0.8),
				inset 0 1px 0 rgba(93,78,55,0.15),
				inset 0 -2px 0 rgba(0,0,0,0.4);
			position: relative;
			height: fit-content;
			transition: all 0.3s ease;
			cursor: pointer;
			margin: 8px;
			/* Torn paper effect */
			clip-path: polygon(
				0% 8px, 15px 0%, 25px 12px, 40px 0%, 55px 16px, 70px 0%, 85px 10px, 100% 0%,
				100% calc(100% - 15px), calc(100% - 12px) 100%, calc(100% - 28px) calc(100% - 8px),
				calc(100% - 45px) 100%, calc(100% - 62px) calc(100% - 12px), calc(100% - 78px) 100%,
				calc(100% - 90px) calc(100% - 6px), 8px 100%, 0% calc(100% - 20px)
			);
		}

		.bounty-note:hover {
			transform: scale(1.02) rotate(0deg) !important;
			z-index: 10;
			box-shadow:
				0 10px 20px rgba(0,0,0,0.9),
				inset 0 1px 0 rgba(93,78,55,0.2),
				inset 0 -2px 0 rgba(0,0,0,0.6);
		}

		/* Multiple nail types for variety */
		.note-nail {
			position: absolute;
			width: 12px;
			height: 12px;
			background: radial-gradient(circle at 30% 30%, #2d1810 0%, #1a0e08 50%, #0d0603 100%);
			border-radius: 50%;
			box-shadow:
				inset 0 2px 3px rgba(0,0,0,0.9),
				inset 0 -1px 1px rgba(45,32,16,0.1),
				0 2px 4px rgba(0,0,0,0.7);
			top: 12px;
			left: 50%;
			transform: translateX(-50%);
			z-index: 5;
			border: 1px solid #0d0603;
		}

		/* Add secondary nails for more authentic look */
		.bounty-note::before {
			content: '';
			position: absolute;
			width: 8px;
			height: 8px;
			background: radial-gradient(circle at 30% 30%, #1a0e08 0%, #0d0603 50%, #000000 100%);
			border-radius: 50%;
			box-shadow:
				inset 0 1px 2px rgba(0,0,0,0.9),
				inset 0 -1px 1px rgba(26,14,8,0.05),
				0 2px 3px rgba(0,0,0,0.8);
			top: 8px;
			right: 15px;
			z-index: 5;
		}

		.bounty-note::after {
			content: '';
			position: absolute;
			width: 6px;
			height: 6px;
			background: radial-gradient(circle at 30% 30%, #0d0603 0%, #000000 100%);
			border-radius: 50%;
			box-shadow:
				inset 0 1px 1px rgba(0,0,0,0.95),
				0 2px 2px rgba(0,0,0,0.8);
			bottom: 12px;
			left: 20px;
			z-index: 5;
		}

		/* Enhanced torn edges with more realistic tears */
		.bounty-note:nth-child(odd) {
			clip-path: polygon(
				0% 12px, 18px 0%, 32px 15px, 48px 0%, 62px 20px, 78px 0%, 92% 8px, 100% 0%,
				100% calc(100% - 10px), calc(100% - 15px) 100%, calc(100% - 30px) calc(100% - 12px),
				calc(100% - 48px) 100%, calc(100% - 65px) calc(100% - 18px), calc(100% - 80px) 100%,
				10px 100%, 0% calc(100% - 25px)
			);
		}

		.bounty-note:nth-child(even) {
			clip-path: polygon(
				0% 6px, 12px 0%, 28px 18px, 44px 0%, 58px 14px, 74px 0%, 88% 22px, 100% 0%,
				100% calc(100% - 16px), calc(100% - 20px) 100%, calc(100% - 35px) calc(100% - 10px),
				calc(100% - 52px) 100%, calc(100% - 70px) calc(100% - 14px), calc(100% - 85px) 100%,
				6px 100%, 0% calc(100% - 12px)
			);
		}

		/* Additional weathering for every third note */
		.bounty-note:nth-child(3n) {
			/* Heavily torn edge */
			clip-path: polygon(
				0% 20px, 25px 0%, 45px 25px, 65px 0%, 85% 15px, 100% 0%,
				100% calc(100% - 25px), calc(100% - 25px) 100%, calc(100% - 50px) calc(100% - 15px),
				calc(100% - 75px) 100%, 15px 100%, 0% calc(100% - 30px)
			);
		}

		/* Skull icons positioning adjustments for torn layout */
		.contract-type {
			background: linear-gradient(145deg, #4a0000 0%, #660000 100%);
			color: #cc9900;
			padding: 3px 8px;
			border-radius: 8px;
			font-size: 0.7em;
			text-transform: uppercase;
			font-weight: bold;
			letter-spacing: 1px;
			border: 1px solid #1a0e08;
			position: relative;
			z-index: 10;
			box-shadow: 0 2px 4px rgba(0,0,0,0.8);
		}

		/* Enhance the scratched out effect for more realism */
		.scratched-out {
			filter: blur(2px) brightness(0.4) contrast(1.2);
			user-select: none;
			pointer-events: none;
		}

		.scratched-out::before {
			content: "";
			position: absolute;
			top: 0;
			left: 0;
			right: 0;
			bottom: 0;
			background:
				repeating-linear-gradient(
					-15deg,
					transparent,
					transparent 2px,
					rgba(0, 0, 0, 0.8) 2px,
					rgba(0, 0, 0, 0.8) 4px
				),
				repeating-linear-gradient(
					45deg,
					transparent,
					transparent 3px,
					rgba(26, 14, 8, 0.9) 3px,
					rgba(26, 14, 8, 0.9) 5px
				);
			pointer-events: none;
			z-index: 20;
		}

		.bounty-note:hover {
			transform: scale(1.02) rotate(0deg) !important;
			z-index: 10;
			box-shadow:
				0 8px 16px rgba(0,0,0,0.5),
				inset 0 1px 0 rgba(255,255,255,0.4),
				inset 0 -1px 0 rgba(0,0,0,0.15);
		}
		.contract-header {
			display: flex;
			justify-content: space-between;
			align-items: center;
			margin-bottom: 10px;
		}

		.contract-payment {
			font-size: 1.1em;
			font-weight: bold;
			color: #8B4513;
		}

		.contract-target {
			font-size: 1em;
			font-weight: bold;
			margin-bottom: 8px;
			color: #5d4e37;
		}

		.contract-details {
			color: #6b5b47;
			margin-bottom: 8px;
			line-height: 1.4;
			font-size: 0.85em;
		}

		.contract-instructions {
			background: rgba(139, 69, 19, 0.1);
			border-left: 3px solid #8B4513;
			padding: 8px;
			margin: 10px 0;
			font-style: italic;
			border-radius: 0 3px 3px 0;
			font-size: 0.85em;
		}

		.contract-footer {
			display: flex;
			justify-content: space-between;
			align-items: center;
			margin-top: 10px;
			font-size: 0.85em;
		}

		.contract-actions {
			display: flex;
			gap: 6px;
			margin-top: 10px;
			flex-wrap: wrap;
		}

		.status-available { color: #228B22; font-weight: bold; }
		.status-progress { color: #FF8C00; font-weight: bold; }
		.status-completed { color: #4169E1; font-weight: bold; }
		.status-failed { color: #DC143C; font-weight: bold; }
		.status-pending { color: #8B4513; font-weight: bold; }

		.time-remaining {
			color: #8B4513;
			font-style: italic;
		}

		.scratched-out {
			filter: blur(2px) brightness(0.6);
			user-select: none;
			pointer-events: none;
		}

		.scratched-out::before {
			content: "██████████████████████████████████████████████";
			white-space: pre-wrap;
			color: #3e2723;
			text-decoration: line-through;
			position: absolute;
			top: 0; left: 0;
			width: 100%;
			height: 100%;
			background: repeating-linear-gradient(
				-45deg,
				transparent,
				transparent 2px,
				rgba(0,0,0,0.1) 2px,
				rgba(0,0,0,0.1) 4px
			);
			pointer-events: none;
		}

		.waiting-indicator {
			background: rgba(255, 140, 0, 0.2);
			border-left: 3px solid #FF8C00;
			padding: 8px;
			border-radius: 0 3px 3px 0;
			margin: 10px 0;
			color: #8B4513;
			font-size: 0.85em;
		}

		.contraband-spawned {
			background: rgba(34, 139, 34, 0.2);
			border-left: 3px solid #228B22;
			padding: 8px;
			border-radius: 0 3px 3px 0;
			margin: 10px 0;
			color: #228B22;
			font-size: 0.85em;
		}

		.no-contracts {
			grid-column: 1 / -1;
			text-align: center;
			color: #8B4513;
			padding: 60px;
			font-size: 1.2em;
			font-style: italic;
		}

		/* Form Overlay */
		.form-overlay {
			position: fixed;
			top: 0;
			right: -400px;
			width: 400px;
			height: 100vh;
			background: linear-gradient(145deg, #8B4513 0%, #654321 50%, #3e2723 100%);
			border-left: 6px solid #5d4e37;
			box-shadow: -8px 0 25px rgba(0,0,0,0.8);
			transition: right 0.4s ease;
			z-index: 1000;
			display: flex;
			flex-direction: column;
		}

		.form-overlay.active {
			right: 0;
		}

		.form-header {
			background: linear-gradient(135deg, #f4e4bc 0%, #e6d7b8 100%);
			color: #3e2723;
			padding: 20px;
			border-bottom: 3px solid #8B4513;
			flex-shrink: 0;
		}

		.form-title {
			font-family: 'Cinzel Decorative', serif;
			font-size: 1.5em;
			margin: 0;
			text-align: center;
			color: #5d4e37;
		}

		.form-content {
			flex: 1;
			overflow-y: auto;
			padding: 20px;
		}

		.form-content::-webkit-scrollbar {
			width: 8px;
		}

		.form-content::-webkit-scrollbar-track {
			background: rgba(139, 69, 19, 0.2);
			border-radius: 4px;
		}

		.form-content::-webkit-scrollbar-thumb {
			background: linear-gradient(145deg, #8B4513, #654321);
			border-radius: 4px;
		}

		.parchment-form {
			background: linear-gradient(135deg, #f4e4bc 0%, #e6d7b8 100%);
			border: 3px solid #8B4513;
			border-radius: 8px;
			padding: 20px;
			color: #3e2723;
			box-shadow: 0 6px 12px rgba(0,0,0,0.3);
		}

		.form-group {
			margin-bottom: 15px;
		}

		.form-label {
			display: block;
			margin-bottom: 6px;
			color: #5d4e37;
			font-weight: 600;
			text-transform: uppercase;
			letter-spacing: 1px;
			font-size: 0.85em;
		}

		.form-input, .form-select, .form-textarea {
			width: 100%;
			padding: 10px;
			background: rgba(255, 255, 255, 0.9);
			border: 2px solid #8B4513;
			border-radius: 6px;
			color: #3e2723;
			font-family: 'Cinzel', serif;
			font-size: 0.9em;
			box-sizing: border-box;
		}

		.form-input:focus, .form-select:focus, .form-textarea:focus {
			outline: none;
			border-color: #ffd700;
			box-shadow: 0 0 8px rgba(255, 215, 0, 0.4);
		}

		.form-textarea {
			resize: vertical;
			min-height: 80px;
		}

		.hidden {
			display: none;
		}

		.nail {
			position: absolute;
			width: 12px;
			height: 12px;
			background: radial-gradient(circle, #654321 0%, #3e2723 100%);
			border-radius: 50%;
			box-shadow: inset 0 2px 4px rgba(0,0,0,0.5);
		}

		.nail-1 { top: 20px; left: 20px; }
		.nail-2 { top: 20px; right: 20px; }
		.nail-3 { bottom: 20px; left: 20px; }
		.nail-4 { bottom: 20px; right: 20px; }

		/* Background overlay when form is open */
		.overlay-backdrop {
			position: fixed;
			top: 0;
			left: 0;
			width: 100vw;
			height: 100vh;
			background: rgba(0,0,0,0.5);
			opacity: 0;
			visibility: hidden;
			transition: all 0.3s ease;
			z-index: 999;
		}

		.overlay-backdrop.active {
			opacity: 1;
			visibility: visible;
		}

		@media (max-width: 1200px) {
			#contracts-list {
				grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
			}
		}

		@media (max-width: 768px) {
			.form-overlay {
				width: 100vw;
				right: -100vw;
			}

			#contracts-list {
				grid-template-columns: 1fr;
			}
		}
	</style>
</head>
<body>
	<div class="overlay-backdrop" id="overlay-backdrop" onclick="toggleCreateForm()"></div>

	<div class="container">
		<div class="board-frame">
			<div class="nail nail-1"></div>
			<div class="nail nail-2"></div>
			<div class="nail nail-3"></div>
			<div class="nail nail-4"></div>

			<div class="header">
				<h1 class="title">The Bounty Board</h1>
				<p class="subtitle">Guild of Shadows & Fortune</p>
			</div>

			<div class="main-content">
				<div class="contracts-section">
					<div class="section-header">
						<h2 class="section-title">Posted Bounties</h2>
						<button class="btn" onclick="toggleCreateForm()">Post Bounty</button>
					</div>

					<div id="contracts-list">
"}

	if(active_contracts.len == 0)
		html += {"
						<div class="no-contracts">
							<p>No bounties currently posted</p>
							<p>Be the first to seek the guilds aid...</p>
						</div>
		"}
	else
		for(var/datum/bounty_contract/contract in active_contracts)
			var/time_remaining = max(0, (contract.creation_time + contract.time_limit - world.time) / 10)
			var/minutes = round(time_remaining / 60)
			var/status_class = "status-available"
			var/status_text = "AVAILABLE"
			var/can_accept = FALSE
			var/can_complete = FALSE
			var/can_verify = FALSE
			var/is_contractor = (user.real_name == contract.contractor_name)

			if(contract.completed)
				status_class = "status-completed"
				status_text = "COMPLETED"
			else if(contract.failed)
				status_class = "status-failed"
				status_text = "FAILED"
			else if(contract.pending_verification)
				status_class = "status-pending"
				status_text = "PENDING"
				if(is_contractor)
					can_verify = TRUE
			else if(contract.assigned_to_harlequinn)
				status_class = "status-progress"
				status_text = "IN PROGRESS"
				if(contract.harlequinn_ckey == user.ckey)
					can_complete = TRUE
			else if(is_bountyhunter && !is_contractor)
				can_accept = TRUE

			var/should_obscure = !is_contractor && !is_bountyhunter
			var/obscure_class = should_obscure ? "scratched-out" : ""
			var/click_handler = (can_accept ? "onclick=\"acceptContract('[contract.contract_id]')\"" : "")
			var/requires_location = (contract.contract_type in list("kidnapping", "smuggling", "burial"))

			html += {"<div class=\"bounty-note [obscure_class]\" [click_handler]>"}
			html += {"<div class=\"note-nail\"></div>"}
			html += {"
							<div class="contract-header">
								<span class="contract-type">[contract.contract_type]</span>
								<span class="contract-payment">[contract.payment] Mammons</span>
							</div>
							<div class="contract-target">Target: [contract.target_name]</div>
							<div class="contract-details">
								By: [should_obscure ? "???" : contract.contractor_name]<br>
								Time: [minutes]m remaining
							</div>
			"}

			if(contract.special_instructions)
				html += {"
							<div class="contract-instructions">
								<strong>Instructions:</strong> [contract.special_instructions]
							</div>
				"}

			if(requires_location && contract.delivery_location)
				html += {"
							<div class="contract-instructions">
								<strong>Location:</strong> [contract.delivery_location]
							</div>
				"}

			if(contract.contract_type == "smuggling" && contract.contraband_type)
				html += {"
							<div class="contract-instructions">
								<strong>Contraband:</strong> [contract.contraband_type]
							</div>
				"}

			if(requires_location && contract.waiting_for_area_completion)
				html += {"
							<div class="waiting-indicator">
								Awaiting completion at [contract.delivery_location]...
							</div>
				"}

			if(contract.contraband_spawned && !contract.completed)
				html += {"
							<div class="contraband-spawned">
								Goods ready at [contract.spawn_location]
							</div>
				"}

			html += {"
							<div class="contract-footer">
								<span class="[status_class]">[status_text]</span>
								<span class="time-remaining">[minutes]m left</span>
							</div>
			"}

			if(can_accept || can_complete || can_verify)
				html += "<div class=\"contract-actions\">"
				if(can_complete && !contract.is_verification_based())
					html += {"
						<button class="btn btn-small" onclick="completeContract('[contract.contract_id]')">
							Complete
						</button>
					"}

				if(can_complete && contract.is_verification_based())
					html += {"
						<button class="btn btn-small" onclick="requestVerification('[contract.contract_id]')">
							Verify
						</button>
					"}

				if(can_verify)
					html += {"
						<button class="btn btn-verify btn-small" onclick="verifyContract('[contract.contract_id]', true)">
							✓
						</button>
						<button class="btn btn-reject btn-small" onclick="verifyContract('[contract.contract_id]', false)">
							✗
						</button>
					"}

				html += "</div>"

			html += "</div>"

	html += {"
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Form Overlay -->
	<div class="form-overlay" id="create-form">
		<div class="form-header">
			<h3 class="form-title">Post New Bounty</h3>
		</div>
		<div class="form-content">
			<div class="parchment-form">
				<form onsubmit="submitContract(event)">
					<div class="form-group">
						<label class="form-label">Bounty Type</label>
						<select class="form-select" id="contract-type" required>
							<option value="">Choose your task...</option>
							[contract_types]
						</select>
					</div>
					<div class="form-group" id="marker-target-group" style="display:none;">
						<label class="form-label">Marked Target</label>
						<select class="form-select" id="marker-target" required>
							<option value="">Select marked target...</option>
							[get_marker_targets_html(user)]
						</select>
						<small style="color: #888; font-style: italic;">Use your bounty marker to mark targets first</small>
					</div>

					<div class="form-group" id="target-group">
						<label class="form-label">Target/Description</label>
						<input type="text" class="form-input" id="target-name" required>
					</div>
					<div class="form-group" id="contraband-group" style="display:none;">
						<label class="form-label">Contraband Type</label>
						<select class="form-select" id="contraband-type">
							<option value="">Select contraband...</option>
							[contraband_options]
						</select>
					</div>
					<div class="form-group">
						<label class="form-label">Mammons</label>
						<input type="number" class="form-input" id="payment" min="1" required>
					</div>
					<div class="form-group">
						<label class="form-label">Time Limit (minutes)</label>
						<input type="number" class="form-input" id="time-limit" value="60" min="1" required>
					</div>
					<div class="form-group">
						<label class="form-label">Special Instructions</label>
						<textarea class="form-textarea" id="instructions" placeholder="Additional details..."></textarea>
					</div>
					<div class="form-group" id="location-group" style="display:none;">
						<label class="form-label">Location</label>
						<select class="form-select" id="location">
							<option value="">Select location...</option>
							[location_options]
						</select>
					</div>
					<div class="form-group">
						<button type="submit" class="btn" style="width: 100%; margin-bottom: 10px;">Post Bounty</button>
						<button type="button" class="btn" onclick="toggleCreateForm()" style="width: 100%; background: linear-gradient(145deg, #696969 0%, #2F4F4F 100%);">Cancel</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<script>
		const MARKER_REQUIRED_TYPES = \['kidnapping', 'assassination', 'impersonation', 'burial'\];
		function toggleCreateForm() {
			const form = document.getElementById('create-form');
			const backdrop = document.getElementById('overlay-backdrop');

			if (form.classList.contains('active')) {
				form.classList.remove('active');
				backdrop.classList.remove('active');
			} else {
				form.classList.add('active');
				backdrop.classList.add('active');
			}
		}

		document.getElementById('contract-type').addEventListener('change', function() {
			const contractType = this.value;
			const locationGroup = document.getElementById('location-group');
			const contrabandGroup = document.getElementById('contraband-group');
			const targetGroup = document.getElementById('target-group');
			const markerTargetGroup = document.getElementById('marker-target-group');

			const needsLocation = \['kidnapping', 'smuggling', 'burial'\].includes(contractType);
			const isSmuggling = contractType === 'smuggling';
			const requiresMarker = MARKER_REQUIRED_TYPES.includes(contractType);

			locationGroup.style.display = needsLocation ? 'block' : 'none';
			contrabandGroup.style.display = isSmuggling ? 'block' : 'none';

			if (requiresMarker) {
				markerTargetGroup.style.display = 'block';
				targetGroup.style.display = 'none';
				document.getElementById('marker-target').required = true;
				document.getElementById('target-name').required = false;
				refreshMarkerTargets(); // Refresh available targets
			} else if (isSmuggling) {
				markerTargetGroup.style.display = 'none';
				targetGroup.style.display = 'none';
				document.getElementById('marker-target').required = false;
				document.getElementById('target-name').required = false;
				document.getElementById('target-name').value = 'Contraband Delivery';
			} else {
				markerTargetGroup.style.display = 'none';
				targetGroup.style.display = 'block';
				document.getElementById('marker-target').required = false;
				document.getElementById('target-name').required = true;
			}
		});

		function submitContract(event) {
			event.preventDefault();

			const contractType = document.getElementById('contract-type').value;
			const requiresMarker = MARKER_REQUIRED_TYPES.includes(contractType);

			const formData = {
				type: contractType,
				target: requiresMarker ? '' : document.getElementById('target-name').value,
				marker_target: requiresMarker ? document.getElementById('marker-target').value : '',
				payment: parseInt(document.getElementById('payment').value),
				time_limit: parseInt(document.getElementById('time-limit').value),
				instructions: document.getElementById('instructions').value,
				location: document.getElementById('location').value,
				contraband: document.getElementById('contraband-type').value
			};

			if (requiresMarker && !formData.marker_target) {
				alert('Please select a marked target for this contract type!');
				return;
			}

			window.location.href = 'byond://?src=' + encodeURIComponent('[REF(src)]') + '&action=create_contract&' +
				Object.keys(formData).map(key => key + '=' + encodeURIComponent(formData\[key\])).join('&');
		}

		function acceptContract(contractId) {
			window.location.href = 'byond://?src=' + encodeURIComponent('[REF(src)]') + '&action=accept_contract&contract_id=' + encodeURIComponent(contractId);
		}

		function completeContract(contractId) {
			window.location.href = 'byond://?src=' + encodeURIComponent('[REF(src)]') + '&action=complete_contract&contract_id=' + encodeURIComponent(contractId);
		}

		function requestVerification(contractId) {
			window.location.href = 'byond://?src=' + encodeURIComponent('[REF(src)]') + '&action=request_verification&contract_id=' + encodeURIComponent(contractId);
		}

		function verifyContract(contractId, success) {
			window.location.href = 'byond://?src=' + encodeURIComponent('[REF(src)]') + '&action=verify_contract&contract_id=' + encodeURIComponent(contractId) + '&success=' + (success ? '1' : '0');
		}
	</script>
</body>
</html>
	"}
	return html

/obj/structure/bounty_board/Topic(href, href_list)
	if(!usr || !usr.client)
		return

	if(href_list["action"])
		switch(href_list["action"])
			if("create_contract")
				create_contract_from_form(usr, href_list)
			if("accept_contract")
				accept_contract(usr, href_list["contract_id"])
			if("complete_contract")
				complete_contract_manual(usr, href_list["contract_id"])
			if("request_verification")
				request_contract_verification(usr, href_list["contract_id"])
			if("verify_contract")
				verify_contract_completion(usr, href_list["contract_id"], text2num(href_list["success"]))

/obj/structure/bounty_board/proc/create_contract_from_form(mob/user, list/params)
	var/contract_type = params["type"]
	var/target_name = sanitize(params["target"])
	var/payment = text2num(params["payment"])
	var/time_limit = text2num(params["time_limit"])
	var/special_instructions = sanitize(params["instructions"])
	var/delivery_location = params["location"]
	var/contraband_type = params["contraband"]
	var/marker_target_id = params["marker_target"]

	if(!contract_type || !(contract_type in GLOB.bounty_contract_types) || !payment || payment <= 0)
		to_chat(user, span_warning("Invalid contract parameters!"))
		return

	var/requires_marker = (contract_type in list("kidnapping", "assassination", "impersonation", "burial"))
	var/requires_location = (contract_type in list("kidnapping", "smuggling", "burial"))
	var/datum/marked_target/selected_target

	if(requires_marker)
		var/obj/item/bounty_marker/marker = locate() in user.get_contents()
		if(!marker)
			to_chat(user, span_warning("You need a bounty marker to create this type of contract!"))
			return

		if(!marker.marked_targets.len)
			to_chat(user, span_warning("You need to mark a target first using your bounty marker!"))
			return

		// Find the selected target by ID or name
		if(marker_target_id)
			for(var/datum/marked_target/mt in marker.marked_targets)
				if(mt.target_name == marker_target_id && mt.is_valid())
					selected_target = mt
					break

		if(!selected_target)
			to_chat(user, span_warning("Selected target is no longer valid!"))
			return

		target_name = selected_target.target_name

	if(requires_location)
		if(!delivery_location)
			to_chat(user, span_warning("This contract requires delivery location!"))
			return

		var/valid_location = FALSE

		for(var/obj/effect/landmark/bounty_location/loc as anything in GLOB.bounty_locations)
			if(loc.location_name == delivery_location)
				valid_location = TRUE
				break

		if(!valid_location)
			to_chat(user, span_warning("Invalid delivery location!"))
			return

	// Special validation for smuggling contracts
	if(contract_type == "smuggling")
		if(!(contraband_type in GLOB.contraband_packs))
			to_chat(user, span_warning("Smuggling contracts require contraband type!"))
			return
		target_name = "Contraband Delivery: [contraband_type]"
	else if(!target_name && !requires_marker)
		to_chat(user, span_warning("Target name is required!"))
		return

	// Verify user has funds
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/extra = 0
		if(contract_type == "smuggling")
			var/datum/supply_pack/contraband_pack = GLOB.contraband_packs[contraband_type]
			extra = contraband_pack.cost
		if(get_mammons_in_atom(H) < payment + extra)
			to_chat(user, span_warning("Insufficient funds!"))
			return
		remove_mammons_from_atom(H, payment + extra)

	// Create the contract
	var/datum/bounty_contract/new_contract = new()
	new_contract.contract_type = contract_type
	new_contract.target_name = target_name
	new_contract.payment = payment
	new_contract.time_limit = time_limit * 60 * 10 // Convert to deciseconds
	new_contract.special_instructions = special_instructions
	new_contract.delivery_location = delivery_location
	new_contract.contraband_type = contraband_type
	new_contract.contractor_name = user.real_name
	new_contract.contractor_ckey = user.ckey
	new_contract.creation_time = world.time
	new_contract.contract_id = "[new_contract.contract_type]_[world.time]_[rand(1000,9999)]"
	new_contract.target_marker = selected_target // Store reference to marked target

	active_contracts += new_contract
	total_bounty_pool += payment
	check_harlequin_injection()

	to_chat(user, span_notice("Contract posted successfully! Payment held in escrow."))
	if(selected_target)
		selected_target.mark_as_used()
		to_chat(user, span_notice("Target: [selected_target.target_name] has been assigned to this contract."))
	interact(user)

/// This proc should be called when significant actions happen (death, theft, etc.) basically this is the check completion proc
/obj/structure/bounty_board/proc/check_target_action(mob/actor, mob/target, action_type)
	for(var/datum/bounty_contract/contract in active_contracts)
		if(!contract.assigned_to_harlequinn || contract.completed || contract.failed)
			continue

		if(!contract.target_marker)
			continue

		var/mob/marked_target = contract.target_marker.get_target()
		if(!marked_target || marked_target != target)
			continue

		// Check if the action matches the contract type
		var/contract_completed = FALSE
		switch(contract.contract_type)
			if("assassination")
				if(action_type == "death" && target.stat == DEAD)
					// Verify the harlequinn was involved in the kill
					if(actor && actor.ckey == contract.harlequinn_ckey)
						contract_completed = TRUE
						log_game("BOUNTY: Assassination contract [contract.contract_id] completed by [actor.ckey] on target [target.real_name]")
					else
						// Check if harlequinn was nearby or assisted
						var/mob/harlequinn = get_harlequinn_mob(contract.harlequinn_ckey)
						if(harlequinn && get_dist(harlequinn, target) <= 7) // Within reasonable range
							contract_completed = TRUE
							log_game("BOUNTY: Assassination contract [contract.contract_id] completed by proximity by [contract.harlequinn_ckey] on target [target.real_name]")

			if("kidnapping")
				if(action_type == "kidnap" && (target.stat == UNCONSCIOUS))
					contract_completed = TRUE
					log_game("BOUNTY: Kidnapping contract [contract.contract_id] completed on target [target.real_name]")

			if("impersonation")
				if(action_type == "impersonate") // Custom action for impersonation
					contract_completed = TRUE
					log_game("BOUNTY: Impersonation contract [contract.contract_id] completed on target [target.real_name]")

			if("burial")
				if(action_type == "death" && target.stat == DEAD)
					// Mark the corpse as available for burial
					contract.burial_corpse_available = TRUE
					to_chat(get_harlequinn_mob(contract.harlequinn_ckey), span_notice("Target eliminated! Retrieve the body and take it to [contract.delivery_location] for burial."))
					log_game("BOUNTY: Burial contract [contract.contract_id] target [target.real_name] eliminated, awaiting burial")

		if(contract_completed && contract.contract_type != "burial") // Burial has special handling
			contract.complete_contract(src)
			// Find the bounty hunter and reward them
			var/mob/harlequinn = get_harlequinn_mob(contract.harlequinn_ckey)
			if(harlequinn)
				modify_reputation(harlequinn, get_reputation_reward(contract.contract_type))
				to_chat(harlequinn, span_notice("Contract '[contract.target_name]' completed automatically!"))


/obj/structure/bounty_board/proc/get_reputation_reward(contract_type)
	switch(contract_type)
		if("burial")
			return 5
		if("kidnapping", "impersonation")
			return 8
		if("assassination")
			return 12
		else
			return 5

/obj/structure/bounty_board/proc/get_marker_targets_html(mob/user)
	var/obj/item/bounty_marker/marker = locate() in user.get_contents()
	if(!marker || !marker.marked_targets.len)
		return ""

	var/html = ""
	for(var/datum/marked_target/target in marker.marked_targets)
		if(target.is_valid())
			html += "<option value=\"[target.target_name]\">[target.get_display_name()]</option>"

	return html

/obj/structure/bounty_board/proc/accept_contract(mob/user, contract_id)
	if(!is_bounty_hunter(user))
		to_chat(user, span_warning("Only bounty hunters can accept contracts!"))
		return

	var/datum/bounty_contract/contract = find_contract_by_id(contract_id)
	if(!contract)
		to_chat(user, span_warning("Contract not found!"))
		return

	if(contract.assigned_to_harlequinn)
		to_chat(user, span_warning("This contract is already assigned!"))
		return

	if(contract.contractor_ckey == user.ckey)
		to_chat(user, span_warning("You cannot accept your own contract!"))
		return

	// Check reputation requirements
	var/required_rep = get_required_reputation(contract.contract_type)
	if(get_reputation(user) < required_rep)
		to_chat(user, span_warning("Your reputation is too low for this type of contract! (Required: [required_rep])"))
		return

	contract.assign_to_harlequinn(user)

	// If it's a smuggling contract, spawn the contraband
	if(contract.contract_type == "smuggling" && contract.contraband_type)
		spawn_contraband_for_contract(contract, user)

	to_chat(user, span_notice("Contract accepted! Good hunting."))
	interact(user)

/obj/structure/bounty_board/proc/get_required_reputation(contract_type)
	switch(contract_type)
		if("burial")
			return -10 // Even low rep can do these
		if("smuggling", "kidnapping")
			return 0 // Neutral reputation required
		if("sabotage", "impersonation")
			return 10 // Good reputation required
		if("assassination")
			return 25 // High reputation required
		else
			return 0

/obj/structure/bounty_board/proc/complete_contract_manual(mob/user, contract_id)
	var/datum/bounty_contract/contract = find_contract_by_id(contract_id)
	if(!contract)
		return

	if(contract.harlequinn_ckey != user.ckey)
		to_chat(user, span_warning("This is not your contract!"))
		return

	if(contract.is_area_based())
		to_chat(user, span_warning("This contract will complete automatically when the task is done at the specified location!"))
		return

	if(contract.is_verification_based())
		to_chat(user, span_warning("This contract requires verification from the contractor!"))
		return

	contract.complete_contract(src)
	modify_reputation(user, 5) // Gain reputation for completing contracts
	to_chat(user, span_notice("Contract completed!"))
	interact(user)

/obj/structure/bounty_board/proc/request_contract_verification(mob/user, contract_id)
	var/datum/bounty_contract/contract = find_contract_by_id(contract_id)
	if(!contract)
		return

	if(contract.harlequinn_ckey != user.ckey)
		to_chat(user, span_warning("This is not your contract!"))
		return

	contract.pending_verification = TRUE
	to_chat(user, span_notice("Verification requested! The contractor will need to confirm completion."))

	// Notify the contractor if they're online
	for(var/mob/M in GLOB.player_list)
		if(M.ckey == contract.contractor_ckey)
			to_chat(M, span_notice("Contract verification requested for '[contract.target_name]'. Check the bounty board to verify."))
			break

	interact(user)

/obj/structure/bounty_board/proc/verify_contract_completion(mob/user, contract_id, success)
	var/datum/bounty_contract/contract = find_contract_by_id(contract_id)
	if(!contract)
		return

	if(contract.contractor_ckey != user.ckey)
		to_chat(user, span_warning("You are not the contractor for this job!"))
		return

	if(!contract.pending_verification)
		to_chat(user, span_warning("This contract is not pending verification!"))
		return

	if(success)
		contract.complete_contract(src)
		// Find the harlequinn and give them reputation
		for(var/mob/M in GLOB.player_list)
			if(M.ckey == contract.harlequinn_ckey)
				modify_reputation(M, 10) // More reputation for verified completion
				to_chat(M, span_notice("Your contract has been verified as successful!"))
				break
		to_chat(user, span_notice("Contract verified as successful!"))
	else
		contract.fail_contract(src)
		// Find the harlequinn and reduce their reputation
		for(var/mob/M in GLOB.player_list)
			if(M.ckey == contract.harlequinn_ckey)
				modify_reputation(M, -15) // Penalty for failed contracts
				to_chat(M, span_warning("Your contract has been marked as failed!"))
				break
		to_chat(user, span_notice("Contract marked as failed."))

	interact(user)

/obj/structure/bounty_board/proc/find_contract_by_id(contract_id)
	for(var/datum/bounty_contract/contract in active_contracts)
		if(contract.contract_id == contract_id)
			return contract
	return null

/obj/structure/bounty_board/proc/is_bounty_hunter(mob/user)
	return user.mind?.has_antag_datum(/datum/antagonist/harlequinn) || user.mind?.has_antag_datum(/datum/antagonist/bandit) || user.mind?.has_antag_datum(/datum/antagonist/assassin)

/obj/structure/bounty_board/proc/spawn_contraband_for_contract(datum/bounty_contract/contract, mob/harlequinn)
	if(!contract.contraband_type || contract.contraband_spawned)
		return

	// Get the supply pack type
	var/pack_type = GLOB.contraband_packs[contract.contraband_type]
	if(!pack_type)
		to_chat(harlequinn, span_warning("Error: Contraband type not found!"))
		return

	// Choose a random spawn location (excluding the delivery location)
	var/list/available_locations = list()
	for(var/obj/effect/landmark/bounty_location/loc as anything in GLOB.bounty_locations)
		if(loc.location_name != contract.delivery_location)
			available_locations += loc

	if(!available_locations.len)
		to_chat(harlequinn, span_warning("Error: No spawn locations available!"))
		return

	var/obj/effect/landmark/bounty_location/spawn_location = pick(available_locations)

	// Create the smuggling pouch with contraband
	var/obj/item/storage/smuggling_pouch/pouch = new(spawn_location.loc)
	pouch.contract_id = contract.contract_id
	pouch.delivery_location = contract.delivery_location

	// Create the supply pack and add its contents to the pouch
	var/datum/supply_pack/pack = new pack_type()

	for(var/item_type in pack.contains)
		var/obj/item = new item_type(pouch)
		SEND_SIGNAL(pouch, COMSIG_TRY_STORAGE_INSERT, item, null, TRUE, TRUE)

	// Mark contract as having contraband spawned
	contract.contraband_spawned = TRUE
	contract.spawn_location = spawn_location.location_name

	// Notify Harlequinn
	to_chat(harlequinn, span_notice("A smuggling pouch containing [contract.contraband_type] has been placed at [spawn_location.location_name]. Deliver it to [contract.delivery_location] to complete the contract."))

	// Clean up the pack datum
	qdel(pack)

// Called by external systems when area-based actions occur
/obj/structure/bounty_board/proc/check_area_completion(mob/harlequinn, obj/effect/landmark/bounty_location/location)
	for(var/datum/bounty_contract/contract in active_contracts)
		if(!contract.assigned_to_harlequinn || contract.completed || contract.failed)
			continue

		if(contract.harlequinn_ckey != harlequinn.ckey)
			continue

		if(contract.delivery_location == location.location_name)
			if(get_dist(harlequinn, location) <= location.completion_range)
				// Different completion logic based on contract type
				switch(contract.contract_type)
					if("smuggling")
						var/obj/item/storage/smuggling_pouch/pouch = locate() in harlequinn.get_contents()
						if(pouch && pouch.contract_id == contract.contract_id)
							contract.complete_contract(src)
							modify_reputation(harlequinn, 8)
							to_chat(harlequinn, span_notice("Smuggling contract completed! Contraband delivered successfully."))
							qdel(pouch)
						else
							to_chat(harlequinn, span_warning("You need to bring the smuggling pouch to complete this contract!"))

					if("kidnapping")
						if(!contract.kidnapping_timer_active)
							contract.start_kidnapping_timer(harlequinn, location, src)

					if("burial")
						// Check if they're carrying the target's corpse and have burial tools
						var/has_shovel = FALSE
						var/has_target_corpse = FALSE
						var/obj/structure/closet/dirthole/burial_hole = locate(/obj/structure/closet/dirthole) in location.loc

						// Check for shovel
						for(var/obj/item in harlequinn.get_contents())
							if(istype(item, /obj/item/weapon/shovel))
								has_shovel = TRUE
								break

						// Check for the specific target's corpse
						if(contract.target_marker && contract.burial_corpse_available)
							var/mob/target_corpse = contract.target_marker.get_target()
							if(target_corpse && target_corpse.stat == DEAD)
								// Check if corpse is being carried/dragged or nearby
								if(harlequinn.pulling == target_corpse || get_dist(harlequinn, target_corpse) <= 2)
									has_target_corpse = TRUE

						// Check if there's a suitable dirthole (pit stage or deeper)
						var/has_burial_site = FALSE
						if(burial_hole && burial_hole.stage >= 3)
							has_burial_site = TRUE

						if(has_shovel && has_target_corpse && has_burial_site)
							if(!contract.burial_timer_active)
								contract.start_burial_timer(harlequinn, location, src)
						else
							var/missing_items = list()
							if(!has_shovel)
								missing_items += "burial tools (shovel)"
							if(!has_target_corpse)
								missing_items += "the target's corpse nearby"
							if(!has_burial_site)
								missing_items += "a proper burial pit (dig deeper with your shovel)"
							to_chat(harlequinn, span_warning("You need [english_list(missing_items)] to complete this burial contract!"))


/datum/bounty_contract/proc/start_burial_timer(mob/harlequinn, obj/effect/landmark/bounty_location/location, obj/structure/bounty_board/board)
	burial_timer_active = TRUE
	burial_completion_time = world.time + 600
	burial_target_location = location

	to_chat(harlequinn, span_notice("Beginning burial process... Stay in the area for 60 seconds to complete the contract."))
	to_chat(harlequinn, span_warning("Do not move too far from the burial site or the contract will fail!"))

	// Start a timer to check if they stay in the area
	spawn(100)
		while(burial_timer_active && world.time < burial_completion_time)
			if(get_dist(harlequinn, location) > location.completion_range)
				burial_timer_active = FALSE
				to_chat(harlequinn, span_warning("You moved too far from the burial site! Burial contract failed."))
				return

			var/mob/target_corpse = target_marker?.get_target()
			if(!target_corpse || target_corpse.stat != DEAD || get_dist(harlequinn, target_corpse) > 2)
				burial_timer_active = FALSE
				to_chat(harlequinn, span_warning("You lost the corpse! Burial contract failed."))
				return

			var/time_left = (burial_completion_time - world.time) / 10
			if(time_left > 0 && time_left % 20 == 0) // Every 20 seconds
				to_chat(harlequinn, span_notice("Burial in progress... [time_left] seconds remaining."))

			sleep(100)


/datum/bounty_contract/proc/complete_burial(obj/structure/bounty_board/board)
	if(!burial_timer_active)
		return

	burial_timer_active = FALSE

	// Properly bury the corpse using the dirthole system
	var/mob/target_corpse = target_marker?.get_target()
	var/mob/harlequinn = board.get_harlequinn_mob(harlequinn_ckey)

	if(target_corpse && harlequinn)
		// Find or create a dirthole at the burial location
		var/turf/burial_turf = get_turf(burial_target_location)
		var/obj/structure/closet/dirthole/grave_hole = locate(/obj/structure/closet/dirthole) in burial_turf

		if(!grave_hole)
			// Create a new dirthole for burial
			grave_hole = new /obj/structure/closet/dirthole(burial_turf)
			grave_hole.stage = 3 // Set to pit stage for burial
			grave_hole.update_appearance(UPDATE_NAME | UPDATE_ICON)

		// Ensure the hole is at the right stage for burial
		if(grave_hole.stage < 3)
			grave_hole.stage = 3
			grave_hole.update_appearance(UPDATE_NAME | UPDATE_ICON)
		// Open the grave if it's closed
		if(!grave_hole.opened)
			grave_hole.open()

		// Place the corpse in the grave
		target_corpse.forceMove(burial_turf)
		grave_hole.user_buckle_mob(target_corpse, harlequinn)

		// Close and bless the grave
		grave_hole.close()

		// Set the buried flag properly
		if(istype(target_corpse, /mob/living/carbon/human))
			var/mob/living/carbon/human/buried_human = target_corpse
			buried_human.buried = TRUE

		// Create a grave marker for the blessed burial
		var/obj/structure/gravemarker/marker = new(burial_turf)
		marker.name = "grave of [target_corpse.real_name]"

		// Bless the burial - remove any curses and provide protection
		if(harlequinn && isliving(harlequinn))
			var/mob/living/living_harlequinn = harlequinn
			// Remove curse status if they have the graverobber trait (blessed burial)
			if(HAS_TRAIT(living_harlequinn, TRAIT_GRAVEROBBER))
				living_harlequinn.remove_status_effect(/datum/status_effect/debuff/cursed)
				to_chat(harlequinn, span_notice("Necra smiles upon this proper burial. Any curses are lifted."))
			else
				to_chat(harlequinn, span_notice("The proper burial brings peace to the departed soul."))

		log_game("BOUNTY: Burial contract [contract_id] completed, corpse of [target_corpse.real_name] properly buried and blessed at [burial_turf]")

	complete_contract(board)

	// Find the harlequinn and notify them
	if(harlequinn)
		board.modify_reputation(harlequinn, 6)
		to_chat(harlequinn, span_notice("Burial contract completed! The body has been properly interred and blessed."))

// Process contract timeouts and kidnapping timers
/obj/structure/bounty_board/proc/process_contracts()
	for(var/datum/bounty_contract/contract in active_contracts)
		// Check for timeouts
		if(world.time > contract.creation_time + contract.time_limit)
			if(!contract.completed && !contract.failed)
				contract.fail_contract(src)
				// Reduce reputation for timeout
				if(contract.assigned_to_harlequinn)
					var/mob/harlequinn = get_harlequinn_mob(contract.harlequinn_ckey)
					if(harlequinn)
						modify_reputation(harlequinn, -10)
						to_chat(harlequinn, span_warning("Contract '[contract.target_name]' has timed out!"))

		// Process kidnapping timers
		if(contract.kidnapping_timer_active && world.time > contract.kidnapping_completion_time)
			contract.complete_kidnapping(src)

		// Process burial timers
		if(contract.burial_timer_active && world.time > contract.burial_completion_time)
			contract.complete_burial(src)

/obj/structure/bounty_board/proc/get_harlequinn_mob(ckey)
	for(var/mob/M in GLOB.player_list)
		if(M.ckey == ckey)
			return M
	return null

/datum/bounty_contract
	var/contract_id
	var/contract_type // theft, kidnapping, assassination, etc.
	var/target_name
	var/payment
	var/time_limit
	var/special_instructions
	var/delivery_location
	var/contraband_type // For smuggling contracts
	var/contractor_name
	var/contractor_ckey
	var/creation_time
	var/completed = FALSE
	var/failed = FALSE
	var/assigned_to_harlequinn = FALSE
	var/harlequinn_ckey
	var/waiting_for_area_completion = FALSE
	var/contraband_spawned = FALSE // For smuggling contracts
	var/spawn_location // Where contraband was spawned
	var/pending_verification = FALSE
	// Kidnapping timer variables
	var/kidnapping_timer_active = FALSE
	var/kidnapping_completion_time = 0
	var/kidnapping_target_location
	var/datum/marked_target/target_marker

	var/burial_timer_active = FALSE
	var/burial_completion_time = 0
	var/burial_target_location
	var/obj/item/corpse_carried // Track if carrying the right corpse
	var/burial_corpse_available = FALSE

/datum/bounty_contract/proc/is_area_based()
	return contract_type in list("kidnapping", "smuggling", "burial")

/datum/bounty_contract/proc/is_verification_based()
	return contract_type in list("assassination", "sabotage", "impersonation")

/datum/bounty_contract/proc/assign_to_harlequinn(mob/harlequinn)
	assigned_to_harlequinn = TRUE
	harlequinn_ckey = harlequinn.ckey
	if(is_area_based() && delivery_location)
		waiting_for_area_completion = TRUE

/datum/bounty_contract/proc/complete_contract(obj/structure/bounty_board/board)
	completed = TRUE
	waiting_for_area_completion = FALSE
	pending_verification = FALSE
	kidnapping_timer_active = FALSE

	// Pay the harlequinn
	if(harlequinn_ckey)
		for(var/mob/M in GLOB.player_list)
			if(M.ckey == harlequinn_ckey && ishuman(M))
				var/mob/living/carbon/human/H = M
				add_mammons_to_atom(H, payment)
				to_chat(H, span_notice("You have been paid [payment] Mammons for completing the contract!"))
				break

	// Remove from active contracts and add to completed
	if(board)
		board.active_contracts -= src
		board.completed_contracts += src
		board.total_bounty_pool -= payment


/datum/bounty_contract/proc/fail_contract(obj/structure/bounty_board/board)
	failed = TRUE
	waiting_for_area_completion = FALSE
	pending_verification = FALSE
	kidnapping_timer_active = FALSE

	// Return payment to contractor
	if(contractor_ckey)
		for(var/mob/M in GLOB.player_list)
			if(M.ckey == contractor_ckey && ishuman(M))
				var/mob/living/carbon/human/H = M
				add_mammons_to_atom(H, payment)
				to_chat(H, span_notice("Your contract has failed. [payment] Mammons have been returned."))
				break

	// Remove from active contracts
	if(board)
		board.active_contracts -= src
		board.total_bounty_pool -= payment
		if(board.last_harlequin_spawn)
			board.last_harlequin_spawn = max(0, board.last_harlequin_spawn - payment)

/datum/bounty_contract/proc/start_kidnapping_timer(mob/harlequinn, obj/effect/landmark/bounty_location/location, obj/structure/bounty_board/board)
	kidnapping_timer_active = TRUE
	kidnapping_completion_time = world.time + 300 // 30 seconds
	kidnapping_target_location = location

	to_chat(harlequinn, span_notice("Kidnapping in progress... Stay in the area for 30 seconds to complete the contract."))

	// Start a timer to check if they stay in the area
	spawn(50) // Check every 5 seconds
		while(kidnapping_timer_active && world.time < kidnapping_completion_time)
			if(get_dist(harlequinn, location) > location.completion_range)
				kidnapping_timer_active = FALSE
				to_chat(harlequinn, span_warning("You moved too far from the target area! Kidnapping contract failed."))
				return
			sleep(50)

/datum/bounty_contract/proc/complete_kidnapping(obj/structure/bounty_board/board)
	if(!kidnapping_timer_active)
		return

	kidnapping_timer_active = FALSE
	complete_contract(board)

	// Find the harlequinn and notify them
	for(var/mob/M in GLOB.player_list)
		if(M.ckey == harlequinn_ckey)
			board.modify_reputation(M, 7)
			to_chat(M, span_notice("Kidnapping contract completed! Target successfully acquired."))
			break

// Smuggling pouch item
/obj/item/storage/smuggling_pouch
	name = "smuggling pouch"
	desc = "A discrete pouch containing contraband goods. Handle with care."
	icon = 'icons/roguetown/clothing/storage.dmi'
	icon_state = "pouch"
	w_class = WEIGHT_CLASS_NORMAL
	var/contract_id
	var/delivery_location
	var/dropped_at_location = FALSE

/obj/item/storage/smuggling_pouch/dropped(mob/user)
	. = ..()
	if(!contract_id || dropped_at_location)
		return

	// Check if dropped at the correct delivery location
	for(var/obj/effect/landmark/bounty_location/location in range(6, src))
		if(location.location_name == delivery_location)
			dropped_at_location = TRUE
			visible_message(span_notice("[src] has been delivered to [delivery_location]."))

			for(var/obj/structure/bounty_board/board in GLOB.bounty_boards)
				var/datum/bounty_contract/contract = board.find_contract_by_id(contract_id)
				if(contract && contract.assigned_to_harlequinn)
					contract.complete_contract(board)
					for(var/mob/M in GLOB.player_list)
						if(M.ckey == contract.harlequinn_ckey)
							board.modify_reputation(M, 8)
							to_chat(M, span_notice("Smuggling contract auto-completed! Pouch delivered successfully."))
							break

			break

// Landmark for bounty locations
/obj/effect/landmark/bounty_location
	name = "bounty location"
	var/location_name = "Unknown Location"
	var/completion_range = 3 // Tiles within this range count as "at the location"

/obj/effect/landmark/bounty_location/Initialize()
	. = ..()
	LAZYADD(GLOB.bounty_locations, src)
	if(!location_name || location_name == "Unknown Location")
		location_name = name

/obj/effect/landmark/bounty_location/Destroy()
	LAZYREMOVE(GLOB.bounty_locations, src)
	return ..()

/obj/effect/landmark/bounty_location/bathhouse
	name = "Behind the Bathhouse"
	location_name = "Behind the Bathhouse"
	completion_range = 5

/obj/effect/landmark/bounty_location/graveyard
	name = "Old Graveyard"
	location_name = "Old Graveyard"
	completion_range = 4

/obj/effect/landmark/bounty_location/warehouse
	name = "Abandoned Warehouse"
	location_name = "Abandoned Warehouse"
	completion_range = 6

/obj/effect/landmark/bounty_location/docks
	name = "Harbor Docks"
	location_name = "Harbor Docks"
	completion_range = 8

/obj/effect/landmark/bounty_location/alley
	name = "Dark Alley"
	location_name = "Dark Alley"
	completion_range = 3

/obj/item/bounty_marker
	name = "bounty marker"
	desc = "Brands a target spiritually from afar and stores them as a bounty."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "scryeye"
	w_class = WEIGHT_CLASS_SMALL
	var/list/marked_targets = list()
	var/max_targets = 5 // Maximum number of targets that can be marked

/obj/item/bounty_marker/attack_self(mob/user, list/modifiers)
	if(!marked_targets.len)
		to_chat(user, span_warning("No targets have been marked with this device."))
		return

	var/list/target_names = list()
	for(var/datum/marked_target/target in marked_targets)
		if(target.is_valid())
			target_names[target.get_display_name()] = target

	if(!target_names.len)
		to_chat(user, span_warning("All marked targets are no longer valid."))
		marked_targets = list()
		return

/obj/item/bounty_marker/afterattack(atom/target, mob/user, proximity_flag, list/modifiers)
	. = ..()
	if(!proximity_flag && get_dist(user, target) > 7)
		return

	if(!isliving(target))
		to_chat(user, span_warning("You can only mark living targets."))
		return

	var/mob/living/living_target = target
	if(living_target == user)
		to_chat(user, span_warning("You cannot mark yourself as a target."))
		return

	for(var/datum/marked_target/existing in marked_targets)
		if(existing.target_ref && existing.target_ref.resolve() == living_target)
			to_chat(user, span_warning("[living_target.real_name] is already marked."))
			return

	// Remove oldest target if at max capacity
	if(marked_targets.len >= max_targets)
		var/datum/marked_target/oldest = marked_targets[1]
		marked_targets -= oldest
		qdel(oldest)

	// Create new marked target
	var/datum/marked_target/new_target = new()
	new_target.target_ref = WEAKREF(living_target)
	new_target.target_name = living_target.real_name
	new_target.target_ckey = living_target.ckey
	new_target.mark_time = world.time
	new_target.marker_user = user.real_name

	marked_targets += new_target

	log_game("[user.real_name] marked [living_target.real_name] as a bounty target using a bounty marker.")

/datum/marked_target
	var/datum/weakref/target_ref
	var/target_name
	var/target_ckey
	var/mark_time
	var/marker_user
	var/used_in_contract = FALSE

/datum/marked_target/proc/is_valid()
	if(used_in_contract)
		return FALSE
	var/mob/target = target_ref?.resolve()
	return target && target.stat != DEAD // Allow unconscious targets

/datum/marked_target/proc/get_display_name()
	var/mob/target = target_ref?.resolve()
	if(target)
		return "[target_name] ([target.stat == DEAD ? "DEAD" : "ALIVE"])"
	return "[target_name] (MISSING)"

/datum/marked_target/proc/get_target()
	return target_ref?.resolve()

/datum/marked_target/proc/mark_as_used()
	used_in_contract = TRUE

/proc/add_mammons_to_atom(mob/target, mammons_to_add)
	if(!target || mammons_to_add <= 0)
		return FALSE

	var/remaining_mammons = mammons_to_add

	// First, try to add to existing coin stacks
	for(var/obj/item/coin/existing_coin in target.contents)
		if(!existing_coin.base_type || remaining_mammons <= 0)
			continue

		var/space_in_stack = 20 - existing_coin.quantity // MAX_COIN_STACK_SIZE = 20
		if(space_in_stack <= 0)
			continue

		var/coins_to_add = min(floor(remaining_mammons / existing_coin.sellprice), space_in_stack)
		if(coins_to_add > 0)
			existing_coin.set_quantity(existing_coin.quantity + coins_to_add)
			remaining_mammons -= coins_to_add * existing_coin.sellprice

	// Create new coin stacks for remaining mammons
	while(remaining_mammons > 0)
		var/coin_type_to_create = null
		var/coin_value = 0

		// Determine best coin denomination
		if(remaining_mammons >= 10)
			coin_type_to_create = /obj/item/coin/gold
			coin_value = 10
		else if(remaining_mammons >= 5)
			coin_type_to_create = /obj/item/coin/silver
			coin_value = 5
		else if(remaining_mammons >= 1)
			coin_type_to_create = /obj/item/coin/copper
			coin_value = 1
		else
			break // Less than 1 mammon remaining

		var/coins_to_create = min(floor(remaining_mammons / coin_value), 20)
		var/obj/item/coin/new_coin = new coin_type_to_create(get_turf(target), coins_to_create)

		if(ismob(target))
			target.put_in_hands(new_coin)
		else
			new_coin.forceMove(target)

		remaining_mammons -= coins_to_create * coin_value

	return mammons_to_add - remaining_mammons // Return actual amount added

// Remove mammons from an atom by modifying/deleting coins
/proc/remove_mammons_from_atom(atom/movable/target, mammons_to_remove)
	if(!target || mammons_to_remove <= 0)
		return 0

	var/static/list/coins_types = typecacheof(/obj/item/coin)
	var/remaining_to_remove = mammons_to_remove
	var/total_removed = 0

	// Create a list of all coins sorted by value (highest first for efficient removal)
	var/list/coin_list = list()
	for(var/obj/item/coin/coin in target.contents)
		if(coins_types[coin.type])
			coin_list += coin

	// Sort coins by sellprice (descending)
	sortTim(coin_list, GLOBAL_PROC_REF(cmp_coin_value_desc))

	// Remove from coins starting with highest value
	for(var/obj/item/coin/coin in coin_list)
		if(remaining_to_remove <= 0)
			break

		var/coin_total_value = coin.quantity * coin.sellprice
		if(coin_total_value <= remaining_to_remove)
			// Remove entire coin
			remaining_to_remove -= coin_total_value
			total_removed += coin_total_value
			qdel(coin)
		else
			// Partially remove from this coin
			var/quantity_to_remove = remaining_to_remove / coin.sellprice
			if(quantity_to_remove >= 1)
				coin.quantity -= quantity_to_remove
				var/value_removed = quantity_to_remove * coin.sellprice
				remaining_to_remove -= value_removed
				total_removed += value_removed
				coin.update_appearance(UPDATE_ICON_STATE | UPDATE_NAME | UPDATE_DESC)

		// Also check contents recursively
		if(remaining_to_remove > 0)
			var/removed_from_contents = remove_mammons_from_atom_recursive(coin, remaining_to_remove)
			remaining_to_remove -= removed_from_contents
			total_removed += removed_from_contents

	// Check other contents recursively
	for(var/atom/movable/content in target.contents)
		if(remaining_to_remove <= 0)
			break
		if(!coins_types[content.type]) // Skip coins we already processed
			var/removed_from_content = remove_mammons_from_atom_recursive(content, remaining_to_remove)
			remaining_to_remove -= removed_from_content
			total_removed += removed_from_content

	return total_removed

// Helper function for recursive mammon removal
/proc/remove_mammons_from_atom_recursive(atom/movable/target, mammons_to_remove)
	if(!target || mammons_to_remove <= 0)
		return 0

	var/static/list/coins_types = typecacheof(/obj/item/coin)
	var/remaining_to_remove = mammons_to_remove
	var/total_removed = 0

	// Remove from direct coin contents first
	for(var/obj/item/coin/coin in target.contents)
		if(remaining_to_remove <= 0)
			break
		if(coins_types[coin.type])
			var/coin_total_value = coin.quantity * coin.sellprice
			if(coin_total_value <= remaining_to_remove)
				remaining_to_remove -= coin_total_value
				total_removed += coin_total_value
				qdel(coin)
			else
				var/quantity_to_remove = remaining_to_remove / coin.sellprice
				if(quantity_to_remove >= 1)
					coin.quantity -= quantity_to_remove
					var/value_removed = quantity_to_remove * coin.sellprice
					remaining_to_remove -= value_removed
					total_removed += value_removed
					coin.update_appearance(UPDATE_ICON_STATE | UPDATE_NAME | UPDATE_DESC)

	// Then check other contents recursively
	for(var/atom/movable/content in target.contents)
		if(remaining_to_remove <= 0)
			break
		if(!coins_types[content.type])
			var/removed = remove_mammons_from_atom_recursive(content, remaining_to_remove)
			remaining_to_remove -= removed
			total_removed += removed

	return total_removed

/proc/cmp_coin_value_desc(obj/item/coin/a, obj/item/coin/b)
	return b.sellprice - a.sellprice

/proc/notify_bounty_boards_death(mob/dying_mob, mob/killer)
	for(var/obj/structure/bounty_board/board in GLOB.bounty_boards)
		board.check_target_action(killer, dying_mob, "death")

/proc/notify_bounty_boards_kidnap(mob/actor, mob/victim)
	for(var/obj/structure/bounty_board/board in GLOB.bounty_boards)
		board.check_target_action(actor, victim, "kidnap")

/proc/notify_bounty_boards_impersonate(mob/actor, mob/target)
	for(var/obj/structure/bounty_board/board in GLOB.bounty_boards)
		board.check_target_action(actor, target, "impersonate")
