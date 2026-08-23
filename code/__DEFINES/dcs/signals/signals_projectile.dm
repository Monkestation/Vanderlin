// /obj/projectile signals (sent to the firer)
/// from base of /obj/projectile/proc/on_hit(): (atom/movable/firer, atom/target, Angle)
#define COMSIG_PROJECTILE_ON_HIT "projectile_on_hit"
/// from base of /obj/projectile/proc/fire(): (obj/projectile, atom/original_target)
#define COMSIG_PROJECTILE_BEFORE_FIRE "projectile_before_fire"
/// sent to targets during the process_hit proc of projectiles
#define COMSIG_PROJECTILE_PREHIT "com_proj_prehit"
#define COMSIG_PROJECTILE_SELF_ON_HIT "projectile_self_on_hit"
