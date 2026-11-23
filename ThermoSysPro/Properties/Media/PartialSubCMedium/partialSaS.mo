within ThermoSysPro.Properties.Media.PartialSubCMedium;
partial function partialSaS "Interface of the trace sink and source laws (replaceable function SaS of the components)"
  extends Modelica.Icons.Function;
  input Real SubC[:] "Trace concentrations in the control volume";
  output Real C[size(SubC,1)] "Trace removal rate (concentration per second)";
  annotation (Documentation(info="
Interface of the functions that model a sink or a source of traces inside a control volume (chemical reaction, degradation, injection, ...).

- `SubC`: trace concentrations of the fluid in the control volume;
- `C`: rate at which each trace concentration is removed, in concentration per second. `C > 0` means that the trace is consumed, `C < 0` that it is produced.

The components declare a replaceable function `SaS`, with `noSaS` as default, and add its result to their trace balance, for instance in `DynamicDrum`:

```modelica
rhov*Vv*der(SubCv) + SubCv*BQv + rhov*Vv*SubCSaS = BSubCv;   // SubCSaS = SaS()
```

A dedicated law is used in a single component by redeclaring `SaS`, for instance a first-order degradation of rate constant `k`:

```modelica
function firstOrderDegradation
  extends partialSaS;
  input Real k = 1e-3 \"Degradation rate constant (1/s)\";
algorithm
  C := k*SubC;
end firstOrderDegradation;
```
"));
end partialSaS;
