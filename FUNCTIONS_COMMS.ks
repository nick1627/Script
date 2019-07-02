//for functions that deal with communcaiton links
//something about signal delay?  time for file download?

FUNCTION CHECKHOMECONNECTION{
  //Future project - make this actually check for a connection.
  PRINT "TESTING FOR HOME CONNECTION...".
  LOCAL HOMECONNECTION IS FALSE.
  LIST VOLUMES IN VOLUMELIST.
  FOR VOL IN VOLUMELIST{
      IF VOL:NAME = "ARCHIVE"{
          SET HOMECONNECTION TO TRUE.
          PRINT "HOME CONNECTION EXISTS.".
      }ELSE{
          PRINT "NO HOME CONNECTION.".
      }
  }
  RETURN HOMECONNECTION.
}
