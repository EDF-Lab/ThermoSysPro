within ThermoSysPro.Fluid.HeatExchangers;
model StaticAerocondenser "Static aerocondenser"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialTwoPhaseThermoSysProMedium "Medium model for the condensing side" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  replaceable package Medium_Air = ThermoSysPro.Properties.Media.FlueGases constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model for the air side" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));

  parameter Units.SI.CoefficientOfHeatTransfer Uref=50
    "Reference heat transfer coefficient between the air and the condenser external wall";
  parameter Real UCOR=1. "Heat transfer corrective coefficient";
  parameter Units.SI.Area Se=1.e4 "Condenser external wall area";
  parameter Units.SI.Height z=0 "Water level in the condenser";
  parameter Real K=0.02 "Pressure loss coefficient for the water/steam pipe (Pa.s2/(kg.m3))";
  parameter Real Ka=0.00 "Pressure loss coefficient for the air (Pa.s2/(kg.m3))";
  parameter Units.SI.MassFlowRate gamma_diff=1e-4
    "Air diffusion conductance (active if diffusion=true in neighbouring volumes)";
  parameter Boolean continuous_flow_reversal=false "true: continuous flow reversal - false: discontinuous flow reversal";
  parameter Boolean diffusion=false "true: energy balance equation with diffusion - false: energy balance equation without diffusion";
protected
  constant Units.SI.Acceleration g=Modelica.Constants.g_n "Gravity constant";
  parameter Units.SI.MassFlowRate gamma0=1.e-4
    "Pseudo-diffusion conductance use for continuous flow reversal (active if diffusion=false and continuous_flow_reversal = true)";

public
  Units.SI.SpecificEnthalpy he(start=370000)
    "Water specific enthalpy at the outlet of the condenser";
  Units.SI.SpecificEnthalpy hae(start=75000)
    "Air specific enthalpy at the inlet of the condenser";
  Units.SI.SpecificEnthalpy has(start=100000)
    "Air specific enthalpy at the outlet of the condenser";
  Units.SI.MassFlowRate Q(start=1.5e2)
    "Fluid mass flow rate in the water/steam pipe";
  Units.SI.MassFlowRate Qa(start=1.4e3) "Air mass flow rate in the condenser";
  Units.SI.Temperature Tae(start=290)
    "Air temperature at the inlet of the condenser";
  Units.SI.Temperature Tas(start=360)
    "Air temperature at the outlet of the condenser";
  Units.SI.AbsolutePressure Pae(start=1.e5)
    "Air pressure at the inlet of the condenser";
  Units.SI.AbsolutePressure Pas(start=1.e5)
    "Air pressure at the outlet of the condenser";
  Units.SI.AbsolutePressure Pfond(start=30000)
    "Water pressure at the bottom of the condenser";
  Units.SI.AbsolutePressure Pcond(start=17000) "Condensation pressure (vacuum)";
  Units.SI.Temperature Tcond(start=360) "Condensation temperature";
  ThermoSysPro.Units.SI.PressureDifference deltaP "Total air pressure loss";
  Units.SI.CoefficientOfHeatTransfer U(start=50) "Heat transfer coefficient";
  Units.SI.SpecificHeatCapacity cp_a(start=1000)
    "Air specific heat capacity at constant pressure";
  Real Nut(start=2.) "Number of transfer units";
  Real Ef(start=0.8) "Efficiency in two-phase flow regime";
  Units.SI.Power W "Heat power transfered to the cooling air";
  Units.SI.Density rho_e(start=998)
    "Water density at the outlet of the condenser";
  Units.SI.Density rho_a(start=1) "Air density";
  Units.SI.Power Jws1 "Thermal power diffusion from inlet Cws1";
  Units.SI.Power Jw "Thermal power diffusion from inlet Cw";
  Units.SI.Power Jws2 "Thermal power diffusion from outlet Cws2";
  Units.SI.Power J "Total thermal power diffusion for the liquid in the cavity";
  Units.SI.MassFlowRate gamma_ws1 "Diffusion conductance for inlet Cws1";
  Units.SI.MassFlowRate gamma_w "Diffusion conductance for inlet Cw";
  Units.SI.MassFlowRate gamma_ws2 "Diffusion conductance for outlet Cws2";
  Real rws1 "Value of r(Q/gamma) for inlet Cws1";
  Real rw "Value of r(Q/gamma) for inlet Cw";
  Real rws2 "Value of r(Q/gamma) for outlet Cws1";
  Medium.MassFraction X[Medium.nXi](start=Medium.X_default[1:Medium.nXi]) "Mass fractions in the condenser cavity";
  Medium.ExtraProperty SubC[Medium.nC](start=Medium.C_default) "Trace substance concentrations in the condenser cavity";
  Medium_Air.MassFraction X_Air[Medium_Air.nXi](start=Medium_Air.X_default[1:Medium_Air.nXi]) "Air mass fractions";
  Medium.SaturationProperties sat "Saturation properties inside the condenser";

