within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestStaticPlateHeatExchanger_Traces
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.WaterSteam (
      extraPropertiesNames={"Trace1","Trace2","Trace3"},
      C_nominal={0.1,0.2,0.3},
      C_default={0.2,0.3,0.4});

  ThermoSysPro.Fluid.HeatExchangers.StaticPlateHeatExchanger staticPlateHeatExchanger(
    redeclare package Medium_c = Medium,
    redeclare package Medium_f = Medium,
    Sp=2,
    Ec(P(start=300000), h(start=280e3)),
    Sc(P(start=100000), h(start=250e3), Q(start=1000)),
    Ef(P(start=300000), h(start=70e3), Q(start=1000)),
    Sf(P(start=100000), h(start=200e3)),
    Tec(start=340),
    Tsc(start=330),
    Tef(start=290),
    Tsf(start=320),
    Tmc(start=335),
    Tmf(start=305),
    Hmc(start=270e3),
    Hmf(start=140e3)) annotation (Placement(transformation(extent={{-10,30},{10,50}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourcePc(
    redeclare package Medium = Medium,
    T0=340,
    SubC0={0.1,0.2,0.3}) annotation (Placement(transformation(extent={{-70,30},{-50,50}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourcePf(
    redeclare package Medium = Medium,
    SubC0={0.4,0.5,0.6}) annotation (Placement(transformation(extent={{-50,10},{-30,30}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkPc(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{50,30},{70,50}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkPf(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{30,10},{50,30}}, rotation=0)));
equation
  connect(sourcePc.C, staticPlateHeatExchanger.Ec) annotation (Line(points={{-50,40},{-10,40}}, color={0,0,255}));
  connect(sourcePf.C, staticPlateHeatExchanger.Ef) annotation (Line(points={{-30,20},{-5,20},{-5,34}}, color={0,0,255}));
  connect(staticPlateHeatExchanger.Sc, sinkPc.C) annotation (Line(points={{10,40},{30,40},{50,40}}, color={0,0,255}));
  connect(staticPlateHeatExchanger.Sf, sinkPf.C) annotation (Line(points={{5,34},{4,34},{4,20},{30,20}}, color={0,0,255}));
  annotation (
    experiment(StopTime=1000),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestStaticPlateHeatExchanger_Traces;
