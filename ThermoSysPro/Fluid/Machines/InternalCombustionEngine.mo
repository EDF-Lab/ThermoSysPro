within ThermoSysPro.Fluid.Machines;
model InternalCombustionEngine "Internal combustion engine with electrical output"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model for the water/steam side" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  replaceable package Medium_FlueGases = ThermoSysPro.Properties.Media.FlueGases constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model for the flue gases side" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));

  parameter Integer mechanical_efficiency_type=1 "1: fixed nominal efficiency - 2: Linear efficiency using Coef_Rm_a, Coef_Rm_b and Coef_Rm_c - 3: Beau de Rochas cycle efficiency";
  parameter Real Rmeca_nom=0.40 "Fixed nominal mechanical efficiency (active if mechanical_efficiency_type=1)";
  parameter Real Coef_Rm_a=-5.727E-09 "Coefficient a for the linear mechanical efficiency (active if mechanical_efficiency_type=2)";
  parameter Real Coef_Rm_b=4.5267E-05 "Coefficient b for the linear mechanical efficiency (active if mechanical_efficiency_type=2)";
  parameter Real Coef_Rm_c=0.312412946 "Coefficient c for the linear mechanical efficiency (active if mechanical_efficiency_type=2)";
  parameter Real Relec=0.97 "Engine electrical efficiency";
  parameter Real Cosphi=1 "Cos(phi) of the electrical grid";
  parameter Real Xpth=0.03 "Thermal loss fraction - cooling (0-1 sur Q.PCI)";
  parameter Real Xref=0.2 "Cooling power fraction (0-1 sur Q.PCI)";
  parameter Real MMg=30 "Gas average molar mass (g/mol)";
  parameter Real DPe=0 "Water pressure loss as percent of the pressure at the inlet";
  parameter ThermoSysPro.Units.SI.PressureDifference DPaf=0
    "Pressure difference between the air pressure at the inlet and the flue gases pressure at the outlet";
  parameter Real RV=6 "Engine volume ratio (> 1)";
  parameter Real Kc=1.2 "Compression polytropic coefficient";
  parameter Real Kd=1.4 "Expansion polytropic coefficient";
  parameter Real Gamma=1.3333 "Flue gases gamma = Cp/Cv";
  parameter Units.SI.MassFlowRate gamma_diff_ws=1e-4
    "Diffusion conductance for the water/steam side (active if diffusion=true in neighbouring volumes)";
  parameter Boolean continuous_flow_reversal=false "true: continuous flow reversal - false: discontinuous flow reversal";
  parameter Boolean diffusion=false "true: energy balance equation with diffusion - false: energy balance equation without diffusion";

protected
  constant Real amC=12.01115 "Carbon atomic mass";
  constant Real amH=1.00797 "Hydrogen atomic mass";
  constant Real amO=15.9994 "Oxygen atomic mass";
  constant Real amS=32.064 "Sulfur atomic mass";
  constant Real amCO2=amC+2*amO "CO2 molecular mass";
  constant Real amH2O=2*amH+amO "H2O molecular mass";
  constant Real amSO2=amS+2*amO "SO2 molecular mass";
  parameter Integer iN2=ThermoSysPro.Properties.Media.Functions.findSubstanceIndex(Medium_FlueGases.substanceNames, {"N2", "Nitrogen", "nitrogen"}) "Index of nitrogen in the flue gases composition";
  parameter Integer iO2=ThermoSysPro.Properties.Media.Functions.findSubstanceIndex(Medium_FlueGases.substanceNames, {"O2", "Oxygen", "oxygen"}) "Index of oxygen in the flue gases composition";
  parameter Integer iH2O=ThermoSysPro.Properties.Media.Functions.findSubstanceIndex(Medium_FlueGases.substanceNames, {"H2O", "Water", "water"}) "Index of water vapor in the flue gases composition";
  parameter Integer iCO2=ThermoSysPro.Properties.Media.Functions.findSubstanceIndex(Medium_FlueGases.substanceNames, {"CO2", "Carbondioxide", "Carbon dioxide", "carbondioxide"}) "Index of carbon dioxide in the flue gases composition";
  parameter Integer iSO2=ThermoSysPro.Properties.Media.Functions.findSubstanceIndex(Medium_FlueGases.substanceNames, {"SO2", "Sulfurdioxide", "Sulfur dioxide", "sulfurdioxide"}) "Index of sulfur dioxide in the flue gases composition";
  parameter Units.SI.MassFlowRate gamma0=1.e-4
    "Pseudo-diffusion conductance use for continuous flow reversal (active if diffusion=false and continuous_flow_reversal = true)";

