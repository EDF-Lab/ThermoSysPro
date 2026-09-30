within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestSteamGenerator_1SG
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.WaterSteam;
  replaceable package Medium_Primary = Properties.Media.WaterSteam;

  ThermoSysPro.Fluid.HeatExchangers.SteamGenerator_1SG steamGenerator(
    redeclare package Medium = Medium,
    redeclare package Medium_Primary = Medium_Primary,
    DomeGV(
      Cm(h_vol_1(start=1467382.1491761294),
                                   Q(start=3682.6323348377664)),
      hl(start=1239103.1618852438),
      Tp(start=1085.1630860204652, displayUnit="degC"),
      Pfond(start=6537896.329041586, displayUnit="bar")),
    DownComerGV(C2(P(start=6652618.15111204, displayUnit="bar"))),
    fluidInlet(h_vol_2(start=1203352.0170161917)),
    fluidInlet1(P(start=15603447.190394623, displayUnit="bar")),
    fluidOutletI(h_vol_1(start=2.82156e6)),
    fluidOutletI1(h(start=1266398.0525517925)),
    MixAlimDomeGV(P(start=6597719.510802327, displayUnit="bar"),
                                      Cs(h_vol_2(start=1203352.0170161917))),
    outputReal(signal(start=-6.329123415280561)),
    RiserGV(
      h(start={1.20335e6,1.28046e6,1.34313e6,1.39379e6,1.43460e6,1.46738e6,1.46738e6}),
      P(start={6.65262e6,6.63846e6,6.62828e6,6.62094e6,6.61445e6,6.60826e6,6.53790e6}),
      Tp1(start={556.156,555.899,555.700,555.537,555.398}),
      Tp2(start={557.644,557.097,556.655,556.295,555.999}),
      state1(h(start={1280461.0750118925,1343134.833335842,1393794.5882590986,1434595.9090880589,1467382.1491761294}), p(start={6638456.595608159,6628277.414901627,6620936.90876653,6614447.789782153,6608263.233348276}, each displayUnit="bar"))),
    UtubeColdtLeg(
      P(start={1.54474e7,1.54475e7,1.54477e7,1.54482e7,1.54487e7,1.54493e7,1.54500e7}),
      Tp(start={565.892673062783,563.7423137333859,562.0024887705413,560.5974122265403,559.4633025748175}, each displayUnit="degC")),
    UtubeHotLeg(
      P(start={1.56034e7,1.55774e7,1.55514e7,1.55254e7,1.54994e7,1.54734e7,1.54474e7}),
      Tp(start={586.895939774836,580.9426855874689,575.9677586513063,571.864684816329,568.5110695637635}, each displayUnit="degC")),
    DPnulle_AlimDwnc(rho(start=830.6664450130019, displayUnit="g/cm3")),
    dynamic_energy_balance=false,
    dynamic_mass_balance=false,
    inertia=false) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ feedwater(redeclare package Medium = Medium, Q0=531.242, h0=991272, option_temperature=false) annotation (Placement(transformation(extent={{50,30},{70,50}})));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP steamSink(redeclare package Medium = Medium, P0=6600000, h0=2.77257e6, option_temperature=false) annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ primaryInlet(redeclare package Medium = Medium_Primary, Q0=4756, h0=1.47084e6, option_temperature=false) annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP primaryOutlet(redeclare package Medium = Medium_Primary, P0=15450000, h0=1.27187e6, option_temperature=false) annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
equation
  connect(feedwater.C, steamGenerator.fluidInlet) annotation (Line(points={{70,40},{52,40},{52,7.46667},{3.46667,7.46667}}, color={0,0,255}));
  connect(steamGenerator.fluidOutletI, steamSink.C) annotation (Line(points={{0,9.93333},{0,34},{0,60},{-10,60}},
                                                                                                  color={0,0,255}));
  connect(primaryInlet.C, steamGenerator.fluidInlet1) annotation (Line(points={{-50,-60},{-3.06667,-60},{-3.06667,-8.13333}}, color={0,0,255}));
  connect(steamGenerator.fluidOutletI1, primaryOutlet.C) annotation (Line(points={{3.06667,-8.13333},{3.06667,-60},{50,-60}}, color={0,0,255}));
  annotation (experiment(StopTime=1), Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestSteamGenerator_1SG;
