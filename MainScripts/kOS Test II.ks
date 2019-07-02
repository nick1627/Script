CLEARSCREEN.
print "TESTING PART QUERY SCRIPT".

Set Escape to False.
Set CurrentPart to ship:rootpart.

until Escape{
  print CurrentPart:Title.
  set OPTIONSLIST TO LIST("U", "D", "E").
  LOCAL INSTRUCTION IS GETVALIDINPUT(FALSE, "DO YOU WISH TO GO UP (U) OR DOWN (D)? (E TO ESCAPE)", Optionslist, "ERROR.  TRY AGAIN.").
  IF INSTRUCTION = "U"{
    IF CURRENTPART:HASPARENT = "TRUE"{
      SET CURRENTPART TO CURRENTPART:PARENT.
    }ELSE{
      PRINT "THIS PART DOES NOT HAVE A PARENT.".
    }
  }
  IF INSTRUCTION = "D"{
    SET LISTOFCHILDREN TO CURRENTPART:CHILDREN.
    print LISTOFCHILDREN.
    LOCAL NEXTPARTTITLE IS GETVALIDINPUT(FALSE, "SELECT A PART", LISTOFCHILDREN:TITLE, "ERROR.  TRY AGAIN.").
    FOR P IN LISTOFCHILDREN{
      IF NEXTPARTTITLE = LISTOFCHILDREN[P]:TITLE{
        SET PARTNUMBER TO P.
      }
    }
    SET CURRENTPART TO LISTOFCHILDREN[P].//PART WITH TITLE THAT WAS SELECTED FINISH HERE!!!!!
  }
  IF INSTRUCTION = "E"{
    PRINT "ESCAPING...".
    SET ESCAPE TO TRUE.
  }
}
