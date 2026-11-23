within ThermoSysPro.Fluid.Sensors;
model SensorQv "Volumetric flow sensor"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  parameter Integer output_unit=1 "Sensor outpu unit - 1: m3/h, other: m3/s";

protected
  parameter Units.SI.Time facteur=if (output_unit == 1) then 3600 else 1 "Unit factor";

public
  Units.SI.MassFlowRate Q(start=500) "Mass flow rate";
  Units.SI.VolumeFlowRate Qv(start=0.5) "Volume flow rate";
  Units.SI.Density rho(start=998) "Fluid density";

public
  ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal Measure
    annotation (Placement(transformation(
        origin={0,102},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet C1(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{-110,-90},{-90,-70}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet C2(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{92,-90},{112,-70}}, rotation=0)));
equation

  C1.P = C2.P;
  C1.h = C2.h;
  C1.Q = C2.Q;

  C1.h_vol_1 = C2.h_vol_1;
  C1.h_vol_2 = C2.h_vol_2;

  C2.diff_on_1 = C1.diff_on_1;
  C1.diff_on_2 = C2.diff_on_2;

  C2.diff_res_1 = C1.diff_res_1;
  C1.diff_res_2 = C2.diff_res_2;

  C1.Xi = C2.Xi;

  C1.SubC = C2.SubC;

  Q = C1.Q;

  /* Sensor signal */
  Qv = Q/rho;
  Measure.signal = Qv*facteur;

  /* Fluid thermodynamic properties */
  rho = Medium.density_phX(p=C1.P, h=C1.h, X=C1.Xi);

  annotation (
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
        Text(
          extent={{-60,60},{60,0}},
          lineColor={0,0,0},
          textString="Qv")}),
    Window(
      x=0.3,
      y=0.19,
      width=0.6,
      height=0.6),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Ellipse(
          extent={{-60,92},{60,-28}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={0,255,0}),
        Line(points={{0,-30},{0,-80}}),
        Line(points={{-98,-80},{102,-80}}),
        Text(
          extent={{-60,64},{60,4}},
          lineColor={28,108,200},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          textString =                      "Qv")}),
    Documentation(info = "
## Copyright © EDF 2002 - 2026
## ThermoSysPro Version 4.2
    ", revisions = "
Authors

Daniel Bouskela
Baligh El Hefni

    "));
end SensorQv;
