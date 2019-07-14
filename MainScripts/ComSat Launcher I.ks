//comsat launching mission.
CLEARSCREEN.

IF SHIP:STATUS = "PRELAUNCH"{
    RUN LAUNCH(80000).
}

//DEPLOYALL().
//deploy stuff on action groups 1 and 2.
//use 1 for fairing
IF NOT AG1{
    AG1 ON.
}
IF NOT AG2{
    AG2 ON.
}

//RUN CIRCULARISE(80000). cirularisation is dodgy and the launch script is good enough for now
PRINT "MANEUVRE INTO DESIRED SATELLITE ORBIT.".
MONITORFORMANOEUVRES(100).
//Upon exiting monitoring for maneuvres, you should be in a circular orbit that you desire for your satellites
PRINT "RELEASE ONE SATELLITE.".
LOCAL CHAR IS GETVALIDINPUT(FALSE, "ENTER 'F' WHEN FINISHED.  ENTER 'A' TO ABORT", LIST("F", "A"), "ENTER F OR A ONLY.").

if not(CHAR = "A"){
    local DeltaV is GetDeltaVForDiffPeriod((2/3), "KERBIN", "periapsis").
    set M1 to node(time:seconds + eta:periapsis, 0, 0, DeltaV).
    Add M1.
    EXECUTEMANOEUVRE(M1).
    WAIT 60.
    SET M2 TO NODE(TIME:SECONDS + ETA:APOAPSIS, 0, 0, -DeltaV).
    Add M2.
    ExecuteManoeuvre(M2).


    PRINT "RELEASE ONE SATELLITE.".
    LOCAL CHAR IS GETVALIDINPUT(FALSE, "ENTER 'F' WHEN FINISHED.  ENTER 'A' TO ABORT", LIST("F", "A"), "ENTER F OR A ONLY.").

    set M3 to node(time:seconds + 30, 0, 0, DeltaV).
    Add M3.
    EXECUTEMANOEUVRE(M3).
    WAIT 60.
    SET M4 TO NODE(TIME:SECONDS + ETA:APOAPSIS, 0, 0, -DeltaV).
    Add M4.
    ExecuteManoeuvre(M4).

    PRINT "RELEASE ONE SATELLITE.".
    LOCAL CHAR IS GETVALIDINPUT(FALSE, "ENTER 'F' WHEN FINISHED.  ENTER 'A' TO ABORT", LIST("F", "A"), "ENTER F OR A ONLY.").

    PRINT "CONSIDER DEBRIS REMOVAL METHODS.".
    MONITORFORMANOEUVRES(100).

}

