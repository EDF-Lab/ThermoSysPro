within ThermoSysPro.NuclearCore;
model Core


  parameter Integer TubesNumber=Rods_per_FA*numberFA annotation ( Dialog(tab = "Fuel"));
  parameter Integer numberFA=101 "Number of fuel assemblies " annotation ( Dialog(tab = "Fuel"));
  parameter Integer Rods_per_FA=265 "Number of fuel rod per assembly"
                                                                     annotation(Dialog(tab = "Fuel"));
  parameter Integer n_rods=3 "Number of control rods" annotation(Dialog(tab = "Neutronics",group="Control Rods Parameters"));

  parameter ThermoSysPro.Units.SI.MassFlowRate NominalFlow=5573 "Primary Mass Flow Rate" annotation (
    Dialog(tab = "General", group = "Nominal values"));
  parameter ThermoSysPro.Units.SI.Temperature T_inletCore=295 + 273.15 "Core Inlet Temperature" annotation (
    Dialog(tab = "General", group = "Nominal values"));
  parameter ThermoSysPro.Units.SI.Temperature T_outletCore=330 + 273.15 "Core Outlet Temperature" annotation (
    Dialog(tab = "General", group = "Nominal values"));
  parameter ThermoSysPro.Units.SI.Power MaximumPower=1150e6 "Power of the core at 100%" annotation (
    Dialog(tab = "General", group = "Nominal values"));
  parameter ThermoSysPro.Units.SI.Pressure NominalPressure=15500000 "Pressure inside the core" annotation (
    Dialog(tab = "General", group = "Nominal values"));
  parameter ThermoSysPro.Units.SI.SpecificEnthalpy h_inletCore= ThermoSysPro.Properties.Fluid.SpecificEnthalpy_PT(NominalPressure, T_inletCore, 1, 0, 0, 0, 0, 0) "Enthalpy at the core inlet" annotation (
    Dialog(tab = "General", group = "Nominal values"));
  parameter ThermoSysPro.Units.SI.SpecificEnthalpy h_outletCore=ThermoSysPro.Properties.Fluid.SpecificEnthalpy_PT(NominalPressure, T_outletCore, 1, 0, 0, 0, 0, 0) "Enthalpy at the core inlet" annotation (
    Dialog(tab = "General", group = "Nominal values"));

  parameter Real Kfuel=1
    "Ratio between the power produced in the fuel and the total power" annotation (
    Dialog(tab = "Neutronics", group = "Kinetics"));

  parameter Real Ptot0=524e6 "Initial power of the core" annotation ( Dialog(tab = "Initialisation"));

   parameter Real Kris[:]={0.0251,0.01654,0.02586}
    "Fraction of the power associated to group i"  annotation (
      Dialog(tab = "Neutronics", group = "Decay heat"));
  parameter Real Tris[:]={15,137,2910}
     "Time constant associated to group i (s)" annotation (
      Dialog(tab = "Neutronics", group = "Decay heat"));
  parameter Boolean DecayHeat_steady_state=true "Initialize the decay heat at equilibrium" annotation(choices(checkBox=true), Dialog(tab = "Initialisation"));

  parameter Boolean steady_state = true annotation(Dialog(tab = "Neutronics", group = "Reference state"),choices(checkBox=true));

  parameter Real kp[Np] = {-1.085e-17, -1.2e-19} "Poison Coefficient" annotation(Dialog(tab = "Neutronics",group="Reactivity Contributions"));
  parameter Real kB = -10 "Soluble Poison (Boron) Coefficient (pcm/ppm)" annotation(Dialog(tab = "Neutronics",group="Reactivity Contributions"));

  parameter Real rod_stroke[n_rods] = {100,100,100} "Rod Stroke in the core (in steps, cm...)" annotation(Dialog(tab = "Neutronics",group="Control Rods Parameters"));
  parameter Real RodsPos0[n_rods]={10,0,0} "Control rods initial position (0 -> completely extracted from the core)" annotation(Dialog(tab = "Neutronics",group="Control Rods Parameters"));

    parameter Boolean continuosInsertion = true "Whether to use constant rod worths or tables" annotation(Dialog(tab = "Neutronics",group="Control Rods Parameters"),choices(checkBox=true));


  parameter Integer rodWorthModel = 0 "0: constant worth, 1: S-shape, 2: table" annotation(Dialog(tab = "Neutronics",group="Control Rods Parameters"));

  parameter Integer rod_nodes = 10 "Number of sections in the rod worth tables" annotation(Dialog(tab = "Neutronics",group="Control Rods Parameters",enable=rodWorthModel==2));

  parameter Real Z_rodNodes[n_rods,rod_nodes + 3]={{i*rod_stroke[j]/rod_nodes for i in -1:rod_nodes + 1} for j in 1:n_rods} "Z of rodworth sections" annotation (Dialog(tab = "Neutronics",group="Control Rods Parameters", enable=rodWorthModel==2));

  parameter Real rodWorth_tab[n_rods, rod_nodes+3] = zeros(n_rods, rod_nodes+3) "Rod Worth of as a function of Z (see Z_rodNodes)" annotation(Dialog(enable=rodWorthModel==2,tab = "Neutronics",group="Control Rods Parameters"));






  parameter Boolean Pois_steady_state = true "Steady-state (true) or fixed values (false) initialization" annotation(Dialog(tab="Initialisation"));
  parameter Real Xe_start[Np] = fill(0, Np) "Initial concentration of Xenon (if steady_state=false)" annotation (Dialog(tab="Initialisation",enable=not steady_state));
  parameter Real I_start[Np] = fill(0, Np) "Initial concentration of Iode (if steady_state=false)" annotation (Dialog(tab="Initialisation",enable=not steady_state));
  parameter ThermoSysPro.Units.SI.Density FuelDensity = 10950 "Fuel Density" annotation(Dialog(tab="Fuel",group="Fuel Properties"));
  parameter Real Enrichment = 0.02433 "Fuel enrichement" annotation(Dialog(tab="Fuel",group="Fuel Properties"));

  parameter ThermoSysPro.Units.SI.Radius Rp=4.05765E-03 "Radius of the fuel pellet" annotation(Dialog(tab="Fuel",group="Geometry"));
  parameter ThermoSysPro.Units.SI.Length ActiveLength=4.270 "Active length of the fuel rods" annotation(Dialog(tab="Fuel",group="Geometry"));
  parameter ThermoSysPro.Units.SI.Length Length=4.270 "Lenght of the coolant channel" annotation(Dialog(tab="Fuel",group="Geometry"));

  parameter Integer Np =2 "Number of poisons" annotation(Dialog(tab="Neutronics",group="Poisoning"));
  parameter Real FastFissionFactor = 1.07 "Fast Fission Factor" annotation(Dialog(tab="Neutronics",group="Nuclear physics"));
  parameter ThermoSysPro.Units.SI.Area Fuel_Fission_CS = 5.82e-26 "Fuel thermal microscopic fission cross-section" annotation(Dialog(tab="Neutronics",group="Nuclear physics"));
  parameter ThermoSysPro.Units.SI.Energy FissionEnergy = 3.2e-11 "Energy from each fission" annotation(Dialog(tab="Neutronics",group="Nuclear physics"));
  parameter Real FAtomicMass = 235.04393 "Fissil atomic mass" annotation(Dialog(tab="Neutronics",group="Nuclear physics"));
  parameter Real NeutronsPerFission = 2.43 "Average number of neutrons per thermal fission" annotation(Dialog(tab="Neutronics",group="Nuclear physics"));
  parameter Real P_yield[Np] = {0.063,0.011} "Total fission yield of parent nuclide" annotation(Dialog(tab="Neutronics",group="Poisoning"));
  parameter Real D_yield[Np] = {0.002,0} "Total fission yield of daughter nuclide" annotation(Dialog(tab="Neutronics",group="Poisoning"));
  parameter Real P_decay[Np] = {2.95e-05,3.63e-06} "Decay constant of parent nuclide" annotation(Dialog(tab="Neutronics",group="Poisoning"));
  parameter Real D_decay[Np] = {2.1e-05,0} "Decay constant of daughter nuclide" annotation(Dialog(tab="Neutronics",group="Poisoning"));
  parameter ThermoSysPro.Units.SI.Area D_abs_CS[Np] = {3e-22,6.5e-23} "Microscopic absorption cross-section of 135Xenon" annotation(Dialog(tab="Neutronics",group="Poisoning"));

  parameter Real fuel_porosity=0.05 "Fuel porosity" annotation(Dialog(tab="Fuel", group="Fuel Properties"));
  parameter Real oxy_on_metal=2 "Oxyde on Metal Ratio" annotation(Dialog(tab="Fuel", group="Fuel Properties"));
  parameter ThermoSysPro.Units.SI.Density rho_uo2=10950 "Density of UO2" annotation(Dialog(tab="Fuel", group="Fuel Properties"));
  parameter Boolean isMOX=false "Whether fuel is MOX or not" annotation(Dialog(tab="Fuel", group="Fuel Properties"));
  parameter Real pu_mFraction=0 "PuO2 Mass Fraction" annotation(Dialog(tab="Fuel", group="Fuel Properties",enable=isMOX));
  parameter ThermoSysPro.Units.SI.Density rho_puo2=11500 "Density of PuO2" annotation(Dialog(tab="Fuel", group="Fuel Properties",enable=isMOX));
  parameter ThermoSysPro.Units.SI.Density rho=(1-fuel_porosity)*1/(pu_mFraction/rho_puo2+(1-pu_mFraction)/rho_uo2) "Density of MOX" annotation(Dialog(tab="Fuel",group="Fuel Properties",enable=false));

  parameter ThermoSysPro.Units.SI.Radius Rclad=4.1402E-03 "Internal radius of the cladding" annotation(Dialog(tab="Fuel", group="Geometry"));
  parameter ThermoSysPro.Units.SI.Radius Rclad_out= 4.7498E-03 "Internal radius of the cladding" annotation(Dialog(tab="Fuel", group="Geometry"));
  parameter ThermoSysPro.Units.SI.Length pitch =0.012598 "Fuel rod pitch" annotation(Dialog(tab="Fuel", group="Geometry"));

  parameter Integer Nz=6 "Number of axial zones" annotation(Dialog(tab="General"));
  parameter Integer Nr=5 "Number of radial zones" annotation(Dialog(tab="Fuel", group="Geometry"));
  parameter ThermoSysPro.Units.SI.Radius rsi[Nr]={sqrt(i*Rp^2/Nr) for i in 1:Nr} "Radii of volume skins (constant volume)" annotation(Dialog(tab="Fuel", group="Geometry",enable=false));
  parameter ThermoSysPro.Units.SI.Radius rvi[Nr]={sqrt((i-0.5)*Rp^2/Nr) for i in 1:Nr} "Radii of volume centers (constant volume)" annotation(Dialog(tab="Fuel", group="Geometry",enable=false));

  parameter Boolean Fuel_steady_state=true annotation(choices(checkBox=true), Dialog(tab="Initialisation"));
  parameter ThermoSysPro.Units.SI.Temperature Tstart=973.15 annotation(Dialog(tab="Initialisation"));

  parameter ThermoSysPro.Units.SI.CoefficientOfHeatTransfer  heat_coeff_gap=10000
    "Heat Tranfer Coefficient between the fuel rods and the internal wall of the cladding" annotation(Dialog(tab="Fuel"));

  parameter ThermoSysPro.Units.SI.ThermalConductivity lambda=26 "Cladding thermal conductivity" annotation(Dialog(tab="Fuel"));
  parameter ThermoSysPro.Units.SI.SpecificHeatCapacity cpw=1000
    "Cladding specific heat capacity (active if dynamic_energy_balance=true)"
   annotation(Dialog(tab="Fuel"));
  parameter ThermoSysPro.Units.SI.Density rhow=6500
    "Cladding density (active if dynamic_energy_balance=true)"
    annotation(Dialog(tab="Fuel"));
  parameter Real rugosrel=1e-6   "Cladding outer surface relqtive roughness"
    annotation(Dialog(tab="Fuel"));

  ThermoSysPro.WaterSteam.HeatExchangers.DynamicOnePhaseFlowPipe
                                                            PrimaryCoolantFlow_Core(
    L=Length,
    D=2*Rclad_out*(4/3.14*(pitch/2/Rclad_out)^2 - 1),
    rugosrel=rugosrel,
    ntubes=TubesNumber,
    z1=0,
    z2=Length,
    hcCorr=2*Rclad_out/PrimaryCoolantFlow_Core.D*ActiveLength/Length,
    Ns=Nz,
    simplified_dynamic_energy_balance=true,
    inertia=false,
    dynamic_mass_balance=false,
    continuous_flow_reversal=false,
    Q(start=fill(NominalFlow, Nz + 1)),
    P(start=fill(NominalPressure, Nz + 2)),
    h(start=linspace(
          h_inletCore,
          h_outletCore,
          Nz + 2)))                annotation (Placement(transformation(
        extent={{-19,-20},{19,20}},
        rotation=90,
        origin={126,-1})));

  ThermoSysPro.NuclearCore.Modules.FuelThermalPower Fuel_Thermal_Power(
    fuel_porosity=fuel_porosity,
    oxy_on_metal=oxy_on_metal,
    rho_uo2=rho_uo2,
    isMOX=isMOX,
    pu_mFraction=pu_mFraction,
    rho_puo2=rho_puo2,
    Rods_per_FA=Rods_per_FA,
    FA=numberFA,
    Rp=Rp,
    Rclad=Rclad,
    Nz=Nz,
    Nr=Nr,
    Length=ActiveLength,
    steady_state=Fuel_steady_state,
    Tstart=Tstart,
    heat_coeff_gap=heat_coeff_gap)
    annotation (Placement(transformation(extent={{24,-12},{48,12}})));
  ThermoSysPro.Thermal.HeatTransfer.HeatExchangerWall heatExchangerWallCounterFlow(
    L=Length,
    D=2*Rclad,
    e=Rclad_out - Rclad,
    lambda=lambda,
    Ns=Nz,
    cpw=cpw,
    rhow(displayUnit="kg/m3") = rhow,
    steady_state=true,
    ntubes=TubesNumber) annotation (Placement(transformation(
        extent={{-16,-16},{16,16}},
        rotation=90,
        origin={72,0})));
  ThermoSysPro.NuclearCore.Modules.NeutronKinetics Neutron_Kinetics(
    Kfuel=Kfuel,
    Ptot0=Ptot0,
    FissionEnergy=FissionEnergy,
    NeutronsPerFission=NeutronsPerFission,
    Pneut(start=MaximumPower))
    annotation (Placement(transformation(extent={{-64,-20},{-24,20}})));
  ThermoSysPro.NuclearCore.Modules.DecayHeat Residual_Power(
    Kris=Kris,
    Tris=Tris,
    Pres_start=fill(0, size(Kris, 1)),
    steady_state=DecayHeat_steady_state,
    Pneut(start=MaximumPower))
    annotation (Placement(transformation(extent={{-60,-74},{-24,-38}})));
  ThermoSysPro.NuclearCore.Modules.ReactivityFeedbacks Reactivity_Feedbacks(
    steady_state=steady_state,
    Tref_mod=(T_inletCore + T_outletCore)/2,
    Np=Np,
    kp=kp,
    kB=kB,
    n_rods=n_rods,
    rod_stroke=rod_stroke,
    RodsPos0=RodsPos0,
    rodWorthModel=rodWorthModel,
    rod_nodes=rod_nodes,
    continuosInsertion=continuosInsertion)
    annotation (Placement(transformation(extent={{-66,40},{-14,100}})));
  ThermoSysPro.WaterSteam.Sensors.SensorT
                                     sensorTin(Q(start=NominalFlow)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={118,-62})));
  ThermoSysPro.WaterSteam.Sensors.SensorT
                                     sensorTout(Q(start=NominalFlow)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={118,66})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Add Tmoy(k1=0.5, k2=0.5) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={66,60})));
  ThermoSysPro.NuclearCore.Modules.Poison xenon(
    steady_state=Pois_steady_state,
    Np=Np,
    FuelDensity=FuelDensity,
    Enrichment=Enrichment,
    Rp=Rp,
    Length=Length,
    Rods_per_FA=Rods_per_FA,
    FA=numberFA,
    FastFissionFactor=FastFissionFactor,
    Fuel_Fission_CS=Fuel_Fission_CS,
    FissionEnergy=FissionEnergy,
    FAtomicMass=FAtomicMass,
    P_decay=P_decay,
    D_decay=D_decay,
    P_yield=P_yield,
    D_yield=D_yield,
    D_abs_CS=D_abs_CS)
    annotation (Placement(transformation(extent={{-6,18},{14,38}})));
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal RodsSpeeds1[size(
    Reactivity_Feedbacks.RodsSpeeds, 1)]
    annotation (Placement(transformation(extent={{-170,80},{-150,100}}),
        iconTransformation(extent={{-170,80},{-150,100}})));
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal EntreeCbore1
    annotation (Placement(transformation(extent={{-168,-10},{-148,10}}),
        iconTransformation(extent={{-168,-10},{-148,10}})));
  ThermoSysPro.WaterSteam.Connectors.FluidInletI      C1_1
    annotation (Placement(transformation(extent={{-10,-128},{10,-108}})));
  ThermoSysPro.WaterSteam.Connectors.FluidOutletI      C2_1
    annotation (Placement(transformation(extent={{-10,130},{10,150}})));
  ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal Tmoyen
    annotation (Placement(transformation(extent={{154,76},{174,96}}),
        iconTransformation(extent={{154,76},{174,96}})));
  ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal Thot
    annotation (Placement(transformation(extent={{156,40},{176,60}}),
        iconTransformation(extent={{156,40},{176,60}})));
  ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal Tcold
    annotation (Placement(transformation(extent={{156,6},{176,26}}),
        iconTransformation(extent={{156,6},{176,26}})));
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal S1
    annotation (Placement(transformation(extent={{-170,32},{-150,52}}),
        iconTransformation(extent={{-170,32},{-150,52}})));
  replaceable ThermoSysPro.NuclearCore.Modules.KinParam_BU_Linear KinParam(Nrods=
        n_rods) constrainedby
    ThermoSysPro.NuclearCore.Interfaces.KineticParametersInterface annotation (
      choicesAllMatching=true, Placement(transformation(extent={{-130,-84},{-88,
            -54}})));
  Interfaces.KineticParametersInput bUinput
    annotation (Placement(transformation(extent={{-170,-78},{-150,-58}})));
