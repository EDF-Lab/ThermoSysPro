within ThermoSysPro.Fluid.Examples.SimpleExamples.Junctions;
model TestSteamExtractionSplitter_Traces
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Fluid.Examples.SimpleExamples.Media.WaterSteam_NonVolatileTrace;
  ThermoSysPro.Fluid.Junctions.SteamExtractionSplitter steamExtractionSplitter(redeclare package Medium = Medium, alpha=0.9, redeclare function PhasesSeparationFunction = Medium.PhasesSeparation (x=steamExtractionSplitter.xe)) annotation (Placement(transformation(extent={{-20,20},{0,40}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceQ(redeclare package Medium = Medium, h0=2600000) annotation (Placement(transformation(extent={{-100,20},{-80,40}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLoss2(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-60,20},{-40,40}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkP(redeclare package Medium = Medium, P0=100e5) annotation (Placement(transformation(extent={{60,20},{80,40}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLoss1(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{20,20},{40,40}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLoss3(redeclare package Medium = Medium, K=2.e-3) annotation (Placement(transformation(extent={{0,-20},{20,0}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkQ sink(redeclare package Medium = Medium, Q0=10) annotation (Placement(transformation(extent={{40,-20},{60,0}}, rotation=0)));
equation
  connect(sourceQ.C, singularPressureLoss2.C1) annotation (Line(points={{-80,30},{-60,30}}, color={0,0,255}));
  connect(singularPressureLoss2.C2, steamExtractionSplitter.Ce) annotation (Line(points={{-40,30},{-20.3,30}}, color={0,0,255}));
  connect(steamExtractionSplitter.Cs, singularPressureLoss1.C1) annotation (Line(points={{0.3,30},{20,30}}, color={0,0,255}));
  connect(steamExtractionSplitter.Cex, singularPressureLoss3.C1) annotation (Line(points={{-6,20},{-6,-10},{0,-10}}, color={0,0,255}));
  connect(singularPressureLoss1.C2, sinkP.C) annotation (Line(points={{40,30},{60,30}}, color={0,0,255}));
  connect(singularPressureLoss3.C2, sink.C) annotation (Line(points={{20,-10},{40,-10}}, color={0,0,255}));
  annotation (
    experiment(StopTime=1000),
    Diagram(graphics),
    Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2024 </p>
<p><b>ThermoSysPro Version 4.1 </h4>
</html>"));
end TestSteamExtractionSplitter_Traces;