public
  Interfaces.Connectors.FluidInlet Cws1(redeclare package Medium = Medium) annotation (Placement(transformation(
          extent={{-10,100},{10,120}}, rotation=0)));
  Interfaces.Connectors.FluidOutlet Cws2(redeclare package Medium = Medium) annotation (Placement(transformation(
          extent={{-10,-120},{10,-100}}, rotation=0)));
  Interfaces.Connectors.FluidInlet Cair1(redeclare package Medium = Medium_Air) annotation (Placement(transformation(
          extent={{100,-119},{120,-99}}, rotation=0)));
  Interfaces.Connectors.FluidOutlet Cair2(redeclare package Medium = Medium_Air) annotation (Placement(transformation(
          extent={{100,100},{120,120}}, rotation=0)));
public
  Interfaces.Connectors.FluidInlet Cw(redeclare package Medium = Medium) annotation (Placement(transformation(
          extent={{-120,-100},{-100,-80}}, rotation=0), iconTransformation(
          extent={{-120,-100},{-100,-80}})));
equation
  /* Unconnected connectors */
  if (cardinality(Cw) == 0) then
    Cw.Q = 0;
    Cw.h = 1.e5;
    Cw.h_vol_1 = 1.e5;
    Cw.diff_res_1 = 0;
    Cw.diff_on_1 = false;
    Cw.Xi = Medium.X_default[1:Medium.nXi];
    Cw.SubC = Medium.C_default;
  end if;

  /* Pressure at the bottom of the condenser*/
  Pfond = Pcond + rho_e*g*z;

  /* Water/steam mass balance equation */
  0 = Cws1.Q + Cw.Q - Cws2.Q;

  Q = Cws2.Q;

  Pcond = Cws1.P;
  Pcond = Cw.P;
  Pfond = Cws2.P;

  /* Water/steam energy balance equation */
  0 = (Cws1.h - he)*Cws1.Q + (Cw.h - he)*Cw.Q - (Cws2.h - he)*Cws2.Q - W + J;

  Cws1.h_vol_2 = he;
  Cw.h_vol_2 = he;
  Cws2.h_vol_1 = he;

  /* Fluid composition in the cavity (no balance equations) */
  X = Cws1.Xi;
  SubC = Cws1.SubC;
  Cws2.Xi = X;
  Cws2.SubC = SubC;

  /* Air inlet and outlet */
  Cair1.Q = Cair2.Q;

  Cair1.h_vol_1 = Cair2.h_vol_1;
  Cair1.h_vol_2 = Cair2.h_vol_2;

  Cair2.diff_on_1 = Cair1.diff_on_1;
  Cair1.diff_on_2 = Cair2.diff_on_2;

  Cair2.diff_res_1 = Cair1.diff_res_1 + 1/gamma_diff;
  Cair1.diff_res_2 = Cair2.diff_res_2 + 1/gamma_diff;

  Cair1.Xi = Cair2.Xi;
  Cair1.SubC = Cair2.SubC;
  X_Air = Cair1.Xi;

  Qa = Cair1.Q;
  Pae = Cair1.P;
  Pas = Cair2.P;
  hae = Cair1.h;
  has = Cair2.h;

  deltaP = Cair1.P - Cair2.P;

  /* Air pressure loss */
  deltaP = Ka*Qa*abs(Qa)/rho_a;

  /* Heat power transferred to the cooling water */
  W = Qa*(has - hae);

  /* Heat exchange coefficient */
  U = UCOR*Uref*(-2.e-4*(Tae - 273.16)^2 + 0.0187*(Tae - 273.16) + 0.5007);

  /* Number of transfer units */
  Nut = if noEvent(Qa*cp_a > 0) then Se*U/(Qa*cp_a) else 2.;

  /* Efficiency in the two-phase flow regime */
  Ef = 1 - exp(-Nut);

  /* Flow reversal */
  if continuous_flow_reversal then
    Cws2.h = ThermoSysPro.Functions.SmoothCond(Cws2.Q/gamma_ws2, Cws2.h_vol_1, Cws2.h_vol_2, 1);
  else
    Cws2.h = if (Cws2.Q > 0) then Cws2.h_vol_1 else Cws2.h_vol_2;
  end if;

  /* Diffusion power */
  if diffusion then
    rws1 = if Cws1.diff_on_1 then exp(-0.033*(Cws1.Q*Cws1.diff_res_1)^2) else 0;
    rw = if Cw.diff_on_1 then exp(-0.033*(Cw.Q*Cw.diff_res_1)^2) else 0;
    rws2 = if Cws2.diff_on_2 then exp(-0.033*(Cws2.Q*Cws2.diff_res_2)^2) else 0;

    gamma_ws1 = if Cws1.diff_on_1 then 1/Cws1.diff_res_1 else gamma0;
    gamma_w = if Cw.diff_on_1 then 1/Cw.diff_res_1 else gamma0;
    gamma_ws2 = if Cws2.diff_on_2 then 1/Cws2.diff_res_2 else gamma0;

    Jws1 = if Cws1.diff_on_1 then rws1*gamma_ws1*(Cws1.h_vol_1 - Cws1.h_vol_2) else 0;
    Jw = if Cw.diff_on_1 then rw*gamma_w*(Cw.h_vol_1 - Cw.h_vol_2) else 0;
    Jws2 = if Cws2.diff_on_2 then rws2*gamma_ws2*(Cws2.h_vol_2 - Cws2.h_vol_1) else 0;
  else
    rws1 = 0;
    rw = 0;
    rws2 = 0;

    gamma_ws1 = gamma0;
    gamma_w = gamma0;
    gamma_ws2 = gamma0;

    Jws1 = 0;
    Jw = 0;
    Jws2 = 0;
   end if;

  J = Jws1 + Jw + Jws2;

  Cws1.diff_res_2 = 0;
  Cw.diff_res_2 = 0;
  Cws2.diff_res_1 = 0;

  Cws1.diff_on_2 = diffusion;
  Cw.diff_on_2 = diffusion;
  Cws2.diff_on_1 = diffusion;

  /* Condensation temperature */
  Tcond = ((Tas + Tae*(Ef - 1.0))/Ef);

  /* Condensation pressure */
  Pcond = Medium.saturationPressure(Tcond);

  /* Water/steam thermodynamic properties */
  rho_e = Medium.density_phX(p=(Pfond + Pcond)/2, h=he, X=X);

  /* Water specific enthalpy at the saturation point with pressure Pcond */
  sat = Medium.setSat_p(Pcond);
  he = Medium.bubbleEnthalpy(sat);

  /* Air thermodynamic properties */
  Tae = Medium_Air.temperature_phX(p=Pae, h=hae, X=X_Air);
  has = Medium_Air.specificEnthalpy_pTX(p=Pas, T=Tas, X=X_Air);
  rho_a = Medium_Air.density_phX(p=Pae, h=hae, X=X_Air);
  cp_a = Medium_Air.specificHeatCapacityCp(Medium_Air.setState_pTX(p=(Pae + Pas)/2, T=(Tae + Tas)/2, X=X_Air));

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-120,-120},{120,120}},
        grid={2,2}), graphics={
        Text(
          extent={{86,112},{98,102}},
          lineColor={0,0,0},
          lineThickness=1,
          fillPattern=FillPattern.Sphere,
          fillColor={191,0,0},
          textString=
               "Air"),
        Text(
          extent={{82,-106},{94,-116}},
          lineColor={0,0,0},
          lineThickness=1,
          fillPattern=FillPattern.Sphere,
          fillColor={191,0,0},
          textString=
               "Air"),
        Text(
          extent={{-36,-112},{-12,-120}},
          lineColor={0,0,0},
          lineThickness=1,
          fillPattern=FillPattern.Sphere,
          fillColor={191,0,0},
          textString=
               "Water"),
        Text(
          extent={{-38,114},{-12,106}},
          lineColor={0,0,0},
          lineThickness=1,
          fillPattern=FillPattern.Sphere,
          fillColor={191,0,0},
          textString=
               "Steam"),
        Polygon(
          points={{100,-62},{0,100},{0,100},{-100,-62},{100,-62}},
          lineColor={28,108,200},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{89,40},{79,20},{99,20},{89,40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.Sphere,
          fillColor={191,0,0}),
        Line(
          points={{89,20},{89,4}},
          color={0,0,0},
          thickness=1),
        Ellipse(
          extent={{-20,100},{20,60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,0,0}),
        Ellipse(
          extent={{60,-39},{100,-79}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,128,255}),
        Ellipse(
          extent={{-100,-39},{-60,-79}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,128,255}),
        Polygon(
          points={{-28,30},{-36,34},{-16,68},{-8,64},{-28,30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0}),
        Polygon(
          points={{-49,-6},{-57,-2},{-36,34},{-28,30},{-49,-6}},
          lineColor={255,128,0},
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-71,-44},{-79,-40},{-57,-2},{-49,-6},{-71,-44}},
          lineColor={0,128,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{38,33},{30,29},{9,64},{16,69},{38,33}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0}),
        Polygon(
          points={{60,-6},{52,-10},{30,29},{38,33},{60,-6}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,128,0}),
        Polygon(
          points={{80,-40},{70,-42},{52,-10},{60,-6},{80,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,128,255}),
        Polygon(
          points={{-5,-48},{55,-38},{55,-58},{-5,-48},{-5,-48}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{5,-48},{-55,-58},{-55,-38},{5,-48},{5,-48}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-100,-79},{-80,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,255,255}),
        Ellipse(
          extent={{80,-79},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,255,255}),
        Rectangle(
          extent={{-89,-79},{90,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,255,255}),
        Text(
          extent={{-38,22},{36,-38}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,0},
          textString=
               "Volume")}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-120,-120},{120,120}},
        grid={2,2}), graphics={
        Polygon(
          points={{100,-62},{0,100},{0,100},{-100,-62},{100,-62}},
          lineColor={0,255,0},
          fillColor= DynamicSelect({85,170,255},
          if diffusion then fill_color_singular
          else fill_color_static),
          fillPattern=FillPattern.Solid,
          lineThickness=0),
        Line(
          points={{110,20},{110,-8}},
          color={0,0,0},
          thickness=0),
        Ellipse(
          extent={{-20,100},{20,60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,0,0}),
        Ellipse(
          extent={{60,-39},{100,-79}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,128,255}),
        Ellipse(
          extent={{-100,-39},{-60,-79}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,128,255}),
        Polygon(
          points={{-28,30},{-36,34},{-16,68},{-8,64},{-28,30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0}),
        Polygon(
          points={{-49,-6},{-57,-2},{-36,34},{-28,30},{-49,-6}},
          lineColor={255,128,0},
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-71,-44},{-79,-40},{-57,-2},{-49,-6},{-71,-44}},
          lineColor={0,128,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{38,33},{30,29},{9,64},{16,69},{38,33}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0}),
        Polygon(
          points={{60,-6},{52,-10},{30,29},{38,33},{60,-6}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,128,0}),
        Polygon(
          points={{80,-40},{70,-42},{52,-10},{60,-6},{80,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,128,255}),
        Polygon(
          points={{-5,-48},{55,-38},{55,-58},{-5,-48},{-5,-48}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{5,-48},{-55,-58},{-55,-38},{5,-48},{5,-48}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{80,-79},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,255,255}),
        Ellipse(
          extent={{-100,-79},{-80,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,255,255}),
        Rectangle(
          extent={{-89,-79},{90,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,255,255}),
        Text(
          extent={{20,120},{54,100}},
          lineColor={238,46,47},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Steam inlet"),
        Text(
          extent={{126,116},{154,100}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Air outlet"),
        Text(
          extent={{126,-104},{150,-116}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Air inlet"),
        Line(
          points={{110,-99},{110,104}},
          color={28,108,200},
          thickness=1),
        Polygon(
          points={{110,12},{100,-8},{120,-8},{110,12}},
          lineColor={0,0,0},
          lineThickness=0,
          fillPattern=FillPattern.Sphere,
          fillColor={191,0,0})}),
    Window(
      x=0.09,
      y=0.08,
      width=0.76,
      height=0.76),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
    ", revisions = "
Author  

Baligh El Hefni   

    "));
end StaticAerocondenser;
