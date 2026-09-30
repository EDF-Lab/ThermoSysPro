within ThermoSysPro.Fluid.Junctions;

model MassFlowMultiplier "Mass flow multipliier"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;
  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  parameter Real alpha=2 "Flow multiplier";
  parameter Boolean continuous_flow_reversal=false
    "true: continuous flow reversal - false: discontinuous flow reversal";
  parameter Boolean diffusion=false
    "true: energy balance equation with diffusion - false: energy balance equation without diffusion";
  parameter Units.SI.Density p_rho=0 "If > 0, fixed fluid density"
    annotation (Evaluate=true, Dialog(tab="Fluid", group="Fluid properties"));

protected
  parameter Units.SI.MassFlowRate gamma0=1.e-4
    "Pseudo-diffusion conductance use for continuous flow reversal (active if diffusion=false and continuous_flow_reversal = true)";

public
  Units.SI.AbsolutePressure P(start=10e5) "Fluid pressure";
  Units.SI.SpecificEnthalpy h(start=10e5) "Fluid specific enthalpy";
  Units.SI.Temperature T "Fluid temperature";
  Units.SI.Density rho(start=998) "Fluid density";
  Units.SI.Power Je "Thermal power diffusion from inlet e";
  Units.SI.Power Js "Thermal power diffusion from outlet s";
  Units.SI.Power J "Total thermal power diffusion";
  Units.SI.MassFlowRate gamma_e "Diffusion conductance for inlet e";
  Units.SI.MassFlowRate gamma_s "Diffusion conductance for outlet s";
  Real re "Value of r(Q/gamma) for inlet e";
  Real rs "Value of r(Q/gamma) for outlet s";

public
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet Ce(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet Cs(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{90,-10},{110,10}}, rotation=0)));
equation

  /* Mass balance equation */
  0 = alpha*Ce.Q - Cs.Q;
  P = Ce.P;
  P = Cs.P;
/* Energy balance equation */
  0 = alpha*Ce.Q*Ce.h - Cs.Q*Cs.h + J;
  Ce.h_vol_2 = h;
  Cs.h_vol_1 = h;

  /* Fluid composition */
  Ce.Xi*alpha*Ce.Q = Cs.Xi*Cs.Q;

  Ce.SubC*alpha*Ce.Q = Cs.SubC*Cs.Q;

  /* Flow reversal */
  if continuous_flow_reversal then
    Cs.h = ThermoSysPro.Functions.SmoothCond(Cs.Q/gamma_s, Cs.h_vol_1, Cs.h_vol_2, 1);
  else
    Cs.h = if (Cs.Q > 0) then Cs.h_vol_1 else Cs.h_vol_2;
  end if;
/* Diffusion power */
  if diffusion then
    re = if Ce.diff_on_1 then exp(-0.033*(Ce.Q*Ce.diff_res_1)^2) else 0;
    rs = if Cs.diff_on_2 then exp(-0.033*(Cs.Q*Cs.diff_res_2)^2) else 0;
    gamma_e = if Ce.diff_on_1 then 1/Ce.diff_res_1 else gamma0;
    gamma_s = if Cs.diff_on_2 then 1/Cs.diff_res_2 else gamma0;
    Je = if Ce.diff_on_1 then re*gamma_e*(Ce.h_vol_1 - Ce.h_vol_2) else 0;
    Js = if Cs.diff_on_2 then rs*gamma_s*(Cs.h_vol_2 - Cs.h_vol_1) else 0;
  else
    re = 0;
    rs = 0;
    gamma_e = gamma0;
    gamma_s = gamma0;
    Je = 0;
    Js = 0;
  end if;
  J = Je + Js;
  Ce.diff_res_2 = 0;
  Cs.diff_res_1 = 0;
  Ce.diff_on_2 = diffusion;
  Cs.diff_on_1 = diffusion;

 /* Fluid thermodynamic properties */
  T = Medium.temperature_phX(P, h, Cs.Xi);

  if (p_rho > 0) then
    rho = p_rho;
  else
    rho = Medium.density_phX(P,h,Cs.Xi);
  end if;
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}, grid = {2, 2}), graphics = {Polygon(points = {{-100, 60}, {-100, -60}, {90, 0}, {-100, 60}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.VerticalCylinder, fillColor = {255, 255, 0}), Text(extent = {{-60, 24}, {-20, -16}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, textString = "%alpha")}),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}, grid = {2, 2}), graphics = {Polygon(points = {{-100, 60}, {-100, -60}, {90, 0}, {-100, 60}}, lineColor = {0, 0, 0}, fillColor = DynamicSelect({255, 255, 0}, if diffusion then fill_color_singular else fill_color_static), fillPattern = FillPattern.Solid), Text(extent = {{-60, 24}, {-20, -16}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, textString = "%alpha")}),
    Window(x = 0.33, y = 0.09, width = 0.71, height = 0.88),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
    ", revisions = "
Authors  

Baligh El Hefni  
Daniel Bouskela   

    "));
end MassFlowMultiplier;