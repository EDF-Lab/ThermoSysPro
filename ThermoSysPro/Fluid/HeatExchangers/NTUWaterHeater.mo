within ThermoSysPro.Fluid.HeatExchangers;
model NTUWaterHeater "NTU water heater"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium_e = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model for the water side" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  replaceable package Medium_c = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialTwoPhaseThermoSysProMedium "Medium model for the condensing side" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));

  parameter Real lambdaE=0 "Pressure loss coefficient on the water side";
  parameter Units.SI.Area SCondDes=3000
    "Exchange surface for the condensation and deheating";
  parameter Units.SI.CoefficientOfHeatTransfer KCond=1
    "Heat transfer coefficient for the condensation";
  parameter Units.SI.Area SPurge=0 "Drain surface - if > 0: with drain cooling";
  parameter Units.SI.CoefficientOfHeatTransfer KPurge=1
    "Heat transfer coefficient for the drain cooling";
  parameter Units.SI.MassFlowRate gamma_diff_e=1e-4
    "Diffusion conductance for the water side (active if diffusion=true in neighbouring volumes)";
  parameter Boolean continuous_flow_reversal=false "true: continuous flow reversal - false: discontinuous flow reversal";
  parameter Boolean diffusion=false "true: energy balance equation with diffusion - false: energy balance equation without diffusion";

protected
  parameter Units.SI.MassFlowRate gamma0=1.e-4
    "Pseudo-diffusion conductance use for continuous flow reversal (active if diffusion=false and continuous_flow_reversal = true)";
  parameter Real eps=1.e-3 "Small number for pressure loss equation";

