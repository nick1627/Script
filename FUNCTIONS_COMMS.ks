//for functions that deal with communcaiton links
//something about signal delay?  time for file download?

FUNCTION CHECKHOMECONNECTION{
  //Future project - make this actually check for a connection.
  PRINT "Testing for connection to KSC...".
  LOCAL connect IS FALSE.

  IF HOMECONNECTION:ISCONNECTED{
      SET connect TO True.
      PRINT("Connection to KSC extablished.").
  }ELSE{
      SET connect TO False.
      PRINT("No connection to KSC found.").
  }
//   LIST VOLUMES IN VOLUMELIST.
//   FOR VOL IN VOLUMELIST{
//       IF VOL:NAME = "ARCHIVE"{
//           SET HOMECONNECTION TO TRUE.
//           PRINT "HOME CONNECTION EXISTS.".
//       }ELSE{
//           PRINT "NO HOME CONNECTION.".
//       }
//   }
    RETURN connect.
}
