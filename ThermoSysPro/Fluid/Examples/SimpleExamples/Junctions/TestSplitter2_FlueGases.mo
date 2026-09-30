within ThermoSysPro.Fluid.Examples.SimpleExamples.Junctions;
model TestSplitter2_FlueGases
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.FlueGases (
      extraPropertiesNames={"Trace"},
      C_nominal={0.1},
      C_default={0.2});
  ThermoSysPro.Fluid.Junctions.Splitter2 splitter2(redeclare replaceable package Medium = Medium, h(start=2.83057e6)) annotation (Placement(transformation(extent={{-20,-10},{0,10}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceP(
    redeclare replaceable package Medium = Medium,
    Q0=200,
    T0=573.15,
    option_temperature=true,
    SubC0={3}) annotation (Placement(transformation(extent={{-100,-10},{-80,10}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLoss(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{-60,-10},{-40,10}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sinkP(
    redeclare replaceable package Medium = Medium,
    T0=573.15,
    option_temperature=true) annotation (Placement(transformation(extent={{80,30},{100,50}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkP1(
    redeclare replaceable package Medium = Medium,
    P0=4500000,
    T0=573.15,
    option_temperature=true) annotation (Placement(transformation(extent={{80,-50},{100,-30}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLoss1(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{40,30},{60,50}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLoss2(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{40,-50},{60,-30}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante(k=0.2) annotation (Placement(transformation(extent={{-40,10},{-20,30}}, rotation=0)));
equation
  connect(sourceP.C, singularPressureLoss.C1) annotation (Line(points={{-80,0},{-60,0}}, color={0,0,255}));
  connect(singularPressureLoss.C2, splitter2.Ce) annotation (Line(points={{-40,0},{-20,0}}, color={0,0,255}));
  connect(splitter2.Cs1, singularPressureLoss1.C1) annotation (Line(points={{-6,10},{-6,40},{40,40}}, color={0,0,255}));
  connect(singularPressureLoss1.C2, sinkP.C) annotation (Line(points={{60,40},{80,40}}, color={0,0,255}));
  connect(splitter2.Cs2, singularPressureLoss2.C1) annotation (Line(points={{-6,-10},{-6,-40},{40,-40}}, color={0,0,255}));
  connect(singularPressureLoss2.C2, sinkP1.C) annotation (Line(points={{60,-40},{80,-40}}, color={0,0,255}));
  connect(constante.y, splitter2.Ialpha1) annotation (Line(points={{-19,20},{-14,20},{-14,6},{-9,6}}));
  annotation (experiment(StopTime=10), Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2024 </p>
<p><b>ThermoSysPro Version 4.1 </h4>
</html>"));
end TestSplitter2_FlueGases;
