within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestStaticExchangerKS
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.WaterSteam;

  ThermoSysPro.Fluid.HeatExchangers.StaticExchangerKS staticExchangerKS(
    redeclare package Medium_c = Medium,
    redeclare package Medium_f = Medium,
    K=100,
    S=10,
    exchanger_conf=1) annotation (Placement(transformation(extent={{-20,44},{0,64}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourcePc(
    redeclare package Medium = Medium,
    T0=340) annotation (Placement(transformation(extent={{-80,44},{-60,64}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourcePf(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-60,24},{-40,44}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkPc(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{40,44},{60,64}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkPf(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{20,24},{40,44}}, rotation=0)));
equation
  connect(sourcePc.C, staticExchangerKS.Ec) annotation (Line(points={{-60,54},{-20,54},{-20,51}}, color={0,0,255}));
  connect(sourcePf.C, staticExchangerKS.Ef) annotation (Line(points={{-40,34},{-20,34},{-20,57}}, color={0,0,255}));
  connect(staticExchangerKS.Sc, sinkPc.C) annotation (Line(points={{0,51},{20,51},{20,54},{40,54}}, color={0,0,255}));
  connect(staticExchangerKS.Sf, sinkPf.C) annotation (Line(points={{0,57},{6,57},{6,34},{20,34}}, color={0,0,255}));
  annotation (
    experiment(StopTime=1000),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestStaticExchangerKS;
