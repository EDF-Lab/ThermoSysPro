within ThermoSysPro.Fluid.Examples.SimpleExamples.Machines;
model TestCHPEngineBarkantineSystem
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam;
  replaceable package Medium_FlueGases = ThermoSysPro.Properties.Media.FlueGases;

  ThermoSysPro.Fluid.BoundaryConditions.SourceP SourceP1(
    redeclare package Medium = Medium,
    P0=300000,
    h0=293e3,
    option_temperature=false)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}}, rotation=
            0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP PuitsP1(
    redeclare package Medium = Medium,
    P0=100000,
    T0=360)
    annotation (Placement(transformation(extent={{60,20},{80,40}}, rotation=0)));
  ThermoSysPro.Fluid.Machines.CHPEngineBarkantineSystem CHPBarkantine(
    redeclare package Medium = Medium,
    redeclare package Medium_FlueGases = Medium_FlueGases)
    annotation (Placement(transformation(extent={{-40,0},{20,60}}, rotation=0)));
equation
  connect(SourceP1.C, CHPBarkantine.inletWaterSteam) annotation (Line(points={{
          -80,30},{-50,30},{-50,45},{-40,45}}, color={0,0,0}));
  connect(CHPBarkantine.outletWaterSteam, PuitsP1.C)
    annotation (Line(points={{20,45},{30,45},{30,30},{60,30}}, color={0,0,0}));
  annotation (
    experiment(StopTime=1000),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2})),
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
<p><b>Copyright &copy; EDF 2002 - 2024</b> </p>
<p><b>ThermoSysPro Version 4.1</b> </p>
</html>"));
end TestCHPEngineBarkantineSystem;
