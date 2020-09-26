//Mission parameters:
//Are travelling from A to B
SET origin TO "KERBIN".
SET destination TO "MUN".
SET orbAltA TO 80000.
SET orbAltB TO 15000.

SET destinationWaypoint TO "NULL".



//Now will deal with statuses and intentions
SET intention TO "neither".
LOCK status TO ship:status.
LOCK currentBody TO ship:body.
SET halt TO false.

CLEARSCREEN.

UNTIL halt = true{
    //have various statuses and intentions

    //available statuses are landed, splashed, prelaunch, flying, sub_orbital, orbiting, escaping and docked
    IF intention = "up"{
        IF status = "PRELAUNCH"{
            RUN launch(orbAltA).
            IF status = "ORBITING"{
                SET intention TO "neither".
            }

        }ELSE IF status = "LANDED"{
            RUN launch(orbAltB).
            IF status = "ORBITING"{
                SET intention TO "neither".
            }

        }ELSE{ 
            SET halt TO true.
        }

    } ELSE IF intention = "neither"{
        IF status = "ORBITING"{
            MonitorForManoeuvres(5).

        } ELSE IF status = "PRELAUNCH"{
            SET intention TO "up".

        } ELSE IF status = "SUB_ORBITAL"{
            SET intention TO "down".
        } ELSE {
            SET halt TO true.
        }

    } ELSE IF intention = "down"{
        IF status = "SUB_ORBITAL"{
            RUN land(destinationWaypoint, 1000, -2).
        } ELSE {
            SET halt TO true.
        }
    } ELSE {
        SET halt TO true.
    }
}

UNLOCK ALL.
WAIT 1.
SAS ON.
WAIT 1.
PRINT("Returning control to manual...").
PRINT("Shutting down...").
WAIT 1.

