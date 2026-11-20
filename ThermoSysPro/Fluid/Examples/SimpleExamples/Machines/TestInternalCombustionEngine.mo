within ThermoSysPro.Fluid.Examples.SimpleExamples.Machines;
model TestInternalCombustionEngine
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam;
  replaceable package Medium_FlueGases = ThermoSysPro.Properties.Media.FlueGases;

  ThermoSysPro.Fluid.Combustion.BoundaryConditions.FuelSourcePQ fuelSourcePQ(
    Hum=0,
    Xh=0.25,
    Xs=0,
    Xashes=0,
    Xc=0.75,
    Xo=0,
    Xn=0,
    Q0=0.0676,
    rho=0.744,
    LHV=50e6,
    T0(displayUnit="K") = 299,
    P0=210300,
    Vol=1)
    annotation (Placement(transformation(extent={{-106,-81},{-72,-43}},
          rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourceAir(
    redeclare package Medium = Medium_FlueGases,
    Q0=1.9627,
    T0=30 + 273.16,
    option_temperature=true,
    X0={0.765,0.23,0.005,0,0},
    P0=191000)
    annotation (Placement(transformation(extent={{111,-79},{73,-45}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink(
    redeclare package Medium = Medium_FlueGases,
    option_temperature=true)
    annotation (Placement(transformation(extent={{0,44},{44,86}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourceWater(
    redeclare package Medium = Medium,
    Q0=15.3,
    h0=334.41e3,
    P0=410000)
    annotation (Placement(transformation(extent={{-107,-19},{-71,15}}, rotation=0)));
  ThermoSysPro.Fluid.Machines.InternalCombustionEngine internalCombustionEngine(
    redeclare package Medium = Medium,
    redeclare package Medium_FlueGases = Medium_FlueGases,
    mechanical_efficiency_type=2,
    Rmeca_nom=0.41,
    Coef_Rm_a=-5.4727e-9,
    Coef_Rm_b=4.9359e-5,
    Coef_Rm_c=0.30814,
    Xpth=0.05,
    MMg=20,
    DPe=1,
    RV=6.45,
    Kc=1.28,
    Kd=1.33,
    Wmeca(start=1400e3),
    Welec(start=1358e3),
    Wcomb(start=3.4942e6),
    exc(start=1.8),
    Gamma=1.2085,
    Tsf(start=1088.15))
    annotation (Placement(transformation(extent={{-44,-46},{44,42}})));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sinkWater(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{75,-19},{111,15}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss waterPressureLossIn(
      redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-63,-8},{-51,4}})));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss waterPressureLossOut(
      redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{51,-9},{65,5}})));
equation
  connect(internalCombustionEngine.Cair, sourceAir.C) annotation (Line(
      points={{0,-41.6},{0,-62},{73,-62}},
      color={0,0,0},
      thickness=1));
  connect(internalCombustionEngine.Cfuel, fuelSourcePQ.C) annotation (Line(
      points={{-30.8,-41.6},{-30.8,-62},{-72,-62}}, color={0,0,0}));
  connect(sourceWater.C, waterPressureLossIn.C1)
    annotation (Line(points={{-71,-2},{-63,-2}}, color={0,0,255}));
  connect(internalCombustionEngine.Cws1, waterPressureLossIn.C2) annotation (
      Line(points={{-39.6,-2},{-51,-2}}, color={0,0,255}));
  connect(internalCombustionEngine.Cws2, waterPressureLossOut.C1)
    annotation (Line(points={{39.6,-2},{48,-2},{51,-2}}, color={0,0,255}));
  connect(sinkWater.C, waterPressureLossOut.C2)
    annotation (Line(points={{75,-2},{65,-2}}, color={0,0,255}));
  connect(internalCombustionEngine.Cfg, sink.C) annotation (Line(
      points={{0,37.6},{0,65}},
      color={0,0,0},
      thickness=1));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TestInternalCombustionEngine;
