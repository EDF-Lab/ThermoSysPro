within ThermoSysPro.Fluid.Volumes;
model VolumeB "Mixing volume with 2 inlets and 2 outlets"

  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  replaceable function SaS = Medium.noSaS(SubC=SubC) annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));

  parameter Boolean dynamic_energy_balance=true
    "true: dynamic energy balance equation - false: static energy balance equation";
  parameter Units.SI.Volume V=1
    "Volume (active if dynamic_energy_balance=true)"
    annotation (Evaluate=true, Dialog(enable=dynamic_energy_balance));
  parameter Boolean dynamic_mass_balance=false
    "true: dynamic mass balance equation - false: static mass balance equation (active if the fluid is compressible and if dynamic_energy_balance=true)" annotation(Evaluate=true, Dialog(enable=isCompressible and dynamic_energy_balance));
  parameter Boolean steady_state=true
    "true: start from steady state - false: start from (P0, h0) (active if dynamic_energy_balance=true)" annotation(Evaluate=true, Dialog(enable=dynamic_energy_balance));
  parameter Units.SI.AbsolutePressure P0=1e5
    "Initial fluid pressure (active if the fluid is compressible, and if dynamic_energy_balance=true and dynamic_mass_balance=true and steady_state=false)"
    annotation (Evaluate=true, Dialog(enable=isCompressible and
          dynamic_energy_balance and dynamic_mass_balance and not steady_state));
  parameter Units.SI.SpecificEnthalpy h0=1e5
    "Initial fluid specific enthalpy (active if dynamic_energy_balance=true and steady_state=false)"
    annotation (Evaluate=true, Dialog(enable=dynamic_energy_balance and not
          steady_state));
  parameter Boolean continuous_flow_reversal=false
    "true: continuous flow reversal - false: discontinuous flow reversal";
  parameter Boolean diffusion=false
    "true: energy balance equation with diffusion - false: energy balance equation without diffusion";
  parameter Units.SI.Density p_rho=0 "If > 0, fixed fluid density"
    annotation (Evaluate=true, Dialog(tab="Fluid", group="Fluid properties"));

  parameter Boolean dynamic_composition_balance=false
    "<html>true: dynamic fluid composition balance equation <br>false: static fluid composition balance equation (active for flue gases)</html>" annotation(Evaluate=true, Dialog(tab="Fluid", group="Fluid properties"));

  parameter Medium.MassFraction X0[Medium.nX]=Medium.X_default "Initial composition values" annotation (Evaluate=true, Dialog(
      enable=dynamic_composition_balance,
      tab="Fluid",
      group="Medium"));

protected
  constant Boolean isCompressible = Medium.isCompressible;
  parameter Units.SI.MassFlowRate gamma0=1.e-4
    "Pseudo-diffusion conductance use for continuous flow reversal (active if diffusion=false and continuous_flow_reversal = true)";

public
  Units.SI.Temperature T "Fluid temperature";
  Units.SI.AbsolutePressure P(start = 1.e5) "Fluid pressure";
  Units.SI.SpecificEnthalpy h(start = 100000) "Fluid specific enthalpy";
  Units.SI.Density rho(start = 998) "Fluid density";
  Units.SI.MassFlowRate BQ "Right hand side of the mass balance equation";
  Units.SI.Power BH "Right hand side of the energy balance equation";
  Units.SI.DerDensityByPressure ddph "density derivative wrt pressure at constant specific enthalpy";
  Units.SI.DerDensityByEnthalpy ddhp "density derivative wrt specific enthalpy at constant pressure";
  Units.SI.MassFlowRate BX[Medium.nXi] "Right hand side of the X balance equation";
  Medium.MassFraction X[Medium.nXi](start=Medium.X_default[1:Medium.nXi]) "Fluid mass fraction";
  Medium.ExtraProperty BSubC[Medium.nC](quantity=Medium.extraPropertiesNames) "Right hand side of the trace balance equation";
  Medium.ExtraProperty SubC[Medium.nC](quantity=Medium.extraPropertiesNames, start=Medium.C_default) "Fluid trace substances";
  Medium.ExtraProperty SubCSaS[Medium.nC](quantity=Medium.extraPropertiesNames) "Trace modification in the trace balance equation";
  Medium.ThermodynamicState state;
  Units.SI.Power Je1 "Thermal power diffusion from inlet e1";
  Units.SI.Power Je2 "Thermal power diffusion from inlet e2";
  Units.SI.Power Js1 "Thermal power diffusion from outlet s1";
  Units.SI.Power Js2 "Thermal power diffusion from outlet s2";
  Units.SI.Power J "Total thermal power diffusion";
  Units.SI.MassFlowRate gamma_e1 "Diffusion conductance for inlet e1";
  Units.SI.MassFlowRate gamma_e2 "Diffusion conductance for inlet e2";
  Units.SI.MassFlowRate gamma_s1 "Diffusion conductance for outlet s1";
  Units.SI.MassFlowRate gamma_s2 "Diffusion conductance for outlet s2";
  Real re1 "Value of r(Q/gamma) for inlet e1";
  Real re2 "Value of r(Q/gamma) for inlet e2";
  Real rs1 "Value of r(Q/gamma) for outlet s1";
  Real rs2 "Value of r(Q/gamma) for outlet s2";

