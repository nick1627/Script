//bootscript

//This program runs automatically on computer startup.
//It checks to see if there are new instructions.

//decide on a file name system.  shipname_1.ks?
//for now, forget the number.  I don't think it's necessary

LOCAL FILENAME IS SHIP:NAME + ".ks".

PRINT SHIP:NAME + " IS IN STARTUP.".

FUNCTION UPDATEALL{
	PRINT "UPDATING FILES...".
	PRINT "ACQUIRING FUNCTIONS...".
	COPYPATH("0:/FUNCTIONS_COMMS.KS", "1:/FUNCTIONS_COMMS.KS").
	COPYPATH("0:/FUNCTIONS_FILES.KS", "1:/FUNCTIONS_FILES.KS").
	COPYPATH("0:/FUNCTIONS_MANOEUVRE.KS", "1:/FUNCTIONS_MANOEUVRE.KS").
	COPYPATH("0:/FUNCTIONS_PROG.KS", "1:/FUNCTIONS_PROG.KS").
	COPYPATH("0:/FUNCTIONS_VESSEL.KS", "1:/FUNCTIONS_VESSEL.KS").
	PRINT "FUNCTION ACQUISITION COMPLETE.".

	PRINT "ACQUIRING LARGER FILES...".
	COPYPATH("0:/LAUNCH.KS", "1:/LAUNCH.KS").
	COPYPATH("0:/LAND.KS", "1:/LAND.KS").
	//COPYPATH("0:/CIRCULARISE.KS", "1:/CIRCULARISE.KS").
	PRINT "ACQUISITION OF LARGER FILES COMPLETE.".
	PRINT "YOU NEED TO DO SOMETHING ABOUT THIS - MAKE THEM INTO FUNCTIONS.".

	LOCAL FILENAME IS SHIP:NAME + ".ks".
	PRINT "ATTEMPTING TO UPDATE MAIN FILE...".
	SWITCH TO 0.
	CD("0:/MainScripts"). //"0:/MainScripts". //used to be switch to 0.
	LIST FILES IN FILELIST.
	FOR F IN FILELIST{
		IF F:NAME = FILENAME{
			//WE CAN UPDATE
			PRINT "UPDATING MAIN FILE...".
			COPYPATH("0:/MainScripts/" + FILENAME, "1:/" + FILENAME).  //OVERWRITE OLD MAIN FILE WITH NEW ONE
		}
	}
	SWITCH TO 1.
	PRINT "FILE UPDATE COMPLETE".
}

FUNCTION RUNFUNCTIONS{
	RUN FUNCTIONS_COMMS.KS.
	RUN FUNCTIONS_FILES.KS.
	RUN FUNCTIONS_MANOEUVRE.KS.
	RUN FUNCTIONS_PROG.KS.
	RUN FUNCTIONS_VESSEL.KS.
}

//check ship status.
if ship:status = "PRELAUNCH"{
	UPDATEALL().
}

//load all functions for later use.
RUNFUNCTIONS().

if ship:status <> "PRELAUNCH" AND CHECKHOMECONNECTION(){
  	UPDATEALL().
	RUNFUNCTIONS().
}

//CLEARALLNODES().
PRINT "BOOTSCRIPT COMPLETE, RUNNING VESSEL FILE.".
LOCAL FILENAME IS SHIP:NAME + ".ks".
RUNPATH("1:/" + FILENAME).
//MAY WANT TO RUN FUNCTIONS AND DO STARTUP IN HERE... or may not... may want ship specific boot files... not all ships need same functions.
