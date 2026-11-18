within ThermoSysPro.Properties.Media.PartialSubCMedium;
function equilibriumPartition
  "Liquid and vapour trace concentrations of a two-phase mixture at phase equilibrium"
  extends Modelica.Icons.Function;
  input Real SubC[nSubC] "Trace concentrations of the mixture";
  input Real x "Vapour mass fraction of the mixture";
  input ThermoSysPro.Units.SI.Temperature T "Saturation temperature";
  output C_BiPhase C_record "Liquid (Cl) and vapour (Cg) trace concentrations";
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
  annotation (Inline=true, Documentation(info="<html>
<p>With <code>RV = relativeVolatility(T)</code>, equilibrium <code>Cg = RV*Cl</code>
and conservation <code>(1 - x)*Cl + x*Cg = SubC</code> give</p>
<pre>  Cl = SubC/(1 - x + x*RV),   Cg = RV*Cl</pre>
<p>This is the only phase-partition law of the library. Components apply it to every
mass transfer between phases, at the vapour mass fraction of the transferred stream.
To keep their balances exact whatever the volatility, components give one phase the
vapour (or liquid) part and the other phase the remainder.</p>
<p>The denominator is bounded below by <code>1e-12</code> to cover the limit of a
non-volatile trace (<code>RV = 0</code>) in dry steam (<code>x = 1</code>).</p>
</html>"));
end equilibriumPartition;
