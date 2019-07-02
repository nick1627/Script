//This file contains functions for ease of code and programs rather than for rockets.


FUNCTION GETNUMBERINPUT{
    //function to get user input when input is more than one character
    //Expecting input to be number
    SET NUMBERSTRING TO GETCHARINPUT().

    SET NUMBERTORETURN TO NUMBERSTRING:TONUMBER(0).

    RETURN NUMBERTORETURN.
}


FUNCTION GETCHARINPUT{
    //gets character input in a more controlled way (requiring return to finish).
    LOCAL STOPWAITING IS FALSE.
    LOCAL STRINGTORETURN IS "".
    SET LISTOFCHARACTERS TO LIST().
    UNTIL STOPWAITING{
        SET CHAR TO TERMINAL:INPUT:GETCHAR().
        IF CHAR = TERMINAL:INPUT:RETURN{
            SET STOPWAITING TO TRUE.
        }ELSE{
            PRINT CHAR.
            LISTOFCHARACTERS:ADD(CHAR).
        }
    }
    IF LISTOFCHARACTERS:LENGTH > 1{
        SET STRINGTORETURN TO LISTOFCHARACTERS:JOIN("").
    }ELSE{
        SET STRINGTORETURN TO LISTOFCHARACTERS[0].
    }

    RETURN STRINGTORETURN.
}


FUNCTION GETVALIDINPUT{
    PARAMETER ISNUMBER. //Is the required input a number?
    PARAMETER QUESTION. //the question to present to the user
    PARAMETER ANSWERS.  //IF NUMBER, FIRST ANSWER IS LOWER BOUND, SECOND IS UPPER BOUND.
    PARAMETER ERRORMESSAGE. //COULD MAKE THIS OPTIONAL
    LOCAL VALID IS FALSE.
    LOCAL ANSWER IS 0.
    UNTIL VALID{
        PRINT QUESTION.
        IF ISNUMBER{
            SET ANSWER TO GETNUMBERINPUT().

            IF ANSWER > ANSWERS[0] AND ANSWER < ANSWERS[1]{
                SET VALID TO TRUE.
            }
        }ELSE{
            set ANSWER to GETCHARINPUT().

            FROM {LOCAL COUNT IS 0.} UNTIL COUNT = ANSWERS:LENGTH STEP {SET COUNT TO COUNT + 1.} DO {
                IF ANSWERS[COUNT] = ANSWER{
                    SET VALID TO TRUE.
                }
            }
        }
        IF VALID = FALSE{
            PRINT ERRORMESSAGE.
        }
    }
    RETURN ANSWER.
}


FUNCTION CLOSETO{
    PARAMETER A.
    PARAMETER B.
    PARAMETER C.

    IF ABS(A - B) <= ABS(C){
        RETURN TRUE.
    }ELSE{
        RETURN FALSE.
    }
}
