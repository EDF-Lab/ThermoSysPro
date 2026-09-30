within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestDynamicMultiFluidHeatExchangerShell
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium_shell = Properties.Media.WaterSteam;
  replaceable package Medium_pipe = Properties.Media.WaterSteam;

  ThermoSysPro.Fluid.HeatExchangers.DynamicMultiFluidHeatExchangerShell exchanger(
    redeclare package Medium_shell = Medium_shell,
    redeclare package Medium_pipe = Medium_pipe,
    Dint=0.016,
    Dext=0.019,
    dynamic_energy_balance=false,
    dynamic_mass_balance=false,
    inertia=false) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourcePipe(redeclare package Medium = Medium_pipe, P0=300000, h0=280000, option_temperature=false) annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkPipe(redeclare package Medium = Medium_pipe, P0=100000, h0=280000, option_temperature=false) annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourceShell(redeclare package Medium = Medium_shell, P0=300000, h0=320000, option_temperature=false) annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkShell(redeclare package Medium = Medium_shell, P0=100000, h0=310000, option_temperature=false) annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
equation
  connect(sourcePipe.C, exchanger.Cws1) annotation (Line(points={{-50,0},{-10,0}}, color={0,0,255}));
  connect(exchanger.Cws2, sinkPipe.C) annotation (Line(points={{10,0},{50,0}}, color={0,0,255}));
  connect(sourceShell.C, exchanger.Cfg1) annotation (Line(points={{10,60},{20,60},{20,5},{0,5}}, color={0,0,255}));
  connect(exchanger.Cfg2, sinkShell.C) annotation (Line(points={{0,-5},{0,-32},{0,-60},{-10,-60}},
                                                                                 color={0,0,255}));
  annotation (experiment(StopTime=1), Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestDynamicMultiFluidHeatExchangerShell;
