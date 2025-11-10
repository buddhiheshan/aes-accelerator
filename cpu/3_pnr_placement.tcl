# placement
# https://www.youtube.com/watch?v=bE3GaN4g6Fs

getDesignMode -user -bottomRoutingLayer
getDesignMode -user -topRoutingLayer
setRouteMode -earlyGlobalHonorMsvRouteConstraint false -earlyGlobalRoutePartitionPinGuide true
setEndCapMode -reset
setEndCapMode -boundary_tap false
setNanoRouteMode -quiet -drouteAutoStop 0
setNanoRouteMode -quiet -drouteEndIteration default
setNanoRouteMode -quiet -drouteFixAntenna 0
setNanoRouteMode -quiet -drouteNoTaperOnOutputPin 0
setNanoRouteMode -quiet -droutePostRouteSwapVia {}
setNanoRouteMode -quiet -droutePostRouteSpreadWire 1
setNanoRouteMode -quiet -drouteUseMultiCutViaEffort {}
setNanoRouteMode -quiet -drouteOnGridOnly 0
setNanoRouteMode -quiet -routeIgnoreAntennaTopCellPin 0
setNanoRouteMode -quiet -routeWithViaInPin 0
setNanoRouteMode -quiet -timingEngine {}
setUsefulSkewMode -noBoundary false -maxAllowedDelay 1
setPlaceMode -reset
setPlaceMode -congEffort high -timingDriven 1 -clkGateAware 1 -powerDriven 0 -ignoreScan 1 -reorderScan 1 -ignoreSpare 0 -placeIOPins 0 -moduleAwareSpare 0 -maxDensity 0.7 -preserveRouting 1 -rmAffectedRouting 0 -checkRoute 0 -swapEEQ 0
setPlaceMode -fp false
place_design
