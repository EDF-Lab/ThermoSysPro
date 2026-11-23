within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestFixedPowerHeatExchanger_Traces
  extends ThermoSysPro.UsersGuide.Icons.Example;
  extends TestFixedPowerHeatExchanger(
    redeclare replaceable package Medium = Properties.Media.WaterSteam (
        extraPropertiesNames={"Trace1"},
        C_nominal={0.1},
        C_default={0.2}),
    sourcePQ1(SubC0={1}),
    sourcePQ(SubC0={2}));


  annotation (
    experiment(StopTime=1000),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestFixedPowerHeatExchanger_Traces;
