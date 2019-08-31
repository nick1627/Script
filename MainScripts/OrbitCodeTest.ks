CLEARSCREEN.


IF SHIP:STATUS = "PRELAUNCH"{
  RUN LAUNCH(80000, 45).
}

AG1 ON.

MONITORFORMANOEUVRES(10000).

//ChangeApOrPe("Apoapsis", 100000). //code is broken, maths is wrong.