within ThermoSysPro.Fluid.Examples.SimpleExamples.Volumes;
model TestTwoPhaseVolume
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam;
  ThermoSysPro.Fluid.Volumes.TwoPhaseVolume volume(
    steady_state=false,
    P0=13000000,
    P(start=13000000, fixed=true),
    hl(start=1454400),
    hv(start=2.658e6),
    xv(start=0.01),
    rhol(start=670),
    rhov(start=78),
    V=80,
    A=20,
    Vf0=0.5,
    redeclare replaceable package Medium = Medium)  annotation (Placement(transformation(extent={{-20,-20},{40,40}}, rotation=0)));

  ThermoSysPro.Fluid.BoundaryConditions.SinkQ sinkQ(redeclare replaceable package Medium = Medium, Q0=1)
                                                                                                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-40})));
equation
  connect(sinkQ.C, volume.Cl) annotation (Line(points={{20,-40},{10,-40},{10,-20}}, color={0,0,0}));
  annotation (
    experiment(StopTime=1000),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,80}})));
end TestTwoPhaseVolume;
