within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestDynamicFlueGasesMultiFluidHeatExchanger_Traces
  extends TestDynamicFlueGasesMultiFluidHeatExchanger(
    redeclare package Medium = ThermoSysPro.Fluid.Examples.SimpleExamples.Media.WaterSteam_FullyVolatileTrace,
    redeclare package Medium_FlueGases = Properties.Media.FlueGases(extraPropertiesNames={"Trace1"}, C_nominal={0.1}, C_default={0.2}),
    sourceFg(SubC0={30}),
    sourceWs(SubC0={10}));
end TestDynamicFlueGasesMultiFluidHeatExchanger_Traces;
