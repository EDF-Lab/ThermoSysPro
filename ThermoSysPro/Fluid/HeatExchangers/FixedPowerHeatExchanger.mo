within ThermoSysPro.Fluid.HeatExchangers;
model FixedPowerHeatExchanger "Heat exchanger with fixed delta power"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium_c = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model for the hot fluid" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  replaceable package Medium_f = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model for the cold fluid" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));

  parameter Units.SI.Power DW=0
    "Power exchanged between the hot and the cold fluid";
  parameter Real DPc=10 "Total pressure loss for the hot fluid (percent of the fluid pressure at the inlet)";
  parameter Real DPf=10 "Total pressure loss for the cold fluid (percent of the fluid pressure at the inlet)";
  parameter Units.SI.MassFlowRate gamma_diff_c=1e-4
    "Diffusion conductance for the hot fluid (active if diffusion=true in neighbouring volumes)";
  parameter Units.SI.MassFlowRate gamma_diff_f=1e-4
    "Diffusion conductance for the cold fluid (active if diffusion=true in neighbouring volumes)";

public
  Units.SI.Temperature Tec "Fluid temperature at the inlet of the hot side";
  Units.SI.Temperature Tsc "Fluid temperature at the outlet of the hot side";
  Units.SI.Temperature Tef "Fluid temperature at the inlet of the cold side";
  Units.SI.Temperature Tsf "Fluid temperature at the outlet of the cold side";
  Units.SI.MassFlowRate Qc(start=100) "Hot fluid mass flow rate";
  Units.SI.MassFlowRate Qf(start=100) "Cold fluid mass flow rate";
  Medium_c.MassFraction Xc[Medium_c.nXi](start=Medium_c.X_default[1:Medium_c.nXi]) "Mass fractions of the hot fluid";
  Medium_f.MassFraction Xf[Medium_f.nXi](start=Medium_f.X_default[1:Medium_f.nXi]) "Mass fractions of the cold fluid";
  Medium_c.ThermodynamicState state_ce "Thermodynamic state of the hot fluid at the inlet";
  Medium_c.ThermodynamicState state_cs "Thermodynamic state of the hot fluid at the outlet";
  Medium_f.ThermodynamicState state_fe "Thermodynamic state of the cold fluid at the inlet";
  Medium_f.ThermodynamicState state_fs "Thermodynamic state of the cold fluid at the outlet";

public
  Interfaces.Connectors.FluidInlet Ec(redeclare package Medium = Medium_c) annotation (Placement(transformation(
          extent={{-68,-70},{-48,-50}}, rotation=0)));
  Interfaces.Connectors.FluidInlet Ef(redeclare package Medium = Medium_f) annotation (Placement(transformation(
          extent={{-110,-10},{-90,10}}, rotation=0)));
  Interfaces.Connectors.FluidOutlet Sf(redeclare package Medium = Medium_f) annotation (Placement(transformation(
          extent={{88,-9},{108,11}}, rotation=0)));
  Interfaces.Connectors.FluidOutlet Sc(redeclare package Medium = Medium_c) annotation (Placement(transformation(
          extent={{48,-70},{68,-50}}, rotation=0)));
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

  /* Power exchanged between the hot and cold fluid */
  DW = Qf*(Sf.h - Ef.h);
  DW = Qc*(Ec.h - Sc.h);

  /* Pressure losses */
  Sc.P = if (Qc > 0) then Ec.P - DPc*Ec.P/100 else Ec.P + DPc*Ec.P/100;
  Sf.P = if (Qf > 0) then Ef.P - DPf*Ef.P/100 else Ef.P + DPf*Ef.P/100;

  /* Fluid thermodynamic properties for the hot fluid */
  state_ce = Medium_c.setState_phX(p=Ec.P, h=Ec.h, X=Xc);
  state_cs = Medium_c.setState_phX(p=Sc.P, h=Sc.h, X=Xc);

  Tec = Medium_c.temperature(state_ce);
  Tsc = Medium_c.temperature(state_cs);

  /* Fluid thermodynamic properties for the cold fluid */
  state_fe = Medium_f.setState_phX(p=Ef.P, h=Ef.h, X=Xf);
  state_fs = Medium_f.setState_phX(p=Sf.P, h=Sf.h, X=Xf);

  Tef = Medium_f.temperature(state_fe);
  Tsf = Medium_f.temperature(state_fs);

  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={Rectangle(
          extent={{-100,62},{100,-62}},
          lineColor={255,255,170},
          fillColor=DynamicSelect({127,255,0}, fill_color_singular),
          lineThickness=0,
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,62},{100,-62}},
          lineColor={0,0,0},
          fillColor={127,255,0},
          fillPattern=FillPattern.CrossDiag),
        Line(
          points={{-58,-50},{-58,4},{-2,-28},{58,6},{58,-50}},
          color={0,0,255},
          thickness=0.5),
        Text(
          extent={{-126,24},{-106,14}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Cold inlet"),
        Text(
          extent={{-88,-70},{-68,-80}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Hot inlet"),
        Text(
          extent={{70,-72},{94,-82}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Hot outlet"),
        Text(
          extent={{104,24},{128,10}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Cold outlet")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={28,108,200},
          fillColor={127,255,0},
          fillPattern=FillPattern.CrossDiag), Line(
          points={{-58,-50},{-58,2},{-2,-34},{58,2},{58,-50}},
          color={0,0,255},
          thickness=0.5),
        Text(
          extent={{-104,28},{-60,10}},
          lineColor={0,0,0},
          textString="Cold inlet"),
        Text(
          extent={{62,30},{106,12}},
          lineColor={0,0,0},
          textString="Cold outlet"),
        Text(
          extent={{62,-36},{106,-54}},
          lineColor={238,46,47},
          textString="Hot outlet"),
        Text(
          extent={{-106,-34},{-62,-52}},
          lineColor={238,46,47},
          textString="Hot inlet")}),
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
end FixedPowerHeatExchanger;
