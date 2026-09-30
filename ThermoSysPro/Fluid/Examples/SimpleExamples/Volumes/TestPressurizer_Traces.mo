within ThermoSysPro.Fluid.Examples.SimpleExamples.Volumes;
model TestPressurizer_Traces
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Fluid.Examples.SimpleExamples.Media.WaterSteam_FullyVolatileTrace;

  parameter Units.SI.Power Wch(fixed=true) = 0.29e6 "Power released by the electrical heaters";
  parameter Real OUVfeedwaterValve(fixed=true) = 0.01 "Position of the feedwater valve";

  ThermoSysPro.Fluid.Volumes.Pressurizer pressurizer(
    redeclare package Medium = Medium,
    redeclare function PhasesSeparationFunction = Medium.PhasesSeparation (x=1),
    Zm=10.15,
    Klv=0.5e6,
    cpp=600,
    hl(start=1629887.98290107),
    hv(start=2596216.59571565),
    Zl(start=5.5900717167325),
    Yw0=32.92,
    steady_state=false,
    V=61.12,
    Rp=1.27,
    Ae=96.23,
    Klp=1780,
    Kvp=7500,
    Mp=107e3,
    Kpa=5.63,
    Ccond=0.02,
    Cevap=0.05,
    Yw(start=32.92),
    y(start=0.3292),
    P0=15500000,
    P(start=15500000),
    Tp(start=617.94155291055),
    SubCl0={0},
    SubCv0={10})
                annotation (Placement(transformation(extent={{-20,-20},{40,40}}, rotation=0)));

  ThermoSysPro.Fluid.PressureLosses.ControlValve FeedwaterValve_Spray(
    Cv(start=100),
    C1(
      P(start=160e5),
      h_vol_2(start=1270e3),
      Q(start=0.3),
      h(start=1270e3)),
    Q(fixed=false, start=0.32),
    Cvmax=5000,
    redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-80,36},{-60,56}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourceP(
    option_temperature=false,
    h0=1270e3,
    P0=16000000,
    redeclare package Medium = Medium,
    SubC0={10}) annotation (Placement(transformation(extent={{-138,30},{-118,50}}, rotation=0)));
  InstrumentationAndControl.Blocks.Tables.Table1DTemps FeedwaterValveSpray(Table=[0,OUVfeedwaterValve; 200,OUVfeedwaterValve; 250,OUVfeedwaterValve + 0.005; 300,OUVfeedwaterValve + 0.005; 400,0; 1000,0]) annotation (Placement(transformation(extent={{-104,60},{-78,86}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve SteamValve(
    Cv(start=25000),
    Cvmax(fixed=true) = 5000,
    Pm(start=15500000),
    redeclare package Medium = Medium) annotation (Placement(transformation(extent={{88,36},{108,56}}, rotation=0)));
  InstrumentationAndControl.Blocks.Sources.Constante SteamrValve_O(k(fixed=true) = 0.5) annotation (Placement(transformation(extent={{30,62},{50,82}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkQ sinkQ(
    Q0=0,
    h0=3e6,
    redeclare package Medium = Medium) annotation (Placement(transformation(extent={{136,30},{156,50}}, rotation=0)));
  Thermal.BoundaryConditions.HeatSource SourceC1(
    option_temperature=2,
    T0={310},
    W0={1e5}) annotation (Placement(transformation(
        origin={-67,-12},
        extent={{-17,17},{17,-17}},
        rotation=270)));
  Thermal.BoundaryConditions.HeatSource SourceC2(
    T0={310},
    W0={0.286e6},
    option_temperature=1) annotation (Placement(transformation(
        origin={-67,11},
        extent={{-17,17},{17,-17}},
        rotation=270)));
  InstrumentationAndControl.Blocks.Tables.Table1DTemps ElectricalHeaters(Table=[0,Wch; 100,Wch; 110,Wch; 120,Wch; 300,Wch; 1200,Wch; 1400,Wch*7.75; 1600,Wch*7.75; 1900,Wch; 3000,Wch]) annotation (Placement(transformation(extent={{-109,-25},{-83,1}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss lumpedStraightPipe(
    z1=1,
    z2=0,
    C1(P(start=160e5), redeclare package Medium = Medium),
    C2(P(start=160e5), redeclare package Medium = Medium),
    Q(fixed=false, start=0)) annotation (Placement(transformation(
        origin={10,-44},
        extent={{10,-10},{-10,10}},
        rotation=90)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkQ sinkQ1(
    Q0=0,
    h0=1600000,
    redeclare package Medium = Medium) annotation (Placement(transformation(extent={{12,-78},{32,-58}}, rotation=0)));
  ThermoSysPro.Examples.Control.Drum_LevelControl regulation_Niveau(
    Ti=50,
    add(k1=+1, k2=-1),
    minval=-100,
    pIsat(
      Limiteur1(u(signal(start=0.001))),
      ureset0=0.0,
      maxval=100,
      Ti=2000)) annotation (Placement(transformation(extent={{94,-54},{66,-28}}, rotation=0)));
  InstrumentationAndControl.Blocks.Sources.Constante Level_y100(k=32.92) annotation (Placement(transformation(extent={{129,-58},{110,-39}}, rotation=0)));
equation
  connect(FeedwaterValveSpray.y, FeedwaterValve_Spray.Ouv) annotation (Line(points={{-76.7,73},{-70,73},{-70,57}}, color={0,0,255}));
  connect(SteamrValve_O.y, SteamValve.Ouv) annotation (Line(points={{51,72},{98,72},{98,57}}));
  connect(pressurizer.Cs, SteamValve.C1) annotation (Line(points={{40,39.4},{64,39.4},{64,40},{88,40}}, color={0,0,0}));
  connect(sinkQ.C, SteamValve.C2) annotation (Line(points={{136,40},{108,40}}, color={0,0,0}));
  connect(sourceP.C, FeedwaterValve_Spray.C1) annotation (Line(points={{-118,40},{-80,40}}, color={0,0,0}));
  connect(FeedwaterValve_Spray.C2, pressurizer.Cas) annotation (Line(points={{-60,40},{-24,40},{-24,48},{10,48},{10,40}}, color={0,0,0}));
  connect(SourceC2.C[1], pressurizer.Ca) annotation (Line(points={{-50.34,11},{-33.67,11},{-33.67,10.6},{-17,10.6}}, color={191,95,0}));
  connect(SourceC1.C[1], pressurizer.Cc) annotation (Line(points={{-50.34,-12},{10,-12},{10,0.4}}, color={191,95,0}));
  connect(ElectricalHeaters.y, SourceC1.ISignal) annotation (Line(points={{-81.7,-12},{-75.5,-12}}, color={0,0,255}));
  connect(Level_y100.y, regulation_Niveau.ConsigneNiveauEau) annotation (Line(
      points={{109.05,-48.5},{106,-48.5},{106,-48.8},{94.7,-48.8}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(regulation_Niveau.SortieReelle1, sinkQ1.IMassFlow) annotation (Line(points={{65.3,-52.7},{22,-52.7},{22,-63}}, color={0,0,255}));
  connect(pressurizer.yLevel, regulation_Niveau.MesureNiveauEau) annotation (Line(points={{37,10},{100,10},{100,-29.3},{94.7,-29.3}}, color={0,0,255}));
  connect(pressurizer.Cex, lumpedStraightPipe.C1) annotation (Line(points={{10,-20},{10,-34}}, color={0,0,0}));
  connect(lumpedStraightPipe.C2, sinkQ1.C) annotation (Line(points={{10,-54},{10,-68},{12,-68}}, color={0,0,0}));
  annotation (
    experiment(StopTime=1000),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,80}})));
end TestPressurizer_Traces;
