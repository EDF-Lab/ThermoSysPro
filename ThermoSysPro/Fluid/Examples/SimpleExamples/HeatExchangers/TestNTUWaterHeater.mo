within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestNTUWaterHeater
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium_e = Properties.Media.WaterSteam;
  replaceable package Medium_c = Properties.Media.WaterSteam;

  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ Water_inlet1(
    redeclare package Medium = Medium_e,
    Q0=1788.90,
    h0=760.83e3,
    P0=8270000) annotation (Placement(transformation(extent={{-174,-16},{-154,4}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.Sink Puit_condenseur2(
    redeclare package Medium = Medium_e) annotation (Placement(transformation(extent={{137,-16},{157,4}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP Steam_inlet1(
    redeclare package Medium = Medium_c,
    option_temperature=false,
    P0=17.49e5,
    h0=2432.50e3) annotation (Placement(transformation(extent={{-174,84},{-154,104}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLoss6(
    redeclare package Medium = Medium_e,
    K=1e-4) annotation (Placement(transformation(extent={{-111,-16},{-91,4}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLoss7(
    redeclare package Medium = Medium_c,
    K=1e-4) annotation (Placement(transformation(extent={{-110,84},{-90,104}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.Sink Puit_condenseur3(
    redeclare package Medium = Medium_c) annotation (Placement(transformation(extent={{136,-75},{156,-55}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLoss8(
    redeclare package Medium = Medium_e,
    K=1e-4) annotation (Placement(transformation(extent={{75,-16},{95,4}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLoss9(
    redeclare package Medium = Medium_c,
    K=1e-4) annotation (Placement(transformation(extent={{75,-75},{95,-55}}, rotation=0)));
  ThermoSysPro.Fluid.HeatExchangers.NTUWaterHeater nTUWaterHeating1(
    redeclare package Medium_e = Medium_e,
    redeclare package Medium_c = Medium_c,
    HeiF(start=900000),
    HDesF(start=900000),
    Hep(start=500000),
    SCondDes=5752,
    Ee(
      P(start=82e5),
      h_vol_2(start=760000),
      Q(start=1790),
      h(start=780000)),
    Ep(Q(start=118)),
    Ev(P(start=27.22e5), h_vol_2(start=2430000)),
    KCond=5024,
    KPurge=1767,
    Sp(h_vol_1(start=780.13e3), h(fixed=true, start=780.13e3)),
    lambdaE=67.1,
    SPurge=1458,
    Se(h(fixed=true, start=872.08e3), P(start=80.19e5, fixed=true))) annotation (Placement(transformation(extent={{-66,-77},{50,65}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLoss10(
    redeclare package Medium = Medium_c,
    K=1e-4) annotation (Placement(transformation(extent={{-110,35},{-90,55}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ Drain_inlet1(
    redeclare package Medium = Medium_c,
    Q0=118.02,
    h0=889.89e3) annotation (Placement(transformation(extent={{-174,35},{-154,55}}, rotation=0)));
equation
  connect(Water_inlet1.C, singularPressureLoss6.C1) annotation (Line(points={{-154,-6},{-111,-6}}, color={0,0,255}));
  connect(Steam_inlet1.C, singularPressureLoss7.C1) annotation (Line(points={{-154,94},{-110,94}}, color={0,0,255}));
  connect(singularPressureLoss8.C2, Puit_condenseur2.C) annotation (Line(points={{95,-6},{137,-6}}, color={0,0,255}));
  connect(singularPressureLoss9.C2, Puit_condenseur3.C) annotation (Line(points={{95,-65},{136,-65}}, color={0,0,255}));
  connect(singularPressureLoss7.C2, nTUWaterHeating1.Ev) annotation (Line(points={{-90,94},{26.8,94},{26.8,18.14}}, color={0,0,255}));
  connect(nTUWaterHeating1.Se, singularPressureLoss8.C1) annotation (Line(points={{50,-6},{75,-6}}, color={0,0,255}));
  connect(singularPressureLoss9.C1, nTUWaterHeating1.Sp) annotation (Line(points={{75,-65},{-44,-65},{-44,-29.43},{-42.8,-29.43}}, color={0,0,255}));
  connect(singularPressureLoss6.C2, nTUWaterHeating1.Ee) annotation (Line(points={{-91,-6},{-66,-6}}, color={0,0,255}));
  connect(Drain_inlet1.C, singularPressureLoss10.C1) annotation (Line(points={{-154,45},{-110,45}}, color={0,0,255}));
  connect(singularPressureLoss10.C2, nTUWaterHeating1.Ep) annotation (Line(points={{-90,45},{-42.8,45},{-42.8,18.14}}, color={0,0,255}));
  annotation (experiment(StopTime=1000), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{200,200}})));
end TestNTUWaterHeater;
