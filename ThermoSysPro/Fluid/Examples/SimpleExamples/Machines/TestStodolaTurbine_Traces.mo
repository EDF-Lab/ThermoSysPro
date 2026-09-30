within ThermoSysPro.Fluid.Examples.SimpleExamples.Machines;
model TestStodolaTurbine_Traces
  extends ThermoSysPro.UsersGuide.Icons.Example;

replaceable package Medium = Properties.Media.WaterSteam(extraPropertiesNames={"Trace1", "Trace2", "Trace3", "Trace4"}, C_nominal={0.1, 0.2, 0.3, 0.4}, C_default={0.2, 0.3, 0.4, 0.5});

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
    SubC0={40,50,60,70},
    option_temperature=false)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink(redeclare replaceable package
      Medium =                                                                           Medium)
    annotation (Placement(transformation(extent={{26,-10},{46,10}})));
equation
  connect(sourcePQ.C, stodolaTurbine.Ce)
    annotation (Line(points={{-30,0},{-10.1,0}}, color={0,0,0}));
  connect(stodolaTurbine.Cs, sink.C)
    annotation (Line(points={{10.1,0},{26,0}}, color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TestStodolaTurbine_Traces;
