within ThermoSysPro.Fluid.HeatExchangers;
model SimpleEvaporatorWaterSteamFlueGases "Simple water/steam - flue gases evaporator"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialTwoPhaseThermoSysProMedium "Medium model for the water/steam side" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  replaceable package Medium_FlueGases = ThermoSysPro.Properties.Media.FlueGases constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model for the flue gases side" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));

  parameter Real Kdpf=10 "Flue gases pressure drop coefficient";
  parameter Real Kdpe=10 "Water/steam pressure drop coefficient";
  parameter Units.SI.MassFlowRate gamma_diff_ws=1e-4
    "Diffusion conductance for the water/steam side (active if diffusion=true in neighbouring volumes)";
  parameter Units.SI.MassFlowRate gamma_diff_fg=1e-4
    "Diffusion conductance for the flue gases side (active if diffusion=true in neighbouring volumes)";

protected
  parameter Real eps=1.e-0 "Small number for pressure loss equation";

public
  Units.SI.AbsolutePressure Pef(start=3e5) "Flue gases pressure at the inlet";
  Units.SI.AbsolutePressure Psf(start=2.5e5)
    "Flue gases pressure at the outlet";
  Units.SI.Temperature Tef(start=600) "Flue gases temperature at the inlet";
  Units.SI.Temperature Tsf(start=400) "Flue gases temperature at the outlet";
  Units.SI.SpecificEnthalpy Hsf(start=3e5)
    "Flue gases specific enthalpy at the outlet";
  Units.SI.SpecificEnthalpy Hef(start=6e5)
    "Flue gases specific enthalpy at the inlet";
  Units.SI.MassFlowRate Qf(start=10) "Flue gases mass flow rate";
  Units.SI.AbsolutePressure Pee(start=2e6) "Water pressure at the inlet";
  Units.SI.AbsolutePressure Pse(start=2e6) "Water pressure at the outlet";
  Units.SI.Temperature Tee(start=400) "Water temperature at the inlet";
  Units.SI.Temperature Tse(start=450) "Water temperature at the outlet";
  Units.SI.SpecificEnthalpy Hee(start=3e5)
    "Water specific enthalpy at the inlet";
  Units.SI.SpecificEnthalpy Hse(start=20e5)
    "Water specific enthalpy at the outlet";
  Units.SI.MassFlowRate Qe(start=10) "Water mass flow rate";
  Units.SI.Density rhof(start=0.9) "Flue gases density";
  Units.SI.Density rhoe(start=700) "Water density";
  Units.SI.Power W(start=1e8) "Power exchanged";
  Medium.MassFraction Xws[Medium.nXi](start=Medium.X_default[1:Medium.nXi]) "Water/steam mass fractions";
  Medium_FlueGases.MassFraction Xfg[Medium_FlueGases.nXi](start=Medium_FlueGases.X_default[1:Medium_FlueGases.nXi]) "Flue gases mass fractions";
  Medium.ExtraProperty SubCws[Medium.nC](quantity=Medium.extraPropertiesNames, start=Medium.C_default) "Water/steam trace substances";
  Medium_FlueGases.ExtraProperty SubCfg[Medium_FlueGases.nC](quantity=Medium_FlueGases.extraPropertiesNames, start=Medium_FlueGases.C_default) "Flue gases trace substances";
  Medium.ThermodynamicState state_ws_in "Water/steam inlet thermodynamic state";
  Medium.ThermodynamicState state_ws_out "Water/steam outlet thermodynamic state";
  Medium.ThermodynamicState state_ws_m "Water/steam average thermodynamic state";
  Medium.SaturationProperties sat_ws "Water/steam saturation properties at the outlet pressure";
  Medium_FlueGases.ThermodynamicState state_fg_in "Flue gases inlet thermodynamic state";
  Medium_FlueGases.ThermodynamicState state_fg_out "Flue gases outlet thermodynamic state";

  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet Cws2(redeclare package Medium = Medium) annotation (
      Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet Cws1(redeclare package Medium = Medium) annotation (
      Placement(transformation(extent={{-110,-10},{-90,10}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet Cfg1(redeclare package Medium = Medium_FlueGases) annotation (
      Placement(transformation(extent={{-10,80},{10,100}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet Cfg2(redeclare package Medium = Medium_FlueGases) annotation (
      Placement(transformation(extent={{-10,-100},{10,-80}}, rotation=0)));
equation
  /* Flue gases inlet */
  Pef = Cfg1.P;
  Hef = Cfg1.h;
  Qf = Cfg1.Q;

  /* Flue gases outlet */
  Psf = Cfg2.P;
  Hsf = Cfg2.h;
  Cfg1.Q = Cfg2.Q;

  Cfg1.h_vol_1 = Cfg2.h_vol_1;
  Cfg1.h_vol_2 = Cfg2.h_vol_2;

  Cfg2.diff_on_1 = Cfg1.diff_on_1;
  Cfg1.diff_on_2 = Cfg2.diff_on_2;

  Cfg2.diff_res_1 = Cfg1.diff_res_1 + 1/gamma_diff_fg;
  Cfg1.diff_res_2 = Cfg2.diff_res_2 + 1/gamma_diff_fg;

  Cfg1.Xi = Cfg2.Xi;
  Xfg = Cfg1.Xi;
  Cfg1.SubC = Cfg2.SubC;
  SubCfg = Cfg1.SubC;

  /* Water inlet */
  Pee = Cws1.P;
  Hee = Cws1.h;
  Qe = Cws1.Q;

  /* Water outlet */
  Pse = Cws2.P;
  Hse = Cws2.h;
  Cws1.Q = Cws2.Q;

  Cws1.h_vol_1 = Cws2.h_vol_1;
  Cws1.h_vol_2 = Cws2.h_vol_2;

  Cws2.diff_on_1 = Cws1.diff_on_1;
  Cws1.diff_on_2 = Cws2.diff_on_2;

  Cws2.diff_res_1 = Cws1.diff_res_1 + 1/gamma_diff_ws;
  Cws1.diff_res_2 = Cws2.diff_res_2 + 1/gamma_diff_ws;

  Cws1.Xi = Cws2.Xi;
  Xws = Cws1.Xi;
  Cws1.SubC = Cws2.SubC;
  SubCws = Cws1.SubC;

  /* Pressure losses */
  Pef = Psf + Kdpf*ThermoSysPro.Functions.ThermoSquare(Qf, eps)/rhof;
  Pee = Pse + Kdpe*ThermoSysPro.Functions.ThermoSquare(Qe, eps)/rhoe;

  /* Power exchanged */
  W = Qf*(Hef - Hsf);
  W = Qe*(Hse - Hee);

  /* Flue gases specific enthalpy at the inlet */
  state_fg_in = Medium_FlueGases.setState_phX(p=Pef, h=Hef, X=Xfg);
  Tef = Medium_FlueGases.temperature(state_fg_in);

  /* Flue gases specific enthalpy at the outlet */
  state_fg_out = Medium_FlueGases.setState_phX(p=Psf, h=Hsf, X=Xfg);
  Tsf = Medium_FlueGases.temperature(state_fg_out);

  /* Flue gases density */
  rhof = Medium_FlueGases.density(state_fg_in);

  /* Water/steam thermodynamic properties */
  state_ws_in = Medium.setState_phX(p=Pee, h=Hee, X=Xws);
  Tee = Medium.temperature(state_ws_in);

  state_ws_m = Medium.setState_phX(p=(Pee + Pse)/2, h=(Hee + Hse)/2, X=Xws);
  rhoe = Medium.density(state_ws_m);

  state_ws_out = Medium.setState_phX(p=Pse, h=Hse, X=Xws);
  Tse = Medium.temperature(state_ws_out);

  sat_ws = Medium.setSat_p(Pse);
  Hse = Medium.dewEnthalpy(sat_ws);

  annotation (Diagram(graphics={
        Rectangle(
          extent={{-100,80},{100,-80}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Backward),
        Text(
          extent={{-30,76},{28,66}},
          lineColor={0,0,0},
          lineThickness=0,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={175,175,175},
          textString=
               "Flue gases"),
        Polygon(
          points={{-94,12},{-80,12},{-80,56},{80,56},{80,12},{92,12},{92,6},{74,
              6},{74,50},{-74,50},{-74,6},{-94,6},{-94,12}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-94,-12},{-80,-12},{-80,-56},{80,-56},{80,-12},{92,-12},{92,
              -6},{74,-6},{74,-50},{-74,-50},{-74,-6},{-94,-6},{-94,-12}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-114,28},{-48,18}},
          lineColor={0,0,0},
          lineThickness=0,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={175,175,175},
          textString=
               "Water/Steam"),
        Polygon(
          points={{-94,3},{90,3},{90,-3},{-94,-3},{-94,3}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid)}),
                            Icon(graphics={
        Rectangle(
          extent={{-100,-75},{100,-85}},
          lineColor={175,175,175},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,86},{100,76}},
          lineColor={175,175,175},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,80},{100,-80}},
          lineColor={175,175,175},
          lineThickness=0,
          fillColor= DynamicSelect({255,255,0}, fill_color_static),
          fillPattern=FillPattern.Backward),
        Polygon(
          points={{-94,12},{-80,12},{-80,56},{80,56},{80,12},{92,12},{92,6},{74,
              6},{74,50},{-74,50},{-74,6},{-94,6},{-94,12}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-92,3},{92,3},{92,-3},{-92,-3},{-92,3}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-94,-12},{-80,-12},{-80,-56},{80,-56},{80,-12},{92,-12},{92,
              -6},{74,-6},{74,-50},{-74,-50},{-74,-6},{-94,-6},{-94,-12}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-128,26},{-102,16}},
          lineColor={28,108,200},
          lineThickness=0,
          fillColor={255,255,0},
          fillPattern=FillPattern.Backward,
          textString="Water"),
        Text(
          extent={{104,22},{128,12}},
          lineColor={255,0,0},
          lineThickness=0,
          fillColor={255,255,0},
          fillPattern=FillPattern.Backward,
          textString="Steam"),
        Text(
          extent={{-52,-86},{-14,-98}},
          lineColor={28,108,200},
          fillColor={255,255,0},
          fillPattern=FillPattern.Backward,
          textString="Flue gases"),
        Text(
          extent={{-50,102},{-14,86}},
          lineColor={238,46,47},
          fillColor={255,255,0},
          fillPattern=FillPattern.Backward,
          textString="Flue gases")}),
    Documentation(revisions = "
Author  

Baligh El Hefni   

    ", info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
    "));
end SimpleEvaporatorWaterSteamFlueGases;
