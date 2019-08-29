CLEARSCREEN.

IF SHIP:STATUS = "PRELAUNCH"{
  RUN LAUNCH(80000).
}

MONITORFORMANOEUVRES(10000).

//Now in the landing section of code
local Flag is false.
until Flag{
    list Engines in EngineList.
    if EngineList:length > 0{
        STAGE.
        Wait 1.
    }else{
        set Flag to true.
    }
}
//no engines left.
//should have heat shield out now
SAS off.
wait 5.

//unlock steering.
wait 5.
//SAS on.
lock steering to RETROGRADE.

UNLOCK STEERING.

SAS OFF.

WAIT 1.

//SET SASMODE TO "PROGRADE". 
WAIT 10.
//SET SASMODE TO "RETROGRADE".
wait 10.
panels off.
//SET SASMODE TO "RETROGRADE".
lock steering to RETROGRADE.
wait 1.
lock steering to RETROGRADE.
wait 1.
//now deal with chutes
//SET SASMODE TO "RETROGRADE".
until alt:radar < 90000{
    lock steering to RETROGRADE.
    wait 1.
}
print "Entering atmosphere...".
until chutesSafe{
    lock steering to RETROGRADE.
    wait 1.
}

local Landed is false.


until Landed{
    if (ship:status = "LANDED") or (ship:status = "SPLASHED"){
        set Landed to true.
    }
    chutesSafe on.
}

print "Arrived at Eve.".
wait 60.
panels on.

SET c16 TO SHIP:PARTSDUBBED("Communotron 16").//this section didn't work
SET antennae TO LIST().
FOR antenna IN c16 {
    antennae:ADD(antenna).
}
FOR antenna IN antennae {
    antenna:GETMODULE("ModuleAnimateGeneric"):DOACTION("toggle antenna", true).//doesn't work
}

//consider opening panels and doing science.

