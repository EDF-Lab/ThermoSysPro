within ThermoSysPro.Fluid.HeatExchangers;
model SimpleStaticCondenser "Simple static condenser"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialTwoPhaseThermoSysProMedium "Medium model for the condensing side" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  replaceable package Medium_Cooling = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialTwoPhaseThermoSysProMedium "Medium model for the cooling side" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));

  parameter Real Kc=10 "Friction pressure loss coefficient for the hot side";
  parameter Real Kf=10 "Friction pressure loss coefficient for the cold side";
  parameter Units.SI.Position z1c=0 "Hot inlet altitude";
  parameter Units.SI.Position z2c=0 "Hot outlet altitude";
  parameter Units.SI.Position z1f=0 "Cold inlet altitude";
  parameter Units.SI.Position z2f=0 "Cold outlet altitude";
  parameter Units.SI.Density p_rhoc=0
    "If > 0, fixed fluid density for the hot side";
  parameter Units.SI.Density p_rhof=0
    "If > 0, fixed fluid density for the cold side";
  parameter Units.SI.MassFlowRate gamma_diff_c=1e-4
    "Diffusion conductance for the hot fluid (active if diffusion=true in neighbouring volumes)";
  parameter Units.SI.MassFlowRate gamma_diff_f=1e-4
    "Diffusion conductance for the cold fluid (active if diffusion=true in neighbouring volumes)";
protected
  constant Units.SI.Acceleration g=Modelica.Constants.g_n "Gravity constant";
  parameter Real eps=1.e-0 "Small number for pressure loss equation";

public
  Units.SI.Power W(start=1e6)
    "Power exchanged from the hot side to the cold side";
  Units.SI.Temperature Tec(start=500)
    "Fluid temperature at the inlet of the hot side";
  Units.SI.Temperature Tsc(start=400)
    "Fluid temperature at the outlet of the hot side";
  Units.SI.Temperature Tef(start=350)
    "Fluid temperature at the inlet of the cold side";
  Units.SI.Temperature Tsf(start=350)
    "Fluid temperature at the outlet of the cold side";
  ThermoSysPro.Units.SI.PressureDifference DPfc(start=1e3)
    "Friction pressure loss in the hot side";
  ThermoSysPro.Units.SI.PressureDifference DPgc(start=1e2)
    "Gravity pressure loss in the hot side";
  ThermoSysPro.Units.SI.PressureDifference DPc(start=1e3)
    "Total pressure loss in the hot side";
  ThermoSysPro.Units.SI.PressureDifference DPff(start=1e3)
    "Friction pressure loss in the cold side";
  ThermoSysPro.Units.SI.PressureDifference DPgf(start=1e2)
    "Gravity pressure loss in the cold side";
  ThermoSysPro.Units.SI.PressureDifference DPf(start=1e3)
    "Total pressure loss in the cold side";
  Units.SI.Density rhoc(start=998) "Density of the fluid in the hot side";
  Units.SI.Density rhof(start=998) "Density of the fluid in the cold side";
  Units.SI.MassFlowRate Qc(start=100) "Hot fluid mass flow rate";
  Units.SI.MassFlowRate Qf(start=100) "Cold fluid mass flow rate";
  Medium.MassFraction Xc[Medium.nXi](start=Medium.X_default[1:Medium.nXi]) "Mass fractions in the condensing side";
  Medium_Cooling.MassFraction Xf[Medium_Cooling.nXi](start=Medium_Cooling.X_default[1:Medium_Cooling.nXi]) "Mass fractions in the cooling side";
  Medium.ThermodynamicState state_ce "Thermodynamic state at the condensing-side inlet";
  Medium.ThermodynamicState state_cs "Thermodynamic state at the condensing-side outlet";
  Medium.ThermodynamicState state_mc "Average thermodynamic state in the condensing side";
  Medium_Cooling.ThermodynamicState state_fe "Thermodynamic state at the cooling-side inlet";
  Medium_Cooling.ThermodynamicState state_fs "Thermodynamic state at the cooling-side outlet";
  Medium_Cooling.ThermodynamicState state_mf "Average thermodynamic state in the cooling side";
  Medium.SaturationProperties sat_c "Saturation properties at the condensing-side inlet pressure";

public
  Interfaces.Connectors.FluidInlet Ec(redeclare package Medium = Medium) annotation (Placement(transformation(
          extent={{-70,-110},{-50,-90}}, rotation=0)));
  Interfaces.Connectors.FluidInlet Ef(redeclare package Medium = Medium_Cooling) annotation (Placement(transformation(
          extent={{-110,-10},{-90,10}}, rotation=0)));
  Interfaces.Connectors.FluidOutlet Sf(redeclare package Medium = Medium_Cooling) annotation (Placement(transformation(
          extent={{90,-11},{110,9}}, rotation=0)));
  Interfaces.Connectors.FluidOutlet Sc(redeclare package Medium = Medium) annotation (Placement(transformation(
          extent={{50,-110},{70,-90}}, rotation=0)));
