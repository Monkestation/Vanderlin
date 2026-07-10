/client/var/datum/native_say/native_say


/datum/native_say
	var/client/client
	var/list/hurt_phrases = list("GACK!", "GLORF!", "OOF!", "AUGH!", "OW!", "URGH!", "HRNK!")
	var/max_length = MAX_MESSAGE_LEN
	var/window_open = FALSE

	// Window sizing
	var/window_width = 300
	var/window_height = 40
	var/list/window_sizes = list("small" = 40, "medium" = 60, "large" = 80)

	// Channel definitions - will be populated dynamically
	var/list/datum/say_channel/available_channels = list()
	var/list/channel_names = list()
	var/datum/say_channel/current_channel
	var/current_channel_index = 0

	// Chat history
	var/list/chat_history = list()
	var/history_index = 0
	var/temp_message = ""

/datum/native_say/New(client/C)
	src.client = C
	fetch_channels()
	initialize()

/datum/native_say/proc/fetch_channels()
	available_channels = list()
	channel_names = list()

	for(var/channel_type in subtypesof(/datum/say_channel))
		var/datum/say_channel/channel = new channel_type()

		if(channel.can_show(client))
			available_channels += channel
			channel_names += channel.name

	if(available_channels.len > 0)
		current_channel = available_channels[1]
		current_channel_index = 1

/datum/native_say/proc/initialize()
	set waitfor = FALSE
	reload_ui()

/datum/native_say/proc/reload_ui()
	var/scale = 1
	if(client?.window_scaling)
		scale = client?.window_scaling

	client << browse(get_html(), "window=native_say;size=[window_width * scale]x[window_height * scale];pos=848,500;can_close=0;can_minimize=0;can_resize=0;titlebar=0")
	winset(client, "native_say", "is-visible=0")
	winset(client, "native_say.browser", "size=[window_width * scale]x[window_height * scale]")

