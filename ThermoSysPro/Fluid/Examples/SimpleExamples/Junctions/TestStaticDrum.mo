within ThermoSysPro.Fluid.Examples.SimpleExamples.Junctions;
model TestStaticDrum
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.WaterSteam;
  ThermoSysPro.Fluid.Junctions.StaticDrum StaticDrumTh1(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-54,0},{-34,20}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLossVALI1(redeclare package Medium = Medium, K=1e-4) annotation (Placement(transformation(extent={{0,-10},{20,10}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLossVALI2(redeclare package Medium = Medium, K=1e-4) annotation (Placement(transformation(extent={{-80,-50},{-60,-30}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkQ sinkP1(redeclare package Medium = Medium, Q0=10) annotation (Placement(transformation(extent={{40,-10},{60,10}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourcePQ(redeclare package Medium = Medium, P0=100e5) annotation (Placement(transformation(extent={{-90,-90},{-70,-70}}, rotation=0)));
  ThermoSysPro.Thermal.BoundaryConditions.HeatSink heatSource annotation (Placement(transformation(extent={{-80,20},{-60,40}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLossVALI3(redeclare package Medium = Medium, K=1e-4) annotation (Placement(transformation(extent={{-20,50},{0,70}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sinkP2(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{60,50},{80,70}}, rotation=0)));
equation
  connect(singularPressureLossVALI2.C2, StaticDrumTh1.Ce_eco) annotation (Line(points={{-60,-40},{-48,-40},{-48,0.6}}, color={0,0,255}));
  connect(singularPressureLossVALI1.C2, sinkP1.C) annotation (Line(points={{20,0},{40,0}}, color={0,0,255}));
  connect(heatSource.C[1], StaticDrumTh1.Cth) annotation (Line(points={{-70,20.2},{-70,10},{-44,10}}, color={191,95,0}));
  connect(StaticDrumTh1.Cs_purg, singularPressureLossVALI1.C1) annotation (Line(points={{-34.6,6.6},{-19.3,6.6},{-19.3,0},{0,0}}, color={0,0,255}));
  connect(StaticDrumTh1.Cs_sur, singularPressureLossVALI3.C1) annotation (Line(points={{-40.2,19.4},{-40.2,60},{-20,60}}, color={0,0,255}));
  connect(sourcePQ.C, singularPressureLossVALI2.C1) annotation (Line(points={{-70,-80},{-66,-80},{-66,-54},{-84,-54},{-84,-40},{-80,-40}}, color={0,0,0}));
  connect(singularPressureLossVALI3.C2, sinkP2.C) annotation (Line(points={{0,60},{60,60}}, color={0,0,0}));
  annotation (
    experiment(StopTime=1000),
    Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2024 </p>
<p><b>ThermoSysPro Version 4.1 </h4>
</html>"));
end TestStaticDrum;
