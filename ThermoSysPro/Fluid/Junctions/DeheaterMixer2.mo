within ThermoSysPro.Fluid.Junctions;

model DeheaterMixer2
  extends ThermoSysPro.Fluid.Interfaces.IconColors;
  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  parameter Units.SI.Temperature Tmax=700 "Maximum fluid temperature";
  parameter Boolean continuous_flow_reversal=false
    "true: continuous flow reversal - false: discontinuous flow reversal";
  parameter Boolean diffusion=false
    "true: energy balance equation with diffusion - false: energy balance equation without diffusion";

protected
  parameter Units.SI.MassFlowRate gamma0=1.e-4
    "Pseudo-diffusion conductance use for continuous flow reversal (active if diffusion=false and continuous_flow_reversal = true)";

public
  Units.SI.AbsolutePressure P(start=50e5) "Fluid pressure";
  Units.SI.SpecificEnthalpy h(start=10e5) "Fluid specific enthalpy";
  Units.SI.Temperature T(start=700) "Fluid temperature";
  Units.SI.SpecificEnthalpy hmax(start=10e5) "Maximum fluid specific enthalpy";
  Units.SI.Power Je "Thermal power diffusion from inlet e";
  Units.SI.Power Je_mix "Thermal power diffusion from inlet e_mix";
  Units.SI.Power Js "Thermal power diffusion from outlet s";
  Units.SI.Power J "Total thermal power diffusion";
  Units.SI.MassFlowRate gamma_e "Diffusion conductance for inlet e";
  Units.SI.MassFlowRate gamma_e_mix "Diffusion conductance for inlet e_mix";
  Units.SI.MassFlowRate gamma_s "Diffusion conductance for outlet s";
  Real re "Value of r(Q/gamma) for inlet e";
  Real re_mix "Value of r(Q/gamma) for inlet e_mix";
  Real rs "Value of r(Q/gamma) for outlet s";

public
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet Ce_mix(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-9,-110},{11,-90}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet Cs(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{90,50},{110,70}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet Ce(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-110,50},{-90,70}}, rotation=0)));
equation

  /* Mass balance equation */
  0 = Ce.Q + Ce_mix.Q - Cs.Q;
  P = Ce.P;
  P = Ce_mix.P;
  P = Cs.P;
/* Energy balance equation */
  0 = Ce.Q*Ce.h + Ce_mix.Q*Ce_mix.h - Cs.Q*Cs.h + J;
  Ce.h_vol_2 = h;
  Ce_mix.h_vol_2 = h;
  Cs.h_vol_1 = h;
/* The flow at the mixing inlet is such as to ensure T <= Tmax */
  if T <= Tmax then
    Ce_mix.Q = 0;
  else
    h = hmax;
  end if;

  /* Fluid composition balance equations */
  Cs.Xi*Cs.Q = Ce.Xi*Ce.Q + Ce_mix.Xi*Ce_mix.Q;

  /* Traces composition balance equations */
  Cs.SubC*Cs.Q = Ce.SubC*Ce.Q + Ce_mix.SubC*Ce_mix.Q;

  /* Flow reversal */
  if continuous_flow_reversal then
    Cs.h = ThermoSysPro.Functions.SmoothCond(Cs.Q/gamma_s, Cs.h_vol_1, Cs.h_vol_2, 1);
  else
    Cs.h = if (Cs.Q > 0) then Cs.h_vol_1 else Cs.h_vol_2;
  end if;
/* Diffusion power */
  if diffusion then
    re = if Ce.diff_on_1 then exp(-0.033*(Ce.Q*Ce.diff_res_1)^2) else 0;
    re_mix = if Ce_mix.diff_on_1 then exp(-0.033*(Ce_mix.Q*Ce_mix.diff_res_1)^2) else 0;
    rs = if Cs.diff_on_2 then exp(-0.033*(Cs.Q*Cs.diff_res_2)^2) else 0;
    gamma_e = if Ce.diff_on_1 then 1/Ce.diff_res_1 else gamma0;
    gamma_e_mix = if Ce_mix.diff_on_1 then 1/Ce_mix.diff_res_1 else gamma0;
    gamma_s = if Cs.diff_on_2 then 1/Cs.diff_res_2 else gamma0;
    Je = if Ce.diff_on_1 then re*gamma_e*(Ce.h_vol_1 - Ce.h_vol_2) else 0;
    Je_mix = if Ce_mix.diff_on_1 then re_mix*gamma_e_mix*(Ce_mix.h_vol_1 - Ce_mix.h_vol_2) else 0;
    Js = if Cs.diff_on_2 then rs*gamma_s*(Cs.h_vol_2 - Cs.h_vol_1) else 0;
  else
    re = 0;
    re_mix = 0;
    rs = 0;
    gamma_e = gamma0;
    gamma_e_mix = gamma0;
    gamma_s = gamma0;
    Je = 0;
    Je_mix = 0;
    Js = 0;
  end if;
  J = Je + Je_mix + Js;
  Ce.diff_res_2 = 0;
  Ce_mix.diff_res_2 = 0;
  Cs.diff_res_1 = 0;
  Ce.diff_on_2 = diffusion;
  Ce_mix.diff_on_2 = diffusion;
  Cs.diff_on_1 = diffusion;

  /* Fluid thermodynamic properties */
  T = Medium.temperature_phX(P, h, Cs.Xi);

  hmax = Medium.specificEnthalpy_pTX(P, Tmax, Cs.Xi);

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={Polygon(
          points={{-100,80},{-100,40},{-20,40},{-20,-100},{20,-100},{20,40},{
              100,40},{100,80},{-100,80}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid), Text(
          extent={{-16,72},{16,46}},
          lineColor={0,0,255},
          textString=
               "D")}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={Polygon(
          points={{-100,80},{-100,40},{-20,40},{-20,-100},{20,-100},{20,40},{
              100,40},{100,80},{-100,80}},
          lineColor={0,0,0},
          fillColor= DynamicSelect({255,255,0},
          if diffusion then fill_color_singular
          else fill_color_static),
          fillPattern=FillPattern.Solid), Text(
          extent={{-18,78},{22,38}},
          lineColor={0,0,255},
          textString=
               "D")}),
    Window(
      x=0.33,
      y=0.09,
      width=0.71,
      height=0.88),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
    ", revisions = "
Authors  

Baligh El Hefni  
Daniel Bouskela   

    "));
end DeheaterMixer2;
