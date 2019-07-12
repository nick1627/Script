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
PRINT "ENTER 'F' WHEN FINISHED.".
