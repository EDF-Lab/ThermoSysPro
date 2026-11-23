within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestSteamGenerator_1SG
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.WaterSteam;
  replaceable package Medium_Primary = Properties.Media.WaterSteam;

  parameter Units.SI.Pressure P_Prim=155e5 annotation (Dialog(group="Primary"));
  parameter Units.SI.Temperature Thot_Prim=320 + 273.15 annotation (Dialog(group="Primary"));
  parameter Units.SI.Temperature Tcold_Prim=288.8 + 273.15 annotation (Dialog(group="Primary"));
  parameter Units.SI.MassFlowRate Q_Prim=5000 "Primary side flow rate per SG" annotation (Dialog(group="Primary"));

  parameter Units.SI.Temperature T_Feedwater=227 + 273.15 annotation (Dialog(group="Secondary"));
  parameter Units.SI.SpecificEnthalpy h_Feedwater=977100 annotation (Dialog(group="Secondary"));
  parameter Units.SI.MassFlowRate Q_Secondary=520 "Secondary side flow rate per SG" annotation (Dialog(group="Secondary"));
  parameter Units.SI.Pressure P_Secondary=67.3e5 annotation (Dialog(group="Secondary"));

  parameter Real K_steam(fixed=false, start=43.9)
    "Pressure loss coefficient of the steam line, computed so that the drum level is 1 m (inverse problem)" annotation (Dialog(group="Secondary"));

  ThermoSysPro.Fluid.BoundaryConditions.SinkQ sinkQ(redeclare package Medium = Medium_Primary, Q0=Q_Prim, h0=1.278e6) annotation (Placement(transformation(extent={{60,-44},{80,-24}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourceP(
    redeclare package Medium = Medium_Primary,
    P0=P_Prim,
    T0=Thot_Prim,
    h0=1.478e6,
    option_temperature=false) annotation (Placement(transformation(extent={{-80,-46},{-60,-26}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceQ1(
    redeclare package Medium = Medium,
    h0=h_Feedwater,
    Q0=Q_Secondary,
    option_temperature=false) annotation (Placement(transformation(extent={{100,20},{80,40}})));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkP1(
    redeclare package Medium = Medium,
    h0=2764e3,
    option_temperature=false,
    P0=P_Secondary) annotation (Placement(transformation(extent={{80,50},{100,70}})));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLoss1(
    redeclare package Medium = Medium,
    K=K_steam,
    Pm(start=6895125.5), h(start=2771781.2), Q(start=520), rho(start=35.961479)) annotation (Placement(transformation(
        origin={50,60},
        extent={{10,-10},{-10,10}},
        rotation=180)));
  ThermoSysPro.Fluid.HeatExchangers.SteamGenerator_1SG steamGenerator(
    redeclare package Medium = Medium,
    redeclare package Medium_Primary = Medium_Primary,
    n_tubes=5500,
    S=7000,
    e_tubes=1.09e-3,
    Dext_tubes=19.05e-3,
    hcCorr=1.0,
    V_sep=12,
    L_sep=2.9,
    V_Riser=75,
    V_Dome=100,
    L_Dome=6.3,
    V_MixARE=22.5,
    K_riser=0.6,
    volumeA(dynamic_mass_balance=false),
    UtubeHotLeg(Q(start={5000,5000,5000,5000,5000,5000}), state2(p(start={15500000,15470475,15441022,15411612,15382228,15352859})), P(start={15500000,15470475,15441022,15411612,15382228,15352859,15323499}), h(start={1478000,1437996.6,1405566.4,1379131.4,1357572.5,1340007.1,1340007.1}), Tp(start={583.25378,579.10779,575.58075,572.63025,570.18518})),
    UtubeColdLeg(Q(start={5000,5000,5000,5000,5000,5000}), state2(p(start={15323499,15322608,15321934,15321431,15321063,15320805})), P(start={15323499,15322608,15321934,15321431,15321063,15320805,15320634}), h(start={1340007.1,1325737.9,1314275.8,1304999.8,1297471.1,1291353.1,1291353.1}), Tp(start={568.18042,566.58685,565.26953,564.18793,563.30261})),
    RiserGV(state2(p(start={7102785,7087560,7079207.5,7074296,7070380.5,7066886.5})), P(start={7102785,7087560,7079207.5,7074296,7070380.5,7066886.5,7063601.5}), h(start={1188296.2,1334547.2,1452826.2,1549058.2,1627441.8,1691262.8,1691262.8}), Q(start={1855.46,1855.46,1855.46,1855.46,1855.46,1855.46}), Tp1(start={563.6377,562.93787,562.31647,561.79114,561.35492}), Tp2(start={570.51843,568.78345,567.16504,565.76685,564.59314})),
    heatExchangerWall(Tp(start={576.69275,573.78888,571.24512,569.09436,567.30426})),
    heatExchangerWall1(Tp(start={565.84009,564.70697,563.74817,562.95319,562.29919})),
    DomeGV(Pfond(start=7067494.5), P(start=7060251), hl(start=1270562.4), hv(start=2771781.2), Tp(start=559.56055), zl(fixed=true, start=1.0)),
    volumeA(P(start=7105473), h(start=1188296.2)),
    volumeA1(P(start=7063601.5), h(start=1691262.8)),
    MixAlimDomeGV(P(start=7067079), h(start=1188296.2)),
    DPnulle_Tcirc(Pm(start=7104129), h(start=1188296.2), Q(start=1855.46), rho(start=768.50885)),
    DPnulle_AlimDwnc(Pm(start=7067079), h(start=977100), Q(start=520), rho(start=835.24182)),
    DPnulle_DomeDwnc(Pm(start=7067287), h(start=1270531.6), Q(start=1335.46), rho(start=738.66504)),
    DPSeparateurCyclone(Pm(start=7061926), h(start=1691262.8), Q(start=1855.46), rho(start=116.6667)),
    DownComerGV(Pm(start=7086276), h(start=1188296.2), rho(start=768.48517), Q(start=1855.46))) annotation (Placement(transformation(extent={{-34,-36},{32,40}})));
  ThermoSysPro.Fluid.Sensors.SensorT SensorT_ThotPrim(redeclare package Medium = Medium_Primary) annotation (Placement(transformation(
        origin={-40,-28},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  ThermoSysPro.Fluid.Sensors.SensorT SensorT_TcoldPrim(redeclare package Medium = Medium_Primary) annotation (Placement(transformation(
        origin={40,-26},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  ThermoSysPro.Fluid.Sensors.SensorT SensorT_TARE(redeclare package Medium = Medium, T(start=T_Feedwater)) annotation (Placement(transformation(
        origin={50,38},
        extent={{10,-10},{-10,10}},
        rotation=0)));
equation
  connect(sinkP1.C, singularPressureLoss1.C2) annotation (Line(points={{80,60},{60,60}}));
  connect(singularPressureLoss1.C1, steamGenerator.fluidOutletI) annotation (Line(points={{40,60},{0,60},{0,39.7467},{-1,39.7467}}, color={0,0,255}));
  connect(sourceP.C, SensorT_ThotPrim.C1) annotation (Line(points={{-60,-36},{-50,-36}}, color={0,0,255}));
  connect(SensorT_ThotPrim.C2, steamGenerator.fluidInlet1) annotation (Line(points={{-29.8,-36},{-12,-36}}, color={0,0,255}));
  connect(sinkQ.C, SensorT_TcoldPrim.C2) annotation (Line(points={{60,-34},{50.2,-34}}, color={0,0,255}));
  connect(SensorT_TcoldPrim.C1, steamGenerator.fluidOutletI1) annotation (Line(points={{30,-34},{10,-34},{10,-36}}, color={0,0,255}));
  connect(sourceQ1.C, SensorT_TARE.C1) annotation (Line(points={{80,30},{60,30}}, color={0,0,255}));
  connect(SensorT_TARE.C2, steamGenerator.fluidInlet) annotation (Line(points={{39.8,30},{26,30},{26,29.8667},{10.44,29.8667}}, color={0,0,255}));
  annotation (experiment(StopTime=1, Tolerance=1e-6), Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="
Fluid counterpart of `ThermoSysPro.Examples.SimpleExamples.TestSteamGenerator_1SG`, with the same parameters and boundary conditions:
primary pressure and enthalpy imposed at the inlet, primary flow rate imposed at the outlet, feedwater flow rate and enthalpy imposed,
steam outlet connected to a pressure sink through a singular pressure loss.

As in the WaterSteam example, the drum level is imposed (`steamGenerator.DomeGV.zl(fixed=true, start=1.0)`) and the pressure loss
coefficient of the steam line is computed (inverse problem). The computed coefficient is the parameter `K_steam(fixed=false)`, declared
without binding and passed to `singularPressureLoss1`: a `fixed=false` modifier on `singularPressureLoss1.K` itself would keep the
default binding of `K`, which OpenModelica uses as an equation.

The mass balance of the riser inlet volume `steamGenerator.volumeA` is static (`dynamic_mass_balance=false`), whereas the component
(as the WaterSteam one) uses a dynamic mass balance. At steady state both settings give the same equations (`der(P) = 0` reduces
the dynamic mass balance to `0 = BQ`) and the same solution. They however change the set of states, hence the tearing of the large
nonlinear initialisation system chosen by OpenModelica: without purge flow and with the dynamic mass balance, the torn system is
ill-conditioned (near-null directions along wall temperatures of the tubes) and OpenModelica does not converge, whereas with the static
mass balance it converges to the same steady state as Dymola. `TestSteamGenerator_1SG_Purge` restores the dynamic mass balance.
"));
end TestSteamGenerator_1SG;
