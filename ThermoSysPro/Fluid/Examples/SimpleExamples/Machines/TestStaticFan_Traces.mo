within ThermoSysPro.Fluid.Examples.SimpleExamples.Machines;
model TestStaticFan_Traces
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Properties.Media.FlueGases (
      extraPropertiesNames={"Trace"},
      C_nominal={0.1},
      C_default={0.2});

  ThermoSysPro.Fluid.Machines.StaticFan Compressor(
    redeclare package Medium = Medium,
    VRotn=2700,
    rm=1,
    a2=0,
    b1=-1.315,
    b2=2.4593,
    VRot=2700,
    a1=-263.145,
    a3=500,
    Q(start=2),
    Qv(start=1.4),
    rho(start=1.4)) annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ SourceQ1(
    redeclare package Medium = Medium,
    SubC0={0.5},
    X0={1 - 0.006 - 0.23,0.23,0.006,0,0},
    Q0=4,
    P0=130000,
    T0=300,
    option_temperature=true) annotation (Placement(transformation(extent={{-60,-10},{-40,10}}, rotation=0)));

  ThermoSysPro.Fluid.BoundaryConditions.Sink SinkP1(
    redeclare package Medium = Medium,
    T0=300,
    option_temperature=true) annotation (Placement(transformation(
        origin={50,0},
        extent={{10,-10},{-10,10}},
        rotation=180)));
equation
  connect(Compressor.C2, SinkP1.C) annotation (Line(points={{10,0},{40,0}}, color={0,0,0}));
  connect(Compressor.C1, SourceQ1.C) annotation (Line(points={{-10,0},{-40,0}}, color={0,0,0}));
  annotation (Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2021</b> </p>
<p><b>ThermoSysPro Version 4.0</b> </p>
</html>"));
end TestStaticFan_Traces;
