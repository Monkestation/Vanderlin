#define COG_SMALL 1
#define COG_LARGE 2 // keep at double of COG_SMALL

//Relative connection directions
#define CONN_DIR_NONE		(1<<0)
#define CONN_DIR_FORWARD	(1<<1)
#define CONN_DIR_LEFT		(1<<2)
#define CONN_DIR_RIGHT		(1<<3)
#define CONN_DIR_FLIP		(1<<4)
#define CONN_DIR_Z_UP		(1<<5)
#define CONN_DIR_Z_DOWN		(1<<6)

#define CONN_DIR_ALL_CARDINAL CONN_DIR_FORWARD | CONN_DIR_FLIP | CONN_DIR_LEFT | CONN_DIR_RIGHT

//Placing behavior of rotation contraption items
#define PLACE_TOWARDS_USER	1
#define PLACE_ON_PIPE 2
