within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestDynamicWaterSteamMultiFluidsHeatExchanger_Traces
  extends TestDynamicWaterSteamMultiFluidsHeatExchanger(
    redeclare package Medium_1 = ThermoSysPro.Fluid.Examples.SimpleExamples.Media.WaterSteam_FullyVolatileTrace,
    redeclare package Medium_2 = ThermoSysPro.Fluid.Examples.SimpleExamples.Media.WaterSteam_FullyVolatileTrace,
    source1(SubC0={10}),
    source2(SubC0={20}));
end TestDynamicWaterSteamMultiFluidsHeatExchanger_Traces;
