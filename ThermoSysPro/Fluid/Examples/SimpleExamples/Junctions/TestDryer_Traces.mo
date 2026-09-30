within ThermoSysPro.Fluid.Examples.SimpleExamples.Junctions;
model TestDryer_Traces
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Fluid.Examples.SimpleExamples.Media.WaterSteam_NonVolatileTrace;
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourcePQ(redeclare replaceable package Medium = Medium, h0=2e6,
    SubC0={1})                                                                                                   annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  ThermoSysPro.Fluid.Junctions.SteamDryer steamDryer(redeclare package Medium = Medium, redeclare function PhasesSeparationFunction = Medium.PhasesSeparation (x=steamDryer.xe)) annotation (Placement(transformation(extent={{-10,-14},{10,6}})));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink_cond(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{30,-40},{50,-20}})));
equation
  connect(sourcePQ.C, steamDryer.Cev) annotation (Line(points={{-30,0},{-9.9,0}}, color={0,0,0}));
  connect(sink.C, steamDryer.Csv) annotation (Line(points={{30,0},{9.9,0}}, color={0,0,0}));
  connect(steamDryer.Csl, sink_cond.C) annotation (Line(points={{0.1,-14},{0.1,-30},{30,-30}}, color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestDryer_Traces;
