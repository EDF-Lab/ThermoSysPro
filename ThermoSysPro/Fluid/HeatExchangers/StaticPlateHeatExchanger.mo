within ThermoSysPro.Fluid.HeatExchangers;
model StaticPlateHeatExchanger "Static plate heat exchanger"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium_c = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model for the hot fluid" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  replaceable package Medium_f = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model for the cold fluid" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  parameter Units.SI.ThermalConductivity lambdam=15.0
    "Metal thermal conductivity";
  parameter Units.SI.CoefficientOfHeatTransfer p_hc=6000
    "Heat transfer coefficient for the hot side if not computed by the correlations";
  parameter Units.SI.CoefficientOfHeatTransfer p_hf=3000
    "Heat transfer coefficient for the cold side if not computed by the correlations";
  parameter Real p_Kc=100 "Pressure loss coefficient for the hot side if not computed by the correlations";
  parameter Real p_Kf=100 "Pressure loss coefficient for the cold side if not computed by the correlations";
  parameter Units.SI.Thickness emetal=0.0006 "Wall thickness";
  parameter Units.SI.Area Sp=2 "Plate area";
  parameter Real nbp=499 "Number of plates";
  parameter Real c1=1.12647 "Correction coefficient";
  parameter Integer exchanger_type=1 "Exchanger type - 1: counter-current. 2: co-current";
  parameter Integer heat_exchange_correlation=1 "Correlation for the computation of the heat exchange coefficient - 0: no correlation. 1: SRI correlations";
  parameter Integer pressure_loss_correlation=1 "Correlation for the computation of the pressure loss coefficient - 0: no correlation. 1: SRI correlations";
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

public
  Units.SI.Power W "Thermal power exchanged between the two sides";
  ThermoSysPro.Units.SI.PressureDifference DPc
    "Pressure loss of the hot fluid";
  ThermoSysPro.Units.SI.PressureDifference DPf
    "Pressure loss of the cold fluid";
  Units.SI.CoefficientOfHeatTransfer hc
    "Heat transfer coefficient of the hot fluid";
  Units.SI.CoefficientOfHeatTransfer hf
    "Heat transfer coefficient of the cold fluid";
  Units.SI.CoefficientOfHeatTransfer K "Global heat transfer coefficient";
  Units.SI.Area S "Heat exchange surface";
  Units.SI.Temperature Tec "Fluid temperature at the hot inlet";
  Units.SI.Temperature Tsc "Fluid temperature at the hot outlet";
  Units.SI.Temperature Tef "Fluid temperature at the cold inlet";
  Units.SI.Temperature Tsf "Fluid temperature at the cold outlet";
  ThermoSysPro.Units.SI.TemperatureDifference DTm
    "Difference in average temperature";
  ThermoSysPro.Units.SI.TemperatureDifference DT1
    "Temperature difference at the inlet of the exchanger";
  ThermoSysPro.Units.SI.TemperatureDifference DT2
    "Temperature difference at the outlet of the exchanger";
  Real DT12 "DT1/DT2 (s.u.)";
  Units.SI.MassFlowRate Qc(start=500) "Mass flow rate of the hot fluid";
  Units.SI.MassFlowRate Qf(start=500) "Mass flow rate of the cold fluid";
  Real qmc;
  Real qmf;
  Real quc;
  Real quf;
  Real N;
  Units.SI.Density rhoc(start=998) "Hot fluid density";
  Units.SI.Density rhof(start=998) "Cold fluid density";
  Units.SI.DynamicViscosity muc(start=1.e-3) "Hot fluid dynamic viscosity";
  Units.SI.DynamicViscosity muf(start=1.e-3) "Cold fluid dynamic viscosity";
  Units.SI.ThermalConductivity lambdac(start=0.602698)
    "Hot fluid thermal conductivity";
  Units.SI.ThermalConductivity lambdaf(start=0.597928)
    "Cold fluid thermal conductivity";
  Units.SI.Temperature Tmc(start=290) "Hot fluid average temperature";
  Units.SI.Temperature Tmf(start=290) "Cold fluid average temperature";
  Units.SI.AbsolutePressure Pmc(start=1.e5) "Hot fluid average pressure";
  Units.SI.AbsolutePressure Pmf(start=1.e5) "Cold fluid average pressure";
  Units.SI.SpecificEnthalpy Hmc(start=100000)
    "Hot fluid average specific enthalpy";
  Units.SI.SpecificEnthalpy Hmf(start=100000)
    "Cold fluid average specific enthalpy";
  Medium_c.MassFraction Xc[Medium_c.nXi](start=Medium_c.X_default[1:Medium_c.nXi]) "Mass fractions of the hot fluid";
  Medium_f.MassFraction Xf[Medium_f.nXi](start=Medium_f.X_default[1:Medium_f.nXi]) "Mass fractions of the cold fluid";
  Medium_c.ThermodynamicState state_c "Average thermodynamic state of the hot fluid";
  Medium_f.ThermodynamicState state_f "Average thermodynamic state of the cold fluid";
  Medium_c.ThermodynamicState state_ce "Thermodynamic state of the hot fluid at the inlet";
  Medium_c.ThermodynamicState state_cs "Thermodynamic state of the hot fluid at the outlet";
  Medium_f.ThermodynamicState state_fe "Thermodynamic state of the cold fluid at the inlet";
  Medium_f.ThermodynamicState state_fs "Thermodynamic state of the cold fluid at the outlet";

