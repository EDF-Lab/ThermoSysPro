within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestStaticAerocondenser
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam;
  replaceable package Medium_Air = ThermoSysPro.Properties.Media.FlueGases;

  ThermoSysPro.Fluid.HeatExchangers.StaticAerocondenser staticAerocondenser(
    redeclare package Medium = Medium,
    redeclare package Medium_Air = Medium_Air,
    Se=10000,
    z=0.5,
    Ka=1) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ airSource(
    redeclare package Medium = Medium_Air,
    Q0=1400,
    h0=Medium_Air.specificEnthalpy_pTX(
        p=100000,
        T=293.15,
        X=Medium_Air.X_default)) annotation (Placement(transformation(extent={{40,-30},{20,-10}},rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ drainSource(
    redeclare package Medium = Medium,
    Q0=1,
    T0=340,
    h0=370000) annotation (Placement(transformation(extent={{-40,-20},{-20,0}},   rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ steamSource1(
    redeclare package Medium = Medium,
    Q0=100,
    T0=340,
    h0=2600000) annotation (Placement(transformation(extent={{-40,10},{-20,30}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.Sink condensateSink(
    redeclare package Medium = Medium,
    h0=370000) annotation (Placement(transformation(
        extent={{-10,-70},{10,-50}},
        rotation=-90,
        origin={60,-50})));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP airSink(
    redeclare package Medium = Medium_Air,
    P0=100000,
    T0=293.15) annotation (Placement(transformation(
        extent={{40,50},{60,70}},
        rotation=90,
        origin={80,-20})));
equation
  connect(airSource.C, staticAerocondenser.Cair1) annotation (Line(points={{20,-20},{9.16667,-20},{9.16667,-9.08333}},
                                                                                                       color={0,0,0}));
  connect(drainSource.C, staticAerocondenser.Cw) annotation (Line(points={{-20,-10},{-14,-10},{-14,-7.5},{-9.16667,-7.5}}, color={0,0,0}));
  connect(staticAerocondenser.Cws1, steamSource1.C) annotation (Line(points={{0,9.16667},{0,20},{-20,20}}, color={0,0,0}));
  connect(staticAerocondenser.Cws2, condensateSink.C) annotation (Line(points={{0,-9.16667},{0,-40}},                   color={0,0,0}));
  connect(staticAerocondenser.Cair2, airSink.C) annotation (Line(points={{9.16667,9.16667},{20,9.16667},{20,20}},
                                                                                                      color={0,0,0}));
  annotation (
    experiment(StopTime=1000),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestStaticAerocondenser;
