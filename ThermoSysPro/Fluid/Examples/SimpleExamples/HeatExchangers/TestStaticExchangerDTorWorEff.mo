within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestStaticExchangerDTorWorEff
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.WaterSteam;

  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceWaterSteam_FF(
    redeclare package Medium = Medium,
    C(P(start=219e5)),
    Q0=481.07,
    h0=1067.9e3) annotation (Placement(transformation(extent={{-60,-20},{-40,0}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkWaterSteam_FF(
    redeclare package Medium = Medium,
    P0=217.68e5) annotation (Placement(transformation(extent={{20,-20},{40,0}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceWaterSteam_FC(
    redeclare package Medium = Medium,
    C(P(start=24e5)),
    Q0=23.377,
    h0=3420.3e3) annotation (Placement(transformation(origin={-30,30}, extent={{10,-10},{-10,10}}, rotation=180)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkWaterSteam_FC(
    redeclare package Medium = Medium,
    P0=24.13e5) annotation (Placement(transformation(extent={{-2,20},{20,40}}, rotation=0)));
  ThermoSysPro.Fluid.HeatExchangers.StaticExchangerDTorWorEff exchangerWaterSteamDTorWorEFF(
    redeclare package Medium_c = Medium,
    redeclare package Medium_f = Medium,
    EffEch=1,
    Kf=597.832,
    Ec(P(start=23e5)),
    Ef(P(start=219e5)),
    exchanger_type=3) annotation (Placement(transformation(extent={{-20,-20},{0,0}}, rotation=0)));
equation
  connect(sourceWaterSteam_FF.C, exchangerWaterSteamDTorWorEFF.Ef) annotation (Line(points={{-40,-10},{-20,-10}}, color={0,0,255}));
  connect(exchangerWaterSteamDTorWorEFF.Sf, sinkWaterSteam_FF.C) annotation (Line(points={{0,-9.9},{10.2,-9.9},{10.2,-10},{20,-10}}, color={0,0,255}));
  connect(sourceWaterSteam_FC.C, exchangerWaterSteamDTorWorEFF.Ec) annotation (Line(points={{-20,30},{-14,30},{-14,-5.9}}, color={0,0,255}));
  connect(exchangerWaterSteamDTorWorEFF.Sc, sinkWaterSteam_FC.C) annotation (Line(points={{-6,-5.9},{-6,30},{-2,30}}, color={0,0,255}));
  annotation (experiment(StopTime=1000), Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestStaticExchangerDTorWorEff;
