within ThermoSysPro.Fluid.Examples.SimpleExamples.Volumes;
model TestTwoPhaseCavityOnePipe_Traces
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Fluid.Examples.SimpleExamples.Media.WaterSteam_FullyVolatileTrace;

  ThermoSysPro.Fluid.Volumes.TwoPhaseCavityOnePipe cavity(
    redeclare package Medium = Medium,
    redeclare function PhasesSeparationFunction = Medium.PhasesSeparation(x=cavity.xv),
    steady_state=false,
    P0=13000000,
    P(start=13000000, fixed=true),
    hl(start=1454400),
    hv(start=2.658e6),
    hvIn(start=2.8e6),
    xv(start=0.01),
    rhol(start=670),
    rhov(start=78),
    Ns=2,
    Vf0=0.5,
    Cal_hcond=false,
    SubCl0={1},
    SubCv0={10}) annotation (Placement(transformation(extent={{-20,-20},{40,40}}, rotation=0)));

  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceWater(
    redeclare package Medium = Medium,
    Q0=1,
    h0=1454400,
    SubC0={1}) annotation (Placement(transformation(extent={{-100,0},{-80,20}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceSteamBP(
    redeclare package Medium = Medium,
    Q0=1,
    h0=2.8e6,
    SubC0={10}) annotation (Placement(transformation(extent={{-80,50},{-60,70}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceSteamGCT(
    redeclare package Medium = Medium,
    Q0=1,
    h0=2.8e6,
    SubC0={10}) annotation (Placement(transformation(extent={{-110,50},{-90,70}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkQ sinkWater(
    redeclare package Medium = Medium, Q0=3)
          annotation (Placement(transformation(extent={{-90,-60},{-70,-40}}, rotation=0)));

  ThermoSysPro.Thermal.BoundaryConditions.HeatSource heatSource(
    T0={293.15, 293.15},
    option_temperature=2,
    W0={1e5, 1e5}) annotation (Placement(transformation(extent={{70,30},{90,50}}, rotation=0)));
equation
  connect(sourceWater.C, cavity.Ce) annotation (Line(points={{-80,10},{-26,10},{-26,25.8},{-12.971,25.8}},
                                                                                                       color={0,0,0}));
  connect(sourceSteamBP.C, cavity.CvBP) annotation (Line(points={{-60,60},{9.82857,60},{9.82857,32}},
                                                                                                color={0,0,0}));
  connect(sourceSteamGCT.C, cavity.CvGCT) annotation (Line(points={{-90,60},{-84,60},{-84,46},{-2.857,46},{-2.857,32}},
                                                                                                           color={0,0,0}));
  connect(cavity.Cl, sinkWater.C) annotation (Line(points={{10,-12},{10,-34},{-94,-34},{-94,-50},{-90,-50}},
                                                                                             color={0,0,0}));
  connect(cavity.Cth3, heatSource.C) annotation (Line(points={{9.82857,21.2},{50,21.2},{50,30.2},{80,30.2}},
                                                                                                          color={255,0,0}));
  annotation (
    experiment(StopTime=1000),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,80}})));
end TestTwoPhaseCavityOnePipe_Traces;
