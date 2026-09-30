within ThermoSysPro.Fluid.HeatExchangers;
model StaticExchangerKS "Static heat exchanger with fixed K and S (Coefficient of heat transfer and Heat exchanger surface)"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium_c = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model for the hot fluid" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  replaceable package Medium_f = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model for the cold fluid" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  parameter Units.SI.CoefficientOfHeatTransfer K=100
    "Global heat exchange coefficient";
  parameter Units.SI.Area S=10 "Heat exchange surface";
  parameter Real Kc=1e-4 "Pressure loss coefficient for the hot fluid";
  parameter Real Kf=1e-4 "Pressure loss coefficient for the cold fluid";
  parameter Integer exchanger_conf=1 "Exchanger configuration - 1: counter-current. 2: co-current";
  parameter Units.SI.MassFlowRate gamma_diff_c=1e-4
    "Diffusion conductance for the hot fluid (active if diffusion=true in neighbouring volumes)";
  parameter Units.SI.MassFlowRate gamma_diff_f=1e-4
    "Diffusion conductance for the cold fluid (active if diffusion=true in neighbouring volumes)";
  parameter Units.SI.Density p_rhoc=0
    "If > 0, fixed fluid density for the hot fluid"
    annotation (Evaluate=true, Dialog(tab="Fluid", group="Fluid properties"));
  parameter Units.SI.Density p_rhof=0
    "If > 0, fixed fluid density for the cold fluid"
    annotation (Evaluate=true, Dialog(tab="Fluid", group="Fluid properties"));

protected
  constant Units.SI.Acceleration g=Modelica.Constants.g_n "Gravity constant";
  parameter Real eps=1.e-0 "Small number for pressure loss equation";

public
  Units.SI.Power W "Power exchanged";
  Units.SI.Temperature Tec(start=400)
    "Temperature of the hot fluid at the inlet";
  Units.SI.Temperature Tsc(start=300)
    "Temperature of the hot fluid at the outlet";
  Units.SI.Temperature Tef(start=300)
    "Temperature of the cold fluid at the inlet";
  Units.SI.Temperature Tsf(start=400)
    "Temperature of the cold fluid at the outlet";
  ThermoSysPro.Units.SI.TemperatureDifference DT1 "Delta T at the inlet";
  ThermoSysPro.Units.SI.TemperatureDifference DT2 "Delta T at the outlet";
  Units.SI.SpecificHeatCapacity Cpf(start=2000)
    "Specific heat capacity of the cold fluid";
  Units.SI.SpecificHeatCapacity Cpc(start=2000)
    "Specific heat capacity of the hot fluid";
  Units.SI.Density rhoc(start=998) "Hot fluid density";
  Units.SI.Density rhof(start=998) "Cold fluid density";
  Units.SI.MassFlowRate Qc(start=100) "Mass flow rate of the hot fluid";
  Units.SI.MassFlowRate Qf(start=100) "Mass flow rate of the cold fluid";
  Medium_c.MassFraction Xc[Medium_c.nXi](start=Medium_c.X_default[1:Medium_c.nXi]) "Mass fractions of the hot fluid";
  Medium_f.MassFraction Xf[Medium_f.nXi](start=Medium_f.X_default[1:Medium_f.nXi]) "Mass fractions of the cold fluid";
  Medium_c.ThermodynamicState state_c "Thermodynamic state of the hot fluid";
  Medium_f.ThermodynamicState state_f "Thermodynamic state of the cold fluid";
  Real Kcor "Corrective term for the global heat exchange coefficient";

  Interfaces.Connectors.FluidOutlet Sc(redeclare package Medium = Medium_c) annotation (Placement(transformation(
          extent={{90,-40},{110,-20}}, rotation=0), iconTransformation(extent={
            {90,-40},{110,-20}})));
  Interfaces.Connectors.FluidInlet Ec(redeclare package Medium = Medium_c) annotation (Placement(transformation(
          extent={{-110,-40},{-90,-20}}, rotation=0), iconTransformation(extent=
           {{-110,-40},{-90,-20}})));
  Interfaces.Connectors.FluidInlet Ef(redeclare package Medium = Medium_f) annotation (Placement(transformation(
          extent={{-110,20},{-90,40}}, rotation=0), iconTransformation(extent={
            {-110,20},{-90,40}})));
  Interfaces.Connectors.FluidOutlet Sf(redeclare package Medium = Medium_f) annotation (Placement(transformation(
          extent={{90,20},{110,40}}, rotation=0), iconTransformation(extent={{
            90,20},{110,40}})));
  InstrumentationAndControl.Connectors.InputReal Kcorr "K_correction"
    annotation (Placement(transformation(
        origin={0,70},
        extent={{-10,-10},{10,10}},
        rotation=270)));
