//this script launches a bunch of satellites.

PARAMETER NUMBEROFSATS.
PARAMETER FINALALT.

CLEARSCREEN.


PRINT SHIP:NAME + " IS IN STARTUP.".

PRINT "ACQUIRING FUNCTIONS...".
COPYPATH("0:/FUNCTIONS.KS", "").
RUN FUNCTIONS.KS.
PRINT "FUNCTION ACQUISITION COMPLETE.".

CLEARALLNODES().

LOCAL NUMBEROFSATS IS GETVALIDINPUT(TRUE, "HOW MANY SATELLITES ARE TO BE LAUNCHED?", LIST(0, 10), "ERROR.  TRY AGAIN.").
LOCAL FINALALT IS GETVALIDINPUT(TRUE, "ENTER ALTITUDE OF DESIRED ORBIT:  ", LIST(70000, 85000000), "ERROR!  ALTITUDE MUST BE > 70000.").

COPYPATH("0:/LAUNCH.KS","").
RUN "LAUNCH.KS"(FINALALT).

RUN "CIRCULARISE.KS"(FINALALT).

//deploy satellite



//WANT FUNCTION TO CIRCURLARISE AT NEXT AP/PE WITH JUST ONE BURN.