within ThermoSysPro.Fluid.PressureLosses;
model SwitchValve "Switch valve"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));

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
  Units.SI.MassFlowRate Q(start=100) "Mass flow rate";
  Units.SI.PressureDifference deltaP "Singular pressure loss";
  Units.SI.Density rho(start=998) "Fluid density";
  Units.SI.Temperature T(start=290) "Fluid temperature";
  Units.SI.AbsolutePressure Pm(start=1.e5)
    "Fluid average pressure";
  Units.SI.SpecificEnthalpy h(start=100000)
    "Fluid specific enthalpy";
  Medium.MassFraction X[Medium.nXi](start=Medium.X_default[1:Medium.nXi]) "Mass fractions";


public
  ThermoSysPro.InstrumentationAndControl.Connectors.InputLogical Ouv
    annotation (Placement(transformation(
        origin={0,72},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet C1(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{-110,-70},{-90,-50}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet C2(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{90,-70},{110,-50}}, rotation=0),
        iconTransformation(extent={{90,-70},{110,-50}})));
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
  if Ouv.signal then
    deltaP - k*ThermoSysPro.Functions.ThermoSquare(Q, eps)/2/rho = 0;
  else
    Q - Qmin = 0;
  end if;

  /* Fluid thermodynamic properties */
  Pm = (C1.P + C2.P)/2;

  T = Medium.temperature_phX(p=Pm, h=h, X=X);

  if (p_rho > 0) then
    rho = p_rho;
  else
    rho = Medium.density_phX(p=Pm, h=h, X=X);
  end if;

  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Polygon(
          points={{-100,-100},{0,-60},{-100,-20},{-100,-100},{-100,-100}},
          lineColor={0,0,255},
          fillColor=DynamicSelect({127,255,0}, fill_color_singular),
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-60},{100,-20},{100,-100},{0,-60},{0,-60}},
          lineColor={0,0,255},
          fillColor=DynamicSelect({127,255,0}, fill_color_singular),
          fillPattern=FillPattern.Solid),
        Line(
          points={{-40,60},{40,60}},
          color={28,108,200},
          thickness=1),
        Line(points={{0,60},{0,-60}})}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Polygon(
          points={{-100,-100},{0,-60},{-100,-20},{-100,-100},{-100,-100}},
          lineColor={28,108,200},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-60},{100,-20},{100,-100},{0,-60},{0,-60}},
          lineColor={28,108,200},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-40,60},{40,60}},
          color={28,108,200},
          thickness=1),
        Line(points={{0,60},{0,-60}})}),
    Window(
      x=0.1,
      y=0.04,
      width=0.79,
      height=0.84),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
This component model is documented in Sect. 13.10 of the ThermoSysPro book.   
    ", revisions = "
Author  

Daniel Bouskela   

    "));
end SwitchValve;
