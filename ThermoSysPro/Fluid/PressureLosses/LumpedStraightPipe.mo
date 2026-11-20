within ThermoSysPro.Fluid.PressureLosses;
model LumpedStraightPipe "Lumped straight pipe (circular duct)"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;
  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));

  parameter Units.SI.Length L=10. "Pipe length";
  parameter Units.SI.Diameter D=0.2 "Pipe internal hydraulic diameter";
  parameter Real ntubes=1 "Number of pipes in parallel";
  parameter Real lambda=0.03
    "Friction pressure loss coefficient (active if lambda_fixed=true)";
  parameter Real rugosrel=0.0001
    "Pipe roughness (active if lambda_fixed=false)";
  parameter Units.SI.Position z1=0 "Inlet altitude";
  parameter Units.SI.Position z2=0 "Outlet altitude";
  parameter Boolean lambda_fixed=true
    "true: lambda given by parameter - false: lambde computed using Idel'Cik correlation";
  parameter Boolean inertia=false
    "true: momentum balance equation with inertia - false: without inertia";
  parameter Units.SI.Density p_rho=0 "If > 0, fixed fluid density"
    annotation (Evaluate=true, Dialog(tab="Fluid", group="Fluid properties"));

protected
  constant Units.SI.Acceleration g=Modelica.Constants.g_n "Gravity constant";
  constant Real pi=Modelica.Constants.pi "pi";
  parameter Real eps=1.e-3 "Small number for pressure loss equation";
  parameter Units.SI.Area A=ntubes*pi*D^2/4
    "Pipe cross-sectional area (circular duct is assumed)";
  parameter Units.SI.Area Pw=pi*D*ntubes
    "Pipe wetted perimeter (circular duct is assumed)";

public
  Real khi "Hydraulic pressure loss coefficient";
  ThermoSysPro.Units.SI.PressureDifference deltaPf "Friction pressure loss";
  ThermoSysPro.Units.SI.PressureDifference deltaP "Total pressure loss";
  Units.SI.MassFlowRate Q(start=100) "Mass flow rate";
  Units.SI.ReynoldsNumber Re "Reynolds number";
  Units.SI.ReynoldsNumber Relim "Limit Reynolds number";
  Real lam "Friction pressure loss coefficient";
  Units.SI.Density rho "Fluid density";
  Units.SI.DynamicViscosity mu "Fluid dynamic viscosity";
  Units.SI.Temperature T "Fluid temperature";
  Units.SI.AbsolutePressure Pm "Fluid average pressure";
  Units.SI.SpecificEnthalpy h "Fluid specific enthalpy";
  Units.SI.SpecificHeatCapacity cp(start=4200) "Fluid specific heat capacity";
  Units.SI.ThermalConductivity k(start=0.05) "Fluid thermal conductivity";
  Units.SI.MassFlowRate gamma_diff(start=1.e-4) "Diffusion conductance";
  Medium.MassFraction X[Medium.nXi](start=Medium.X_default[1:Medium.nXi]) "Mass fractions";
  Medium.ThermodynamicState state "Fluid thermodynamic state";

public
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet C1(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet C2(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{90,-10},{110,10}}, rotation=0)));
initial equation
  if inertia then
    der(Q) = 0;
  end if;

equation

  C1.Q = C2.Q;
  C1.h = C2.h;

  C1.h_vol_1 = C2.h_vol_1;
  C1.h_vol_2 = C2.h_vol_2;

  C2.diff_on_1 = C1.diff_on_1;
  C1.diff_on_2 = C2.diff_on_2;

  C2.diff_res_1 = C1.diff_res_1 + 1/gamma_diff;
  C1.diff_res_2 = C2.diff_res_2 + 1/gamma_diff;

  C1.Xi = C2.Xi;
  X = C1.Xi;

  C1.SubC = C2.SubC;

  Q = C1.Q;
  h = C1.h;
  deltaP = C1.P - C2.P;

  /* Diffusion resistance */
  gamma_diff = A*k/cp/L;

  /* Pressure loss */
  if inertia then
    deltaP = deltaPf + rho*g*(z2 - z1) + L/A*der(Q);
  else
    deltaP = deltaPf + rho*g*(z2 - z1);
  end if;

  deltaPf = khi*ThermoSysPro.Functions.ThermoSquare(Q, eps)/(2*A^2*rho);

  /* Darcy-Weisbach formula (Idel'cik p. 55). Quadratic flow regime is assumed and Re > 4000 (Re > Relim). */
  khi = lam*L/D;

  if lambda_fixed then
    lam = lambda;
  else
    if (rugosrel > 0.00005) then
      lam = 1/(2*Modelica.Math.log10(3.7/rugosrel))^2;
    else
      lam = if noEvent(Re > 0) then 1/(1.8*Modelica.Math.log10(Re) - 1.64)^2 else 0;
    end if;
  end if;

  Relim = if (rugosrel > 0.00005) then max(560/rugosrel, 2.e5) else 4000;
  Re = 4*abs(Q)/(Pw*mu);

  /* Fluid thermodynamic properties */
  Pm = (C1.P + C2.P)/2;
  state = Medium.setState_phX(p=Pm, h=h, X=X);

  if (p_rho > 0) then
    rho = p_rho;
  else
    rho = Medium.density(state);
  end if;

  T = Medium.temperature(state);
  mu = Medium.dynamicViscosity(state);
  k = Medium.thermalConductivity(state);
  cp = Medium.specificHeatCapacityCp(state);

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={Rectangle(
          extent={{-100,20},{100,-20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={127,255,0})}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={Rectangle(
          extent={{-100,20},{100,-20}},
          lineColor={28,108,200},
          fillPattern=FillPattern.Solid,
          fillColor=DynamicSelect({127,255,0},
          if inertia then fill_color_dynamic
          else fill_color_singular))}),
    Window(
      x=0.06,
      y=0.08,
      width=0.82,
      height=0.65),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
This component model is documented in Sect. 13.5 of the ThermoSysPro book.   
    ", revisions = "
Authors  

Daniel Bouskela  
Baligh El Hefni   

    "));
end LumpedStraightPipe;
