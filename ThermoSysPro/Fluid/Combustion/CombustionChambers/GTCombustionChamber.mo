within ThermoSysPro.Fluid.Combustion.CombustionChambers;
model GTCombustionChamber "Gas turbine combustion chamber"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model for the water/steam side" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  replaceable package Medium_FlueGases = ThermoSysPro.Properties.Media.FlueGases constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model for the flue gases side" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));

  parameter Real kcham=1 "Pressure loss coefficient in the combustion chamber";
  parameter Units.SI.Area Acham=1 "Average cross-sectional area of the combustion chamber";
  parameter Real eta_comb=1 "Combustion efficiency";
  parameter Units.SI.Power Wpth=1e6 "Thermal loss fraction in the body of the combustion chamber";
  parameter Boolean air_atomisation=false "true: computation with air atomisation - false: computation without air atomisation";
  parameter Units.SI.Temperature Tecpat=293 "Temperature at the inlet of the atomisation compressor";
  parameter Real kat=0 "Atomisation pressure loss coefficient";
  parameter Real XQat=0 "Atomisation air mass flow rate coefficient";
  parameter Real Xspat=0 "Atomisation over-pressure coefficient";
  parameter Real eta_is=1 "Atomisation compressor isentropic efficiency";
  parameter Boolean diffusion=false "true: energy balance equation with diffusion - false: energy balance equation without diffusion";

protected
  constant Real amC=12.01115 "Carbon atomic mass";
  constant Real amH=1.00797 "Hydrogen atomic mass";
  constant Real amO=15.9994 "Oxygen atomic mass";
  constant Real amS=32.064 "Sulfur atomic mass";
  constant Real eps_a=1e-6 "Zero criterion for a-dimensional numbers";
  constant Real eps_s=1e-6 "Zero criterion for surface numbers";
  constant Real amCO2 = amC + 2*amO "CO2 molecular mass";
  constant Real amH2O = 2*amH + amO "H2O molecular mass";
  constant Real amSO2 = amS + 2*amO "SO2 molecular mass";
  parameter Integer iN2=ThermoSysPro.Properties.Media.Functions.findSubstanceIndex(Medium_FlueGases.substanceNames, {"N2", "Nitrogen", "nitrogen"}) "Index of nitrogen in the flue gases composition";
  parameter Integer iO2=ThermoSysPro.Properties.Media.Functions.findSubstanceIndex(Medium_FlueGases.substanceNames, {"O2", "Oxygen", "oxygen"}) "Index of oxygen in the flue gases composition";
  parameter Integer iH2O=ThermoSysPro.Properties.Media.Functions.findSubstanceIndex(Medium_FlueGases.substanceNames, {"H2O", "Water", "water"}) "Index of water vapor in the flue gases composition";
  parameter Integer iCO2=ThermoSysPro.Properties.Media.Functions.findSubstanceIndex(Medium_FlueGases.substanceNames, {"CO2", "Carbondioxide", "Carbon dioxide", "carbondioxide"}) "Index of carbon dioxide in the flue gases composition";
  parameter Integer iSO2=ThermoSysPro.Properties.Media.Functions.findSubstanceIndex(Medium_FlueGases.substanceNames, {"SO2", "Sulfurdioxide", "Sulfur dioxide", "sulfurdioxide"}) "Index of sulfur dioxide in the flue gases composition";
  parameter Units.SI.MassFlowRate gamma0=1.e-4
    "Pseudo-diffusion conductance use for continuous flow reversal (active if diffusion=false and continuous_flow_reversal = true)";

