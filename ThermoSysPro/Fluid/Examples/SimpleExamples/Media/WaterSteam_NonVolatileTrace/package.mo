within ThermoSysPro.Fluid.Examples.SimpleExamples.Media;
package WaterSteam_NonVolatileTrace "Water/steam carrying one non-volatile trace"
  extends Properties.Media.WaterSteam(extraPropertiesNames={"Trace"}, C_nominal={0.1}, C_default={0.2});

  redeclare function relativeVolatility "Non-volatile trace: it stays in the liquid phase"
    extends partialRelativeVolatility;
  algorithm
    RV := fill(0, nSubC);
  end relativeVolatility;

  function approachToEquilibriumPartition
    "Example of partition law: partial approach to the phase equilibrium"
    extends partialPartition;
    input Real eta(min=0, max=1) = 1
      "Approach to the phase equilibrium: 0 = no partition (both phases carry the mixture concentration), 1 = equilibrium";
  protected
    C_BiPhase C_eq "Partition at phase equilibrium";
  algorithm
    C_eq := equilibriumPartition(SubC, x, T);
    C_record.Cl := SubC + eta*(C_eq.Cl - SubC);
    C_record.Cg := SubC + eta*(C_eq.Cg - SubC);
    annotation (Documentation(info="
Example of a partition law other than `equilibriumPartition`, for a component where the traces do not have the time to reach the phase equilibrium. Each phase concentration moves from the mixture concentration `SubC` towards its equilibrium value by the fraction `eta`:

```
Cl = SubC + eta*(Cl_eq - SubC),   Cg = SubC + eta*(Cg_eq - SubC)
```

The trace mass of the mixture is conserved for any `eta`, since both `SubC` and the equilibrium partition satisfy `(1 - x)*Cl + x*Cg = SubC`.

It is used in a single component by redeclaring its partition law, see `Junctions.TestDryer_Traces_ApproachToEquilibrium`:

```modelica
SteamDryer steamDryer(redeclare package Medium = Medium,
  redeclare function tracePartition = Medium.approachToEquilibriumPartition(eta=0.5));
```
"));
  end approachToEquilibriumPartition;

  annotation (Documentation(info="
Water/steam with one trace that does not evaporate: `relativeVolatility = 0`. The vapour phase carries no trace at equilibrium, the liquid phase carries `SubC/(1 - x)`.

The package also defines `approachToEquilibriumPartition`, an example of a partition law that a single component can use instead of the equilibrium.
"));
end WaterSteam_NonVolatileTrace;
