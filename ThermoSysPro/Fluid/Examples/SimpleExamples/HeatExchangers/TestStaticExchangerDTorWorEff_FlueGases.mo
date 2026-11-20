within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestStaticExchangerDTorWorEff_FlueGases
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.FlueGases;
  parameter Medium.MassFraction X0[Medium.nX]={0.1,0.2,0.3,0.2,0.2};

  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceFlueGases_FF(
    redeclare package Medium = Medium,
    C(P(start=4500000), Xi(start={0.1,0.2,0.3,0.2,0.2})),
    Q0=481.07,
    option_temperature=true,
    T0=573.15,
    X0=X0) annotation (Placement(transformation(extent={{-60,-20},{-40,0}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkFlueGases_FF(
    redeclare package Medium = Medium,
    P0=4450000,
    T0=573.15) annotation (Placement(transformation(extent={{20,-20},{40,0}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceFlueGases_FC(
    redeclare package Medium = Medium,
    C(P(start=300000), Xi(start={0.1,0.2,0.3,0.2,0.2})),
    Q0=23.377,
    option_temperature=true,
    T0=673.15,
    X0=X0) annotation (Placement(transformation(origin={-30,30}, extent={{10,-10},{-10,10}}, rotation=180)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkFlueGases_FC(
    redeclare package Medium = Medium,
    P0=100000,
    T0=573.15) annotation (Placement(transformation(extent={{-2,20},{20,40}}, rotation=0)));
  ThermoSysPro.Fluid.HeatExchangers.StaticExchangerDTorWorEff exchangerFlueGasesDTorWorEFF(
    redeclare package Medium_c = Medium,
    redeclare package Medium_f = Medium,
    EffEch=0.8,
    Kc=1e-4,
    Kf=1e-4,
    Ec(P(start=300000), h(start=3379115.64844), Xi(start={0.1,0.2,0.3,0.2,0.2})),
    Sc(P(start=100000), h(start=3200000), Xi(start={0.1,0.2,0.3,0.2,0.2})),
    Ef(P(start=4500000), h(start=2879115.64844), Xi(start={0.1,0.2,0.3,0.2,0.2})),
    Sf(P(start=4450000), h(start=3000000), Xi(start={0.1,0.2,0.3,0.2,0.2})),
    Tec(start=673.15),
    Tsc(start=640),
    Tef(start=573.15),
    Tsf(start=600),
    exchanger_type=3) annotation (Placement(transformation(extent={{-20,-20},{0,0}}, rotation=0)));
equation
  connect(sourceFlueGases_FF.C, exchangerFlueGasesDTorWorEFF.Ef) annotation (Line(points={{-40,-10},{-20,-10}}, color={0,0,255}));
  connect(exchangerFlueGasesDTorWorEFF.Sf, sinkFlueGases_FF.C) annotation (Line(points={{0,-9.9},{10.2,-9.9},{10.2,-10},{20,-10}}, color={0,0,255}));
  connect(sourceFlueGases_FC.C, exchangerFlueGasesDTorWorEFF.Ec) annotation (Line(points={{-20,30},{-14,30},{-14,-5.9}}, color={0,0,255}));
  connect(exchangerFlueGasesDTorWorEFF.Sc, sinkFlueGases_FC.C) annotation (Line(points={{-6,-5.9},{-6,30},{-2,30}}, color={0,0,255}));
  annotation (experiment(StopTime=1000), Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestStaticExchangerDTorWorEff_FlueGases;
