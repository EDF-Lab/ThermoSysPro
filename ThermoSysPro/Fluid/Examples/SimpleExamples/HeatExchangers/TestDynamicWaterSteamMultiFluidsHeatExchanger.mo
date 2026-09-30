within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestDynamicWaterSteamMultiFluidsHeatExchanger
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium_1 = Properties.Media.WaterSteam;
  replaceable package Medium_2 = Properties.Media.WaterSteam;

  ThermoSysPro.Fluid.HeatExchangers.DynamicWaterSteamMultiFluidsHeatExchanger exchanger(
    redeclare package Medium_1 = Medium_1,
    redeclare package Medium_2 = Medium_2,
    dynamic_energy_balance=false,
    dynamic_mass_balance=false,
    inertia=false) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP source1(redeclare package Medium = Medium_1, P0=300000, h0=280000, option_temperature=false) annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sink1(redeclare package Medium = Medium_1, P0=100000, h0=280000, option_temperature=false) annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP source2(redeclare package Medium = Medium_2, P0=300000, h0=1.2e6, option_temperature=false) annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sink2(redeclare package Medium = Medium_2, P0=100000, h0=1.2e6, option_temperature=false) annotation (Placement(transformation(extent={{50,-10},{70,10}})));
equation
  connect(source1.C, exchanger.Cfg1) annotation (Line(points={{10,60},{20,60},{20,5},{0,5}}, color={0,0,255}));
  connect(exchanger.Cfg2, sink1.C) annotation (Line(points={{0,-5},{0,-32},{0,-60},{-10,-60}},
                                                                             color={0,0,255}));
  connect(source2.C, exchanger.Cws1) annotation (Line(points={{-50,0},{-10,0}}, color={0,0,255}));
  connect(exchanger.Cws2, sink2.C) annotation (Line(points={{10,0},{50,0}}, color={0,0,255}));
  annotation (experiment(StopTime=1), Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestDynamicWaterSteamMultiFluidsHeatExchanger;
