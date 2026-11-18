within ThermoSysPro.Fluid.Examples.SimpleExamples.Media;
package WaterSteam_NonVolatileTrace "Water/steam carrying one non-volatile trace"
  extends Properties.Media.WaterSteam(extraPropertiesNames={"Trace"}, C_nominal={0.1}, C_default={0.2});

  redeclare function relativeVolatility "Non-volatile trace: it stays in the liquid phase"
    extends partialRelativeVolatility;
  algorithm
    RV := fill(0, nSubC);
  end relativeVolatility;

  annotation (Documentation(info="<html>
<p>Water/steam with one trace that does not evaporate: <code>relativeVolatility = 0</code>.
The vapour phase carries no trace at equilibrium, the liquid phase carries
<code>SubC/(1 - x)</code>.</p>
</html>"));
end WaterSteam_NonVolatileTrace;
