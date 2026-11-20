within ThermoSysPro.Properties.Media;
partial package PartialSubCMedium
  constant Integer nSubC;
  constant Boolean isCompressible;

  partial function partialRelativeVolatility
    "Interface of relativeVolatility: media redeclare relativeVolatility by extending it"
    extends Modelica.Icons.Function;
    input ThermoSysPro.Units.SI.Temperature T "Saturation temperature";
    output Real RV[nSubC] "Relative volatility C_vapour/C_liquid (1: homogeneous, 0: non-volatile)";
  end partialRelativeVolatility;

  replaceable function relativeVolatility
    "Relative volatility of the traces, ratio of the vapour to the liquid concentration at phase equilibrium"
    extends partialRelativeVolatility;
  algorithm
    RV := fill(1, nSubC);
    annotation (Documentation(info="<html>
<p>Ratio <code>RV = Cg/Cl</code> of the trace concentration in the vapour phase to
the trace concentration in the liquid phase, when both phases are at equilibrium
at the saturation temperature <code>T</code>.</p>
<p>The default value <code>RV = 1</code> is the homogeneous separation: both phases
carry the bulk concentration. A medium with traces that prefer one phase redeclares
this function, for instance <code>RV = 0</code> for a non-volatile trace, or a
temperature-dependent law for a conditioning amine:</p>
<pre>  redeclare function relativeVolatility
    extends partialRelativeVolatility;
  algorithm
    RV := fill(0, nSubC);
  end relativeVolatility;</pre>
<p>All two-phase Fluid components split traces between phases with
<code>equilibriumPartition</code>, which is built on this function.</p>
</html>"));
  end relativeVolatility;

end PartialSubCMedium;
