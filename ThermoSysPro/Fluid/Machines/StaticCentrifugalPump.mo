within ThermoSysPro.Fluid.Machines;
model StaticCentrifugalPump "Static centrifugal pump"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));

  parameter Units.nonSI.AngularVelocity_rpm VRot=1400
    "Fixed rotational speed (active if fixed_rot_or_power=1 and rpm_or_mpower connector not connected)";
  parameter Units.SI.Power MPower=0.1e6
    "Fixed mechanical power (active if fixed_rot_or_power=2 and rpm_or_mpower connector not connected)";
  parameter Units.nonSI.AngularVelocity_rpm VRotn=1400
    "Nominal rotational speed";
  parameter Real rm=0.85
    "Product of the pump mechanical and electrical efficiencies";
  parameter Integer fixed_rot_or_power=1
    "1: fixed rotational speed - 2: fixed mechanical power";
  parameter Boolean adiabatic_compression=false
    "true: compression at constant enthalpy - false: compression with varying enthalpy";
  parameter Units.SI.MassFlowRate gamma_diff=1e-4
    "Diffusion conductance (active if diffusion=true in neighbouring volumes)";
  parameter Units.SI.Density p_rho=0 "If > 0, fixed fluid density"
    annotation (Evaluate=true, Dialog(tab="Fluid", group="Fluid properties"));

  parameter Real a1=-88.67
    "x^2 coef. of the pump characteristics hn = f(vol_flow) (s2/m5)";
  parameter Real a2=0
    "x coef. of the pump characteristics hn = f(vol_flow) (s/m2)";
  parameter Real a3=43.15
    "Constant coef. of the pump characteristics hn = f(vol_flow) (m)";

  parameter Real b1=-3.7751
    "x^2 coef. of the pump efficiency characteristics rh = f(vol_flow) (s2/m6)";
  parameter Real b2=3.61
    "x coef. of the pump efficiency characteristics rh = f(vol_flow) (s/m3)";
  parameter Real b3=-0.0075464
    "Constant coef. of the pump efficiency characteristics rh = f(vol_flow) (s.u.)";

protected
  constant Units.SI.Acceleration g=Modelica.Constants.g_n
    "Gravity constant";
  parameter Real eps=1.e-6 "Small number";
  parameter Real rhmin=0.20 "Minimum efficiency to avoid zero crossings";

public
  Real rh "Hydraulic efficiency";
  Units.SI.Height hn(start=10) "Pump head";
  Real R(start=VRot/VRotn) "Reduced rotational speed";
  Units.SI.MassFlowRate Q(start=500) "Mass flow rate";
  Units.SI.VolumeFlowRate Qv(start=0.5) "Volume flow rate";
  Units.SI.Power Wh "Hydraulic power";
  Units.SI.Power Wm "Mechanical power";
  Units.nonSI.AngularVelocity_rpm Vr "Rotational speed";
  Units.SI.Density rho(start=998) "Fluid density";
  Units.SI.PressureDifference deltaP
    "Pressure variation between the outlet and the inlet";
  Units.SI.SpecificEnthalpy deltaH
    "Specific enthalpy variation between the outlet and the inlet";
  Units.SI.AbsolutePressure Pm(start=1.e5)
    "Fluid average pressure";
  Units.SI.SpecificEnthalpy h(start=100000)
    "Fluid average specific enthalpy";
  Medium.MassFraction X[Medium.nXi](start=Medium.X_default[1:Medium.nXi]) "Mass fractions";

  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet C1(redeclare package
      Medium =                                                                      Medium) annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet C2(redeclare package
      Medium =                                                                       Medium) annotation (Placement(
        transformation(extent={{90,-10},{110,10}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal rpm_or_mpower
    annotation (Placement(transformation(
        origin={0,-110},
        extent={{-10,-10},{10,10}},
        rotation=90)));
equation
  if (cardinality(rpm_or_mpower) == 0) then
    if (fixed_rot_or_power == 1) then
      rpm_or_mpower.signal = VRot;
    elseif (fixed_rot_or_power == 2) then
      rpm_or_mpower.signal = MPower;
    else
      assert(false, "StaticCentrifugalPump: incorrect option");
    end if;
  end if;

  C1.Q = C2.Q;

  C1.h_vol_1 = C2.h_vol_1;
  C1.h_vol_2 = C2.h_vol_2;

  C2.diff_on_1 = if (gamma_diff > 0) then C1.diff_on_1 else false;
  C1.diff_on_2 = if (gamma_diff > 0) then C2.diff_on_2 else false;

  C2.diff_res_1 = C1.diff_res_1 + (if (gamma_diff > 0) then 1/gamma_diff else 0);
  C1.diff_res_2 = C2.diff_res_2 + (if (gamma_diff > 0) then 1/gamma_diff else 0);

  C1.Xi = C2.Xi;

  X = C1.Xi;

  C1.SubC = C2.SubC;

  Q = C1.Q;
  deltaP = C2.P - C1.P;
  deltaH = C2.h - C1.h;

  deltaP = rho*g*hn;
  Q = Qv*rho;

  /* Fixed rotational speed or fixed mechanical power */
  if (fixed_rot_or_power == 1) then
    Vr = rpm_or_mpower.signal;
  elseif (fixed_rot_or_power == 2) then
    Wm = rpm_or_mpower.signal;
  else
    assert(false, "StaticCentrifugalPump: incorrect option");
  end if;

  /* Energy balance equation */
  if adiabatic_compression then
    deltaH = 0;
  else
    deltaH = g*hn/rh;
  end if;

  /* Reduced rotational speed */
  R = Vr/VRotn;

  /* Pump characteristics */
  hn = noEvent(a1*Qv*abs(Qv) + a2*Qv*R + a3*R^2);
  rh = noEvent(max(if (abs(R) > eps) then b1*Qv*abs(Qv)/R^2 + b2*Qv/R + b3 else b3, rhmin));

  /* Mechanical power */
  Wm = Q*deltaH/rm;

  /* Hydraulic power */
  Wh = Qv*deltaP/rh;

  /* Fluid thermodynamic properties */
  Pm = (C1.P + C2.P)/2;
  h = (C1.h + C2.h)/2;

  if (p_rho > 0) then
    rho = p_rho;
  else
    rho = Medium.density_phX(p=Pm, h=h, X=X);
  end if;
  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={127,255,0}),
        Line(points={{-80,0},{80,0}}),
        Line(points={{80,0},{2,60}}),
        Line(points={{80,0},{0,-60}})}),
    Window(
      x=0.03,
      y=0.02,
      width=0.95,
      height=0.95),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor= DynamicSelect({127,255,0}, fill_color_singular)),
        Line(points={{-80,0},{80,0}}),
        Line(points={{80,0},{2,60}}),
        Line(points={{80,0},{0,-60}})}),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
This component model is documented in Sect. 12.2 of the ThermoSysPro book.   
    ", revisions = "
Authors  

Daniel Bouskela  
Baligh El Hefni   

    "));
end StaticCentrifugalPump;
