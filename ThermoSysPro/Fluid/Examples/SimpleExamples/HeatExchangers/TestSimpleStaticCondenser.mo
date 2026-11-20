within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestSimpleStaticCondenser
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam;

  ThermoSysPro.Fluid.HeatExchangers.SimpleStaticCondenser simpleStaticCondenser(
    redeclare package Medium = Medium,
    redeclare package Medium_Cooling = Medium,
    Ec(h(start=532983.7176868258)),
    Ef(h(start=71016.12237181116)),
    Qc(start=1049.6385508765125),
    Qf(start=4469.84281279143),
    Sf(h(start=64330.208038325145))) annotation (Placement(transformation(extent={{-20,20},{0,40}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourceP(
    redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-60,20},{-40,40}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourceP1(
    redeclare package Medium = Medium,
    T0=400) annotation (Placement(transformation(extent={{-60,-20},{-40,0}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkP(
    redeclare package Medium = Medium) annotation (Placement(transformation(extent={{20,20},{40,40}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkP1(
    redeclare package Medium = Medium) annotation (Placement(transformation(extent={{20,-20},{40,0}}, rotation=0)));
equation
  connect(sourceP.C, simpleStaticCondenser.Ef) annotation (Line(points={{-40,30},{-20,30}}, color={0,0,255}));
  connect(sourceP1.C, simpleStaticCondenser.Ec) annotation (Line(points={{-40,-10},{-16,-10},{-16,20}}, color={0,0,255}));
  connect(simpleStaticCondenser.Sf, sinkP.C) annotation (Line(points={{0,29.9},{10,29.9},{10,30},{20,30}}, color={0,0,255}));
  connect(simpleStaticCondenser.Sc, sinkP1.C) annotation (Line(points={{-4,20},{-4,-10},{20,-10}}, color={0,0,255}));
  annotation (
    experiment(StopTime=1000),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestSimpleStaticCondenser;
