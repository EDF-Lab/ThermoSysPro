within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestDynamicWaterHeaterOnePipe
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.WaterSteam;
  replaceable package Medium_Cooling = Properties.Media.WaterSteam;

  ThermoSysPro.Fluid.HeatExchangers.DynamicWaterHeaterOnePipe waterHeater(
    redeclare package Medium = Medium,
    redeclare package Medium_Cooling = Medium_Cooling,
    dynamic_energy_balance=true,
    dynamic_mass_balance=true,
    P0c=2200000,
    Vf0=0.43,
    pipe_3(h0=fill(9e5, 20), P0=6900000),
    inertia=false,
    volumeC(P0=6900000, P(start=6900000)),
    volumeD(P0=6900000, P(start=6900000)))
                   annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ steamSource(redeclare package Medium = Medium, Q0=10, h0=2.7e6, option_temperature=false) annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ extraSource(redeclare package Medium = Medium, Q0=1e-4, h0=1e5, option_temperature=false) annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
  ThermoSysPro.Fluid.BoundaryConditions.SinkQ condensateSink(redeclare package Medium = Medium,
    Q0=10 + 1e-4,                                                                                          h0=1e5, option_temperature=false) annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ coolingSource(redeclare package Medium = Medium_Cooling, Q0=100, h0=1e5, option_temperature=false) annotation (Placement(transformation(extent={{-70,-50},{-50,-30}})));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP coolingSink(redeclare package Medium = Medium_Cooling,
    P0=6900000,                                                                                                 h0=1e5, option_temperature=false) annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
equation
  connect(steamSource.C, waterHeater.C1vap) annotation (Line(points={{10,60},{0,60},{0,10}}, color={0,0,255}));
  connect(extraSource.C, waterHeater.C1) annotation (Line(points={{-50,60},{-6.4,60},{-6.4,9.2}}, color={0,0,255}));
  connect(waterHeater.C2ex, condensateSink.C) annotation (Line(points={{0,-10},{0,-36},{0,-60},{-10,-60}},
                                                                                         color={0,0,255}));
  connect(coolingSource.C, waterHeater.Ce1) annotation (Line(points={{-50,-40},{-30,-40},{-30,-4.5},{-10,-4.5}}, color={0,0,255}));
  connect(waterHeater.Ce2, coolingSink.C) annotation (Line(points={{-10,4.4},{-30,4.4},{-30,20},{-70,20}}, color={0,0,255}));
  annotation (experiment(StopTime=1), Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestDynamicWaterHeaterOnePipe;
