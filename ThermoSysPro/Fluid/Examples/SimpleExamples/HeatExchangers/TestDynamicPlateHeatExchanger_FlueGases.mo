within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestDynamicPlateHeatExchanger_FlueGases
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium_c = Properties.Media.FlueGases;
  replaceable package Medium_f = Properties.Media.FlueGases;

  ThermoSysPro.Fluid.HeatExchangers.DynamicPlateHeatExchanger dynamicPlateHeatExchanger(
    redeclare package Medium_c = Medium_c,
    redeclare package Medium_f = Medium_f,
    Ns=5,
    Sp=2,
    dynamic_energy_balance=false,
    heat_exchange_correlation=0,
    pressure_loss_correlation=0,
    p_hc=100,
    p_hf=100,
    p_Kc=1e-4,
    p_Kf=1e-4,
    Ec(P(start=4500000), h(start=2879115.64844), Xi(start={0.1,0.2,0.3,0.2,0.2})),
    Sc(P(start=4450000), h(start=2879115.64844), Q(start=117275.047014), Xi(start={0.1,0.2,0.3,0.2,0.2})),
    Ef(P(start=300000), h(start=2879115.64844), Q(start=49585.430645), Xi(start={0.1,0.2,0.3,0.2,0.2})),
    Sf(P(start=100000), h(start=2879115.64844), Xi(start={0.1,0.2,0.3,0.2,0.2})),
    hc(start=fill(2879115.64844, 7)),
    hf(start=fill(2879115.64844, 7)),
    hbc(start=fill(2879115.64844, 6)),
    hbf(start=fill(2879115.64844, 6)),
    Tc1(start=fill(573.15, 5)),
    Tf1(start=fill(573.15, 5)),
    Tc2(start=fill(573.15, 6)),
    Tf2(start=fill(573.15, 6))) annotation (Placement(transformation(extent={{-10,30},{10,50}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourcePc(
    redeclare package Medium = Medium_c,
    P0=4500000,
    T0=573.15,
    X0={0.1,0.2,0.3,0.2,0.2}) annotation (Placement(transformation(extent={{-70,30},{-50,50}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourcePf(
    redeclare package Medium = Medium_f,
    P0=300000,
    T0=573.15,
    X0={0.1,0.2,0.3,0.2,0.2}) annotation (Placement(transformation(extent={{-50,10},{-30,30}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkPc(
    redeclare package Medium = Medium_c,
    P0=4450000,
    T0=573.15) annotation (Placement(transformation(extent={{50,30},{70,50}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkPf(
    redeclare package Medium = Medium_f,
    P0=100000,
    T0=573.15) annotation (Placement(transformation(extent={{30,10},{50,30}}, rotation=0)));
equation
  connect(sourcePc.C, dynamicPlateHeatExchanger.Ec) annotation (Line(points={{-50,40},{-10,40}}, color={0,0,255}));
  connect(sourcePf.C, dynamicPlateHeatExchanger.Ef) annotation (Line(points={{-30,20},{-5,20},{-5,34}}, color={0,0,255}));
  connect(dynamicPlateHeatExchanger.Sc, sinkPc.C) annotation (Line(points={{10,40},{30,40},{50,40}}, color={0,0,255}));
  connect(dynamicPlateHeatExchanger.Sf, sinkPf.C) annotation (Line(points={{5,34},{4,34},{4,20},{30,20}}, color={0,0,255}));
  annotation (
    experiment(StopTime=1000),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestDynamicPlateHeatExchanger_FlueGases;
