within ThermoSysPro.Fluid.PressureLosses;
model Diaphragm "Diaphragm"
  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));

  parameter Real Ouv=0.5 "Diaphragm aperture";
  parameter Units.SI.Diameter D=0.2 "Diaphragm diameter";
  parameter Units.SI.MassFlowRate gamma_diff=1e-4
    "Diffusion conductance (active if diffusion=true in neighbouring volumes)";
  parameter Units.SI.Density p_rho=0 "If > 0, fixed fluid density"
    annotation (Evaluate=true, Dialog(tab="Fluid", group="Fluid properties"));

protected
  constant Real pi=Modelica.Constants.pi "pi";
  parameter Real eps=1.e-3 "Small number for pressure loss equation";

public
  Real khi "Hydraulic pressure loss coefficient";
  Units.SI.PressureDifference deltaP "Pressure loss";
  Units.SI.MassFlowRate Q "Mass flow rate";
  Units.SI.ReynoldsNumber Re "Reynolds number";
  Units.SI.ReynoldsNumber Relim "Limit Reynolds number";
  Units.SI.Density rho "Fluid density";
  Units.SI.DynamicViscosity mu "Fluid dynamic viscosity";
  Units.SI.Temperature T "Fluid temperature";
  Units.SI.AbsolutePressure Pm "Fluid average pressure";
  Units.SI.SpecificEnthalpy h "Fluid specific enthalpy";
  Medium.MassFraction X[Medium.nXi](start=Medium.X_default[1:Medium.nXi]) "Mass fractions";
  Medium.ThermodynamicState state;

public
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet C1(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet C2(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{90,-10},{110,10}}, rotation=0)));
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
  C1.P - C2.P = deltaP;

  /* Pressure loss */
  deltaP = 8*khi*ThermoSysPro.Functions.ThermoSquare(Q, eps)/(pi^2*D^4*rho);

    /* Diaphragme avec ouvertures à arêtes vives (Idel'cik p. 103). One assumes that Re > 1.e5 (Re > Relim) */
  assert((Ouv > 0) and not (Ouv > 1), "Diaphragm: parameter Ouv should be such as 0 < Ouv <= 1");

  khi = ((1.707 - Ouv)/Ouv)^2;

  Relim = 1.e5;

  Re = 4*abs(Q)/(pi*D*mu*Ouv);

  /* Fluid thermodynamic properties */
  Pm = (C1.P + C2.P)/2;

  T = Medium.temperature(state);

  if (p_rho > 0) then
    rho = p_rho;
  else
    rho = Medium.density(state);
  end if;

  state=Medium.setState_phX(p=Pm, h=h, X=X);
  mu = Medium.dynamicViscosity(state);
  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Line(
          points={{-40,100},{-40,20}},
          color={0,203,0},
          thickness=0.5),
        Line(
          points={{-40,-20},{-40,-100}},
          color={0,203,0},
          thickness=0.5),
        Line(
          points={{40,100},{40,18}},
          color={0,203,0},
          thickness=0.5),
        Line(
          points={{40,-20},{40,-100}},
          color={0,203,0},
          thickness=0.5)}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Line(
          points={{-40,100},{-40,20}},
          color= {0,203,0},
          thickness=0.5),
        Line(
          points={{-40,-20},{-40,-100}},
          color= {0,203,0},
          thickness=0.5),
        Line(
          points={{40,100},{40,18}},
          color= {0,203,0},
          thickness=0.5),
        Line(
          points={{40,-20},{40,-100}},
          color= {0,203,0},
          thickness=0.5)}),
    Window(
      x=0.13,
      y=0.05,
      width=0.73,
      height=0.73),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
This component model is documented in Sect. 13.7 of the ThermoSysPro book.   
    ", revisions = "
Author  

Daniel Bouskela   

    "));
end Diaphragm;
