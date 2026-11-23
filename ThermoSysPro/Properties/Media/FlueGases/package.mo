within ThermoSysPro.Properties.Media;
package FlueGases "Flue gases library inherited from Modelica.Media"
  import Modelica.Media.Interfaces.Choices.ReferenceEnthalpy;

  extends PartialSubCMedium(nSubC=nC,isCompressible=true);
  extends Modelica.Media.IdealGases.Common.MixtureGasNasa(
    mediumName="MediaMonomeld",
    data={Modelica.Media.IdealGases.Common.SingleGasesData.N2,Modelica.Media.IdealGases.Common.SingleGasesData.O2,
          Modelica.Media.IdealGases.Common.SingleGasesData.H2O,Modelica.Media.IdealGases.Common.SingleGasesData.CO2,
          Modelica.Media.IdealGases.Common.SingleGasesData.SO2},
    fluidConstants={Modelica.Media.IdealGases.Common.FluidData.N2,Modelica.Media.IdealGases.Common.FluidData.O2,
                    Modelica.Media.IdealGases.Common.FluidData.H2O,Modelica.Media.IdealGases.Common.FluidData.CO2,
                    Modelica.Media.IdealGases.Common.FluidData.SO2},
    substanceNames={"Nitrogen","Oxygen","Water","Carbondioxide","Sulfurdioxide"},
    reference_X={0.768,0.232,0.0,0.0,0.0},
    referenceChoice=ReferenceEnthalpy.UserDefined,
    h_offset = hr - hr_FlueGases + Modelica.Media.IdealGases.Common.SingleGasesData.H2O.H0);

    constant Units.SI.SpecificEnthalpy hr=2501569 "ThermoSysPro Water/steam reference specific enthalpy at 0.01°C";
    constant Units.SI.SpecificEnthalpy hr_FlueGases=503298 "FlueGases reference specific enthalpy, computed from ThermoSysPro.Properties.ModelicaMediaFlueGases.specificEnthalpy(state0) at (0.006112 bars, 0.01°C)";

  redeclare function extends density_derh_p "Density derivative by specific enthalpy"

  protected
    Units.SI.SpecificEntropy s "Flue gases specific entropy";
    Units.SI.Density rho "Flue gaases density";
    Units.SI.SpecificHeatCapacity cp "Specific heat capacity";
    Units.SI.SpecificHeatCapacity R "gas constant";
    Units.SI.DerDensityByEnthalpy drhodh
      "Derivative of the density wrt. the specific enthalpy at constant pressure";

  algorithm
    s := ThermoSysPro.Properties.ModelicaMediaFlueGases.specificEntropy(state);
    rho := ThermoSysPro.Properties.ModelicaMediaFlueGases.density(state);
    cp := ThermoSysPro.Properties.ModelicaMediaFlueGases.specificHeatCapacityCp(state);
    R := ThermoSysPro.Properties.ModelicaMediaFlueGases.gasConstant(state);

    drhodh := -rho*rho*R/(state.p*cp);
    ddhp := drhodh;

    annotation (
      smoothOrder=2,
      Icon(graphics),
      Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2010</b></p>
</HTML>
<html>
<p><b>ThermoSysPro Version 2.0</b></p>
</HTML>
</html>"));

  end density_derh_p;

  redeclare function extends density_derp_h "Density derivative by pressure"
  protected
    Units.SI.SpecificEntropy s "Flue gases specific entropy";
    Units.SI.Density rho "Flue gaases density";
    Units.SI.SpecificHeatCapacity cp "Specific heat capacity";
    Units.SI.SpecificHeatCapacity R "gas constant";
    Units.SI.DerDensityByPressure drhodp "Derivative of the density wrt. the pressure at constant specific enthalpy";
  algorithm
    s := ThermoSysPro.Properties.ModelicaMediaFlueGases.specificEntropy(state);
    rho := ThermoSysPro.Properties.ModelicaMediaFlueGases.density(state);
    cp := ThermoSysPro.Properties.ModelicaMediaFlueGases.specificHeatCapacityCp(state);
    R := ThermoSysPro.Properties.ModelicaMediaFlueGases.gasConstant(state);

    drhodp := (rho*rho*R)/(state.p*cp)*(1/rho + state.T/state.p*(cp - R));
    ddph := drhodp;
    annotation (Inline=true);
  end density_derp_h;
  annotation (Documentation(info="<html>

</html>"));
end FlueGases;
