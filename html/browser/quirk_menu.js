function setCookie(name, value, days) {
	var expires = "";
	if (days) {
		var date = new Date();
		date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
		expires = "; expires=" + date.toUTCString();
	}
	document.cookie = name + "=" + encodeURIComponent(value || "") + expires + "; path=/";
}

function getCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for (var i = 0; i < ca.length; i++) {
		var c = ca[i];
		while (c.charAt(0) == ' ') c = c.substring(1, c.length);
		if (c.indexOf(nameEQ) == 0) return decodeURIComponent(c.substring(nameEQ.length, c.length));
	}
	return null;
}

// Handle quirk customization dropdown changes
function updateQuirkCustomization(selectElement) {
	var quirkRef = selectElement.getAttribute('data-quirk');
	var selectedValue = selectElement.value;

	if (!quirkRef || !selectedValue) {
		return;
	}

	console.log('Updating quirk customization:', quirkRef, selectedValue);

	// Save state before navigation
	saveState();

	// Navigate to update customization
	window.location.href = '?quirk_customize=' + quirkRef + '&value=' + encodeURIComponent(selectedValue);
}

// Handle text input changes
function updateQuirkText(inputElement) {
	var quirkRef = inputElement.getAttribute('data-quirk');
	var textValue = inputElement.value;

	if (!quirkRef) {
		return;
	}

	console.log('Updating quirk text:', quirkRef, textValue);

	// Save state before navigation
	saveState();

	// Navigate to update customization
	window.location.href = '?quirk_customize=' + quirkRef + '&value=' + encodeURIComponent(textValue);
}

// Debounced text update (optional - for auto-saving as user types)
var textUpdateTimeout;
function updateQuirkTextDebounced(inputElement) {
	clearTimeout(textUpdateTimeout);
	textUpdateTimeout = setTimeout(function() {
		var quirkRef = inputElement.getAttribute('data-quirk');
		var textValue = inputElement.value;

		if (!quirkRef) {
			return;
		}

		console.log('Auto-saving quirk text:', quirkRef, textValue);

		// Use the non-reloading endpoint for smoother experience
		window.location.href = '?quirk_text_update=' + quirkRef + '&text=' + encodeURIComponent(textValue);
	}, 1000); // Wait 1 second after user stops typing
}

// Restore state from cookies
function restoreStateImmediate() {
	console.log('Restoring state...');

	// Restore active tab
	var savedTab = getCookie('quirk_active_tab');
	console.log('Saved tab:', savedTab);

	if (savedTab) {
		var tabButtons = document.querySelectorAll('.tab-button');
		var tabPanels = document.querySelectorAll('.tab-panel');

		tabButtons.forEach(function(btn) {
			if (btn.getAttribute('data-tab') === savedTab) {
				btn.classList.add('active');
			} else {
				btn.classList.remove('active');
			}
		});

		tabPanels.forEach(function(panel) {
			if (panel.id === 'tab-' + savedTab) {
				panel.classList.add('active');
				panel.style.display = 'block';
			} else {
				panel.classList.remove('active');
				panel.style.display = 'none';
			}
		});
	}

	// Restore scroll positions
	var scrollStateStr = getCookie('quirk_scroll_state');
	console.log('Saved scroll state:', scrollStateStr);

	if (scrollStateStr) {
		try {
			var scrollState = JSON.parse(scrollStateStr);

			// Restore tab scroll positions
			for (var tabName in scrollState) {
				if (tabName === 'selected') {
					var selectedPanel = document.getElementById('selected-panel');
					if (selectedPanel && scrollState[tabName]) {
						selectedPanel.scrollTop = parseInt(scrollState[tabName]);
						console.log('Restored selected scroll to:', scrollState[tabName]);
					}
				} else {
					var panel = document.getElementById('tab-' + tabName);
					if (panel && scrollState[tabName]) {
						panel.scrollTop = parseInt(scrollState[tabName]);
						console.log('Restored ' + tabName + ' scroll to:', scrollState[tabName]);
					}
				}
			}
		} catch (e) {
			console.error('Error restoring scroll state:', e);
		}
	}
}