public
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet Ce1( redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet Ce2( redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{90,-10},{110,10}}, rotation=0),
        iconTransformation(extent={{90,-10},{110,10}})));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet Cs1( redeclare package Medium = Medium) annotation (
      Placement(transformation(extent={{-10,90},{10,110}}, rotation=0),
        iconTransformation(extent={{-10,90},{10,110}})));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet Cs2( redeclare package Medium = Medium) annotation (
      Placement(transformation(extent={{-10,-110},{10,-90}}, rotation=0)));
initial equation
  if dynamic_energy_balance and dynamic_mass_balance then
    if steady_state then
      der(P) = 0;
    else
      P = P0;
    end if;
  end if;
  if dynamic_energy_balance then
    if steady_state then
      der(h) = 0;
    else
      h = h0;
    end if;
  end if;

  if dynamic_composition_balance then
    if steady_state then
      der(X) = fill(0,Medium.nX);
    else
      X = X0[1:Medium.nXi];
    end if;
  end if;
equation
/* Check that volume is positive */
  if dynamic_energy_balance or dynamic_mass_balance then
    assert(V > 0, "Volume non-positive");
  end if;

  /* Unconnected connectors */
  if (cardinality(Ce1) == 0) then
    Ce1.Q = 0;
    Ce1.h = 1.e5;
    Ce1.h_vol_1 = 1.e5;
    Ce1.diff_res_1 = 0;
    Ce1.diff_on_1 = false;
    Ce1.Xi = Medium.X_default[1:Medium.nXi];
    Ce1.SubC = Medium.C_default;
  end if;
  if (cardinality(Ce2) == 0) then
    Ce2.Q = 0;
    Ce2.h = 1.e5;
    Ce2.h_vol_1 = 1.e5;
    Ce2.diff_res_1 = 0;
    Ce2.diff_on_1 = false;
    Ce2.Xi = Medium.X_default[1:Medium.nXi];
    Ce2.SubC = Medium.C_default;
  end if;
  if (cardinality(Cs1) == 0) then
    Cs1.Q = 0;
    Cs1.h_vol_2 = 1.e5;
    Cs1.diff_res_2 = 0;
    Cs1.diff_on_2 = false;
  end if;
  if (cardinality(Cs2) == 0) then
    Cs2.Q = 0;
    Cs2.h_vol_2 = 1.e5;
    Cs2.diff_res_2 = 0;
    Cs2.diff_on_2 = false;
  end if;
/* Mass balance equation */
  BQ = Ce1.Q + Ce2.Q - Cs1.Q - Cs2.Q;
  if isCompressible and dynamic_energy_balance and dynamic_mass_balance then
    V*(ddph*der(P) + ddhp*der(h)) = BQ;
  else
    0 = BQ;
  end if;
  P = Ce1.P;
  P = Ce2.P;
  P = Cs1.P;
  P = Cs2.P;

  /* Energy balance equation */
  BH = Ce1.Q*Ce1.h + Ce2.Q*Ce2.h - Cs1.Q*Cs1.h - Cs2.Q*Cs2.h + J;

  if dynamic_energy_balance then
    if dynamic_mass_balance then
      V*((h*ddph - 1)*der(P) + (h*ddhp + rho)*der(h)) = BH;
    else
      V*rho*der(h) = BH;
    end if;
  else
    BH = 0;
  end if;
  Ce1.h_vol_2 = h;
  Ce2.h_vol_2 = h;
  Cs1.h_vol_1 = h;
  Cs2.h_vol_1 = h;

  /* Fluid composition balance equations */
  BX = Ce1.Xi*Ce1.Q + Ce2.Xi*Ce2.Q - Cs1.Xi*Cs1.Q - Cs2.Xi*Cs2.Q;

  if dynamic_composition_balance then
    V*rho*der(X) + X*BQ = BX;
  else
    X*BQ = BX;
  end if;

  Cs1.Xi = X;

  Cs2.Xi = X;

  /* Traces composition balance equations */
  BSubC = Ce1.Q*Ce1.SubC + Ce2.Q*Ce2.SubC - Cs1.Q*Cs1.SubC - Cs2.Q*Cs2.SubC;

  SubCSaS = SaS();
  if dynamic_mass_balance then
    V*rho*der(SubC) + SubC*BQ + V*rho*SubCSaS = BSubC;
  else
    V*rho*SubCSaS = BSubC;
  end if;

  Cs1.SubC = SubC;
  Cs2.SubC = SubC;

  /* Flow reversal */
  if continuous_flow_reversal then
    Cs1.h = ThermoSysPro.Functions.SmoothCond(Cs1.Q/gamma_s1, Cs1.h_vol_1, Cs1.h_vol_2, 1);
    Cs2.h = ThermoSysPro.Functions.SmoothCond(Cs2.Q/gamma_s2, Cs2.h_vol_1, Cs2.h_vol_2, 1);
  else
    Cs1.h = if (Cs1.Q > 0) then Cs1.h_vol_1 else Cs1.h_vol_2;
    Cs2.h = if (Cs2.Q > 0) then Cs2.h_vol_1 else Cs2.h_vol_2;
  end if;