equation


  connect(Neutron_Kinetics.DecayHeat, Residual_Power.DecayHeat) annotation (Line(points={{-65.2,2},
          {-80,2},{-80,-32},{-18,-32},{-18,-56},{-22.2,-56}},                                                                                                color={0,0,255}));
  connect(Neutron_Kinetics.Pneutrons, Residual_Power.Pneutrons) annotation (Line(points={{-22,10},
          {-14,10},{-14,-82},{-66,-82},{-66,-56},{-61.8,-56}},                                                                                               color={0,0,255}));
  connect(Reactivity_Feedbacks.SortieReac, Neutron_Kinetics.Reactivity) annotation (Line(points={{
          -13.2571,70},{-4,70},{-4,34},{-74,34},{-74,16},{-64.8,16}},                                                                                            color={0,0,255}));
  connect(Fuel_Thermal_Power.Teff_fuel, Reactivity_Feedbacks.EntreeT_fuel) annotation (Line(points={{36,13.2},
          {36,106},{-92,106},{-92,92.5},{-66.3714,92.5}},                                                                                                color={0,0,255}));
  connect(Fuel_Thermal_Power.C_clad, heatExchangerWallCounterFlow.WT2) annotation (Line(points={{49.2,
          -0.12},{59,-0.12},{59,0},{68.8,0}},                                                                                                    color={0,0,0}));
  connect(heatExchangerWallCounterFlow.WT1, PrimaryCoolantFlow_Core.CTh) annotation (Line(points={{75.2,0},
          {120,0},{120,-1}},                                                                                                   color={0,0,0}));
  connect(Tmoy.u2, sensorTout.Measure) annotation (Line(
      points={{77,66},{108,66}},
      color={0,0,255},
      pattern=LinePattern.Dot));
  connect(Tmoy.u1, sensorTin.Measure) annotation (Line(
      points={{77,54},{98,54},{98,-62},{108,-62}},
      color={0,0,255},
      pattern=LinePattern.Dot));
  connect(Tmoy.y, Reactivity_Feedbacks.EntreeT_CoreAv) annotation (Line(
      points={{55,60},{50,60},{50,88},{-8,88},{-8,108},{-76,108},{-76,87.25},{-66.3714,
          87.25}},
      color={0,0,255},
      pattern=LinePattern.Dot));
  connect(Neutron_Kinetics.TotalPower, Fuel_Thermal_Power.Wt_fuel) annotation (Line(points={{-22,3.2},
          {18,3.2},{18,0},{22.8,0}},                                                                                                      color={0,0,255}));
  connect(sensorTout.C1, PrimaryCoolantFlow_Core.C2) annotation (Line(points={{126,56},
          {126,18}},                                                                          color={0,0,0}));
  connect(PrimaryCoolantFlow_Core.C1, sensorTin.C2) annotation (Line(points={{126,-20},
          {126,-51.8}},                                                                          color={0,0,0}));
  connect(Reactivity_Feedbacks.RodsSpeeds, RodsSpeeds1) annotation (Line(points={{
          -66.3714,98.125},{-144,98.125},{-144,90},{-160,90}},            color
        ={0,0,255}));
  connect(Reactivity_Feedbacks.EntreeCbore, EntreeCbore1) annotation (Line(
        points={{-66.3714,81.25},{-96,81.25},{-96,76},{-122,76},{-122,0},{-158,0}},
        color={0,0,255}));
  connect(sensorTin.C1, C1_1) annotation (Line(points={{126,-72},{126,-86},{0,
          -86},{0,-118}},         color={0,0,0}));
  connect(sensorTout.C2, C2_1) annotation (Line(points={{126,76.2},{126,112},{0,
          112},{0,140}}, color={0,0,0}));
  connect(Tmoy.y, Tmoyen) annotation (Line(
      points={{55,60},{50,60},{50,86},{164,86}},
      color={0,0,255},
      pattern=LinePattern.Dot));
  connect(sensorTout.Measure, Thot) annotation (Line(
      points={{108,66},{104,66},{104,50},{166,50}},
      color={0,0,255},
      pattern=LinePattern.Dot));
  connect(sensorTin.Measure, Tcold) annotation (Line(
      points={{108,-62},{98,-62},{98,16},{166,16}},
      color={0,0,255},
      pattern=LinePattern.Dot));
  connect(xenon.Power, Residual_Power.Pneutrons) annotation (Line(points={{-4.2,28},
          {-14,28},{-14,-82},{-66,-82},{-66,-56},{-61.8,-56}},
                 color={0,0,255}));
  connect(xenon.Poisons, Reactivity_Feedbacks.EntreeCpois) annotation (Line(
        points={{12.2,28},{20,28},{20,110},{-78,110},{-78,75.625},{-66.3714,75.625}},
                      color={0,0,255}));
  connect(Neutron_Kinetics.S, S1) annotation (Line(points={{-64.8,9.2},{-144,9.2},
          {-144,42},{-160,42}}, color={0,0,255}));
  connect(bUinput, KinParam.BUinput) annotation (Line(points={{-160,-68},{-150,-68},
          {-150,-70},{-130,-70},{-130,-69}}, color={0,140,72}));
  connect(KinParam.outputReal[1], Reactivity_Feedbacks.alfa_mod) annotation (
      Line(points={{-87.16,-69},{-76,-69},{-76,-36},{-116,-36},{-116,69.625},{-66.3714,
          69.625}}, color={0,0,255}));
  connect(KinParam.outputReal[2], Reactivity_Feedbacks.alfa_dop) annotation (
      Line(points={{-87.16,-69},{-76,-69},{-76,-36},{-116,-36},{-116,64.5625},{-66.3714,
          64.5625}}, color={0,0,255}));
  connect(KinParam.outputReal[3], Reactivity_Feedbacks.ReacGd) annotation (Line(
        points={{-87.16,-69},{-76,-69},{-76,-36},{-116,-36},{-116,58.5625},{-66.3714,
          58.5625}}, color={0,0,255}));
  connect(KinParam.outputReal[4], Neutron_Kinetics.Tlife) annotation (Line(
        points={{-87.16,-69},{-76,-69},{-76,-36},{-116,-36},{-116,-17.6},{-65.2,
          -17.6}}, color={0,0,255}));
  connect(KinParam.outputReal[5:10], Neutron_Kinetics.Lambda) annotation (Line(
        points={{-87.16,-69},{-76,-69},{-76,-36},{-116,-36},{-116,-4.4},{-65.2,-4.4}},
        color={0,0,255}));
  connect(KinParam.outputReal[11:16], Neutron_Kinetics.Beta) annotation (Line(
        points={{-87.16,-69},{-76,-69},{-76,-36},{-116,-36},{-116,-11.2},{-65.2,
          -11.2}}, color={0,0,255}));
  connect(KinParam.outputReal[17], Reactivity_Feedbacks.deltaReacFuel)
    annotation (Line(points={{-87.16,-69},{-76,-69},{-76,-36},{-116,-36},{-116,45.8125},
          {-66.3714,45.8125}}, color={0,0,255}));
  connect(KinParam.outputReal[18:end], Reactivity_Feedbacks.rodWorth)
    annotation (Line(points={{-87.16,-69},{-76,-69},{-76,-36},{-116,-36},{-116,52.5625},
          {-66.3714,52.5625}}, color={0,0,255}));
  annotation (
    experiment(StopTime=1000),
    Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2024 </p>
<p><b>ThermoSysPro Version 4.1 </h4>
</html>"),
    Diagram(coordinateSystem(extent={{-160,-120},{160,140}})),
    Icon(coordinateSystem(extent={{-160,-120},{160,140}}), graphics={
        Ellipse(
          extent={{-162,140},{160,22}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={255,128,0}),
        Ellipse(
          extent={{-162,0},{160,-120}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={255,128,0}),
        Rectangle(
          extent={{-162,90},{160,-66}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,128,0}),
        Text(
          extent={{-86,56},{84,-32}},
          textColor={28,108,200},
          textString="Core")}));
end Core;
