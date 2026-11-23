within ThermoSysPro.Fluid.Examples.SimpleExamples.Machines;
model TestSteamEngine_Traces
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam (
      extraPropertiesNames={"Trace"},
      C_nominal={0.1},
      C_default={0.2});
  ThermoSysPro.Fluid.Machines.SteamEngine steamEngine1(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP puitsP(redeclare package Medium = Medium, P0=100000) annotation (Placement(transformation(extent={{30,-10},{50,10}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourceP(
    redeclare package Medium = Medium,
    h0=3.e6,
    option_temperature=false,
    P0=1600000,
    SubC0={0.5}) annotation (Placement(transformation(extent={{-50,-10},{-30,10}}, rotation=0)));
equation
  connect(sourceP.C, steamEngine1.C1) annotation (Line(points={{-30,0},{-7,0}}, color={0,0,255}));
  connect(steamEngine1.C2, puitsP.C) annotation (Line(points={{7,0},{30,0}}, color={0,0,255}));
  annotation (
    experiment(StopTime=1000),
    Window(
      x=0.32,
      y=0.02,
      width=0.39,
      height=0.47),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics),
    Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2024 </p>
<p><b>ThermoSysPro Version 4.1 </h4>
</html>"));
end TestSteamEngine_Traces;