equation

  if (cardinality(Kcorr) == 0) then
    Kcorr.signal = 1;
  end if;

  Kcor = Kcorr.signal;

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

  /* Presure losses */
  Ec.P - Sc.P = Kc*ThermoSysPro.Functions.ThermoSquare(Qc, eps)/rhoc;
  Ef.P - Sf.P = Kf*ThermoSysPro.Functions.ThermoSquare(Qf, eps)/rhof;

  if (exchanger_conf == 1) then
     /* Counter-current exchanger */
     DT1 = Tec - Tsf;
     DT2 = Tsc - Tef;
  elseif (exchanger_conf == 2) then
     /* Co-current exchanger */
     DT1 = Tec - Tef;
     DT2 = Tsc - Tsf;
  else
     DT1 = 0;
     DT2 = 0;
     assert(false, "StaticExchangerFlueGasesWaterSteam: incorrect exchanger configuration");
  end if;

  DT2 = if (exchanger_conf == 1) then DT1*Modelica.Math.exp(-Kcor*K*S*(1/(Qc*Cpc) - 1/(Qf*Cpf)))
                                 else DT1*Modelica.Math.exp(-Kcor*K*S*(1/(Qc*Cpc) + 1/(Qf*Cpf)));

  /* Power exchanged */
  W = Qc*(Ec.h-Sc.h);
  W = Qf*(Sf.h - Ef.h);

  /* Cold fluid temperatures */
  Tef = Medium_f.temperature_phX(p=Ef.P, h=Ef.h, X=Xf);
  Tsf = Medium_f.temperature_phX(p=Sf.P, h=Sf.h, X=Xf);

  /* Hot fluid temperatures */
  Tec = Medium_c.temperature_phX(p=Ec.P, h=Ec.h, X=Xc);
  Tsc = Medium_c.temperature_phX(p=Sc.P, h=Sc.h, X=Xc);

  /* Specific heat capacities */
  state_f = Medium_f.setState_phX(p=Ef.P, h=Ef.h, X=Xf);
  state_c = Medium_c.setState_phX(p=Ec.P, h=Ec.h, X=Xc);
  Cpf = Medium_f.specificHeatCapacityCp(state_f);
  Cpc = Medium_c.specificHeatCapacityCp(state_c);

  /* Hot fluid density */
  if (p_rhoc > 0) then
    rhoc = p_rhoc;
  else
    rhoc = Medium_c.density_phX(p=(Ec.P + Sc.P)/2, h=(Ec.h + Sc.h)/2, X=Xc);
  end if;

  /* Cold fluid density */
  if (p_rhof > 0) then
    rhof = p_rhof;
  else
    rhof = Medium_f.density_phX(p=(Ef.P + Sf.P)/2, h=(Ef.h + Sf.h)/2, X=Xf);
  end if;

  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-100,-54},{100,-61}},
          lineColor={175,175,175},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
                               Rectangle(
          extent={{-100,0},{100,-60}},
          lineColor={28,108,200},
          fillColor= DynamicSelect({255,255,0}, fill_color_static),
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-100,61},{100,54}},
          lineColor={175,175,175},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
                               Rectangle(
          extent={{-100,60},{100,0}},
          lineColor={28,108,200},
          fillColor=DynamicSelect({255,255,0}, fill_color_static),
          fillPattern=FillPattern.Backward),
        Line(points={{-50,-31},{48,-31}},
                                      color={255,0,0}),
        Line(points={{46,-29},{50,-31}},
                                     color={255,0,0}),
        Line(points={{46,-33},{50,-31}},
                                      color={255,0,0}),
        Line(
          points={{-100,0},{-42,0},{-26,0},{10,0},{38,0},{100,0}},
          color={0,0,0},
          thickness=0.5)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={28,108,200},
          fillColor={255,255,0},
          fillPattern=FillPattern.Backward),
        Line(
          points={{-100,0},{-42,0},{-22,48},{18,-46},{38,0},{100,0}},
          color={0,0,0},
          thickness=1),
        Text(
          extent={{-114,32},{-78,0}},
          lineColor={28,108,200},
          textString="Cold fluid inlet"),
        Text(
          extent={{-116,56},{-90,36}},
          lineColor={28,108,200},
          textString=" Fluid 2"),
        Text(
          extent={{-112,0},{-84,-28}},
          lineColor={238,46,47},
          textString=" Fluid 1"),
        Text(
          extent={{-110,-30},{-74,-66}},
          lineColor={238,46,47},
          textString="Hot fluid inlet"),
        Text(
          extent={{84,32},{124,-4}},
          lineColor={28,108,200},
          textString="Cold fluid outlet"),
        Text(
          extent={{87,-29},{124,-64}},
          lineColor={238,46,47},
          textString="Hot fluid outlet")}),
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

    "));
end StaticExchangerKS;
