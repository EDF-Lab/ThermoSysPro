within ThermoSysPro.Fluid.Junctions;
model StaticDrum "Static drum"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;
    replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialTwoPhaseThermoSysProMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  replaceable function PhasesSeparationFunction = Medium.HomogeneousPhasesSeparation(SubC = Ce_steam.SubC) annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  parameter Real x=1 "Vapor separation efficiency at the outlet";
  parameter Boolean continuous_flow_reversal=false
    "true: continuous flow reversal - false: discontinuous flow reversal";
  parameter Boolean diffusion=false
    "true: energy balance equation with diffusion - false: energy balance equation without diffusion";

protected
  constant Units.SI.SpecificEnthalpy hr=2501569
    "Water/steam reference specific enthalpy at 0.01°C";
  parameter Units.SI.MassFlowRate gamma0=1.e-4
    "Pseudo-diffusion conductance use for continuous flow reversal (active if diffusion=false and continuous_flow_reversal = true)";

public
  Units.SI.Temperature T "Fluid temperature";
  Units.SI.AbsolutePressure P(start=10.e5) "Fluid pressure";
  Units.SI.SpecificEnthalpy hl(start=100000) "Liquid phase specific enthalpy";
  Units.SI.SpecificEnthalpy hv(start=2800000) "Gas phase specific enthalpy";
  Medium.MassFraction X[Medium.nXi] "Fluid mass fraction";
  Medium.ExtraProperty SubCl[Medium.nC](quantity=Medium.extraPropertiesNames) "Liquid phase trace substances";
  Medium.ExtraProperty SubCv[Medium.nC](quantity=Medium.extraPropertiesNames) "Vapor phase trace substances";
  Medium.ExtraProperty SubCs_sur[Medium.nC](quantity=Medium.extraPropertiesNames) "Trace substances at the steam/reheater outlet";
  Medium.C_BiPhase C_record;
  Units.SI.Power Je_steam "Thermal power diffusion from inlet e_steam";
  Units.SI.Power Je_sup "Thermal power diffusion from inlet e_sup";
  Units.SI.Power Je_eva "Thermal power diffusion from inlet e_eva";
  Units.SI.Power Je_eco "Thermal power diffusion from inlet e_eco";
  Units.SI.Power Js_eva "Thermal power diffusion from outlet s_eva";
  Units.SI.Power Js_purg "Thermal power diffusion from outlet s_purg";
  Units.SI.Power Js_sup "Thermal power diffusion from outlet s_sup";
  Units.SI.Power Js_sur "Thermal power diffusion from outlet s_sur";
  Units.SI.Power J "Total thermal power diffusion";
  Units.SI.MassFlowRate gamma_e_steam "Diffusion conductance for inlet e_steam";
  Units.SI.MassFlowRate gamma_e_sup "Diffusion conductance for inlet e_sup";
  Units.SI.MassFlowRate gamma_e_eva "Diffusion conductance for inlet e_eva";
  Units.SI.MassFlowRate gamma_e_eco "Diffusion conductance for inlet e_eco";
  Units.SI.MassFlowRate gamma_s_eva "Diffusion conductance for outlet s_eva";
  Units.SI.MassFlowRate gamma_s_purg "Diffusion conductance for outlet s_purg";
  Units.SI.MassFlowRate gamma_s_sup "Diffusion conductance for outlet s_sup";
  Units.SI.MassFlowRate gamma_s_sur "Diffusion conductance for outlet s_sur";
  Real re_steam "Value of r(Q/gamma) for inlet e_steam";
  Real re_sup "Value of r(Q/gamma) for inlet e_sup";
  Real re_eva "Value of r(Q/gamma) for inlet e_eva";
  Real re_eco "Value of r(Q/gamma) for inlet e_eco";
  Real rs_eva "Value of r(Q/gamma) for outlet s_eva";
  Real rs_purg "Value of r(Q/gamma) for outlet s_purg";
  Real rs_sup "Value of r(Q/gamma) for outlet s_sup";
  Real rs_sur "Value of r(Q/gamma) for outlet s_sur";

