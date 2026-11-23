within ThermoSysPro.Fluid.Examples.SimpleExamples.Junctions;
model TestMassFlowMultiplier_FlueGases
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.FlueGases (
      extraPropertiesNames={"Trace"},
      C_nominal={0.1},
      C_default={0.2});
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourcePQ(
    redeclare package Medium = Medium,
    P0=4500000,
    T0=573.15,
    option_temperature=true,
    C(h_vol_2(start=2830566))) annotation (Placement(transformation(extent={{-90,-10},{-70,10}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink(
    redeclare package Medium = Medium,
    T0=573.15,
    option_temperature=true) annotation (Placement(transformation(extent={{70,-10},{90,10}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLoss(redeclare package Medium = Medium, rho(start=27, displayUnit="kg/m3")) annotation (Placement(transformation(extent={{-50,-10},{-30,10}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLoss1(redeclare package Medium = Medium, rho(displayUnit="kg/m3", start=27)) annotation (Placement(transformation(extent={{30,-10},{50,10}}, rotation=0)));
  ThermoSysPro.Fluid.Junctions.MassFlowMultiplier massFlowMultiplier(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0)));
equation
  connect(sourcePQ.C, singularPressureLoss.C1) annotation (Line(points={{-70,0},{-50,0}}, color={0,0,255}));
  connect(singularPressureLoss1.C2, sink.C) annotation (Line(points={{50,0},{70,0}}, color={0,0,255}));
  connect(singularPressureLoss.C2, massFlowMultiplier.Ce) annotation (Line(points={{-30,0},{-10,0}}, color={0,0,255}));
  connect(massFlowMultiplier.Cs, singularPressureLoss1.C1) annotation (Line(points={{10,0},{30,0}}, color={0,0,255}));
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
end TestMassFlowMultiplier_FlueGases;
