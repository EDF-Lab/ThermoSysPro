within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestStaticWallFlueGasesExchanger_Traces
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.FlueGases(
    extraPropertiesNames={"Trace1","Trace2","Trace3"},
    C_nominal={0.1,0.2,0.3},
    C_default={0.2,0.3,0.4});
  parameter Integer Ns=3;
  parameter Medium.MassFraction X0[Medium.nX]={0.1,0.2,0.3,0.2,0.2};

  ThermoSysPro.Fluid.HeatExchangers.StaticWallFlueGasesExchanger exchanger(
    redeclare package Medium = Medium,
    Ns=Ns,
    DPc=1e-4,
    Tp0=500,
    C1(
      P(start=4500000),
      h(start=2879115.64844),
      Q(start=10),
      Xi(start={0.1,0.2,0.3,0.2,0.2}),
      SubC(start={0.1,0.2,0.3})),
    C2(
      P(start=4450000),
      h(start=2820000),
      Q(start=10),
      Xi(start={0.1,0.2,0.3,0.2,0.2}),
      SubC(start={0.1,0.2,0.3})),
    h(start=fill(2879115.64844, Ns + 2)),
    hb(start=fill(2879115.64844, Ns + 1)),
    T1(start=fill(573.15, Ns)),
    T2(start=fill(573.15, Ns + 1))) annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ source(
    redeclare package Medium = Medium,
    P0=4500000,
    Q0=10,
    option_temperature=true,
    T0=573.15,
    X0=X0,
    SubC0={0.1,0.2,0.3}) annotation (Placement(transformation(extent={{-70,-10},{-50,10}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink(
    redeclare package Medium = Medium,
    option_temperature=false,
    h0=2820000) annotation (Placement(transformation(extent={{50,-10},{70,10}}, rotation=0)));
  ThermoSysPro.Thermal.BoundaryConditions.HeatSource wall(
    T0=fill(500, Ns),
    option_temperature=1) annotation (Placement(transformation(extent={{-10,50},{10,70}}, rotation=0)));
equation
  connect(source.C, exchanger.C1) annotation (Line(points={{-50,0},{-10,0}}, color={0,0,255}));
  connect(exchanger.C2, sink.C) annotation (Line(points={{10,0},{50,0}}, color={0,0,255}));
  connect(wall.C, exchanger.CTh) annotation (Line(points={{0,50.2},{0,3}}, color={255,127,0}));
  annotation (experiment(StopTime=1000), Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestStaticWallFlueGasesExchanger_Traces;
