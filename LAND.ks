//this is the landing script.  It lands the vessel at a particular longitude on the surface of the body of choice.
//DE-ORBIT BURN MUST BE COMPLETE BY THIS POINT.
//PARAMETER BODYNAME.
PARAMETER TARGETWAYPOINT.
PARAMETER STARTALT. //ALTITUDE AT WHICH SHIP DOES FIRST DECELERATION BURN.
PARAMETER TOUCHDOWNVELOCITY. //SHOULD BE A NEGATIVE VALUE LIKE -3m/s.
//SHOULD REALLY DO SOME INITIAL CHECKS.

FUNCTION getLandingOrientation{
	// LOCK northPole TO latlng(90,0).
	// LOCK head TO mod(mod(360 - northPole:bearing,360) + 180, 360).
	// LOCK pitch TO -(90 - vectorangle(UP:FOREVECTOR, FACING:FOREVECTOR)).
	// IF pitch < 0{
	// 	LOCK pitch TO 0.
	// }
	// RETURN HEADING(head, pitch).
	SET orientation TO RETROGRADE.
	IF ship:verticalSpeed > 0{
		SET orientation TO UP.
	}
	return orientation.
}


FUNCTION getShipHeight{
	LIST PARTS IN partList.
	SET lp TO 0.//lowest part height
	SET hp TO 0.//highest part height

	FOR p IN partList{
		SET cp TO FACING:VECTOR * p:POSITION.

		IF cp < lp{
			SET lp TO cp.
		}ELSE IF cp > hp{
			SET hp TO cp.
		}
	}
	SET height TO hp - lp.
	return height.
}



PRINT "COMMENCING LANDING...".
PRINT "TARGET PARAMETERS:  ".
PRINT "BODY:  " + SHIP:BODY:NAME + ".".
IF SHIP:BODY:ATM:EXISTS = TRUE{
	PRINT "ATMOSPHERE PRESENT.".
}ELSE{
	PRINT "ATMOSPHERE NOT PRESENT.".
}

SET BODYMASS TO SHIP:BODY:MASS.
SET BODYRADIUS TO SHIP:BODY:RADIUS.
SET SURFGRAV TO (CONSTANT:G*BODYMASS)/(BODYRADIUS*BODYRADIUS).




//DO FIRST BURN THAT TAKES YOU ON PATH OVER TARGET

//DO SECOND BURN TO REDUCE HORIZONTAL VELOCITY TO ZERO

UNLOCK STEERING.
WAIT 1.
SAS ON.
WAIT 1.
LOCAL throt IS 0.
LOCK THROTTLE TO throt.

SET SASMODE TO "RETROGRADE".
WAIT 1.
PRINT "Waiting until RADAR altitude falls below " + STARTALT + "m.".
WAIT UNTIL ALT:RADAR <= STARTALT.
SET SASMODE TO "RETROGRADE".
PRINT "Decelerating for landing burn.".
SET throt TO 1.

WAIT UNTIL SHIP:GROUNDSPEED <= 3.

SET throt TO 0.

WAIT 1.

SAS OFF.
WAIT 0.1.
//DO FINAL LANDING BURN

LOCK STEERING TO getLandingOrientation().

SET throt TO 0.
GEAR ON.

SET shipHeight TO getShipHeight().
SET safetyMargin TO 50.

WAIT UNTIL SHIP:VERTICALSPEED < 0.
WAIT 1.
SET K2 TO 0.5*SHIP:MASS*SHIP:VERTICALSPEED*SHIP:VERTICALSPEED.
SET Y2 TO ALT:RADAR - shipHeight.
SET G2 TO SHIP:MASS*SURFGRAV*Y2.
SET Y1 TO (K2 + G2)/(SHIP:MAXTHRUST) + shipHeight + safetyMargin.
PRINT "Landing burn will commence at " + Y1 + "m above terrain.".

WAIT UNTIL ALT:RADAR <= (Y1).
PRINT "Burning...".
SET THROT TO 1.
WAIT UNTIL SHIP:VERTICALSPEED >= TOUCHDOWNVELOCITY.
SET THROT TO 0.
PRINT "Main burn complete.".

PRINT "Commencing final descent...".
//FOLLOWING LINE DOESN'T WORK IF MASS HAS CHANGED A LOT DURING LANDING
// LOCK THROTTLE to (ship:mass*SURFGRAV/ship:maxthrust).
// wait until alt:radar <= (SHIPHEIGHT + 0.5).

local VKp is 0.01. //THESE PARAMETERS ARE FINE FOR KERBIN
local VKi is 0.005.//PARAMETERS MAY BE POOR FOR OTHER WORLDS
local VKd is 0.005.

local TARGETVEL is 0.
set TARGETVEL to TOUCHDOWNVELOCITY.
print "Touching down at " + TOUCHDOWNVELOCITY + "m/s.".

local VELPID is PIDLOOP(VKp, VKi, VKd, 0, 1).
set VELPID:SETPOINT to TARGETVEL.

until ALT:RADAR <= (shipHeight + 0.5){
	set THROT to VELPID:UPDATE(TIME:SECONDS, SHIP:VERTICALSPEED).
}
set THROT to 0.
wait 1.


//SET THROT TO 0.
//wait 1.
lock THROTTLE to 0.
wait 5.
UNLOCK THROTTLE.
WAIT 1.
SET THROTTLE TO 0.
WAIT 5.


PRINT "LANDING COMPLETE.".

