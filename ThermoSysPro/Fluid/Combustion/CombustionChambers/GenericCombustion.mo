within ThermoSysPro.Fluid.Combustion.CombustionChambers;
model GenericCombustion "Generic combustion chamber"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model for the water/steam side" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  replaceable package Medium_FlueGases = ThermoSysPro.Properties.Media.FlueGases constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model for the flue gases side" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));

  parameter ThermoSysPro.Units.xSI.PressureLossCoefficient kcham=1 "Pressure loss coefficient in the combustion chamber";
  parameter Units.SI.Area Acham=1 "Average corss-sectional area of the combusiton chamber";
  parameter Real Xpth=0.01 "Thermal loss fraction in the body of the combustion chamber (0-1 over Q.HHV)";
  parameter Real ImbCV=0 "Unburnt particles ratio in the volatile ashes (0-1)";
  parameter Real ImbBF=0 "Unburnt particle ratio in the low furnace ashes (0-1)";
  parameter Units.SI.SpecificHeatCapacity Cpcd=500 "Ashes specific heat capacity";
  parameter Units.SI.Temperature Tbf=500 "Ashes temperature at the outlet of the low furnace";
  parameter Real Xbf=0.1 "Ashes ration in the low furnace (0-1)";
  parameter Boolean diffusion=false "true: energy balance equation with diffusion - false: energy balance equation without diffusion";

protected
  constant Real amC=12.01115 "Carbon atomic mass";
  constant Real amH=1.00797 "Hydrogen atomic mass";
  constant Real amO=15.9994 "Oxygen atomic mass";
  constant Real amS=32.064 "Sulfur atomic mass";
  constant Units.SI.SpecificEnergy HHVcarbone=32.8e6 "Unburnt carbon higher heating value";
  constant Real amCO2=amC + 2*amO "CO2 molecular mass";
  constant Real amH2O=2*amH + amO "H2O molecular mass";
  constant Real amSO2=amS + 2*amO "SO2 molecular mass";
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
  Real Xwfuel(start=0) "H2O mass fraction in the fuel";
  Real XCDfuel(start=0) "Ashes mass fraction in the fuel";
  Units.SI.SpecificEnergy LHVfuel(start=5e7) "Fuel lower heating value";
  Units.SI.SpecificHeatCapacity Cpfuel(start=1000) "Fuel specific heat capacity";
  Units.SI.SpecificEnergy HHVfuel "Fuel higher heating value";
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
  Units.SI.Power Wpth(start=1e6) "Thermal losses power";
  Real exc(start=1) "Combustion air ratio";
  Units.SI.MassFlowRate Qcv(start=1) "Volatile ashes mass flow rate";
  Units.SI.MassFlowRate Qbf(start=1) "Low furnace ashes mass flow rate";
  Units.SI.SpecificEnthalpy Hcv(start=10e3)
    "Volatile ashes specific enthalpy at the outlet";
  Units.SI.SpecificEnthalpy Hbf(start=10e3)
    "Low furnace ashes specific enthalpy at the outlet";
  ThermoSysPro.Units.SI.PressureDifference deltaPccb(start=1e3) "Pressure loss in the combustion chamber";
  Units.SI.SpecificEnthalpy Hrair(start=10e3) "Air reference specific enthalpy";
  Units.SI.SpecificEnthalpy Hrws(start=10e4) "Water/steam reference specific enthalpy";
  Units.SI.SpecificEnthalpy Hrfuel(start=10e3) "Fuel reference specific enthalpy";
  Units.SI.SpecificEnthalpy Hrcd(start=10e3) "Ashes reference specific enthalpy";
  Units.SI.SpecificEnthalpy Hrfg(start=10e3) "Flue gases reference specific enthalpy";
  Real Vea(start=0.001) "Air volume mass (m3/kg)";
  Real Vsf(start=0.001) "Flue gases volume mass (m3/kg)";
  Units.SI.Density rhoea(start=0.001) "Air density at the inlet";
  Units.SI.Density rhosf(start=0.001) "Flue gases density at the outlet";
  Units.SI.MassFlowRate Qm(start=400) "Average mlass flow rate in the combusiton chamber";
  Real Vccbm(start=0.001) "Average volume mass in the combustion chamber";
  Units.SI.Velocity v(start=100) "Flue gases reference velocity in the combusiton chamber";
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

public
  ThermoSysPro.Fluid.Interfaces.Connectors.FuelInlet Cfuel "Fuel inlet"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}}, rotation=
            0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet Ca(redeclare package Medium = Medium_FlueGases) "Air inlet"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}},
          rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet Cfg(redeclare package Medium = Medium_FlueGases) "Flue gases outlet"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}}, rotation=
            0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet Cws(redeclare package Medium = Medium) "Water/steam inlet"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}}, rotation=0)));
