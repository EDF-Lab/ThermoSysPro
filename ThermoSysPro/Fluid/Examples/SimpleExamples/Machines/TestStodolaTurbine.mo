within ThermoSysPro.Fluid.Examples.SimpleExamples.Machines;
model TestStodolaTurbine
  extends ThermoSysPro.UsersGuide.Icons.Example;

replaceable package Medium = Properties.Media.WaterSteam;

  ThermoSysPro.Fluid.Machines.StodolaTurbine stodolaTurbine(
    redeclare replaceable package Medium = Medium,
    Cst=4100,
    Ps(start=5000),
    rhos(start=1.22))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourcePQ(
    redeclare replaceable package Medium = Medium,
    P0=300000,
    Q0=200,
    h0=3e6,
    option_temperature=false)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink(redeclare replaceable package Medium = Medium)
    annotation (Placement(transformation(extent={{26,-10},{46,10}})));
equation
  connect(sourcePQ.C, stodolaTurbine.Ce)
    annotation (Line(points={{-30,0},{-10.1,0}}, color={0,0,0}));
  connect(stodolaTurbine.Cs, sink.C)
    annotation (Line(points={{10.1,0},{26,0}}, color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TestStodolaTurbine;
