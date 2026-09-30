within ThermoSysPro.Fluid.PressureLosses;
model CheckValve "Check valve"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));

  parameter Units.SI.PressureDifference dPOuvert=10
    "Pressure difference when the valve opens";
  parameter Units.SI.PressureDifference dPFerme=0
    "Pressure difference when the valve closes";
  parameter Units.xSI.PressureLossCoefficient k=1000
    "Pressure loss coefficient";
  parameter Units.SI.MassFlowRate Qmin=1.e-6
    "Mass flow when the valve is closed";
  parameter Units.SI.MassFlowRate gamma_diff=1e-4
    "Diffusion conductance (active if diffusion=true in neighbouring volumes)";
  parameter Units.SI.Density p_rho=0 "If > 0, fixed fluid density"
    annotation (Evaluate=true, Dialog(tab="Fluid", group="Fluid properties"));

protected
  parameter Real eps=1.e-3 "Small number for pressure loss equation";

public
  Boolean ouvert(start=true, fixed=true) "Valve state";
  discrete Boolean touvert(start=false, fixed=true);
  discrete Boolean tferme(start=false, fixed=true);
  Units.SI.MassFlowRate Q(start=500) "Mass flow rate";
  Units.SI.PressureDifference deltaP "Singular pressure loss";
  Units.SI.Density rho(start=998) "Fluid density";
  Units.SI.Temperature T(start=290) "Fluid temperature";
  Units.SI.AbsolutePressure Pm(start=1.e5)
    "Fluid average pressure";
  Units.SI.SpecificEnthalpy h(start=100000)
    "Fluid specific enthalpy";
  Medium.MassFraction X[Medium.nXi](start=Medium.X_default[1:Medium.nXi]) "Mass fractions";

  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet C1(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{-120,-10},{-100,10}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet C2(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{100,-10},{120,10}}, rotation=0)));
equation

  C1.Q = C2.Q;
  C1.h = C2.h;

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
  h = C1.h;
  deltaP = C1.P - C2.P;

  /* Pressure loss */
  if ouvert then
    deltaP - k*ThermoSysPro.Functions.ThermoSquare(Q, eps)/2/rho = 0;
  else
    Q - Qmin = 0;
  end if;

  touvert = (deltaP > dPOuvert);
  tferme = (deltaP < dPFerme);

  when {pre(tferme),pre(touvert)} then
    ouvert = pre(touvert);
  end when;

  /* Fluid thermodynamic properties */
  Pm = (C1.P + C2.P)/2;

  T = Medium.temperature_phX(p=Pm, h=h, X=X);

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
          extent={{-70,70},{-50,50}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,0,255}),
        Line(
          points={{-60,-60},{-60,60},{60,-60},{60,60}},
          color={0,203,0},
          thickness=0.5),
        Line(points={{-100,0},{-60,0}}),
        Line(points={{60,0},{100,0}})}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Line(
          points={{-60,-60},{-60,60},{60,-60},{60,60}},
          color={0,203,0},
          thickness=0.5),
        Line(points={{-100,0},{-60,0}}),
        Line(points={{60,0},{100,0}}),
        Ellipse(
          extent={{-70,70},{-50,50}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor= DynamicSelect({127,255,0}, fill_color_singular))}),
    Window(
      x=0.09,
      y=0.05,
      width=0.91,
      height=0.92),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
This component model is documented in Sect. 13.11 of the ThermoSysPro book.   
    ", revisions = "
Author  

Daniel Bouskela   

    "));
end CheckValve;
