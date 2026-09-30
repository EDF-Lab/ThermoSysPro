within ThermoSysPro.Fluid.Examples.SimpleExamples.Combustion;
model TestGenericCombustion
  extends ThermoSysPro.UsersGuide.Icons.Example;
  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam;
  replaceable package Medium_FlueGases = ThermoSysPro.Properties.Media.FlueGases;

  ThermoSysPro.Fluid.Combustion.CombustionChambers.GenericCombustion combustionChamber(
    redeclare package Medium = Medium,
    redeclare package Medium_FlueGases = Medium_FlueGases)
    annotation (Placement(transformation(extent={{-40,-40},{40,40}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourceWaterSteam(
    redeclare package Medium = Medium,
    Q0=0,
    P0=15e5,
    h0=300e3)
    annotation (Placement(transformation(extent={{-120,10},{-80,50}}, rotation=0)));
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
    annotation (Placement(transformation(extent={{30,-100},{70,-60}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourceAir(
    redeclare package Medium = Medium_FlueGases,
    P0=15e5,
    Q0=415,
    T0=680,
    option_temperature=true,
    X0={0.76,0.23,0.01,0,0})
    annotation (Placement(transformation(extent={{-40,-100},{0,-60}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sinkFlueGases(
    redeclare package Medium = Medium_FlueGases,
    T0=1200,
    option_temperature=true)
    annotation (Placement(transformation(extent={{-20,80},{20,120}}, rotation=0)));
equation
  connect(sourceWaterSteam.C, combustionChamber.Cws) annotation (Line(points={{-80,30},{-70,30},{-70,4},{-36,4}}, color={0,0,255}));
  connect(sourceFuel.C, combustionChamber.Cfuel) annotation (Line(points={{70,-80},{28,-80},{28,-36}}, color={0,0,0}));
  connect(sourceAir.C, combustionChamber.Ca) annotation (Line(points={{0,-80},{-12,-80},{-12,-36}}, color={0,0,0}));
  connect(combustionChamber.Cfg, sinkFlueGases.C) annotation (Line(points={{-12,36},{-12,100},{-20,100}}, color={0,0,0}));
  annotation (experiment(StopTime=1));
end TestGenericCombustion;
