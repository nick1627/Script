//This file contains functions for performing manoeuvres in space.

FUNCTION GETECCENTRICITY{
    //function to calculate the eccentricity of an orbit given the apoapsis and periapsis.
    //EXPECTING TWO ALTITUDES (NOT INCLUDING CELESTIAL BODY RADIUS)
    PARAMETER R1.
    PARAMETER R2.
    //PARAMETER BODYNAME.  NICK FIX THISSSS!!!!!

    IF R1 < R2{
        local PE is R1.
        local AP is R2.
    }
    IF R1 > R2{
        local PE is R2.
        local AP is R1.
    }
    IF R1 = R2{
        RETURN 0.
    }
    RETURN (AP+KERBIN:RADIUS - (PE + KERBIN:RADIUS))/(AP+KERBIN:RADIUS + (PE + KERBIN:RADIUS)).
}


FUNCTION GETBURNTIME{
    //Finds the time a burn will take.
    PARAMETER DELTAV.  //SCALAR
    PARAMETER ISP.
    PARAMETER THRUST.
    PARAMETER THROT.

    RETURN (-9.81*SHIP:MASS*ISP/(THROT*THRUST))*(CONSTANT:E^((-1*DELTAV)/(9.81*ISP))-1). //why the minus?
}


FUNCTION CHOOSETHROTTLEVALUE{
    //BASED ON A TIME YOU WANT A CERTAIN BURN TO TAKE, THE THROTTLE VALUE IS CALCULATED.
    PARAMETER ISP1.
    PARAMETER M0.
    PARAMETER TIME1.
    PARAMETER TMAX.
    PARAMETER DELTAV.

    RETURN (ISP1*9.81*M0/(TIME1*TMAX))*(CONSTANT:E^((-1*DELTAV)/(9.81*ISP1))-1).
}


FUNCTION GETFINISHTIME{
    //FUNCTION TO FIND THE TIME A BURN WILL FINISH.
    PARAMETER DELTAV1.
    PARAMETER ISP.
    PARAMETER THRUST.
    PARAMETER THROT. //THROTTLE VALUE

    LOCAL BURNTIME1 IS GETBURNTIME(DELTAV1, ISP, THRUST, THROT).
    RETURN TIME:SECONDS + BURNTIME1.
}


FUNCTION WARPTOMANOEUVRE{
    PARAMETER M1.

    //Find burn time
    LOCAL ISP IS GETISPOFCURRENTENGINES().
    LOCAL THRUST IS GETCURRENTMAXTHRUST().

    LOCAL THROT IS 1.
    //burntime comes out different to what game says because game estimates.
    LOCAL BURNTIME IS GETBURNTIME(M1:DElTAV:MAG, ISP, THRUST, THROT).


    SET WARPMODE TO "RAILS".
    WARPTO(TIME:SECONDS + M1:ETA - 60 - (BURNTIME/2)).
}


FUNCTION EXECUTEMANOEUVRE{
    PARAMETER M1. //this is a manoeuvre

    //FIND ISP - could have multiple engines active at once.
    LOCAL ISP IS GETISPOFCURRENTENGINES().

    LOCAL THRUST IS GETCURRENTMAXTHRUST().

    LOCAL THROT IS 1.
    //burntime comes out different to what game says because game estimates.
    LOCAL BURNTIME IS GETBURNTIME(M1:DElTAV:MAG, ISP, THRUST, THROT).
    print "BURNTIME:  ".
    PRINT BURNTIME.
    //Point in direction of burn.
    PRINT "POINTING ALONG BURN VECTOR".
    SAS OFF.
    WAIT 1.
    LOCAL MANOEUVREDIRECTION IS M1:BURNVECTOR.
    LOCK STEERING TO MANOEUVREDIRECTION.

    LOCAL STAGEREQUIRED IS FALSE.
    IF M1:DElTAV:MAG > GETCURRENTSTAGEDELTAV(){ //NEED TO FIX SOMETHING WEIRD HAPPENING HERE.
        SET STAGEREQUIRED TO TRUE.
    }

    LOCAL STOPTIME IS TIME:SECONDS + M1:ETA + (BURNTIME/2).

    WAIT UNTIL TIME:SECONDS >= TIME:SECONDS + M1:ETA - (BURNTIME/2) - 5.

    //Ensure pointing in right direction.
    //LOCAL MANOEUVREDIRECTION IS M1:BURNVECTOR.
    LOCK STEERING TO M1:BURNVECTOR.
    WAIT 5.

    LOCAL TIMELEFT IS 0.
    LOCAL CORRECTION1MADE IS FALSE.
    LOCAL CORRECTION2MADE IS FALSE.

    PRINT "BURNING...".

    LOCK THROTTLE TO THROT.
    SET TIMELEFT TO GETBURNTIME(M1:DELTAV:MAG, ISP, THRUST, THROT).
    UNTIL (M1:DELTAV:MAG<0.1) OR (TIMELEFT < 0.1){//TIME:SECONDS >= GETFINISHTIME(M1:DELTAV:MAG, ISP, THRUST, THROT){
        SET TIMELEFT TO GETBURNTIME(M1:DELTAV:MAG, ISP, THRUST, THROT).

        IF STAGEREQUIRED{
            IF CHECKSTAGEREQUIRED() AND GETNUMBEROFINACTIVEENGINES()>=1{
                STAGE.
                WAIT 0.1.
                //UPDATE VARIOUS VALUES
                IF CHECKFORACTIVEENGINE(){ //ENGINE MUST BE ACTIVE TO ALLOW NEW VALUES TO BE FOUND.
                    SET THRUST TO GETCURRENTMAXTHRUST().
                    SET ISP TO GETISPOFCURRENTENGINES().
                }
            }
        }
        IF TIMELEFT < 5 AND CORRECTION1MADE = FALSE{
            SET THROT TO 0.5.
            //LOCK THROTTLE TO 0.5.
            SET CORRECTION1MADE TO TRUE.
        }
        IF TIMELEFT <= 2 AND CORRECTION2MADE = FALSE{
            SET THROT TO 0.2.
            //LOCK THROTTLE TO 0.2.
            SET CORRECTION2MADE TO TRUE.
        }
    }



    LOCK THROTTLE TO 0.0.
    WAIT 1.
    UNLOCK THROTTLE.
    SET THROTTLE TO 0.0.
    UNLOCK STEERING.
    SAS ON.
    SET THROTTLE TO 0.0.
    Wait 1.
    WAIT 5.
    SAS OFF.

    remove M1.

    //STAGES EVEN IF THERE ISN'T AN ENGINE ON THE NEXT STAGE.  WE SHOULD CHECK THAT FIRST.
}


