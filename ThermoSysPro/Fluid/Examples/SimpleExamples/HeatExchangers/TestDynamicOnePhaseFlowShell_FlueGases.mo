within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestDynamicOnePhaseFlowShell_FlueGases
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.FlueGases(
      extraPropertiesNames={"Trace1","Trace2","Trace3"},
      C_nominal={0.1,0.2,0.3},
      C_default={0.2,0.3,0.4});

  ThermoSysPro.Fluid.HeatExchangers.DynamicOnePhaseFlowShell dynamicOnePhaseFlowShell(
    redeclare package Medium = Medium,
    Ns=1,
    Q(start=fill(36, dynamicOnePhaseFlowShell.Ns + 1)),
    h(start={3077096.0822837264,3135044.986588299,3077096.0822837264}),
    P(start=linspace(
          45,
          44.5,
          dynamicOnePhaseFlowShell.Ns + 2))) annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourceP(
    redeclare package Medium = Medium,
    P0=4500000,
    T0=573.15,
    X0={0,0,1,0,0}) annotation (Placement(transformation(extent={{-50,-10},{-30,10}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkP(
    redeclare package Medium = Medium,
    P0=4450000,
    T0=573.15) annotation (Placement(transformation(extent={{30,-10},{50,10}}, rotation=0)));
  ThermoSysPro.Thermal.BoundaryConditions.HeatSource heatSource(
    T0=fill(726.855, dynamicOnePhaseFlowShell.Ns),
    option_temperature=2,
    W0=fill(2e6/dynamicOnePhaseFlowShell.Ns, dynamicOnePhaseFlowShell.Ns)) annotation (Placement(transformation(extent={{-10,30},{10,50}}, rotation=0)));
  ThermoSysPro.Thermal.HeatTransfer.HeatExchangerWall heatExchangerWall(Ns=dynamicOnePhaseFlowShell.Ns) annotation (Placement(transformation(extent={{-10,10},{10,30}}, rotation=0)));
equation
  connect(sourceP.C, dynamicOnePhaseFlowShell.C1) annotation (Line(points={{-30,0},{-10,0}}, color={0,0,255}));
  connect(dynamicOnePhaseFlowShell.C2, sinkP.C) annotation (Line(points={{10,0},{30,0}}, color={0,0,255}));
  connect(heatSource.C, heatExchangerWall.WT2) annotation (Line(points={{0,30.2},{0,22}}, color={191,95,0}));
  connect(heatExchangerWall.WT1, dynamicOnePhaseFlowShell.CTh) annotation (Line(points={{0,18},{0,3}}, color={191,95,0}));
  annotation (
    experiment(StopTime=1000),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestDynamicOnePhaseFlowShell_FlueGases;
