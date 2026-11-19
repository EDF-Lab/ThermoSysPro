within ThermoSysPro.Properties.Media;
partial package PartialSubCMedium "Trace substances (SubC) common to the ThermoSysPro media: number, phase partition and sink/source laws"
  constant Integer nSubC "Number of trace substances carried by the fluid (= nC of the medium)";
  constant Boolean isCompressible "true: compressible fluid (dynamic mass balance available in the volumes) - false: incompressible fluid";

  partial function partialRelativeVolatility
    "Interface of relativeVolatility: media redeclare relativeVolatility by extending it"
    extends Modelica.Icons.Function;
    input ThermoSysPro.Units.SI.Temperature T "Saturation temperature";
    output Real RV[nSubC] "Relative volatility Cg/Cl of each trace";
    annotation (Documentation(info="
Interface of the relative volatility of the traces, `RV = Cg/Cl`: ratio of the trace concentration in the vapour phase `Cg` to the trace concentration in the liquid phase `Cl`, at phase equilibrium.

- `T`: saturation temperature;
- `RV[nSubC]`: one value per trace. `RV = 1` for a homogeneous trace (both phases carry the mixture concentration), `RV = 0` for a non-volatile trace, `RV >> 1` for a trace that goes to the vapour phase.

A medium with traces redeclares `relativeVolatility` by extending this interface.
"));
  end partialRelativeVolatility;

  replaceable function relativeVolatility
    "Relative volatility of the traces, ratio of the vapour to the liquid concentration at phase equilibrium"
    extends partialRelativeVolatility;
  algorithm
    RV := fill(1, nSubC);
    annotation (Documentation(info="
Ratio `RV = Cg/Cl` of the trace concentration in the vapour phase to the trace concentration in the liquid phase, when both phases are at equilibrium at the saturation temperature `T`.

The default value `RV = 1` is the homogeneous separation: both phases carry the mixture concentration. A medium with traces that prefer one phase redeclares this function, for instance `RV = 0` for a non-volatile trace, or a temperature-dependent law for a conditioning amine:

```modelica
redeclare function relativeVolatility
  extends partialRelativeVolatility;
algorithm
  RV := fill(0, nSubC);
end relativeVolatility;
```

The two-phase Fluid components split traces between phases with their replaceable function `tracePartition`, whose default `equilibriumPartition` is built on this function.
"));
  end relativeVolatility;

end PartialSubCMedium;
