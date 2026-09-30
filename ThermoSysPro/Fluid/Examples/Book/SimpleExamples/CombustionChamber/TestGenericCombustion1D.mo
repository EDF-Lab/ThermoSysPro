within ThermoSysPro.Fluid.Examples.Book.SimpleExamples.CombustionChamber;

model TestGenericCombustion1D "TestGenericCombustion1D"
  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam;
  replaceable package Medium_FlueGases = ThermoSysPro.Properties.Media.FlueGases;

  ThermoSysPro.Fluid.Combustion.CombustionChambers.GenericCombustion1D genericCombustionCCS(
    redeclare package Medium = Medium,
    redeclare package Medium_FlueGases = Medium_FlueGases,
    NCEL=7,
    Qm(fixed=false),
    Qsf(fixed=false),
    kcham(fixed=true) = 0.1,
    Acham=275,
    Xbf=0,
    ImbCV=0.05,
    EPSPAR=0.7,
    Kec=8.8,
    SM={639.92,198.58,466.48,466.48,466.48,358.56,358.56},
    ImbBF=0.0,
    Psf(start=113275)) annotation(
    Placement(transformation(extent = {{-62, -56}, {62, 72}}, rotation = 0)));
  ThermoSysPro.Fluid.Combustion.BoundaryConditions.FuelSourcePQ fuelSourcePQ(Xn = 0.0208, Xashes = 0.136, Cp = 1200, rho = 1100, LHV = 29245e3, Xc = 0.719, Xh = 0.0414, Xo = 0.086, Xs = 0.0044, Vol = 0.286, Q0 = 57.20, T0 = 358.15, Hum = 0.08) annotation(
    Placement(transformation(extent = {{-106, -43}, {-72, -5}}, rotation = 0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourceAir(
    redeclare package Medium = Medium_FlueGases,
    Q0=609.29,
    P0=191000,
    T0=524.89,
    option_temperature=true,
    X0={0.76,0.23,0.01,0,0}) annotation(
    Placement(transformation(extent = {{-44, -98}, {0, -58}}, rotation = 0)));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink (
    redeclare package Medium = Medium_FlueGases,
    T0=1200,
    option_temperature=true) annotation(
    Placement(transformation(extent = {{0, 70}, {44, 112}}, rotation = 0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ SourcePQ_Water(
    redeclare package Medium = Medium,
    Q0=0,
    P0=100000) annotation(
    Placement(transformation(extent = {{-107, 23}, {-71, 57}}, rotation = 0)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicTwoPhaseFlowPipe PipeWaterSteam(
    redeclare package Medium = Medium,
    Ns=7,
    inertia=false,
    dynamic_energy_balance=false,
    z2=56,
    rugosrel=5e-5,
    ntubes=403,
    L=58,
    D=0.0327,
    P(start=fill(2.0e7, 9)),
    Q(start=fill(486.69, 8)),
    h(start=fill(1.8e6, 9)),
    C2(Q(fixed=false, start=486.69), P(
        fixed=false,
        start=1.96318e+07,
        displayUnit="Pa")),
    dpfCorr=3.5) annotation(
    Placement(transformation(origin = {91, 8}, extent = {{49, 16}, {-49, -16}}, rotation = 270)));
  ThermoSysPro.Thermal.HeatTransfer.HeatExchangerWall paroiEcrans(Ns = 7, lambda = 40, steady_state = true, ntubes = 403, L = 58, D = 0.0327, e = 0.001) annotation(
    Placement(transformation(origin = {73, 7.5}, extent = {{51.5, -15}, {-51.5, 15}}, rotation = 270)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkWaterSteam2(
    redeclare package Medium = Medium,
    option_temperature=false,
    Q(start=486.69),
    h0=2.5e+06,
    P0=19621600) annotation(
    Placement(transformation(origin = {90, 90.5}, extent = {{14.5, -15}, {-14.5, 15}}, rotation = 270)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourceEcrans(
    redeclare package Medium = Medium,
    h0=1.292e+06,
    option_temperature=false,
    P0=20112000) annotation(
    Placement(transformation(origin = {91, -81}, extent = {{15, -15}, {-15, 15}}, rotation = 270)));
equation
  connect(fuelSourcePQ.C, genericCombustionCCS.Cfuel) annotation(
    Line(points = {{-72, -24}, {-55.8, -24}}, color = {0, 0, 0}));
  connect(genericCombustionCCS.Cfg, sink.C) annotation(
    Line(points = {{0, 65.6}, {0, 91}, {0, 91}}, color = {0, 0, 0}, thickness = 1));
  connect(genericCombustionCCS.Ca, sourceAir.C) annotation(
    Line(points = {{0, -49.6}, {0, -78}}, color = {0, 0, 0}, thickness = 1));
  connect(SourcePQ_Water.C, genericCombustionCCS.Cws) annotation(
    Line(points = {{-71, 40}, {-55.8, 40}}, color = {0, 0, 255}));
  connect(genericCombustionCCS.Cth, paroiEcrans.WT2) annotation(
    Line(points = {{55.8, 8}, {68, 8}, {68, 7.5}, {76, 7.5}}, color = {191, 95, 0}));
  connect(paroiEcrans.WT1, PipeWaterSteam.CTh) annotation(
    Line(points = {{70, 7.5}, {71, 7.5}, {71, 8}, {86.2, 8}}, color = {191, 95, 0}));
  connect(sourceEcrans.C, PipeWaterSteam.C1) annotation(
    Line(points = {{91, -66}, {91, -41}}, color = {0, 0, 255}));
  connect(PipeWaterSteam.C2, sinkWaterSteam2.C) annotation(
    Line(points = {{91, 57}, {91, 76}, {90, 76}}, color = {0, 0, 255}));
  annotation(
    Diagram(graphics),
    Documentation(revisions = "
Author  

Baligh El Hefni   

    ", info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
This model is documented in Sect. 8.2.5 of the ThermoSysPro book.  
The results reported in the ThermoSysPro book were computed using Dymola.  
    "),
    Icon(graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100.0, -100.0}, {100.0, 100.0}}, radius = 25.0), Rectangle(lineColor = {128, 128, 128}, extent = {{-100.0, -100.0}, {100.0, 100.0}}, radius = 25.0), Polygon(origin = {8.0, 14.0}, lineColor = {78, 138, 73}, fillColor = {78, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-58.0, 46.0}, {42.0, -14.0}, {-58.0, -74.0}, {-58.0, 46.0}})}));
end TestGenericCombustion1D;