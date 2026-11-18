within ThermoSysPro.Fluid.Examples.SimpleExamples.Media;
package WaterSteam_FullyVolatileTrace "Water/steam carrying one fully volatile trace"
  extends Properties.Media.WaterSteam(extraPropertiesNames={"Trace"}, C_nominal={0.1}, C_default={0.2});

  redeclare function relativeVolatility "Fully volatile trace: it goes to the vapour phase"
    extends partialRelativeVolatility;
  algorithm
    RV := fill(1e6, nSubC);
  end relativeVolatility;

  annotation (Documentation(info="<html>
<p>Water/steam with one trace that goes entirely to the vapour phase. The exact
limit, <code>Cl = 0</code> and <code>Cg = SubC/x</code>, corresponds to an infinite
relative volatility; <code>relativeVolatility = 1e6</code> reproduces it to better
than <code>0.1 %</code> as soon as the vapour mass fraction exceeds <code>1e-3</code>.</p>
</html>"));
end WaterSteam_FullyVolatileTrace;
