#define TEMPERATURE_DAMAGE_COEFFICIENT 1.5
/// Normal body temperature in Celsius
#define BODYTEMP_NORMAL 37
#define BODYTEMP_AUTORECOVERY_DIVISOR 22
/// degree per second minimum recovery
#define BODYTEMP_AUTORECOVERY_MINIMUM 1
#define BODYTEMP_COLD_DIVISOR 12
#define BODYTEMP_HEAT_DIVISOR 30
/// degrees cooling per second
#define BODYTEMP_COOLING_MAX -5
/// degrees heating per second
#define BODYTEMP_HEATING_MAX 3
/// Death from heat
#define BODYTEMP_MAX_TEMPERATURE 80
/// Death from cold
#define BODYTEMP_MIN_TEMPERATURE -10
/// Above this you take damage
#define BODYTEMP_HEAT_DAMAGE_LIMIT 49
/// Below this you take damage
#define BODYTEMP_COLD_DAMAGE_LIMIT 10

/// Below this, you feel cool
#define AMBIENT_COMFORT_MIN 18
/// Above this, you feel warm
#define AMBIENT_COMFORT_MAX 26
