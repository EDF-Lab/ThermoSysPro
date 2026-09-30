within ThermoSysPro.Fluid.Examples.SimpleExamples.Volumes;
model TestTankHorizontal_withPipePressureLosses
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam;
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss PerteDP1(
    redeclare package Medium = Medium,
    K=1.5,
    Q(start=5282.482640023983),
    rho(start=997.40780979054, displayUnit="g/cm3")) annotation (Placement(transformation(extent={{30,-50},{50,-30}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve VanneReglante1(
    redeclare package Medium = Medium,
    Pm(start=21741.77302868171, displayUnit="bar"),
    Q(start=-1.3278998585228342E-31)) annotation (Placement(transformation(extent={{-50,2},{-30,22}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP SourceP1(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-90,-4},{-70,16}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP PuitsP1(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{70,-50},{90,-30}}, rotation=0)));
  ThermoSysPro.Fluid.Volumes.TankHorizontal Tank1(
    redeclare package Medium = Medium,
    z(fixed=false, start=1),
    Cs1(Q(start=1.2116903504194741E-27)),
    Cs2(P(start=3.2e5)),
    rho(start=997.4119292829444, displayUnit="g/cm3")) annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Rampe Rampe1 annotation (Placement(transformation(extent={{-90,30},{-70,50}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss PerteDP2(
    redeclare package Medium = Medium,
    K=1.5,
    rho(start=997.33695032119, displayUnit="g/cm3")) annotation (Placement(transformation(extent={{30,-4},{50,16}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP PuitsP2(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{70,-4},{90,16}}, rotation=0)));
equation
  connect(PerteDP1.C2, PuitsP1.C) annotation (Line(points={{50,-40},{70,-40}}, color={0,0,255}));
  connect(SourceP1.C, VanneReglante1.C1) annotation (Line(points={{-70,6},{-50,6}}, color={0,0,255}));
  connect(Tank1.Cs2, PerteDP1.C1) annotation (Line(points={{10,-5},{20,-5},{20,-40},{30,-40}}, color={0,0,255}));
  connect(Rampe1.y, VanneReglante1.Ouv) annotation (Line(points={{-69,40},{-40,40},{-40,23}}));
  connect(VanneReglante1.C2, Tank1.Ce1) annotation (Line(points={{-30,6},{-20,6},{-20,5},{-10,5}}, color={0,0,255}));
  connect(Tank1.Cs1, PerteDP2.C1) annotation (Line(points={{10.2,4.9},{20,4.9},{20,6},{30,6}}, color={0,0,255}));
  connect(PerteDP2.C2, PuitsP2.C) annotation (Line(points={{50,6},{70,6}}, color={0,0,255}));
  annotation (
    experiment(StopTime=20),
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
end TestTankHorizontal_withPipePressureLosses;
