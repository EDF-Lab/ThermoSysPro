within ThermoSysPro.Properties.Media.PartialSubCMedium;
record C_BiPhase "Liquid and vapour trace concentrations of a two-phase mixture"
  Real Cl[nSubC] "Trace concentrations in the liquid phase";
  Real Cg[nSubC] "Trace concentrations in the vapour phase";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="
Result of the trace partition laws (`partialPartition`, `equilibriumPartition`): concentrations `Cl` in the liquid phase and `Cg` in the vapour phase of a two-phase mixture, one value per trace.
"));
end C_BiPhase;
