//mainly for functions that query the vessel

FUNCTION CHECKFORACTIVEENGINE{
    LIST ENGINES IN ENGINELIST.
    LOCAL ENGINEACTIVE IS FALSE.
    FOR ENG IN ENGINELIST{
        IF ENG:IGNITION{
            SET ENGINEACTIVE TO TRUE.
        }
    }
    RETURN ENGINEACTIVE.
}


FUNCTION GETNUMBEROFINACTIVEENGINES{
    LIST ENGINES IN ENGINELIST.
    LOCAL ACTIVEENGINES IS 0.
    FOR ENG IN ENGINELIST{
        IF ENG:FLAMEOUT = FALSE AND ENG:IGNITION = FALSE{
            SET ACTIVEENGINES TO ACTIVEENGINES + 1.
        }
    }
    RETURN ACTIVEENGINES.
}


FUNCTION CHECKSTAGEREQUIRED{
    //Function to check if staging required.
	LIST ENGINES IN ENGINELIST.
	LOCAL NUMOUT IS 0.
    LOCAL NUMACTIVE IS 0.

	FOR ENG IN ENGINELIST{
		IF ENG:FLAMEOUT{
			SET NUMOUT TO NUMOUT + 1.
		}
        IF ENG:IGNITION{
            SET NUMACTIVE TO NUMACTIVE + 1.
        }
	}

	IF (NUMOUT > 0 OR NUMACTIVE < 1) AND ENGINELIST:LENGTH > 0{
		PRINT "STAGING REQUIRED.".
		RETURN TRUE.
	}ELSE{
		RETURN FALSE.
	}
  //SOMETHING ABOUT STAGE.READY.  CHECK THIS, COULD MAKE IMPROVEMENTS HERE.  EP3
}

FUNCTION doStage{
    //This function performs the staging safely.
    //We assume that staging is required by the 
    //time this function is called.
  
    LOCAL attempts IS 0.
    LOCAL stageComplete IS False.

    //Implement workaround for weird staging bug.
    IF NOT checkStageIntegrity(){
        UNTIL STAGE:READY{
            WAIT 0.
        }
        STAGE.
        WAIT 0.1.
    }


    UNTIL (attempts = 5) OR (stageComplete = True){
        PRINT("Waiting for stage...").
        UNTIL STAGE:READY{
            WAIT 0.
        }
        PRINT("Staging...").
        STAGE.
        WAIT 0.1.
        SET attempts TO attempts + 1.
        LOCAL integrity IS checkStageIntegrity().
        LOCAL activeEng IS CHECKFORACTIVEENGINE().
        IF (integrity = True) AND (activeEng = True){
            SET stageComplete TO True.
        }
    }

    IF (attempts = 5) AND (stageComplete = False){
        PRINT("Staging failed.").
    }
    IF stageComplete{
        PRINT("Staging successful.").
    }
    RETURN stageComplete.
}


FUNCTION GETCURRENTSTAGEDELTAV{//THis function needs fixing!!! not dealing with resources properly I think
    //FIND THE DELTA V OF THE CURRENT STAGE.
    //LOCAL RESLIST IS STAGE:RESOURCES.
    //print stage:resources.
    wait 1.
    LOCAL AMOUNTOFFUEL IS 0.
    //FOR RES IN RESLIST{
    SET AMOUNTOFFUEL TO AMOUNTOFFUEL + STAGE:LIQUIDFUEL + STAGE:OXIDIZER.
    //}
    LOCAL MASSOFFUEL IS AMOUNTOFFUEL * 5.
    LOCAL CURRENTISP IS GETISPOFCURRENTENGINES().

    RETURN GETDELTAV(CURRENTISP, SHIP:MASS * 1000, (SHIP:MASS * 1000) - MASSOFFUEL).
}


FUNCTION GETDELTAV{
    //FINDS DELTA V OF ENGINE IN VACUUM.
    PARAMETER ISP1.
    PARAMETER Mass0.
    PARAMETER Mass1.

    // print "Mass0 in kg".
    // print Mass0.
    // print "Mass1 in kg".
    // print Mass1.

    RETURN ISP1 * 9.81 * LN(Mass0/Mass1).
}


FUNCTION GETISPOFCURRENTENGINES{
    LIST ENGINES IN ENGINELIST.

    LOCAL ISPMSUM IS 0.
    LOCAL MSUM IS 0.
    LOCAL MASSFLOWRATE IS 0.
    FOR ENG IN ENGINELIST {
        IF ENG:IGNITION{
            print("max thrust is " + ENG:MAXTHRUST).
            SET MASSFLOWRATE TO (ENG:MAXTHRUST*1000)/(9.81*ENG:ISP).
            SET ISPMSUM TO ISPMSUM + ENG:ISP*MASSFLOWRATE.
            SET MSUM TO MSUM + MASSFLOWRATE.
        }
    }

    IF engineList:length > 0{
        SET ISP1 TO ISPMSUM/MSUM.
    }ELSE{
        SET ISP1 TO "NULL".
    }

    RETURN ISP1.
}


FUNCTION GETCURRENTMAXTHRUST{
    //Finds the sum of the max thrusts of each active engine.
    LOCAL THRUST IS 0.
    LIST ENGINES IN ENGINELIST.
    FOR ENG IN ENGINELIST{
        IF ENG:IGNITION{
            SET THRUST TO THRUST + ENG:MAXTHRUST.
        }
    }
    RETURN THRUST.
}

FUNCTION DEPLOYALL{
  //DEPLOY ALL SOLAR PANELS, RADIATORS, COMMS ETC.
  //STUFF SHOULD BE TIED TO PANELS AG.
  PANELS ON.
}

FUNCTION QUERYVESSEL{
  //return list of parts within a certain subset of the vessel
  //NEEDS FINISHING
  PARAMETER LOCATION.
  PARAMETER PARTTITLE.

  SET PARTLIST TO SHIP:PARTSTITLED(PARTTITLE).


  RETURN PARTLIST.
}

FUNCTION checkStageIntegrity{
    //Sometimes the stage light will flash green and there
    //are no resources on the current stage.  If this happens,
    //one must stage.  I think.
    LOCAL integrity IS True.

    LOCAL finished IS False.
    LIST ENGINES IN ENGINELIST.
    FOR ENG IN ENGINELIST{
        IF ENG:FLAMEOUT{
            SET finished TO True.
        }
    }

    IF getCurrentMaxThrust() = 0 AND finished = False{
        SET integrity TO False.
    }
    PRINT("Stage integrity:  " + integrity).
    return integrity.
}
