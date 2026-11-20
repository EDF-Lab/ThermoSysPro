within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestDynamicMultiFluidHeatExchangerShell_Traces
  extends TestDynamicMultiFluidHeatExchangerShell(
    redeclare package Medium_shell = ThermoSysPro.Fluid.Examples.SimpleExamples.Media.WaterSteam_FullyVolatileTrace,
    redeclare package Medium_pipe = ThermoSysPro.Fluid.Examples.SimpleExamples.Media.WaterSteam_FullyVolatileTrace,
    sourcePipe(SubC0={10}),
    sourceShell(SubC0={20}));
end TestDynamicMultiFluidHeatExchangerShell_Traces;
