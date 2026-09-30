within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestSimpleEvaporatorWaterSteamFlueGases
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam;
  replaceable package Medium_FlueGases = ThermoSysPro.Properties.Media.FlueGases;

  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceWater(
    redeclare package Medium = Medium,
    Q0=10,
    C(P(start=2000000)),
    h0=300000,
    option_temperature=false) annotation (Placement(transformation(extent={{-80,-10},{-60,10}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkSteam(
    redeclare package Medium = Medium,
    P0=1900000) annotation (Placement(transformation(extent={{60,-10},{80,10}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceFlueGases(
    redeclare package Medium = Medium_FlueGases,
    Q0=50,
    C(P(start=300000)),
    T0=900,
    option_temperature=true,
    X0={0.75,0.1,0.1,0.03,0.02}) annotation (Placement(transformation(extent={{-10,70},{10,50}}, rotation=-90,
        origin={-60,30})));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkFlueGases(
    redeclare package Medium = Medium_FlueGases,
    P0=250000) annotation (Placement(transformation(extent={{-10,-70},{10,-50}}, rotation=-90,
        origin={60,-30})));
  ThermoSysPro.Fluid.HeatExchangers.SimpleEvaporatorWaterSteamFlueGases evaporator(
    redeclare package Medium = Medium,
    redeclare package Medium_FlueGases = Medium_FlueGases,
    Kdpf=0.02,
    Kdpe=0.02,
    Cws1(P(start=2000000), h(start=300000)),
    Cws2(P(start=1900000), h(start=2800000)),
    Cfg1(P(start=300000), h(start=1000000), Xi(start={0.75,0.1,0.1,0.03,0.02})),
    Cfg2(P(start=250000), h(start=500000), Xi(start={0.75,0.1,0.1,0.03,0.02}))) annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0)));
equation
  connect(sourceWater.C, evaporator.Cws1) annotation (Line(points={{-60,0},{-10,0}}, color={0,0,255}));
  connect(evaporator.Cws2, sinkSteam.C) annotation (Line(points={{10,0},{60,0}}, color={0,0,255}));
  connect(sourceFlueGases.C, evaporator.Cfg1) annotation (Line(points={{0,20},{0,9}}, color={0,0,255}));
  connect(evaporator.Cfg2, sinkFlueGases.C) annotation (Line(points={{0,-9},{0,-20}}, color={0,0,255}));
  annotation (
    experiment(StopTime=1000),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestSimpleEvaporatorWaterSteamFlueGases;
