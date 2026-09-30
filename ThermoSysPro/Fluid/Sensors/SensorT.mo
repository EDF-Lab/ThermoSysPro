within ThermoSysPro.Fluid.Sensors;
model SensorT "Temperature sensor"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));

public
  Units.SI.Temperature T "Fluid temperature";

public
  ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal Measure
    annotation (Placement(transformation(
        origin={0,102},
        extent={{-10,-10},{10,10}},
        rotation=90), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,102})));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet C1(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{-110,-90},{-90,-70}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet C2(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{92,-90},{112,-70}}, rotation=0)));
equation

  C1.P = C2.P;
  C1.Q = C2.Q;
  C1.h = C2.h;

  C1.h_vol_1 = C2.h_vol_1;
  C1.h_vol_2 = C2.h_vol_2;

  C2.diff_on_1 = C1.diff_on_1;
  C1.diff_on_2 = C2.diff_on_2;

  C2.diff_res_1 = C1.diff_res_1;
  C1.diff_res_2 = C2.diff_res_2;

  C1.Xi = C2.Xi;

  C1.SubC = C2.SubC;

  /* Sensor signal */
  Measure.signal = T;

  /* Fluid thermodynamic properties */
  T = Medium.temperature_phX(p=C1.P, h=C1.h, X=C1.Xi);

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Ellipse(
          extent={{-60,92},{60,-28}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={127,255,0}),
        Line(points={{0,-30},{0,-80}}),
        Line(points={{-98,-80},{102,-80}}),
        Text(
          extent={{-60,64},{60,4}},
          lineColor={28,108,200},
          fillColor={127,255,0},
          fillPattern=FillPattern.Solid,
          textString=
               "T")}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Ellipse(
          extent={{-60,92},{60,-28}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor=DynamicSelect({127,255,0}, fill_color_singular)),
        Line(points={{0,-30},{0,-80}}),
        Line(points={{-98,-80},{102,-80}}),
        Text(extent={{-60,64},{60,4}}, textString=
                                            "T")}),
    Window(
      x=0.22,
      y=0.21,
      width=0.6,
      height=0.6),
    Documentation(info = "
## Copyright © EDF 2002 - 2026
## ThermoSysPro Version 4.2
    ", revisions = "
Authors

Daniel Bouskela
Baligh El Hefni

    "));
end SensorT;