public
  Interfaces.Connectors.FluidInlet Ec(redeclare package Medium = Medium_c) annotation (Placement(transformation(
          extent={{-110,-10},{-90,10}}, rotation=0)));
  Interfaces.Connectors.FluidInlet Ef(redeclare package Medium = Medium_f) annotation (Placement(transformation(
          extent={{-60,-70},{-40,-50}}, rotation=0)));
  Interfaces.Connectors.FluidOutlet Sf(redeclare package Medium = Medium_f) annotation (Placement(transformation(
          extent={{40,-70},{60,-50}}, rotation=0)));
  Interfaces.Connectors.FluidOutlet Sc(redeclare package Medium = Medium_c) annotation (Placement(transformation(
          extent={{90,-8},{110,12}}, rotation=0)));
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

  /* Pressures */
  Sc.P = if Qc > 0 then Ec.P - DPc else Ec.P + DPc;
  Sf.P = if Qf > 0 then Ef.P - DPf else Ef.P + DPf;

  /* Heat exchanges between the hot and cold fluids */
  K = hc*hf/(hc + hf + hc*hf*emetal/lambdam);
  W = K*S*DTm;

  if (abs(Qc) > 1.e-3) then
    W = Qc*Medium_c.specificHeatCapacityCp(state_c)*(Tec - Tsc);
  else
    Tec = Tsc;
  end if;

  if (abs(Qf) > 1.e-3) then
    W = Qf*Medium_f.specificHeatCapacityCp(state_f)*(Tsf - Tef);
  else
    Tef = Tsf;
  end if;

  /* Difference in average temperatures */
  if noEvent(((DT1 > DT2) and (DT2 > 0)) or ((DT1 < DT2) and (DT2 < 0))) then
    DTm = (DT1 - DT2)/Modelica.Math.log(DT1/DT2);
  else
    DTm = (DT1 + DT2)/2;
  end if;

  if (exchanger_type == 1) then
    /* Counter-current heat exchanger */
    DT1 = Tec - Tsf;
    DT2 = Tsc - Tef;
  elseif (exchanger_type == 2) then
    /* Co-current heat exchanger */
    DT1 = Tec - Tef;
    DT2 = Tsc - Tsf;
  else
    DT1 = 0;
    DT2 = 0;
    assert(false, "StaticWaterWaterExchanger: incorrect exchanger type");
  end if;

  DT12 = if noEvent(abs(DT2) > Modelica.Constants.eps) then DT1/DT2 else 0;

  /* Heat exchange area (for the plate heat exchanger) */
  S = (nbp - 2)*Sp;
  N = (nbp - 1)/2;

  /* Heat exchange coefficients */
  qmc = noEvent(abs(Qc)/(muc*N));
  qmf = noEvent(abs(Qf)/(muf*N));

  if (heat_exchange_correlation == 0) then
    hc = p_hc;
    hf = p_hf;
  elseif (heat_exchange_correlation == 1) then
    hc = noEvent(if (qmc < 1.e-3) then 0 else 11.245*qmc^0.8*abs(muc*Medium_c.specificHeatCapacityCp(state_c)/lambdac)^0.4*lambdac);
    hf = noEvent(if (qmf < 1.e-3) then 0 else 11.245*qmf^0.8*abs(muf*Medium_f.specificHeatCapacityCp(state_f)/lambdaf)^0.4*lambdaf);
  else
    hc = 0;
    hf = 0;
    assert(false, "StaticWaterWaterExchanger: incorrect heat exchange correlation number");
  end if;

  /* Pressure losses */
  quc = noEvent(abs(Qc)/N);
  quf = noEvent(abs(Qf)/N);

  if (pressure_loss_correlation == 0) then
    DPc = p_Kc*Qc^2/rhoc;
    DPf = p_Kf*Qf^2/rhof;
  elseif (pressure_loss_correlation == 1) then
    DPc = noEvent(if (qmc < 1.e-3) then 0 else c1*14423.2/rhoc*qmc^(-0.097)*quc^2*(1472.47 + 1.54*(N - 1)/2 + 104.97*qmc^(-0.25)));
    DPf = noEvent(if (qmf < 1.e-3) then 0 else 14423.2/rhof*qmf^(-0.097)*quf^2*(1472.47 + 1.54*(N - 1)/2 + 104.97*qmf^(-0.25)));
  else
    DPc = 0;
    DPf = 0;
    assert(false,
      "StaticWaterWaterExchanger: incorrect pressure loss correlation number");
  end if;

  /* Fluid thermodynamic properties */
  Pmc = (Ec.P + Sc.P)/2;
  Pmf = (Ef.P + Sf.P)/2;
  Hmc = (Ec.h + Sc.h)/2;
  Hmf = (Ef.h + Sf.h)/2;

  state_c = Medium_c.setState_phX(p=Pmc, h=Hmc, X=Xc);
  state_f = Medium_f.setState_phX(p=Pmf, h=Hmf, X=Xf);

  Tmc = Medium_c.temperature(state_c);
  Tmf = Medium_f.temperature(state_f);

  if (p_rhoc > 0) then
    rhoc = p_rhoc;
  else
    rhoc = Medium_c.density(state_c);
  end if;

  if (p_rhof > 0) then
    rhof = p_rhof;
  else
    rhof = Medium_f.density(state_f);
  end if;

  muc = Medium_c.dynamicViscosity(state_c);
  muf = Medium_f.dynamicViscosity(state_f);

  lambdac = Medium_c.thermalConductivity(state_c);
  lambdaf = Medium_f.thermalConductivity(state_f);

  /* Fluid temperatures at the inlet and outlet of the exchanger */
  state_ce = Medium_c.setState_phX(p=Ec.P, h=Ec.h, X=Xc);
  state_cs = Medium_c.setState_phX(p=Sc.P, h=Sc.h, X=Xc);

  state_fe = Medium_f.setState_phX(p=Ef.P, h=Ef.h, X=Xf);
  state_fs = Medium_f.setState_phX(p=Sf.P, h=Sf.h, X=Xf);

  Tec = Medium_c.temperature(state_ce);
  Tsc = Medium_c.temperature(state_cs);
  Tef = Medium_f.temperature(state_fe);
  Tsf = Medium_f.temperature(state_fs);

  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor=DynamicSelect({255,255,0}, fill_color_static)),
        Line(points={{-80,60},{-80,-60}}),
        Line(points={{80,60},{80,-60}}),
        Line(points={{-80,0},{-60,0},{-40,20},{40,-20},{60,0},{80,0}}, color={
              28,108,200}),
        Text(
          extent={{-126,24},{-106,14}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Hot inlet"),
        Text(
          extent={{-82,-66},{-62,-76}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Cold inlet"),
        Text(
          extent={{66,-66},{90,-76}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Cold outlet"),
        Text(
          extent={{104,24},{128,10}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Hot outlet")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,0}),
        Line(points={{-80,60},{-80,-60}}),
        Line(points={{80,60},{80,-60}}),
        Line(points={{-80,0},{-60,0},{-40,20},{40,-20},{60,0},{80,0}}, color={
              28,108,200}),
        Text(
          extent={{-122,22},{-102,12}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Hot inlet"),
        Text(
          extent={{100,24},{124,10}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Hot outlet"),
        Text(
          extent={{-86,-66},{-62,-76}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Cold inlet"),
        Text(
          extent={{64,-66},{92,-80}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Cold outlet")}),
    Window(
      x=0.05,
      y=0.01,
      width=0.93,
      height=0.87),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
This component model is documented in Sect. 9.6.2 of the ThermoSysPro book.   
    ", revisions = "
Author  

Daniel Bouskela   

    "));
end StaticPlateHeatExchanger;
