within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestDynamicCondenser_Traces
  extends TestDynamicCondenser(
    redeclare package Medium = Properties.Media.WaterSteam,
    redeclare package Medium_Cooling = ThermoSysPro.Fluid.Examples.SimpleExamples.Media.WaterSteam_FullyVolatileTrace,
    coolingSource(SubC0={10}));
end TestDynamicCondenser_Traces;
