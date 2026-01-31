
/*****************************************
*
* FUNCTION AND VAR DECLARATIONS
*
******************************************/

//DEBUG STUFF
var escaper = encodeURIComponent || escape;
var decoder = decodeURIComponent || unescape;
window.onerror = function(msg, url, line, col, error) {
	if (document.location.href.indexOf("proc=debug") <= 0) {
		var extra = !col ? '' : ' | column: ' + col;
		extra += !error ? '' : ' | error: ' + error;
		extra += !navigator.userAgent ? '' : ' | user agent: ' + navigator.userAgent;
		var debugLine = 'Error: ' + msg + ' | url: ' + url + ' | line: ' + line + extra;
		window.location = '?_src_=chat&proc=debug&param[error]='+escaper(debugLine);
	}
	return true;
};

//Globals
var messageQueue = {
    messages: [],
    processing: false,
    batchSize: 10, // Process this many at once
    batchDelay: 16, // ~60fps

    add: function(message, flag) {
        this.messages.push({message: message, flag: flag});
        if (!this.processing) {
            this.processing = true;
            requestAnimationFrame(() => this.processBatch());
        }
    },

    processBatch: function() {
        if (this.messages.length === 0) {
            this.processing = false;
            return;
        }

        // Process up to batchSize messages
        var batch = this.messages.splice(0, this.batchSize);
        var fragment = document.createDocumentFragment();
        var atBottom = this.checkIfAtBottom();

        // Process all messages in batch
        batch.forEach(item => {
            var entry = this.createMessageElement(item.message, item.flag);
            if (entry) {
                fragment.appendChild(entry);
            }
        });

        // Apply highlights BEFORE appending to DOM (more efficient)
        if (window.highlightSystem && highlightSystem.filters && highlightSystem.filters.length > 0) {
            this.batchHighlight(fragment);
        }

        // Apply linkify and other processing
        var entries = Array.prototype.slice.call(fragment.children);
        entries.forEach(function(entry) {
            // Linkify
            var to_linkify = entry.querySelectorAll ? entry.querySelectorAll('.linkify') : [];
            if (typeof Node === 'undefined') {
                for(var i = 0; i < to_linkify.length; ++i) {
                    to_linkify[i].innerHTML = linkify_fallback(to_linkify[i].innerHTML);
                }
            } else {
                for(var i = 0; i < to_linkify.length; ++i) {
                    linkify_node(to_linkify[i]);
                }
            }

            // Icon error handlers
            var icons = entry.querySelectorAll ? entry.querySelectorAll('img.icon') : [];
            for(var i = 0; i < icons.length; i++) {
                icons[i].addEventListener('error', iconError);
            }

            // Replace regex
            var replaceElements = entry.querySelectorAll ? entry.querySelectorAll('[replaceRegex]') : [];
            for(var i = 0; i < replaceElements.length; i++) {
                var selectedRegex = replaceRegexes[replaceElements[i].getAttribute('replaceRegex')];
                if (selectedRegex) {
                    var replacedText = replaceElements[i].innerHTML.replace(selectedRegex[0], selectedRegex[1]);
                    replaceElements[i].innerHTML = replacedText;
                }
                replaceElements[i].removeAttribute('replaceRegex');
            }
        });

        // Single DOM append for entire batch
        $messages[0].appendChild(fragment);

        // Cleanup old messages in one go
        this.cleanupOldMessages();

        // Handle scroll once
        if (atBottom) {
            this.scrollToBottom();
        }

        // Continue processing if more messages
        if (this.messages.length > 0) {
            setTimeout(() => requestAnimationFrame(() => this.processBatch()), this.batchDelay);
        } else {
            this.processing = false;
        }
    },

    checkIfAtBottom: function() {
        var bodyHeight = window.innerHeight;
        var messagesHeight = $messages[0].scrollHeight;
        var scrollPos = window.pageYOffset || document.documentElement.scrollTop;
        return bodyHeight + scrollPos >= messagesHeight - opts.scrollSnapTolerance;
    },

    scrollToBottom: function() {
        // Use RAF for smooth scroll
        requestAnimationFrame(() => {
            $('body,html').scrollTop($messages.outerHeight());
        });
    },

    createMessageElement: function(message, flag) {
        if (typeof message === 'undefined') return null;

        message = byondDecode(message).trim();

        var entry = document.createElement('div');
        entry.innerHTML = message;
        entry.className = 'entry';

        opts.messageCount++;

        // Apply filter efficiently
        this.quickFilterCheck(entry);

        return entry;
    },

    quickFilterCheck: function(entry) {
        // Fast path for 'all' filter
        if (opts.currentFilter === 'all') return;

        // Cache class list as string for faster searching
        var classStr = ' ' + entry.className + ' ';
        var innerHTML = entry.innerHTML;

        var shouldShow = classStr.indexOf(' ' + opts.currentFilter + ' ') !== -1 ||
                        innerHTML.indexOf('class="' + opts.currentFilter) !== -1;

        // Check custom tabs (optimized)
        if (!shouldShow && opts.customTabs && opts.customTabs.length > 0) {
            for (var i = 0; i < opts.customTabs.length; i++) {
                var tab = opts.customTabs[i];
                if (tab.name.toLowerCase() === opts.currentFilter) {
                    for (var j = 0; j < tab.classes.length; j++) {
                        if (classStr.indexOf(' ' + tab.classes[j] + ' ') !== -1 ||
                            innerHTML.indexOf('class="' + tab.classes[j]) !== -1) {
                            shouldShow = true;
                            break;
                        }
                    }
                    break;
                }
            }
        }

        if (!shouldShow) {
            entry.classList.add('filtered-hidden');
            entry.style.display = 'none';
        }
    },

    cleanupOldMessages: function() {
        while (opts.messageCount > opts.messageLimit) {
            var first = $messages[0].firstElementChild;
            if (first) {
                first.remove();
                opts.messageCount--;
            } else {
                break;
            }
        }
    },

    batchHighlight: function(fragment) {
        // Only highlight if filters are enabled
        if (!highlightSystem || !highlightSystem.filters) return;

        var enabledFilters = highlightSystem.filters.filter(f => f.enabled && f.term.trim());
        if (enabledFilters.length === 0) return;

        // Get entries - fragment is not yet in DOM so we need to iterate its children
        var entries;
        if (fragment.children) {
            entries = Array.prototype.slice.call(fragment.children);
        } else if (fragment.childNodes) {
            entries = Array.prototype.filter.call(fragment.childNodes, function(node) {
                return node.nodeType === 1; // Element nodes only
            });
        } else {
            return;
        }

        // Apply highlights to each entry
        entries.forEach(function(entry) {
            if (entry && entry.nodeType === 1) {
                highlightSystem.highlightElement(entry);
            }
        });
    }
};

