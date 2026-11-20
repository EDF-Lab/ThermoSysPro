within ThermoSysPro.Fluid.BoundaryConditions;

model RefT "Fixed temperature reference"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;
 replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));


  parameter Units.SI.Temperature T0=290 "Fixed fluid temperature";

public
  Units.SI.MassFlowRate Q "Fluid mass flow rate";
  Units.SI.AbsolutePressure P "Fluid pressure";
  Units.SI.SpecificEnthalpy h "Fluid specific enthalpy";
  Medium.MassFraction X[Medium.nXi](start=Medium.X_default[1:Medium.nXi]) "Mass fractions";



  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet C1(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet C2(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{90,-10},{110,10}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal ITemperature annotation (Placement(transformation(
        origin={0,110},
        extent={{-10,-10},{10,10}},
        rotation=270)));

equation
  if (cardinality(ITemperature) == 0) then
    ITemperature.signal = T0;
  end if;
  C1.Q = C2.Q;
  C1.P = C2.P;
  C1.h = C2.h;
  C1.h_vol_1 = C2.h_vol_1;
  C1.h_vol_2 = C2.h_vol_2;
  C2.diff_on_1 = C1.diff_on_1;
  C1.diff_on_2 = C2.diff_on_2;
  C2.diff_res_1 = C1.diff_res_1;
  C1.diff_res_2 = C2.diff_res_2;

  C1.Xi = C2.Xi;

  X = C1.Xi;

  C1.SubC = C2.SubC;

  Q = C1.Q;
  P = C1.P;
  h = C1.h;


  /* Computation of the fluid specific enthalpy */
  h = Medium.specificEnthalpy_pTX(p=P, T=ITemperature.signal, X=X);

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Ellipse(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={128,255,0}),
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
               "T")}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Line(points={{0,100},{0,40}}, color={0,0,255}),
        Line(points={{20,60},{0,40},{-20,60}}, color={0,0,255}),
        Line(points={{-90,0},{-40,0}}, color={0,0,255}),
        Line(points={{40,0},{90,0}}, color={0,0,255}),
        Ellipse(
          extent={{-40,40},{40,-40}},
          lineColor= {0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor= DynamicSelect({127,255,0}, fill_color_singular)),
        Text(
          extent={{-28,30},{28,-26}},
          lineColor={0,0,255},
          fillColor={128,255,0},
          fillPattern=FillPattern.Solid,
          textString=
               "T")}),
    Window(
      x=0.06,
      y=0.08,
      width=0.82,
      height=0.65),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
    ", revisions = "
Authors  

Baligh El Hefni  
Daniel Bouskela   

    "),
    DymolaStoredErrors);
end RefT;
