/* Parameters */
	/* Mouse Buttons */
		/// The left mouse button.
		/// Used mainly as `params[BUTTON_CHANGED] == LEFT_CLICK`, or `params[LEFT_CLICK] = TRUE|FALSE` if needed.
		#define LEFT_CLICK "left"
		/// The middle mouse button.
		/// Used mainly as `params[BUTTON_CHANGED] == MIDDLE_CLICK`, or `params[MIDDLE_CLICK] = TRUE|FALSE` if needed.
		#define MIDDLE_CLICK "middle"
		/// The right mouse button.
		/// Used mainly as `params[BUTTON_CHANGED] == RIGHT_CLICK`, or `params[RIGHT_CLICK] = TRUE|FALSE` if needed.
		#define RIGHT_CLICK "right"

		/// The mouse button that triggered this Click() action.
		/// Used as `params[BUTTON_CHANGED] = LEFT_CLICK|MIDDLE_CLICK|RIGHT_CLICK`.
		#define BUTTON_CHANGED "button"
		/// The mouse button that's being used for a drag action, only used in MouseUp(), MouseDown()
		/// Used as `params[BUTTON_DRAGGED] = LEFT_CLICK|MIDDLE_CLICK|RIGHT_CLICK`.
		#define BUTTON_DRAGGED "drag"

	/* Key Buttons */
		/// Used as `params[CTRL_CLICKED] == TRUE|FALSE`.
		#define CTRL_CLICKED "ctrl"
		/// TRUE if shift was held during this click action.
		/// Used as `params[CTRL_CLICKED] == TRUE|FALSE`.
		#define SHIFT_CLICKED "shift"
		/// TRUE if alt was held during this click action.
		/// Used as `params[CTRL_CLICKED] == TRUE|FALSE`.
		#define ALT_CLICKED "alt"

	/* Coordinates */
		/// The pixel coodinates of the Click() in screen-loc format. `("[tile_x]:[pixel_x],[tile_y]:[pixel_y]") `
		#define SCREEN_LOC "screen-loc"
		/// The pixel coordinates of the Click() within the icon's coordinates.
		/// Ranges from 1 - `icon.Width()`.
		#define ICON_X "icon-x"
		/// The pixel coordinates of the Click() within the icon's coordinates.
		/// Ranges from 1 - `icon.Height()`.
		#define ICON_Y "icon-y"
		/// The screen coordinates of the Click() relative to the icon's lower left corner.
		/// Will be empty if it's the same as ICON_X.
		#define VIS_X "vis-x" //! Very finnicky, but here for completeness.
		/// The screen coordinates of the Click() relative to the icon's lower left corner.
		/// Will be empty if it's the same as ICON_Y.
		#define VIS_Y "vis-y" //! Very finnicky, but here for completeness.

	/* Miscellanious */
		/// If dragging a grid control, will return the name of the cell being dragged.
		#define DRAG_CELL "drag_cell"
		/// If dragging a grid control, will return the name of the cell being dropped on.
		#define DROP_CELL "drop_cell"
		/// If the mouse is over a maptext link, OR if the mouse action is related to clicking a link.
		/// Used as `params[OVER_LINK] == TRUE|FALSE`
		#define OVER_LINK "link"

/* Custom Params */
#define CLICK_CATCHER "catcher"
