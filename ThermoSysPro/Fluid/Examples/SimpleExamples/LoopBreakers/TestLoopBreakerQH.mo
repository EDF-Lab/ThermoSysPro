within ThermoSysPro.Fluid.Examples.SimpleExamples.LoopBreakers;
model TestLoopBreakerQH
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.WaterSteam;

  ThermoSysPro.Fluid.BoundaryConditions.RefP refP(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-90,0},{-70,20}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante(k=2.e5) annotation (Placement(transformation(extent={{-100,60},{-80,80}}, rotation=0)));
  ThermoSysPro.Fluid.Machines.StaticCentrifugalPump pump(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-30,0},{-10,20}}, rotation=0)));
  ThermoSysPro.Fluid.LoopBreakers.LoopBreakerQ loopBreakerQ(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{0,0},{20,20}}, rotation=0)));
  ThermoSysPro.Fluid.LoopBreakers.LoopBreakerH loopBreakerH(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{30,0},{50,20}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.RefT refT(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-60,0},{-40,20}}, rotation=0)));
  ThermoSysPro.Fluid.Volumes.VolumeA volumeA(redeclare package Medium = Medium, dynamic_energy_balance=false) annotation (Placement(transformation(extent={{10,-30},{-10,-10}})));
equation
  connect(refP.C2, refT.C1) annotation (Line(points={{-70,10},{-60,10}}, color={0,0,255}));
  connect(refT.C2, pump.C1) annotation (Line(points={{-40,10},{-30,10}}, color={0,0,255}));
  connect(constante.y, refP.IPressure) annotation (Line(points={{-79,70},{-60,70},{-60,34},{-80,34},{-80,21}}));
  connect(pump.C2, loopBreakerQ.C1) annotation (Line(points={{-10,10},{0,10}}, color={0,0,255}));
  connect(loopBreakerQ.C2, loopBreakerH.C1) annotation (Line(points={{20,10},{30,10}}, color={0,0,255}));
  connect(volumeA.Cs1, refP.C1) annotation (Line(points={{-10,-20},{-100,-20},{-100,10},{-90,10}}, color={0,0,0}));

  connect(volumeA.Ce1, loopBreakerH.C2) annotation (Line(points={{10,-20},{100,-20},{100,10},{50,10}}, color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestLoopBreakerQH;