var highlightSystem = {
    filters: [], // Array of {term: string, color: string, animation: string, enabled: boolean, id: string, soundEnabled: boolean}
    animations: {
        'none': 'No animation',
        'glow': 'Glow effect',
        'pulse': 'Pulse animation',
        'flash': 'Flash animation',
        'rainbow': 'Rainbow effect',
    },

    // Initialize the system
    init: function() {
        this.loadFilters();
        this.injectStyles();
    },

    // Inject required CSS styles
    injectStyles: function() {
        if (document.getElementById('highlightSystemStyles')) return;

        var style = document.createElement('style');
        style.id = 'highlightSystemStyles';
        style.textContent = `
            /* Fixed animations */
            @keyframes glow {
                0%, 100% {
                    box-shadow: 0 0 5px currentColor;
                    filter: brightness(1);
                }
                50% {
                    box-shadow: 0 0 20px currentColor, 0 0 30px currentColor;
                    filter: brightness(1.3);
                }
            }
            .highlight-glow {
                animation: glow 2s infinite;
                border-radius: 3px;
            }

            @keyframes pulse {
                0%, 100% {
                    transform: scale(1);
                    opacity: 1;
                }
                50% {
                    transform: scale(1.1);
                    opacity: 0.7;
                }
            }
            .highlight-pulse {
                animation: pulse 1.5s infinite;
                display: inline-block;
                border-radius: 3px;
            }

            @keyframes flash {
                0%, 50%, 100% { opacity: 1; }
                25%, 75% { opacity: 0.3; }
            }
            .highlight-flash {
                animation: flash 1s infinite;
                border-radius: 3px;
            }

            @keyframes bounce {
                0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
                40% { transform: translateY(-3px); }
                60% { transform: translateY(-2px); }
            }
            .highlight-bounce {
                animation: bounce 2s infinite;
                display: inline-block;
                border-radius: 3px;
            }

            @keyframes slide {
                0% { background-position: -200% 0; }
                100% { background-position: 200% 0; }
            }
            .highlight-slide {
                background: linear-gradient(90deg, transparent 30%, var(--highlight-color, #FFFF00) 50%, transparent 70%);
                background-size: 200% 100%;
                animation: slide 2s infinite;
                border-radius: 3px;
            }

            @keyframes rainbow {
                0% { background-color: #ff0000; color: white; }
                14% { background-color: #ff8000; color: white; }
                28% { background-color: #ffff00; color: black; }
                42% { background-color: #80ff00; color: black; }
                57% { background-color: #00ff80; color: black; }
                71% { background-color: #0080ff; color: white; }
                85% { background-color: #8000ff; color: white; }
                100% { background-color: #ff0000; color: white; }
            }
            .highlight-rainbow {
                animation: rainbow 3s infinite;
                font-weight: bold;
                border-radius: 3px;
                padding: 1px 2px;
            }

            /* Darkened popup styles */
            .popup {
                position: fixed;
                background: linear-gradient(135deg, #0f1419 0%, #1a1d23 100%);
                border: 2px solid #000000;
                border-radius: 12px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.8);
                z-index: 10000;
                width: 95vw;
                max-width: 600px;
                max-height: 85vh;
                color: #c9d1d9;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                display: flex;
                flex-direction: column;
                /* Smart positioning - will be set by JavaScript */
            }

            .popup .head {
                background: linear-gradient(135deg, #161b22, #21262d);
                padding: 15px 20px;
                border-radius: 10px 10px 0 0;
                font-size: 18px;
                font-weight: bold;
                text-align: center;
                position: relative;
                flex-shrink: 0;
            }

            .popup .close {
                position: absolute;
                top: 10px;
                right: 15px;
                font-size: 24px;
                text-decoration: none;
                color: #c9d1d9;
                opacity: 0.7;
                transition: opacity 0.3s ease;
                width: 30px;
                height: 30px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 50%;
                background: rgba(255,255,255,0.05);
            }

            .popup .close:hover {
                opacity: 1;
                background: rgba(255,255,255,0.1);
            }

            .highlight-manager {
                padding: 15px;
                flex: 1;
                overflow: hidden;
                display: flex;
                flex-direction: column;
            }

            #highlightFilters {
                flex: 1;
                overflow-y: auto;
                margin-bottom: 15px;
                padding-right: 8px;
                max-height: 400px;
            }

            /* Custom scrollbar - darker */
            #highlightFilters::-webkit-scrollbar {
                width: 6px;
            }

            #highlightFilters::-webkit-scrollbar-track {
                background: rgba(0, 0, 0, 0.3);
                border-radius: 3px;
            }

            #highlightFilters::-webkit-scrollbar-thumb {
                background: rgba(100, 100, 100, 0.4);
                border-radius: 3px;
            }

            #highlightFilters::-webkit-scrollbar-thumb:hover {
                background: rgba(120, 120, 120, 0.6);
            }

            .highlight-filter-item {
                background: rgba(0, 0, 0, 0.3);
                border: 1px solid rgba(100, 100, 100, 0.2);
                border-radius: 8px;
                padding: 12px;
                margin-bottom: 12px;
                transition: all 0.3s ease;
            }

            .highlight-filter-item:hover {
                background: rgba(0, 0, 0, 0.4);
                border-color: rgba(120, 120, 120, 0.3);
            }

            /* Main row for term input and color */
            .filter-main-row {
                display: flex;
                gap: 8px;
                margin-bottom: 8px;
                align-items: center;
            }

            .filter-term-input {
                flex: 1;
                min-width: 0;
            }

            .filter-color-input {
                flex-shrink: 0;
            }

            /* Controls row for animation, toggles, and remove */
            .filter-controls-row {
                display: flex;
                gap: 6px;
                flex-wrap: wrap;
                align-items: center;
            }

            .filter-animation-select {
                flex: 1;
                min-width: 100px;
            }

            .filter-buttons {
                display: flex;
                gap: 4px;
                flex-shrink: 0;
            }

            .highlight-filter-item input[type="text"] {
                background: rgba(0, 0, 0, 0.6);
                border: 1px solid rgba(80, 80, 80, 0.4);
                border-radius: 4px;
                padding: 6px 8px;
                font-size: 13px;
                color: #c9d1d9;
                transition: border-color 0.3s ease;
                width: 100%;
                box-sizing: border-box;
            }

            .highlight-filter-item input[type="text"]:focus {
                outline: none;
                border-color: rgba(120, 120, 120, 0.6);
                box-shadow: 0 0 3px rgba(80, 80, 80, 0.5);
            }

            .highlight-filter-item input[type="color"] {
                width: 40px;
                height: 32px;
                border: 2px solid rgba(80, 80, 80, 0.4);
                border-radius: 4px;
                cursor: pointer;
                background: rgba(0, 0, 0, 0.5);
                transition: border-color 0.3s ease;
            }

            .highlight-filter-item input[type="color"]:hover {
                border-color: rgba(120, 120, 120, 0.6);
            }

            .highlight-filter-item select {
                background: rgba(0, 0, 0, 0.6);
                border: 1px solid rgba(80, 80, 80, 0.4);
                border-radius: 4px;
                padding: 6px;
                font-size: 12px;
                color: #c9d1d9;
                cursor: pointer;
                transition: border-color 0.3s ease;
            }

            .highlight-filter-item select:focus {
                outline: none;
                border-color: rgba(120, 120, 120, 0.6);
            }

            .highlight-filter-item button {
                background: rgba(30, 90, 130, 0.3);
                border: 1px solid rgba(30, 90, 130, 0.5);
                border-radius: 4px;
                padding: 4px 8px;
                color: #c9d1d9;
                cursor: pointer;
                font-size: 10px;
                font-weight: bold;
                transition: all 0.3s ease;
                white-space: nowrap;
                min-width: 35px;
            }

            .highlight-filter-item button:hover {
                background: rgba(30, 90, 130, 0.4);
                transform: translateY(-1px);
            }

            .toggle-btn.enabled {
                background: rgba(25, 130, 70, 0.4) !important;
                border-color: rgba(25, 130, 70, 0.7) !important;
                color: #40d47e !important;
            }

            .remove-btn:hover {
                background: rgba(150, 40, 30, 0.4) !important;
                border-color: rgba(150, 40, 30, 0.7) !important;
                color: #ff6b6b !important;
            }

            .sound-btn.enabled {
                background: rgba(160, 120, 10, 0.4) !important;
                border-color: rgba(160, 120, 10, 0.7) !important;
                color: #ffd93d !important;
            }

            .highlight-controls {
                display: flex;
                gap: 8px;
                flex-wrap: wrap;
                justify-content: center;
                padding-top: 12px;
                border-top: 1px solid rgba(80, 80, 80, 0.3);
                flex-shrink: 0;
            }

            .add-filter-btn {
                background: rgba(25, 130, 70, 0.3);
                border: 1px solid rgba(25, 130, 70, 0.5);
                border-radius: 6px;
                padding: 8px 12px;
                color: #c9d1d9;
                cursor: pointer;
                font-size: 12px;
                font-weight: bold;
                transition: all 0.3s ease;
                white-space: nowrap;
            }

            .add-filter-btn:hover {
                background: rgba(25, 130, 70, 0.4);
                transform: translateY(-1px);
                box-shadow: 0 3px 8px rgba(25, 130, 70, 0.4);
            }

            .no-filters-message {
                text-align: center;
                padding: 30px 15px;
                color: rgba(201, 209, 217, 0.4);
                font-style: italic;
            }

            /* Mobile-specific styles */
            @media (max-width: 600px) {
                .popup {
                    width: 98vw;
                    max-height: 95vh;
                    margin: 0;
                }

                .popup .head {
                    font-size: 16px;
                    padding: 12px 15px;
                }

                .highlight-manager {
                    padding: 10px;
                }

                .filter-controls-row {
                    flex-direction: column;
                    align-items: stretch;
                }

                .filter-buttons {
                    justify-content: space-between;
                    margin-top: 6px;
                }

                .highlight-filter-item button {
                    flex: 1;
                    padding: 8px 4px;
                    font-size: 9px;
                }

                .highlight-controls {
                    flex-direction: column;
                    gap: 6px;
                }

                .add-filter-btn {
                    font-size: 11px;
                    padding: 10px;
                }
            }

            /* Very small screens */
            @media (max-width: 400px) {
                .filter-main-row {
                    flex-direction: column;
                    align-items: stretch;
                }

                .filter-color-input {
                    align-self: center;
                }

                .highlight-filter-item input[type="color"] {
                    width: 60px;
                    height: 35px;
                }
            }
        `;
        document.head.appendChild(style);
    },

    // Generate unique ID for filters
    generateId: function() {
        return 'highlight_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
    },

    // Add a new highlight filter
    addFilter: function(term, color = '#FFFF00', animation = 'none') {
		var filter = {
			id: this.generateId(),
			term: term.toLowerCase(),
			color: color,
			animation: animation,
			enabled: true,
			soundEnabled: false,
			soundType: 'beep',
			customSoundUrl: '' // Changed from customSound to customSoundUrl
		};
		this.filters.push(filter);
		this.saveFilters();
		return filter;
	},


    // Remove a filter by ID
    removeFilter: function(id) {
        this.filters = this.filters.filter(f => f.id !== id);
        this.saveFilters();
    },

    // Update a filter
    updateFilter: function(id, updates) {
        var filter = this.filters.find(f => f.id === id);
        if (filter) {
            Object.assign(filter, updates);
            if (updates.term) {
                filter.term = updates.term.toLowerCase();
            }
            this.saveFilters();
        }
    },

    // Toggle filter enabled state
    toggleFilter: function(id) {
        var filter = this.filters.find(f => f.id === id);
        if (filter) {
            filter.enabled = !filter.enabled;
            this.saveFilters();
        }
    },

    // Toggle sound for filter
    toggleSound: function(id) {
        var filter = this.filters.find(f => f.id === id);
        if (filter) {
            filter.soundEnabled = !filter.soundEnabled;
            this.saveFilters();
        }
    },

    // Play sound notification
    playSound: function(filter) {
		try {
			if (filter && filter.customSoundUrl && filter.soundType === 'custom') {
				// Play custom audio from URL
				var audio = new Audio(filter.customSoundUrl);
				audio.volume = 0.5;
				audio.play().catch(e => console.warn('Custom sound failed:', e));
			} else {
				// Use built-in sound based on soundType
				var audioContext = new (window.AudioContext || window.webkitAudioContext)();
				var oscillator = audioContext.createOscillator();
				var gainNode = audioContext.createGain();

				oscillator.connect(gainNode);
				gainNode.connect(audioContext.destination);

				var soundType = (filter && filter.soundType) || 'beep';

				switch(soundType) {
					case 'beep':
						oscillator.frequency.value = 800;
						oscillator.type = 'sine';
						gainNode.gain.setValueAtTime(0, audioContext.currentTime);
						gainNode.gain.linearRampToValueAtTime(0.3, audioContext.currentTime + 0.01);
						gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.3);
						oscillator.start(audioContext.currentTime);
						oscillator.stop(audioContext.currentTime + 0.3);
						break;
					case 'chime':
						oscillator.frequency.value = 1200;
						oscillator.type = 'sine';
						gainNode.gain.setValueAtTime(0, audioContext.currentTime);
						gainNode.gain.linearRampToValueAtTime(0.2, audioContext.currentTime + 0.01);
						gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.8);
						oscillator.start(audioContext.currentTime);
						oscillator.stop(audioContext.currentTime + 0.8);
						break;
					case 'pop':
						oscillator.frequency.value = 400;
						oscillator.type = 'square';
						gainNode.gain.setValueAtTime(0, audioContext.currentTime);
						gainNode.gain.linearRampToValueAtTime(0.4, audioContext.currentTime + 0.01);
						gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.1);
						oscillator.start(audioContext.currentTime);
						oscillator.stop(audioContext.currentTime + 0.1);
						break;
					case 'ding':
						oscillator.frequency.value = 1800;
						oscillator.type = 'triangle';
						gainNode.gain.setValueAtTime(0, audioContext.currentTime);
						gainNode.gain.linearRampToValueAtTime(0.25, audioContext.currentTime + 0.01);
						gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.5);
						oscillator.start(audioContext.currentTime);
						oscillator.stop(audioContext.currentTime + 0.5);
						break;
				}
			}
		} catch (e) {
			console.warn('Sound notification failed:', e);
		}
	},

    // Apply highlights to an element
    highlightElement: function(element) {
        if (!this.filters.length) return;

        var enabledFilters = this.filters.filter(f => f.enabled && f.term.trim());
        if (!enabledFilters.length) return;

        this.highlightTextNodes(element, enabledFilters);
    },

    // Recursively highlight text nodes
    highlightTextNodes: function(element, filters) {
        // Build combined regex for all filters at once
        var terms = filters.map(f => this.escapeRegex(f.term)).join('|');
        if (!terms) return;

        var regex = new RegExp('(' + terms + ')', 'gi');

        // Use faster tree walker
        var walker = document.createTreeWalker(
            element,
            NodeFilter.SHOW_TEXT,
            {
                acceptNode: function(node) {
                    var parent = node.parentNode;
                    if (parent.classList && parent.classList.contains('highlight-filter')) {
                        return NodeFilter.FILTER_REJECT;
                    }
                    if (parent.tagName === 'SCRIPT' || parent.tagName === 'STYLE') {
                        return NodeFilter.FILTER_REJECT;
                    }
                    // Quick check if text contains any terms
                    var text = node.textContent.toLowerCase();
                    for (var i = 0; i < filters.length; i++) {
                        if (text.indexOf(filters[i].term) !== -1) {
                            return NodeFilter.FILTER_ACCEPT;
                        }
                    }
                    return NodeFilter.FILTER_REJECT;
                }
            },
            false
        );

        var textNodes = [];
        var node;
        var maxNodes = 100; // Safety limit
        var count = 0;

        while (node = walker.nextNode()) {
            textNodes.push(node);
            if (++count > maxNodes) break;
        }

        // Process in chunks to avoid blocking
        if (textNodes.length > 10) {
            this.highlightInChunks(textNodes, filters, 0);
        } else {
            textNodes.forEach(textNode => {
                this.highlightTextNode(textNode, filters);
            });
        }
    },

    highlightInChunks: function(textNodes, filters, index) {
        var chunkSize = 5;
        var end = Math.min(index + chunkSize, textNodes.length);

        for (var i = index; i < end; i++) {
            this.highlightTextNode(textNodes[i], filters);
        }

        if (end < textNodes.length) {
            requestAnimationFrame(() => {
                this.highlightInChunks(textNodes, filters, end);
            });
        }
    },

    // Highlight matches in a single text node
    highlightTextNode: function(textNode, filters) {
        var text = textNode.textContent;
        var matches = [];

        // Find all matches
        filters.forEach(filter => {
            var regex = new RegExp(this.escapeRegex(filter.term), 'gi');
            var match;
            while ((match = regex.exec(text)) !== null) {
                matches.push({
                    start: match.index,
                    end: match.index + match[0].length,
                    filter: filter,
                    text: match[0]
                });

                // Play sound if enabled for this filter
                if (filter.soundEnabled) {
                    this.playSound(filter);
                }
            }
        });

        if (!matches.length) return;

        // Sort matches by position and remove overlaps
        matches.sort((a, b) => a.start - b.start);
        var cleanMatches = this.removeOverlaps(matches);

        if (!cleanMatches.length) return;

        // Create highlighted content
        var result = '';
        var lastEnd = 0;

        cleanMatches.forEach(match => {
            // Add text before match
            result += this.escapeHtml(text.substring(lastEnd, match.start));

            // Add highlighted match
            var animationClass = match.filter.animation !== 'none' ? `highlight-${match.filter.animation}` : '';
            var style = match.filter.animation === 'slide'
                ? `background-color: ${match.filter.color}; --highlight-color: ${match.filter.color};`
                : match.filter.animation === 'rainbow'
                ? '' // Rainbow uses its own colors
                : `background-color: ${match.filter.color};`;

            result += `<span class="highlight-filter ${animationClass}" style="${style}" data-filter-id="${match.filter.id}">`;
            result += this.escapeHtml(match.text);
            result += '</span>';

            lastEnd = match.end;
        });

        // Add remaining text
        result += this.escapeHtml(text.substring(lastEnd));

        // Replace the text node with highlighted content
        var wrapper = document.createElement('span');
        wrapper.innerHTML = result;
        textNode.parentNode.replaceChild(wrapper, textNode);
    },

    // Remove overlapping matches (prioritize first match)
    removeOverlaps: function(matches) {
        var result = [];
        var lastEnd = 0;

        matches.forEach(match => {
            if (match.start >= lastEnd) {
                result.push(match);
                lastEnd = match.end;
            }
        });

        return result;
    },

    // Escape regex special characters
    escapeRegex: function(string) {
        return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    },

    // Escape HTML
    escapeHtml: function(text) {
        var div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    },

    // Show the highlight manager popup
    showManager: function() {
        var content = this.createManagerHTML();
        if (typeof createPopup === 'function') {
            // Try to use existing createPopup function
            var popup = createPopup(content, 600);
            // If createPopup returns the popup element, apply smart positioning
            if (popup && popup.nodeType) {
                this.positionPopup(popup);
            }
        } else {
            // Fallback popup creation with smart positioning
            this.createFallbackPopup(content);
        }
        this.bindManagerEvents();
    },

    // Create manager HTML
    createManagerHTML: function() {
        var html = `
            <div class="head">
                Highlight Filter Manager
                <a href="#" class="close">&times;</a>
            </div>
            <div class="highlight-manager" id="highlightManager">
                <div id="highlightFilters">
                    ${this.createFiltersHTML()}
                </div>
                <div class="highlight-controls">
                    <button class="add-filter-btn" onclick="highlightSystem.addNewFilter()">Add Filter</button>
                    <button class="add-filter-btn" onclick="highlightSystem.exportFilters()">Export</button>
                    <input type="file" id="importFiltersInput" accept=".json" style="display: none;" onchange="highlightSystem.importFilters(this)">
                    <button class="add-filter-btn" onclick="document.getElementById('importFiltersInput').click()">Import</button>
                </div>
            </div>
        `;
        return html;
    },

    // Create HTML for existing filters
	createFiltersHTML: function() {
		if (!this.filters.length) {
			return '<div class="no-filters-message">No highlight filters configured.<br>Click "Add Filter" to get started!</div>';
		}

		return this.filters.map(filter => `
			<div class="highlight-filter-item" data-filter-id="${filter.id}">
				<div class="filter-main-row">
					<input type="text" class="filter-term-input" value="${this.escapeHtml(filter.term)}" placeholder="Search term"
						onchange="highlightSystem.updateFilterTerm('${filter.id}', this.value)">
					<input type="color" class="filter-color-input" value="${filter.color}"
						onchange="highlightSystem.updateFilterColor('${filter.id}', this.value)">
				</div>
				<div class="filter-controls-row">
					<select class="filter-animation-select" onchange="highlightSystem.updateFilterAnimation('${filter.id}', this.value)">
						${Object.entries(this.animations).map(([key, label]) =>
							`<option value="${key}" ${filter.animation === key ? 'selected' : ''}>${label}</option>`
						).join('')}
					</select>
					<div class="filter-buttons">
						<button class="toggle-btn ${filter.enabled ? 'enabled' : ''}"
								onclick="highlightSystem.toggleFilterInManager('${filter.id}')">
							${filter.enabled ? 'ON' : 'OFF'}
						</button>
						<button class="sound-btn ${filter.soundEnabled ? 'enabled' : ''}"
								onclick="highlightSystem.toggleSoundInManager('${filter.id}')" title="Sound notification">
							🔊
						</button>
						<button class="remove-btn" onclick="highlightSystem.removeFilterFromManager('${filter.id}')" title="Remove filter">
							✕
						</button>
					</div>
				</div>
				${filter.soundEnabled ? `
				<div class="sound-controls-row" style="margin-top: 8px; display: flex; gap: 6px; align-items: center;">
					<select class="sound-type-select" onchange="highlightSystem.updateSoundType('${filter.id}', this.value)" style="flex: 1;">
						<option value="beep" ${(filter.soundType || 'beep') === 'beep' ? 'selected' : ''}>Beep</option>
						<option value="chime" ${filter.soundType === 'chime' ? 'selected' : ''}>Chime</option>
						<option value="pop" ${filter.soundType === 'pop' ? 'selected' : ''}>Pop</option>
						<option value="ding" ${filter.soundType === 'ding' ? 'selected' : ''}>Ding</option>
						<option value="custom" ${filter.soundType === 'custom' ? 'selected' : ''}>Custom URL</option>
					</select>
					<button class="test-sound-btn" onclick="highlightSystem.testSound('${filter.id}')" title="Test sound">
						▶️
					</button>
					${filter.soundType === 'custom' ? `
					<input type="url" id="customSoundUrl_${filter.id}"
						value="${filter.customSoundUrl || ''}"
						placeholder="Enter audio URL"
						onchange="highlightSystem.updateCustomSoundUrl('${filter.id}', this.value)"
						style="flex: 2; background: rgba(0, 0, 0, 0.6); border: 1px solid rgba(80, 80, 80, 0.4);
								border-radius: 4px; padding: 6px 8px; font-size: 13px; color: #c9d1d9;">
					` : ''}
				</div>
				` : ''}
			</div>
		`).join('');
	},

	updateCustomSoundUrl: function(id, url) {
		this.updateFilter(id, { customSoundUrl: url });
	},

	updateSoundType: function(id, soundType) {
		this.updateFilter(id, { soundType: soundType });
		if (soundType !== 'custom') {
			this.updateFilter(id, { customSoundUrl: '' });
		}
		this.refreshManager();
	},

	testSound: function(id) {
		var filter = this.filters.find(f => f.id === id);
		if (filter) {
			this.playSound(filter);
		}
	},

	triggerFileUpload: function(id) {
		var input = document.getElementById('customSound_' + id);
		if (input) {
			input.click();
		}
	},

	uploadCustomSound: function(id, input) {
		var file = input.files[0];
		if (!file) return;

		if (!file.type.startsWith('audio/')) {
			alert('Please select an audio file');
			return;
		}

		var reader = new FileReader();
		reader.onload = (e) => {
			this.updateFilter(id, {
				customSound: e.target.result,
				soundType: 'custom'
			});
			input.value = ''; // Reset input
			// Show confirmation
			alert('Custom sound uploaded successfully!');
		};
		reader.readAsDataURL(file);
	},

    // Fallback popup creation
    createFallbackPopup: function(content) {
        var popup = document.createElement('div');
        popup.className = 'popup';
        popup.innerHTML = content;

        document.body.appendChild(popup);

        // Smart positioning to keep popup within viewport
        this.positionPopup(popup);

        // Handle window resize
        var resizeHandler = () => this.positionPopup(popup);
        window.addEventListener('resize', resizeHandler);

        popup.querySelector('.close').onclick = function(e) {
            e.preventDefault();
            window.removeEventListener('resize', resizeHandler);
            document.body.removeChild(popup);
        };
    },

    // Smart popup positioning
    positionPopup: function(popup) {
        // Get viewport dimensions
        var viewportWidth = window.innerWidth;
        var viewportHeight = window.innerHeight;

        // Get popup dimensions (after it's been added to DOM)
        var popupRect = popup.getBoundingClientRect();
        var popupWidth = popupRect.width || popup.offsetWidth;
        var popupHeight = popupRect.height || popup.offsetHeight;

        // Calculate ideal center position
        var idealLeft = (viewportWidth - popupWidth) / 2;
        var idealTop = (viewportHeight - popupHeight) / 2;

        // Ensure minimum margins from edges
        var margin = 10;
        var left = Math.max(margin, Math.min(idealLeft, viewportWidth - popupWidth - margin));
        var top = Math.max(margin, Math.min(idealTop, viewportHeight - popupHeight - margin));

        // Apply positioning
        popup.style.left = left + 'px';
        popup.style.top = top + 'px';
        popup.style.transform = 'none'; // Remove any existing transform

        // If popup is still too tall, make it scrollable
        if (popupHeight > viewportHeight - (margin * 2)) {
            popup.style.maxHeight = (viewportHeight - (margin * 2)) + 'px';
            popup.style.top = margin + 'px';
        }
    },

    // Bind events for manager
    bindManagerEvents: function() {
        // Events are handled by inline handlers in the HTML
    },

    // Manager event handlers
    addNewFilter: function() {
        this.addFilter('', '#FFFF00', 'none');
        this.refreshManager();
    },

    updateFilterTerm: function(id, term) {
        this.updateFilter(id, { term: term });
    },

    updateFilterColor: function(id, color) {
        this.updateFilter(id, { color: color });
    },

    updateFilterAnimation: function(id, animation) {
        this.updateFilter(id, { animation: animation });
    },

    toggleFilterInManager: function(id) {
        this.toggleFilter(id);
        this.refreshManager();
    },

    toggleSoundInManager: function(id) {
        this.toggleSound(id);
        this.refreshManager();
    },

    removeFilterFromManager: function(id) {
        if (confirm('Are you sure you want to remove this highlight filter?')) {
            this.removeFilter(id);
            this.refreshManager();
        }
    },

    // Refresh the manager display
    refreshManager: function() {
        var container = document.getElementById('highlightFilters');
        if (container) {
            container.innerHTML = this.createFiltersHTML();
        }
    },

    // Export filters to JSON
    exportFilters: function() {
        var data = JSON.stringify(this.filters, null, 2);
        var blob = new Blob([data], { type: 'application/json' });
        var url = URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.href = url;
        a.download = 'highlight_filters.json';
        a.click();
        URL.revokeObjectURL(url);
    },

    // Import filters from JSON
    importFilters: function(input) {
        var file = input.files[0];
        if (!file) return;

        var reader = new FileReader();
        reader.onload = (e) => {
            try {
                var imported = JSON.parse(e.target.result);
                if (Array.isArray(imported)) {
                    // Validate and add filters
                    imported.forEach(filter => {
                        if (filter.term && filter.color) {
                            var newFilter = this.addFilter(filter.term, filter.color, filter.animation || 'none');
                            if (filter.soundEnabled) {
                                this.updateFilter(newFilter.id, { soundEnabled: true });
                            }
                        }
                    });
                    this.refreshManager();
                    alert('Filters imported successfully!');
                }
            } catch (error) {
                alert('Error importing filters: Invalid file format');
            }
        };
        reader.readAsText(file);
        input.value = ''; // Reset input
    },

    // Save filters to cookie
    saveFilters: function() {
        var data = JSON.stringify(this.filters);
        try {
            if (typeof setCookie === 'function') {
                setCookie('highlightFilters', data, 365);
            }
        } catch (e) {
            console.warn('Failed to save highlight filters:', e);
        }
    },

    // Load filters from cookie
    loadFilters: function() {
		var saved = null;

		try {
			if (typeof getCookie === 'function') {
				saved = getCookie('highlightFilters');
			}

			if (saved) {
				var parsed = JSON.parse(saved);
				if (Array.isArray(parsed)) {
					this.filters = parsed;
					// Ensure all filters have required properties
					this.filters.forEach(filter => {
						if (filter.soundEnabled === undefined) {
							filter.soundEnabled = false;
						}
						if (filter.soundType === undefined) {
							filter.soundType = 'beep';
						}
						// Migrate old customSound to customSoundUrl
						if (filter.customSound !== undefined) {
							filter.customSoundUrl = '';
							delete filter.customSound;
						}
						if (filter.customSoundUrl === undefined) {
							filter.customSoundUrl = '';
						}
					});
				}
			}
		} catch (e) {
			console.warn('Failed to load highlight filters:', e);
		}
	}
};