equation

  assert(Medium_FlueGases.nX > 1, "GenericCombustion: Medium_FlueGases must be a gas mixture");
  assert(iN2 > 0 and iO2 > 0 and iH2O > 0 and iCO2 > 0 and iSO2 > 0, "GenericCombustion: Medium_FlueGases.substanceNames must contain nitrogen, oxygen, water, carbon dioxide and sulfur dioxide");

  /* Fuel inlet */
  Qfuel = Cfuel.Q;
  Tfuel = Cfuel.T;

  XCfuel = Cfuel.Xc;
  XHfuel = Cfuel.Xh;
  XOfuel = Cfuel.Xo;
  XSfuel = Cfuel.Xs;
  Xwfuel = Cfuel.hum;
  XCDfuel = Cfuel.Xashes;

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
  0 = Qea + Qews + Qfuel*(1 - XCDfuel) - Qcv*ImbCV - Qbf*ImbBF - Qsf;

  Qcv = Qfuel*XCDfuel*(1 - Xbf)/(1 - ImbCV);
  Qbf = Qfuel*XCDfuel*Xbf/(1 - ImbBF);

  /* Energy balance equation */
  0 = ((Qea + Qews + Qfuel*(1 - XCDfuel))*(Hsf - Hrfg) + Wpth + Qcv*(Hcv - Hrcd)+ Qbf*(Hbf - Hrcd)+(Qcv*ImbCV+Qbf*ImbBF)*HHVcarbone)
      - (Qfuel*(Hfuel - Hrfuel + LHVfuel) + Qea*(Hea - Hrair) + Qews*(Hews - Hrws)) + J;

  Hfuel = Cpfuel*(Tfuel - 273.16);
  Hcv = Cpcd*(Tsf - 273.16);
  Hbf = Cpcd*(Tbf - 273.16);

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

 /* Reference specific enthalpies */
  Hrair = 2501.569e3*XeaH2O;
  Hrfuel = 0;
  Hrws = 2501.569e3;
  Hrfg = 2501.569e3*XsfH2O;
  Hrcd = 0;

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

  /* CO2 flue gases mass fraction */
  XsfCO2*Qsf = (Qea*XeaCO2) + ((Qfuel*XCfuel - Qcv*ImbCV - Qbf*ImbBF)*amCO2/amC);

  /* H2O flue gases mass fraction */
  XsfH2O*Qsf = Qews + (Qea*XeaH2O+Qfuel*XHfuel*amH2O/2 /amH);

  /* O2 flue gases mass fraction */
  XsfO2*Qsf = (Qea*XeaO2) - (Qfuel*amO*(2*XCfuel/amC + 0.5*XHfuel/amH + 2*XSfuel/amS)) + (Qfuel*XOfuel);

  /* SO2 flue gases mass fraction */
  XsfSO2*Qsf = (Qea*XeaSO2) + (Qfuel*XSfuel*amSO2/amS);

  Xsf[iN2] = 1 - XsfCO2 - XsfH2O - XsfO2 - XsfSO2;
  Xsf[iO2] = XsfO2;
  Xsf[iH2O] = XsfH2O;
  Xsf[iCO2] = XsfCO2;
  Xsf[iSO2] = XsfSO2;
  Cfg.Xi = Xsf[1:Medium_FlueGases.nXi];
  Cfg.SubC = Ca.SubC;
  SubCfg = Cfg.SubC;

  /* Fuel thermal power */
  HHVfuel = LHVfuel + 224.3e5*XHfuel + 25.1e5*Xwfuel;
  Wfuel = Qfuel*HHVfuel;
  Wpth = Qfuel*LHVfuel*Xpth;

  /* Combustion air ratio */
  exc = Qea*(1 - XeaH2O)/((Qfuel*amO*(2*XCfuel/amC + 0.5*XHfuel/amH + 2*XSfuel/amS - XOfuel/amO)
        - Qfuel*amO*2*(Qcv*ImbCV + Qbf*ImbBF)/amC)/(XeaO2/(1 - XeaH2O)));

  /* Pressure losses */
  Pea - Psf = deltaPccb;
  Qm = Qea + (Qfuel + Qews)/2;
  Vccbm = (Vea + Vsf)/2;
  v = Qm*Vccbm/Acham;
  deltaPccb = (kcham*(v^2))/(2*Vccbm);

    annotation (Diagram(graphics={
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-50,-36},{-44,30},{-34,-2},{-10,66},{10,-4},{44,54},{66,-44},
              {38,-80},{-34,-80},{-50,-36}},
          lineColor={0,0,0},
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-32,-36},{-18,-44},{-26,-16},{-16,6},{4,-44},{8,-28},{36,-72},
              {16,-80},{-16,-80},{-32,-36}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}),
                             Icon(graphics={
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,255},
          fillColor=DynamicSelect({255,255,0},
          if diffusion then fill_color_singular
          else fill_color_static),
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-50,-36},{-44,30},{-34,-2},{-10,66},{10,-4},{44,54},{66,-44},
              {38,-80},{-34,-80},{-50,-36}},
          lineColor={0,0,0},
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-32,-36},{-18,-44},{-26,-16},{-16,6},{4,-44},{8,-28},{36,-72},
              {16,-80},{-16,-80},{-32,-36}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{82,-76},{108,-104}},
          lineColor={28,108,200},
          textString="Fuel inlet"),
        Text(
          extent={{-66,-78},{-42,-102}},
          lineColor={28,108,200},
          textString="Air inlet"),
        Text(
          extent={{-110,42},{-82,14}},
          lineColor={28,108,200},
          textString="Water inlet"),
        Text(
          extent={{-18,106},{30,70}},
          lineColor={238,46,47},
          textString="Flue gases outlet")}),
    Documentation(revisions = "
Authors  

Benoît Bride  
Baligh El Hefni   

    ", info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
    "));
end GenericCombustion;
