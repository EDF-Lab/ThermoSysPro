within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestDynamicFlueGasesMultiFluidHeatExchanger
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.WaterSteam;
  replaceable package Medium_FlueGases = Properties.Media.FlueGases;

  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger exchanger(
    redeclare package Medium = Medium,
    redeclare package Medium_FlueGases = Medium_FlueGases,
    h0=fill(1.2e6, 1),
    option_temperature=false,
    ExchangerFlueGasesMetal(h(start=fill(3e6, 3)), hb(start=fill(3e6, 2))),
    dynamic_energy_balance=false,
    dynamic_mass_balance=false,
    inertia=false) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceFg(redeclare package Medium = Medium_FlueGases, Q0=10, h0=3e6, option_temperature=false, X0={0.1,0.2,0.3,0.2,0.2}, C(h(start=3e6), h_vol_1(start=3e6))) annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkFg(redeclare package Medium = Medium_FlueGases, P0=100000, h0=3e6, option_temperature=false, C(h(start=3e6), h_vol_2(start=3e6))) annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourceWs(redeclare package Medium = Medium, P0=300000, h0=1.2e6, option_temperature=false) annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkWs(redeclare package Medium = Medium, P0=100000, h0=1.2e6, option_temperature=false) annotation (Placement(transformation(extent={{50,-10},{70,10}})));
equation
  connect(sourceFg.C, exchanger.Cfg1) annotation (Line(points={{10,60},{20,60},{20,5},{0,5}}, color={0,0,255}));
  connect(exchanger.Cfg2, sinkFg.C) annotation (Line(points={{0,-5},{0,-50}}, color={0,0,255}));
  connect(sourceWs.C, exchanger.Cws1) annotation (Line(points={{-50,0},{-10,0}}, color={0,0,255}));
  connect(exchanger.Cws2, sinkWs.C) annotation (Line(points={{10,0},{50,0}}, color={0,0,255}));
  annotation (experiment(StopTime=1), Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestDynamicFlueGasesMultiFluidHeatExchanger;
