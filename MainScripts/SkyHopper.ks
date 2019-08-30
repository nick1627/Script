//HOVERSCRIPT
local AKp is 0.01.
local AKi is 0.001.
local AKd is 0.005.//0.005

local VKp is 0.01.
local VKi is 0.001.
local VKd is 0.009.

local TARGETALT is 500.
local TARGETVEL IS -5.

clearscreen.
print "TESTING HOVER SCRIPT".


local ALTPID is PIDLOOP(AKp, AKi, AKd, 0, 1).
set ALTPID:SETPOINT to TARGETALT.

local VELPID is PIDLOOP(VKp, VKi, VKd, 0, 1).
set VELPID:SETPOINT to TARGETVEL.

lock STEERING to HEADING(90, 90).
local THROT is 0.
lock THROTTLE to THROT.

stage.
wait 1.
local InitialFuel is STAGE:LIQUIDFUEL.


wait 1.
print "LAUNCHING...".
print "TRAVELLING TO ALTITUDE OF " + TARGETALT + " METRES.".
//stage.
gear off.
local n is 0.
log "New Attempt" to path("0:/Data/AltitudePID.txt").
log "Kp:  " + AKp to path("0:/Data/AltitudePID.txt").
log "Ki:  " + AKi to path("0:/Data/AltitudePID.txt").
log "Kd:  " + AKd to path("0:/Data/AltitudePID.txt").

log "Time, Altitude" to path("0:/Data/AltitudePID.txt").

until STAGE:LIQUIDFUEL < (0.001*InitialFuel){
    set THROT to ALTPID:UPDATE(TIME:SECONDS, ALT:RADAR).
    wait 0.001.
    set n to n + 1.
    if MOD(n, 100) = 0{
        set LogString to TIME:SECONDS + ", " + ALT:RADAR.
        log LogString to path("0:/Data/AltitudePID.txt").
    }
}
log "" to path("0:/Data/AltitudePID.txt").
print "NOW DESCENDING...".
gear on.
// until STAGE:LIQUIDFUEL <= 0{
//     set THROT to VELPID:UPDATE(TIME:SECONDS, SHIP:VERTICALSPEED).
// }
print "OUT OF FUEL".
set THROT to 0.

chutesSafe on.

until ALT:RADAR < 10{
    chutesSafe on.
}

chutes on.

unlock THROTTLE.
wait 0.1.
set THROTTLE to 0.
wait 2.
