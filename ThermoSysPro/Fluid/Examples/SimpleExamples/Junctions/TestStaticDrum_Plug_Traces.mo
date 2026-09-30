within ThermoSysPro.Fluid.Examples.SimpleExamples.Junctions;
model TestStaticDrum_Plug_Traces
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Fluid.Examples.SimpleExamples.Media.WaterSteam_NonVolatileTrace;
  ThermoSysPro.Fluid.Junctions.StaticDrum StaticDrumTh1(
    redeclare package Medium = Medium,
    redeclare function PhasesSeparationFunction = Medium.PhasesSeparation(x=StaticDrumTh1.x)) annotation (Placement(transformation(extent={{-54,0},{-34,20}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLossVALI1(redeclare package Medium = Medium, K=1e-4) annotation (Placement(transformation(extent={{0,-10},{20,10}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLossVALI2(redeclare package Medium = Medium, K=1e-4) annotation (Placement(transformation(extent={{-80,-50},{-60,-30}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkQ sinkP1(redeclare package Medium = Medium, Q0=10) annotation (Placement(transformation(extent={{40,-10},{60,10}}, rotation=0)));
  ThermoSysPro.Thermal.BoundaryConditions.HeatSource heatSource(
    option_temperature=2,
    W0={2.4e8},
    T0={290}) annotation (Placement(transformation(extent={{-80,20},{-60,40}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLossVALI3(redeclare package Medium = Medium, K=1e-4) annotation (Placement(transformation(extent={{-20,50},{0,70}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sinkP2(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{60,50},{80,70}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.RefP refP(redeclare package Medium = Medium, P0=3e5) annotation (Placement(transformation(extent={{-26,-90},{-6,-70}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.RefQ refQ(redeclare package Medium = Medium, Q0=100) annotation (Placement(transformation(extent={{-56,-90},{-36,-70}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.PlugA sourcePlug(
    redeclare package Medium = Medium,
    SubC0={10}) annotation (Placement(transformation(extent={{-90,-90},{-70,-70}}, rotation=0)));
equation
  connect(singularPressureLossVALI2.C2, StaticDrumTh1.Ce_eco) annotation (Line(points={{-60,-40},{-60,0.6},{-48,0.6}}, color={0,0,255}));
  connect(singularPressureLossVALI1.C2, sinkP1.C) annotation (Line(points={{20,0},{40,0}}, color={0,0,255}));
  connect(heatSource.C[1], StaticDrumTh1.Cth) annotation (Line(points={{-70,20.2},{-70,10},{-44,10}}, color={191,95,0}));
  connect(StaticDrumTh1.Cs_purg, singularPressureLossVALI1.C1) annotation (Line(points={{-34.6,6.6},{-19.3,6.6},{-19.3,0},{0,0}}, color={0,0,255}));
  connect(StaticDrumTh1.Cs_sur, singularPressureLossVALI3.C1) annotation (Line(points={{-40.2,19.4},{-40.2,60},{-20,60}}, color={0,0,255}));
  connect(refQ.C2, refP.C1) annotation (Line(points={{-36,-80},{-26,-80}}, color={0,0,255}));
  connect(sourcePlug.C, refQ.C1) annotation (Line(points={{-70,-80},{-56,-80}}, color={0,0,255}));
  connect(refP.C2, singularPressureLossVALI2.C1) annotation (Line(points={{-6,-80},{-2,-80},{-2,-56},{-84,-56},{-84,-40},{-80,-40}}, color={0,0,0}));
  connect(singularPressureLossVALI3.C2, sinkP2.C) annotation (Line(points={{0,60},{60,60}}, color={0,0,0}));
  annotation (
    experiment(StopTime=1000),
    Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Polygon(
          origin={8.0,14.0},
          lineColor={78,138,73},
          fillColor={78,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-58.0,46.0},{42.0,-14.0},{-58.0,-74.0},{-58.0,46.0}})}),
    Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2024 </p>
<p><b>ThermoSysPro Version 4.1 </h4>
</html>"));
end TestStaticDrum_Plug_Traces;
