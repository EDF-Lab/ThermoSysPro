within ThermoSysPro.Fluid.Examples.SimpleExamples.Junctions;
model TestSplitter3_Traces
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.WaterSteam(
      extraPropertiesNames={"Trace"},
      C_nominal={0.1},
      C_default={0.2});
  ThermoSysPro.Fluid.Junctions.Splitter3 splitter3(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-16,-10},{4,10}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceP1(redeclare package Medium = Medium, Q0=100) annotation (Placement(transformation(extent={{-96,-10},{-76,10}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLoss3(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-56,-10},{-36,10}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sinkP2(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{84,30},{104,50}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sinkP3(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{84,-50},{104,-30}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLoss4(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{44,30},{64,50}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLoss5(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{44,-50},{64,-30}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante1(k=0) annotation (Placement(transformation(extent={{-36,10},{-16,30}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkP4(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{84,-10},{104,10}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante2(k=0) annotation (Placement(transformation(extent={{-36,-30},{-16,-10}}, rotation=0)));
equation
  connect(sourceP1.C, singularPressureLoss3.C1) annotation (Line(points={{-76,0},{-56,0}}, color={0,0,255}));
  connect(singularPressureLoss3.C2, splitter3.Ce) annotation (Line(points={{-36,0},{-15.8,0}}, color={0,0,255}));
  connect(splitter3.Cs1, singularPressureLoss4.C1) annotation (Line(points={{-2,10},{-2,40},{44,40}}, color={0,0,255}));
  connect(singularPressureLoss4.C2, sinkP2.C) annotation (Line(points={{64,40},{84,40}}, color={0,0,255}));
  connect(splitter3.Cs2, singularPressureLoss5.C1) annotation (Line(points={{-2,-10},{-2,-40},{44,-40}}, color={0,0,255}));
  connect(singularPressureLoss5.C2, sinkP3.C) annotation (Line(points={{64,-40},{84,-40}}, color={0,0,255}));
  connect(constante1.y, splitter3.Ialpha1) annotation (Line(points={{-15,20},{-10,20},{-10,6},{-5,6}}));
  connect(splitter3.Cs3, sinkP4.C) annotation (Line(points={{4,0},{84,0}}, color={0,0,255}));
  connect(splitter3.Ialpha2, constante2.y) annotation (Line(points={{-5,-6},{-10,-6},{-10,-20},{-15,-20}}));
  annotation (
    experiment(StopTime=10),
    Diagram(graphics),
    Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2024 </p>
<p><b>ThermoSysPro Version 4.1 </p>
<p>This model is documented in Sect. 14.8.5 of the <a href=\"https://www.springer.com/us/book/9783030051044\">ThermoSysPro book</a>.</h4>
<p>The results reported in the ThermoSysPro book were computed using Dymola.</h4>
</html>"));
end TestSplitter3_Traces;