FUNCTION GETREMAININGDELTAV{
    //function is incorrect.
    PARAMETER DESIREDVELOCITYVECTOR. //THIS MUST BE A VECTOR!
    LOCAL REMAININGVELOCITYVECTOR IS DESIREDVELOCITYVECTOR - SHIP:VELOCITY:ORBIT.
    RETURN REMAININGVELOCITYVECTOR:MAG.
}


FUNCTION CLEARALLNODES{
    PRINT "DELETING ALL PLANNED MANOEUVRES.".
    IF ALLNODES:LENGTH <> 0{
        UNTIL ALLNODES:LENGTH = 0{
            REMOVE NEXTNODE.
        }
    }
}


FUNCTION GETLAUNCHPROFILE{
    //FUNCTION TO GET THE LAUNCH PROFILE DEPENDING ON THE BODY.
}


FUNCTION ABORTNOW{
    //DETECT SITUATION
    //KERBIN
    UNLOCK THROTTLE.
    UNLOCK STEERING.
    WAIT 1.
    SET THROTTLE TO 0.
    PRINT "LOCATION: " + BODY:NAME.
    PRINT "STATUS: " + SHIP:STATUS.

    IF BODY:NAME = "KERBIN"{
        IF SHIP:STATUS = "FLYING" OR SHIP:STATUS = "SUB_ORBITAL"{
            //NEED TO REDUCE VELOCITY AND DEPLOY CHUTES.
            SET NAVMODE TO "SURFACE".
            SAS ON.
            WAIT 1.
            SET SASMODE TO "RETROGRADE".

            LIST ENGINES IN ENGINELIST.
            IF ENGINELIST:LENGTH > 0{

                UNTIL SHIP:VELOCITY:SURFACE:MAG < 200 OR SHIP:ALTITUDE < 1000{
                    SET THROTTLE TO 1.

                    IF CHECKSTAGEREQUIRED{
                        SET SASMODE TO "NORMAL".
                        WAIT 1.
                        STAGE.
                        WAIT 1.
                        SET SASMODE TO "RETROGRADE".
                    }
                }
            }

            UNTIL CHUTES{
                CHUTESAFE ON.
            }

            PRINT "PARACHUTES DEPLOYED".
            WAIT UNTIL SHIP:STATUS = "LANDED" OR SHIP:STATUS = "SPLASHED".
            PRINT "ANOTHER HAPPY LANDING".


        }
    }
}


Function abort{

}

Function MonitorForManoeuvres{
  PARAMETER N. //number of manoeuvres to monitor for.

  LOCAL STOP IS FALSE.

  UNTIL (STOP OR N <=0){
      LOCAL CHAR IS GETVALIDINPUT(FALSE, "TO WARP TO THE NEXT MANOEUVRE, PRESS W.  PRESS E TO EXIT THE LOOP.", LIST("W", "E"), "ENTER W OR E ONLY.").
      IF CHAR = "W"{
          IF HASNODE{
              SET M1 TO NEXTNODE.
              WARPTOMANOEUVRE(M1).
              EXECUTEMANOEUVRE(M1).
              SET N TO N-1.
          }
      }
      IF CHAR = "E"{
          SET STOP TO TRUE.
      }
  }
}

Function Land{
  PARAMETER TARGETWAYPOINT.
  //commencing deorbit burn
  //commencing horizontal velocity cancelling burn
  //commencing landing burn
}

function GetRadius{
    parameter BodyName.
    parameter Alt.

    return Body(BodyName):radius + Alt.
}