public
  Units.SI.MassFlowRate Qsf(start=400)
    "Flue gases mass flow rate at the outlet";
  Units.SI.AbsolutePressure Psf(start=12e5) "Flue gases pressure at the outlet";
  Units.SI.Temperature Tsf(start=1500) "Flue gases temperature at the outlet";
  Real XsfCO2(start=0.5) "Flue gases CO2 mass fraction at the outlet";
  Real XsfH2O(start=0.1) "Flue gases H2O mass fraction at the outlet";
  Real XsfO2(start=0) "Flue gases O2 mass fraction at the outlet";
  Real XsfSO2(start=0) "Flue gases SO2 mass fraction at the outlet";
  Real Rmeca(start=0.3) "Engine mechanical efficiency";
  Units.SI.Power Wmeca(start=5e8) "Engine mechanical power";
  Units.SI.Power Welec(start=5e8) "Engine electrical power";
  Units.SI.Power Wact(start=5e8) "Active power";
  Units.SI.Power Wcomb(start=5e8) "Fuel power available (Q.PCS)";
  Units.SI.Power Wpth_ref(start=1e6) "Power of thermal losses + cooling";
  Real exc(start=1) "Combustion air ratio";
  Real PCScomb "Pouvoir Calorifique Supérieur du combustible sur brut(en J/kg)";
  Units.SI.Temperature Tm(start=500) "Air-gas mixture temperature";
  Units.SI.Temperature Tfcp(start=500)
    "Temperature at the end of the compression phase";
  Units.SI.AbsolutePressure Pfcp(start=12e5)
    "Pressure at the end of the compression phase";
  Units.SI.Temperature Tfcb(start=500)
    "Temperature at the end of the combustion phase";
  Units.SI.AbsolutePressure Pfcb(start=12e5)
    "Pressure at the end of the combustion phase";
  Units.SI.Temperature Tfd(start=500)
    "Temperature at the end of the expansion phase";
  Units.SI.AbsolutePressure Pfd(start=12e5)
    "Pressure at the end of the expansion phase";
  Units.SI.Temperature Tfe(start=500) "Temperature at the exhaust";
  Units.SI.SpecificEnthalpy Hea(start=50e3)
    "Air specific enthalpy at the inlet";
  Units.SI.SpecificEnthalpy Hsf(start=50e4)
    "Flue gases specific enthalpy at the outlet";
  Units.SI.SpecificEnthalpy Hcomb(start=10e3)
    "Fuel specific enthalpy at the inlet";
  Units.SI.SpecificEnthalpy Hrfum(start=10e3)
    "Flue gases reference specific enthalpy";
  Units.SI.SpecificEnthalpy Hrair(start=10e3) "Air reference specific enthalpy";
  Units.SI.SpecificEnthalpy Hrcomb(start=10e3)
    "Fuel reference specific enthalpy";
  Units.SI.MassFlowRate Qea(start=400) "Air mass flow rate at the inlet";
  Units.SI.AbsolutePressure Pea(start=1e5) "Air pressure at the inlet";
  Units.SI.Temperature Tea(start=600) "Air temperature at the inlet";
  Real XeaCO2(start=0) "Air CO2 mass fraction at the inlet";
  Real XeaH2O(start=0.1) "Air H2O mass fraction at the inlet";
  Real XeaO2(start=0.2) "Air O2 mass fraction at the inlet";
  Real XeaSO2(start=0) "Air SO2 mass fraction at the inlet";
  Units.SI.SpecificHeatCapacity Cpair(start=1000) "Air specific heat capacity";
  Units.SI.MassFlowRate Qcomb(start=5) "Fuel mass flow rate";
  Units.SI.Temperature Tcomb(start=300) "Fuel temperature";
  Real XCcomb(start=0.8) "Fuel carbon fraction";
  Real XHcomb(start=0.2) "Fuel hydrogen fraction";
  Real XOcomb(start=0) "Fuel oxygen fraction";
  Real XScomb(start=0) "Fuel sulfur fraction";
  Real XEAUcomb(start=0) "Fuel H2O fraction";
  Real XCDcomb(start=0) "Fuel ashes fraction";
  Real PCIcomb(start=5e7) "Fuel PCI (J/kg)";
  Units.SI.SpecificHeatCapacity Cpcomb(start=1000)
    "Fuel specific heat capacity";
  Units.SI.MassFlowRate Qe(start=1) "Water mass flow rate";
  Units.SI.SpecificEnthalpy Hev(start=10e3)
    "Water specific enthalpy at the inlet";
  Units.SI.Density rhoea(start=0.001) "Air density at the inlet";
  Units.SI.Density rhosf(start=0.001) "Flue gases density at the outlet";
  Units.SI.SpecificEnthalpy Hsv(start=10e3)
    "Water specific enthalpy at the outlet";
  Real MMairgaz(start=30) "Air/gas mixture molecular mass (g/mol)";
  Real MMfumees(start=30) "Flue gases molecular mass (g/mol)";
  Units.SI.SpecificEnthalpy h(start=10e5) "Flue gases specific enthalpy";
  Units.SI.Power Jair "Thermal power diffusion from inlet Cair";
  Units.SI.Power Jfg "Thermal power diffusion from outlet Cfg";
  Units.SI.Power J "Total thermal power diffusion";
  Units.SI.MassFlowRate gamma_air "Diffusion conductance for inlet Cair";
  Units.SI.MassFlowRate gamma_fg "Diffusion conductance for outlet Cfg";
  Real rair "Value of r(Q/gamma) for inlet Cair";
  Real rfg "Value of r(Q/gamma) for outlet Cfg";
  Medium.MassFraction Xws[Medium.nXi](start=Medium.X_default[1:Medium.nXi]) "Water/steam mass fractions";
  Medium_FlueGases.MassFraction Xea[Medium_FlueGases.nX](start=Medium_FlueGases.X_default) "Air inlet mass fractions";
  Medium_FlueGases.MassFraction Xsf[Medium_FlueGases.nX](start=Medium_FlueGases.X_default) "Flue gases outlet mass fractions";
  Medium.ExtraProperty SubCws[Medium.nC](quantity=Medium.extraPropertiesNames, start=Medium.C_default) "Water/steam trace substances";
  Medium_FlueGases.ExtraProperty SubCfg[Medium_FlueGases.nC](quantity=Medium_FlueGases.extraPropertiesNames, start=Medium_FlueGases.C_default) "Flue gases trace substances";

