within ThermoSysPro.Fluid.Examples.SimpleExamples.Junctions;
model TestDeheaterMixer2
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.WaterSteam;
  ThermoSysPro.Fluid.Junctions.DeheaterMixer2 deheaterMixer2_1(redeclare package Medium = Medium, Tmax=308) annotation (Placement(transformation(extent={{-10,-16},{10,4}},rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLoss(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-50,-10},{-30,10}},rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLoss1(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{30,-10},{50,10}},rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLoss2(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-50,-50},{-30,-30}},
                                                                                                                                                                                   rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkQ sinkP(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{70,-10},{90,10}},rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourceP(redeclare package Medium = Medium, T0=310) annotation (Placement(transformation(extent={{-90,-10},{-70,10}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.Source source(redeclare package Medium = Medium, h0=30000) annotation (Placement(transformation(extent={{-90,-50},{-70,-30}},rotation=0)));
equation
  connect(singularPressureLoss.C2, deheaterMixer2_1.Ce) annotation (Line(points={{-30,0},{-10,0}},                     color={0,0,255}));
  connect(deheaterMixer2_1.Cs, singularPressureLoss1.C1) annotation (Line(points={{10,0},{30,0}},                  color={0,0,255}));
  connect(singularPressureLoss2.C2, deheaterMixer2_1.Ce_mix) annotation (Line(points={{-30,-40},{0.1,-40},{0.1,-16}},  color={0,0,255}));
  connect(singularPressureLoss1.C2, sinkP.C) annotation (Line(points={{50,0},{70,0}},   color={0,0,255}));
  connect(sourceP.C, singularPressureLoss.C1) annotation (Line(points={{-70,0},{-50,0}},   color={0,0,255}));
  connect(source.C, singularPressureLoss2.C1) annotation (Line(points={{-70,-40},{-50,-40}}, color={0,0,255}));
  annotation (
    experiment(StopTime=10),
    Diagram(graphics),
    Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Polygon(
          origin={8.0,14.0},
          lineColor={78,138,73},
          fillColor={78,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-58.0,46.0},{42.0,-14.0},{-58.0,-74.0},{-58.0,46.0}})}),
    Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2024 </p>
<p><b>ThermoSysPro Version 4.1 </h4>
</html>"));
end TestDeheaterMixer2;
