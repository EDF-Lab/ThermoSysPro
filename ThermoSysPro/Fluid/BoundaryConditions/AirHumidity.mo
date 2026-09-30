within ThermoSysPro.Fluid.BoundaryConditions;

model AirHumidity "Air humidity"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium = ThermoSysPro.Properties.Media.FlueGases constrainedby Modelica.Media.Interfaces.PartialMixtureMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  parameter Real hum0=0.5 "Air humidiy";
  parameter Units.SI.Temperature T0=290 "Fixed fluid temperature";

public
  Units.SI.AbsolutePressure ppvap0(start=1e4)
    "Intermediate vapor partial pressure";
  Units.SI.Density rho_vap0(start=200) "Intermediate H2O density";
  Units.SI.AbsolutePressure P "Air pressure";
  Units.SI.MassFlowRate Q "Air mass flow rate";
  Units.SI.SpecificEnthalpy h "Air specific enthalpy";
  Units.SI.Temperature T "Air temperature";
  Units.SI.Density rho_vap(start = 200) "H20 density";
  Units.SI.Density rho_air(start = 0.8) "Air density";
  Units.SI.AbsolutePressure psvap(start = 1e5) "Vapor saturation pressure in the air";
  Units.SI.AbsolutePressure ppvap(start = 1e4) "Vapor partial pressure";
  Units.SI.AbsolutePressure ppair "Air partial pressure";
  Real hum "Air relative humidity";
  Real Xo2as(start=0.2) "O2 mass fraction in dry air";
  Real Xh2o "H2O mass fraction at the outlet";

public
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_pT pro
    annotation (Placement(transformation(extent={{-100,80},{-80,100}}, rotation=
           0)));
  Interfaces.Connectors.FluidInlet C1(redeclare package Medium=Medium) annotation (Placement(transformation(
          extent={{-110,-10},{-90,10}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal humidity
    "Air humidity"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Interfaces.Connectors.FluidOutlet C2(redeclare package Medium=Medium) annotation (Placement(transformation(
          extent={{90,-10},{110,10}}, rotation=0)));
protected
  parameter Integer iN2 = ThermoSysPro.Properties.Media.Functions.findSubstanceIndex(Medium.substanceNames, {"Nitrogen"});
  parameter Integer iO2 = ThermoSysPro.Properties.Media.Functions.findSubstanceIndex(Medium.substanceNames, {"Oxygen"});
  parameter Integer iH2O = ThermoSysPro.Properties.Media.Functions.findSubstanceIndex(Medium.substanceNames, {"Water"});
  parameter Integer iCO2 = ThermoSysPro.Properties.Media.Functions.findSubstanceIndex(Medium.substanceNames, {"Carbondioxide"});
  parameter Integer iSO2 = ThermoSysPro.Properties.Media.Functions.findSubstanceIndex(Medium.substanceNames, {"Sulfurdioxide"});
equation
  if (cardinality(humidity) == 0) then
    humidity.signal = hum0;
  end if;
  hum = humidity.signal;
  C1.P = C2.P;
  C1.Q = C2.Q;
  C1.h = C2.h;
  C1.h_vol_1 = C2.h_vol_1;
  C1.h_vol_2 = C2.h_vol_2;
  C2.diff_on_1 = C1.diff_on_1;
  C1.diff_on_2 = C2.diff_on_2;
  C2.diff_res_1 = C1.diff_res_1;
  C1.diff_res_2 = C2.diff_res_2;

  C1.SubC = C2.SubC;

  P = C1.P;
  Q = C1.Q;
  h = C1.h;

  /* O2 mass fraction at the inlet */
  Xo2as = C1.Xi[iO2];

  /* Temperature at the outlet */
//   T = ThermoSysPro.Properties.FlueGases.FlueGases_T(P, h, 0, Xh2o, Xo2as, 0);
  T = Medium.temperature_phX(P,h, C2.Xi);

  /* Flue gas composition at the outlet. The sole constituents for air are O2 and N2 */
  C2.Xi[iSO2] = 0;
  C2.Xi[iCO2] = 0;
  Xh2o = rho_vap/(rho_vap + rho_air);
  C2.Xi[iH2O] = Xh2o;
  C2.Xi[iO2] = Xo2as*(1 - Xh2o);
  C2.Xi[iN2] = 1- Xo2as*(1 - Xh2o) - Xh2o;

  /* Vapor partial pressure */
  ppvap = psvap*hum;
  0 = if (ppvap < 0.061080e-4) then ppvap0 - 0.061080e-4 else ppvap - ppvap0;
/* Air partial pressure */
  ppair = P - ppvap;
/* Vapor saturation pressure */
  psvap = ThermoSysPro.Properties.WaterSteam.BaseIF97.Basic.psat(T);

  /* H2O density */
  pro = ThermoSysPro.Properties.WaterSteam.IF97.Water_PT(ppvap, T, 0);

  rho_vap0 = pro.d;
  0 = if (ppvap < 0.061080e-4) then rho_vap - (rho_vap0*ppvap/ppvap0) else rho_vap - rho_vap0;

  /* Air density */
  rho_air = ThermoSysPro.Properties.FlueGases.FlueGases_rho(ppair, T, 0, Xh2o, Xo2as, 0);

  annotation (Diagram(graphics={
        Ellipse(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Line(points={{0,100},{0,40}}, color={0,0,255}),
        Line(points={{20,60},{0,40},{-20,60}}, color={0,0,255}),
        Line(points={{-90,0},{-40,0}}, color={0,0,255}),
        Line(points={{40,0},{90,0}}, color={0,0,255}),
        Text(
          extent={{-28,30},{28,-26}},
          lineColor={0,0,255},
          fillColor={128,255,0},
          fillPattern=FillPattern.Solid,
          textString=
               "H2O")}),                 Icon(graphics={
        Ellipse(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,255},
          fillColor=DynamicSelect({255,255,0}, fill_color_static),
          fillPattern=FillPattern.Solid),
        Line(points={{0,100},{0,40}}, color={0,0,255}),
        Line(points={{20,60},{0,40},{-20,60}}, color={0,0,255}),
        Line(points={{-90,0},{-40,0}}, color={0,0,255}),
        Line(points={{40,0},{90,0}}, color={0,0,255}),
        Text(
          extent={{-28,30},{28,-26}},
          lineColor={0,0,255},
          fillColor={128,255,0},
          fillPattern=FillPattern.Solid,
          textString=
               "H2O")}),
    Documentation(revisions = "
Author  

Baligh El Hefni   

    ", info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
    "));
end AirHumidity;
