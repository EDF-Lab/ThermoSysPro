within ThermoSysPro.Fluid.Examples.SimpleExamples.Combustion;
model TestPostCombustionGas
  extends ThermoSysPro.UsersGuide.Icons.Example;
  replaceable package Medium_FlueGases = ThermoSysPro.Properties.Media.FlueGases;

  ThermoSysPro.Fluid.BoundaryConditions.Sink sinkFlueGases(
    redeclare package Medium = Medium_FlueGases,
    T0=1200,
    option_temperature=true)
    annotation (Placement(transformation(origin={151,-6}, extent={{23,-24},{-23,24}}, rotation=180)));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourceFlueGases(
    redeclare package Medium = Medium_FlueGases,
    P0=15e5,
    Q0=415,
    T0=680,
    option_temperature=true,
    X0={0.76,0.23,0.01,0,0})
    annotation (Placement(transformation(extent={{-174,-30},{-128,18}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceAir(
    redeclare package Medium = Medium_FlueGases,
    T0=680,
    option_temperature=true,
    Q0=10,
    X0={0.76,0.23,0.01,0,0})
    annotation (Placement(transformation(extent={{-172,68},{-132,108}}, rotation=0)));
  ThermoSysPro.Fluid.Combustion.BoundaryConditions.FuelSourcePQ sourceFuel(
    Hum=0,
    Xo=0,
    Xn=0,
    Xs=0,
    rho=0.838,
    Xc=0.755,
    Xh=0.245,
    Cp=2255,
    T0=410,
    Q0=9.30,
    LHV=47500e3)
    annotation (Placement(transformation(extent={{-107,-109},{-71,-73}}, rotation=0)));
  ThermoSysPro.Fluid.Combustion.CombustionChambers.PostCombustionGas postCombustionGas(
    redeclare package Medium_FlueGases = Medium_FlueGases, Psf(start = 1.5e6), Tmel(start = 2427.85 + 273.15), h(start = 4026550))
    annotation (Placement(transformation(extent={{-52,-74},{74,50}})));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss airPressureLoss(
    redeclare package Medium = Medium_FlueGases)
    annotation (Placement(transformation(extent={{-100,78},{-80,98}})));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss inletPressureLoss(
    redeclare package Medium = Medium_FlueGases)
    annotation (Placement(transformation(extent={{-102,-16},{-82,4}})));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss outletPressureLoss(
    redeclare package Medium = Medium_FlueGases)
    annotation (Placement(transformation(extent={{90,-16},{110,4}})));
equation
  connect(sourceFuel.C, postCombustionGas.Cfuel)
    annotation (Line(points={{-71,-91},{-7.9,-91},{-7.9,-67.8}}, color={0,0,0}));
  connect(sourceAir.C, airPressureLoss.C1)
    annotation (Line(points={{-132,88},{-100,88}}, color={0,0,0}));
  connect(airPressureLoss.C2, postCombustionGas.Ca)
    annotation (Line(points={{-80,88},{-20.5,88},{-20.5,43.8}}, color={0,0,0}));
  connect(sourceFlueGases.C, inletPressureLoss.C1)
    annotation (Line(points={{-128,-6},{-102,-6}}, color={0,0,0}));
  connect(inletPressureLoss.C2, postCombustionGas.Cfg1)
    annotation (Line(points={{-82,-6},{-64,-6},{-64,-5.8},{-45.7,-5.8}}, color={0,0,0}));
  connect(postCombustionGas.Cfg2, outletPressureLoss.C1)
    annotation (Line(points={{67.7,-5.8},{79.85,-5.8},{79.85,-6},{90,-6}}, color={0,0,0}));
  connect(outletPressureLoss.C2, sinkFlueGases.C)
    annotation (Line(points={{110,-6},{128,-6}}, color={0,0,0}));
  annotation (experiment(StopTime=1));
end TestPostCombustionGas;