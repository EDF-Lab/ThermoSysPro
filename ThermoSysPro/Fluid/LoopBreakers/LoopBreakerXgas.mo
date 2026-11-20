within ThermoSysPro.Fluid.LoopBreakers;
model LoopBreakerXgas "Fluid composition loop breaker"

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
public
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet C1(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet C2(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{90,-10},{110,10}}, rotation=0)));
equation

  C1.Q = C2.Q;
  C1.P = C2.P;
  C1.h = C2.h;

  C1.h_vol_1 = C2.h_vol_1;
  C1.h_vol_2 = C2.h_vol_2;

  C2.diff_on_1 = C1.diff_on_1;
  C1.diff_on_2 = C2.diff_on_2;

  C2.diff_res_1 = C1.diff_res_1;
  C1.diff_res_2 = C2.diff_res_2;

  C1.SubC = C2.SubC;

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Polygon(
          points={{0,100},{100,0},{0,-100},{-100,0},{0,100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,0}),
        Text(
          extent={{-38,38},{42,-42}},
          lineColor={0,0,255},
          textString="X"),
        Line(points={{0,100},{0,-100}}, color={0,0,255})}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Polygon(
          points={{0,100},{100,0},{0,-100},{-100,0},{0,100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,0}),
        Text(
          extent={{-40,38},{40,-42}},
          lineColor={0,0,255},
          textString="X"),
        Line(points={{0,100},{0,-100}}, color={0,0,255})}),
    Window(
      x=0.33,
      y=0.09,
      width=0.71,
      height=0.88),
    Documentation(info = "
## Copyright © EDF 2002 - 2026
## ThermoSysPro Version 4.2
    ", revisions = "
Authors

Baligh El Hefni
Daniel Bouskela

    "));
end LoopBreakerXgas;
