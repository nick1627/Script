//script to get graph of pressure
// local AltList is list().
// local TemperatureList is list().
// local Temperature is 0.
// set Kerbin to Body("Kerbin").
// from {local Alt is 0.} until Alt = 70010 step {set Alt to Alt + 10.} do{
//     AltList:add(Alt).
//     set Temperature to Kerbin:Atm:AltitudeTemperature(Alt).
//     TemperatureList:add(Temperature).
//     log Alt + ", " + Temperature to path("0:/Data/KerbinTemperatureData.txt").
// }



set Kerbin to Body("Kerbin").
log "Altitude, Weight, Dynamic Pressure, Pitch1, Pitch2, Airspeed, Vertical speed, Groundspeed" to path("0:/Data/Aircraft.txt").
until false{
    set Alt to Kerbin:altitude.
    set Weight to 9.81*ship:mass.
    set DynamicPressure to Ship:Q.
    set Pitch1 to (90 - vang(ship:up:vector, ship:facing:forevector)).
    set Pitch2 to arctan2(Ship:VerticalSpeed, Ship:GroundSpeed).
    set Airspeed to ship:Airspeed.
    set VerticalSpeed to ship:VerticalSpeed.
    set GroundSpeed to ship:GroundSpeed.
    set LogString to Alt + ", " + Weight + ", " + DynamicPressure + ", " + Pitch1 + ", " + Pitch2 + ", " + Airspeed + ", " + VerticalSpeed + ", " + GroundSpeed.
    log LogString to path("0:/Data/Aircraft.txt").
    Wait 10.
}