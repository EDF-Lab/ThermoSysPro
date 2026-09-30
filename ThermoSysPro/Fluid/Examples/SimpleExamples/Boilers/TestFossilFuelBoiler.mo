within ThermoSysPro.Fluid.Examples.SimpleExamples.Boilers;
model TestFossilFuelBoiler
  extends ThermoSysPro.UsersGuide.Icons.Example;
  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam;
  replaceable package Medium_FlueGases = ThermoSysPro.Properties.Media.FlueGases;

  ThermoSysPro.Fluid.Boilers.FossilFuelBoiler fossilFuelBoiler(
    redeclare package Medium = Medium,
    redeclare package Medium_FlueGases = Medium_FlueGases,
    Wloss=0,
    Ke=1.e6,
    Tsf=386.16,
    Tea(start=298.16),
    Tf(start=2138.32),
    deltaPe(start=4028755.6),
    rhof(start=0.2733))
    annotation (Placement(transformation(extent={{-45,-51},{45,51}}, rotation=0)));
  ThermoSysPro.Fluid.Combustion.BoundaryConditions.FuelSourcePQ fuelSourcePQ(
    Xashes=0.011,
    rho=1000,
    Hum=0.50,
    Xc=0.2479,
    Xh=0.0297,
    Xo=0.2088,
    Xn=0.0017,
    Xs=0.0003,
    LHV=1.5e7,
    Q0=0.0407331,
    T0=294.45)
    annotation (Placement(transformation(extent={{-36,-78},{0,-41}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceFlueGases(
    redeclare package Medium = Medium_FlueGases,
    Q0=27,
    T0=298.16,
    option_temperature=true,
    X0={0.757,0.233,0.01,0,0})
    annotation (Placement(transformation(extent={{-110,-50},{-71,-13}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkFlueGases(
    redeclare package Medium = Medium_FlueGases,
    P0=100000,
    T0=386.16,
    option_temperature=true)
    annotation (Placement(transformation(extent={{68,-51},{110,-12}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourceWaterSteam(
    redeclare package Medium = Medium,
    P0=140e5,
    Q0=24,
    h0=600e3)
    annotation (Placement(transformation(extent={{-107,14},{-71,48}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sinkWaterSteam(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{74,13},{110,49}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss inletPressureLoss(
    redeclare package Medium = Medium,
    K=1e-3,
    rho(start=932.96))
    annotation (Placement(transformation(extent={{-64,25},{-56,37}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss outletPressureLoss(
    redeclare package Medium = Medium,
    K=1e-3,
    rho(start=29.77))
    annotation (Placement(transformation(extent={{57,25},{65,37}}, rotation=0)));
equation
  connect(sourceFlueGases.C, fossilFuelBoiler.Cair) annotation (Line(
      points={{-71,-31.5},{-63.5,-31.5},{-63.5,-31.62},{-45,-31.62}},
      color={0,0,0},
      thickness=1));
  connect(fossilFuelBoiler.Cfg, sinkFlueGases.C) annotation (Line(
      points={{45,-31.62},{62,-31.62},{62,-31.5},{68,-31.5}},
      color={0,0,0},
      thickness=1));
  connect(fuelSourcePQ.C, fossilFuelBoiler.Cfuel) annotation (Line(points={{0,-59.5},{0,-40.8}}, color={0,0,0}));
  connect(sourceWaterSteam.C, inletPressureLoss.C1) annotation (Line(points={{-71,31},{-64,31}}, color={0,0,255}));
  connect(inletPressureLoss.C2, fossilFuelBoiler.Cws1) annotation (Line(points={{-56,31},{-50,31},{-50,30.6},{-45,30.6}}, color={0,0,255}));
  connect(fossilFuelBoiler.Cws2, outletPressureLoss.C1) annotation (Line(points={{45,30.6},{51,30.6},{51,31},{57,31}}, color={0,0,255}));
  connect(outletPressureLoss.C2, sinkWaterSteam.C) annotation (Line(points={{65,31},{74,31}}, color={0,0,255}));
  annotation (experiment(StopTime=1));
end TestFossilFuelBoiler;
