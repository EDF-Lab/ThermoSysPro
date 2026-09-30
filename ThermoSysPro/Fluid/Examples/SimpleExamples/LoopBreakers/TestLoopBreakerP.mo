within ThermoSysPro.Fluid.Examples.SimpleExamples.LoopBreakers;
model TestLoopBreakerP
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.WaterSteam;
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourcePQ(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{-100,0},{-80,20}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLoss1(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{-20,20},{0,40}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLoss2(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{-20,-20},{0,0}}, rotation=0)));
  ThermoSysPro.Fluid.Junctions.Splitter2 splitter2_1(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{-56,0},{-36,20}}, rotation=0)));
  ThermoSysPro.Fluid.Junctions.Mixer2 mixer2_1(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{40,0},{60,20}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{80,0},{100,20}}, rotation=0)));
  InstrumentationAndControl.Blocks.Sources.Constante constante(k=0.5) annotation (Placement(transformation(extent={{-80,40},{-60,60}}, rotation=0)));
  ThermoSysPro.Fluid.LoopBreakers.LoopBreakerP loopBreakerP(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{10,-20},{30,0}}, rotation=0)));
equation
  connect(sourcePQ.C, splitter2_1.Ce) annotation (Line(
      points={{-80,10},{-56,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(splitter2_1.Cs1, singularPressureLoss1.C1) annotation (Line(
      points={{-42,20},{-42,30},{-20,30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(splitter2_1.Cs2, singularPressureLoss2.C1) annotation (Line(
      points={{-42,0},{-42,-10},{-20,-10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(mixer2_1.Ce1, singularPressureLoss1.C2) annotation (Line(points={{46,20},{46,30},{0,30}}, smooth=Smooth.None));
  connect(mixer2_1.Cs, sink.C) annotation (Line(
      points={{60,10},{80,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(constante.y, splitter2_1.Ialpha1) annotation (Line(points={{-59,50},{-52,50},{-52,16},{-45,16}}, smooth=Smooth.None));
  connect(singularPressureLoss2.C2, loopBreakerP.C1) annotation (Line(
      points={{0,-10},{10,-10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(loopBreakerP.C2, mixer2_1.Ce2) annotation (Line(
      points={{30,-10},{46,-10},{46,0}},
      color={0,0,255},
      smooth=Smooth.None));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestLoopBreakerP;
