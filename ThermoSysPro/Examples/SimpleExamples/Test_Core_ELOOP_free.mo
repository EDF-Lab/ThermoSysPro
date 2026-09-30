within ThermoSysPro.Examples.SimpleExamples;
model Test_Core_ELOOP_free

  NuclearCore.Core core(
    n_rods=3,
    steady_state=true,
    rod_stroke={100,100,100},
    RodsPos0={0,0,0},
    Rp=8.27E-03/2,
    ActiveLength=2.86,
    Length=3.10,
    Rclad=8.27E-03/2 + 8.38E-05,
    Rclad_out=8.27E-03/2 + 8.38E-05 + 5.71E-04,
    pitch=1.26E-02,
    Nz=11,
    heat_coeff_gap=7500,
    lambda=20)
    annotation (Placement(transformation(extent={{-48,-42},{48,36}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante Boron(k=0)
    annotation (Placement(transformation(extent={{-200,-40},{-180,-20}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Echelon Group1(hauteur=
        200, startTime=50)
    annotation (Placement(transformation(extent={{-200,80},{-180,100}})));
  ThermoSysPro.WaterSteam.BoundaryConditions.SourceP
                                                sourceP(P0=15500000, T0=568.15)
    annotation (Placement(transformation(extent={{-40,-88},{-20,-68}})));
  ThermoSysPro.WaterSteam.BoundaryConditions.SinkQ
                                              sinkQ(
    Q0=5183,
    C(Q(start=5573)))
    annotation (Placement(transformation(extent={{52,58},{72,78}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante Group2(k=0)
    annotation (Placement(transformation(extent={{-200,50},{-180,70}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante NeutronSource(k=0)
    annotation (Placement(transformation(extent={{-200,-10},{-180,10}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante Group3(k=0)
    annotation (Placement(transformation(extent={{-200,20},{-180,40}})));
  NuclearCore.Interfaces.KineticParametersInput bUinput annotation (Placement(
        transformation(extent={{-114,-68},{-102,-56}}), iconTransformation(
          extent={{-114,-68},{-102,-56}})));
  InstrumentationAndControl.Blocks.Sources.Constante Burnup(k=0)
    annotation (Placement(transformation(extent={{-200,-72},{-180,-52}})));
  InstrumentationAndControl.AdaptorForFMU.AdaptorTSPModelica
    adaptorTSPModelica
    annotation (Placement(transformation(extent={{-154,-68},{-142,-56}})));
equation
  connect(Boron.y, core.EntreeCbore1) annotation (Line(points={{-179,-30},{-58,
          -30},{-58,-6},{-47.4,-6}}, color={0,0,255}));
  connect(NeutronSource.y, core.S1) annotation (Line(points={{-179,0},{-58,0},{
          -58,6.6},{-48,6.6}}, color={0,0,255}));
  connect(sourceP.C, core.C1_1) annotation (Line(points={{-20,-78},{0,-78},{0,
          -41.4}},                     color={0,0,255}));
  connect(core.C2_1, sinkQ.C) annotation (Line(points={{0,36},{-2,36},{-2,68},{
          52,68}}, color={255,0,0}));
  connect(Group1.y, core.RodsSpeeds1[1]) annotation (Line(points={{-179,90},{
          -140,90},{-140,46},{-56,46},{-56,21},{-48,21}}, color={0,0,255}));
  connect(Group3.y, core.RodsSpeeds1[2]) annotation (Line(points={{-179,30},{
          -164,30},{-164,20},{-56,20},{-56,21},{-48,21}}, color={0,0,255}));
  connect(Group2.y, core.RodsSpeeds1[3]) annotation (Line(points={{-179,60},{
          -140,60},{-140,46},{-56,46},{-56,24},{-54,24},{-54,21},{-48,21}},
        color={0,0,255}));
  connect(core.bUinput, bUinput) annotation (Line(points={{-48,-26.4},{-50,
          -26.4},{-50,-62},{-108,-62}}, color={0,140,72}));
  connect(Burnup.y, adaptorTSPModelica.inputReal)
    annotation (Line(points={{-179,-62},{-154.6,-62}}, color={0,0,255}));
  connect(adaptorTSPModelica.y, bUinput.Burnup)
    annotation (Line(points={{-140.8,-62},{-108,-62}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                     Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent={{-100,
              -100},{100,100}},                                                                                                                                                     radius = 25.0), Rectangle(lineColor = {128, 128, 128}, extent={{-100,
              -100},{100,100}},                                                                                                                                                                                                        radius = 25.0), Polygon(origin={8,14},        lineColor = {78, 138, 73}, fillColor = {78, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-58.0, 46.0}, {42.0, -14.0}, {-58.0, -74.0}, {-58.0, 46.0}})}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=200, __Dymola_Algorithm="Dassl"));
end Test_Core_ELOOP_free;
