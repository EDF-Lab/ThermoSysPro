within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestFixedPowerHeatExchanger
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.WaterSteam;

  ThermoSysPro.Fluid.HeatExchangers.FixedPowerHeatExchanger fixedPowerHeatExchanger(
    redeclare package Medium_c = Medium,
    redeclare package Medium_f = Medium,
    DW=1e6)
           annotation (Placement(transformation(extent={{-20,44},{0,64}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourcePQ(
    redeclare package Medium = Medium,
    T0=340) annotation (Placement(transformation(extent={{-70,22},{-50,42}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourcePQ1(
    redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-58,44},{-38,64}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.Sink  sinkPc(
    redeclare package Medium = Medium) annotation (Placement(transformation(extent={{40,44},{60,64}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.Sink  sinkPf(
    redeclare package Medium = Medium) annotation (Placement(transformation(extent={{20,24},{40,44}}, rotation=0)));
equation
  connect(sourcePQ.C, fixedPowerHeatExchanger.Ec) annotation (Line(points={{-50,32},{-16,32},{-16,48},{-15.8,48}},
                                                                                                        color={0,0,255}));
  connect(sourcePQ1.C, fixedPowerHeatExchanger.Ef) annotation (Line(points={{-38,54},{-20,54}}, color={0,0,255}));
  connect(fixedPowerHeatExchanger.Sc, sinkPf.C) annotation (Line(points={{-4.2,48},{-4.2,34},{20,34}}, color={0,0,0}));
  connect(fixedPowerHeatExchanger.Sf, sinkPc.C) annotation (Line(points={{-0.2,54.1},{19.9,54.1},{19.9,54},{40,54}}, color={0,0,0}));
  annotation (experiment(StopTime=1000), Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestFixedPowerHeatExchanger;
