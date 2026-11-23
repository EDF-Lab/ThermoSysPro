within ThermoSysPro.Fluid.Examples.Book.SimpleExamples.Boiler;

model TestFossilFuelBoiler
  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam;
  replaceable package Medium_FlueGases = ThermoSysPro.Properties.Media.FlueGases;

  ThermoSysPro.Fluid.Boilers.FossilFuelBoiler FossilFuelBoiler(
    redeclare package Medium = Medium,
    redeclare package Medium_FlueGases = Medium_FlueGases,
    Wloss=0,
    Ke=1.e6,
    Tsf=386.16,
    Tea(start=298.15999999999923),
    Tf(start=2138.3201722145304),
    deltaPe(start=4028755.599053718),
    rhof(start=0.2733355904203506)) annotation(
    Placement(transformation(extent = {{-45, -51}, {45, 51}}, rotation = 0)));
  ThermoSysPro.Fluid.Combustion.BoundaryConditions.FuelSourcePQ fuelSourcePQ(T0 = 338.16, Cp = 1282, Xh = 0.24403, Xc = 0.75323, Q0 = 1.45) annotation(
    Placement(transformation(extent = {{-36, -78}, {0, -41}}, rotation = 0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceQ(
    redeclare package Medium = Medium_FlueGases,
    Q0=27.,
    T0=298.16,
    option_temperature=true,
    X0={0.757,0.233,0.01,0,0}) annotation(
    Placement(transformation(extent = {{-110, -50}, {-71, -13}}, rotation = 0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkP (
    redeclare package Medium = Medium_FlueGases,
    P0=100000,
    T0=386.16,
    option_temperature=true) annotation(
    Placement(transformation(extent = {{68, -51}, {110, -12}}, rotation = 0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourcePQ(
    redeclare package Medium = Medium,
    P0=140e5,
    Q0=24.,
    h0=600e3) annotation(
    Placement(transformation(extent = {{-107, 14}, {-71, 48}}, rotation = 0)));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink (redeclare package Medium = Medium) annotation(
    Placement(transformation(extent = {{74, 13}, {110, 49}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLoss(
    redeclare package Medium = Medium,
    K=1e-3, rho(
        start=932.9612394321883)) annotation(
    Placement(transformation(extent = {{-64, 25}, {-56, 37}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLoss1(
    redeclare package Medium = Medium,
    K=1e-3, rho(
        start=29.766102492862515)) annotation(
    Placement(transformation(extent = {{57, 25}, {65, 37}}, rotation = 0)));
equation
  connect(sourceQ.C, FossilFuelBoiler.Cair) annotation(
    Line(points = {{-71, -31.5}, {-63.5, -31.5}, {-63.5, -31.62}, {-45, -31.62}}, color = {0, 0, 0}, thickness = 1));
  connect(FossilFuelBoiler.Cfg, sinkP.C) annotation(
    Line(points = {{45, -31.62}, {62, -31.62}, {62, -31.5}, {68, -31.5}}, color = {0, 0, 0}, thickness = 1));
  connect(fuelSourcePQ.C, FossilFuelBoiler.Cfuel) annotation(
    Line(points = {{0, -59.5}, {0, -40.8}}, color = {0, 0, 0}));
  connect(sourcePQ.C, singularPressureLoss.C1) annotation(
    Line(points = {{-71, 31}, {-64, 31}}, color = {0, 0, 255}));
  connect(singularPressureLoss.C2, FossilFuelBoiler.Cws1) annotation(
    Line(points = {{-56, 31}, {-50, 31}, {-50, 30.6}, {-45, 30.6}}, color = {0, 0, 255}));
  connect(singularPressureLoss1.C2, sink.C) annotation(
    Line(points = {{65, 31}, {74, 31}}, color = {0, 0, 255}));
  connect(FossilFuelBoiler.Cws2, singularPressureLoss1.C1) annotation(
    Line(points = {{45, 30.6}, {51, 30.6}, {51, 31}, {57, 31}}, color = {0, 0, 255}));
  annotation(
    Diagram(graphics),
    Icon(graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100.0, -100.0}, {100.0, 100.0}}, radius = 25.0), Rectangle(lineColor = {128, 128, 128}, extent = {{-100.0, -100.0}, {100.0, 100.0}}, radius = 25.0), Polygon(origin = {8.0, 14.0}, lineColor = {78, 138, 73}, fillColor = {78, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-58.0, 46.0}, {42.0, -14.0}, {-58.0, -74.0}, {-58.0, 46.0}})}),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
This model is documented in Sect. 7.2.5 of the ThermoSysPro book.  
The results reported in the ThermoSysPro book were computed using Dymola.  
    "));
end TestFossilFuelBoiler;