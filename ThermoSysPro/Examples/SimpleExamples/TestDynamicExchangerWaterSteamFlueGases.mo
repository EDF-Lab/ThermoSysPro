within ThermoSysPro.Examples.SimpleExamples;

model TestDynamicExchangerWaterSteamFlueGases
  parameter Units.SI.AbsolutePressure Source_WSteamP0(fixed = false, start = 13021255)
    "Source pressure computed by initialization";
  MultiFluids.HeatExchangers.DynamicExchangerWaterSteamFlueGases Echangeur(
    Ns = 10,
    TwoPhaseFlowPipe(
      P(start = {13021255, 13015229, 13012838, 13011100, 13009574, 13008138, 13006748, 13005381, 13004027, 13002681, 13001339, 13000000}),
      h(start = {1460000, 1763911.12, 1929304.5, 2020748.62, 2071598.75, 2100049.75, 2116132, 2125338.5, 2130677.25, 2133810.5, 2135670.5, 100000}),
      Tp1(start = {610.928772, 609.345581, 607.539001, 606.317139, 605.529785, 605.005249, 604.65271, 604.418457, 604.265015, 604.165222})),
    z2 = 10,
    Ntubes = 1480,
    ExchangerWall(
      e = 0.0026,
      lambda = 47,
      Tp1(start = {610.928772, 609.345581, 607.539001, 606.317139, 605.529785, 605.005249, 604.65271, 604.418457, 604.265015, 604.165222}),
      Tp(start = {614.808716, 611.457153, 608.706482, 606.966309, 605.893005, 605.210571, 604.770203, 604.486633, 604.304993, 604.188965})),
    L = 21,
    Dint = 32e-3,
    ExchangerFlueGasesMetal(
      step_L = 0.092,
      step_T = 0.087,
      Fa = 1,
      Dext = 0.0372,
      CSailettes = 12,
      Encras(fixed = true) = 1,
      K(fixed = false, start = 40),
      T(start = {750, 685.249451, 649.573242, 629.712524, 618.626282, 612.410278, 608.892395, 606.877258, 605.708191, 605.021912, 604.614502}),
      Tm(start = {717.624756, 667.411377, 639.642883, 624.169434, 615.51825, 610.651367, 607.884827, 606.292725, 605.365051, 604.818237}),
      Tp(start = {618.40741, 613.415649, 609.789307, 607.568481, 606.229919, 605.401001, 604.879211, 604.549805, 604.342102, 604.210999}),
      DeltaT(start = {99.2172928, 53.9957123, 29.8535938, 16.6009483, 9.28834438, 5.25034571, 3.0055995, 1.74290681, 1.02295697, 0.607229412}))) annotation(
    Placement(transformation(extent = {{-60, -58}, {60, 58}}, rotation = 0)));
  ThermoSysPro.FlueGases.BoundaryConditions.SourcePQ Source_Fumees(Xso2 = 0, P0 = 1.1e5, T0 = 750, Xco2 = 0.06, Xh2o = 0.06, Xo2 = 0.14, Q0 = 610) annotation(
    Placement(transformation(extent = {{-20, 38}, {0, 58}}, rotation = 0)));
  ThermoSysPro.FlueGases.BoundaryConditions.Sink Puits_Fumees annotation(
    Placement(transformation(origin = {10, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  WaterSteam.BoundaryConditions.SourceP Source_WSteam(option_temperature = 2, mode = 0, h0 = 1.46e6, C(Q(fixed = true, start = 150)), P0 = Source_WSteamP0, T0 = 610) annotation(
    Placement(transformation(extent = {{-104, -10}, {-84, 10}}, rotation = 0)));
  WaterSteam.BoundaryConditions.SinkP Puits_WSteam(option_temperature = 2, mode = 0, P0 = 13000000) annotation(
    Placement(transformation(origin = {94, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
equation
  connect(Source_Fumees.C, Echangeur.Cfg1) annotation(
    Line(points = {{0, 48}, {0, 29}}, color = {0, 0, 0}, thickness = 1));
  connect(Puits_Fumees.C, Echangeur.Cfg2) annotation(
    Line(points = {{0.2, -50}, {0, -50}, {0, -29}}, color = {0, 0, 0}, thickness = 1));
  connect(Source_WSteam.C, Echangeur.Cws1) annotation(
    Line(points = {{-84, 0}, {-60, 0}}, color = {0, 0, 255}));
  connect(Echangeur.Cws2, Puits_WSteam.C) annotation(
    Line(points = {{60, 0}, {84, 0}}, color = {255, 0, 0}));
  annotation(
    Icon(graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100.0, -100.0}, {100.0, 100.0}}, radius = 25.0), Rectangle(lineColor = {128, 128, 128}, extent = {{-100.0, -100.0}, {100.0, 100.0}}, radius = 25.0), Polygon(origin = {8.0, 14.0}, lineColor = {78, 138, 73}, fillColor = {78, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-58.0, 46.0}, {42.0, -14.0}, {-58.0, -74.0}, {-58.0, 46.0}})}),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
    "));
end TestDynamicExchangerWaterSteamFlueGases;
