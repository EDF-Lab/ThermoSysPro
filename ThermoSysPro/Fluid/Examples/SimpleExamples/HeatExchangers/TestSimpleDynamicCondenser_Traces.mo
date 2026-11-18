within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestSimpleDynamicCondenser_Traces
  extends ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers.TestSimpleDynamicCondenser(
    redeclare package Medium = ThermoSysPro.Fluid.Examples.SimpleExamples.Media.WaterSteam_FullyVolatileTrace) annotation (experiment(StopTime=1000), Icon(coordinateSystem(preserveAspectRatio=false)));
end TestSimpleDynamicCondenser_Traces;
