within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestDynamicMultiFluidHeatExchanger_Traces
  extends TestDynamicMultiFluidHeatExchanger(
    redeclare package Medium_1 = ThermoSysPro.Fluid.Examples.SimpleExamples.Media.WaterSteam_FullyVolatileTrace,
    redeclare package Medium_2 = ThermoSysPro.Fluid.Examples.SimpleExamples.Media.WaterSteam_FullyVolatileTrace,
    source1(SubC0={10}),
    source2(SubC0={20}));
end TestDynamicMultiFluidHeatExchanger_Traces;
