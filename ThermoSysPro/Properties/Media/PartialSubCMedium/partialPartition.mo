within ThermoSysPro.Properties.Media.PartialSubCMedium;
partial function partialPartition
  "Interface of the liquid/vapour trace partition laws (tracePartition function of the components)"
  extends Modelica.Icons.Function;
  input Real SubC[nSubC] "Trace concentrations of the mixture";
  input Real x "Vapour mass fraction of the mixture";
  input ThermoSysPro.Units.SI.Temperature T "Saturation temperature";
  output C_BiPhase C_record "Liquid (Cl) and vapour (Cg) trace concentrations";
  annotation (Documentation(info="
Interface of the functions that split the trace concentrations `SubC` of a two-phase mixture of vapour mass fraction `x` into a liquid concentration `Cl` and a vapour concentration `Cg`.

The two-phase components (drums, cavities, condenser, steam dryer, extraction splitter, ...) declare a replaceable function `tracePartition` constrained by this interface, with `equilibriumPartition` as default. A dedicated law can be used in a single component, for instance when the residence time is too short for the traces to reach the phase equilibrium:

```modelica
redeclare function tracePartition = MyPartitionLaw(...)
```

A partition law should conserve the trace mass of the mixture, `(1 - x)*Cl + x*Cg = SubC`. The components compute one phase from the balance anyway, so their balances remain exact.
"));
end partialPartition;
