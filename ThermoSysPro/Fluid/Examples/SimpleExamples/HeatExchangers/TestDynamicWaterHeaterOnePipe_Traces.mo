within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestDynamicWaterHeaterOnePipe_Traces
  extends TestDynamicWaterHeaterOnePipe(
    redeclare package Medium = Properties.Media.WaterSteam,
    redeclare package Medium_Cooling = ThermoSysPro.Fluid.Examples.SimpleExamples.Media.WaterSteam_FullyVolatileTrace,
    coolingSource(SubC0={10}));
end TestDynamicWaterHeaterOnePipe_Traces;
