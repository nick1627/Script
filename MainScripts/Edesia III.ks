CLEARSCREEN.

LOCAL SHIPHEIGHT IS 2.55. //ENTER A HEIGHT.

IF SHIP:STATUS = "PRELAUNCH"{
    print "CHECK CONTROL POINT.".
    wait 20.
    RUN LAUNCH(80000).
}
AG1 ON.
WAIT 10.
AG2 ON.

UNTIL SHIP:STATUS = "LANDED"{
    PRINT "PERFORM MANOEUVRES TO REACH MINMUS.".
    PRINT "ONCE AT MINMUS, PERFORM A DE-ORBIT BURN.".

    MONITORFORMANOEUVRES(10000).
    LOCAL STOP IS FALSE.


    UNTIL (STOP OR (SHIP:STATUS = "LANDED")){
        LOCAL CHAR IS GETVALIDINPUT(FALSE, "ENTER L WHEN READY TO LAND, OR E TO EXIT THE LOOP.", LIST("L", "E"), "ENTER L OR E ONLY.").
        IF CHAR = "L"{
            RUN LAND("NULL", 1000, SHIPHEIGHT, -2).
        }
        IF CHAR = "E"{
            SET STOP TO TRUE.
        }
    }
}

IF SHIP:STATUS = "LANDED"{
    WAIT 5.
    PRINT "EDESIA III HAS LANDED.".
    WAIT 1.
    PRINT "RETRACTING PANELS.".
    TOGGLE AG2.
    WAIT 5.
    PRINT "DEPLOYING ROVER.".
    TOGGLE AG3.
    WAIT 30.
    STAGE.
}