public
  Units.SI.MassFlowRate Qea(start=400) "Air mass flow rate";
  Units.SI.AbsolutePressure Pea(start=1e5) "Air pressure at the inlet";
  Units.SI.Temperature Tea(start=600) "Air temperature at the inlet";
  Units.SI.SpecificEnthalpy Hea(start=50e3) "Air specific enthalpy at the inlet";
  Real XeaCO2(start=0) "CO2 mass fraction at the air inlet";
  Real XeaH2O(start=0.1) "H2O mass fraction at the air inlet";
  Real XeaO2(start=0.2) "O2 mass fraction at the air inlet";
  Real XeaSO2(start=0) "SO2 mass fraction at the air inlet";
  Units.SI.MassFlowRate Qfuel(start=5) "Fuel mass flow rate";
  Units.SI.Temperature Tfuel(start=300) "Fuel temperature";
  Units.SI.SpecificEnthalpy Hfuel(start=10e3) "Fuel specific enthalpy";
  Real XCfuel(start=0.8) "C mass fraction in the fuel";
  Real XHfuel(start=0.2) "H mass fraction in the fuel";
  Real XOfuel(start=0) "O mass fraction in the fuel";
  Real XSfuel(start=0) "S mass fraction in the fuel";
  Units.SI.SpecificEnergy LHVfuel(start=5e7) "Fuel lower heating value";
  Units.SI.SpecificHeatCapacity Cpfuel(start=1000) "Fuel specific heat capacity";
  Units.SI.MassFlowRate Qews(start=1) "Water/steam mass flow rate";
  Units.SI.SpecificEnthalpy Hews(start=10e3) "Water/steam specific enthalpy at the inlet";
  Units.SI.MassFlowRate Qsf(start=400) "Flue gases mass flow rate";
  Units.SI.AbsolutePressure Psf(start=12e5) "Flue gases pressure at the outlet";
  Units.SI.Temperature Tsf(start=1500) "Flue gases temperature at the outlet";
  Units.SI.SpecificEnthalpy Hsf(start=50e4) "Flue gases specific enthalpy at the outlet";
  Real XsfCO2(start=0.5) "CO2 mass fraction in the flue gases";
  Real XsfH2O(start=0.1) "H2O mass fraction in the flue gases";
  Real XsfO2(start=0) "O2 mass fraction in the flue gases";
  Real XsfSO2(start=0) "SO2 mass fraction in the flue gases";
  Units.SI.Power Wfuel(start=5e8) "LHV power available in the fuel";
  Real exc(start=1) "Combustion air ratio";
  ThermoSysPro.Units.SI.PressureDifference deltaPccb(start=1e3) "Pressure loss in the combusiton chamber";
  Units.SI.SpecificEnthalpy Hrair(start=10e3) "Air reference specific enthalpy";
  Units.SI.SpecificEnthalpy Hrws(start=10e4) "Water/steam reference specific enthalpy";
  Units.SI.SpecificEnthalpy Hrfuel(start=10e3) "Fuel reference specific enthalpy";
  Units.SI.SpecificEnthalpy Hrfg(start=10e3) "Flue gases reference specific enthalpy";
  Units.SI.SpecificEnthalpy Hecpat(start=10e3) "Air specific enthalpy at the inlet of the atomisaiton compressor";
  Units.SI.SpecificEnthalpy Hiscpat(start=10e3) "Air specific enthalpy after isentropic expansion at the outlet of the atomisaiotn compressor";
  Units.SI.AbsolutePressure Pecpat(start=1e5) "Pressure at the inlet of the atomisation compressor";
  Units.SI.AbsolutePressure Pscpat(start=1e5) "Pressure at the outlet of the atomisation compressor";
  Units.SI.SpecificEntropy Secpat(start=1e3) "Entropy at the inlet of the atomisation compressor";
  Units.SI.MassFlowRate Qm(start=400) "Average mass flow rate in the combustion chamber";
  Real Vea(start=0.001) "Air volume mass (m3/kg)";
  Real Vsf(start=0.001) "Flue gases volume mass (m3/kg)";
  Units.SI.Density rhoea(start=0.001) "Air density at the inlet";
  Units.SI.Density rhosf(start=0.001) "Flue gases density at the outlet";
  Real Vccbm(start=0.001) "Average volume mass in the combustion chamber";
  Units.SI.Velocity v(start=100) "Flue gases reference velocity in the combusiton chamber";
  Units.SI.Power Wcpat(start=1e3) "Power of the atomisation compressor";
  Units.SI.Power Wrfat(start=1e3) "Thermal power extracted by the atomisaiton refrigerant";
  Real eta_isc(start=1) "Intermediate variable for the computation of the isentropic efficiency of the atomisaiton compressor";
  Units.SI.Area Achamc(start=1) "Intermediate variable for the computation of the average corss-section aera of the combusion chamber";
  Real XeaO2c(start=0.2) "Intermediate variable for the computation of the O2 mass fraction";
  Units.SI.SpecificEnthalpy h(start=10e5) "Fluid specific enthalpy";
  Units.SI.Power Ja "Thermal power diffusion from inlet Ca";
  Units.SI.Power Jws "Thermal power diffusion from inlet Cws";
  Units.SI.Power Jfg "Thermal power diffusion from outlet Cfg";
  Units.SI.Power J "Total thermal power diffusion";
  Units.SI.MassFlowRate gamma_a "Diffusion conductance for inlet Ca";
  Units.SI.MassFlowRate gamma_ws "Diffusion conductance for inlet Cws";
  Units.SI.MassFlowRate gamma_fg "Diffusion conductance for outlet Cfg";
  Real ra "Value of r(Q/gamma) for inlet Ca";
  Real rws "Value of r(Q/gamma) for inlet Cws";
  Real rfg "Value of r(Q/gamma) for outlet Cfg";
  Medium.MassFraction Xws[Medium.nXi](start=Medium.X_default[1:Medium.nXi]) "Water/steam mass fractions";
  Medium_FlueGases.MassFraction Xea[Medium_FlueGases.nX](start=Medium_FlueGases.X_default) "Air inlet mass fractions";
  Medium_FlueGases.MassFraction Xsf[Medium_FlueGases.nX](start=Medium_FlueGases.X_default) "Flue gases outlet mass fractions";
  Medium.ExtraProperty SubCws[Medium.nC](quantity=Medium.extraPropertiesNames, start=Medium.C_default) "Water/steam trace substances";
  Medium_FlueGases.ExtraProperty SubCfg[Medium_FlueGases.nC](quantity=Medium_FlueGases.extraPropertiesNames, start=Medium_FlueGases.C_default) "Flue gases trace substances";
  Medium_FlueGases.ThermodynamicState state_air_in "Air inlet thermodynamic state";
  Medium_FlueGases.ThermodynamicState state_fg_out "Flue gases outlet thermodynamic state";
  Medium_FlueGases.ThermodynamicState state_atom_in "Atomisation compressor inlet state";

