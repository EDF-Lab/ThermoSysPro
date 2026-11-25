within ThermoSysPro.Examples.Book.SimpleExamples.HeatExchanger;

model TestNTUWaterHeater
  parameter Real KCond1(fixed = false, start = 5024)
    "Condensation heat exchange coefficient computed by initialization";
  parameter Real KPurge1(fixed = false, start = 1767)
    "Purge heat exchange coefficient computed by initialization";
  parameter Real lambdaE1(fixed = false, start = 67.1)
    "Water-side heat exchange coefficient computed by initialization";
  ThermoSysPro.WaterSteam.BoundaryConditions.SourcePQ Water_inlet1(Q0 = 1788.90, h0 = 760.83e3, P0 = 8270000) annotation(
    Placement(transformation(extent = {{-174, -16}, {-154, 4}}, rotation = 0)));
  ThermoSysPro.WaterSteam.BoundaryConditions.Sink Puit_condenseur2 annotation(
    Placement(transformation(extent = {{137, -16}, {157, 4}}, rotation = 0)));
  ThermoSysPro.WaterSteam.BoundaryConditions.SourceP Steam_inlet1(option_temperature = 2, mode = 0, P0 = 17.49e5, h0 = 2432.50e3) annotation(
    Placement(transformation(extent = {{-174, 84}, {-154, 104}}, rotation = 0)));
  ThermoSysPro.WaterSteam.PressureLosses.SingularPressureLoss singularPressureLoss6(K = 1e-4, h(start = 760830), C2(Q(start = 1788.9), P(start = 8270000), h_vol(start = 760830), h(start = 760830))) annotation(
    Placement(transformation(extent = {{-111, -16}, {-91, 4}}, rotation = 0)));
  ThermoSysPro.WaterSteam.PressureLosses.SingularPressureLoss singularPressureLoss7(K = 1e-4, Q(start = 118), h(start = 2432500)) annotation(
    Placement(transformation(extent = {{-110, 84}, {-90, 104}}, rotation = 0)));
  ThermoSysPro.WaterSteam.BoundaryConditions.Sink Puit_condenseur3 annotation(
    Placement(transformation(extent = {{136, -75}, {156, -55}}, rotation = 0)));
  ThermoSysPro.WaterSteam.PressureLosses.SingularPressureLoss singularPressureLoss8(K = 1e-4, h(start = 872080), C1(Q(start = 1788.9), P(start = 8019000), h_vol(start = 872080), h(start = 872080))) annotation(
    Placement(transformation(extent = {{75, -16}, {95, 4}}, rotation = 0)));
  ThermoSysPro.WaterSteam.PressureLosses.SingularPressureLoss singularPressureLoss9(K = 1e-4, h(start = 780130), C1(Q(start = 118), P(start = 2779000), h_vol(start = 780130), h(start = 780130))) annotation(
    Placement(transformation(extent = {{75, -75}, {95, -55}}, rotation = 0)));
  ThermoSysPro.WaterSteam.HeatExchangers.NTUWaterHeating nTUWaterHeating1(HeiF(start = 878165.8), HDesF(start = 872080), Hep(start = 889890), SCondDes = 5752, P(start = 1749000), h(start = 780130), SDes(start = 1e-9), Ee(P(start = 8270000), h_vol(start = 760830), Q(start = 1788.9), h(start = 760830)), Ep(P(start = 2779000), Q(start = 118), h(start = 889890), h_vol(start = 780130)), Ev(P(start = 1749000), Q(start = 118), h(start = 2432500), h_vol(start = 780130)), KCond = KCond1, KPurge = KPurge1, Sp(Q(start = 118), h_vol(start = 780.13e3), h(fixed = true, start = 780.13e3)), lambdaE = lambdaE1, SPurge = 1458, Se(P(start = 80.19e5, fixed = true), Q(start = 1788.9), h_vol(start = 872.08e3), h(fixed = true, start = 872.08e3))) annotation(
    Placement(transformation(extent = {{-66, -77}, {50, 65}}, rotation = 0)));
  ThermoSysPro.WaterSteam.PressureLosses.SingularPressureLoss singularPressureLoss10(K = 1e-4, Q(start = 118), h(start = 889890), C2(Q(start = 118), P(start = 2779000), h_vol(start = 889890), h(start = 889890))) annotation(
    Placement(transformation(extent = {{-110, 35}, {-90, 55}}, rotation = 0)));
  ThermoSysPro.WaterSteam.BoundaryConditions.SourcePQ Drain_inlet1(P0 = 27.79e5, Q0 = 118.02, h0 = 889.89e3) annotation(
    Placement(transformation(extent = {{-174, 35}, {-154, 55}}, rotation = 0)));
equation
  connect(Water_inlet1.C, singularPressureLoss6.C1) annotation(
    Line(points = {{-154, -6}, {-111, -6}}, color = {0, 0, 255}));
  connect(Steam_inlet1.C, singularPressureLoss7.C1) annotation(
    Line(points = {{-154, 94}, {-110, 94}}, color = {0, 0, 255}));
  connect(singularPressureLoss8.C2, Puit_condenseur2.C) annotation(
    Line(points = {{95, -6}, {137, -6}}, color = {0, 0, 255}));
  connect(singularPressureLoss9.C2, Puit_condenseur3.C) annotation(
    Line(points = {{95, -65}, {136, -65}}, color = {0, 0, 255}));
  connect(singularPressureLoss7.C2, nTUWaterHeating1.Ev) annotation(
    Line(points = {{-90, 94}, {26.8, 94}, {26.8, 16.72}}, color = {0, 0, 255}));
  connect(nTUWaterHeating1.Se, singularPressureLoss8.C1) annotation(
    Line(points = {{50, -6}, {75, -6}}, color = {0, 0, 255}));
  connect(singularPressureLoss9.C1, nTUWaterHeating1.Sp) annotation(
    Line(points = {{75, -65}, {-44, -65}, {-44, -29.43}, {-42.8, -29.43}}));
  connect(singularPressureLoss6.C2, nTUWaterHeating1.Ee) annotation(
    Line(points = {{-91, -6}, {-67.16, -6}}, color = {0, 0, 255}));
  connect(Drain_inlet1.C, singularPressureLoss10.C1) annotation(
    Line(points = {{-154, 45}, {-110, 45}}, color = {0, 0, 255}));
  connect(singularPressureLoss10.C2, nTUWaterHeating1.Ep) annotation(
    Line(points = {{-90, 45}, {-42.8, 45}, {-42.8, 18.14}}, color = {0, 0, 255}));
  annotation(
    Diagram(graphics, coordinateSystem(preserveAspectRatio = false, extent = {{-200, -200}, {200, 200}})),
    Icon(graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100.0, -100.0}, {100.0, 100.0}}, radius = 25.0), Rectangle(lineColor = {128, 128, 128}, extent = {{-100.0, -100.0}, {100.0, 100.0}}, radius = 25.0), Polygon(origin = {8.0, 14.0}, lineColor = {78, 138, 73}, fillColor = {78, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-58.0, 46.0}, {42.0, -14.0}, {-58.0, -74.0}, {-58.0, 46.0}})}),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
This model is documented in Sect. 9.5.5.5 of the ThermoSysPro book.  
The results reported in the ThermoSysPro book were computed using Dymola.  
    "));
end TestNTUWaterHeater;
