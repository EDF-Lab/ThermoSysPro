within ThermoSysPro.Fluid.Examples.SimpleExamples.BoundaryConditions;
model TestRefH
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.WaterSteam;

  ThermoSysPro.Fluid.BoundaryConditions.RefP refP(
    redeclare package Medium = Medium,
    P0=2000000)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.RefQ refQ(
    redeclare package Medium = Medium,
    Q0=110)
    annotation (Placement(transformation(extent={{92,-10},{112,10}})));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss pipePressureLoss(
      redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{126,-10},{146,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.RefH refH(
    redeclare package Medium = Medium,
    h0=2600e3)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  ThermoSysPro.Fluid.Volumes.VolumeA volumeA(
    redeclare package Medium = Medium,
    h0=2600e3,
    dynamic_energy_balance=false)
    annotation (Placement(transformation(extent={{20,-50},{0,-30}})));
  InstrumentationAndControl.Blocks.Sources.Constante enthalpy(k=2600e3)
    annotation (Placement(transformation(extent={{-58,38},{-38,58}})));
  InstrumentationAndControl.Blocks.Sources.Constante pressure(k=2000000)
    annotation (Placement(transformation(extent={{-110,38},{-90,58}})));
  InstrumentationAndControl.Blocks.Sources.Constante massFlow(k=110)
    annotation (Placement(transformation(extent={{2,38},{22,58}})));
  ThermoSysPro.Fluid.LoopBreakers.LoopBreakerH loopBreakerH(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-10,-10},{10,10}},
                                                                                                                                                             rotation=0)));
  ThermoSysPro.Fluid.LoopBreakers.LoopBreakerQ loopBreakerQ(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{18,-10},{38,10}},
                                                                                                                                                            rotation=0)));
  ThermoSysPro.Fluid.LoopBreakers.LoopBreakerP loopBreakerP(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{46,-10},{66,10}},
                                                                                                                                                            rotation=0)));
equation
  connect(refP.C2, refH.C1)
    annotation (Line(points={{-70,0},{-40,0}}, color={0,0,0}));
  connect(refQ.C2, pipePressureLoss.C1)
    annotation (Line(points={{112,0},{126,0}},
                                             color={0,0,0}));
  connect(pipePressureLoss.C2, volumeA.Ce1)
    annotation (Line(points={{146,0},{150,0},{150,-40},{20,-40}},
                                                               color={0,0,0}));
  connect(volumeA.Cs1, refP.C1)
    annotation (Line(points={{0,-40},{-102,-40},{-102,0},{-90,0}}, color={0,0,0}));
  connect(enthalpy.y, refH.ISpecificEnthalpy)
    annotation (Line(points={{-37,48},{-30,48},{-30,11}}, color={0,0,255}));
  connect(pressure.y, refP.IPressure)
    annotation (Line(points={{-89,48},{-80,48},{-80,11}}, color={0,0,255}));
  connect(massFlow.y, refQ.IMassFlow)
    annotation (Line(points={{23,48},{102,48},{102,11}},
                                                       color={0,0,255}));
  connect(refH.C2, loopBreakerH.C1) annotation (Line(points={{-20,0},{-10,0}}, color={0,0,0}));
  connect(loopBreakerH.C2, loopBreakerQ.C1) annotation (Line(points={{10,0},{18,0}}, color={0,0,0}));
  connect(loopBreakerQ.C2, loopBreakerP.C1) annotation (Line(points={{38,0},{46,0}}, color={0,0,0}));
  connect(loopBreakerP.C2, refQ.C1) annotation (Line(points={{66,0},{92,0}}, color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TestRefH;
