within ThermoSysPro.Fluid.Junctions;

model SteamDryer "Steam dryer"

  extends ThermoSysPro.Fluid.Interfaces.IconColors;
  import ThermoSysPro.Fluid.Interfaces.PropertyInterfaces.IF97Region;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialTwoPhaseThermoSysProMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  replaceable function SaS = Medium.noSaS(SubC = Cev.SubC) annotation (choicesAllMatching=true,Dialog(tab="Fluid", group="Medium"));
  replaceable function PhasesSeparationFunction = Medium.HomogeneousPhasesSeparation(SubC = Cev.SubC) annotation (choicesAllMatching=true,Dialog(tab="Fluid", group="Medium"));
  parameter Real eta=1 "Steam dryer efficiency (0 <= eta <= 1)";
  parameter Boolean continuous_flow_reversal=false
    "true: continuous flow reversal - false: discontinuous flow reversal";
  parameter Boolean diffusion=false
    "true: energy balance equation with diffusion - false: energy balance equation without diffusion";
  parameter IF97Region region_e=IF97Region.All_regions "IF97 region at the inlet (active for IF97 water/steam only)" annotation(Evaluate=true, Dialog(tab="Fluid", group="Fluid properties"));

protected
  parameter Units.SI.MassFlowRate gamma0=1.e-4
    "Pseudo-diffusion conductance use for continuous flow reversal (active if diffusion=false and continuous_flow_reversal = true)";
  parameter Integer mode_e=Integer(region_e) - 1 "IF97 region at the inlet. 1:liquid - 2:steam - 4:saturation line - 0:automatic";
  Medium.C_BiPhase C_record;

public
  Units.SI.AbsolutePressure P(start=10e5) "Fluid pressure";
  Units.SI.SpecificEnthalpy h(start=10e5) "Fluid specific enthalpy";
  Units.SI.Density rho(start=1.0) "Fluid density at inlet";
  Real xe(start=1.0) "Vapor mass fraction at the inlet";
  Medium.MassFraction X[Medium.nXi](start=Medium.X_default[1:Medium.nXi]) "Fluid mass fraction";
  Medium.ExtraProperty SubCSaS[Medium.nC](quantity=Medium.extraPropertiesNames) "Trace modification in the trace balance equation";
  Units.SI.Power Jev "Thermal power diffusion from inlet ev";
  Units.SI.Power Jsv "Thermal power diffusion from outlet sv";
  Units.SI.Power Jsl "Thermal power diffusion from outlet sl";
  Units.SI.Power J "Total thermal power diffusion";
  Units.SI.MassFlowRate gamma_ev "Diffusion conductance for inlet ev";
  Units.SI.MassFlowRate gamma_sv "Diffusion conductance for outlet sv";
  Units.SI.MassFlowRate gamma_sl "Diffusion conductance for outlet sl";
  Real rev "Value of r(Q/gamma) for inlet ev";
  Real rsv "Value of r(Q/gamma) for outlet sv";
  Real rsl "Value of r(Q/gamma) for outlet sl";