// Initialize when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function() {
        highlightSystem.init();
    });
} else {
    highlightSystem.init();
}

window.status = 'Output';
var $messages, $subOptions, $subAudio, $selectedSub, $contextMenu, $filterMessages, $last_message;
var opts = {
	//General
	'messageCount': 0, //A count...of messages...
	'messageLimit': 200, //A limit...for the messages...
	'scrollSnapTolerance': 10, //If within x pixels of bottom
	'clickTolerance': 10, //Keep focus if outside x pixels of mousedown position on mouseup
	'imageRetryDelay': 50, //how long between attempts to reload images (in ms)
	'imageRetryLimit': 50, //how many attempts should we make?
	'popups': 0, //Amount of popups opened ever
	'wasd': false, //Is the user in wasd mode?
	'priorChatHeight': 0, //Thing for height-resizing detection
	'restarting': false, //Is the round restarting?
	'darkmode':false, //Are we using darkmode? If not WHY ARE YOU LIVING IN 2009???

	//Options menu
	'selectedSubLoop': null, //Contains the interval loop for closing the selected sub menu
	'suppressSubClose': false, //Whether or not we should be hiding the selected sub menu
	'highlightTerms': [],
	'highlightLimit': 10,
	'highlightColor': '#FFFF00', //The color of the highlighted message
	'pingDisabled': true, //Has the user disabled the ping counter

	//Ping display
	'lastPang': 0, //Timestamp of the last response from the server.
	'pangLimit': 35000,
	'pingTime': 0, //Timestamp of when ping sent
	'pongTime': 0, //Timestamp of when ping received
	'noResponse': false, //Tracks the state of the previous ping request
	'noResponseCount': 0, //How many failed pings?

	//Clicks
	'mouseDownX': null,
	'mouseDownY': null,
	'preventFocus': false, //Prevents switching focus to the game window

	//Client Connection Data
	'clientDataLimit': 5,
	'clientData': [],

	//Admin music volume update
	'volumeUpdateDelay': 5000, //Time from when the volume updates to data being sent to the server
	'volumeUpdating': false, //True if volume update function set to fire
	'updatedVolume': 0, //The volume level that is sent to the server
	'musicStartAt': 0, //The position the music starts playing
	'musicEndAt': 0, //The position the music... stops playing... if null, doesn't apply (so the music runs through)

	'defaultMusicVolume': 25,

	'messageCombining': false,

	'currentFilter': 'all',
    'customTabs': []

};
var replaceRegexes = {};