/* Diffusion power */
  if diffusion then
    re1 = if Ce1.diff_on_1 then exp(-0.033*(Ce1.Q*Ce1.diff_res_1)^2) else 0;
    re2 = if Ce2.diff_on_1 then exp(-0.033*(Ce2.Q*Ce2.diff_res_1)^2) else 0;
    rs1 = if Cs1.diff_on_2 then exp(-0.033*(Cs1.Q*Cs1.diff_res_2)^2) else 0;
    rs2 = if Cs2.diff_on_2 then exp(-0.033*(Cs2.Q*Cs2.diff_res_2)^2) else 0;
    gamma_e1 = if Ce1.diff_on_1 then 1/Ce1.diff_res_1 else gamma0;
    gamma_e2 = if Ce2.diff_on_1 then 1/Ce2.diff_res_1 else gamma0;
    gamma_s1 = if Cs1.diff_on_2 then 1/Cs1.diff_res_2 else gamma0;
    gamma_s2 = if Cs2.diff_on_2 then 1/Cs2.diff_res_2 else gamma0;
    Je1 = if Ce1.diff_on_1 then re1*gamma_e1*(Ce1.h_vol_1 - Ce1.h_vol_2) else 0;
    Je2 = if Ce2.diff_on_1 then re2*gamma_e2*(Ce2.h_vol_1 - Ce2.h_vol_2) else 0;
    Js1 = if Cs1.diff_on_2 then rs1*gamma_s1*(Cs1.h_vol_2 - Cs1.h_vol_1) else 0;
    Js2 = if Cs2.diff_on_2 then rs2*gamma_s2*(Cs2.h_vol_2 - Cs2.h_vol_1) else 0;
  else
    re1 = 0;
    re2 = 0;
    rs1 = 0;
    rs2 = 0;
    gamma_e1 = gamma0;
    gamma_e2 = gamma0;
    gamma_s1 = gamma0;
    gamma_s2 = gamma0;
    Je1 = 0;
    Je2 = 0;
    Js1 = 0;
    Js2 = 0;
  end if;
  J = Je1 + Je2 + Js1 + Js2;
  Ce1.diff_res_2 = 0;
  Ce2.diff_res_2 = 0;
  Cs1.diff_res_1 = 0;
  Cs2.diff_res_1 = 0;
  Ce1.diff_on_2 = diffusion;
  Ce2.diff_on_2 = diffusion;
  Cs1.diff_on_1 = diffusion;
  Cs2.diff_on_1 = diffusion;
/* Fluid thermodynamic properties */
  if isCompressible and dynamic_mass_balance then
    ddph = Medium.density_derp_h(state);
    ddhp = Medium.density_derh_p(state);
  else
    ddph = 0;
    ddhp = 0;
  end if;

  state = Medium.setState_phX(p=P, h=h, X=X);

  T = Medium.temperature(state);

  if (p_rho > 0) then
    rho = p_rho;
  else
    rho = Medium.density(state);
  end if;
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}, grid = {2, 2}), graphics = {Line(points = {{-90, 0}, {90, 0}}, color = {0, 0, 255}), Line(points = {{0, 90}, {0, -100}}, color = {0, 0, 255}, thickness = 0.2), Ellipse(extent = {{-60, 60}, {60, -60}}, lineColor = {0, 0, 255}, fillPattern = FillPattern.Solid, fillColor = {85, 170, 255}, lineThickness = 0.2)}),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}, grid = {2, 2}), graphics = {Line(points = {{0, 90}, {0, -100}}, color = {28, 108, 200}, thickness = 0.2), Line(points = {{-90, 0}, {90, 0}}, color = {28, 108, 200}, thickness = 0.2), Ellipse(extent = {{-60, 60}, {60, -60}}, lineColor = {28, 108, 200}, lineThickness = 0.2, fillPattern = DynamicSelect(FillPattern.Solid, if dynamic_mass_balance and dynamic_energy_balance then FillPattern.Sphere else FillPattern.Solid), fillColor = DynamicSelect({85, 170, 255}, if dynamic_energy_balance then fill_color_dynamic else if diffusion then fill_color_singular else fill_color_static))}),
    Window(x = 0.14, y = 0.2, width = 0.66, height = 0.69),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
This component model is documented in Sect. 14.1 of the ThermoSysPro book.   
    ", revisions = "
Authors  

Daniel Bouskela  
Baligh El Hefni   

    "));
end VolumeB;