public
  Units.SI.AbsolutePressure P(start=10e5) "Fluid pressure";
  Units.SI.SpecificEnthalpy h(start=10e5) "Fluid specific enthalpy";
  Units.SI.SpecificEnthalpy HsateC(start=300e3, min=0)
    "Saturation specific enthalpy of the water at the pressure of the vapor inlet";
  Units.SI.SpecificEnthalpy HsatvC(start=2500e3, min=0)
    "Saturation specific enthalpy of the vapor at the pressure of the vapor inlet";
  Units.SI.Area SDes(start=0) "Heat exchange surface for deheating";
  Units.SI.SpecificEnthalpy HeiF(start=200e3)
    "Fluid specific enthalpy after drain cooling";
  Units.SI.SpecificEnthalpy HDesF(start=200e3)
    "Fluid specific enthalpy after deheating";
  Units.SI.Temperature TeiF(start=400, min=0)
    "Fluid temperature after drain cooling";
  Units.SI.Temperature TsatC(start=400, min=0) "Saturation temperature";
  Units.SI.Power W(start=1) "Total heat power transfered to the cooling water";
  Units.SI.Power Wdes(start=1) "Energy transfer during deheating";
  Units.SI.Power Wcond(start=1) "Energy transfer during condensation";
  Units.SI.Power Wflash(start=1)
    "Energy transfer during partial vaporisation in the drain";
  Units.SI.Power Wpurge(start=1) "Energy transfer during drain cooling";
  Units.SI.SpecificEnthalpy Hep(start=3e5)
    "Mixing specific enthalpy of the drain and the condensate";
  Units.SI.Density rho(start=1e3, min=0) "Average water density";
  Medium_e.MassFraction Xe[Medium_e.nXi](start=Medium_e.X_default[1:Medium_e.nXi]) "Mass fractions on the water side";
  Medium_c.MassFraction Xc[Medium_c.nXi](start=Medium_c.X_default[1:Medium_c.nXi]) "Mass fractions in the condensing volume";
  Medium_c.ExtraProperty SubCc[Medium_c.nC](quantity=Medium_c.extraPropertiesNames, start=Medium_c.C_default) "Trace substances in the condensing volume";
  Units.SI.Power Jep "Thermal power diffusion from the inlet of the drain";
  Units.SI.Power Jev "Thermal power diffusion from the inlet of the vapor side";
  Units.SI.Power Jsp "Thermal power diffusion from the outlet of the drain";
  Units.SI.Power J "Total thermal power diffusion";
  Units.SI.MassFlowRate gamma_ep
    "Diffusion conductance for the inlet of the drain";
  Units.SI.MassFlowRate gamma_ev
    "Diffusion conductance for the inlet of the vapor side";
  Units.SI.MassFlowRate gamma_sp
    "Diffusion conductance for the outlet of the drain";
  Real rep "Value of r(Q/gamma) for the inlet of the drain";
  Real rev "Value of r(Q/gamma) for inlet for the inlet of the vapor side";
  Real rsp "Value of r(Q/gamma) for the outlet of the drain";

  Medium_e.ThermodynamicState state_eeF "Water inlet fluid state (4F)";
  Medium_e.ThermodynamicState state_seF "Water outlet fluid state (1F)";
  Medium_c.ThermodynamicState state_spC "Drain outlet fluid state (4C)";
  Interfaces.Connectors.FluidInlet Ee(redeclare package Medium = Medium_e) "Water inlet"
    annotation (Placement(transformation(extent={{-90,-10},{-110,10}}, rotation=
           0)));
  Interfaces.Connectors.FluidOutlet Se(redeclare package Medium = Medium_e) "Water outlet" annotation (Placement(
        transformation(extent={{110,-10},{90,10}}, rotation=0)));
  Interfaces.Connectors.FluidInlet Ep(redeclare package Medium = Medium_c) "Drain inlet"
    annotation (Placement(transformation(extent={{-50,24},{-70,44}}, rotation=0)));
  Interfaces.Connectors.FluidOutlet Sp(redeclare package Medium = Medium_c) "Drain outlet" annotation (Placement(
        transformation(extent={{-50,-43},{-70,-23}}, rotation=0)));
  Interfaces.Connectors.FluidInlet Ev(redeclare package Medium = Medium_c) "Vapor inlet"
    annotation (Placement(transformation(extent={{70,24},{50,44}}, rotation=0),
        iconTransformation(extent={{70,24},{50,44}})));
  Medium_c.ThermodynamicState state_evC "Vapor inlet fluid state (1C)";
  Medium_c.SaturationProperties satC "Saturation conditions at the vapor inlet pressure";
  Medium_c.ThermodynamicState state_lsatC "Saturated liquid state";
  Medium_c.ThermodynamicState state_vsatC "Saturated vapor state";
  Medium_e.ThermodynamicState state_meF "Average water fluid state (between 4F and 3F)";
  Medium_c.ThermodynamicState state_desmC "Deheating average fluid state (between 1C and 2C)";
  Medium_e.ThermodynamicState state_mcF "Average deheating fluid state (between 3F and 2F)";
  Medium_e.ThermodynamicState state_desF "Deheating inlet fluid state (2F)";
  Medium_e.ThermodynamicState state_desmF "Average deheating fluid state (between 2F and 1F)";
  Medium_c.ThermodynamicState state_sp "Drain outlet fluid state before cooling (near 3C)";
  Medium_c.ThermodynamicState state_mpC "Average fluid state in the drain (between 3C and 4C)";
  Medium_e.ThermodynamicState state_mpF "Average water fluid state (between 4F and 3F)";
  Medium_e.ThermodynamicState state_ecF "Water fluid state (3F)";
  Units.SI.SpecificHeatCapacity cp_desmC;
  Units.SI.SpecificHeatCapacity cp_mcF;
  Units.SI.SpecificHeatCapacity cp_desmF;
  Units.SI.SpecificHeatCapacity cp_mpC;
  Units.SI.SpecificHeatCapacity cp_mpF;
  Units.SI.Temperature T_evC;
  Units.SI.Temperature T_desF;
  Units.SI.Temperature T_sp;
  Units.SI.Temperature T_eeF;
  Real x_flashepC "Steam mass fraction in the flash state";