function clamp(val, min, max) {
	return Math.max(min, Math.min(val, max))
}

function outerHTML(el) {
    var wrap = document.createElement('div');
    wrap.appendChild(el.cloneNode(true));
    return wrap.innerHTML;
}

//Polyfill for fucking date now because of course IE8 and below don't support it
if (!Date.now) {
	Date.now = function now() {
		return new Date().getTime();
	};
}
//Polyfill for trim() (IE8 and below)
if (typeof String.prototype.trim !== 'function') {
	String.prototype.trim = function () {
		return this.replace(/^\s+|\s+$/g, '');
	};
}

// Linkify the contents of a node, within its parent.
function linkify(parent, insertBefore, text) {
	var start = 0;
	var match;
	var regex = /(?:(?:https?:\/\/)|(?:www\.))(?:[^ ]*?\.[^ ]*?)+[-A-Za-z0-9+&@#\/%?=~_|$!:,.;()]+/ig;
	while ((match = regex.exec(text)) !== null) {
		// add the unmatched text
		parent.insertBefore(document.createTextNode(text.substring(start, match.index)), insertBefore);

		var href = match[0];
		if (!/^https?:\/\//i.test(match[0])) {
			href = "http://" + match[0];
		}

		// add the link
		var link = document.createElement("a");
		link.href = href;
		link.textContent = match[0];
		parent.insertBefore(link, insertBefore);

		start = regex.lastIndex;
	}
	if (start !== 0) {
		// add the remaining text and remove the original text node
		parent.insertBefore(document.createTextNode(text.substring(start)), insertBefore);
		parent.removeChild(insertBefore);
	}
}

// Recursively linkify the children of a given node.
function linkify_node(node) {
	var children = node.childNodes;
	// work backwards to avoid the risk of looping forever on our own output
	for (var i = children.length - 1; i >= 0; --i) {
		var child = children[i];
		if (child.nodeType == Node.TEXT_NODE) {
			// text is to be linkified
			linkify(node, child, child.textContent);
		} else if (child.nodeName != "A" && child.nodeName != "a") {
			// do not linkify existing links
			linkify_node(child);
		}
	}
}

//Shit fucking piece of crap that doesn't work god fuckin damn it
function linkify_fallback(text) {
	var rex = /((?:<a|<iframe|<img)(?:.*?(?:src="|href=").*?))?(?:(?:https?:\/\/)|(?:www\.))+(?:[^ ]*?\.[^ ]*?)+[-A-Za-z0-9+&@#\/%?=~_|$!:,.;]+/ig;
	return text.replace(rex, function ($0, $1) {
		if(/^https?:\/\/.+/i.test($0)) {
			return $1 ? $0: '<a href="'+$0+'">'+$0+'</a>';
		}
		else {
			return $1 ? $0: '<a href="http://'+$0+'">'+$0+'</a>';
		}
	});
}

function byondDecode(message) {
	// Basically we url_encode twice server side so we can manually read the encoded version and actually do UTF-8.
	// The replace for + is because FOR SOME REASON, BYOND replaces spaces with a + instead of %20, and a plus with %2b.
	// Marvelous.
	message = message.replace(/\+/g, "%20");
	try {
		// This is a workaround for the above not always working when BYOND's shitty url encoding breaks. (byond bug id:2399401)
		if (decodeURIComponent) {
			message = decodeURIComponent(message);
		} else {
			throw new Error("Easiest way to trigger the fallback")
		}
	} catch (err) {
		message = unescape(message);
	}
	return message;
}

function replaceRegex() {
	var selectedRegex = replaceRegexes[$(this).attr('replaceRegex')];
	if (selectedRegex) {
		var replacedText = $(this).html().replace(selectedRegex[0], selectedRegex[1]);
		$(this).html(replacedText);
	}
	$(this).removeAttr('replaceRegex');
}

//Actually turns the highlight term match into appropriate html
function addHighlightMarkup(match) {
	var extra = '';
	if (opts.highlightColor) {
		extra += ' style="background-color: '+opts.highlightColor+'"';
	}
	return '<span class="highlight"'+extra+'>'+match+'</span>';
}

//Highlights words based on user settings
function highlightTerms(el) {
    if (window.highlightSystem) {
        highlightSystem.highlightElement(el);
    } else {
        // Fallback to old system if new one isn't loaded
        legacyHighlightTerms(el);
    }
}

function legacyHighlightTerms(el) {
    if (el.children.length > 0) {
        for(var h = 0; h < el.children.length; h++){
            legacyHighlightTerms(el.children[h]);
        }
    }

    var hasTextNode = false;
    for (var node = 0; node < el.childNodes.length; node++) {
        if (el.childNodes[node].nodeType === 3) {
            hasTextNode = true;
            break;
        }
    }

    if (hasTextNode) {
        var newText = '';
        for (var c = 0; c < el.childNodes.length; c++) {
            if (el.childNodes[c].nodeType === 3) {
                var words = el.childNodes[c].data.split(' ');
                for (var w = 0; w < words.length; w++) {
                    var newWord = null;
                    for (var i = 0; i < opts.highlightTerms.length; i++) {
                        if (opts.highlightTerms[i] && words[w].toLowerCase().indexOf(opts.highlightTerms[i].toLowerCase()) > -1) {
                            newWord = words[w].replace("<", "&lt;").replace(new RegExp(opts.highlightTerms[i], 'gi'), addHighlightMarkup);
                            break;
                        }
                    }
                    newText += newWord || words[w].replace("<", "&lt;");
                    newText += w >= words.length ? '' : ' ';
                }
            } else {
                newText += outerHTML(el.childNodes[c]);
            }
        }
        el.innerHTML = newText;
    }
}

function iconError(E) {
	var that = this;
	setTimeout(function() {
		var attempts = $(that).data('reload_attempts');
		if (typeof attempts === 'undefined' || !attempts) {
			attempts = 1;
		}
		if (attempts > opts.imageRetryLimit)
			return;
		var src = that.src;
		that.src = null;
		that.src = src+'#'+attempts;
		$(that).data('reload_attempts', ++attempts);
	}, opts.imageRetryDelay);
}

//Send a message to the client
function output(message, flag) {
    if (typeof message === 'undefined') {
        return;
    }
    if (typeof flag === 'undefined') {
        flag = '';
    }

    if (flag !== 'internal') opts.lastPang = Date.now();

    // Send to WebSocket if available
    if (flag !== 'internal' && typeof window.WebSocketManager !== 'undefined') {
        try {
            var tempDiv = document.createElement('div');
            tempDiv.innerHTML = byondDecode(message).trim();
            var plainText = tempDiv.textContent || tempDiv.innerText || "";

            var payload = JSON.stringify({
                content: {
                    html: message,
                    text: plainText,
                    timestamp: Date.now(),
                    flag: flag
                }
            });

            window.WebSocketManager.sendMessage('chat/message', payload);
        } catch (e) {
            console.warn('WebSocket send failed:', e);
        }
    }

    // Add to queue instead of processing immediately
    messageQueue.add(message, flag);
}



// Highlighting function (fixed)
function highlightTerms(element) {
	if (!opts.highlightTerms || opts.highlightTerms.length === 0) return;

	function highlightInTextNode(textNode) {
		var text = textNode.textContent;
		var highlightedText = text;

		opts.highlightTerms.forEach(term => {
			if (term && term.trim()) {
				var regex = new RegExp(`(${escapeRegex(term.trim())})`, 'gi');
				highlightedText = highlightedText.replace(regex,
					`<span class="highlight" style="background-color: ${opts.highlightColor}">$1</span>`);
			}
		});

		if (highlightedText !== text) {
			var wrapper = document.createElement('span');
			wrapper.innerHTML = highlightedText;
			textNode.parentNode.replaceChild(wrapper, textNode);
		}
	}

	function escapeRegex(string) {
		return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
	}

	// Walk through all text nodes
	var walker = document.createTreeWalker(
		element,
		NodeFilter.SHOW_TEXT,
		null,
		false
	);

	var textNodes = [];
	var node;
	while (node = walker.nextNode()) {
		textNodes.push(node);
	}

	textNodes.forEach(highlightInTextNode);
}
class WebSocketManager {
            constructor() {
                this.websocket = null;
                this.settings = {
                    websocketEnabled: false,
                    websocketServer: 'localhost:1234'
                };
                this.WEBSOCKET_DISABLED = 4555;
                this.WEBSOCKET_REATTEMPT = 4556;
                this.reconnectAttempts = 0;
                this.maxReconnectAttempts = 5;

                this.loadSettings();
                this.initializeUI();
            }

            // Send WebSocket notices to chat
            sendWSNotice(message, small = false) {
                const html = small
                    ? `<span class='adminsay'>${message}</span>`
                    : `<div class="boxed_message"><center><span class='alertwarning'>${message}</span></center></div>`;

                // Assuming you have a chat renderer function
                if (typeof processChatMessage === 'function') {
                    processChatMessage({ html: html });
                } else {
                    // Fallback: append directly to messages
                    const messagesDiv = document.getElementById('messages');
                    if (messagesDiv) {
                        const messageElement = document.createElement('div');
                        messageElement.innerHTML = html;
                        messagesDiv.appendChild(messageElement);
                        messagesDiv.scrollTop = messagesDiv.scrollHeight;
                    }
                }
            }

            // Update WebSocket status indicator
            updateStatus(status, message = '') {
                const statusElement = document.getElementById('websocketStatus');
                if (statusElement) {
                    statusElement.className = `websocket-status ${status}`;
                    statusElement.textContent = message || status.charAt(0).toUpperCase() + status.slice(1);
                }
            }

            // Setup WebSocket connection
            setupWebsocket() {
                if (!this.settings.websocketEnabled) {
                    if (this.websocket) {
                        this.websocket.close(this.WEBSOCKET_REATTEMPT);
                        this.websocket = null;
                    }
                    this.updateStatus('disconnected');
                    return;
                }

                // Close existing connection
                if (this.websocket) {
                    this.websocket.close(this.WEBSOCKET_REATTEMPT);
                }

                this.updateStatus('connecting');

                try {
                    this.websocket = new WebSocket(`ws://${this.settings.websocketServer}`);
                } catch (e) {
                    if (e.name === 'SyntaxError') {
                        this.sendWSNotice(
                            `Error creating websocket: Invalid address! Make sure you're following the placeholder. Example: <code>localhost:1234</code>`
                        );
                        this.updateStatus('disconnected', 'Invalid Address');
                        return;
                    }
                    this.sendWSNotice(`Error creating websocket: ${e.name} - ${e.message}`);
                    this.updateStatus('disconnected', 'Connection Error');
                    return;
                }

                this.websocket.addEventListener('open', () => {
                    this.sendWSNotice('Websocket connected!', true);
                    this.updateStatus('connected');
                    this.reconnectAttempts = 0;
                });

                this.websocket.addEventListener('close', (ev) => {
                    if (!this.settings.websocketEnabled) {
                        this.updateStatus('disconnected');
                        return;
                    }

                    if (ev.code !== this.WEBSOCKET_DISABLED && ev.code !== this.WEBSOCKET_REATTEMPT) {
                        this.sendWSNotice(
                            `Websocket disconnected! Code: ${ev.code} Reason: ${ev.reason || 'None provided'}`
                        );
                        this.updateStatus('disconnected', 'Connection Lost');

                        // Auto-reconnect logic
                        if (this.settings.websocketEnabled && this.reconnectAttempts < this.maxReconnectAttempts) {
                            this.reconnectAttempts++;
                            setTimeout(() => {
                                this.sendWSNotice(`Attempting to reconnect... (${this.reconnectAttempts}/${this.maxReconnectAttempts})`, true);
                                this.setupWebsocket();
                            }, 2000 * this.reconnectAttempts);
                        }
                    } else {
                        this.updateStatus('disconnected');
                    }
                });

                this.websocket.addEventListener('error', (error) => {
                    console.error('WebSocket error:', error);
                    this.updateStatus('disconnected', 'Connection Error');
                });

                // Handle incoming messages
                this.websocket.addEventListener('message', (event) => {
                    try {
                        const data = JSON.parse(event.data);
                        this.handleWebSocketMessage(data);
                    } catch (e) {
                        console.error('Error parsing WebSocket message:', e);
                    }
                });
            }

            // Handle incoming WebSocket messages
            handleWebSocketMessage(data) {
                // Process incoming messages based on type
                console.log('Received WebSocket message:', data);

                // You can extend this to handle different message types
                if (data.type === 'chat/message') {
                    // Handle chat messages
                    this.sendWSNotice(data.message, data.small || false);
                } else if (data.type === 'system/message') {
                    // Handle system messages
                    this.sendWSNotice(data.message, true);
                }
            }

            // Send message through WebSocket
            sendMessage(type, payload) {
                if (this.websocket && this.websocket.readyState === WebSocket.OPEN) {
                    this.websocket.send(JSON.stringify({
                        type: type,
                        payload: payload
                    }));
                    return true;
                }
                return false;
            }

            // Connect WebSocket
            connect() {
                this.settings.websocketEnabled = true;
                this.saveSettings();
                this.sendWSNotice('Websocket enabled.', true);
                this.setupWebsocket();
            }

            // Disconnect WebSocket
            disconnect() {
                this.settings.websocketEnabled = false;
                this.saveSettings();
                if (this.websocket) {
                    this.websocket.close(this.WEBSOCKET_DISABLED);
                    this.websocket = null;
                }
                this.sendWSNotice('Websocket forcefully disconnected.', true);
                this.updateStatus('disconnected');
            }

            // Reconnect WebSocket
            reconnect() {
                if (this.settings.websocketEnabled) {
                    this.reconnectAttempts = 0;
                    this.setupWebsocket();
                }
            }

            // Update server address
            updateServer(server) {
                this.settings.websocketServer = server;
                this.saveSettings();

                if (this.settings.websocketEnabled) {
                    if (this.websocket) {
                        this.websocket.close(this.WEBSOCKET_REATTEMPT, 'Websocket settings changed');
                    }
                    this.setupWebsocket();
                }
            }

            // Save settings to localStorage
            saveSettings() {
                try {
                    localStorage.setItem('websocketSettings', JSON.stringify(this.settings));
                } catch (e) {
                    console.error('Failed to save WebSocket settings:', e);
                }

                // Update UI
                const enabledCheckbox = document.getElementById('websocketEnabled');
                const serverInput = document.getElementById('websocketServer');

                if (enabledCheckbox) {
                    enabledCheckbox.checked = this.settings.websocketEnabled;
                }
                if (serverInput) {
                    serverInput.value = this.settings.websocketServer;
                }
            }

            // Load settings from localStorage
            loadSettings() {
                try {
                    const saved = localStorage.getItem('websocketSettings');
                    if (saved) {
                        this.settings = { ...this.settings, ...JSON.parse(saved) };
                    }
                } catch (e) {
                    console.error('Failed to load WebSocket settings:', e);
                }
            }

            // Initialize UI event listeners
            initializeUI() {
                // Wait for DOM to be ready
                if (document.readyState === 'loading') {
                    document.addEventListener('DOMContentLoaded', () => this.setupUIListeners());
                } else {
                    this.setupUIListeners();
                }
            }

            setupUIListeners() {
                // WebSocket toggle button
                const toggleWebsocket = document.getElementById('toggleWebsocket');
                if (toggleWebsocket) {
                    toggleWebsocket.addEventListener('click', (e) => {
                        e.preventDefault();
                        const subWebsocket = document.getElementById('subWebsocket');
                        if (subWebsocket) {
                            subWebsocket.style.display = subWebsocket.style.display === 'block' ? 'none' : 'block';
                        }
                    });
                }

                // Enable/disable checkbox
                const enabledCheckbox = document.getElementById('websocketEnabled');
                if (enabledCheckbox) {
                    enabledCheckbox.checked = this.settings.websocketEnabled;
                    enabledCheckbox.addEventListener('change', (e) => {
                        if (e.target.checked) {
                            this.connect();
                        } else {
                            this.disconnect();
                        }
                    });
                }

                // Server input
                const serverInput = document.getElementById('websocketServer');
                if (serverInput) {
                    serverInput.value = this.settings.websocketServer;
                    serverInput.addEventListener('change', (e) => {
                        this.updateServer(e.target.value);
                    });
                    serverInput.addEventListener('keypress', (e) => {
                        if (e.key === 'Enter') {
                            this.updateServer(e.target.value);
                        }
                    });
                }

                // Control buttons
                const connectBtn = document.getElementById('connectWebsocket');
                const disconnectBtn = document.getElementById('disconnectWebsocket');
                const reconnectBtn = document.getElementById('reconnectWebsocket');

                if (connectBtn) {
                    connectBtn.addEventListener('click', () => this.connect());
                }
                if (disconnectBtn) {
                    disconnectBtn.addEventListener('click', () => this.disconnect());
                }
                if (reconnectBtn) {
                    reconnectBtn.addEventListener('click', () => this.reconnect());
                }

                // Initialize connection if enabled
                if (this.settings.websocketEnabled) {
                    setTimeout(() => this.setupWebsocket(), 1000);
                }
            }
        }

        // Initialize WebSocket Manager
        const wsManager = new WebSocketManager();

        // Make it globally accessible for integration with existing chat system
        window.WebSocketManager = wsManager;

        // Example integration with existing chat system
        // You can call these functions from your existing browserOutput.js
        window.sendWebSocketMessage = function(type, payload) {
            return wsManager.sendMessage(type, payload);
        };

        window.getWebSocketStatus = function() {
            return wsManager.websocket ? wsManager.websocket.readyState : WebSocket.CLOSED;
        };

// Fixed filter function that looks at nested elements for chat classes
function applyFilterToMessage(messageElement) {
    if (!messageElement) return;

    var shouldShow = false;

    // Fast path
    if (opts.currentFilter === 'all') {
        shouldShow = true;
    } else {
        // Check cache first
        var cacheKey = messageElement.className + messageElement.innerHTML.substring(0, 100);
        if (filterCache.has(cacheKey)) {
            shouldShow = filterCache.get(cacheKey);
        } else {
            // Compute and cache
            var classes = messageElement.className.split(' ');
            var innerHTML = messageElement.innerHTML;

            shouldShow = classes.indexOf(opts.currentFilter) !== -1 ||
                        innerHTML.indexOf('class="' + opts.currentFilter) !== -1;

            if (!shouldShow && opts.customTabs) {
                for (var i = 0; i < opts.customTabs.length; i++) {
                    var tab = opts.customTabs[i];
                    if (tab.name.toLowerCase() === opts.currentFilter) {
                        for (var j = 0; j < tab.classes.length; j++) {
                            if (classes.indexOf(tab.classes[j]) !== -1 ||
                                innerHTML.indexOf('class="' + tab.classes[j]) !== -1) {
                                shouldShow = true;
                                break;
                            }
                        }
                        break;
                    }
                }
            }

            // Cache result
            filterCache.set(cacheKey, shouldShow);
        }
    }

    // Apply visibility
    if (shouldShow) {
        messageElement.classList.remove('filtered-hidden');
        if (messageElement.style.display === 'none') {
            messageElement.style.display = '';
        }
    } else {
        messageElement.classList.add('filtered-hidden');
        messageElement.style.display = 'none';
    }
}


var filterCache = new Map();

function switchFilter(filterName) {
    console.log('Switching to filter:', filterName);
    opts.currentFilter = filterName.toLowerCase();

    // Update tab appearance
    $('.filter-tab').removeClass('active');
    $(`.filter-tab[data-filter="${filterName.toLowerCase()}"]`).addClass('active');

    // Clear cache when switching filters
    filterCache.clear();

    // Use DocumentFragment for better performance
    var entries = document.querySelectorAll('#messages .entry');

    // Batch DOM updates
    requestAnimationFrame(() => {
        entries.forEach(entry => {
            applyFilterToMessage(entry);
        });
    });

    setCookie('currentFilter', filterName, 365);
}


// Custom tab functions
function showAddTabForm() {
	$('#addTabForm').show();
}

function cancelAddTab() {
	$('#addTabForm').hide();
	$('#tabName').val('');
	$('#tabClasses').val('');
}

function saveCustomTab() {
	var name = $('#tabName').val().trim();
	var classesStr = $('#tabClasses').val().trim();

	if (!name || !classesStr) {
		alert('Please fill in both fields');
		return;
	}

	var classes = classesStr.split(',').map(c => c.trim()).filter(c => c);
	var newTab = { name: name, classes: classes };

	opts.customTabs.push(newTab);

	// Add tab to UI
	var tabElement = $(`<div class="filter-tab custom" data-filter="${name.toLowerCase()}">${name} <span class="remove-tab">×</span></div>`);
	$('#addTabBtn').before(tabElement);

	// Save to cookie
	setCookie('customTabs', JSON.stringify(opts.customTabs), 365);

	cancelAddTab();
}

function removeCustomTab(tabName) {
	opts.customTabs = opts.customTabs.filter(tab => tab.name.toLowerCase() !== tabName.toLowerCase());
	$(`.filter-tab[data-filter="${tabName.toLowerCase()}"]`).remove();
	setCookie('customTabs', JSON.stringify(opts.customTabs), 365);

	// Switch to 'all' if we removed the active tab
	if (opts.currentFilter === tabName.toLowerCase()) {
		switchFilter('all');
	}
}

// Popup functions
function createPopup(content, width) {
	var popup = $(`<div class="popup" style="width: ${width}px;">${content}<a href="#" class="close">×</a></div>`);
	$('body').append(popup);

	popup.on('click', '.close', function(e) {
		e.preventDefault();
		popup.remove();
	});
}

function showHighlightPopup() {
	var termInputs = '';
	for (var i = 0; i < 10; i++) {
		termInputs += `<div><input type="text" id="highlightTerm${i}" placeholder="Highlight term ${i + 1}" value="${opts.highlightTerms[i] || ''}" /></div>`;
	}

	var popupContent = `
		<div class="head">String Highlighting</div>
		<div>Enter terms to highlight in chat messages:</div>
		<form id="highlightForm">
			${termInputs}
			<div>
				<label>Highlight Color:</label>
				<input type="color" id="highlightColor" value="${opts.highlightColor}" />
			</div>
			<input type="submit" value="Save Settings" />
		</form>
	`;

	createPopup(popupContent, 350);
}

function internalOutput(message, flag)
{
	output(escaper(message), flag)
}

//Runs a route within byond, client or server side. Consider this "ehjax" for byond.
function runByond(uri) {
	window.location = uri;
}

function setCookie(cname, cvalue, exdays) {
	cvalue = escaper(cvalue);
	var d = new Date();
	d.setTime(d.getTime() + (exdays*24*60*60*1000));
	var expires = 'expires='+d.toUTCString();
	document.cookie = cname + '=' + cvalue + '; ' + expires + "; path=/";
}

function getCookie(cname) {
	var name = cname + '=';
	var ca = document.cookie.split(';');
	for(var i=0; i < ca.length; i++) {
	var c = ca[i];
	while (c.charAt(0)==' ') c = c.substring(1);
		if (c.indexOf(name) === 0) {
			return decoder(c.substring(name.length,c.length));
		}
	}
	return '';
}

function rgbToHex(R,G,B) {return toHex(R)+toHex(G)+toHex(B);}
function toHex(n) {
	n = parseInt(n,10);
	if (isNaN(n)) return "00";
	n = Math.max(0,Math.min(n,255));
	return "0123456789ABCDEF".charAt((n-n%16)/16) + "0123456789ABCDEF".charAt(n%16);
}

function swap() { //Swap to darkmode
	if (opts.darkmode){
		document.getElementById("sheetofstyles").href = "browserOutput.css";
		opts.darkmode = false;
		runByond('?_src_=chat&proc=swaptolightmode');
	} else {
		document.getElementById("sheetofstyles").href = "browserOutput.css";
		opts.darkmode = true;
		runByond('?_src_=chat&proc=swaptodarkmode');
	}
	setCookie('darkmode', (opts.darkmode ? 'true' : 'false'), 365);
}

function handleClientData(ckey, ip, compid) {
	//byond sends player info to here
	var currentData = {'ckey': ckey, 'ip': ip, 'compid': compid};
	if (opts.clientData && !$.isEmptyObject(opts.clientData)) {
		runByond('?_src_=chat&proc=analyzeClientData&param[cookie]='+JSON.stringify({'connData': opts.clientData}));

		for (var i = 0; i < opts.clientData.length; i++) {
			var saved = opts.clientData[i];
			if (currentData.ckey == saved.ckey && currentData.ip == saved.ip && currentData.compid == saved.compid) {
				return; //Record already exists
			}
		}

		if (opts.clientData.length >= opts.clientDataLimit) {
			opts.clientData.shift();
		}
	} else {
		runByond('?_src_=chat&proc=analyzeClientData&param[cookie]=none');
	}

	//Update the cookie with current details
	opts.clientData.push(currentData);
	setCookie('connData', JSON.stringify(opts.clientData), 365);
}

//Server calls this on ehjax response
//Or, y'know, whenever really
function ehjaxCallback(data) {
	opts.lastPang = Date.now();
	if (data == 'softPang') {
		return;
	} else if (data == 'pang') {
		opts.pingCounter = 0; //reset
		opts.pingTime = Date.now();
		runByond('?_src_=chat&proc=ping');

	} else if (data == 'pong') {
		if (opts.pingDisabled) {return;}
		opts.pongTime = Date.now();
		var pingDuration = Math.ceil((opts.pongTime - opts.pingTime) / 2);
		$('#pingMs').text(pingDuration+'ms');
		pingDuration = Math.min(pingDuration, 255);
		var red = pingDuration;
		var green = 255 - pingDuration;
		var blue = 0;
		var hex = rgbToHex(red, green, blue);
		$('#pingDot').css('color', '#'+hex);

	} else if (data == 'roundrestart') {
		opts.restarting = true;
		internalOutput('<div class="connectionClosed internal restarting">The connection has been closed because the server is restarting. Please wait while you automatically reconnect.</div>', 'internal');
	} else if (data == 'stopMusic') {
		$('#adminMusic').prop('src', '');
	} else {
		//Oh we're actually being sent data instead of an instruction
		var dataJ;
		try {
			dataJ = $.parseJSON(data);
		} catch (e) {
			//But...incorrect :sadtrombone:
			window.onerror('JSON: '+e+'. '+data, 'browserOutput.html', 327);
			return;
		}
		data = dataJ;

		if (data.clientData) {
			if (opts.restarting) {
				opts.restarting = false;
				$('.connectionClosed.restarting:not(.restored)').addClass('restored').text('The round restarted and you successfully reconnected!');
			}
			if (!data.clientData.ckey && !data.clientData.ip && !data.clientData.compid) {
				//TODO: Call shutdown perhaps
				return;
			} else {
				handleClientData(data.clientData.ckey, data.clientData.ip, data.clientData.compid);
			}
			sendVolumeUpdate();
		} else if (data.adminMusic) {
			if (typeof data.adminMusic === 'string') {
				var adminMusic = byondDecode(data.adminMusic);
				var bindLoadedData = false;
				adminMusic = adminMusic.match(/https?:\/\/\S+/) || '';
				if (data.musicRate) {
					var newRate = Number(data.musicRate);
					if(newRate) {
						$('#adminMusic').prop('defaultPlaybackRate', newRate);
					}
				} else {
					$('#adminMusic').prop('defaultPlaybackRate', 1.0);
				}
				if (data.musicSeek) {
					opts.musicStartAt = Number(data.musicSeek) || 0;
					bindLoadedData = true;
				} else {
					opts.musicStartAt = 0;
				}
				if (data.musicHalt) {
					opts.musicEndAt = Number(data.musicHalt) || null;
					bindLoadedData = true;
				}
				if (bindLoadedData) {
					$('#adminMusic').one('loadeddata', adminMusicLoadedData);
				}
				$('#adminMusic').prop('src', adminMusic);
				$('#adminMusic').trigger("play");
			}
		} else if (data.syncRegex) {
			for (var i in data.syncRegex) {

				var regexData = data.syncRegex[i];
				var regexName = regexData[0];
				var regexFlags = regexData[1];
				var regexReplaced = regexData[2];

				replaceRegexes[i] = [new RegExp(regexName, regexFlags), regexReplaced];
			}
		}
	}
}

function createPopup(contents, width) {
	opts.popups++;
	$('body').append('<div class="popup" id="popup'+opts.popups+'" style="width: '+width+'px;">'+contents+' <a href="#" class="close"><i class="icon-remove"></i></a></div>');

	//Attach close popup event
	var $popup = $('#popup'+opts.popups);
	var height = $popup.outerHeight();
	$popup.css({'height': height+'px', 'margin': '-'+(height/2)+'px 0 0 -'+(width/2)+'px'});

	$popup.on('click', '.close', function(e) {
		e.preventDefault();
		$popup.remove();
	});
}

function toggleWasd(state) {
	opts.wasd = (state == 'on' ? true : false);
}

function sendVolumeUpdate() {
	opts.volumeUpdating = false;
	if(opts.updatedVolume) {
		runByond('?_src_=chat&proc=setMusicVolume&param[volume]='+opts.updatedVolume);
	}
}

function adminMusicEndCheck(event) {
	if (opts.musicEndAt) {
		if ($('#adminMusic').prop('currentTime') >= opts.musicEndAt) {
			$('#adminMusic').off(event);
			$('#adminMusic').trigger('pause');
			$('#adminMusic').prop('src', '');
		}
	} else {
		$('#adminMusic').off(event);
	}
}

function adminMusicLoadedData(event) {
	if (opts.musicStartAt && ($('#adminMusic').prop('duration') === Infinity || (opts.musicStartAt <= $('#adminMusic').prop('duration'))) ) {
		$('#adminMusic').prop('currentTime', opts.musicStartAt);
	}
	if (opts.musicEndAt) {
		$('#adminMusic').on('timeupdate', adminMusicEndCheck);
	}
}

function subSlideUp() {
	$(this).removeClass('scroll');
	$(this).css('height', '');
}

function startSubLoop() {
	if (opts.selectedSubLoop) {
		clearInterval(opts.selectedSubLoop);
	}
	return setInterval(function() {
		if (!opts.suppressSubClose && $selectedSub.is(':visible')) {
			$selectedSub.slideUp('fast', subSlideUp);
			clearInterval(opts.selectedSubLoop);
		}
	}, 5000); //every 5 seconds
}

function handleToggleClick($sub, $toggle) {
	if ($selectedSub !== $sub && $selectedSub.is(':visible')) {
		$selectedSub.slideUp('fast', subSlideUp);
	}
	$selectedSub = $sub
	if ($selectedSub.is(':visible')) {
		$selectedSub.slideUp('fast', subSlideUp);
		clearInterval(opts.selectedSubLoop);
	} else {
		$selectedSub.slideDown('fast', function() {
			var windowHeight = $(window).height();
			var toggleHeight = $toggle.outerHeight();
			var priorSubHeight = $selectedSub.outerHeight();
			var newSubHeight = windowHeight - toggleHeight;
			$(this).height(newSubHeight);
			if (priorSubHeight > (windowHeight - toggleHeight)) {
				$(this).addClass('scroll');
			}
		});
		opts.selectedSubLoop = startSubLoop();
	}
}


/*****************************************
*
* DOM READY
*
******************************************/

if (typeof $ === 'undefined') {
	var div = document.getElementById('loading').childNodes[1];
	div += '<br><br>ERROR: Jquery did not load.';
}

$(function() {
	$messages = $('#messages');
	$subOptions = $('#subOptions');
	$subAudio = $('#subAudio');
	$selectedSub = $subOptions;

	//Hey look it's a controller loop!
	setInterval(function() {
		if (opts.lastPang + opts.pangLimit < Date.now() && !opts.restarting) { //Every pingLimit
				if (!opts.noResponse) { //Only actually append a message if the previous ping didn't also fail (to prevent spam)
					opts.noResponse = true;
					opts.noResponseCount++;
					internalOutput('<div class="connectionClosed internal" data-count="'+opts.noResponseCount+'">You are either AFK, experiencing lag or the connection has closed.</div>', 'internal');
				}
		} else if (opts.noResponse) { //Previous ping attempt failed ohno
				$('.connectionClosed[data-count="'+opts.noResponseCount+'"]:not(.restored)').addClass('restored').text('Your connection has been restored (probably)!');
				opts.noResponse = false;
		}
	}, 2000); //2 seconds


	/*****************************************
	*
	* LOAD SAVED CONFIG
	*
	******************************************/
	var savedConfig = {
		fontsize: getCookie('fontsize'),
		'spingDisabled': getCookie('pingdisabled'),
		'smusicVolume': getCookie('musicVolume'),
		'smessagecombining': getCookie('messagecombining'),
		'sdarkmode': getCookie('darkmode'),
	};

	var savedFilter = getCookie('currentFilter');
	if (savedFilter) {
		opts.currentFilter = savedFilter;
	}

	var savedCustomTabs = getCookie('customTabs');
	if (savedCustomTabs) {
		try {
			opts.customTabs = JSON.parse(savedCustomTabs);
			// Recreate custom tabs in UI
			opts.customTabs.forEach(tab => {
				var tabElement = $(`<div class="filter-tab custom" data-filter="${tab.name.toLowerCase()}">${tab.name} <span class="remove-tab">×</span></div>`);
				$('#addTabBtn').before(tabElement);
			});
		} catch (e) {
			console.log('Error loading custom tabs:', e);
		}
	}

	// Set initial filter
	if (opts.currentFilter && opts.currentFilter !== 'all') {
		switchFilter(opts.currentFilter);
	}
	if (savedConfig.fontsize) {
		$messages.css('font-size', savedConfig.fontsize);
		internalOutput('<span class="internal boldnshit">Loaded font size setting of: '+savedConfig.fontsize+'</span>', 'internal');
	}
	if(savedConfig.sdarkmode == 'true'){
		swap();
	}
	if (savedConfig.spingDisabled) {
		if (savedConfig.spingDisabled == 'true') {
			opts.pingDisabled = true;
			$('#ping').hide();
		}
		internalOutput('<span class="internal boldnshit">Loaded ping display of: '+(opts.pingDisabled ? 'hidden' : 'visible')+'</span>', 'internal');
	}
	if (savedConfig.smusicVolume) {
		var newVolume = clamp(savedConfig.smusicVolume, 0, 100);
		$('#adminMusic').prop('volume', newVolume / 100);
		$('#musicVolume').val(newVolume);
		opts.updatedVolume = newVolume;
		sendVolumeUpdate();
		internalOutput('<span class="internal boldnshit">Loaded music volume of: '+savedConfig.smusicVolume+'</span>', 'internal');
	}
	else{
		$('#adminMusic').prop('volume', opts.defaultMusicVolume / 100);
	}

	if (savedConfig.smessagecombining) {
		if (savedConfig.smessagecombining == 'false') {
			opts.messageCombining = false;
		} else {
			opts.messageCombining = true;
		}
	}
	(function() {
		var dataCookie = getCookie('connData');
		if (dataCookie) {
			var dataJ;
			try {
				dataJ = $.parseJSON(dataCookie);
			} catch (e) {
				window.onerror('JSON '+e+'. '+dataCookie, 'browserOutput.html', 434);
				return;
			}
			opts.clientData = dataJ;
		}
	})();


	/*****************************************
	*
	* BASE CHAT OUTPUT EVENTS
	*
	******************************************/

	$('body').on('click', 'a', function(e) {
		e.preventDefault();
	});

	$('body').on('mousedown', function(e) {
		var $target = $(e.target);

		if ($contextMenu) {
			$contextMenu.hide();
			return false;
		}

		if ($target.is('a') || $target.parent('a').length || $target.is('input') || $target.is('textarea')) {
			opts.preventFocus = true;
		} else {
			opts.preventFocus = false;
			opts.mouseDownX = e.pageX;
			opts.mouseDownY = e.pageY;
		}
	});

	$messages.on('mousedown', function(e) {
		if ($selectedSub && $selectedSub.is(':visible')) {
			$selectedSub.slideUp('fast', subSlideUp);
			clearInterval(opts.selectedSubLoop);
		}
	});

	$('body').on('mouseup', function(e) {
		if (!opts.preventFocus &&
			(e.pageX >= opts.mouseDownX - opts.clickTolerance && e.pageX <= opts.mouseDownX + opts.clickTolerance) &&
			(e.pageY >= opts.mouseDownY - opts.clickTolerance && e.pageY <= opts.mouseDownY + opts.clickTolerance)
		) {
			opts.mouseDownX = null;
			opts.mouseDownY = null;
			runByond('byond://winset?mapwindow.map.focus=true');
		}
	});

	$messages.on('click', 'a', function(e) {
		var href = $(this).attr('href');
		$(this).addClass('visited');
		if (href[0] == '?' || (href.length >= 8 && href.substring(0,8) == 'byond://')) {
			runByond(href);
		} else {
			href = escaper(href);
			runByond('?action=openLink&link='+href);
		}
	});

	//Fuck everything about this event. Will look into alternatives.
	$('body').on('keydown', function(e) {
		if (e.target.nodeName == 'INPUT' || e.target.nodeName == 'TEXTAREA') {
			return;
		}

		if (e.ctrlKey || e.altKey || e.shiftKey) { //Band-aid "fix" for allowing ctrl+c copy paste etc. Needs a proper fix.
			return;
		}

		e.preventDefault()

		var k = e.which;
		// Hardcoded because else there would be no feedback message.
		if (k == 113) { // F2
			runByond('byond://winset?screenshot=auto');
			internalOutput('Screenshot taken', 'internal');
		}

		var c = "";
		switch (k) {
			case 8:
				c = 'BACK';
			case 9:
				c = 'TAB';
			case 13:
				c = 'ENTER';
			case 19:
				c = 'PAUSE';
			case 27:
				c = 'ESCAPE';
			case 33: // Page up
				c = 'NORTHEAST';
			case 34: // Page down
				c = 'SOUTHEAST';
			case 35: // End
				c = 'SOUTHWEST';
			case 36: // Home
				c = 'NORTHWEST';
			case 37:
				c = 'WEST';
			case 38:
				c = 'NORTH';
			case 39:
				c = 'EAST';
			case 40:
				c = 'SOUTH';
			case 45:
				c = 'INSERT';
			case 46:
				c = 'DELETE';
			case 93: // That weird thing to the right of alt gr.
				c = 'APPS';

			default:
				c = String.fromCharCode(k);
		}

		if (c.length == 0) {
			if (!e.shiftKey) {
				c = c.toLowerCase();
			}
			runByond('byond://winset?mapwindow.map.focus=true;mainwindow.input.text='+c);
			return false;
		} else {
			runByond('byond://winset?mapwindow.map.focus=true');
			return false;
		}
	});

	//Mildly hacky fix for scroll issues on mob change (interface gets resized sometimes, messing up snap-scroll)
	$(window).on('resize', function(e) {
		if ($(this).height() !== opts.priorChatHeight) {
			$('body,html').scrollTop($messages.outerHeight());
			opts.priorChatHeight = $(this).height();
		}
	});


	/*****************************************
	*
	* OPTIONS INTERFACE EVENTS
	*
	******************************************/

	$('body').on('click', '#newMessages', function(e) {
		var messagesHeight = $messages.outerHeight();
		$('body,html').scrollTop(messagesHeight);
		$('#newMessages').remove();
		runByond('byond://winset?mapwindow.map.focus=true');
	});

	// Filter tab click handlers
	$(document).on('click', '.filter-tab', function(e) {
		e.preventDefault();
		var filterName = $(this).data('filter');
		switchFilter(filterName);
	});

	$(document).on('click', '#addTabBtn', function(e) {
		e.preventDefault();
		showAddTabForm();
	});

	$(document).on('click', '.remove-tab', function(e) {
		e.preventDefault();
		e.stopPropagation();
		var tabName = $(this).parent().data('filter');
		removeCustomTab(tabName);
	});

	$('#toggleOptions').click(function(e) {
		handleToggleClick($subOptions, $(this));
	});
	$('#darkmodetoggle').click(function(e) {
		swap();
	});
	$('#toggleAudio').click(function(e) {
		handleToggleClick($subAudio, $(this));
	});

	$('.sub, .toggle').mouseenter(function() {
		opts.suppressSubClose = true;
	});

	$('.sub, .toggle').mouseleave(function() {
		opts.suppressSubClose = false;
	});

	$('#decreaseFont').click(function(e) {
		savedConfig.fontsize = Math.max(parseInt(savedConfig.fontsize || 13) - 1, 1) + 'px';
		$messages.css({'font-size': savedConfig.fontsize});
		setCookie('fontsize', savedConfig.fontsize, 365);
		internalOutput('<span class="internal boldnshit">Font size set to '+savedConfig.fontsize+'</span>', 'internal');
	});

	$('#increaseFont').click(function(e) {
		savedConfig.fontsize = (parseInt(savedConfig.fontsize || 13) + 1) + 'px';
		$messages.css({'font-size': savedConfig.fontsize});
		setCookie('fontsize', savedConfig.fontsize, 365);
		internalOutput('<span class="internal boldnshit">Font size set to '+savedConfig.fontsize+'</span>', 'internal');
	});

	$('#togglePing').click(function(e) {
		if (opts.pingDisabled) {
			$('#ping').slideDown('fast');
			opts.pingDisabled = false;
		} else {
			$('#ping').slideUp('fast');
			opts.pingDisabled = true;
		}
		setCookie('pingdisabled', (opts.pingDisabled ? 'true' : 'false'), 365);
	});

	$('#saveLog').click(function(e) {
		var date = new Date();
		var fname = ' Vanderlin Chat Log ' +
					date.getFullYear() + '-' +
					(date.getMonth() + 1 < 10 ? '0' : '') + (date.getMonth() + 1) + '-' +
					(date.getDate() < 10 ? '0' : '') + date.getDate() + ' ' +
					(date.getHours() < 10 ? '0' : '') + date.getHours() +
					(date.getMinutes() < 10 ? '0' : '') + date.getMinutes() +
					(date.getSeconds() < 10 ? '0' : '') + date.getSeconds() +
					'.html';

		$.ajax({
			type: 'GET',
			url: 'browserOutput_white.css',
			success: function(styleData) {
				var blob = new Blob([
					'<head><title>Vanderlin Chat Log</title><style>',
					styleData,
					'</style></head><body>',
					$messages.html(),
					'</body>'
				], { type: 'text/html;charset=utf-8' });

				if (window.navigator.msSaveBlob) {
					window.navigator.msSaveBlob(blob, fname);
				} else {
					var link = document.createElement('a');
					link.href = URL.createObjectURL(blob);
					link.download = fname;
					link.click();
					URL.revokeObjectURL(link.href);
				}
			},
		});
	});

	highlightSystem.init();
	$('#highlightTerm').off('click').on('click', function(e) {
        e.preventDefault();

        if (window.highlightSystem) {
            highlightSystem.showManager();
        } else {
            // Fallback to old popup if new system isn't available
            showLegacyHighlightPopup();
        }
    });

    // Initialize the new highlight system
    if (window.highlightSystem) {
        highlightSystem.init();

        // Migrate old highlight terms to new system
        if (opts.highlightTerms && opts.highlightTerms.length > 0) {
            opts.highlightTerms.forEach(function(term) {
                if (term && term.trim()) {
                    highlightSystem.addFilter(term, opts.highlightColor || '#FFFF00', 'none');
                }
            });

            // Clear old terms to avoid duplication
            opts.highlightTerms = [];
            setCookie('highlightterms', JSON.stringify([]), 365);
        }
    };

	$('#clearMessages').click(function() {
		$messages.empty();
		opts.messageCount = 0;
	});

	$('#musicVolumeSpan').hover(function() {
		$('#musicVolumeText').addClass('hidden');
		$('#musicVolume').removeClass('hidden');
	}, function() {
		$('#musicVolume').addClass('hidden');
		$('#musicVolumeText').removeClass('hidden');
	});

	$('#musicVolume').change(function() {
		var newVolume = $('#musicVolume').val();
		newVolume = clamp(newVolume, 0, 100);
		$('#adminMusic').prop('volume', newVolume / 100);
		setCookie('musicVolume', newVolume, 365);
		opts.updatedVolume = newVolume;
		if(!opts.volumeUpdating) {
			setTimeout(sendVolumeUpdate, opts.volumeUpdateDelay);
			opts.volumeUpdating = true;
		}
	});

	$('#toggleCombine').click(function(e) {
		opts.messageCombining = !opts.messageCombining;
		setCookie('messagecombining', (opts.messageCombining ? 'true' : 'false'), 365);
	});

	$('img.icon').error(iconError);




	/*****************************************
	*
	* KICK EVERYTHING OFF
	*
	******************************************/

	runByond('?_src_=chat&proc=doneLoading');
	if ($('#loading').is(':visible')) {
		$('#loading').remove();
	}
	$('#userBar').show();
	opts.priorChatHeight = $(window).height();
});
