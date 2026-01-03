//Define to create a tooltip when hovering over an item.
//hover_element - Pointed item
//text - Display text
#define EMBED_TIP(text) "<span class='embedded_tip'><span class='embedded_tip-text'>[text]</span></span>"
#define EMBED_TIP_MINI(hover_element, text) "<span class='embedded_tip embedded_tip--mini'>[hover_element]<span class='embedded_tip-mark'>(?)</span><span class='embedded_tip-text'>[text]</span></span>"

#define X_OFFSET(n_steps, dir) (n_steps * (!!(dir & EAST) + !!(dir & WEST) * -1))
#define Y_OFFSET(n_steps, dir) (n_steps * (!!(dir & NORTH) + !!(dir & SOUTH) * -1))
