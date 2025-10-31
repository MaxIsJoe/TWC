mob/Player/var
    XPObtained
    timeSinceLastUpdate
    challenge_StarveForXP_WarningGave = FALSE

var/challenge_HungerXP_base_warning_time = 350
var/challenge_HungerXP_base_timeout_time = 600
var/challenge_HungerXP_time_scale_factor = 50     // each level adds 5 seconds to each threshold

mob/Player/proc/challenge_StarveForXP()
    if (Exp != XPObtained)
        XPObtained = Exp
        timeSinceLastUpdate = world.time
        challenge_StarveForXP_WarningGave = FALSE
    
    var/time_passed = world.time - timeSinceLastUpdate
    var/warning_time = challenge_HungerXP_base_warning_time + (level * challenge_HungerXP_time_scale_factor)
    var/death_time = challenge_HungerXP_base_timeout_time + (level * challenge_HungerXP_time_scale_factor)

    if((time_passed >= warning_time && time_passed < death_time) && challenge_StarveForXP_WarningGave == FALSE)
        src << "<span style='color:orange;'>You feel your mind hungering for knowledge...</span>"
        challenge_StarveForXP_WarningGave = TRUE
    
    if(time_passed >= death_time)
        challenge_StarveForXP_WarningGave = FALSE
        XPObtained++
        HP = -100
        Death_Check()
