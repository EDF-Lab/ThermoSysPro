within ThermoSysPro.Fluid.Machines;
model SteamEngine "Steam engine"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialTwoPhaseThermoSysProMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  import ThermoSysPro.Fluid.Interfaces.PropertyInterfaces.IF97Region;

  parameter Real caract[:, 2]=[0, 0; 15e5, 20.0] "Engine charateristics Q=f(deltaP)";
  parameter Real eta_is=0.85 "Isentropic efficiency";
  parameter Real W_frot=0.0 "Power losses due to hydrodynamic friction (percent)";
  parameter Real eta_stato=1.0 "Efficiency to account for cinetic losses (<= 1) (s.u.)";
  parameter Integer option_interpolation=1 "1: linear interpolation - 2: spline interpolation";
  parameter Units.SI.MassFlowRate gamma_diff=1e-4
    "Diffusion conductance (active if diffusion=true in neighbouring volumes)";
  parameter IF97Region region_e=IF97Region.All_regions "Inlet IF97 region (active for IF97 water/steam only)" annotation(Evaluate=true, Dialog(tab="Fluid", group="Fluid properties"));
  parameter IF97Region region_s=IF97Region.All_regions "Outlet IF97 region (active for IF97 water/steam only)" annotation(Evaluate=true, Dialog(tab="Fluid", group="Fluid properties"));

protected
  constant Units.SI.Acceleration g=Modelica.Constants.g_n "Gravity constant";

  Integer phase_e=if Integer(region_e) == 0 then 0 else if Integer(region_e)==4 then 2 else 1;
  Integer phase_s=if Integer(region_s) == 0 then 0 else if Integer(region_s)==4 then 2 else 1;

public
  Units.SI.Power W "Power produced by the engine";
  Units.SI.MassFlowRate Q "Mass flow rate";
  Units.SI.SpecificEnthalpy His
    "Fluid specific enthalpy after isentropic expansion";
  ThermoSysPro.Units.SI.PressureDifference deltaP "Pressure loss";
  Units.SI.AbsolutePressure Pe(start=10e5) "Pressure at the inlet";
  Units.SI.AbsolutePressure Ps(start=10e5) "Pressure at the outlet";
  Units.SI.Temperature Te "Temperature at the inlet";
  Units.SI.Temperature Ts "Temperature at the outlet";
  Real xm(start=1.0,min=0) "Average vapor mass fraction (n.u.)";


  Medium.ThermodynamicState state_e;
  Medium.ThermodynamicState state_s;
  Medium.ThermodynamicState state_ps;

public
  Interfaces.Connectors.FluidInlet C1(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-80,-10},{-60,10}}, rotation=0)));
  Interfaces.Connectors.FluidOutlet C2(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{60,-10},{80,10}}, rotation=0)));
equation

  C1.Q = C2.Q;

  C1.h_vol_1 = C2.h_vol_1;
  C1.h_vol_2 = C2.h_vol_2;

  C2.diff_on_1 = if (gamma_diff > 0) then C1.diff_on_1 else false;
  C1.diff_on_2 = if (gamma_diff > 0) then C2.diff_on_2 else false;

  C2.diff_res_1 = C1.diff_res_1 + (if (gamma_diff > 0) then 1/gamma_diff else 0);
  C1.diff_res_2 = C2.diff_res_2 + (if (gamma_diff > 0) then 1/gamma_diff else 0);

  C1.SubC = C2.SubC;

  C1.Xi = C2.Xi;
  Q = C1.Q;
  Pe = C1.P;
  Ps = C2.P;
  deltaP = Pe - Ps;

  /* Average vapor mass fraction during the expansion */
  xm = (Medium.vapourQuality(state_e) + Medium.vapourQuality(state_s)) /2.0;

  /* Mass flow */
  if (option_interpolation == 1) then
    Q = ThermoSysPro.Functions.LinearInterpolation(caract[:, 1], caract[:, 2], deltaP);
  elseif (option_interpolation == 2) then
    Q = ThermoSysPro.Functions.SplineInterpolation(caract[:, 1], caract[:, 2], deltaP);
  else
    assert(false, "SteamEngine: incorrect interpolation option");
  end if;

  /* Fluid specific enthalpy at the outlet */
  C2.h - C1.h = xm*eta_is*(His - C1.h);

  /* Mechanical power produced by the engine */
  W = Q*eta_stato*(C1.h - C2.h)*(1 - W_frot/100);

  /* Fluid thermodynamic properties before the expansion */
  state_e = Medium.setState_ph(Pe,C1.h, phase=phase_e);
  Te=Medium.temperature(state_e);

  /* Fluid thermodynamic properties after the expansion */
  state_s = Medium.setState_ph(Ps, C2.h, phase=phase_s);
  Ts=Medium.temperature(state_s);

  /* Fluid thermodynamic properties after the isentropic expansion */
  state_ps = Medium.setState_ps(Ps, Medium.specificEntropy(state_e), phase=phase_s);
  His=Medium.specificEnthalpy(state_ps);

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Polygon(
          points={{-60,100},{-60,-100},{60,-100},{60,100},{-60,100}},
          lineColor={0,0,255},
          fillColor={128,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,100},{20,12}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-22,-16},{30,-66}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{0,60},{24,-42}}, color={0,0,255}),
        Rectangle(
          extent={{-20,80},{20,40}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Forward)}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Polygon(
          points={{-60,100},{-60,-100},{60,-100},{60,100},{-60,100}},
          lineColor={28,108,200},
          fillColor=DynamicSelect({127,255,0}, fill_color_singular),
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,100},{20,20}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-22,-16},{30,-66}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{0,60},{24,-42}}, color={0,0,255}),
        Rectangle(
          extent={{-20,80},{20,40}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Forward)}),
    Window(
      x=0.17,
      y=0.1,
      width=0.76,
      height=0.76),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
    ", revisions = "
Authors  

Benoît Bride  
Daniel Bouskela   

    "));
end SteamEngine;
