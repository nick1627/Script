CLEARSCREEN.

IF SHIP:STATUS = "PRELAUNCH"{
    print "CHECK CONTROL POINT.".
    wait 20.
    RUN LAUNCH(80000).
}
AG1 ON. //deploy fairing
WAIT 10.
AG2 ON. //extend antenna

UNTIL SHIP:STATUS = "LANDED"{
    PRINT "PERFORM MANOEUVRES TO REACH MUN.".
    PRINT "ONCE AT MUN, PERFORM A DE-ORBIT BURN.".

    MONITORFORMANOEUVRES(100).
    LOCAL STOP IS FALSE.


    UNTIL (STOP OR (SHIP:STATUS = "LANDED")){
        LOCAL CHAR IS GETVALIDINPUT(FALSE, "ENTER L WHEN READY TO LAND, OR E TO EXIT THE LOOP.", LIST("L", "E"), "ENTER L OR E ONLY.").
        IF CHAR = "L"{
            RUN LAND("NULL", 1000, -2).
        }
        IF CHAR = "E"{
            SET STOP TO TRUE.
        }
    }
}

IF SHIP:STATUS = "LANDED"{
    WAIT 5.
    PRINT "MUNA IV HAS LANDED.".
    WAIT 1.

    SAS OFF.
    WAIT 1.
    SAS OFF.
    WAIT 1.
}


