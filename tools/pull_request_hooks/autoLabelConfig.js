
// File Labels
//
// Add a label based on if a file is modified in the diff
//
// You can optionally set add_only to make the label one-way -
// if the edit to the file is removed in a later commit,
// the label will not be removed
export const file_labels = {
	'github': {
		filepaths: ['.github/'],
	},
	'SQL': {
		filepaths: ['SQL/'],
	},
	'mapping': {
		filepaths: ['_maps/'],
		file_extensions: [".dmm"],
	},
	'tooling': {
		filepaths: ['tools/'],
	},
	'config': {
		filepaths: ['config/', 'code/controllers/configuration/entries/'],
		add_only: true,
	},
	'sprites': {
		filepaths: ['icons/'],
		file_extensions: [".dmi"],
		add_only: true,
	},
	'sound': {
		filepaths: ['sound/'],
		file_extensions: [".ogg"],
		add_only: true,
	},
	'music': {
		filepaths: ['sound/music/'],
		file_extensions: [".ogg"],
		add_only: true,
	},
	'UI': {
		filepaths: ['tgui/'],
		add_only: true,
	},
}

// Title Labels
//
// Add a label based on keywords in the title
export const title_labels = {
	'logging' : {
		keywords: ['log', 'logging'],
	},
	'removal' : {
		keywords: ['remove', 'delete'],
	},
	'code maintenance' : {
		keywords: ['refactor'],
	},
	'unit tests' : {
		keywords: ['unit test'],
	},
	// 'April Fools' : {
	// 	keywords: ['[april fools]'],
	// },
	'DO NOT MERGE' : {
		keywords: ['[dnm]', '[do not merge]'],
	},
	'TEST MERGE ONLY' : {
		keywords: ['[tm only]', '[test merge only]'],
	},
}

// Changelog Labels
//
// Adds labels based on keywords in the changelog
// TODO use the existing changelog parser
export const changelog_labels = {
	'fix': {
		default_text: 'fixed a few things',
		keywords: ['fix', 'fixes', 'bugfix'],
	},
	'quality of life': {
		default_text: 'made something easier to use',
		keywords: ['qol'],
	},
	'sound': {
		default_text: 'added/modified/removed audio or sound effects',
		keywords: ['sound'],
	},
	'feature': {
		default_text: 'Added new mechanics or gameplay changes',
		alt_default_text: 'Added more things',
		keywords: ['add', 'adds', 'rscadd'],
	},
	'removal': {
		default_text: 'Removed old things',
		keywords: ['del', 'dels', 'rscdel'],
	},
	'sprites': {
		default_text: 'added/modified/removed some icons or images',
		keywords: ['image'],
	},
	// 'Grammar and Formatting': {
	// 	default_text: 'fixed a few typos',
	// 	keywords: ['typo', 'spellcheck'],
	// },
	'balance': {
		default_text: 'rebalanced something',
		keywords: ['balance'],
	},
	'code maintenance': {
		default_text: 'changed some code',
		keywords: ['code_imp', 'code', 'refactor'],
	},
	// 'Refactor': {
	// 	default_text: 'refactored some code',
	// 	keywords: ['refactor'],
	// },
	'config': {
		default_text: 'changed some config setting',
		keywords: ['config'],
	},
	'administration': {
		default_text: 'messed with admin stuff',
		keywords: ['admin'],
	},
}
