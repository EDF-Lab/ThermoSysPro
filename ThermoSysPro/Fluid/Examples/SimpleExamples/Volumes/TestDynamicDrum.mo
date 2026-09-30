within ThermoSysPro.Fluid.Examples.SimpleExamples.Volumes;
model TestDynamicDrum
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam;

  ThermoSysPro.Fluid.Volumes.DynamicDrum drum(
    redeclare package Medium = Medium,
    Vertical=false,
    steady_state=false,
    Vv(start=39),
    hl(start=1454400),
    hv(start=2.658e6),
    xv(start=0.01),
    rhol(start=670),
    rhov(start=78),
    P0=13000000,
    P(start=13000000, fixed=true),
    Tp(start=592.6),
    zl(start=1.05)) annotation (Placement(transformation(extent={{-20,-20},{40,40}}, rotation=0)));

  ThermoSysPro.Fluid.BoundaryConditions.SinkQ sinkQ(redeclare replaceable package Medium = Medium, Q0=1)
                                                                                                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,-20})));
equation

  connect(drum.Cs, sinkQ.C) annotation (Line(points={{40,-2},{64,-2},{64,-20},{70,-20}}, color={0,0,0}));
  annotation (
    experiment(StopTime=1000),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,80}})));
end TestDynamicDrum;
