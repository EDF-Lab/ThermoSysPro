within ThermoSysPro.Fluid.Examples.Book.SimpleExamples.PressureLoss;

model TestDynamicCheckValve
  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam;

  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourceP1 (
    redeclare package Medium = Medium) annotation(
    Placement(transformation(extent = {{-38, -10}, {-18, 10}}, rotation = 0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP puitsP1(
                                   redeclare package Medium = Medium,
                                   P0=6e5) annotation(
    Placement(transformation(extent = {{42, -10}, {62, 10}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.DynamicCheckValve checkValve(
    redeclare package Medium = Medium,
    J=10) annotation(
    Placement(transformation(extent = {{2, -10}, {22, 10}}, rotation = 0)));
  InstrumentationAndControl.Blocks.Sources.Sinusoide pulse(period = 100, amplitude = 3e5, offset = 6e5) annotation(
    Placement(transformation(extent = {{-78, -10}, {-58, 10}}, rotation = 0)));
equation
  connect(sourceP1.C, checkValve.C1) annotation(
    Line(points = {{-18, 0}, {2, 0}}, color = {0, 0, 255}));
  connect(checkValve.C2, puitsP1.C) annotation(
    Line(points = {{22, 0}, {32, 0}, {42, 0}}, color = {0, 0, 255}));
  connect(sourceP1.IPressure, pulse.y) annotation(
    Line(points = {{-33, 0}, {-57, 0}}, color = {28, 108, 200}));
  annotation(
    Diagram(graphics, coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}, grid = {2, 2})),
    Window(x = 0.28, y = 0.03, width = 0.5, height = 0.6),
    experiment(StopTime = 300),
    Icon(graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100.0, -100.0}, {100.0, 100.0}}, radius = 25.0), Rectangle(lineColor = {128, 128, 128}, extent = {{-100.0, -100.0}, {100.0, 100.0}}, radius = 25.0), Polygon(origin = {8.0, 14.0}, lineColor = {78, 138, 73}, fillColor = {78, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-58.0, 46.0}, {42.0, -14.0}, {-58.0, -74.0}, {-58.0, 46.0}})}),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
This model is documented in Sect. 13.12.4 of the ThermoSysPro book.   
The results reported in the ThermoSysPro book were computed using Dymola.   
    "));
end TestDynamicCheckValve;