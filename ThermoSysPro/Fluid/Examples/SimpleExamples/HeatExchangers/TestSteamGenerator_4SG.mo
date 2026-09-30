within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestSteamGenerator_4SG
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.WaterSteam;
  replaceable package Medium_Primary = Properties.Media.WaterSteam;

  ThermoSysPro.Fluid.HeatExchangers.SteamGenerator_4SG steamGenerator(
    redeclare package Medium = Medium,
    redeclare package Medium_Primary = Medium_Primary,
    dynamic_energy_balance=false,
    dynamic_mass_balance=false,
    inertia=false) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ feedwater(redeclare package Medium = Medium,
    Q0=4*531.242,                                                                                        h0=991272, option_temperature=false) annotation (Placement(transformation(extent={{50,30},{70,50}})));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP steamSink(redeclare package Medium = Medium, P0=6600000, h0=2.77257e6, option_temperature=false) annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ primaryInlet(redeclare package Medium = Medium_Primary,
    Q0=4*4756,                                                                                                   h0=1.47084e6, option_temperature=false) annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP primaryOutlet(redeclare package Medium = Medium_Primary, P0=15450000, h0=1.27187e6, option_temperature=false) annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
equation
  connect(feedwater.C, steamGenerator.fluidInlet) annotation (Line(points={{70,40},{52,40},{52,7.46667},{3.46667,7.46667}}, color={0,0,255}));
  connect(steamGenerator.fluidOutletI, steamSink.C) annotation (Line(points={{0,9.93333},{0,34},{0,60},{-10,60}},
                                                                                                  color={0,0,255}));
  connect(primaryInlet.C, steamGenerator.fluidInlet1) annotation (Line(points={{-50,-60},{-3.06667,-60},{-3.06667,-8.13333}}, color={0,0,255}));
  connect(steamGenerator.fluidOutletI1, primaryOutlet.C) annotation (Line(points={{3.06667,-8.13333},{3.06667,-60},{50,-60}}, color={0,0,255}));
  annotation (experiment(StopTime=1), Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestSteamGenerator_4SG;