public
  Medium.SaturationProperties sat;
  Medium.ThermodynamicState state_e;
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet Cev(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{-109,30},{-89,50}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet Csv(redeclare package Medium = Medium) annotation (
      Placement(transformation(extent={{89,30},{109,50}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet Csl(redeclare package Medium = Medium) annotation (
      Placement(transformation(extent={{-9,-110},{11,-90}}, rotation=0)));

equation

  /* Check that eta is between 0 and 1 */
  assert((eta >= 0) and (eta <= 1), "SteamDryer - Parameter eta should be >= 0 and <= 1");
/* Mass flow at the vapor outlet */
  Csv.Q = noEvent(if (xe > 0) then Cev.Q*(1 - eta*(1 - xe)) else 0);
/* Mass balance equation */
  0 = Cev.Q - Csv.Q - Csl.Q;
  P = Cev.P;
  P = Csv.P;
  P = Csl.P;
/* Energy balance equation */
  0 = Cev.Q*Cev.h - Csv.Q*Csv.h - Csl.Q*Csl.h + J;
  Cev.h_vol_2 = h;
  Csv.h_vol_1 = h;
  Csl.h_vol_1 = noEvent(if (xe > 0) then Medium.bubbleEnthalpy(sat) else Cev.h);

  /* Fluid composition balance equations*/
  Cev.Xi*Cev.Q =  Csv.Xi*Csv.Q + Csl.Xi*Csl.Q;

  Csv.Xi = X;
  Csl.Xi = X;

  /* Traces composition balance equations */
  C_record = PhasesSeparationFunction();
  Csv.SubC = C_record.Cg;

  Csv.Q*Csv.SubC + Csl.Q*Csl.SubC = Cev.Q*Cev.SubC + SubCSaS * Cev.Q;

  SubCSaS = SaS();

  /* Flow reversal */
  if continuous_flow_reversal then
    Csv.h = ThermoSysPro.Functions.SmoothCond(Csv.Q/gamma_sv, Csv.h_vol_1, Csv.h_vol_2, 1);
    Csl.h = ThermoSysPro.Functions.SmoothCond(Csl.Q/gamma_sl, Csl.h_vol_1, Csl.h_vol_2, 1);
  else
    Csv.h = if (Csv.Q > 0) then Csv.h_vol_1 else Csv.h_vol_2;
    Csl.h = if (Csl.Q > 0) then Csl.h_vol_1 else Csl.h_vol_2;
  end if;
/* Diffusion power */
  if diffusion then
    rev = if Cev.diff_on_1 then exp(-0.033*(Cev.Q*Cev.diff_res_1)^2) else 0;
    rsv = if Csv.diff_on_2 then exp(-0.033*(Csv.Q*Csv.diff_res_2)^2) else 0;
    rsl = if Csl.diff_on_2 then exp(-0.033*(Csl.Q*Csl.diff_res_2)^2) else 0;
    gamma_ev = if Cev.diff_on_1 then 1/Cev.diff_res_1 else gamma0;
    gamma_sv = if Csv.diff_on_2 then 1/Csv.diff_res_2 else gamma0;
    gamma_sl = if Csl.diff_on_2 then 1/Csl.diff_res_2 else gamma0;
    Jev = if Cev.diff_on_1 then rev*gamma_ev*(Cev.h_vol_1 - Cev.h_vol_2) else 0;
    Jsl = if Csl.diff_on_2 then rsl*gamma_sl*(Csl.h_vol_2 - Csl.h_vol_1) else 0;
    Jsv = if Csv.diff_on_2 then rsv*gamma_sv*(Csv.h_vol_2 - Csv.h_vol_1) else 0;
  else
    rev = 0;
    rsv = 0;
    rsl = 0;
    gamma_ev = gamma0;
    gamma_sv = gamma0;
    gamma_sl = gamma0;
    Jev = 0;
    Jsv = 0;
    Jsl = 0;
  end if;
  J = Jev + Jsv + Jsl;
  Cev.diff_res_2 = 0;
  Csv.diff_res_1 = 0;
  Csl.diff_res_1 = 0;
  Cev.diff_on_2 = diffusion;
  Csv.diff_on_1 = diffusion;
  Csl.diff_on_1 = diffusion;

  /* Fluid thermodynamic properties */
  state_e=Medium.setState_phX(p=Cev.P, h=Cev.h, X=Cev.Xi, region=mode_e);
  rho = state_e.d;

  /* Vapor mass fraction at the inlet */
  xe=Medium.vapourQuality(state_e);

  /* Fluid thermodynamic properties at the saturation point */
  sat = Medium.setSat_p(Cev.P);

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={Polygon(
          points={{-98,40},{-18,-100},{22,-100},{102,40},{-98,40}},
          lineColor={28,108,200},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid)}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={Polygon(
          points={{-100,40},{-20,-100},{20,-100},{100,40},{-100,40}},
          lineColor={0,0,0},
          fillColor= DynamicSelect({255,255,0},
          if diffusion then fill_color_singular
          else fill_color_static),
          fillPattern=FillPattern.Solid)}),
    Window(
      x=0.17,
      y=0.1,
      width=0.76,
      height=0.76),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
This component model is documented in Sect. 14.9 of the ThermoSysPro book.   
    ", revisions = "
Authors  

Baligh El Hefni  
Daniel Bouskela   

    "));
end SteamDryer;
