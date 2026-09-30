within ThermoSysPro.Fluid.BoundaryConditions;

model PlugB "Plug"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;
    replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  parameter Boolean diffusion=false "true: energy balance equation with diffusion - false: energy balance equation without diffusion";

public
  Units.SI.MassFlowRate Q "Fluid mass flow rate";
  Units.SI.AbsolutePressure P "Fluid pressure";
  Units.SI.SpecificEnthalpy h "Fluid specific enthalpy";
  Medium.MassFraction X[Medium.nXi] "Fluid mass fraction";
  Medium.ExtraProperty SubC[Medium.nC] "Fluid trace substances";

  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet C(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}, rotation=0)));
equation
  Q = C.Q;
  P = C.P;
  h = C.h;
  C.h_vol_2 = h;
  C.diff_res_2 = 0;
  C.diff_on_2 = diffusion;

  SubC = C.SubC;

  X = C.Xi;

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Line(points={{-90,0},{-40,0},{-54,10}}),
        Line(points={{-54,-10},{-40,0}}),
        Ellipse(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={128,255,0})}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Line(points={{-92,0},{-40,0},{-54,10}}),
        Line(points={{-54,-10},{-40,0}}),
        Ellipse(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor=DynamicSelect({127,255,0}, fill_color_singular))}),
    Window(
      x=0.23,
      y=0.15,
      width=0.81,
      height=0.71),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
    ", revisions = "
Authors  

Baligh El Hefni  
Daniel Bouskela   

    "));
end PlugB;
