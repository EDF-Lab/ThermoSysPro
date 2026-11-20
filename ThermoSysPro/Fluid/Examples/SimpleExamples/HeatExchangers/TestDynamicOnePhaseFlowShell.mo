within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestDynamicOnePhaseFlowShell
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.WaterSteam;

  ThermoSysPro.Fluid.HeatExchangers.DynamicOnePhaseFlowShell dynamicOnePhaseFlowShell(
    redeclare package Medium = Medium,
    Q(start={536.5750641592207,536.5750641592207,536.5750641592207,536.5750641592207,536.5750641592207,536.5750641592207,536.5750641592207,536.5750641592207,536.5750641592207,536.5750641592207,536.5750641592207}),
    h(start={71016.12237181116,74743.46665892199,78470.81094603281,82198.15523314364,85925.49952025448,89652.84380736532,93380.18809447614,97107.53238158698,100834.8766686978,104562.22095580865,108289.56524291947,70825.9016030344}),
    P(start={300000,281833.41863537,263664.30473175,245492.47958308,227317.76827098,209139.99948382,190959.00534677,172774.621262,154586.68575823,136395.04034906,118199.5293995,100000})) annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourceP(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-50,-10},{-30,10}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkP(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{30,-10},{50,10}}, rotation=0)));
  ThermoSysPro.Thermal.BoundaryConditions.HeatSource heatSource(
    T0={1000,1100,1200,1300,1400,1500,1600,1700,1800,1900},
    option_temperature=2,
    W0={2e6,2e6,2e6,2e6,2e6,2e6,2e6,2e6,2e6,2e6}) annotation (Placement(transformation(extent={{-10,30},{10,50}}, rotation=0)));
  ThermoSysPro.Thermal.HeatTransfer.HeatExchangerWall heatExchangerWall(Ns=10) annotation (Placement(transformation(extent={{-10,10},{10,30}}, rotation=0)));
equation
  connect(sourceP.C, dynamicOnePhaseFlowShell.C1) annotation (Line(points={{-30,0},{-10,0}}, color={0,0,255}));
  connect(dynamicOnePhaseFlowShell.C2, sinkP.C) annotation (Line(points={{10,0},{30,0}}, color={0,0,255}));
  connect(heatSource.C, heatExchangerWall.WT2) annotation (Line(points={{0,30.2},{0,22}}, color={191,95,0}));
  connect(heatExchangerWall.WT1, dynamicOnePhaseFlowShell.CTh) annotation (Line(points={{0,18},{0,3}}, color={191,95,0}));
  annotation (
    experiment(StopTime=1000),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestDynamicOnePhaseFlowShell;
