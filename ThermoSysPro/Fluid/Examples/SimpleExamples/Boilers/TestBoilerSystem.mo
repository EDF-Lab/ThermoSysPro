within ThermoSysPro.Fluid.Examples.SimpleExamples.Boilers;
model TestBoilerSystem
  extends ThermoSysPro.UsersGuide.Icons.Example;
  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam;
  replaceable package Medium_FlueGases = ThermoSysPro.Properties.Media.FlueGases;

  ThermoSysPro.Fluid.Boilers.BoilerSystem boilerSystem(
    redeclare package Medium = Medium,
    redeclare package Medium_FlueGases = Medium_FlueGases,
    Wloss=0,
    Ke=1.e6,
    Tsf=386.16)
    annotation (Placement(transformation(extent={{-28,-40},{28,40}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceFlueGases(
    redeclare package Medium = Medium_FlueGases,
    Q0=27,
    T0=298.16,
    option_temperature=true,
    X0={0.757,0.233,0.01,0,0})
    annotation (Placement(transformation(extent={{-84,-58},{-48,-22}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkFlueGases(
    redeclare package Medium = Medium_FlueGases,
    P0=100000,
    T0=386.16,
    option_temperature=true)
    annotation (Placement(transformation(extent={{-34,74},{2,110}},  rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourceWaterSteam(
    redeclare package Medium = Medium,
    P0=140e5,
    Q0=24,
    h0=600e3)
    annotation (Placement(transformation(extent={{54,-80},{90,-44}}, rotation=180,
        origin={132,-126})));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sinkWaterSteam(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{54,44},{90,80}}, rotation=180,
        origin={90,148})));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss inletPressureLoss(
    redeclare package Medium = Medium,
    K=1e-3,
    rho(start=932.96))
    annotation (Placement(transformation(extent={{34,-66},{42,-58}}, rotation=90,
        origin={-38,-94})));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss outletPressureLoss(
    redeclare package Medium = Medium,
    K=1e-3,
    rho(start=29.77))
    annotation (Placement(transformation(extent={{34,58},{42,66}}, rotation=90,
        origin={112,14})));
equation
  connect(sourceFlueGases.C, boilerSystem.InletFlueGases) annotation (Line(points={{-48,-40},{-24,-40}},                     color={0,0,0}));
  connect(boilerSystem.OutletFlueGases, sinkFlueGases.C) annotation (Line(points={{-24,40},{-40,40},{-40,92},{-34,92}}, color={0,0,0}));
  connect(sourceWaterSteam.C, inletPressureLoss.C1) annotation (Line(points={{42,-64},{24,-64},{24,-60}},
                                                                                                 color={0,0,255}));
  connect(inletPressureLoss.C2, boilerSystem.InletWaterSteam) annotation (Line(points={{24,-52},{24,-40}},          color={0,0,255}));
  connect(boilerSystem.OutletWaterSteam, outletPressureLoss.C1) annotation (Line(points={{24,40},{48,40},{48,44},{50,44},{50,48}},
                                                                                                                   color={0,0,255}));
  connect(outletPressureLoss.C2, sinkWaterSteam.C) annotation (Line(points={{50,56},{50,86},{36,86}},
                                                                                              color={0,0,255}));
  annotation (experiment(StopTime=1));
end TestBoilerSystem;
