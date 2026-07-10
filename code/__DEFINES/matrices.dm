/// Helper macro for creating a matrix at the given offsets.
/// Works at compile time.
#define TRANSLATE_MATRIX(offset_x, offset_y) matrix(1, 0, (offset_x), 0, 1, (offset_y))
/**
 * Adds/subtracts overall lightness
 * 0 is identity, 1 makes everything white, -1 makes everything black
 */
#define COLOR_MATRIX_LIGHTNESS(power) list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, power,power,power,0)
/**
 * Changes distance colors have from rgb(127,127,127) grey
 * 1 is identity. 0 makes everything grey >1 blows out colors and greys
 */
#define COLOR_MATRIX_CONTRAST(val) list(val,0,0,0, 0,val,0,0, 0,0,val,0, 0,0,0,1, (1-val)*0.5,(1-val)*0.5,(1-val)*0.5,0)
/// The color matrix of an image which colors haven't been altered. Does nothing.
#define COLOR_MATRIX_IDENTITY list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)
