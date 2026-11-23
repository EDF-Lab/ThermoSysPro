within ThermoSysPro.Fluid.Examples.Book.SimpleExamples.HeatExchanger;

model TestStaticPlateHeatExchanger
  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam;

  ThermoSysPro.Fluid.HeatExchangers.StaticPlateHeatExchanger echangeurAPlaques1(
    redeclare package Medium_c = Medium,
    redeclare package Medium_f = Medium,
    Sp=2,
    Sc(Q(fixed=true, start=1036.78)),
    Hmc(start=220524.0),
    Hmf(start=127690.0),
    Qf(start=1000.0)) annotation(
    Placement(transformation(extent = {{-10, 30}, {10, 50}}, rotation = 0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourceP2(
                                           redeclare package Medium = Medium,
                                           T0=340) annotation(
    Placement(transformation(extent = {{-70, 30}, {-50, 50}}, rotation = 0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourceP3 (
                                            redeclare package Medium = Medium) annotation(
    Placement(transformation(extent = {{-50, 10}, {-30, 30}}, rotation = 0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP puitsP2(
      redeclare package Medium = Medium,
      P0(fixed=false)=
      100000) annotation(
    Placement(transformation(extent = {{50, 30}, {70, 50}}, rotation = 0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP puitsP3 (
                                          redeclare package Medium = Medium) annotation(
    Placement(transformation(extent = {{30, 10}, {50, 30}}, rotation = 0)));
  ThermoSysPro.Fluid.HeatExchangers.StaticPlateHeatExchanger echangeurAPlaques(
      redeclare package Medium_c = Medium,
      redeclare package Medium_f = Medium,
      Sp=2,
    Hmc(start=220524.0),
    Hmf(start=127690.0),
    Qc(start=1000.0),
    Qf(start=1000.0)) annotation(
    Placement(transformation(extent = {{-10, -34}, {10, -14}}, rotation = 0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourceP6(
                                           redeclare package Medium = Medium,
                                           T0=340) annotation(
    Placement(transformation(extent = {{-70, -34}, {-50, -14}}, rotation = 0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourceP7 (
                                            redeclare package Medium = Medium) annotation(
    Placement(transformation(extent = {{-50, -54}, {-30, -34}}, rotation = 0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP puitsP6 (
                                         redeclare package Medium = Medium) annotation(
    Placement(transformation(extent = {{50, -34}, {70, -14}}, rotation = 0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP puitsP7 (
                                          redeclare package Medium = Medium) annotation(
    Placement(transformation(extent = {{30, -54}, {50, -34}}, rotation = 0)));
equation
  connect(sourceP2.C, echangeurAPlaques1.Ec) annotation(
    Line(points = {{-50, 40}, {-10, 40}}, color = {0, 0, 255}));
  connect(sourceP3.C, echangeurAPlaques1.Ef) annotation(
    Line(points = {{-30, 20}, {-5, 20}, {-5, 34}}, color = {0, 0, 255}));
  connect(echangeurAPlaques1.Sc, puitsP2.C) annotation(
    Line(points = {{10, 40.2}, {30, 40.2}, {30, 40}, {50, 40}}, color = {0, 0, 255}));
  connect(echangeurAPlaques1.Sf, puitsP3.C) annotation(
    Line(points = {{5, 34}, {4, 34}, {4, 20}, {30, 20}}, color = {0, 0, 255}));
  connect(sourceP6.C, echangeurAPlaques.Ec) annotation(
    Line(points = {{-50, -24}, {-10, -24}}, color = {0, 0, 255}));
  connect(sourceP7.C, echangeurAPlaques.Ef) annotation(
    Line(points = {{-30, -44}, {-5, -44}, {-5, -30}}, color = {0, 0, 255}));
  connect(echangeurAPlaques.Sc, puitsP6.C) annotation(
    Line(points = {{10, -23.8}, {30, -23.8}, {30, -24}, {50, -24}}, color = {0, 0, 255}));
  connect(echangeurAPlaques.Sf, puitsP7.C) annotation(
    Line(points = {{5, -30}, {4, -30}, {4, -44}, {30, -44}}, color = {0, 0, 255}));
  annotation(
    Diagram(graphics = {Text(extent = {{72, 48}, {92, 30}}, lineColor = {0, 0, 255}, textString = "Qc=true"), Text(extent = {{-28, -52}, {26, -60}}, lineColor = {0, 0, 255}, textString = "Crossing error")}),
    Icon(graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100.0, -100.0}, {100.0, 100.0}}, radius = 25.0), Rectangle(lineColor = {128, 128, 128}, extent = {{-100.0, -100.0}, {100.0, 100.0}}, radius = 25.0), Polygon(origin = {8.0, 14.0}, lineColor = {78, 138, 73}, fillColor = {78, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-58.0, 46.0}, {42.0, -14.0}, {-58.0, -74.0}, {-58.0, 46.0}})}),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
This model is documented in Sect. 9.6.2.5 of the ThermoSysPro book.   
The results reported in the ThermoSysPro book were computed using Dymola.   
    "));
end TestStaticPlateHeatExchanger;