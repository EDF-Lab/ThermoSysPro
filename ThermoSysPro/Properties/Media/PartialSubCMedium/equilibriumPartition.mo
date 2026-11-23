within ThermoSysPro.Properties.Media.PartialSubCMedium;
function equilibriumPartition
  "Liquid and vapour trace concentrations of a two-phase mixture at phase equilibrium"
  extends partialPartition;
protected
  Real RV[nSubC] "Relative volatility";
  Real xc "Vapour mass fraction bounded to [0, 1]";
algorithm
  RV := relativeVolatility(T);
  xc := min(max(x, 0), 1);
  for k in 1:nSubC loop
    C_record.Cl[k] := SubC[k]/max(1 - xc + xc*RV[k], 1e-12);
    C_record.Cg[k] := RV[k]*C_record.Cl[k];
  end for;
  annotation (Inline=true, Documentation(info="
With `RV = relativeVolatility(T)`, the phase equilibrium `Cg = RV*Cl` and the conservation `(1 - x)*Cl + x*Cg = SubC` give:

```
Cl = SubC/(1 - x + x*RV),   Cg = RV*Cl
```

This is the default of the replaceable function `tracePartition` of the two-phase components (see `partialPartition`). Components apply it to every mass transfer between phases, at the vapour mass fraction of the transferred stream. To keep their balances exact whatever the volatility, components give one phase the vapour (or liquid) part and the other phase the remainder.

The denominator is bounded below by `1e-12` to cover the limit of a non-volatile trace (`RV = 0`) in dry steam (`x = 1`).
"));
end equilibriumPartition;
