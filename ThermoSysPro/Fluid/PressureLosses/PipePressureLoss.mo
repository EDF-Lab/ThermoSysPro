within ThermoSysPro.Fluid.PressureLosses;
model PipePressureLoss "Pipe generic pressure loss"

  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  parameter Real K=10 "Friction pressure loss coefficient";
  parameter Units.SI.Position z1=0 "Inlet altitude";
  parameter Units.SI.Position z2=0 "Outlet altitude";
  parameter Units.SI.MassFlowRate gamma_diff=1e-4
    "Diffusion conductance (active if diffusion=true in neighbouring volumes)";
  parameter Units.SI.Density p_rho=0 "If > 0, fixed fluid density"
    annotation (Evaluate=true, Dialog(tab="Fluid", group="Fluid properties"));
protected
  constant Units.SI.Acceleration g=Modelica.Constants.g_n "Gravity constant";
  parameter Real eps=1.e-3 "Small number for pressure loss equation";

public
  ThermoSysPro.Units.SI.PressureDifference deltaPf "Friction pressure loss";
  ThermoSysPro.Units.SI.PressureDifference deltaPg "Gravity pressure loss";
  ThermoSysPro.Units.SI.PressureDifference deltaP "Total pressure loss";
  Units.SI.MassFlowRate Q(start=100) "Mass flow rate";
  Units.SI.Density rho(start=998) "Fluid density";
  Units.SI.Temperature T(start=290) "Fluid temperature";
  Units.SI.AbsolutePressure Pm(start=1.e5) "Average fluid pressure";
  Units.SI.SpecificEnthalpy h(start=100000) "Fluid specific enthalpy";
  Medium.MassFraction X[Medium.nXi](start=Medium.X_default[1:Medium.nXi]) "Mass fractions";

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

  C1.SubC = C2.SubC;

  Q = C1.Q;
  h = C1.h;
  X = C1.Xi;
  deltaP = C1.P - C2.P;

  /* Pressure loss */
  deltaPf = K*ThermoSysPro.Functions.ThermoSquare(Q, eps)/rho;
  deltaPg = rho*g*(z2 - z1);
  deltaP = deltaPf + deltaPg;

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
        grid={2,2}), graphics={Rectangle(
          extent={{-100,20},{100,-20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={85,255,85}), Text(
          extent={{-12,14},{16,-14}},
          lineColor={0,0,255},
          fillColor={85,255,85},
          fillPattern=FillPattern.Solid,
          textString=
               "K")}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={Rectangle(
          extent={{-100,20},{100,-20}},
          lineColor={0,0,255},
          fillColor=DynamicSelect({127,255,0}, fill_color_singular),
          fillPattern=FillPattern.Solid),
           Text(
          extent={{-14,10},{14,-8}},
          lineColor={0,0,255},
          fillColor={85,255,85},
          fillPattern=FillPattern.Solid,
          textString=
               "K")}),
    Window(
      x=0.11,
      y=0.04,
      width=0.71,
      height=0.88),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
This component model is documented in Sect. 13.4 of the ThermoSysPro book.   
    ", revisions = "
Authors  

Daniel Bouskela  
Baligh El Hefni   

    "));
end PipePressureLoss;