equation

  /* Mass flow rates */
  Ec.Q = Sc.Q;

  Ec.h_vol_1 = Sc.h_vol_1;
  Ec.h_vol_2 = Sc.h_vol_2;

  Sc.diff_on_1 = Ec.diff_on_1;
  Ec.diff_on_2 = Sc.diff_on_2;

  Sc.diff_res_1 = Ec.diff_res_1 + 1/gamma_diff_c;
  Ec.diff_res_2 = Sc.diff_res_2 + 1/gamma_diff_c;

  Ec.Xi = Sc.Xi;
  Ec.SubC = Sc.SubC;

  Ef.Q = Sf.Q;

  Ef.h_vol_1 = Sf.h_vol_1;
  Ef.h_vol_2 = Sf.h_vol_2;

  Sf.diff_on_1 = Ef.diff_on_1;
  Ef.diff_on_2 = Sf.diff_on_2;

  Sf.diff_res_1 = Ef.diff_res_1 + 1/gamma_diff_f;
  Ef.diff_res_2 = Sf.diff_res_2 + 1/gamma_diff_f;

  Ef.Xi = Sf.Xi;
  Ef.SubC = Sf.SubC;

  Qc = Ec.Q;
  Qf = Ef.Q;
  Xc = Ec.Xi;
  Xf = Ef.Xi;

  /* The fluid specific enthalpy at the outlet of the hot side is assumed to be at the saturation point */
  Sc.h = Medium.bubbleEnthalpy(sat_c);

  /* Power exchanged between the two sides */
  W = Qf*(Sf.h - Ef.h);
  W = Qc*(Ec.h - Sc.h);

  /* Pressure losses in the hot side */
  Ec.P - Sc.P = DPc;

  DPfc = Kc*ThermoSysPro.Functions.ThermoSquare(Qc, eps)/rhoc;
  DPgc = rhoc*g*(z2c - z1c);
  DPc  = DPfc + DPgc;

  /* Pressure losses in the cold side */
  Ef.P - Sf.P = DPf;

  DPff = Kf*ThermoSysPro.Functions.ThermoSquare(Qf, eps)/rhof;
  DPgf = rhof*g*(z2f - z1f);
  DPf  = DPff + DPgf;

  /* Fluid thermodynamic properties at the hot side */
  sat_c = Medium.setSat_p(Ec.P);
  state_ce = Medium.setState_phX(p=Ec.P, h=Ec.h, X=Xc);
  state_cs = Medium.setState_phX(p=Sc.P, h=Sc.h, X=Xc);
  state_mc = Medium.setState_phX(p=(Ec.P + Sc.P)/2, h=(Ec.h + Sc.h)/2, X=Xc);

  Tec = Medium.temperature(state_ce);
  Tsc = Medium.temperature(state_cs);

  if (p_rhoc > 0) then
    rhoc = p_rhoc;
  else
    rhoc = Medium.density(state_mc);
  end if;

  /* Fluid thermodynamic properties at the cold side */
  state_fe = Medium_Cooling.setState_phX(p=Ef.P, h=Ef.h, X=Xf);
  state_fs = Medium_Cooling.setState_phX(p=Sf.P, h=Sf.h, X=Xf);
  state_mf = Medium_Cooling.setState_phX(p=(Ef.P + Sf.P)/2, h=(Ef.h + Sf.h)/2, X=Xf);

  Tef = Medium_Cooling.temperature(state_fe);
  Tsf = Medium_Cooling.temperature(state_fs);

  if (p_rhof > 0) then
    rhof = p_rhof;
  else
    rhof = Medium_Cooling.density(state_mf);
  end if;

  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={127,255,0}),
          Line(
          points={{-60,-90},{-60,38},{0,-8},{60,40},{60,-90}},
          color={0,0,255},
          thickness=0),
        Text(
          extent={{-104,-90},{-76,-110}},
          lineColor={238,46,47},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Steam inlet"),
        Text(
          extent={{-132,28},{-106,14}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Cold inlet"),
        Text(
          extent={{104,28},{134,12}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Cold outlet"),
        Text(
          extent={{78,-90},{106,-110}},
          lineColor={238,46,47},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Steam outlet")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,0}),
        Line(
          points={{-60,-90},{-60,38},{0,-8},{60,40},{60,-90}},
          color={0,0,255},
          thickness=0.5),
        Text(
          extent={{-110,21},{-90,11}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString=
               "Cold inlet"),
        Text(
          extent={{-46,-93},{-26,-103}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString=
               "Hot inlet"),
        Text(
          extent={{28,-93},{48,-103}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString=
               "Hot outlet"),
        Text(
          extent={{88,20},{110,9}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString=
               "Cold outlet")}),
    Window(
      x=0.05,
      y=0.01,
      width=0.93,
      height=0.87),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
    ", revisions = "
Author  

Baligh El Hefni   

    "),
    DymolaStoredErrors);
end SimpleStaticCondenser;
