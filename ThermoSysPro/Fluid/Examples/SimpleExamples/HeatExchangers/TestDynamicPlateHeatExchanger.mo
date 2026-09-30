within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestDynamicPlateHeatExchanger
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.WaterSteam;

  ThermoSysPro.Fluid.HeatExchangers.DynamicPlateHeatExchanger dynamicPlateHeatExchanger(
    redeclare package Medium_c = Medium,
    redeclare package Medium_f = Medium,
    Ns=5,
    Sp=2,
    dynamic_energy_balance=false,
    heat_exchange_correlation=0,
    pressure_loss_correlation=0,
    p_Kc=1e-4,
    p_Kf=1e-4,
    state_f2(p(each start=3e5)),
    Ec(
      P(start=300000),
      Q(fixed=true, start=1036),
      h(start=280050)),
    Sc(P(start=100000), h(start=275103), Q(start=1000)),
    Ef(P(start=300000), h(start=280104), Q(start=1000)),
    Sf(P(start=100000), h(start=280076)),
    Pc(start=fill(3e5, 5+2)),
    Pf(start=fill(3e5, 5+2)),
    Qf(start=fill(1000, 5+1)),
    hc(start={280050,280050,280052,280040,280303,275103,275103}),
    hf(start={280076,280104,280154,279724,289301,280000,280000}),
    hbc(start={280050,280050,280052,280040,280303,275103}),
    hbf(start={280076,280104,280154,279724,289301,280000})) annotation (Placement(transformation(extent={{-10,30},{10,50}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourcePc(
    redeclare package Medium = Medium,
    P0=300000,
    option_temperature=false,
    h0=280050) annotation (Placement(transformation(extent={{-70,30},{-50,50}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourcePf(
    redeclare package Medium = Medium,
    P0=300000,
    option_temperature=false,
    h0=280104) annotation (Placement(transformation(extent={{-50,10},{-30,30}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkPc(
    redeclare package Medium = Medium,
    P0(fixed=false) = 100000,
    option_temperature=false,
    h0=275103) annotation (Placement(transformation(extent={{50,30},{70,50}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkPf(
    redeclare package Medium = Medium,
    P0=100000,
    option_temperature=false,
    h0=280076) annotation (Placement(transformation(extent={{30,10},{50,30}}, rotation=0)));
equation
  connect(sourcePc.C, dynamicPlateHeatExchanger.Ec) annotation (Line(points={{-50,40},{-10,40}}, color={0,0,255}));
  connect(sourcePf.C, dynamicPlateHeatExchanger.Ef) annotation (Line(points={{-30,20},{-5,20},{-5,34}}, color={0,0,255}));
  connect(dynamicPlateHeatExchanger.Sc, sinkPc.C) annotation (Line(points={{10,40},{30,40},{50,40}}, color={0,0,255}));
  connect(dynamicPlateHeatExchanger.Sf, sinkPf.C) annotation (Line(points={{5,34},{4,34},{4,20},{30,20}}, color={0,0,255}));
  annotation (
    experiment(StopTime=1000),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestDynamicPlateHeatExchanger;
