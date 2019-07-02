//minmus orbit mission.
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
//TRANSFER TO MINMUS
//CAPTURE AROUND MINMUS.
MONITORFORMANOEUVRES(10000).
//PERFORM SCIENCE
//TRANSFER TO KERBIN
//RUN REENTRY.
