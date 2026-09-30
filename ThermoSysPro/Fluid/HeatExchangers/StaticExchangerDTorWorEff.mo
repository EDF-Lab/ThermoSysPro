within ThermoSysPro.Fluid.HeatExchangers;
model StaticExchangerDTorWorEff "Static heat exchanger with fixed delta temperature, delta power or efficiency"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium_c = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model for the hot fluid" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  replaceable package Medium_f = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model for the cold fluid" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));

  parameter Integer exchanger_type=1 "Exchanger type - 1: delta temperature is fixed - 2: delta power is fixed - 3: efficiency is fixed";
  parameter ThermoSysPro.Units.SI.TemperatureDifference DTfroid=0
    "Temperature difference between the cold inlet and the cold outlet (active if exchanger_type=1)";
  parameter Units.SI.Power DW=0
    "Power increase on the cold side (active if exchanger_type=2)";
  parameter Real EffEch=0.9 "Thermal exchange efficiency (=W/Wmax) (active if exchanger_type=3)";
  parameter Real Kc=1e-4 "Pressure loss coefficient for the hot fluid";
  parameter Real Kf=1e-4 "Pressure loss coefficient for the cold fluid";
  parameter Units.SI.Position z1c=0 "Hot inlet altitude";
  parameter Units.SI.Position z2c=0 "Hot outlet altitude";
  parameter Units.SI.Position z1f=0 "Cold inlet altitude";
  parameter Units.SI.Position z2f=0 "Cold outlet altitude";
  parameter Units.SI.MassFlowRate gamma_diff_c=1e-4
    "Diffusion conductance for the hot fluid (active if diffusion=true in neighbouring volumes)";
  parameter Units.SI.MassFlowRate gamma_diff_f=1e-4
    "Diffusion conductance for the cold fluid (active if diffusion=true in neighbouring volumes)";
  parameter Units.SI.Density p_rhoc=0
    "If > 0, fixed fluid density for the hot fluid";
  parameter Units.SI.Density p_rhof=0
    "If > 0, fixed fluid density for the cold fluid";

protected
  constant Units.SI.Acceleration g=Modelica.Constants.g_n "Gravity constant";
  parameter Real eps=1.e-0 "Small number for pressure loss equation";

public
  Units.SI.Power W(start=1e6)
    "Power exchanged from the hot fluid to the cold fluid";
  Units.SI.Temperature Tec(start=500)
    "Fluid temperature at the inlet of the hot side";
  Units.SI.Temperature Tsc(start=400)
    "Fluid temperature at the outlet of the hot side";
  Units.SI.Temperature Tef(start=350)
    "Fluid temperature at the inlet of the cold side";
  Units.SI.Temperature Tsf(start=450)
    "Fluid temperature at the outlet of the cold side";
  ThermoSysPro.Units.SI.PressureDifference DPfc(start=1e3)
    "Friction pressure loss for the hot fluid";
  ThermoSysPro.Units.SI.PressureDifference DPgc(start=1e2)
    "Gravity pressure loss for the hot fluid";
  ThermoSysPro.Units.SI.PressureDifference DPc(start=1e3)
    "Total pressure loss for the hot fluid";
  ThermoSysPro.Units.SI.PressureDifference DPff(start=1e3)
    "Friction pressure loss for the cold fluid";
  ThermoSysPro.Units.SI.PressureDifference DPgf(start=1e2)
    "Gravity pressure loss for the cold fluid";
  ThermoSysPro.Units.SI.PressureDifference DPf(start=1e3)
    "Total pressure loss for the cold fluid";
  Units.SI.Density rhoc(start=998) "Hot fluid density";
  Units.SI.Density rhof(start=998) "Cold fluid density";
  Units.SI.SpecificHeatCapacity Cpf "Specific heat capacity of the cold fluid";
  Units.SI.SpecificHeatCapacity Cpc "Specific heat capacity of the hot fluid";
  Units.SI.MassFlowRate Qc(start=100) "Hot fluid mass flow rate";
  Units.SI.MassFlowRate Qf(start=100) "Cold fluid mass flow rate";
  Medium_c.MassFraction Xc[Medium_c.nXi](start=Medium_c.X_default[1:Medium_c.nXi]) "Mass fractions of the hot fluid";
  Medium_f.MassFraction Xf[Medium_f.nXi](start=Medium_f.X_default[1:Medium_f.nXi]) "Mass fractions of the cold fluid";
  Medium_c.ThermodynamicState state_ce "Thermodynamic state of the hot fluid at the inlet";
  Medium_c.ThermodynamicState state_cs "Thermodynamic state of the hot fluid at the outlet";
  Medium_c.ThermodynamicState state_cm "Average thermodynamic state of the hot fluid";
  Medium_f.ThermodynamicState state_fe "Thermodynamic state of the cold fluid at the inlet";
  Medium_f.ThermodynamicState state_fs "Thermodynamic state of the cold fluid at the outlet";
  Medium_f.ThermodynamicState state_fm "Average thermodynamic state of the cold fluid";