public
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet Ce_eva(redeclare package Medium = Medium) annotation (
      Placement(transformation(extent={{-104,-44},{-84,-24}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet Ce_eco(redeclare package Medium = Medium) annotation (
      Placement(transformation(extent={{-50,-104},{-30,-84}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet Cs_sup(redeclare package Medium = Medium) annotation (
      Placement(transformation(extent={{84,24},{104,44}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet Cs_eva(redeclare package Medium = Medium) annotation (
      Placement(transformation(extent={{30,-104},{50,-84}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet Cs_sur(redeclare package Medium = Medium) annotation (
      Placement(transformation(extent={{28,84},{48,104}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet Cs_purg(redeclare package Medium = Medium) annotation (
      Placement(transformation(extent={{84,-44},{104,-24}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet Ce_steam(redeclare package Medium = Medium) annotation (
      Placement(transformation(extent={{-48,84},{-28,104}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet Ce_sup(redeclare package Medium = Medium) annotation (
      Placement(transformation(extent={{-104,26},{-84,46}}, rotation=0)));
  Thermal.Connectors.ThermalPort Cth annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, rotation=0)));

  Medium.SaturationProperties sat;
  Medium.ThermodynamicState state_e_steam "Steam inlet state";
  Medium.ThermodynamicState state_e_sup "Extra inlet state";
  Medium.ThermodynamicState state_e_eva "Evaporator inlet state";
  Medium.ThermodynamicState state_e_eco "Economizer inlet state";
equation

  /* Unconnected connectors */
  /* Steam input */
  if (cardinality(Ce_steam) == 0) then
    Ce_steam.Q = 0;
    Ce_steam.h = 1.e5;
    Ce_steam.h_vol_1 = 1.e5;
    Ce_steam.diff_res_1 = 0;
    Ce_steam.diff_on_1 = false;
    Ce_steam.Xi = Medium.X_default[1:Medium.nXi];
    Ce_steam.SubC = Medium.C_default;
  end if;
/* Extra input */
  if (cardinality(Ce_sup) == 0) then
    Ce_sup.Q = 0;
    Ce_sup.h = 1.e5;
    Ce_sup.h_vol_1 = 1.e5;
    Ce_sup.diff_res_1 = 0;
    Ce_sup.diff_on_1 = false;
    Ce_sup.Xi = Medium.X_default[1:Medium.nXi];
    Ce_sup.SubC = Medium.C_default;
  end if;
/* Input from evaporator */
  if (cardinality(Ce_eva) == 0) then
    Ce_eva.Q = 0;
    Ce_eva.h = 1.e5;
    Ce_eva.h_vol_1 = 1.e5;
    Ce_eva.diff_res_1 = 0;
    Ce_eva.diff_on_1 = false;
    Ce_eva.Xi = Medium.X_default[1:Medium.nXi];
    Ce_eva.SubC = Medium.C_default;
  end if;
/* Input from the economizer */
  if (cardinality(Ce_eco) == 0) then
    Ce_eco.Q = 0;
    Ce_eco.h = 1.e5;
    Ce_eco.h_vol_1 = 1.e5;
    Ce_eco.diff_res_1 = 0;
    Ce_eco.diff_on_1 = false;
    Ce_eco.Xi = Medium.X_default[1:Medium.nXi];
    Ce_eco.SubC = Medium.C_default;
  end if;
/* Output to the evaporator */
  if (cardinality(Cs_eva) == 0) then
    Cs_eva.Q = 0;
    Cs_eva.h_vol_2 = 1.e5;
    Cs_eva.diff_res_2 = 0;
    Cs_eva.diff_on_2 = false;
  end if;
/* Drain outlet */
  if (cardinality(Cs_purg) == 0) then
    Cs_purg.Q = 0;
    Cs_purg.h_vol_2 = 1.e5;
    Cs_purg.diff_res_2 = 0;
    Cs_purg.diff_on_2 = false;
  end if;
/* Extra output  */
  if (cardinality(Cs_sup) == 0) then
    Cs_sup.Q = 0;
    Cs_sup.h_vol_2 = 1.e5;
    Cs_sup.diff_res_2 = 0;
    Cs_sup.diff_on_2 = false;
  end if;
/* Output to reheater */
  if (cardinality(Cs_sur) == 0) then
    Cs_sur.Q = 0;
    Cs_sur.h_vol_2 = 1.e5;
    Cs_sur.diff_res_2 = 0;
    Cs_sur.diff_on_2 = false;
  end if;
/* Mass balance equation */
  Ce_eco.Q + Ce_steam.Q + Ce_sup.Q + Ce_eva.Q - Cs_eva.Q - Cs_sur.Q - Cs_purg.Q - Cs_sup.Q = 0;
  P = Ce_steam.P;
  P = Ce_sup.P;
  P = Ce_eva.P;
  P = Ce_eco.P;
  P = Cs_eva.P;
  P = Cs_purg.P;
  P = Cs_sup.P;
  P = Cs_sur.P;
/* Energy balance equation */
  Ce_eco.Q*Ce_eco.h + Ce_steam.Q*Ce_steam.h + Ce_sup.Q*Ce_sup.h + Ce_eva.Q*Ce_eva.h - Cs_eva.Q*Cs_eva.h - Cs_sur.Q*Cs_sur.h - Cs_purg.Q*Cs_purg.h - Cs_sup.Q*Cs_sup.h + Cth.W + J = 0;
  Ce_steam.h_vol_2 = hv;
  Ce_sup.h_vol_2 = hl;
  Ce_eva.h_vol_2 = hl;
  Ce_eco.h_vol_2 = hl;
  Cs_eva.h_vol_1 = hl;
  Cs_purg.h_vol_1 = hl;
  Cs_sup.h_vol_1 = hl;
  Cs_sur.h_vol_1 = (1 - x)*hl + x*hv;

  /* Fluid composition balance equations */
  fill(0,Medium.nXi) = Ce_steam.Xi*Ce_steam.Q + Ce_sup.Xi*Ce_sup.Q + Ce_eva.Xi*Ce_eva.Q + Ce_eco.Xi*Ce_eco.Q - Cs_sur.Xi*Cs_sur.Q - Cs_sup.Xi*Cs_sup.Q - Cs_purg.Xi*Cs_purg.Q - Cs_eva.Xi*Cs_eva.Q;

  X = Cs_eva.Xi;
  X = Cs_purg.Xi;
  X = Cs_sup.Xi;
  X = Cs_sur.Xi;

  /* Traces composition balance equations */
  C_record = PhasesSeparationFunction();

  fill(0, Medium.nC) = (1 - Medium.vapourQuality(state_e_steam))*Ce_steam.Q*Ce_steam.SubC + (1 - Medium.vapourQuality(state_e_sup))*Ce_sup.Q*Ce_sup.SubC + (1 - Medium.vapourQuality(state_e_eva))*Ce_eva.Q*Ce_eva.SubC + (1 - Medium.vapourQuality(state_e_eco))*Ce_eco.Q*Ce_eco.SubC - Cs_eva.Q*Cs_eva.SubC - Cs_purg.Q*Cs_purg.SubC - Cs_sup.Q*Cs_sup.SubC + Medium.vapourQuality(state_e_steam)*Ce_steam.Q*C_record.Cl + Medium.vapourQuality(state_e_sup)*Ce_sup.Q*C_record.Cl + Medium.vapourQuality(state_e_eva)*Ce_eva.Q*C_record.Cl + Medium.vapourQuality(state_e_eco)*Ce_eco.Q*C_record.Cl - (1 - x)*Cs_sur.Q*SubCl;

  fill(0, Medium.nC) = Medium.vapourQuality(state_e_steam)*Ce_steam.Q*C_record.Cg + Medium.vapourQuality(state_e_sup)*Ce_sup.Q*C_record.Cg + Medium.vapourQuality(state_e_eva)*Ce_eva.Q*C_record.Cg + Medium.vapourQuality(state_e_eco)*Ce_eco.Q*C_record.Cg - x*Cs_sur.Q*SubCv;

  SubCs_sur = (1 - x)*SubCl + x*SubCv;

  Cs_eva.SubC = SubCl;
  Cs_purg.SubC = SubCl;
  Cs_sup.SubC = SubCl;
  Cs_sur.SubC = SubCs_sur;

  /* Flow reversal */
  if continuous_flow_reversal then
    Cs_eva.h = ThermoSysPro.Functions.SmoothCond(Cs_eva.Q/gamma_s_eva, Cs_eva.h_vol_1, Cs_eva.h_vol_2, 1);
    Cs_purg.h = ThermoSysPro.Functions.SmoothCond(Cs_purg.Q/gamma_s_purg, Cs_purg.h_vol_1, Cs_purg.h_vol_2, 1);
    Cs_sup.h = ThermoSysPro.Functions.SmoothCond(Cs_sup.Q/gamma_s_sup, Cs_sup.h_vol_1, Cs_sup.h_vol_2, 1);
    Cs_sur.h = ThermoSysPro.Functions.SmoothCond(Cs_sur.Q/gamma_s_sur, Cs_sur.h_vol_1, Cs_sur.h_vol_2, 1);
  else
    Cs_eva.h = if (Cs_eva.Q > 0) then Cs_eva.h_vol_1 else Cs_eva.h_vol_2;
    Cs_purg.h = if (Cs_purg.Q > 0) then Cs_purg.h_vol_1 else Cs_purg.h_vol_2;
    Cs_sup.h = if (Cs_sup.Q > 0) then Cs_sup.h_vol_1 else Cs_sup.h_vol_2;
    Cs_sur.h = if (Cs_sur.Q > 0) then Cs_sur.h_vol_1 else Cs_sur.h_vol_2;
  end if;
/* Diffusion power */
  if diffusion then
    re_steam = if Ce_steam.diff_on_1 then exp(-0.033*(Ce_steam.Q*Ce_steam.diff_res_1)^2) else 0;
    re_sup = if Ce_sup.diff_on_1 then exp(-0.033*(Ce_sup.Q*Ce_sup.diff_res_1)^2) else 0;
    re_eva = if Ce_eva.diff_on_1 then exp(-0.033*(Ce_eva.Q*Ce_eva.diff_res_1)^2) else 0;
    re_eco = if Ce_eco.diff_on_1 then exp(-0.033*(Ce_eco.Q*Ce_eco.diff_res_1)^2) else 0;
    rs_eva = if Cs_eva.diff_on_2 then exp(-0.033*(Cs_eva.Q*Cs_eva.diff_res_2)^2) else 0;
    rs_purg = if Cs_purg.diff_on_2 then exp(-0.033*(Cs_purg.Q*Cs_purg.diff_res_2)^2) else 0;
    rs_sup = if Cs_sup.diff_on_2 then exp(-0.033*(Cs_sup.Q*Cs_sup.diff_res_2)^2) else 0;
    rs_sur = if Cs_sur.diff_on_2 then exp(-0.033*(Cs_sur.Q*Cs_sur.diff_res_2)^2) else 0;
    gamma_e_steam = if Ce_steam.diff_on_1 then 1/Ce_steam.diff_res_1 else gamma0;
    gamma_e_sup = if Ce_sup.diff_on_1 then 1/Ce_sup.diff_res_1 else gamma0;
    gamma_e_eva = if Ce_eva.diff_on_1 then 1/Ce_eva.diff_res_1 else gamma0;
    gamma_e_eco = if Ce_eco.diff_on_1 then 1/Ce_eco.diff_res_1 else gamma0;
    gamma_s_eva = if Cs_eva.diff_on_2 then 1/Cs_eva.diff_res_2 else gamma0;
    gamma_s_purg = if Cs_purg.diff_on_2 then 1/Cs_purg.diff_res_2 else gamma0;
    gamma_s_sup = if Cs_sup.diff_on_2 then 1/Cs_sup.diff_res_2 else gamma0;
    gamma_s_sur = if Cs_sur.diff_on_2 then 1/Cs_sur.diff_res_2 else gamma0;
    Je_steam = if Ce_steam.diff_on_1 then re_steam*gamma_e_steam*(Ce_steam.h_vol_1 - Ce_steam.h_vol_2) else 0;
    Je_sup = if Ce_sup.diff_on_1 then re_sup*gamma_e_sup*(Ce_sup.h_vol_1 - Ce_sup.h_vol_2) else 0;
    Je_eva = if Ce_eva.diff_on_1 then re_eva*gamma_e_eva*(Ce_eva.h_vol_1 - Ce_eva.h_vol_2) else 0;
    Je_eco = if Ce_eco.diff_on_1 then re_eco*gamma_e_eco*(Ce_eco.h_vol_1 - Ce_eco.h_vol_2) else 0;
    Js_eva = if Cs_eva.diff_on_2 then rs_eva*gamma_s_eva*(Cs_eva.h_vol_2 - Cs_eva.h_vol_1) else 0;
    Js_purg = if Cs_purg.diff_on_2 then rs_purg*gamma_s_purg*(Cs_purg.h_vol_2 - Cs_purg.h_vol_1) else 0;
    Js_sup = if Cs_sup.diff_on_2 then rs_sup*gamma_s_sup*(Cs_sup.h_vol_2 - Cs_sup.h_vol_1) else 0;
    Js_sur = if Cs_sur.diff_on_2 then rs_sur*gamma_s_sur*(Cs_sur.h_vol_2 - Cs_sur.h_vol_1) else 0;
  else
    re_steam = 0;
    re_sup = 0;
    re_eva = 0;
    re_eco = 0;
    rs_eva = 0;
    rs_purg = 0;
    rs_sup = 0;
    rs_sur = 0;
    gamma_e_steam = gamma0;
    gamma_e_sup = gamma0;
    gamma_e_eva = gamma0;
    gamma_e_eco = gamma0;
    gamma_s_eva = gamma0;
    gamma_s_purg = gamma0;
    gamma_s_sup = gamma0;
    gamma_s_sur = gamma0;
    Je_steam = 0;
    Je_sup = 0;
    Je_eva = 0;
    Je_eco = 0;
    Js_eva = 0;
    Js_purg = 0;
    Js_sup = 0;
    Js_sur = 0;
  end if;
  J = Je_steam + Je_sup + Je_eva + Je_eco + Js_eva + Js_purg + Js_sup + Js_sur;
  Ce_steam.diff_res_2 = 0;
  Ce_sup.diff_res_2 = 0;
  Ce_eva.diff_res_2 = 0;
  Ce_eco.diff_res_2 = 0;
  Cs_eva.diff_res_1 = 0;
  Cs_purg.diff_res_1 = 0;
  Cs_sup.diff_res_1 = 0;
  Cs_sur.diff_res_1 = 0;
  Ce_steam.diff_on_2 = diffusion;
  Ce_sup.diff_on_2 = diffusion;
  Ce_eva.diff_on_2 = diffusion;
  Ce_eco.diff_on_2 = diffusion;
  Cs_eva.diff_on_1 = diffusion;
  Cs_purg.diff_on_1 = diffusion;
  Cs_sup.diff_on_1 = diffusion;
  Cs_sur.diff_on_1 = diffusion;

  /* Fluid thermodynamic properties */
  state_e_steam = Medium.setState_phX(p=P, h=Ce_steam.h, X=Medium.reference_X);
  state_e_sup = Medium.setState_phX(p=P, h=Ce_sup.h, X=Medium.reference_X);
  state_e_eva = Medium.setState_phX(p=P, h=Ce_eva.h, X=Medium.reference_X);
  state_e_eco = Medium.setState_phX(p=P, h=Ce_eco.h, X=Medium.reference_X);
  sat = Medium.setSat_p(P);

  hl = Medium.bubbleEnthalpy(sat);
  hv = Medium.dewEnthalpy(sat);
  T = sat.Tsat;

  Cth.T = T;
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}, grid = {2, 2}), graphics = {Line(points = {{0, 90}, {0, -100}}), Ellipse(extent = {{-98, 96}, {98, -96}}, lineColor = {28, 108, 200}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid), Line(points = {{-86, -44}, {86, -44}}, color = {28, 108, 200}, pattern = LinePattern.Dash), Line(points = {{-44, -86}, {44, -86}}, color = {28, 108, 200}, pattern = LinePattern.Dash), Line(points = {{-64, -72}, {64, -72}}, color = {28, 108, 200}, pattern = LinePattern.Dash), Line(points = {{-78, -58}, {76, -58}}, color = {28, 108, 200}, pattern = LinePattern.Dash), Text(extent = {{-56, 94}, {-56, 92}}, textString = "Esteam")}),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}, grid = {2, 2}), graphics = {Line(points = {{0, 90}, {0, -100}}), Ellipse(extent = {{-98, 96}, {98, -96}}, lineColor = {0, 0, 0}, fillColor = DynamicSelect({255, 255, 0}, if diffusion then fill_color_singular else fill_color_static), fillPattern = FillPattern.Solid), Line(points = {{-86, -44}, {86, -44}}, color = {28, 108, 200}, pattern = LinePattern.Dash), Line(points = {{-44, -86}, {44, -86}}, color = {28, 108, 200}, pattern = LinePattern.Dash), Line(points = {{-64, -72}, {64, -72}}, color = {28, 108, 200}, pattern = LinePattern.Dash), Line(points = {{-78, -58}, {76, -58}}, color = {28, 108, 200}, pattern = LinePattern.Dash)}),
    Window(x = 0.33, y = 0.08, width = 0.66, height = 0.69),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
This component model is documented in Sect. 14.6 of the ThermoSysPro book.   
    ", revisions = "
Authors  

Baligh El Hefni  
Daniel Bouskela   

    "));
end StaticDrum;