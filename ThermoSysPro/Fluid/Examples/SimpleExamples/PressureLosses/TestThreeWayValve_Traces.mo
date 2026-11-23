within ThermoSysPro.Fluid.Examples.SimpleExamples.PressureLosses;
model TestThreeWayValve_Traces
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium =
      ThermoSysPro.Fluid.Examples.SimpleExamples.Media.WaterSteam_FullyVolatileTrace;

  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourceP(
    redeclare replaceable package Medium = Medium,
    P0=300000,
    h0=100000,
    option_temperature=false,
    SubC0={10})
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  ThermoSysPro.Fluid.PressureLosses.ThreeWayValve threeWayValve(
    redeclare replaceable package Medium = Medium,
    C2(Q(start=0)),
    C3(Q(start=2000)),
    Valve1(Pm(start=200000)),
    VolumeA1(h(start=100000)))
    annotation (Placement(transformation(extent={{-10,-6},{10,14}})));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkP1(
    redeclare replaceable package Medium = Medium,
    P0=100000,
    h0=100000,
    option_temperature=false)
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkP2(
    redeclare replaceable package Medium = Medium,
    P0=100000,
    h0=100000,
    option_temperature=false)
    annotation (Placement(transformation(extent={{70,-50},{90,-30}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Rampe ramp(
    Starttime=1,
    Duration=2,
    Initialvalue=0.2,
    Finalvalue=0.8)
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
equation
  connect(sourceP.C, threeWayValve.C1)
    annotation (Line(points={{-70,0},{-10,0}}, color={0,0,255}));
  connect(threeWayValve.C2, sinkP1.C)
    annotation (Line(points={{10,0},{70,0}}, color={255,0,0}));
  connect(threeWayValve.C3, sinkP2.C)
    annotation (Line(points={{0,-6},{0,-40},{70,-40}}, color={255,0,0}));
  connect(ramp.y, threeWayValve.Ouv)
    annotation (Line(points={{-29,40},{0,40},{0,15}}, color={0,0,255}));
  annotation (experiment(StopTime=5),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestThreeWayValve_Traces;
