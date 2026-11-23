within ThermoSysPro.Fluid.Machines;
model CombustionTurbine "Combustion turbine"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium = ThermoSysPro.Properties.Media.FlueGases constrainedby Modelica.Media.Interfaces.PartialMixtureMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  parameter Real A3=0 "X^3 coefficient of the efficiency curve";
  parameter Real A2=-0.04778 "X^2 coefficient of the efficiency curve";
  parameter Real A1=0.09555 "X^1 coefficient of the efficiency curve";
  parameter Real A0=0.95223 "X^0 coefficient of the efficiency curve";
  parameter Real tau_n=0.07 "Nominal expansion rate";
  parameter Real is_eff_n=0.8600 "Nominal isentropic efficiency";
  parameter Real Qred=0.01 "Reduced mass flow rate";
  parameter Units.SI.MassFlowRate gamma_diff=1e-4
    "Diffusion conductance (active if diffusion=true in neighbouring volumes)";

public
  Real tau(start=0.07) "Expansion rate";
  Real is_eff(start=0.85) "Isentropic efficiency";
  Units.SI.Power Wcp(start=1e9) "Compressor power";
  Units.SI.Power Wturb(start=2e9) "Turbine power";
  Units.SI.Power Wmech(start=1e9) "Mechanical power";
  Units.SI.AbsolutePressure Pe(start=1e5) "Flue gases pressure at the inlet";
  Units.SI.AbsolutePressure Ps(start=1e5) "Flue gases pressure at the outlet";
  Real Xtau(start=1) "Ratio between the actual and nominal expansion rate";
  Units.SI.MassFlowRate Q(start=500) "Flue gases mass flow rate";
  Units.SI.Temperature Te(start=1.4e3) "Flue gases temperature at the inlet";
  Units.SI.Temperature Ts(start=900) "Flue gases temperature at the outlet";
  Units.SI.Temperature Tis(start=750)
    "Isentropic air temperature at the outlet";
  Units.SI.SpecificEnthalpy He(start=1.2e6)
    "Flue gases specific enthalpy at the inlet";
  Units.SI.SpecificEnthalpy Hs(start=6e5)
    "Flue gases specific enthalpy at the outlet";
  Units.SI.SpecificEnthalpy His(start=6e5)
    "Flue gases specific enthalpy after the isentropic expansion";
  Units.SI.SpecificEntropy Se "Flue gases specific entropy at the inlet";

public
  Interfaces.Connectors.FluidInlet Ce(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-110,-10},{-90,10}}, rotation=0)));
  Interfaces.Connectors.FluidOutlet Cs(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal CompressorPower annotation (Placement(transformation(extent={{-120,-50},{-100,-30}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal MechPower annotation (Placement(transformation(extent={{100,-100},{120,-80}}, rotation=0)));

  Medium.ThermodynamicState state_e;
equation

  Ce.Q = Cs.Q;

  Ce.h_vol_1 = Cs.h_vol_1;
  Ce.h_vol_2 = Cs.h_vol_2;

  Cs.diff_on_1 = if (gamma_diff > 0) then Ce.diff_on_1 else false;
  Ce.diff_on_2 = if (gamma_diff > 0) then Cs.diff_on_2 else false;

  Cs.diff_res_1 = Ce.diff_res_1 + (if (gamma_diff > 0) then 1/gamma_diff else 0);
  Ce.diff_res_2 = Cs.diff_res_2 + (if (gamma_diff > 0) then 1/gamma_diff else 0);

  Ce.SubC = Cs.SubC;

  Ce.Xi = Cs.Xi;

  Q = Ce.Q;

  Pe = Ce.P;
  Ps = Cs.P;

  He = Ce.h;
  Hs = Cs.h;

  /* Input compressor power (negative value) */
  Wcp = CompressorPower.signal;

  /* Expansion rate */
  tau = Ps/Pe;

  /* Expansion rates ratio */
  Xtau = tau/tau_n;

  /* Isentropic efficiency */
  is_eff = (A3*Xtau^3 + A2*Xtau^2 + A1*Xtau + A0)*is_eff_n;

  /* Reduced mass flow rate */
  Qred = (Q*sqrt(Te))/Pe;

  /* Turbine power */
  Wturb = Q*(He - Hs);

  /* Mechanical power */
  Wmech = Wturb + Wcp;
  MechPower.signal = Wmech;

  /* Temperature at the inlet */
  state_e = Medium.setState_phX(Pe,He,Ce.Xi);
  Te=Medium.temperature(state_e);

  /* Specific entropy at the inlet */
  Se = Medium.specificEntropy(state_e);

  /* Specific enthalpy after the isentropic expansion */
  Tis=Medium.temperature(Medium.setState_psX(Ps,Se,Ce.Xi));
  His = Medium.specificEnthalpy_pTX(Ps,Tis,Ce.Xi);

  /* Specific enthalpy at the outlet */
  Hs = is_eff*(His - He) +  He;

  /* Temperature at the outlet */
  Ts = Medium.temperature_phX(Ps,Hs,Ce.Xi);

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        initialScale=0.1), graphics={Polygon(
          points={{-100,40},{-100,-40},{100,-100},{100,100},{-100,40}},
          lineColor={0,0,255},
          fillColor={128,255,0},
          fillPattern=FillPattern.Backward)}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        initialScale=0.1), graphics={Polygon(
          points={{-100,40},{-100,-40},{100,-100},{100,100},{-100,40}},
          lineColor={0,0,255},
          fillColor=DynamicSelect({127,255,0}, fill_color_singular),
          fillPattern=FillPattern.Backward)}),
    Documentation(revisions = "
Author  

Baligh El Hefni   

    ", info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
This component model is documented in Sect. 11.4 of the ThermoSysPro book.   
    "));
end CombustionTurbine;
