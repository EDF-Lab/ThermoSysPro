within ThermoSysPro.Fluid.HeatExchangers;
model SteamGenerator_1SG "Single steam generator"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialTwoPhaseThermoSysProMedium "Medium model for the secondary water/steam side" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  replaceable package Medium_Primary = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model for the primary side" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));

  parameter Integer Ns=5 "Number of segments in tubes and riser" annotation (Dialog(tab="General", group="Geometry"));

  parameter Integer n_tubes=4085 "Number of pipes in parallel" annotation (Dialog(tab="General", group="Geometry"));
  parameter Units.SI.Area S=4669 "Heat exchange area" annotation (Dialog(tab="General", group="Geometry"));
  parameter Units.SI.Length e_tubes=1.2e-3 "Pipe's wall thickness" annotation (Dialog(tab="General", group="Geometry"));
  parameter Units.SI.Length Dext_tubes=22.0e-3 "Pipe's external Diameter" annotation (Dialog(tab="General", group="Geometry"));
  parameter Units.SI.Length Leq=S/(n_tubes*(Dext_tubes - 2*e_tubes)*Modelica.Constants.pi) "Equivalent length for pipes and riser" annotation (Dialog(tab="General", group="Geometry"));
  parameter Real hcCorr=5.0 "Corrective term for the heat exchange coefficient (hc) inside all pipes - to tune correct Tcold_primary" annotation (Dialog(tab="General", group="Geometry"));

  parameter Units.SI.Volume V_sep=7.0 "Volume of the separator" annotation (Dialog(tab="General", group="Separator: from Riser volume to Dome"));
  parameter Units.SI.Length L_sep=3.0 "Length of the separator" annotation (Dialog(tab="General", group="Separator: from Riser volume to Dome"));
  parameter Units.SI.Length D_sep=fromVtoDeq(V_sep, L_sep, 1) "Equivalent diameter of the separator (considered one pipe)" annotation (Dialog(tab="General", group="Separator: from Riser volume to Dome"));

  parameter Units.SI.Volume V_Riser=45.0 "Riser's volume " annotation (Dialog(tab="General", group="Riser (Tube bundle in the secondary)"));
  parameter Units.SI.Length D_Riser=fromVtoDeq(
      V_Riser,
      Leq/2,
      n_tubes) "Equivalent diameter of the riser" annotation (Dialog(tab="General", group="Riser (Tube bundle in the secondary)"));
  parameter Real K_riser=10 "Pressure loss coefficient to tune correct recirculation rate" annotation (Dialog(tab="General", group="Riser (Tube bundle in the secondary)"));

  parameter Units.SI.Volume V_Dome=60.0 "Volume of the dome" annotation (Dialog(tab="General", group="Dome"));
  parameter Units.SI.Length L_Dome=5.0 "Length of the dome" annotation (Dialog(tab="General", group="Dome"));
  parameter Units.SI.Length R_Dome=sqrt(V_Dome/(L_Dome*Modelica.Constants.pi)) "Radius of the dome" annotation (Dialog(tab="General", group="Dome"));

  parameter Units.SI.Volume V_DownComer=8.0 "Volume of the downcomer" annotation (Dialog(tab="General", group="DownComer"));
  parameter Units.SI.Diameter Dint_DownComer=4.0 "Inner diameter of the annular downcomer" annotation (Dialog(tab="General", group="DownComer"));
  final parameter AnnularHydraulicEquivalence downComerHydraulicEquivalence=
      fromAnnularVtoHydraulicEquivalence(
        V_DownComer,
        Leq/2,
        Dint_DownComer);
  final parameter Units.SI.Diameter Dh_DownComer=
      downComerHydraulicEquivalence.Dh "Hydraulic diameter of the annular downcomer";
  final parameter Real neq_DownComer=downComerHydraulicEquivalence.neq
      "Equivalent number of circular pipes preserving the downcomer flow area";

  parameter Units.SI.Volume V_MixARE=12.0 "Volume where feedwater mixes with recirculation" annotation (Dialog(tab="General", group="MixARE"));

  parameter Boolean inertia=false
    "true: momentum balance equation with inertia - false: without inertia";
  parameter Boolean advection=false
    "true: momentum balance equation with advection terme - false: without advection terme";
  parameter Boolean dynamic_energy_balance=true
    "true: dynamic energy balance equation - false: static energy balance equation";
  parameter Boolean dynamic_mass_balance=true
    "true: dynamic mass balance equation - false: static mass balance equation (active if dynamic_energy_balance=true)" annotation(Evaluate=true, Dialog(enable=dynamic_energy_balance));
  parameter Boolean simplified_dynamic_energy_balance=true
    "true: simplified dynamic energy balance equation - false: full dynamic energy balance equation (active if dynamic_energy_balance=true and dynamic_mass_balance=true)" annotation(Evaluate=true, Dialog(enable=dynamic_energy_balance and dynamic_mass_balance));
  parameter Boolean steady_state=true
    "true: start from steady state - false: start from T0 (if option_temperature = true) or h0 (if option_temperature=false)(active if dynamic_energy_balance=true)" annotation(Evaluate=true, Dialog(enable=dynamic_energy_balance));
  parameter Real Vf0=0.1 "Fraction of initial water volume in the drum (active if dynamic_energy_balance=true and steady_state=false)" annotation(Evaluate=true, Dialog(enable=dynamic_energy_balance and not steady_state));
  parameter Units.SI.AbsolutePressure P0=50.e5
    "Fluid initial pressure in the drum (active if dynamic_energy_balance=true and steady_state=false)"
    annotation (Evaluate=true, Dialog(enable=dynamic_energy_balance and not
          steady_state));
  parameter Boolean option_temperature=false
    "true: initial temperature is fixed - false: initial specific enthalpy is fixed (active if steady_state=false)" annotation(Evaluate=true, Dialog(enable=not steady_state));
  parameter Boolean continuous_flow_reversal=false
    "true: continuous flow reversal - false: discontinuous flow reversal";
  parameter Boolean diffusion=false
    "true: energy balance equation with diffusion - false: energy balance equation without diffusion";

  Real CirculationRate "Circulation rate";
  Units.SI.Power W_GV_primary "Power from primary to SG";
  Units.SI.Power W_GV_secondary "Power from SG to secondary";