public
  ThermoSysPro.Fluid.Interfaces.Connectors.FuelInlet Cfuel "Fuel inlet"
    annotation (Placement(transformation(extent={{-10,-100},{10,-80}}, rotation=
           0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet Ca(redeclare package Medium = Medium_FlueGases) "Air inlet"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}}, rotation=
           0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet Cfg(redeclare package Medium = Medium_FlueGases) "Flue gases outlet"
    annotation (Placement(transformation(extent={{80,-10},{100,10}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet Cws(redeclare package Medium = Medium) "Water/steam inlet"
    annotation (Placement(transformation(extent={{-70,80},{-50,100}}, rotation=
            0)));
equation

  assert(Medium_FlueGases.nX > 1, "GTCombustionChamber: Medium_FlueGases must be a gas mixture");
  assert(iN2 > 0 and iO2 > 0 and iH2O > 0 and iCO2 > 0 and iSO2 > 0, "GTCombustionChamber: Medium_FlueGases.substanceNames must contain nitrogen, oxygen, water, carbon dioxide and sulfur dioxide");

  /* Fuel inlet */
  Qfuel = Cfuel.Q;
  Tfuel = Cfuel.T;
  XCfuel = Cfuel.Xc;
  XHfuel = Cfuel.Xh;
  XOfuel = Cfuel.Xo;
  XSfuel = Cfuel.Xs;
  LHVfuel = Cfuel.LHV;
  Cpfuel = Cfuel.cp;

  /* Water inlet */
  Cws.diff_res_2 = 0;
  Cws.diff_on_2 = diffusion;

  Qews = Cws.Q;
  Hews = Cws.h;
  Xws = Cws.Xi;
  SubCws = Cws.SubC;

  /* Air inlet */
  Qea = Ca.Q;
  Pea = Ca.P;
  Hea = Ca.h;

  Xea[1:Medium_FlueGases.nXi] = Ca.Xi;
  if Medium_FlueGases.nXi < Medium_FlueGases.nX then
    Xea[Medium_FlueGases.nX] = 1 - sum(Ca.Xi);
  end if;
  XeaCO2 = Xea[iCO2];
  XeaH2O = Xea[iH2O];
  XeaO2 = Xea[iO2];
  XeaSO2 = Xea[iSO2];

  /* Flue gases outlet */
  Qsf = Cfg.Q;
  Psf = Cfg.P;
  Hsf = Cfg.h;

  /* Mass balance equation */
  0 = Qea + Qews + Qfuel - Qsf;

  /* Energy balance equation */
  if air_atomisation then
    0 = ((Qea + Qews + Qfuel)*(Hsf - Hrfg) + Wrfat + Wpth) - (Qfuel*(Hfuel - Hrfuel + LHVfuel*eta_comb) + Qea*(Hea - Hrair) + Qews*(Hews - Hrws) + Wcpat) + J;

    /* Atomisation power */
    Pecpat = Pea*(1 - kat);
    Pscpat = (1 + Xspat)*Pea;
    Wcpat = Qea*XQat*(Hiscpat - Hecpat)*eta_isc;

    /* Heat extracted by the atomisation refrigerant */
    Wrfat = Qea*XQat*(Hea - Hecpat);
  else
    0 = ((Qea + Qews + Qfuel)*(Hsf - Hrfg) + Wpth) - (Qfuel*(Hfuel - Hrfuel + LHVfuel*eta_comb) + Qea*(Hea - Hrair) + Qews*(Hews - Hrws)) + J;

    /* Atomisation power */
    Pecpat = Pea;
    Pscpat = Pea;
    Wcpat = 0;

    /* Heat extracted by the atomisation refrigerant */
    Wrfat = 0;
  end if;

  Cws.h_vol_2 = h;
  Ca.h_vol_2 = h;
  Cfg.h_vol_1 = h;

  /* No flow reversal */
  Cfg.h = Cfg.h_vol_1;

  /* Diffusion power */
  if diffusion then
    ra = if Ca.diff_on_1 then exp(-0.033*(Ca.Q*Ca.diff_res_1)^2) else 0;
    rws = if Cws.diff_on_1 then exp(-0.033*(Cws.Q*Cws.diff_res_1)^2) else 0;
    rfg = if Cfg.diff_on_2 then exp(-0.033*(Cfg.Q*Cfg.diff_res_2)^2) else 0;

    gamma_a = if Ca.diff_on_1 then 1/Ca.diff_res_1 else gamma0;
    gamma_ws = if Cws.diff_on_1 then 1/Cws.diff_res_1 else gamma0;
    gamma_fg = if Cfg.diff_on_2 then 1/Cfg.diff_res_2 else gamma0;

    Ja = if Ca.diff_on_1 then ra*gamma_a*(Ca.h_vol_1 - Ca.h_vol_2) else 0;
    Jws = if Cws.diff_on_1 then rws*gamma_ws*(Cws.h_vol_1 - Cws.h_vol_2) else 0;
    Jfg = if Cfg.diff_on_2 then rfg*gamma_fg*(Cfg.h_vol_2 - Cfg.h_vol_1) else 0;
  else
    ra = 0;
    rws = 0;
    rfg = 0;

    gamma_a = gamma0;
    gamma_ws = gamma0;
    gamma_fg = gamma0;

    Ja = 0;
    Jws = 0;
    Jfg = 0;
  end if;

  J = Ja + Jws + Jfg;

  Ca.diff_res_2 = 0;
  Cfg.diff_res_1 = 0;

  Ca.diff_on_2 = diffusion;
  Cfg.diff_on_1 = diffusion;

  /* Specific enthalpy and entropy at the inlet of the atomisation compressor */
  if air_atomisation then
     Hecpat = Medium_FlueGases.specificEnthalpy_pTX(p=Pecpat, T=Tecpat, X=Xea);
     state_atom_in = Medium_FlueGases.setState_pTX(p=Pecpat, T=Tecpat, X=Xea);
     Secpat = Medium_FlueGases.specificEntropy(state_atom_in);
     Hiscpat = Medium_FlueGases.isentropicEnthalpy(p_downstream=Pscpat, refState=state_atom_in);
  else
     Hecpat =  60000;
     state_atom_in = Medium_FlueGases.setState_pTX(p=Pecpat, T=Tecpat, X=Xea);
     Secpat = -2000;
     Hiscpat = 60000;
  end if;

  /* Reference specific enthalpies */
  Hrair = 2501.569e3*XeaH2O;
  Hrfuel = 0;
  Hrws = 2501.569e3;
  Hrfg = 2501.569e3*XsfH2O;

  /* Air specific enthalpy at the inlet */
  Hea = Medium_FlueGases.specificEnthalpy_pTX(p=Pea, T=Tea, X=Xea);
  state_air_in = Medium_FlueGases.setState_pTX(p=Pea, T=Tea, X=Xea);

  /* Flue gases specific enthalpy at the outlet */
  Hsf = Medium_FlueGases.specificEnthalpy_pTX(p=Psf, T=Tsf, X=Xsf);
  state_fg_out = Medium_FlueGases.setState_pTX(p=Psf, T=Tsf, X=Xsf);

  /* Air density at the inlet */
  rhoea = Medium_FlueGases.density(state_air_in);
  Vea = if (rhoea > 0.001) then 1/rhoea else 1/1.1;

  /* Flue gases density at the outlet */
  rhosf = Medium_FlueGases.density(state_fg_out);
  Vsf = if (rhosf > 0.001) then 1/rhosf else 1/0.1;

  0 = if (eta_is > eps_a) then (eta_isc - eta_is) else (eta_isc - eps_a);
  0 = if (Acham > eps_s) then (Achamc - Acham) else (Achamc - eps_s);
  0 = if (XeaO2 > eps_a) then (XeaO2c - XeaO2) else (XeaO2c - eps_a);

  /* CO2 flue gases mass fraction */
  XsfCO2*(Qea + Qews + Qfuel) = (Qea*XeaCO2) + (Qfuel*XCfuel*amCO2/amC);

  /* H2O flue gases mass fraction */
  XsfH2O*(Qea + Qews + Qfuel) = (Qews) + (Qea*XeaH2O+Qfuel*XHfuel*amH2O/2/amH);

  /* O2 flue gases mass fraction */
  XsfO2*(Qea + Qews + Qfuel) = (Qea*XeaO2c) - (Qfuel*amO*(2*XCfuel/amC + 0.5*XHfuel/amH + 2*XSfuel/amS)) + (Qfuel*XOfuel);

  /* SO2 flue gases mass fraction */
  XsfSO2*(Qea + Qews + Qfuel) = (Qea*XeaSO2) + (Qfuel*XSfuel*amSO2/amS);

  Xsf[iN2] = 1 - XsfCO2 - XsfH2O - XsfO2 - XsfSO2;
  Xsf[iO2] = XsfO2;
  Xsf[iH2O] = XsfH2O;
  Xsf[iCO2] = XsfCO2;
  Xsf[iSO2] = XsfSO2;
  Cfg.Xi = Xsf[1:Medium_FlueGases.nXi];
  Cfg.SubC = Ca.SubC;
  SubCfg = Cfg.SubC;

  /* Fuel thermal power */
  Wfuel = Qfuel*LHVfuel;

  /* Combustion air ratio */
  exc = Qea*(1 - XeaH2O)/((Qfuel*amO*(2*XCfuel/amC + 0.5*XHfuel/amH + 2*XSfuel/amS - XOfuel/amO))/(XeaO2c/(1 - XeaH2O)));

  /* Pressure losses */
  Pea - Psf = deltaPccb;
  Qm = Qea + (Qfuel + Qews)/2;
  Vccbm = (Vea + Vsf)/2;
  v = Qm*Vccbm/Achamc;
  deltaPccb = (kcham*(v^2))/(2*Vccbm);

  /* Fuel specific enthalpy at the inlet */
  Hfuel = Cpfuel*(Tfuel - 273.16);

    annotation (Diagram(graphics={
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,255},
          fillColor={120,255,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-20,80},{-20,-80}}, color={0,0,255}),
        Polygon(
          points={{-20,62},{46,46},{2,30},{58,18},{6,0},{48,-16},{2,-32},{54,
              -44},{-20,-60},{-20,62}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.CrossDiag)}),
                             Icon(graphics={
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,255},
          fillColor=DynamicSelect({255,255,0},
          if diffusion then fill_color_singular
          else fill_color_static),
          fillPattern=FillPattern.Solid),
        Line(points={{-20,80},{-20,-80}}, color={0,0,255}),
        Polygon(
          points={{-20,62},{46,46},{2,30},{58,18},{6,0},{48,-16},{2,-32},{54,
              -44},{-20,-60},{-20,62}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.CrossDiag),
        Text(
          extent={{-98,104},{-72,76}},
          lineColor={28,108,200},
          textString="Water in"),
        Text(
          extent={{62,34},{110,-2}},
          lineColor={238,46,47},
          textString="Flue gases out"),
        Text(
          extent={{18,-78},{44,-106}},
          lineColor={28,108,200},
          textString="Fuel in"),
        Text(
          extent={{-100,-6},{-74,-30}},
          lineColor={28,108,200},
          textString="Air in")}),
    Documentation(revisions = "
Author  

Baligh El Hefni   

    ", info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
This component model is documented in Sect. 8.1 of the ThermoSysPro book.   
    "));
end GTCombustionChamber;