/datum/native_say/proc/get_channel_styles()
	var/styles = ""
	for(var/datum/say_channel/channel in available_channels)
		var/channel_name = channel.name
		styles += {"
		.window-[channel_name] { background-color: [channel.color]; }
		.button-[channel_name] { border: 1px solid [channel.get_border_color()]; color: [channel.color]; }
		.button-[channel_name]:hover { border-color: [channel.get_hover_border()]; color: [channel.get_hover_color()]; }
		.editor-[channel_name] { color: [channel.color]; }
		.shine-[channel_name] {
			background: [channel.get_shine_gradient()];
		}
"}
	return styles
/datum/native_say/proc/get_html()
	var/zoom = 100
	var/scale = 1
	if(client?.window_scaling)
		scale = client?.window_scaling
	var/list/js_channels = list()
	var/list/js_quiet = list()

	for(var/datum/say_channel/channel in available_channels)
		js_channels += "\"[channel.name]\""
		if(channel.quiet)
			js_quiet += "\"[channel.name]\""

	var/channels_json = "\[[jointext(js_channels, ", ")]\]"
	var/quiet_json = "\[[jointext(js_quiet, ", ")]\]"
	var/default_channel = current_channel?.name || "Say"

	return {"<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<style>
		* {
			margin: 0;
			padding: 0;
			box-sizing: border-box;
		}

		body {
			font-family: 'Verdana', sans-serif;
			overflow: hidden;
			background: transparent;
			height: 100vh;
			display: flex;
			flex-direction: column;
			zoom: [zoom]%;
		}

		.window {
			position: absolute;
			inset: 0;
			background-color: #000;
			overflow: hidden;
			z-index: 0;
			pointer-events: auto;
			cursor: move;
		}

		.shine {
			position: absolute;
			inset: 0;
			background-size: 150% 150%;
			animation: shine 15s linear infinite;
			z-index: 1;
			pointer-events: none;
		}

		@keyframes shine {
			0% { transform: rotate(0deg); }
			50% { transform: rotate(270deg); }
			100% { transform: rotate(360deg); }
		}

		.content {
			position: absolute;
			inset: 2px;
			background-color: #000;
			z-index: 2;
			display: flex;
			flex-direction: row;
			padding: 2px;
			gap: 2px;
			min-height: 0;
			pointer-events: auto;
		}

		.button {
			background-color: #1f1f1f;
			border-radius: 0.3rem;
			border: none;
			font-size: 11px;
			font-weight: bold;
			outline: none;
			padding: 0.1rem 0.3rem;
			text-align: center;
			white-space: nowrap;
			cursor: pointer;
			user-select: none;
			flex-shrink: 0;
			width: 20%;
		}

		.textarea-container {
			flex: 1;
			min-width: 0;
			display: flex;
		}

		.editor {
			background: transparent;
			border: none;
			font-size: 1.1rem;
			outline: none;
			overflow-y: auto;
			overflow-x: hidden;
			flex: 1;
			min-width: 0;
			padding: 0.1rem 0.4rem;
			word-wrap: break-word;
			white-space: pre-wrap;
		}

		.editor::-webkit-scrollbar {
			width: 6px;
		}

		.editor::-webkit-scrollbar-track {
			background: transparent;
		}

		.editor::-webkit-scrollbar-thumb {
			background: rgba(255, 255, 255, 0.2);
			border-radius: 3px;
		}

		.editor::-webkit-scrollbar-thumb:hover {
			background: rgba(255, 255, 255, 0.3);
		}

		/* Dynamic channel-specific colors */
		[get_channel_styles()]
	</style>
</head>
<body>
	<div class="window window-[default_channel]" id="window">
		<div class="shine shine-[default_channel]" id="shine"></div>
	</div>
	<div class="content">
		<button class="button button-[default_channel]" id="channelBtn">[default_channel]</button>
		<div class="textarea-container">
			<div class="editor editor-[default_channel]" id="editor" contenteditable="true" spellcheck="false"></div>
		</div>
	</div>

	<script>
		// ===== GLOBALS =====
		window.currentChannel = '[default_channel]';
		window.currentChannelIndex = 0;
		window.windowOpen = false;
		window.isDragging = false;
		window.dragStartPos = {x: 0, y: 0};
		window.currentSize = 'small';
		window.isWindowDragging = false;
		window.dragPointOffset = {x: 0, y: 0};
		window.chatHistory = \[\];
		window.historyIndex = -1;
		window.tempMessage = '';
		window.realText = '';
		window.TYPING_THROTTLE = 2000;

		const channels = [channels_json];
		const quietChannels = [quiet_json];
		const windowSizes = { small: [40 * scale], medium: [60 * scale], large: [80 * scale] };
		const lineLengths = { small: 18, medium: 30, large: 43 };

		const windowEl = document.getElementById('window');
		const shineEl = document.getElementById('shine');
		const button = document.getElementById('channelBtn');
		const editor = document.getElementById('editor');

		// ===== MARKDOWN PARSER =====
		function parseMarkdownBasic(text, barebones) {
			if (!text || text.length === 0) return text;
			let t = text;

			if (!barebones) {
				t = t.replace(/\\$/g, '$-');
				t = t.replace(/\\\\\\\\/g, '$1');
				t = t.replace(/\\\\\\*\\*/g, '$2');
				t = t.replace(/\\\\\\*/g, '$3');
				t = t.replace(/\\\\__/g, '$4');
				t = t.replace(/\\\\_/g, '$5');
				t = t.replace(/\\\\\\^/g, '$6');
				t = t.replace(/\\\\\\(\\(/g, '$7');
				t = t.replace(/\\\\\\)\\)/g, '$8');
				t = t.replace(/\\\\\\|/g, '$9');
				t = t.replace(/\\\\%/g, '$0');
			}

			t = t.replace(/!/g, '$a');

			if (barebones) {
				t = t.replace(/\\+(\[^\\+\]+)\\+/g, '<b>$1</b>');
				t = t.replace(/\\|(\[^\\|\]+)\\|/g, '<i>$1</i>');
				t = t.replace(/_(\[^_\]+)_/g, '<u>$1</u>');
			} else {
				t = t.replace(/\\*(\[^\\*\]*)\\*/g, '<i>$1</i>');
				t = t.replace(/_(\[^_\]*)_/g, '<i>$1</i>');
				t = t.replace(/<i><\\/i>/g, '!');
				t = t.replace(/<\\/i><i>/g, '!');
				t = t.replace(/!(\[^!\]+)!/g, '<b>$1</b>');
				t = t.replace(/\\^(\[^\\^\]+)\\^/g, '<font size="4">$1</font>');
				t = t.replace(/\\|(\[^\\|\]+)\\|/g, '<center>$1</center>');
				t = t.replace(/!/g, '</i><i>');
			}

			t = t.replace(/\\$a/g, '!');

			if (!barebones) {
				t = t.replace(/\\$1/g, '\\\\\\\\');
				t = t.replace(/\\$2/g, '**');
				t = t.replace(/\\$3/g, '*');
				t = t.replace(/\\$4/g, '__');
				t = t.replace(/\\$5/g, '_');
				t = t.replace(/\\$6/g, '^');
				t = t.replace(/\\$7/g, '((');
				t = t.replace(/\\$8/g, '))');
				t = t.replace(/\\$9/g, '|');
				t = t.replace(/\\$0/g, '%');
				t = t.replace(/\\$-/g, '$');
			}

			return t;
		}

		// ===== CURSOR UTILITIES =====
		function getCursorPosition() {
			const sel = window.getSelection();
			if (!sel.rangeCount) return 0;

			const range = sel.getRangeAt(0);
			const preRange = range.cloneRange();
			preRange.selectNodeContents(editor);
			preRange.setEnd(range.endContainer, range.endOffset);

			const renderedPos = preRange.toString().length;
			return mapRenderedToRaw(renderedPos);
		}

		function mapRenderedToRaw(renderedPos) {
			let result = { rawPos: 0, renderedCount: 0 };

			function processText(startIdx, endIdx, targetRendered) {
				let i = startIdx;
				let localRendered = 0;

				while (i < endIdx && localRendered < targetRendered) {
					const char = window.realText\[i\];

					if (char === '+' || char === '|' || char === '_') {
						const closeIdx = window.realText.indexOf(char, i + 1);
						if (closeIdx !== -1 && closeIdx <= endIdx) {
							result.rawPos++;
							i++;

							const innerResult = processText(i, closeIdx, targetRendered - localRendered);
							localRendered += innerResult;
							i = closeIdx;

							result.rawPos++;
							i++;
							continue;
						}
					}

					localRendered++;
					result.rawPos++;
					i++;
				}

				return localRendered;
			}

			processText(0, window.realText.length, renderedPos);
			return result.rawPos;
		}

		function mapRawToRendered(rawPos) {
			let result = { renderedCount: 0, rawCount: 0 };

			function processText(startIdx, endIdx, targetRaw) {
				let i = startIdx;
				let localRendered = 0;

				while (i < endIdx && result.rawCount < targetRaw) {
					const char = window.realText\[i\];

					if (char === '+' || char === '|' || char === '_') {
						const closeIdx = window.realText.indexOf(char, i + 1);
						if (closeIdx !== -1 && closeIdx <= endIdx) {
							result.rawCount++;
							i++;

							if (result.rawCount >= targetRaw) {
								return localRendered;
							}

							const innerResult = processText(i, closeIdx, targetRaw);
							localRendered += innerResult;
							i = closeIdx;

							if (result.rawCount >= targetRaw) {
								return localRendered;
							}

							result.rawCount++;
							i++;
							continue;
						}
					}

					localRendered++;
					result.renderedCount++;
					result.rawCount++;
					i++;
				}

				return localRendered;
			}

			processText(0, window.realText.length, rawPos);
			return result.renderedCount;
		}

		function setCursorPosition(pos) {
			const sel = window.getSelection();
			const range = document.createRange();

			let charCount = 0;
			let foundPos = false;

			function traverseNodes(node) {
				if (foundPos) return;

				if (node.nodeType === Node.TEXT_NODE) {
					const nextCharCount = charCount + node.length;
					if (pos >= charCount && pos <= nextCharCount) {
						range.setStart(node, Math.min(pos - charCount, node.length));
						range.collapse(true);
						foundPos = true;
						return;
					}
					charCount = nextCharCount;
				} else {
					for (let i = 0; i < node.childNodes.length; i++) {
						traverseNodes(node.childNodes\[i\]);
						if (foundPos) return;
					}
				}
			}

			traverseNodes(editor);

			if (foundPos) {
				sel.removeAllRanges();
				sel.addRange(range);
			} else if (editor.childNodes.length > 0) {
				const lastNode = editor.childNodes\[editor.childNodes.length - 1\];
				const lastChild = lastNode.nodeType === Node.TEXT_NODE ? lastNode : (lastNode.lastChild || lastNode);
				try {
					if (lastChild.nodeType === Node.TEXT_NODE) {
						range.setStart(lastChild, lastChild.length);
					} else {
						range.setStartAfter(lastChild);
					}
					range.collapse(true);
					sel.removeAllRanges();
					sel.addRange(range);
				} catch(e) {}
			}

			scrollCursorIntoView();
		}

		function scrollCursorIntoView() {
			const sel = window.getSelection();
			if (!sel.rangeCount) return;

			const range = sel.getRangeAt(0);
			const rect = range.getBoundingClientRect();
			const editorRect = editor.getBoundingClientRect();

			if (rect.bottom > editorRect.bottom) {
				editor.scrollTop += rect.bottom - editorRect.bottom + 5;
			} else if (rect.top < editorRect.top) {
				editor.scrollTop -= editorRect.top - rect.top + 5;
			}
		}

		function updatePreview() {
			const parsed = parseMarkdownBasic(window.realText, true);
			if (editor.innerHTML !== parsed) {
				editor.innerHTML = parsed;
			}
		}

		// ===== UI FUNCTIONS =====
		function applyTheme(channel) {
			windowEl.className = 'window window-' + channel;
			shineEl.className = 'shine shine-' + channel;
			button.className = 'button button-' + channel;
			editor.className = 'editor editor-' + channel;
		}

		function updateWindowSize() {
			let len = window.realText.length;
			let newSize = 'small';

			if (len > lineLengths.medium) {
				newSize = 'large';
			} else if (len > lineLengths.small) {
				newSize = 'medium';
			} else {
				newSize = 'small';
			}

			if (newSize !== window.currentSize) {
				window.currentSize = newSize;
				const newHeight = windowSizes\[newSize\];
				window.location = 'byond://winset?id=native_say&size=[300 * scale]x' + newHeight;
				window.location = 'byond://winset?id=native_say.browser&size=[300 * scale]x' + newHeight;
			}
		}

		// ===== WINDOW CONTROL =====
		function openWindow(channel) {
			if (window.windowOpen) {
				return;
			}

			window.windowOpen = true;

			editor.style.pointerEvents = 'auto';
			window.currentChannel = channel;
			window.currentChannelIndex = channels.indexOf(channel) || 0;

			button.textContent = channel;
			applyTheme(channel);
			editor.innerHTML = '';
			window.realText = '';
			window.currentSize = 'small';
			editor.focus();

			const newHeight = windowSizes\['small'\];
			window.location = 'byond://winset?id=native_say&focus=true';
			window.location = 'byond://winset?id=native_say&size=[300 * scale]x' + newHeight;
			window.location = 'byond://winset?id=native_say.browser&size=[300 * scale]x' + newHeight;

			if (!quietChannels.includes(channel)) {
				window.location = 'byond://?src=' + encodeURIComponent('[ref(src)]') + ';action=thinking;visible=1';
			}
		}

		function closeWindow() {
			window.windowOpen = false;

			editor.style.pointerEvents = 'none';
			editor.innerHTML = '';
			window.realText = '';

			editor.blur();
			button.blur();
			if (document.activeElement) {
				document.activeElement.blur();
			}

			window.historyIndex = -1;
			window.tempMessage = '';
			window.currentSize = 'small';

			window.location = 'byond://winset?id=native_say&is-visible=0';
			window.location = 'byond://winset?id=:map&focus=true';

			window.location = 'byond://?src=' + encodeURIComponent('[ref(src)]') + ';action=close';

			setTimeout(function() {
				window.location = 'byond://winset?id=:map&focus=true';
			}, 50);

		}

		function cycleChannel() {
			window.currentChannelIndex = (window.currentChannelIndex + 1) % channels.length;
			window.currentChannel = channels\[window.currentChannelIndex\];
			button.textContent = window.currentChannel;
			applyTheme(window.currentChannel);

			let visible = !quietChannels.includes(window.currentChannel);
			window.location = 'byond://?src=' + encodeURIComponent('[ref(src)]') + ';action=thinking;visible=' + (visible ? '1' : '0');
		}

		function cycleToChannel(targetChannel) {
			if (!channels.includes(targetChannel)) {
				return;
			}

			window.currentChannel = targetChannel;
			window.currentChannelIndex = channels.indexOf(targetChannel);
			button.textContent = targetChannel;
			applyTheme(targetChannel);

			let visible = !quietChannels.includes(targetChannel);
			window.location = 'byond://?src=' + encodeURIComponent('[ref(src)]') + ';action=thinking;visible=' + (visible ? '1' : '0');

			editor.focus();
		}

		function submitEntry() {
			let entry = window.realText.trim();
			if (entry.length > 0 && entry.length < 1024) {
				window.chatHistory.unshift(entry);
				if (window.chatHistory.length > 5) window.chatHistory.pop();

				window.location = 'byond://?src=' + encodeURIComponent('[ref(src)]') + ';action=entry;channel=' + encodeURIComponent(window.currentChannel) + ';entry=' + encodeURIComponent(entry);
			}
			closeWindow();
		}

		// ===== EVENT HANDLERS =====
		button.addEventListener('mousedown', function(e) {
			window.isDragging = true;
			window.dragStartPos = {x: e.screenX, y: e.screenY};
		});

		button.addEventListener('mouseup', function(e) {
			setTimeout(function() {
				if (window.isDragging && e.screenX === window.dragStartPos.x && e.screenY === window.dragStartPos.y) {
					cycleChannel();
				}
				window.isDragging = false;
			}, 50);
		});

		window.handleWingetPos = function(data) {
			if (data && data.pos) {
				const posX = data.pos.x;
				const posY = data.pos.y;
				window.dragPointOffset = {
					x: window.dragStartPos.x - posX,
					y: window.dragStartPos.y - posY
				};
				window.isWindowDragging = true;
			}
		};

		windowEl.addEventListener('mousedown', function(e) {
			e.preventDefault();
			e.stopPropagation();
			window.dragStartPos = {x: e.screenX, y: e.screenY};

			if (typeof winget === 'function') {
				const posStr = winget('native_say', 'pos');
				const posArr = posStr.split(',').map(v => parseInt(v));
				window.dragPointOffset = {
					x: window.dragStartPos.x - posArr\[0\],
					y: window.dragStartPos.y - posArr\[1\]
				};
				window.isWindowDragging = true;
			} else {
				window.location = 'byond://winget?callback=handleWingetPos&id=native_say&property=pos';
			}
		});

		document.addEventListener('mousemove', function(e) {
			if (!window.isWindowDragging) {
				return;
			}
			e.preventDefault();

			const newX = e.screenX - window.dragPointOffset.x;
			const newY = e.screenY - window.dragPointOffset.y;

			if (typeof winset === 'function') {
				winset('native_say', 'pos=' + newX + ',' + newY);
			} else {
				window.location = 'byond://winset?id=native_say&pos=' + newX + ',' + newY;
			}
		});

		document.addEventListener('mouseup', function(e) {
			if (window.isWindowDragging) {
				window.isWindowDragging = false;
			}
		});

		editor.addEventListener('beforeinput', function(e) {
			if (!window.windowOpen) {
				e.preventDefault();
				return;
			}

			const sel = window.getSelection();
			const hasSelection = sel.rangeCount > 0 && !sel.getRangeAt(0).collapsed;

			let selectionStart, selectionEnd;

			if (hasSelection) {
				const range = sel.getRangeAt(0);
				const preRangeStart = range.cloneRange();
				preRangeStart.selectNodeContents(editor);
				preRangeStart.setEnd(range.startContainer, range.startOffset);
				const preRangeEnd = range.cloneRange();
				preRangeEnd.selectNodeContents(editor);
				preRangeEnd.setEnd(range.endContainer, range.endOffset);

				selectionStart = mapRenderedToRaw(preRangeStart.toString().length);
				selectionEnd = mapRenderedToRaw(preRangeEnd.toString().length);
			} else {
				const cursorPos = getCursorPosition();
				selectionStart = cursorPos;
				selectionEnd = cursorPos;
			}

			if (e.inputType === 'insertText' && e.data) {
				e.preventDefault();
				window.realText = window.realText.slice(0, selectionStart) + e.data + window.realText.slice(selectionEnd);
				updatePreview();
				const newCursorPos = mapRawToRendered(selectionStart + e.data.length);
				setCursorPosition(newCursorPos);
			} else if (e.inputType === 'deleteContentBackward') {
				e.preventDefault();
				if (hasSelection) {
					window.realText = window.realText.slice(0, selectionStart) + window.realText.slice(selectionEnd);
					updatePreview();
					const newCursorPos = mapRawToRendered(selectionStart);
					setCursorPosition(newCursorPos);
				} else if (selectionStart > 0) {
					// Single character deletion
					window.realText = window.realText.slice(0, selectionStart - 1) + window.realText.slice(selectionStart);
					updatePreview();
					const newCursorPos = mapRawToRendered(selectionStart - 1);
					setCursorPosition(newCursorPos);
				}
			} else if (e.inputType === 'deleteWordBackward') {
				e.preventDefault();
				if (hasSelection) {
					window.realText = window.realText.slice(0, selectionStart) + window.realText.slice(selectionEnd);
					updatePreview();
					const newCursorPos = mapRawToRendered(selectionStart);
					setCursorPosition(newCursorPos);
				} else if (selectionStart > 0) {
					// selectionStart is already a RAW position from getCursorPosition()
					let deleteFrom = selectionStart - 1;

					// If we're on whitespace, skip it
					if (/\\s/.test(window.realText\[deleteFrom\])) {
						while (deleteFrom >= 0 && /\\s/.test(window.realText\[deleteFrom\])) {
							deleteFrom--;
						}
					}

					// Now we're at the last character of a word (or -1)
					// Delete back to the start of this word only
					while (deleteFrom >= 0 && !/\\s/.test(window.realText\[deleteFrom\])) {
						deleteFrom--;
					}

					// deleteFrom is now pointing at whitespace before the word (or -1)
					deleteFrom++;

					// Delete from RAW text
					window.realText = window.realText.slice(0, deleteFrom) + window.realText.slice(selectionStart);
					updatePreview();

					// Convert the new RAW position to rendered position for cursor
					const newCursorPos = mapRawToRendered(deleteFrom);
					setCursorPosition(newCursorPos);
				}
			} else if (e.inputType === 'deleteWordForward') {
				e.preventDefault();
				if (hasSelection) {
					window.realText = window.realText.slice(0, selectionStart) + window.realText.slice(selectionEnd);
					updatePreview();
					const newCursorPos = mapRawToRendered(selectionStart);
					setCursorPosition(newCursorPos);
				} else if (selectionStart < window.realText.length) {
					// Work with RAW cursor position in realText
					let rawCursor = selectionStart;
					let deleteTo = rawCursor;

					// Skip any whitespace immediately after cursor in RAW text
					while (deleteTo < window.realText.length && /\\s/.test(window.realText\[deleteTo\])) {
						deleteTo++;
					}

					// Delete non-whitespace characters (the word) in RAW text
					while (deleteTo < window.realText.length && !/\\s/.test(window.realText\[deleteTo\])) {
						deleteTo++;
					}

					// Delete from RAW text
					window.realText = window.realText.slice(0, rawCursor) + window.realText.slice(deleteTo);
					updatePreview();

					// Convert the RAW position to rendered position for cursor
					const newCursorPos = mapRawToRendered(rawCursor);
					setCursorPosition(newCursorPos);
				}
			} else if (e.inputType === 'deleteContentForward') {
				e.preventDefault();
				if (hasSelection) {
					window.realText = window.realText.slice(0, selectionStart) + window.realText.slice(selectionEnd);
					updatePreview();
					const newCursorPos = mapRawToRendered(selectionStart);
					setCursorPosition(newCursorPos);
				} else if (selectionStart < window.realText.length) {
					window.realText = window.realText.slice(0, selectionStart) + window.realText.slice(selectionStart + 1);
					updatePreview();
					const newCursorPos = mapRawToRendered(selectionStart);
					setCursorPosition(newCursorPos);
				}
			} else if (e.inputType === 'insertLineBreak') {
				e.preventDefault();
				window.realText = window.realText.slice(0, selectionStart) + '\\n' + window.realText.slice(selectionEnd);
				updatePreview();
				const newCursorPos = mapRawToRendered(selectionStart + 1);
				setCursorPosition(newCursorPos);
			} else if (e.inputType === 'insertFromPaste') {
				e.preventDefault();
				const pastedText = e.dataTransfer ? e.dataTransfer.getData('text/plain') : '';
				window.realText = window.realText.slice(0, selectionStart) + pastedText + window.realText.slice(selectionEnd);
				updatePreview();
				const newCursorPos = mapRawToRendered(selectionStart + pastedText.length);
				setCursorPosition(newCursorPos);
			}

			updateWindowSize();

			if (!quietChannels.includes(window.currentChannel)) {
				const now = Date.now();

				// Only send if enough time has passed since last call
				if (now - window.lastTypingCall >= window.TYPING_THROTTLE) {
					window.lastTypingCall = now;
					window.location = 'byond://?src=' + encodeURIComponent('[ref(src)]') + ';action=typing';
				}

				// Clear any existing timeout
				if (window.typingTimeout) {
					clearTimeout(window.typingTimeout);
				}

				// Set a timeout to send one final "typing" call after user stops
				window.typingTimeout = setTimeout(function() {
					window.lastTypingCall = Date.now();
					window.location = 'byond://?src=' + encodeURIComponent('[ref(src)]') + ';action=typing';
				}, window.TYPING_THROTTLE);
			}
		});

		editor.addEventListener('keydown', function(e) {
			if (!window.windowOpen) {
				window.location = 'byond://winset?id=:map&focus=true';
				closeWindow()
				e.preventDefault();
				e.stopPropagation();
				e.stopImmediatePropagation();
				return false;
			}

			if (e.key === 'Enter') {
				e.preventDefault();
				submitEntry();
			} else if (e.key === 'Escape') {
				e.preventDefault();
				closeWindow();
			} else if (e.key === 'Tab') {
				e.preventDefault();
				cycleChannel();
			} else if (e.key === 'ArrowUp') {
				e.preventDefault();
				if (window.historyIndex === -1 && window.realText) {
					window.tempMessage = window.realText;
				}
				if (window.historyIndex < window.chatHistory.length - 1) {
					window.historyIndex++;
					window.realText = window.chatHistory\[window.historyIndex\];
					editor.textContent = window.realText;
					button.textContent = (window.historyIndex + 1).toString();
					updatePreview();
					updateWindowSize();
				}
			} else if (e.key === 'ArrowDown') {
				e.preventDefault();
				if (window.historyIndex > 0) {
					window.historyIndex--;
					window.realText = window.chatHistory\[window.historyIndex\];
					editor.textContent = window.realText;
					button.textContent = (window.historyIndex + 1).toString();
					updatePreview();
					updateWindowSize();
				} else if (window.historyIndex === 0) {
					window.historyIndex = -1;
					window.realText = window.tempMessage;
					editor.textContent = window.realText;
					window.tempMessage = '';
					button.textContent = window.currentChannel;
					updatePreview();
					updateWindowSize();
				}
			} else if ((e.key === 'Backspace' || e.key === 'Delete') && window.realText.length === 0) {
				if (window.historyIndex !== -1) {
					window.historyIndex = -1;
					button.textContent = window.currentChannel;
				}
			}
		});

		editor.addEventListener('keypress', function(e) {
			if (!window.windowOpen) {
				e.preventDefault();
				e.stopPropagation();
				return false;
			}
		});

		// Block ALL keyboard events at document level when closed
		document.addEventListener('keydown', function(e) {
			if (!window.windowOpen) {
				window.location = 'byond://winset?id=:map&focus=true';
				closeWindow();
				e.preventDefault();
				e.stopPropagation();
				e.stopImmediatePropagation();
				return false;
			}
		}, true);

		document.addEventListener('keyup', function(e) {
			if (!window.windowOpen) {
				e.preventDefault();
				e.stopPropagation();
				e.stopImmediatePropagation();
				return false;
			}
		}, true);

		document.addEventListener('keypress', function(e) {
			if (!window.windowOpen) {
				e.preventDefault();
				e.stopPropagation();
				e.stopImmediatePropagation();
				return false;
			}
		}, true);

		window.openSayWindow = openWindow;
		window.cycleToChannel = cycleToChannel;
	</script>
</body>
</html>"}

/datum/native_say/Topic(href, href_list)
	. = ..()
	if(href_list["action"])
		switch(href_list["action"])
			if("open")
				handle_open(href_list["channel"])
			if("close")
				handle_close()
			if("entry")
				handle_entry(href_list["channel"], href_list["entry"])
			if("thinking")
				handle_thinking(text2num(href_list["visible"]))
			if("typing")
				handle_typing()

/datum/native_say/proc/handle_open(channel_name)
	window_open = TRUE

	for(var/datum/say_channel/channel in available_channels)
		if(channel.name == channel_name)
			current_channel = channel
			break

	if(current_channel && !current_channel.quiet)
		start_thinking()

/datum/native_say/proc/handle_close()
	window_open = FALSE
	stop_thinking()

/datum/native_say/proc/handle_entry(channel_name, entry)
	if(!entry || length(entry) > max_length)
		return FALSE

	var/datum/say_channel/channel
	for(var/datum/say_channel/ch in available_channels)
		if(ch.name == channel_name)
			channel = ch
			break

	if(!channel)
		return FALSE

	channel.send(client, entry) // this is so we can add new channels for languages

	handle_close()
	return TRUE

/datum/native_say/proc/handle_thinking(visible)
	if(visible)
		start_thinking()
	else
		stop_thinking()

/datum/native_say/proc/handle_typing()
	if(window_open)
		start_typing()

/datum/native_say/proc/start_thinking()
	if(!window_open)
		return FALSE
	return client.start_thinking()

/datum/native_say/proc/stop_thinking()
	return client.stop_thinking()

/datum/native_say/proc/start_typing()
	if(!window_open)
		return FALSE
	return client.start_typing()

/datum/native_say/proc/open_say_window(channel_name)
	if(window_open)
		// Use the same focus logic as the Tab macro

		winset(client, "native_say", "focus=true")
		winset(client, "native_say.browser", "focus=true")
		client << output(null, "native_say.browser:editor.focus()")

		if(channel_name)
			client << output(null, "native_say.browser:cycleToChannel('[channel_name]')")
		return

	var/datum/say_channel/channel = current_channel
	if(channel_name)
		for(var/datum/say_channel/ch in available_channels)
			if(ch.name == channel_name)
				channel = ch
				break
	if(!channel && available_channels.len > 0)
		channel = available_channels[1]
	if(channel)
		window_open = TRUE

		var/scale = 1
		if(client?.window_scaling)
			scale = client?.window_scaling
		winset(client, "native_say", "size=[window_width * scale]x[window_sizes["small"] * scale];is-visible=1;focus=true")
		client << output(null, "native_say.browser:openSayWindow('[channel.name]')")

		winset(client, "native_say", "focus=true")
		winset(client, "native_say.browser", "focus=true")
		client << output(null, "native_say.browser:editor.focus()")

/datum/native_say/proc/force_say()
	client << output(null, "native_say.browser:submitEntry()")
	client.stop_typing()

/datum/native_say/proc/refresh_channels()
	fetch_channels()

	//we need to handle this
	if(window_open)
		handle_close()
	if(available_channels.len > 0 && (!current_channel || !(current_channel in available_channels)))
		current_channel = available_channels[1]
		current_channel_index = 1
	reload_ui()
