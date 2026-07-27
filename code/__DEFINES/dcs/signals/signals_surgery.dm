/// From /datum/surgery_operation/try_perform(): (datum/surgery_operation/operation, atom/movable/operating_on, tool)
#define COMSIG_LIVING_SURGERY_STARTED "mob_surgery_started"
/// From /datum/surgery_operation/try_perform(): (datum/surgery_operation/operation, atom/movable/operating_on, tool)
#define COMSIG_LIVING_SURGERY_FINISHED "mob_surgery_finished"
/// From /datum/surgery_operation/success(): (datum/surgery_operation/operation, atom/movable/operating_on, tool)
#define COMSIG_LIVING_SURGERY_SUCCESS "mob_surgery_step_success"
/// From /datum/surgery_operation/failure(): (datum/surgery_operation/operation, atom/movable/operating_on, tool)
#define COMSIG_LIVING_SURGERY_FAILED "mob_surgery_step_failed"

/// Sent from /mob/living/perform_surgery: (mob/living/patient, list/possible_operations)
#define COMSIG_LIVING_OPERATING_ON "living_operating_on"
/// Sent from /mob/living/perform_surgery: (mob/living/patient, list/possible_operations)
#define COMSIG_LIVING_BEING_OPERATED_ON "living_being_operated_on"