equation

  /* Unconnected connectors */
  if cardinality(Ep) == 0 then
    Ep.Q = 0;
    Ep.h = 1.e5;
    Ep.h_vol_1 = 1.e5;
    Ep.diff_res_1 = 0;
    Ep.diff_on_1 = false;
    Ep.Xi = Medium_c.X_default[1:Medium_c.nXi];
    Ep.SubC = fill(0, Medium_c.nC);
  end if;

  // Cooling pipe
  //-------------

  Ee.Q = Se.Q;

  Ee.h_vol_1 = Se.h_vol_1;
  Ee.h_vol_2 = Se.h_vol_2;

  Se.diff_on_1 = Ee.diff_on_1;
  Ee.diff_on_2 = Se.diff_on_2;

  Se.diff_res_1 = Ee.diff_res_1 + 1/gamma_diff_e;
  Ee.diff_res_2 = Se.diff_res_2 + 1/gamma_diff_e;

  Ee.Xi = Se.Xi;
  Ee.SubC = Se.SubC;

  Xe = Ee.Xi;

  /* Pressure loss equation in the water pipe */
  Ee.P - Se.P = lambdaE*ThermoSysPro.Functions.ThermoSquare(Ee.Q, eps)/rho;

  /* Heating power released to the cooling pipe */
  W = Se.Q*(Se.h - Ee.h);

  // Water/steam cavity
  //-------------------

  /* Fluid pressure */
  P = Ep.P;
  P = Ev.P;
  P = Sp.P;

  /* Fluid specific enthalpy (singular if all flows = 0) */
  Ep.h_vol_2 = h;
  Ev.h_vol_2 = h;
  Sp.h_vol_1 = h;

  /* Mass balance equation */
  0 = Ep.Q + Ev.Q - Sp.Q;

  /* Energy balance equations */

  // Deheating zone
  //---------------

  /* Heat power, fluid specific enthalpy on the cold side and deheating surface */
  /* If deheating is present */
  if (HsatvC < Ev.h) then
    0 = Ev.Q*(Ev.h - HsatvC) - Ee.Q*(Se.h - HDesF) + J/3;
    Wdes = Ee.Q*(Se.h - HDesF);
    Wdes = noEvent(min(Ev.Q*cp_desmC, Ee.Q*cp_desmF)*ThermoSysPro.Correlations.Thermal.WBHeatExchangerEfficiency(Ev.Q, Ee.Q, cp_desmC, cp_desmF, KCond/2, SDes, 1)*(T_evC - T_desF));
  /* If deheating is absent */
  else
    Wdes = 1e-9;
    HDesF = Se.h;
    SDes = 1e-9;
  end if;

  // Condensation zone
  //------------------

  /* Heat power, fluid specific enthalpy at the outlet of the condensation zone and vapor mass flow rate at the inlet */
  if noEvent(Ev.h < HsatvC) then
    0 = Ev.Q*(Ev.h - HsateC) + Wflash - Ee.Q*(HDesF - HeiF) + J/3;
  else
    0 = Ev.Q*(HsatvC - HsateC) + Wflash - Ee.Q*(HDesF - HeiF) + J/3;
  end if;

  Wcond = Ee.Q*(HDesF - HeiF);
  Wcond = Ee.Q*cp_mcF*ThermoSysPro.Correlations.Thermal.WBHeatExchangerEfficiency(Ev.Q, Ee.Q, 1.e20, cp_mcF, KCond, (SCondDes - SDes), 0.5)*(TsatC - TeiF);

  // Flash zone
  //-----------

  /* Heat power in case of partial vaporization in the drain */
  if (x_flashepC > 0) then
    Wflash = Ep.Q*(Ep.h - HsateC);
  else
    Wflash = 0;
  end if;

  /* Condition for partial vaporisation in the drain (flash) */
  if (x_flashepC > 0) then
    Hep = HsateC;
  else
    Sp.Q*Hep = HsateC*Ev.Q + Ep.h*Ep.Q;
  end if;

  // Drain cooling zone
  //-------------------

  /* Power, fluid specific enthalpy at the cold outlet and temperature of the drain outlet */
  if noEvent(SPurge > 0) then
    0 = Sp.Q*(Hep - Sp.h) - Ee.Q*(HeiF - Ee.h) + J/3;
    Wpurge = Ee.Q*(HeiF - Ee.h);
    Wpurge = noEvent(min(Sp.Q*cp_mpC, Ee.Q*cp_mpF)*ThermoSysPro.Correlations.Thermal.WBHeatExchangerEfficiency(Sp.Q, Ee.Q, cp_mpC, cp_mpF, KPurge, SPurge, 0)*(T_sp - T_eeF));
    TeiF = Medium_e.temperature(state_ecF);
  else
    HeiF = Ee.h;
    Wpurge = 0;
    Hep = Sp.h;
    TeiF = T_eeF;
  end if;

  /* Fluid composition balance equations */
  zeros(Medium_c.nXi) = Ep.Xi*Ep.Q + Ev.Xi*Ev.Q - Sp.Xi*Sp.Q;
  zeros(Medium_c.nC) = Ep.SubC*Ep.Q + Ev.SubC*Ev.Q - Sp.SubC*Sp.Q;

  Xc = Sp.Xi;
  SubCc = Sp.SubC;

  /* Flow reversal */
  if continuous_flow_reversal then
    Sp.h = ThermoSysPro.Functions.SmoothCond(Sp.Q/gamma_sp, Sp.h_vol_1, Sp.h_vol_2, 1);
  else
    Sp.h = if (Sp.Q > 0) then Sp.h_vol_1 else Sp.h_vol_2;
  end if;

  /* Diffusion power */
  if diffusion then
    rep = if Ep.diff_on_1 then exp(-0.033*(Ep.Q*Ep.diff_res_1)^2) else 0;
    rev = if Ev.diff_on_1 then exp(-0.033*(Ev.Q*Ev.diff_res_1)^2) else 0;
    rsp = if Sp.diff_on_2 then exp(-0.033*(Sp.Q*Sp.diff_res_2)^2) else 0;

    gamma_ep = if Ep.diff_on_1 then 1/Ep.diff_res_1 else gamma0;
    gamma_ev = if Ev.diff_on_1 then 1/Ev.diff_res_1 else gamma0;
    gamma_sp = if Sp.diff_on_2 then 1/Sp.diff_res_2 else gamma0;

    Jep = if Ep.diff_on_1 then rep*gamma_ep*(Ep.h_vol_1 - Ep.h_vol_2) else 0;
    Jev = if Ev.diff_on_1 then rev*gamma_ev*(Ev.h_vol_1 - Ev.h_vol_2) else 0;
    Jsp = if Sp.diff_on_2 then rsp*gamma_sp*(Sp.h_vol_2 - Sp.h_vol_1) else 0;
  else
    rep = 0;
    rev = 0;
    rsp = 0;

    gamma_ep = gamma0;
    gamma_ev = gamma0;
    gamma_sp = gamma0;

    Jep = 0;
    Jev = 0;
    Jsp = 0;
  end if;

  J = Jep + Jev + Jsp;

  Ep.diff_res_2 = 0;
  Ev.diff_res_2 = 0;
  Sp.diff_res_1 = 0;

  Ep.diff_on_2 = diffusion;
  Ev.diff_on_2 = diffusion;
  Sp.diff_on_1 = diffusion;

  /* Fluid thermodynamic properties */
  state_eeF = Medium_e.setState_phX(p=Ee.P, h=Ee.h, X=Xe);
  state_seF = Medium_e.setState_phX(p=Se.P, h=Se.h, X=Xe);
  state_meF = Medium_e.setState_phX(p=(Ee.P + Se.P)/2, h=(Ee.h + Se.h)/2, X=Xe);
  state_evC = Medium_c.setState_phX(p=Ev.P, h=Ev.h, X=Ev.Xi);
  state_spC = Medium_c.setState_phX(p=Sp.P, h=Sp.h, X=Xc);
  state_sp = Medium_c.setState_phX(p=Ev.P, h=Hep, X=Xc);
  state_desF = Medium_e.setState_phX(p=Se.P, h=HDesF, X=Xe);
  state_mpC = Medium_c.setState_phX(p=Ev.P, h=(Hep + Sp.h)/2, X=Xc);
  state_desmC = Medium_c.setState_phX(p=Ev.P, h=(HsatvC + Ev.h)/2, X=Ev.Xi);
  state_mpF = Medium_e.setState_phX(p=Ee.P, h=(Ee.h + HeiF)/2, X=Xe);
  state_mcF = Medium_e.setState_phX(p=(Ee.P + Se.P)/2, h=(HeiF + HDesF)/2, X=Xe);
  state_desmF = Medium_e.setState_phX(p=Se.P, h=(HDesF + Se.h)/2, X=Xe);
  state_ecF = Medium_e.setState_phX(p=Ee.P, h=HeiF, X=Xe);
  cp_desmC = Medium_c.specificHeatCapacityCp(state_desmC);
  cp_mcF = Medium_e.specificHeatCapacityCp(state_mcF);
  cp_desmF = Medium_e.specificHeatCapacityCp(state_desmF);
  cp_mpC = Medium_c.specificHeatCapacityCp(state_mpC);
  cp_mpF = Medium_e.specificHeatCapacityCp(state_mpF);

  T_evC = Medium_c.temperature(state_evC);
  T_desF = Medium_e.temperature(state_desF);
  T_sp = Medium_c.temperature(state_sp);
  T_eeF = Medium_e.temperature(state_eeF);

  x_flashepC = noEvent(if (Ep.h <= HsateC) then 0 else if (Ep.h >= HsatvC) then 1 else (Ep.h - HsateC)/(HsatvC - HsateC));

  /* Fluid density */
  rho = Medium_e.density(state_meF);

  /* Saturation point at the vapor inlet pressure */
  satC = Medium_c.setSat_p(Ev.P);
  state_lsatC = Medium_c.setBubbleState(satC);
  state_vsatC = Medium_c.setDewState(satC);

  TsatC  = Medium_c.saturationTemperature(Ev.P);
  HsateC = Medium_c.specificEnthalpy(state_lsatC);
  HsatvC = Medium_c.specificEnthalpy(state_vsatC);

  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2},
        initialScale=0.01), graphics={
        Ellipse(
          extent={{-100,-30},{-36,32}},
          lineColor={0,0,0},
          lineThickness=0,
          fillColor= DynamicSelect({85,170,255},
          if diffusion then fill_color_singular
          else fill_color_static),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{38,-30},{102,32}},
          lineColor={0,0,0},
          lineThickness=0,
          fillColor= DynamicSelect({85,170,255},
          if diffusion then fill_color_singular
          else fill_color_static),
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-68,32},{74,-30}},
          lineColor={0,0,0},
          fillColor=DynamicSelect({85,170,255},
          if diffusion then fill_color_singular
          else fill_color_static),
          fillPattern=FillPattern.Solid),
        Line(
          points={{-70,32},{74,32},{74,32}},
          color={0,0,0}),
        Line(
          points={{-70,-30},{74,-30},{74,-30}},
          color={0,0,0},
          thickness=0),
        Line(
          points={{74,32},{74,-30}},
          color={0,0,0},
          thickness=0),
        Line(
          points={{74,0},{102,0}},
          color={0,0,0},
          thickness=0),
        Rectangle(
          extent={{-58,-14},{74,-16}},
          lineColor={0,0,0},
          lineThickness=0,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-58,16},{74,14}},
          lineColor={0,0,0},
          lineThickness=0,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-78,-16},{-44,16}},
          lineColor={0,0,0},
          lineThickness=0,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-76,-14},{-48,14}},
          lineColor={0,0,0},
          lineThickness=0,
          fillColor= DynamicSelect({85,170,255},
          if diffusion then fill_color_singular
          else fill_color_static),
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-62,14},{72,-14}},
          lineColor={0,0,0},
          fillColor= DynamicSelect({85,170,255},
          if diffusion then fill_color_singular
          else fill_color_static),
          fillPattern=FillPattern.Solid),
        Line(
          points={{-96,-12},{74,-12}},
          color={0,0,127},
          pattern=LinePattern.Dash),
        Line(
          points={{-92,-18},{74,-18}},
          color={0,0,127},
          pattern=LinePattern.Dash),
        Line(
          points={{-86,-24},{74,-24}},
          color={0,0,127},
          pattern=LinePattern.Dash),
        Text(
          extent={{-112,22},{-90,12}},
          lineColor={0,0,0},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Water inlet"),
        Text(
          extent={{88,22},{112,8}},
          lineColor={0,0,0},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Water outlet"),
        Text(
          extent={{48,58},{72,44}},
          lineColor={0,0,0},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Steam inlet"),
        Text(
          extent={{-72,56},{-50,44}},
          lineColor={0,0,0},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Drain inlet"),
        Text(
          extent={{-70,-46},{-46,-58}},
          lineColor={0,0,0},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Drain outlet")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2},
        initialScale=0.01), graphics={
        Line(
          points={{-40,-40},{20,-24}},
          color={0,0,255},
          thickness=0.5,
          arrow={Arrow.None,Arrow.Filled}),
        Line(
          points={{-40,-20},{-20,0}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{-20,0},{20,0}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{60,0},{80,20}},
          color={255,0,0},
          thickness=0.5),
        Text(
          extent={{76,28},{84,20}},
          lineColor={0,0,0},
          lineThickness=0,
          textString=
               "1C"),
        Text(
          extent={{56,10},{64,2}},
          lineColor={0,0,0},
          lineThickness=0,
          textString=
               "2C"),
        Text(
          extent={{-24,8},{-16,0}},
          lineColor={0,0,0},
          lineThickness=0,
          textString=
               "3C"),
        Text(
          extent={{-44,-10},{-36,-18}},
          lineColor={255,0,0},
          lineThickness=0,
          textString=
               "4C"),
        Text(
          extent={{76,-10},{82,-16}},
          lineColor={0,0,0},
          lineThickness=0,
          textString=
               "1F"),
        Text(
          extent={{58,-18},{64,-24}},
          lineColor={0,0,0},
          lineThickness=0,
          textString=
               "2F"),
        Text(
          extent={{-22,-38},{-16,-44}},
          lineColor={0,0,0},
          lineThickness=0,
          textString=
               "3F"),
        Text(
          extent={{-42,-44},{-36,-50}},
          lineColor={0,0,0},
          lineThickness=0,
          textString=
               "4F"),
        Line(
          points={{20,0},{60,0}},
          color={255,0,0},
          thickness=0.5,
          arrow={Arrow.Filled,Arrow.None}),
        Line(
          points={{20,-24},{80,-8}},
          color={0,0,255},
          thickness=0.5),
        Text(
          extent={{-40,8},{-24,2}},
          lineColor={0,0,0},
          lineThickness=0,
          textString=
               "Drain"),
        Text(
          extent={{66,-18},{82,-24}},
          lineColor={0,0,0},
          lineThickness=0,
          textString=
               "Deheating"),
        Text(
          extent={{-36,-18},{-16,-24}},
          lineColor={0,0,0},
          lineThickness=0,
          textString=
               "Drain cooling"),
        Line(
          points={{-26,4},{-22,0}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.None,Arrow.Filled}),
        Line(
          points={{-40,-20},{-40,-40}},
          color={0,0,0},
          pattern=LinePattern.Dot),
        Line(
          points={{-20,0},{-20,-34}},
          color={0,0,0},
          pattern=LinePattern.Dot),
        Line(
          points={{60,0},{60,-14}},
          color={0,0,0},
          pattern=LinePattern.Dot),
        Line(
          points={{80,20},{80,-8}},
          color={0,0,0},
          pattern=LinePattern.Dot),
        Text(
          extent={{48,50},{74,44}},
          lineColor={0,0,255},
          textString=
               "Vapor inlet"),
        Text(
          extent={{-74,52},{-48,46}},
          lineColor={0,0,255},
          textString=
               "Drain inlet"),
        Text(
          extent={{-74,-16},{-48,-22}},
          lineColor={0,0,255},
          textString=
               "Drain outlet"),
        Text(
          extent={{-114,18},{-88,12}},
          lineColor={0,0,255},
          textString=
               "Water inlet"),
        Text(
          extent={{86,18},{112,12}},
          lineColor={0,0,255},
          textString=
               "Water outlet"),
        Text(
          extent={{12,-10},{34,-18}},
          lineColor={0,0,255},
          lineThickness=0,
          textString=
               "Condensation"),
        Text(
          extent={{-26,-4},{-12,-8}},
          lineColor={0,0,255},
          lineThickness=0,
          textString=
               "Flash")}),
    Window(
      x=0.05,
      y=0.01,
      width=0.93,
      height=0.87),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
This component model is documented in Sect. 9.5.5 of the ThermoSysPro book.   
    ", revisions = "
Author  

Baligh El Hefni   

    "),
    DymolaStoredErrors);
end NTUWaterHeater;