// Save state to cookies
function saveState() {
	console.log('Saving state...');

	// Save active tab
	var activeTab = document.querySelector('.tab-button.active');
	if (activeTab) {
		var tabName = activeTab.getAttribute('data-tab');
		setCookie('quirk_active_tab', tabName, 7);
		console.log('Saved active tab:', tabName);
	}

	// Save scroll positions
	var scrollState = {};

	// Save each tab's scroll position
	var tabs = ['boons', 'vices', 'peculiarities'];
	tabs.forEach(function(tabName) {
		var panel = document.getElementById('tab-' + tabName);
		if (panel) {
			scrollState[tabName] = panel.scrollTop;
			console.log('Saved ' + tabName + ' scroll:', panel.scrollTop);
		}
	});

	// Save selected panel scroll position
	var selectedPanel = document.getElementById('selected-panel');
	if (selectedPanel) {
		scrollState['selected'] = selectedPanel.scrollTop;
		console.log('Saved selected scroll:', selectedPanel.scrollTop);
	}

	setCookie('quirk_scroll_state', JSON.stringify(scrollState), 7);
}

restoreStateImmediate();

document.addEventListener('DOMContentLoaded', function() {
	console.log('DOM Content Loaded');

	setTimeout(function() {
		restoreStateImmediate();
	}, 10);

	var tabButtons = document.querySelectorAll('.tab-button');
	tabButtons.forEach(function(button) {
		button.addEventListener('click', function() {
			console.log('Tab clicked');

			var tabName = this.getAttribute('data-tab');

			tabButtons.forEach(function(btn) {
				btn.classList.remove('active');
			});
			this.classList.add('active');

			var tabPanels = document.querySelectorAll('.tab-panel');
			tabPanels.forEach(function(panel) {
				panel.classList.remove('active');
				panel.style.display = 'none';
			});

			var targetPanel = document.getElementById('tab-' + tabName);
			if (targetPanel) {
				targetPanel.classList.add('active');
				targetPanel.style.display = 'block';
			}

			// Save the new tab state immediately
			saveState();
		});
	});

	// Quirk card clicking
	document.addEventListener('click', function(e) {
		// Check if clicked on a select element, text input, or within customization area
		if (e.target.closest('.quirk-customization') ||
		    e.target.classList.contains('quirk-select') ||
		    e.target.classList.contains('quirk-text-input')) {
			// Let the input/select handle its own events
			return;
		}

		var card = e.target.closest('.quirk-card');
		if (!card) return;

		// Don't do anything if disabled
		if (card.classList.contains('disabled')) {
			return;
		}

		var quirkRef = card.getAttribute('data-quirk');
		if (!quirkRef) return;

		console.log('Quirk card clicked, saving state...');

		// Save state before navigation
		saveState();

		// Determine if adding or removing
		var isSelected = card.classList.contains('selected');
		var action = isSelected ? 'quirk_remove' : 'quirk_add';

		// Navigate to update
		window.location.href = '?' + action + '=' + quirkRef;
	});

	// Handle select changes (prevent event bubbling)
	document.addEventListener('change', function(e) {
		if (e.target.classList.contains('quirk-select')) {
			e.stopPropagation();
			updateQuirkCustomization(e.target);
		} else if (e.target.classList.contains('quirk-text-input')) {
			e.stopPropagation();
			updateQuirkText(e.target);
		}
	});

	// Optional: Auto-save text inputs as user types (with debounce)
	// Uncomment the following to enable auto-save:
	/*
	document.addEventListener('input', function(e) {
		if (e.target.classList.contains('quirk-text-input')) {
			updateQuirkTextDebounced(e.target);
		}
	});
	*/

	// Save scroll positions as user scrolls
	var saveScrollTimeout;
	function scheduleScrollSave() {
		clearTimeout(saveScrollTimeout);
		saveScrollTimeout = setTimeout(function() {
			saveState();
		}, 200);
	}

	var tabPanels = document.querySelectorAll('.tab-panel');
	tabPanels.forEach(function(panel) {
		panel.addEventListener('scroll', scheduleScrollSave);
	});

	var selectedPanel = document.getElementById('selected-panel');
	if (selectedPanel) {
		selectedPanel.addEventListener('scroll', scheduleScrollSave);
	}

	window.addEventListener('beforeunload', function() {
		saveState();
	});
});
