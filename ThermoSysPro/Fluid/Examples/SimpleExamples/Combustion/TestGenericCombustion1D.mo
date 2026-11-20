within ThermoSysPro.Fluid.Examples.SimpleExamples.Combustion;
model TestGenericCombustion1D
  extends ThermoSysPro.UsersGuide.Icons.Example;
  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam;
  replaceable package Medium_FlueGases = ThermoSysPro.Properties.Media.FlueGases;
  ThermoSysPro.Fluid.Combustion.CombustionChambers.GenericCombustion1D combustionChamber(redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, NCEL = 7, Qm(fixed = false), Qsf(fixed = false), kcham(fixed = true) = 0.1, Acham = 275, Xbf = 0, ImbCV = 0.05, EPSPAR = 0.7, Kec = 8.8, SM = {639.92, 198.58, 466.48, 466.48, 466.48, 358.56, 358.56}, ImbBF = 0.0, Psf(start = 113275)) annotation(
    Placement(transformation(origin = {-4, 10}, extent = {{-40, -40}, {40, 40}})));
  ThermoSysPro.Fluid.Combustion.BoundaryConditions.FuelSourcePQ sourceFuel(Xn = 0.0208, Xashes = 0.136, Cp = 1200, rho = 1100, LHV = 29245e3, Xc = 0.719, Xh = 0.0414, Xo = 0.086, Xs = 0.0044, Vol = 0.286, Q0 = 57.20, T0 = 358.15, Hum = 0.08) annotation(
    Placement(transformation(extent = {{-100, -30}, {-60, 10}}, rotation = 0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourceAir(redeclare package Medium = Medium_FlueGases, Q0 = 609.29, P0 = 191000, T0 = 524.89, option_temperature = true, X0 = {0.76, 0.23, 0.01, 0, 0}) annotation(
    Placement(transformation(origin = {-80, -74}, extent = {{-20, -100}, {20, -60}}, rotation = 90)));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourceWaterSteam(redeclare package Medium = Medium, Q0 = 0, P0 = 100000) annotation(
    Placement(transformation(extent = {{-100, 30}, {-60, 70}}, rotation = 0)));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sinkFlueGases(redeclare package Medium = Medium_FlueGases, T0 = 1200, option_temperature = true) annotation(
    Placement(transformation(origin = {24, -18}, extent = {{-20, 80}, {20, 120}})));
equation
  connect(sourceFuel.C, combustionChamber.Cfuel) annotation(
    Line(points = {{-60, -10}, {-40, -10}}));
  connect(sourceAir.C, combustionChamber.Ca) annotation(
    Line(points = {{0, -54}, {0, -45}, {-4, -45}, {-4, -26}}));
  connect(sourceWaterSteam.C, combustionChamber.Cws) annotation(
    Line(points = {{-60, 50}, {-60, 32}, {-40, 32}, {-40, 30}}, color = {0, 0, 255}));
  connect(combustionChamber.Cfg, sinkFlueGases.C) annotation(
    Line(points = {{-4, 46}, {-4, 63}, {4, 63}, {4, 82}}));
  annotation(
    experiment(StopTime = 1));
end TestGenericCombustion1D;
