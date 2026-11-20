within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestDynamicTwoPhaseFlowPipe_Traces
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Fluid.Examples.SimpleExamples.Media.WaterSteam_FullyVolatileTrace;

  ThermoSysPro.Fluid.HeatExchangers.DynamicTwoPhaseFlowPipe dynamicTwoPhaseFlowPipe(
    redeclare package Medium = Medium,
    L=10,
    D=0.03,
    C1(SubC(start={0.1})),
    C2(SubC(start={0.1})),
    dpfCorr(fixed=false, start=0.2396333653343408)=1,
    P(start={2000000,1999571.7070274,1999140.9402168,1998707.6248919,1998271.6837223,1997833.0364983,1997391.5998908,1996715.822109,1995640.0182728,1994163.0145856,1992283.4952231,1990000}))
                                          annotation (Placement(transformation(extent={{-40,-48},{40,10}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourceP(
    redeclare package Medium = Medium,
    C(Q(start=1, fixed=true), SubC(start={0.1})),
    option_temperature=false,
    h0=800e3,
    P0=2000000,
    SubC0={0.1}) annotation (Placement(transformation(extent={{-90,-28},{-70,-8}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkP(
    redeclare package Medium = Medium,
    option_temperature=false,
    h0=2000e3,
    P0=19.9e5) annotation (Placement(transformation(extent={{70,-28},{90,-8}}, rotation=0)));
  ThermoSysPro.Thermal.BoundaryConditions.HeatSource heatSource(
    option_temperature=2,
    T0={1000,1100,1200,1300,1400,1500,1600,1700,1800,1900},
    W0={2e4,2e4,2e4,2e4,2e4,2e4,2e4,2e4,2e4,2e4}) annotation (Placement(transformation(extent={{-10,31},{10,51}}, rotation=0)));
  ThermoSysPro.Thermal.HeatTransfer.HeatExchangerWall heatExchangerWall(
    Ns=10,
    L=10,
    lambda=10,
    cpw=460,
    rhow=7900,
    e=0.005,
    D=0.03) annotation (Placement(transformation(extent={{-40,-28},{40,52}}, rotation=0)));
equation
  connect(sourceP.C, dynamicTwoPhaseFlowPipe.C1) annotation (Line(points={{-70,-18},{-42,-18},{-42,-19},{-40,-19}}, color={0,0,255}));
  connect(dynamicTwoPhaseFlowPipe.C2, sinkP.C) annotation (Line(points={{40,-19},{70,-18}}, color={0,0,255}));
  connect(heatSource.C, heatExchangerWall.WT2) annotation (Line(points={{0,31.2},{0,20}}, color={191,95,0}));
  connect(heatExchangerWall.WT1, dynamicTwoPhaseFlowPipe.CTh) annotation (Line(points={{0,4},{0,-10.3}}, color={191,95,0}));
  annotation (experiment(StopTime=1500), Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestDynamicTwoPhaseFlowPipe_Traces;
