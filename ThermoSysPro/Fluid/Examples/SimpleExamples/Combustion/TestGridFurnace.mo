within ThermoSysPro.Fluid.Examples.SimpleExamples.Combustion;
model TestGridFurnace
  extends ThermoSysPro.UsersGuide.Icons.Example;
  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam;
  replaceable package Medium_FlueGases = ThermoSysPro.Properties.Media.FlueGases;

  ThermoSysPro.Fluid.Combustion.BoundaryConditions.FuelSourcePQ fuelSource(
    Xn=0.0208,
    Xashes=0.136,
    Cp=1200,
    rho=1100,
    LHV=29245e3,
    Xc=0.719,
    Xh=0.0414,
    Xo=0.086,
    Xs=0.0044,
    Vol=0.286,
    Q0=57.20,
    T0=358.15,
    Hum=0.08)
    annotation (Placement(transformation(extent={{-106,-23},{-72,15}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourcePrimaryAir(
    redeclare package Medium = Medium_FlueGases,
    T0=300,
    Q0=10,
    P0=1.9e5,
    option_temperature=true,
    X0={0.76,0.23,0.01,0,0})
    annotation (Placement(transformation(extent={{-74,-80},{-30,-40}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sinkFlueGases(
    redeclare package Medium = Medium_FlueGases,
    T0=1200,
    option_temperature=true)
    annotation (Placement(transformation(extent={{28,50},{72,92}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourceCoolingWater(
    redeclare package Medium = Medium,
    P0=1.e5,
    Q0=1)
    annotation (Placement(transformation(extent={{89,13},{53,47}}, rotation=0)));
  ThermoSysPro.Fluid.Combustion.CombustionChambers.GridFurnace gridFurnace(
    redeclare package Medium = Medium,
    redeclare package Medium_FlueGases = Medium_FlueGases,
    Q5eH2O(start=27.562088697651173),
    Q5eN2(start=18.629997579210396),
    Q5sCO(start=16.083169558220888),
    Q5sCO2(start=-23.220946069965017),
    Q5sO2(start=-1.7763568394002505E-15),
    T2(start=4353.611752483582),
    Teap(start=2396.269823464287, displayUnit="degC"),
    Teas(start=2396.269823464287, displayUnit="degC"),
    Teasm(start=2419.8632089574135, displayUnit="degC"),
    Tsf(start=1964.2922985959055), Hsf(start = 4575373),Qeasm(start=14.733687))
    annotation (Placement(transformation(extent={{-40,-40},{40,40}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceSecondaryAir(
    redeclare package Medium = Medium_FlueGases,
    option_temperature=true,
    T0=300,
    Q0=10,
    X0={0.76,0.23,0.01,0,0})
    annotation (Placement(transformation(extent={{-90,4},{-46,44}}, rotation=0)));
equation
  connect(fuelSource.C, gridFurnace.Com)
    annotation (Line(points={{-72,-4},{-36,-4}}, color={0,0,0}));
  connect(gridFurnace.Cfg, sinkFlueGases.C)
    annotation (Line(points={{0,36},{0,71},{28,71}}, color={0,0,0}));
  connect(sourceCoolingWater.C, gridFurnace.port_eau_refroid)
    annotation (Line(points={{53,30},{32,30},{32,12}}, color={0,0,255}));
  connect(sourceSecondaryAir.C, gridFurnace.Ca2)
    annotation (Line(points={{-46,24},{-20,24}}, color={0,0,0}));
  connect(sourcePrimaryAir.C, gridFurnace.Ca1)
    annotation (Line(points={{-30,-60},{0,-60},{0,-36}}, color={0,0,0}));
  annotation (experiment(StopTime=1));
end TestGridFurnace;