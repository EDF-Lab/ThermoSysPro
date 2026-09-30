within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestDynamicWaterHeater_Traces
  extends TestDynamicWaterHeater(
    redeclare package Medium = Properties.Media.WaterSteam,
    redeclare package Medium_Cooling = ThermoSysPro.Fluid.Examples.SimpleExamples.Media.WaterSteam_FullyVolatileTrace,
    coolingSource(SubC0={10}));
end TestDynamicWaterHeater_Traces;
