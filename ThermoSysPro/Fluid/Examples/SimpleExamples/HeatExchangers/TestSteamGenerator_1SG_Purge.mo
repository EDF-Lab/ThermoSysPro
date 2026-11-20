within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestSteamGenerator_1SG_Purge
  extends TestSteamGenerator_1SG(steamGenerator(volumeA(dynamic_mass_balance=true)));

  parameter Units.SI.MassFlowRate Q_Purges=5.55 "Purge massflowrate per SG" annotation (Dialog(group="Secondary"));

  ThermoSysPro.Fluid.BoundaryConditions.SinkQ sinkQ1(redeclare package Medium = Medium, Q0=Q_Purges, h0=1.278e6) annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  ThermoSysPro.Fluid.Sensors.SensorT SensorT_Tpurge(redeclare package Medium = Medium) annotation (Placement(transformation(
        origin={58,8},
        extent={{-10,-10},{10,10}},
        rotation=0)));
equation
  connect(SensorT_Tpurge.C2, sinkQ1.C) annotation (Line(points={{68.2,0},{80,0}}, color={0,0,255}));
  connect(steamGenerator.fluidOutletI_purge, SensorT_Tpurge.C1) annotation (Line(points={{7.8,-20.8},{7.8,-20},{26,-20},{26,0},{48,0}}, color={255,0,0}));
  annotation (Documentation(info="
Fluid counterpart of `ThermoSysPro.Examples.SimpleExamples.TestSteamGenerator_1SG_Purge`: same as `TestSteamGenerator_1SG`, with a purge
flow rate imposed on the purge outlet of the steam generator.
"));
end TestSteamGenerator_1SG_Purge;