public
  ThermoSysPro.Fluid.Interfaces.Connectors.FuelInlet Cfuel "Fuel inlet"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}},
          rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet Cair(redeclare package Medium = Medium_FlueGases) "Air inlet"
                                                           annotation (
      Placement(transformation(extent={{-10,-100},{10,-80}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet Cfg(redeclare package Medium = Medium_FlueGases) "Flue gases outlet"
                                                           annotation (
      Placement(transformation(extent={{-10,80},{10,100}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet Cws1(redeclare package Medium = Medium) "Water inlet"
                                                           annotation (
      Placement(transformation(extent={{-100,-10},{-80,10}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet Cws2(redeclare package Medium = Medium)
    "Water/steam outlet"                                    annotation (
      Placement(transformation(extent={{80,-10},{100,10}}, rotation=0)));
equation

  assert(Medium_FlueGases.nX > 1, "InternalCombustionEngine: Medium_FlueGases must be a gas mixture");
  assert(iN2 > 0 and iO2 > 0 and iH2O > 0 and iCO2 > 0 and iSO2 > 0, "InternalCombustionEngine: Medium_FlueGases.substanceNames must contain nitrogen, oxygen, water, carbon dioxide and sulfur dioxide");

  // ----------------
  // Water/steam side

  Cws1.Q = Cws2.Q;

  Cws1.h_vol_1 = Cws2.h_vol_1;
  Cws1.h_vol_2 = Cws2.h_vol_2;

  Cws2.diff_on_1 = if (gamma_diff_ws > 0) then Cws1.diff_on_1 else false;
  Cws1.diff_on_2 = if (gamma_diff_ws > 0) then Cws2.diff_on_2 else false;

  Cws2.diff_res_1 = Cws1.diff_res_1 + (if (gamma_diff_ws > 0) then 1/gamma_diff_ws else 0);
  Cws1.diff_res_2 = Cws2.diff_res_2 + (if (gamma_diff_ws > 0) then 1/gamma_diff_ws else 0);

  Cws1.Xi = Cws2.Xi;
  Cws1.SubC = Cws2.SubC;
  Xws = Cws1.Xi;
  SubCws = Cws1.SubC;

  Qe = Cws1.Q;
  Hev = Cws1.h;
  Hsv = Cws2.h;

  // ---------------
  // Combustion side

  /* Fuel inlet */
  Qcomb = Cfuel.Q;
  Tcomb = Cfuel.T;
  XCcomb = Cfuel.Xc;
  XHcomb = Cfuel.Xh;
  XOcomb = Cfuel.Xo;
  XScomb = Cfuel.Xs;
  XEAUcomb = Cfuel.hum;
  XCDcomb = Cfuel.Xashes;
  PCIcomb = Cfuel.LHV;
  Cpcomb = Cfuel.cp;

  /* Air inlet */
  Qea = Cair.Q;
  Pea = Cair.P;
  Hea = Cair.h; /***/

  Xea[1:Medium_FlueGases.nXi] = Cair.Xi;
  if Medium_FlueGases.nXi < Medium_FlueGases.nX then
    Xea[Medium_FlueGases.nX] = 1 - sum(Cair.Xi);
  end if;
  XeaCO2 = Xea[iCO2];
  XeaH2O = Xea[iH2O];
  XeaO2 = Xea[iO2];
  XeaSO2 = Xea[iSO2];

  /* Flue gases outlet */
  Qsf = Cfg.Q;
  Psf = Cfg.P;
  Hsf = Cfg.h;

  /* Mass balance equation for the flue gases */
  0 = Qcomb + Qea - Qsf;

  /* Energy balance equation for the flue gases */
  0 = Qcomb*(Hcomb - Hrcomb + PCIcomb) + Qea*(Hea - Hrair) - Qsf*(Hsf - Hrfum) - Wpth_ref - Wmeca + J;

  Hcomb = Cpcomb*(Tcomb - 273.15);

  Cair.h_vol_2 = h;
  Cfg.h_vol_1 = h;

  /* Thermal losses */
  Wpth_ref = Qcomb*PCIcomb*(Xpth + Xref);
  Qe*(Hsv - Hev) = Qcomb*PCIcomb*Xref;

  /* Fuel thermal power available */
  PCScomb = PCIcomb + 224.3e5*XHcomb + 25.1e5*XEAUcomb;
  Wcomb = Qcomb*PCIcomb;

  /* Flue gases composition balance equations */
  0 = Qcomb*XCcomb*amCO2/amC + Qea*XeaCO2 - Qsf*XsfCO2;
  0 = Qcomb*XHcomb*(amH2O/2)/amH + Qea*XeaH2O - XsfH2O*Qsf;
  0 = Qea*XeaO2 - Qcomb*amO*(2*XCcomb/amC + 0.5*XHcomb/amH + 2*XScomb/amS) + Qcomb*XOcomb - XsfO2*Qsf;
  0 = Qcomb*XScomb*amSO2/amS + Qea*XeaSO2 - XsfSO2*Qsf;

  Xsf[iN2] = 1 - XsfCO2 - XsfH2O - XsfO2 - XsfSO2;
  Xsf[iO2] = XsfO2;
  Xsf[iH2O] = XsfH2O;
  Xsf[iCO2] = XsfCO2;
  Xsf[iSO2] = XsfSO2;
  Cfg.Xi = Xsf[1:Medium_FlueGases.nXi];
  Cfg.SubC = Cair.SubC;
  SubCfg = Cfg.SubC;

  /* No flow reversal */
  Cfg.h = Cfg.h_vol_1;

  /* Diffusion power */
  if diffusion then
    rair = if Cair.diff_on_1 then exp(-0.033*(Cair.Q*Cair.diff_res_1)^2) else 0;
    rfg = if Cfg.diff_on_2 then exp(-0.033*(Cfg.Q*Cfg.diff_res_2)^2) else 0;

    gamma_air = if Cair.diff_on_1 then 1/Cair.diff_res_1 else gamma0;
    gamma_fg = if Cfg.diff_on_2 then 1/Cfg.diff_res_2 else gamma0;

    Jair = if Cair.diff_on_1 then rair*gamma_air*(Cair.h_vol_1 - Cair.h_vol_2) else 0;
    Jfg = if Cfg.diff_on_2 then rfg*gamma_fg*(Cfg.h_vol_2 - Cfg.h_vol_1) else 0;
  else
    rair = 0;
    rfg = 0;

    gamma_air = gamma0;
    gamma_fg = gamma0;

    Jair = 0;
    Jfg = 0;
  end if;

  J = Jair + Jfg;

  Cair.diff_res_2 = 0;
  Cfg.diff_res_1 = 0;

  Cair.diff_on_2 = diffusion;
  Cfg.diff_on_1 = diffusion;

  /* Air thermodynamic properties at the inlet */
  Hea = ThermoSysPro.Properties.FlueGases.FlueGases_h(Pea, Tea, XeaCO2, XeaH2O, XeaO2, XeaSO2);
  Cpair = ThermoSysPro.Properties.FlueGases.FlueGases_cp(Pea, Tea, XeaCO2, XeaH2O, XeaO2, XeaSO2);
  rhoea = ThermoSysPro.Properties.FlueGases.FlueGases_rho(Pea, Tea, XeaCO2, XeaH2O, XeaO2, XeaSO2);

  /* Flue gases thermodynamic properties at the outlet */
  Hsf = ThermoSysPro.Properties.FlueGases.FlueGases_h(Psf, Tsf, XsfCO2, XsfH2O, XsfO2, XsfSO2);
  rhosf = ThermoSysPro.Properties.FlueGases.FlueGases_rho(Psf, Tsf, XsfCO2, XsfH2O, XsfO2, XsfSO2);

  // --------------------
  //  BEAU DE ROCHAS CYCLE

  /* (1) Air and gas mixing at constant pressure Pea */
  Tm = (Qcomb*Cpcomb*Tcomb + Qea*Cpair*Tea)/(Qcomb*Cpcomb + Qea*Cpair);

  /* (2) Polytropic compression */
  Tfcp = Tm*RV^(Kc - 1);
  Pfcp = Pea*RV^Kc;

  /* (3) Constant volume combustion (point mort haut) */
  MMairgaz = (Qea*28.9 + Qcomb*MMg)/(Qea + Qcomb);
  MMfumees = (1 - XsfCO2 - XsfH2O - XsfO2 - XsfSO2)*28 + XsfCO2*44 + XsfH2O*18 + XsfO2*32 + XsfSO2*64;
  Pfcb = Pfcp*Tfcb/Tfcp*MMairgaz/MMfumees;
  //Tfcb = (Wcomb - Wpth_ref)/ThermoSysPro.Properties.FlueGases.FlueGases_cp(Pfcp, (Tfcp + Tfcb)/2, XsfCO2, XsfH2O, XsfO2, XsfSO2)/0.75/Qsf + Tfcp;
  Tfcb = Wcomb/ThermoSysPro.Properties.FlueGases.FlueGases_cp(Pfcp, (Tfcp + Tfcb)/2, XsfCO2, XsfH2O, XsfO2, XsfSO2)/Qsf + Tfcp;

  /* (4) Polytropic expansion */
  Tfd = Tfcb *(1/RV)^(Kd - 1);
  Pfd = Pfcb *(1/RV)^Kd;

  /* (5) Echappement */
  Tfe = Tfd*(Psf/Pfd)^((Gamma - 1)/Gamma);

  // --------------------

  /* Efficiency and mechanical power */
  if (mechanical_efficiency_type == 1) then
    Rmeca = Rmeca_nom;
  elseif (mechanical_efficiency_type == 2) then
    Rmeca = Coef_Rm_a * Wcomb/1000*Wcomb/1000 + Coef_Rm_b*Wcomb/1000 + Coef_Rm_c;
  else
    Rmeca = ((Qcomb*(Hcomb - Hrcomb + PCIcomb) + Qea*(Hea - Hrair))
            -(Qsf*(ThermoSysPro.Properties.FlueGases.FlueGases_h(Psf, Tfe, XsfCO2, XsfH2O, XsfO2, XsfSO2)
            -Hrfum) + Wpth_ref))/Wcomb;
  end if;

  Wmeca = Rmeca*Wcomb;

  /* Combustion air ratio */
  exc = Qea*(1 - XeaH2O)/((Qcomb*amO*(2*XCcomb/amC + 0.5*XHcomb/amH + 2*XScomb/amS - XOcomb/amO))/(XeaO2/(1 - XeaH2O)));

  /* Pressure losses */
  Pea - Psf = DPaf;
  Cws2.P = if (Qe > 0) then Cws1.P - DPe*Cws1.P/100 else Cws1.P + DPe*Cws1.P/100;

  /* Electrical power produced and active power*/
  Welec = Wmeca*Relec;
  Wact = Welec*Cosphi;

  /* Reference specific enthalpies */
  Hrair = 2501.569e3*XeaH2O;
  Hrcomb = 0;
  Hrfum = 2501.569e3*XsfH2O;

    annotation (Diagram(graphics={
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-10,-64},{4,-46},{0,-56},{18,-54},{2,-60},{22,-66},{6,-64},{
              -10,-76},{-2,-66},{-10,-64}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-46,-42},{-46,0},{-6,0},{-6,58},{0,50},{6,58},{6,0},{48,0},{
              48,-42},{-46,-42}},
          lineColor={0,0,0},
          fillColor={170,255,170},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-80,30},{-34,30},{-34,54},{38,54},{38,30},{80,30},{80,38},{
              46,38},{46,62},{-42,62},{-42,38},{-80,38},{-80,30}},
          lineColor={28,108,200},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-112,32},{-82,4}},
          lineColor={28,108,200},
          textString="Water inlet"),
        Text(
          extent={{82,34},{116,2}},
          lineColor={238,46,47},
          textString="Water outlet"),
        Text(
          extent={{14,-80},{38,-100}},
          lineColor={28,108,200},
          textString="Air inlet"),
        Text(
          extent={{14,112},{62,76}},
          lineColor={238,46,47},
          textString="Flue gases outlet"),
        Text(
          extent={{-112,-76},{-82,-104}},
          lineColor={28,108,200},
          textString="Fuel inlet")}),
                             Icon(graphics={
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-10,-64},{4,-46},{0,-56},{18,-54},{2,-60},{22,-66},{6,-64},{
              -10,-76},{-2,-66},{-10,-64}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-46,-42},{-46,0},{-6,0},{-6,58},{0,50},{6,58},{6,0},{48,0},{
              48,-42},{-46,-42}},
          lineColor={0,0,0},
          fillColor={170,255,170},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-80,30},{-34,30},{-34,54},{38,54},{38,30},{80,30},{80,38},{
              46,38},{46,62},{-42,62},{-42,38},{-80,38},{-80,30}},
          lineColor={28,108,200},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(revisions = "
Author  

Benoît Bride   

    ", info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
This component model is documented in Chapter 15 of the ThermoSysPro book.   
    "));
end InternalCombustionEngine;
