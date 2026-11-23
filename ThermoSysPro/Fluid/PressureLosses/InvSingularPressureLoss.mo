within ThermoSysPro.Fluid.PressureLosses;
model InvSingularPressureLoss "Inverse singular pressure loss"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));

  parameter Units.SI.MassFlowRate gamma_diff=1e-4
    "Diffusion conductance (active if diffusion=true in neighbouring volumes)";
  parameter Units.SI.Density p_rho=0 "If > 0, fixed fluid density"
    annotation (Evaluate=true, Dialog(tab="Fluid", group="Fluid properties"));

protected
  parameter Real eps=1.e-3 "Small number for pressure loss equation";
  constant Real pi=Modelica.Constants.pi "pi";
  parameter Units.SI.MassFlowRate Qeps=1.e-3 "Small mass flow rate";

public
  Real K(start=1.e3) "Pressure loss coefficient";
  ThermoSysPro.Units.SI.PressureDifference deltaP "Singular pressure loss";
  Units.SI.MassFlowRate Q(start=500) "Mass flow rate";
  Units.SI.SpecificEnthalpy h(start=100000) "Fluid specific enthalpy";
  Units.SI.Temperature T(start=290) "Fluid temperature";
  Units.SI.Density rho(start=998) "Fluid density";
  Units.SI.AbsolutePressure Pm(start=1.e5) "Average fluid pressure";
  Medium.MassFraction X[Medium.nXi](start=Medium.X_default[1:Medium.nXi]) "Mass fractions";

public
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet C1(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet C2(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{90,-10},{110,10}}, rotation=0)));
equation

  C2.Q = C1.Q;
  C2.h = C1.h;

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
  deltaP = if noEvent(abs(Q) < Qeps) then 1.e-10 else K*ThermoSysPro.Functions.ThermoSquare(Q, eps)/rho;

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
        Polygon(
          points={{-60,40},{-40,20},{-20,10},{0,8},{20,10},{40,20},{60,40},{-60,
              40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,255,0}),
        Polygon(
          points={{-60,-40},{-40,-20},{-20,-12},{0,-10},{20,-12},{40,-20},{60,
              -40},{-60,-40}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid)}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Polygon(
          points={{-60,40},{-40,20},{-20,10},{0,8},{20,10},{40,20},{60,40},{-60,
              40}},
          lineColor={0,0,255},
          fillColor= DynamicSelect({255,255,0}, fill_color_static),
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-60,-40},{-40,-20},{-20,-12},{0,-10},{20,-12},{40,-20},{60,
              -40},{-60,-40}},
          lineColor={0,0,255},
          fillColor= DynamicSelect({255,255,0}, fill_color_static),
          fillPattern=FillPattern.Solid)}),
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
end InvSingularPressureLoss;
