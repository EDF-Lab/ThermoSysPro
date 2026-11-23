within ThermoSysPro.Fluid.Examples.SimpleExamples.BoundaryConditions;
model TestRefP_Traces_FlueGases
  extends ThermoSysPro.UsersGuide.Icons.Example;
 replaceable package Medium = ThermoSysPro.Properties.Media.FlueGases(extraPropertiesNames={"Trace1", "Trace2", "Trace3"}, C_nominal={0.1, 0.2, 0.3}, C_default={0.2, 0.3, 0.4});

  ThermoSysPro.Fluid.BoundaryConditions.Sink sinkP(
                                                  redeclare package Medium =
        Medium,
    T0=453.15,
    h0=633193.1,
    option_temperature=true)
    annotation (Placement(transformation(extent={{66,-10},{86,10}})));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss pipePressureLoss(
      redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{32,-10},{52,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.RefP refP(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceQ(redeclare package
      Medium = Medium,
    Q0=50,
    T0=473.15,
    h0=633193.1,
    option_temperature=true, SubC0={10,20,30}, X0={0.1,0.2,0.3,0.2,0.2},
    T(start=423.15))
    annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
  InstrumentationAndControl.Blocks.Sources.Constante constante(k=20e5)
    annotation (Placement(transformation(extent={{-30,38},{-10,58}})));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss singularPressureLoss(
      redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-38,-10},{-18,10}})));
equation
  connect(sinkP.C, pipePressureLoss.C2)
    annotation (Line(points={{66,0},{52,0}}, color={0,0,0}));
  connect(refP.C2, pipePressureLoss.C1)
    annotation (Line(points={{10,0},{32,0}}, color={0,0,0}));

  connect(constante.y, refP.IPressure)
    annotation (Line(points={{-9,48},{0,48},{0,11}}, color={0,0,255}));
  connect(sourceQ.C, singularPressureLoss.C1)
    annotation (Line(points={{-46,0},{-38,0}}, color={0,0,0}));
  connect(singularPressureLoss.C2, refP.C1)
    annotation (Line(points={{-18,0},{-10,0}}, color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TestRefP_Traces_FlueGases;