public
  ThermoSysPro.Fluid.HeatExchangers.DynamicOnePhaseFlowPipe UtubeHotLeg(
    redeclare package Medium = Medium_Primary,
    L=Leq/2,
    D=Dext_tubes - 2*e_tubes,
    ntubes=n_tubes,
    z2=Leq/2,
    hcCorr=hcCorr,
    Ns=Ns,
    dpfCorr=0.17,
    advection=advection,
    dynamic_energy_balance=dynamic_energy_balance,
    dynamic_mass_balance=dynamic_mass_balance,
    simplified_dynamic_energy_balance=simplified_dynamic_energy_balance,
    steady_state=steady_state,
    inertia=inertia,
    continuous_flow_reversal=continuous_flow_reversal,
    diffusion=diffusion,
    option_temperature=option_temperature)
                 annotation (Placement(transformation(
        origin={-67,-41.5},
        extent={{30.5,-15},{-30.5,15}},
        rotation=270)));

  ThermoSysPro.Fluid.HeatExchangers.DynamicOnePhaseFlowPipe UtubeColdLeg(
    redeclare package Medium = Medium_Primary,
    L=Leq/2,
    D=Dext_tubes - 2*e_tubes,
    ntubes=n_tubes,
    z1=Leq/2,
    hcCorr=hcCorr,
    Ns=Ns,
    dpfCorr=0.17,
    inertia=inertia,
    advection=advection,
    dynamic_energy_balance=dynamic_energy_balance,
    dynamic_mass_balance=dynamic_mass_balance,
    simplified_dynamic_energy_balance=simplified_dynamic_energy_balance,
    steady_state=steady_state,
    continuous_flow_reversal=continuous_flow_reversal,
    diffusion=diffusion,
    option_temperature=option_temperature)
                 annotation (Placement(transformation(
        origin={67,-41.5},
        extent={{30.5,-14},{-30.5,14}},
        rotation=90)));

  ThermoSysPro.Fluid.Volumes.DynamicDrum DomeGV(
    redeclare package Medium = Medium,
    cpp=500,
    L=L_Dome,
    R=R_Dome,
    Mp=32000,
    dynamic_energy_balance=dynamic_energy_balance,
    steady_state=steady_state,
    continuous_flow_reversal=continuous_flow_reversal,
    diffusion=diffusion,
    Vf0=Vf0,
    P0=P0)
              annotation (Placement(transformation(extent={{-22,64},{22,107}},
          rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.LumpedStraightPipe DPSeparateurCyclone(
    redeclare package Medium = Medium,
    L=L_sep,
    D=D_sep,
    z2=L_sep,
    lambda=0.03,
    inertia=inertia)
                 annotation (Placement(transformation(
        origin={0,42},
        extent={{-5,-10},{5,10}},
        rotation=90)));
public
  ThermoSysPro.Fluid.Volumes.VolumeC MixAlimDomeGV(
    redeclare package Medium = Medium,
    V=V_MixARE,
    dynamic_energy_balance=dynamic_energy_balance,
    steady_state=steady_state,
    dynamic_mass_balance=dynamic_mass_balance,
    continuous_flow_reversal=continuous_flow_reversal,
    diffusion=diffusion)                               " "
    annotation (Placement(transformation(
        origin={94,63},
        extent={{-8,-8},{8,8}},
        rotation=270)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss DPnulle_AlimDwnc(
      redeclare package Medium = Medium,
      K=1e-4)
    annotation (Placement(transformation(
        origin={94,88},
        extent={{-6,-7},{6,7}},
        rotation=270)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss DPnulle_DomeDwnc(
    redeclare package Medium = Medium,
    p_rho=0,
    K=0.172144)                   annotation (Placement(transformation(extent={{53,53},
            {63,73}},          rotation=0)));

public
  ThermoSysPro.Fluid.Sensors.SensorP CapteurPAlim(redeclare package Medium = Medium)
    annotation (Placement(transformation(
        origin={99,26},
        extent={{-6,-6},{6,6}},
        rotation=270)));

  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet fluidOutletI(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,139},{10,159}}, rotation=
            0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet fluidInlet(redeclare package Medium = Medium) annotation (
      Placement(transformation(extent={{42,102},{62,122}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet fluidInlet1(redeclare package Medium = Medium_Primary) annotation (
      Placement(transformation(extent={{-56,-132},{-36,-112}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet fluidOutletI1(redeclare package Medium = Medium_Primary)
    annotation (Placement(transformation(extent={{36,-132},{56,-112}}, rotation=
           0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet fluidOutletI_purge(redeclare package Medium = Medium) "Purge outlet (optional)"
    annotation (Placement(transformation(extent={{140,-130},{160,-110}}, rotation=0), iconTransformation(extent={{36,-100},{56,-80}})));
  ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal outputReal
    annotation (Placement(transformation(extent={{-42,86},{-62,106}}, rotation=
            0)));
public
  ThermoSysPro.Fluid.PressureLosses.LumpedStraightPipe DownComerGV(
    redeclare package Medium = Medium,
    p_rho=0,
    L=Leq/2,
    D=Dh_DownComer,
    ntubes=neq_DownComer,
    z1=Leq/2,
    lambda=0.09,
    inertia=inertia)           "DownComerGV" annotation (Placement(transformation(
        origin={94.5,-41},
        extent={{-31,16.5},{31,-16.5}},
        rotation=270)));
  Thermal.HeatTransfer.HeatExchangerWall heatExchangerWall(
    ntubes=UtubeHotLeg.ntubes,
    L=UtubeHotLeg.L,
    D=UtubeHotLeg.D,
    e=e_tubes,
    Ns=UtubeHotLeg.Ns,
    lambda=23,
    cpw=503,
    rhow=8430,
    dynamic_energy_balance=dynamic_energy_balance)
                  annotation (Placement(transformation(
        origin={-44,-41},
        extent={{-33,-16},{33,16}},
        rotation=270)));
  Thermal.HeatTransfer.HeatExchangerWall heatExchangerWall1(
    ntubes=UtubeColdLeg.ntubes,
    L=UtubeColdLeg.L,
    D=UtubeColdLeg.D,
    e=e_tubes,
    Ns=UtubeColdLeg.Ns,
    lambda=23,
    cpw=503,
    rhow=8430,
    dynamic_energy_balance=dynamic_energy_balance)
                  annotation (Placement(transformation(
        origin={44,-41},
        extent={{-33,16},{33,-16}},
        rotation=270)));

  ThermoSysPro.Fluid.HeatExchangers.DynamicTwoPhaseFlowRiser RiserGV(
    redeclare package Medium = Medium,
    L=Leq/2,
    D=D_Riser,
    ntubes=n_tubes,
    z2=Leq/2,
    hcCorr=hcCorr,
    Ns=Ns,
    dpfCorr=1,
    inertia=inertia,
    advection=advection,
    dynamic_energy_balance=dynamic_energy_balance,
    dynamic_mass_balance=dynamic_mass_balance,
    simplified_dynamic_energy_balance=simplified_dynamic_energy_balance,
    steady_state=steady_state,
    continuous_flow_reversal=continuous_flow_reversal,
    diffusion=diffusion,
    option_temperature=option_temperature)
                                                          annotation (Placement(
        transformation(
        origin={-2.5,-41},
        extent={{-32,31.5},{32,-31.5}},
        rotation=90)));

  ThermoSysPro.Fluid.Volumes.VolumeA volumeA(
    redeclare package Medium = Medium,
    P0=68.4935e5,
    h0=1185.2e3,
    dynamic_energy_balance=dynamic_energy_balance,
    steady_state=steady_state,
    dynamic_mass_balance=dynamic_mass_balance,
    continuous_flow_reversal=continuous_flow_reversal,
    diffusion=diffusion)       annotation (Placement(transformation(
        origin={1,-110},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  ThermoSysPro.Fluid.Volumes.VolumeC volumeA1(
    redeclare package Medium = Medium,
    V=0.1,
    dynamic_energy_balance=dynamic_energy_balance,
    steady_state=steady_state,
    dynamic_mass_balance=dynamic_mass_balance,
    continuous_flow_reversal=continuous_flow_reversal,
    diffusion=diffusion)                                                                                                                   annotation (
      Placement(transformation(
        origin={0,18},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss DPnulle_Tcirc(
    redeclare package Medium = Medium,
    p_rho=0,
    K=K_riser) annotation (Placement(transformation(
        extent={{-6,-7},{6,7}},
        rotation=90,
        origin={1,-86})));

  function fromVtoDeq "Equivalent diameter of ntubes circular pipes of total volume V and length L"
    input Units.SI.Volume V;
    input Units.SI.Length L;
    input Integer ntubes;
    output Units.SI.Length D;
  algorithm
    D := sqrt((4*V)/(L*Modelica.Constants.pi*ntubes));
  end fromVtoDeq;

  record AnnularHydraulicEquivalence "Hydraulic equivalence of an annular duct"
    Units.SI.Diameter Dh "Hydraulic diameter";
    Real neq "Equivalent number of circular pipes preserving the flow area";
  end AnnularHydraulicEquivalence;

  function fromAnnularVtoHydraulicEquivalence "Hydraulic diameter and equivalent number of pipes of an annular duct of volume V, length L and inner diameter Dint"
    input Units.SI.Volume V;
    input Units.SI.Length L;
    input Units.SI.Diameter Dint;
    output AnnularHydraulicEquivalence hydraulicEquivalence;
  protected
    Units.SI.Area A;
    Units.SI.Diameter Dext;
  algorithm
    assert(V > 0, "The annular volume must be strictly positive");
    assert(L > 0, "The annular length must be strictly positive");
    assert(Dint >= 0, "The annular inner diameter must be positive or zero");
    A := V/L;
    Dext := sqrt(Dint^2 + 4*A/Modelica.Constants.pi);
    hydraulicEquivalence.Dh := Dext - Dint;
    hydraulicEquivalence.neq :=
      A/(Modelica.Constants.pi*hydraulicEquivalence.Dh^2/4);
  end fromAnnularVtoHydraulicEquivalence;
equation
  CirculationRate = DownComerGV.Q/fluidOutletI.Q;
  W_GV_primary = (fluidInlet1.h - fluidOutletI1.h)*fluidInlet1.Q;
  W_GV_secondary = -(fluidInlet.h - fluidOutletI.h)*fluidInlet.Q;

  /* Unconnected purge outlet */
  if (cardinality(fluidOutletI_purge) == 1) then
    fluidOutletI_purge.Q = 0;
    fluidOutletI_purge.h_vol_2 = 1.e5;
    fluidOutletI_purge.diff_res_2 = 0;
    fluidOutletI_purge.diff_on_2 = false;
  end if;

  connect(UtubeHotLeg.C2, UtubeColdLeg.C1) annotation (Line(
      points={{-67,-11},{-67,-2},{67,-2},{67,-11}},
      color={127,0,0},
      thickness=0.5));
  connect(MixAlimDomeGV.Ce1, DPnulle_AlimDwnc.C2)
    annotation (Line(points={{94,71},{94,82}}, thickness=0.5));
  connect(DPnulle_DomeDwnc.C2, MixAlimDomeGV.Ce3) annotation (Line(
      points={{63,63},{86,63}},
      color={0,0,255},
      thickness=0.5));
  connect(MixAlimDomeGV.Cs, CapteurPAlim.C1) annotation (Line(
      points={{94,55},{94.2,32}},
      color={0,0,255},
      thickness=0.5));
  connect(DPnulle_AlimDwnc.C1, fluidInlet)
    annotation (Line(points={{94,94},{94,100.5},{52,100.5},{52,112}}));
  connect(fluidInlet1, UtubeHotLeg.C1) annotation (Line(
      points={{-46,-122},{-66,-122},{-66,-72},{-67,-72}},
      color={127,0,0},
      thickness=0.5));
  connect(UtubeColdLeg.C2, fluidOutletI1) annotation (Line(
      points={{67,-72},{68,-78},{68,-122},{46,-122}},
      color={127,0,0},
      thickness=0.5));
  connect(CapteurPAlim.C2, DownComerGV.C1)      annotation (Line(
      points={{94.2,19.88},{94.2,20},{94,20},{94,6},{94.5,6},{94.5,-10}},
      color={0,0,255},
      thickness=0.5));
  connect(UtubeHotLeg.CTh, heatExchangerWall.WT1) annotation (Line(
      points={{-62.5,-41.5},{-57.25,-41.5},{-57.25,-41},{-47.2,-41}},
      color={191,95,0},
      thickness=0.5));
  connect(heatExchangerWall1.WT1, UtubeColdLeg.CTh) annotation (Line(
      points={{47.2,-41},{58,-41},{58,-41.5},{62.8,-41.5}},
      color={191,95,0},
      thickness=0.5));
  connect(DownComerGV.C2, volumeA.Ce1)      annotation (Line(points={{94.5,-72},
          {94.5,-128},{1,-128},{1,-120}}, color={0,0,255}));
  connect(volumeA.Cs1, DPnulle_Tcirc.C1) annotation (Line(points={{1,-100},{1,-92}}, color={0,0,255}));
  connect(DPnulle_Tcirc.C2, RiserGV.C1) annotation (Line(points={{1,-80},{0.65,-80},{0.65,-73}}, color={0,0,255}));
  connect(volumeA.Cs2, fluidOutletI_purge) annotation (Line(points={{11,-110},{130,-110},{130,-120},{150,-120}}, color={0,0,255}));
  connect(RiserGV.C2, volumeA1.Ce1)
                                  annotation (Line(points={{0.65,-9},{
          -6.12303e-016,-9},{-6.12303e-016,8}}, color={0,0,255}));
  connect(volumeA1.Cs, DPSeparateurCyclone.C1) annotation (Line(points={{
          6.12303e-016,28},{-6.12303e-016,28},{-6.12303e-016,37}}, color={0,0,
          255}));
  connect(heatExchangerWall.WT2, RiserGV.CTh2)
                                             annotation (Line(points={{-40.8,
          -41},{-18.25,-41}}, color={191,95,0}));
  connect(RiserGV.CTh1, heatExchangerWall1.WT2)
                                              annotation (Line(points={{19.55,
          -41},{40.8,-41}}, color={191,95,0}));
  connect(DomeGV.Cv, fluidOutletI) annotation (Line(points={{22,107},{22,124},{
          0,124},{0,149}}, color={255,0,0}));
  connect(DPSeparateurCyclone.C2, DomeGV.Cm) annotation (Line(points={{
          6.12303e-016,47},{6.12303e-016,52},{22,52},{22,64}}, color={0,0,255}));
  connect(DomeGV.Cd, DPnulle_DomeDwnc.C1) annotation (Line(points={{22,64},{40,64},{40,63},{53,63}}, color={0,0,255}));
  connect(DomeGV.yLevel, outputReal) annotation (Line(points={{24.2,85.5},{32,85.5},
          {32,114},{-36,114},{-36,96},{-52,96}}, color={0,0,255}));
  annotation (Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-150,-150},{150,150}},
        initialScale=0.1), graphics={Text(
          extent={{55,81},{55,75}},
          lineColor={0,0,255},
          textString=
               "petit DP"), Text(
          extent={{-126,153},{-84,123}},
          lineColor={0,0,255},
          textString=
               "= 1 SG")}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-150,-150},{150,150}},
        initialScale=0.1), graphics={
        Ellipse(
          extent={{-42,150},{42,108}},
          lineColor={0,0,0},
          fillPattern=DynamicSelect(FillPattern.VerticalCylinder,
          if dynamic_energy_balance then FillPattern.VerticalCylinder
          else FillPattern.Solid),
          fillColor={0,128,255}),
        Rectangle(
          extent={{-42,131},{42,80}},
          lineColor={0,0,0},
          fillPattern=DynamicSelect(FillPattern.VerticalCylinder,
          if dynamic_energy_balance then FillPattern.VerticalCylinder
          else FillPattern.Solid),
          fillColor={0,128,255}),
        Ellipse(
          extent={{-36,-108},{36,-150}},
          lineColor={0,0,0},
          fillPattern=DynamicSelect(FillPattern.VerticalCylinder,
          if dynamic_energy_balance then FillPattern.VerticalCylinder
          else FillPattern.Solid),
          fillColor={0,128,255}),
        Rectangle(
          extent={{-42,86},{42,56}},
          lineColor={0,0,0},
          fillPattern=DynamicSelect(FillPattern.VerticalCylinder,
          if dynamic_energy_balance then FillPattern.VerticalCylinder
          else FillPattern.Solid),
          fillColor={170,213,255}),
        Rectangle(
          extent={{-36,42},{36,-128}},
          lineColor={0,0,0},
          fillPattern=DynamicSelect(FillPattern.VerticalCylinder,
          if dynamic_energy_balance then FillPattern.VerticalCylinder
          else FillPattern.Solid),
          fillColor={170,213,255}),
        Polygon(
          points={{-42,56},{42,56},{36,42},{-36,42},{-42,56}},
          lineColor={0,0,0},
          fillPattern=DynamicSelect(FillPattern.VerticalCylinder,
          if dynamic_energy_balance then FillPattern.VerticalCylinder
          else FillPattern.Solid),
          fillColor={170,213,255})}),
    Documentation(revisions = "
Author  

Baligh El Hefni   

    ", info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
    "));
end SteamGenerator_1SG;
