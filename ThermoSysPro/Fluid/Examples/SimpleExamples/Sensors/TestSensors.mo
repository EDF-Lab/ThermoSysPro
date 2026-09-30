within ThermoSysPro.Fluid.Examples.SimpleExamples.Sensors;
model TestSensors
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.WaterSteam;
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{86,-10},{106,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourcePQ(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{-106,-10},{-86,10}})));
  ThermoSysPro.Fluid.Sensors.SensorP sensorP(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{-82,-2},{-62,18}})));
  ThermoSysPro.Fluid.Sensors.SensorQ sensorQ(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{-58,-2},{-38,18}})));
  ThermoSysPro.Fluid.Sensors.SensorQv sensorQv(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{-34,-2},{-14,18}})));
  ThermoSysPro.Fluid.Sensors.SensorH sensorH(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{-10,-2},{10,18}})));
  ThermoSysPro.Fluid.Sensors.SensorT sensorT(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{14,-2},{34,18}})));
  ThermoSysPro.Fluid.Sensors.SensorSubC sensorSubC(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{38,-2},{58,18}})));
  ThermoSysPro.Fluid.Sensors.SensorX sensorX(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{62,-2},{82,18}})));
equation
  connect(sensorP.C1, sourcePQ.C) annotation (Line(points={{-82,0},{-86,0}}, color={0,0,0}));
  connect(sensorP.C2, sensorQ.C1) annotation (Line(points={{-61.8,0},{-58,0}}, color={0,0,0}));
  connect(sensorQ.C2, sensorQv.C1) annotation (Line(points={{-37.8,0},{-34,0}}, color={0,0,0}));
  connect(sensorQv.C2, sensorH.C1) annotation (Line(points={{-13.8,0},{-10,0}}, color={0,0,0}));
  connect(sensorH.C2, sensorT.C1) annotation (Line(points={{10.2,0},{14,0}}, color={0,0,0}));
  connect(sensorT.C2, sensorSubC.C1) annotation (Line(points={{34.2,0},{38,0}}, color={0,0,0}));
  connect(sensorSubC.C2, sensorX.C1) annotation (Line(points={{58.2,0},{62,0}}, color={0,0,0}));
  connect(sensorX.C2, sink.C) annotation (Line(points={{82.2,0},{86,0}}, color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestSensors;
