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

local AltList is list().
local PressureList is list().
local Pressure is 0.
set Kerbin to Body("Kerbin").
from {local Alt is 0.} until Alt = 70010 step {set Alt to Alt + 10.} do{
    AltList:add(Alt).
    set Pressure to Kerbin:Atm:AltitudePressure(Alt).
    PressureList:add(Pressure).
    log Alt + ", " + Pressure to path("0:/Data/KerbinPressureData.txt").
}


