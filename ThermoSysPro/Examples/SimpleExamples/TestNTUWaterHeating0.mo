within ThermoSysPro.Examples.SimpleExamples;

model TestNTUWaterHeating0
  ThermoSysPro.WaterSteam.BoundaryConditions.SourcePQ Source_condenseur(P0 = 80.0e5, Q0 = 1780, h0 = 872.0e3) annotation(
    Placement(transformation(extent = {{-182, -10}, {-162, 10}}, rotation = 0)));
  ThermoSysPro.WaterSteam.BoundaryConditions.Sink Puit_condenseur annotation(
    Placement(transformation(extent = {{152, -10}, {172, 10}}, rotation = 0)));
  ThermoSysPro.WaterSteam.BoundaryConditions.SourceP sourceP(option_temperature = 2, mode = 0, P0 = 27.e5, h0 = 2.6e6) annotation(
    Placement(transformation(extent = {{-182, 88}, {-162, 108}}, rotation = 0)));
  ThermoSysPro.WaterSteam.PressureLosses.SingularPressureLoss singularPressureLoss2(K = 1e-4, h(start = 872000), C2(Q(start = 1780), P(start = 80e5), h_vol(start = 872000), h(start = 872000))) annotation(
    Placement(transformation(extent = {{-106, -10}, {-86, 10}}, rotation = 0)));
  ThermoSysPro.WaterSteam.PressureLosses.SingularPressureLoss singularPressureLoss3(K = 1e-4, Q(start = 112.2867), h(start = 2600e3)) annotation(
    Placement(transformation(extent = {{-106, 88}, {-86, 108}}, rotation = 0)));
  ThermoSysPro.WaterSteam.BoundaryConditions.Sink Puit_condenseur1 annotation(
    Placement(transformation(extent = {{152, -106}, {172, -86}}, rotation = 0)));
  ThermoSysPro.WaterSteam.PressureLosses.SingularPressureLoss singularPressureLoss4(K = 1e-4, h(start = 980281.1), C1(Q(start = 1780), P(start = 7618062.5), h_vol(start = 980281.1), h(start = 980281.1))) annotation(
    Placement(transformation(extent = {{92, -10}, {112, 10}}, rotation = 0)));
  ThermoSysPro.WaterSteam.PressureLosses.SingularPressureLoss singularPressureLoss5(K = 1e-4, h(start = 883498.1), C1(Q(start = 112.2867), P(start = 27e5), h_vol(start = 883498.1), h(start = 883498.1))) annotation(
    Placement(transformation(extent = {{34, -106}, {54, -86}}, rotation = 0)));
  ThermoSysPro.WaterSteam.HeatExchangers.NTUWaterHeating nTUWaterHeating(lambdaE = 102.5, SCondDes = 6314, KCond = 5024, SPurge = 656, KPurge = 1767, P(start = 27e5), h(start = 883498.1), SDes(start = 1e-9), HeiF(start = 878165.8), HDesF(start = 980281.1), Hep(start = 981240.8), Ee(P(start = 80e5), Q(start = 1780), h(start = 872000), h_vol(start = 872000)), Ev(P(start = 27e5), Q(start = 112.2867), h(start = 2600e3), h_vol(start = 883498.1)), Ep(P(start = 1e5), Q(start = 1e-6), h(start = 100000), h_vol(start = 883498.1)), Se(P(start = 7618062.5), Q(start = 1780), h(start = 980281.1), h_vol(start = 980281.1)), Sp(Q(start = 112.2867), h(start = 883498.1), h_vol(start = 883498.1))) annotation(
    Placement(transformation(extent = {{-34, -42}, {44, 42}}, rotation = 0)));
equation
  connect(Source_condenseur.C, singularPressureLoss2.C1) annotation(
    Line(points = {{-162, 0}, {-106, 0}}, color = {0, 0, 255}));
  connect(sourceP.C, singularPressureLoss3.C1) annotation(
    Line(points = {{-162, 98}, {-106, 98}}, color = {0, 0, 255}));
  connect(singularPressureLoss4.C2, Puit_condenseur.C) annotation(
    Line(points = {{112, 0}, {152, 0}}, color = {0, 0, 255}));
  connect(singularPressureLoss5.C2, Puit_condenseur1.C) annotation(
    Line(points = {{54, -96}, {152, -96}}, color = {0, 0, 255}));
  connect(singularPressureLoss3.C2, nTUWaterHeating.Ev) annotation(
    Line(points = {{-86, 98}, {28.4, 98}, {28.4, 13.44}}, color = {0, 0, 255}));
  connect(nTUWaterHeating.Se, singularPressureLoss4.C1) annotation(
    Line(points = {{44, 0}, {92, 0}}, color = {0, 0, 255}));
  connect(singularPressureLoss2.C2, nTUWaterHeating.Ee) annotation(
    Line(points = {{-86, 0}, {-34.78, 0}}, color = {0, 0, 255}));
  connect(singularPressureLoss5.C1, nTUWaterHeating.Sp) annotation(
    Line(points = {{34, -96}, {-14, -96}, {-14, -13.86}, {-18.4, -13.86}}));
  annotation(
    experiment(StopTime = 1000),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-200, -200}, {200, 200}}), graphics),
    Icon(graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100.0, -100.0}, {100.0, 100.0}}, radius = 25.0), Rectangle(lineColor = {128, 128, 128}, extent = {{-100.0, -100.0}, {100.0, 100.0}}, radius = 25.0), Polygon(origin = {8.0, 14.0}, lineColor = {78, 138, 73}, fillColor = {78, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-58.0, 46.0}, {42.0, -14.0}, {-58.0, -74.0}, {-58.0, 46.0}})}),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
    "));
end TestNTUWaterHeating0;
