within ThermoSysPro.Fluid.Examples.SimpleExamples.PressureLosses;
model TestControlValve_Traces
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.WaterSteam(extraPropertiesNames={"Trace1", "Trace2"}, C_nominal={0.1, 2}, C_default={0.2, 5});

  ThermoSysPro.Fluid.PressureLosses.ControlValve         controlValve(
      redeclare replaceable package Medium = Medium, caract=[0,0; 0.5,3000; 0.75,
        7000; 1,8000])
    annotation (Placement(transformation(extent={{-10,-4},{10,16}})));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink(redeclare replaceable package
      Medium = Medium)
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourcePQ(redeclare
      replaceable package Medium = Medium,
    SubC0={10,20},                                           Q0=2580)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  InstrumentationAndControl.Blocks.Tables.Table1DTemps Constante1(Table=[0,0.9;
        5,0.9; 15,0.5; 25,0.5; 50,0.2; 100,0.2])
    annotation (Placement(transformation(extent={{-30,34},{-10,54}}, rotation=0)));
equation
  connect(controlValve.C2, sink.C)
    annotation (Line(points={{10,0},{30,0}}, color={0,0,0}));
  connect(controlValve.C1, sourcePQ.C)
    annotation (Line(points={{-10,0},{-30,0}}, color={0,0,0}));
  connect(Constante1.y, controlValve.Ouv)
    annotation (Line(points={{-9,44},{0,44},{0,17}}, color={0,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TestControlValve_Traces;