public
  Interfaces.Connectors.FluidInlet Ec(redeclare package Medium = Medium_c) "Hot inlet" annotation (Placement(
        transformation(extent={{-50,31},{-30,51}}, rotation=0)));
  Interfaces.Connectors.FluidInlet Ef(redeclare package Medium = Medium_f) "Cold inlet" annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}, rotation=0)));
  Interfaces.Connectors.FluidOutlet Sf(redeclare package Medium = Medium_f) "Cold outlet" annotation (Placement(
        transformation(extent={{90,-9},{110,11}}, rotation=0)));
  Interfaces.Connectors.FluidOutlet Sc(redeclare package Medium = Medium_c) "Hot outlet" annotation (Placement(
        transformation(extent={{30,31},{50,51}}, rotation=0)));
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

   /* Power exchanged between the hot and cold fluids */
  if (exchanger_type == 1) then
    W = Qf*(Sf.h - Ef.h);
    W = Qc*(Ec.h - Sc.h);
    Sf.h = Medium_f.specificEnthalpy_pTX(p=Sf.P, T=Tsf, X=Xf);
    Tsf = Tef + DTfroid;
  elseif (exchanger_type == 2) then
    W = Qf*(Sf.h - Ef.h);
    DW = Qf*(Sf.h - Ef.h);
    DW = Qc*(Ec.h - Sc.h);
    Tsf = Medium_f.temperature(state_fs);
  elseif (exchanger_type == 3) then
    W = noEvent(min(Qc*Cpc, Qf*Cpf)*EffEch*(Tec - Tef));
    Sf.h = Ef.h + W/Qf;
    Sc.h = Ec.h - W/Qc;
    Tsf = Medium_f.temperature(state_fs);
  else
    assert(false, "StaticWaterWaterExchangerDTorWorEff: invalid option");
  end if;

  /* Pressure losses for the hot fluid */
  Ec.P - Sc.P = DPc;

  DPfc = Kc*ThermoSysPro.Functions.ThermoSquare(Qc, eps)/rhoc;
  DPgc = rhoc*g*(z2c - z1c);
  DPc  = DPfc + DPgc;

  /* Pressure losses for the cold fluid */
  Ef.P - Sf.P = DPf;

  DPff = Kf*ThermoSysPro.Functions.ThermoSquare(Qf, eps)/rhof;
  DPgf = rhof*g*(z2f - z1f);
  DPf  = DPff + DPgf;

 /* Hot fluid Temperature at the inlet and at the outlet */
  state_ce = Medium_c.setState_phX(p=Ec.P, h=Ec.h, X=Xc);
  state_cs = Medium_c.setState_phX(p=Sc.P, h=Sc.h, X=Xc);
  state_cm = Medium_c.setState_phX(p=(Ec.P + Sc.P)/2, h=(Ec.h + Sc.h)/2, X=Xc);
  Tec = Medium_c.temperature(state_ce);
  Tsc = Medium_c.temperature(state_cs);

  /* Hot fluid density */
  if (p_rhoc > 0) then
    rhoc = p_rhoc;
  else
    rhoc = Medium_c.density(state_cm);
  end if;

  /* Cold fluid Temperature at the inlet */
  state_fe = Medium_f.setState_phX(p=Ef.P, h=Ef.h, X=Xf);
  state_fs = Medium_f.setState_phX(p=Sf.P, h=Sf.h, X=Xf);
  state_fm = Medium_f.setState_phX(p=(Ef.P + Sf.P)/2, h=(Ef.h + Sf.h)/2, X=Xf);
  Tef = Medium_f.temperature(state_fe);

  /* Cold fluid density */
  if (p_rhof > 0) then
    rhof = p_rhof;
  else
    rhof = Medium_f.density(state_fm);
  end if;

  /* Average specific heat capacities */
  Cpf = Medium_f.specificHeatCapacityCp(state_fe);
  Cpc = Medium_c.specificHeatCapacityCp(state_ce);

  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Ellipse(
          extent={{36,-31},{100,31}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-102,-31},{-38,31}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-68,31},{72,-31}},
          lineColor={255,255,0},
          fillColor= DynamicSelect({255,255,0}, fill_color_static),
          fillPattern=FillPattern.Solid),
        Line(
          points={{-72,31},{72,31},{72,31}},
          color={0,0,0}),
        Line(
          points={{-72,-31},{72,-31},{72,-31}},
          color={0,0,0}),
        Line(
          points={{68,-17},{100,-1}},
          color={0,255,255},
          thickness=0),
        Rectangle(
          extent={{-64,2},{68,2}},
          lineColor={0,255,255},
          lineThickness=0,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-96,5},{-64,21}},
          color={0,255,255},
          thickness=0),
        Line(
          points={{-66,-17},{-66,-7}},
          color={0,255,255},
          thickness=0),
        Line(
          points={{-66,-8},{-66,2}},
          color={0,255,255},
          thickness=0),
        Line(
          points={{70,11},{70,21}},
          color={0,255,255},
          thickness=0),
        Line(
          points={{70,2},{70,12}},
          color={0,255,255},
          thickness=0),
        Line(
          points={{0,31},{0,-23}},
          color={0,0,0},
          thickness=0),
        Rectangle(
          extent={{-64,21},{68,21}},
          lineColor={0,255,255},
          lineThickness=0,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-64,-17},{68,-17}},
          lineColor={0,255,255},
          lineThickness=0,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,31},{0,-23}},
          color={0,0,0},
          thickness=0),
        Text(
          extent={{-126,26},{-96,18}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Cold inlet"),
        Text(
          extent={{94,30},{124,16}},
          lineColor={238,46,47},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Cold outlet"),
        Text(
          extent={{-88,56},{-60,44}},
          lineColor={238,46,47},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Hot inlet"),
        Text(
          extent={{56,56},{88,44}},
          lineColor={238,46,47},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Hot outlet")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Text(
          extent={{-108,28},{-92,22}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString=
               "E_Froid"),
        Text(
          extent={{96,28},{112,22}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString=
               "S_Froid"),
        Ellipse(
          extent={{38,-31},{102,31}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-102,-31},{-38,31}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,31},{70,-31}},
          lineColor={255,255,0},
          lineThickness=0.5,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-72,31},{72,31},{72,31}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-72,-31},{72,-31},{72,-31}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{68,-17},{100,-1}},
          color={0,255,255},
          thickness=1),
        Rectangle(
          extent={{-64,-15},{68,-17}},
          lineColor={0,255,255},
          lineThickness=1,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-64,2},{68,0}},
          lineColor={0,255,255},
          lineThickness=1,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-64,21},{68,19}},
          lineColor={0,255,255},
          lineThickness=1,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-64,-7},{68,-9}},
          lineColor={0,255,255},
          lineThickness=1,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-96,5},{-64,21}},
          color={0,255,255},
          thickness=1),
        Rectangle(
          extent={{-64,11},{68,9}},
          lineColor={0,255,255},
          lineThickness=1,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-64,-17},{-64,-7}},
          color={0,255,255},
          thickness=1),
        Line(
          points={{68,-9},{68,1}},
          color={0,255,255},
          thickness=1),
        Line(
          points={{68,10},{68,20}},
          color={0,255,255},
          thickness=1),
        Line(
          points={{-64,1},{-64,11}},
          color={0,255,255},
          thickness=1),
        Line(
          points={{0,31},{0,-23}},
          color={0,0,0},
          thickness=0.5)}),
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
end StaticExchangerDTorWorEff;
