within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestSteamGenerator_1SG_Traces
  extends TestSteamGenerator_1SG(
    redeclare package Medium = Properties.Media.WaterSteam,
    redeclare package Medium_Primary = ThermoSysPro.Fluid.Examples.SimpleExamples.Media.WaterSteam_FullyVolatileTrace,
    primaryInlet(SubC0={10}));
end TestSteamGenerator_1SG_Traces;
