within ThermoSysPro.Fluid.Examples.SimpleExamples.Junctions;
model TestDryer_Traces_ApproachToEquilibrium
  "Steam dryer with a non-volatile trace that does not reach the phase equilibrium"
  extends TestDryer_Traces(
    steamDryer(redeclare function tracePartition = Medium.approachToEquilibriumPartition(eta=0.5)));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="
Same configuration as `TestDryer_Traces` (non-volatile trace), but the steam dryer uses the example partition law `Media.WaterSteam_NonVolatileTrace.approachToEquilibriumPartition` with `eta = 0.5` instead of the default `equilibriumPartition`: the inlet traces only reach half of their phase equilibrium.

At equilibrium (`TestDryer_Traces`) the vapour phase of the inlet carries no trace. Here it carries half of the mixture concentration, so the vapour outlet `sink` receives more trace and the liquid outlet `sink_cond` less. The trace mass balance of the dryer remains exact.
"));
end TestDryer_Traces_ApproachToEquilibrium;
