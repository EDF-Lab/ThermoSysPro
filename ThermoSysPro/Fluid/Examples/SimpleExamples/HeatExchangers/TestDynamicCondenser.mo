within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestDynamicCondenser
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.WaterSteam;
  replaceable package Medium_Cooling = Properties.Media.WaterSteam;

  ThermoSysPro.Fluid.HeatExchangers.DynamicCondenser condenser(
    redeclare package Medium = Medium,
    redeclare package Medium_Cooling = Medium_Cooling,
    Ns=3,
    ntubest=1000,
    ntubesV=50,
    C1vap(P(start=66004), h_vol_2(start=353999)),
    C2vap(P(start=66004), h_vol_2(start=353999)),
    C1(P(start=66004)),
    C2ex(P(start=47631), h(start=370191)),
    DynamicCondenser(
      P(start=66004),
      Pfond(start=47631),
      hv(start=353999),
      hl(start=370191),
      Tp(start=357.683),
      Tp1(start={351.781,354.987,356.535}),
      CvBP(P(start=66004), h_vol_2(start=353999)),
      CvGCT(P(start=66004), h_vol_2(start=353999)),
      Cl(P(start=47631))),
    Wall_3(Tp2(start={351.781,354.987,356.535})),
    pipe_3(
      P(start={107635,105730,103825,101915,100000}),
      mu2(start=fill(9.14034e-4, 4)),
      rho2(start=fill(997.34, 4))),
    sortieReelle(signal(start=-97.6173)),
    dynamic_energy_balance=false,
    dynamic_mass_balance=false,
    inertia=false) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ vaporSource(redeclare package Medium = Medium, Q0=10, h0=2.7e6, option_temperature=false, C(P(start=66004), h_vol_2(start=353999))) annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ extraVaporSource(redeclare package Medium = Medium, Q0=1e-4, h0=2.7e6, option_temperature=false, C(P(start=66004), h_vol_2(start=353999))) annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ extraWaterSource(redeclare package Medium = Medium, Q0=1e-4, h0=1e5, option_temperature=false, C(P(start=66004))) annotation (Placement(transformation(extent={{-70,20},{-50,40}})));
  ThermoSysPro.Fluid.BoundaryConditions.SinkQ condensateSink(redeclare package Medium = Medium, Q0=10.0002, h0=1e5, option_temperature=false, C(P(start=47631), h(start=370191))) annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ coolingSource(redeclare package Medium = Medium_Cooling, Q0=100, h0=1e5, option_temperature=false) annotation (Placement(transformation(extent={{-70,-20},{-50,0}})));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP coolingSink(redeclare package Medium = Medium_Cooling, P0=100000, h0=1e5, option_temperature=false) annotation (Placement(transformation(extent={{50,-20},{70,0}})));
equation
  connect(vaporSource.C, condenser.C1vap) annotation (Line(points={{10,60},{0,60},{0,10}}, color={0,0,255}));
  connect(extraVaporSource.C, condenser.C2vap) annotation (Line(points={{-50,60},{-3.9,60},{-3.9,9.2}}, color={0,0,255}));
  connect(extraWaterSource.C, condenser.C1) annotation (Line(points={{-50,30},{-8.1,30},{-8.1,7.5}}, color={0,0,255}));
  connect(condenser.C2ex, condensateSink.C) annotation (Line(points={{0,-10},{0,-36},{0,-60},{-10,-60}},
                                                                                       color={0,0,255}));
  connect(coolingSource.C, condenser.Ce1) annotation (Line(points={{-50,-10},{-10,-10},{-10,-0.1}}, color={0,0,255}));
  connect(condenser.Ce2, coolingSink.C) annotation (Line(points={{9.9,-0.1},{30,-0.1},{30,-10},{50,-10}}, color={0,0,255}));
  annotation (experiment(StopTime=1), Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestDynamicCondenser;