function Hohmann{
    parameter InitialAlt.
    parameter FinalAlt.
    parameter BodyName.

    local r1 is GetRadius(BodyName, InitialAlt).
    local r2 is GetRadius(BodyName, FinalAlt).
    local G is Constant:G.
    local M is Body(BodyName):Mass.
    //assumes you are in a circular orbit
    local e is GetEccentricity(InitialAlt, FinalAlt).
    local V1 is sqrt((G*M)/r1).

    if InitialAlt > FinalAlt{
        local V2 is sqrt((G*M*(1 - e))/r1).
        local DeltaV is V2 - V1.
        SET FirstManoeuvre TO NODE(TIME:SECONDS + ETA:PERIAPSIS, 0, 0, DeltaV).
        ADD FirstManoeuvre.
        //should warp for a bit maybe
        EXECUTEMANOEUVRE(FirstManoeuvre).

        set V1 to sqrt(G*M*(1+e)/r2).
        set V2 to sqrt(G*M/r2).
        set DeltaV to V2 - V1.
        set SecondManoeuvre to node(time:seconds + eta:periapsis, 0, 0, DeltaV).

        EXECUTEMANOEUVRE(SecondManoeuvre).

    }else if FinalAlt > InitialAlt{
        local V2 is sqrt((G*M*(1 + e))/r1).
        local DeltaV is V2 - V1.
        SET FirstManoeuvre TO NODE(TIME:SECONDS + ETA:PERIAPSIS, 0, 0, DeltaV).
        ADD FirstManoeuvre.

        EXECUTEMANOEUVRE(FirstManoeuvre).

        set V1 to sqrt(G*M*(1-e)/r2).
        set V2 to sqrt(G*M/r2).
        set DeltaV to V2 - V1.
        set SecondManoeuvre to node(time:seconds + eta:apoapsis, 0, 0, DeltaV).
        add SecondManoeuvre.

        EXECUTEMANOEUVRE(SecondManoeuvre).

    }else{
        print "No need for Hohmann transfer.".
    }
    //I think this function should just return the manoeuvres and not actually perform them.  This should be done 
    //in the main script.
}

function GetDeltaVForDiffPeriod{
    parameter Gamma.  //the fraction of your current period that you want the new period to be 
    //assumes starting from a circular orbit
    //assumes doing burn at periapsis

    parameter BodyName.
    parameter Apsis.


    local G is constant:G.
    local M is body(BodyName):Mass.

    if Apsis = "periapsis"{
        set r1 to GetRadius(BodyName, ship:periapsis).
    }else{
        set r1 to GetRadius(BodyName, ship:apoapsis).
    }
    set r1 to GetRadius(BodyName, ship:periapsis). //what?!

    local v1 is sqrt(G*M/r1).
    local v2 is sqrt((G*M/r1)*(2 - (1/((Gamma^2)^(1/3))))).
    local DeltaV is v2 - v1.

    //set M1 to node(time:seconds + eta:periapsis, 0, 0, DeltaV).

    return DeltaV.
}

function GetSemimajorAxis{
    //takes arguments that do NOT include radius of body.
    //the arguments should be altitudes.
    local parameter Ap.
    parameter Pe.
    parameter BodyName.

    set Ap to GetRadius(BodyName, Ap).
    set Pe to GetRadius(BodyName, Pe).

    return (Ap + Pe)/2.
}

function ChangeApOrPe{
    parameter ApOrPe. //string saying whether it's the apoapsis that's changing or the periapsis
    parameter NewAlt. //new altitude of above thing

    local G is constant:G.
    local BodyName is SHIP:BODY:NAME.
    local M is body(BodyName):Mass.

    if ApOrPe = "APOAPSIS"{
        //must perform manoeuvre at periapsis
        local V1 is VELOCITYAT(SHIP,(TIME + ETA:PERIAPSIS)):ORBIT:MAG.

        local a is GetSemimajorAxis(NewAlt, ship:periapsis, BodyName).

        local V2 is sqrt(G*M*(2/ship:periapsis - 1/a)).

        local DeltaV is V2 - V1.

        local M1 is NODE(TIME:SECONDS + ETA:PERIAPSIS, 0, 0, DeltaV).

        Add M1.

        WARPTOMANOEUVRE(M1).
        EXECUTEMANOEUVRE(M1).
    
    }else if ApOrPe = "PERIAPSIS"{
        //must perform manoeuvre at apoapsis
        local V1 is VELOCITYAT(SHIP,(TIME + ETA:APOAPSIS)):ORBIT:MAG.

        local a is GetSemimajorAxis(ship:apoapsis, NewAlt, BodyName).

        local V2 is sqrt(G*M*(2/ship:apoapsis - 1/a)).

        local DeltaV is V2 - V1.

        local M1 is NODE(TIME:SECONDS + ETA:APOAPSIS, 0, 0, DeltaV).

        Add M1.

        WARPTOMANOEUVRE(M1).
        EXECUTEMANOEUVRE(M1).

    }else{
        print "ERROR:  APOAPSIS OR PERIAPSIS MUST BE SPECIFIED.".
    }
    
    return.
}
