within ThermoSysPro.Fluid.Junctions;

model Splitter2 "Splitter with two outlets"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;
 replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  parameter Boolean continuous_flow_reversal=false
    "true: continuous flow reversal - false: discontinuous flow reversal";
  parameter Boolean diffusion=false
    "true: energy balance equation with diffusion - false: energy balance equation without diffusion";

protected
  parameter Units.SI.MassFlowRate gamma0=1.e-4
    "Pseudo-diffusion conductance use for continuous flow reversal (active if diffusion=false and continuous_flow_reversal = true)";

public
  Real alpha1 "Extraction coefficient for outlet 1 (<=1)";
  Units.SI.AbsolutePressure P(start = 10e5) "Fluid pressure";
  Units.SI.SpecificEnthalpy h(start = 10e5) "Fluid specific enthalpy";
  Units.SI.Temperature T "Fluid temperature";
  Medium.MassFraction X[Medium.nXi](start=Medium.X_default[1:Medium.nXi]) "Mass fractions";
  Units.SI.Power Je "Thermal power diffusion from inlet e";
  Units.SI.Power Js1 "Thermal power diffusion from outlet s1";
  Units.SI.Power Js2 "Thermal power diffusion from outlet s2";
  Units.SI.Power J "Total thermal power diffusion";
  Units.SI.MassFlowRate gamma_e "Diffusion conductance for inlet e";
  Units.SI.MassFlowRate gamma_s1 "Diffusion conductance for outlet s1";
  Units.SI.MassFlowRate gamma_s2 "Diffusion conductance for outlet s2";
  Real re "Value of r(Q/gamma) for inlet e";
  Real rs1 "Value of r(Q/gamma) for outlet s1";
  Real rs2 "Value of r(Q/gamma) for outlet s2";

public
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet Ce(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet Cs1(redeclare package Medium = Medium) annotation (
      Placement(transformation(extent={{30,90},{50,110}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet Cs2(redeclare package Medium = Medium) annotation (
      Placement(transformation(extent={{30,-110},{50,-90}}, rotation=0)));
  InstrumentationAndControl.Connectors.InputReal Ialpha1
    "Extraction coefficient for outlet 1 (<=1)"
    annotation (Placement(transformation(extent={{0,50},{20,70}}, rotation=0)));
  InstrumentationAndControl.Connectors.OutputReal Oalpha1
    annotation (Placement(transformation(extent={{60,50},{80,70}}, rotation=0)));
equation

  /* Unconnected connectors */
  if (cardinality(Ialpha1) == 0) then
    Ialpha1.signal = 0.5;
  end if;
/* Mass balance equation */
  0 = Ce.Q - Cs1.Q - Cs2.Q;
  P = Ce.P;
  P = Cs1.P;
  P = Cs2.P;
/* Energy balance equation */
  0 = Ce.Q*Ce.h - Cs1.Q*Cs1.h - Cs2.Q*Cs2.h + J;
  Ce.h_vol_2 = h;
  Cs1.h_vol_1 = h;
  Cs2.h_vol_1 = h;

  /* Fluid composition balance equations */
  fill(0,Medium.nXi) = Ce.Xi*Ce.Q - Cs1.Xi*Cs1.Q - Cs2.Xi*Cs2.Q;

  Cs1.Xi = X;
  Cs2.Xi = X;

  /* Traces composition balance equations */
  Cs1.Q*Cs1.SubC + Cs2.Q*Cs2.SubC = Ce.Q*Ce.SubC;

  Cs2.SubC = Cs1.SubC;

  /* Mass flow at outlet 1 */
  if (cardinality(Ialpha1) <> 0) then
    Cs1.Q = Ialpha1.signal*Ce.Q;
  end if;
  alpha1 = if noEvent(abs(Ce.Q) > 0) then Cs1.Q/Ce.Q else Modelica.Constants.inf;
  Oalpha1.signal = alpha1;
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
    re = if Ce.diff_on_1 then exp(-0.033*(Ce.Q*Ce.diff_res_1)^2) else 0;
    rs1 = if Cs1.diff_on_2 then exp(-0.033*(Cs1.Q*Cs1.diff_res_2)^2) else 0;
    rs2 = if Cs2.diff_on_2 then exp(-0.033*(Cs2.Q*Cs2.diff_res_2)^2) else 0;
    gamma_e = if Ce.diff_on_1 then 1/Ce.diff_res_1 else gamma0;
    gamma_s1 = if Cs1.diff_on_2 then 1/Cs1.diff_res_2 else gamma0;
    gamma_s2 = if Cs2.diff_on_2 then 1/Cs2.diff_res_2 else gamma0;
    Je = if Ce.diff_on_1 then re*gamma_e*(Ce.h_vol_1 - Ce.h_vol_2) else 0;
    Js1 = if Cs1.diff_on_2 then rs1*gamma_s1*(Cs1.h_vol_2 - Cs1.h_vol_1) else 0;
    Js2 = if Cs2.diff_on_2 then rs2*gamma_s2*(Cs2.h_vol_2 - Cs2.h_vol_1) else 0;
  else
    re = 0;
    rs1 = 0;
    rs2 = 0;
    gamma_e = gamma0;
    gamma_s1 = gamma0;
    gamma_s2 = gamma0;
    Je = 0;
    Js1 = 0;
    Js2 = 0;
  end if;
  J = Je + Js1 + Js2;
  Ce.diff_res_2 = 0;
  Cs1.diff_res_1 = 0;
  Cs2.diff_res_1 = 0;
  Ce.diff_on_2 = diffusion;
  Cs1.diff_on_1 = diffusion;
  Cs2.diff_on_1 = diffusion;

  /* Fluid thermodynamic properties */
  T = Medium.temperature_phX(p=P, h=h, X=X);

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Polygon(
          points={{60,100},{60,-100},{20,-100},{20,-20},{-100,-20},{-100,20},{
              20,20},{20,100},{60,100}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Text(extent={{20,80},{60,40}}, textString=
                                     "1"),
        Text(extent={{20,-40},{60,-80}}, textString=
                             "2")}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Polygon(
          points={{60,100},{60,-100},{20,-100},{20,-20},{-100,-20},{-100,20},{
              20,20},{20,100},{60,100}},
          lineColor={0,0,0},
          fillColor= DynamicSelect({255,255,0},
          if diffusion then fill_color_singular
          else fill_color_static),
          fillPattern=FillPattern.Solid),
        Text(extent={{30,88},{50,72}}, textString=
                                     "1"),
        Text(extent={{32,-72},{50,-88}}, textString=
                             "2")}),
    Window(
      x=0.33,
      y=0.09,
      width=0.71,
      height=0.88),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
This component model is documented in Sect. 14.8 of the ThermoSysPro book.   
    ", revisions = "
Authors  

Baligh El Hefni  
Daniel Bouskela   

    "),
    DymolaStoredErrors);
end Splitter2;
