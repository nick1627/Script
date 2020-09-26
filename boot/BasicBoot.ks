core:part:getmodule("kOSProcessor"):doevent("Open Terminal").
WAIT 1.
IF ship:status = "PRELAUNCH" OR homeConnection:isconnected{
  COPYPATH("0:/boot/Bootscript.ks","1:/boot/Bootscript.ks").
}
PRINT "RUNNING BOOTSCRIPT...".
runpath("1:/boot/Bootscript.ks").
