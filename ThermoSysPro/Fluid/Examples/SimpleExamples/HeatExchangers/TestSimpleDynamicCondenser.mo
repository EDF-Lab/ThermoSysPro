within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestSimpleDynamicCondenser
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam;
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss PerteChargeCondPompe(
    redeclare package Medium = Medium,
    K=1e-6,
    Q(start=234.2),
    rho(start=994.7163, displayUnit="g/cm3"),
    C1(P(start=33724.215, displayUnit="bar"))) annotation (Placement(transformation(
        origin={-8,-80},
        extent={{-10,-10},{10,10}},
        rotation=180)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkQ PuitsRechauffeurEau(
    redeclare package Medium = Medium,
    Q0=234.2,
    h0=137.9e3) annotation (Placement(transformation(extent={{-58,-90},{-78,-70}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss PerteChargeCondPompe1(
    redeclare package Medium = Medium,
    K=1e-6,
    rho(start=995.2436, displayUnit="g/cm3")) annotation (Placement(transformation(
        origin={94,-30},
        extent={{10,-10},{-10,10}},
        rotation=180)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss PerteChargeCondPompe2(
    redeclare package Medium = Medium,
    K=1e-6,
    rho(start=998.6793, displayUnit="g/cm3")) annotation (Placement(transformation(
        origin={-22,-30},
        extent={{10,-10},{-10,10}},
        rotation=180)));
  ThermoSysPro.Fluid.HeatExchangers.SimpleDynamicCondenser Condenseur(
    redeclare package Medium = Medium,
    redeclare package Medium_Cooling = Medium,
    D=0.018,
    V=26.592685799971978,
    A=1.0140805624113665,
    lambda=0.01,
    ntubes=30000,
    gravity_pressure=true,
    steady_state=true,
    P0=5010,
    yNiveau(signal(fixed=false, start=1.5)),
    Vf0=0.10,
    P(start=4999.0117,
                  displayUnit="bar"),
    rhom(displayUnit="g/cm3", start=997.1903),
    xv(start=4.3733834E-09),
    Vv(start=23.606508),
    xl(start=-3.5873317E-08))
                   annotation (Placement(transformation(extent={{14,-46},{70,-6}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP source_retourCondensats(
    redeclare package Medium = Medium,
    P0=25560,
    h0=160.7e3,
    option_temperature=false,
    T(start=311.52)) annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  ThermoSysPro.Fluid.Volumes.VolumeC volumeC(redeclare package Medium = Medium, h(start=1861385.9)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={42,40})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP source_autre(
    redeclare package Medium = Medium,
    P0=82050,
    h0=394.5e3,
    option_temperature=false,
    T(start=367.32)) annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss PdC_chaudCond_out(redeclare package Medium = Medium, K=1e-5) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={42,14})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ source_vapLP(
    redeclare package Medium = Medium,
    Q0=194.355 - 9.231 - 9.766 - 9.418,
    h0=2624.5e3,
    option_temperature=false) annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceQ(
    redeclare package Medium = Medium,
    Q0=7006,
    T0=290.68,
    h0=113e3,
    option_temperature=true) annotation (Placement(transformation(extent={{-72,-40},{-52,-20}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP puitsPCaloporteur(
    redeclare package Medium = Medium,
    T0=302.74,
    option_temperature=true) annotation (Placement(transformation(extent={{128,-40},{148,-20}}, rotation=0)));
  ThermoSysPro.Fluid.Machines.StodolaTurbine LP4(
    redeclare package Medium = Medium,
    Cst(
      fixed=false,
      start=92.838486) = 8000,
    eta_is_nom(fixed=false) = 0.8,
    Ce(P(fixed=true, start=30000)),
    Cs(P(fixed=false, start=5010), h(fixed=true, start=2560.8e3))) annotation (Placement(transformation(extent={{20,110},{40,130}})));
  ThermoSysPro.Fluid.PressureLosses.ControlValve controlValve_autre(
    redeclare package Medium = Medium,
    Cvmax(fixed=false) = 8000,
    Q(fixed=true, start=0.1199),
    C2(P(start=5010, fixed=false))) annotation (Placement(transformation(extent={{-20,36},{0,56}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante2 annotation (Placement(transformation(extent={{-28,56},{-20,64}})));
  ThermoSysPro.Fluid.PressureLosses.ControlValve controlValve_retourCondensats(
    redeclare package Medium = Medium,
    Cvmax(fixed=false) = 8000,
    C2(P(start=5010, fixed=false))) annotation (Placement(transformation(extent={{-20,76},{0,96}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante1 annotation (Placement(transformation(extent={{-28,96},{-20,104}})));
equation
  connect(PerteChargeCondPompe2.C2, Condenseur.Cee) annotation (Line(points={{-12,-30},{4,-30},{4,-30.4},{14,-30.4}}, color={0,0,0}));
  connect(PerteChargeCondPompe.C1, Condenseur.Cl) annotation (Line(points={{2,-80},{42.56,-80},{42.56,-46}}));
  connect(PerteChargeCondPompe1.C1, Condenseur.Cse) annotation (Line(points={{84,-30},{70,-30}}));
  connect(PdC_chaudCond_out.C1, volumeC.Cs) annotation (Line(points={{42,24},{42,30}}, color={0,0,0}));
  connect(PdC_chaudCond_out.C2, Condenseur.Cv) annotation (Line(points={{42,4},{42,-6}}, color={0,0,0}));
  connect(sourceQ.C, PerteChargeCondPompe2.C1) annotation (Line(points={{-52,-30},{-32,-30}}, color={0,0,0}));
  connect(PerteChargeCondPompe1.C2, puitsPCaloporteur.C) annotation (Line(points={{104,-30},{128,-30}}, color={0,0,0}));
  connect(LP4.Ce, source_vapLP.C) annotation (Line(points={{19.9,120},{-40,120}}, color={0,0,0}));
  connect(LP4.Cs, volumeC.Ce2) annotation (Line(points={{40.1,120},{58,120},{58,40},{52,40}}, color={0,0,0}));
  connect(source_autre.C, controlValve_autre.C1) annotation (Line(points={{-40,40},{-20,40}}, color={0,0,0}));
  connect(controlValve_autre.C2, volumeC.Ce3) annotation (Line(points={{0,40},{32,40}}, color={0,0,0}));
  connect(controlValve_autre.Ouv, constante2.y) annotation (Line(points={{-10,57},{-10,60},{-19.6,60}}, color={0,0,255}));
  connect(source_retourCondensats.C, controlValve_retourCondensats.C1) annotation (Line(points={{-40,80},{-20,80}}, color={0,0,0}));
  connect(controlValve_retourCondensats.C2, volumeC.Ce1) annotation (Line(points={{0,80},{42,80},{42,50}}, color={0,0,0}));
  connect(constante1.y, controlValve_retourCondensats.Ouv) annotation (Line(points={{-19.6,100},{-10,100},{-10,97}}, color={0,0,255}));
  connect(PuitsRechauffeurEau.C, PerteChargeCondPompe.C2) annotation (Line(points={{-58,-80},{-18,-80}}, color={0,0,0}));

  annotation (experiment(StopTime=1000), Icon(coordinateSystem(preserveAspectRatio=false)));
end TestSimpleDynamicCondenser;
