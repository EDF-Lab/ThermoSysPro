within ThermoSysPro.Properties.Media;
package Oil_TherminolVP1 "Therminol VP1 oil medium using the legacy ThermoSysPro property functions"

  extends PartialThermoSysProMedium(
    isCompressible=false,
    mediumName="Oil_TherminolVP1",
    substanceNames={"Oil_TherminolVP1"},
    singleState=false,
    SpecificEnthalpy(start=3.0e5, nominal=3.0e5),
    Density(start=900, nominal=900),
    AbsolutePressure(start=1e5, nominal=1e5),
    Temperature(start=400, nominal=400),
    ThermoStates=Modelica.Media.Interfaces.Choices.IndependentVariables.ph);

  constant FluidConstants oilConstants(
    iupacName="Therminol VP1",
    casRegistryNumber="",
    chemicalFormula="",
    structureFormula="",
    molarMass=0.166);
  constant FluidConstants fluidConstants[1]={oilConstants};

  redeclare record extends ThermodynamicState "Thermodynamic state"
    SpecificEnthalpy h "Specific enthalpy";
    Density d "Density";
    Temperature T "Temperature";
    AbsolutePressure p "Pressure";
  end ThermodynamicState;

  redeclare replaceable model extends BaseProperties(
    h(stateSelect=StateSelect.prefer),
    d(stateSelect=StateSelect.default),
    T(stateSelect=StateSelect.default),
    p(stateSelect=StateSelect.prefer))
    "Base properties of Therminol VP1"
  equation
    T = ThermoSysPro.Properties.Oil_TherminolVP1.Temperature_h(h);
    d = ThermoSysPro.Properties.Oil_TherminolVP1.Density_T(T);
    u = h - p/d;
    MM = fluidConstants[1].molarMass;
    R_s = 0;
    state = ThermodynamicState(p=p, h=h, T=T, d=d);
  end BaseProperties;

  redeclare function extends setState_phX
    "Return thermodynamic state from p and h"
  algorithm
    state := ThermodynamicState(
      p=p,
      h=h,
      T=ThermoSysPro.Properties.Oil_TherminolVP1.Temperature_h(h),
      d=ThermoSysPro.Properties.Oil_TherminolVP1.Density_T(ThermoSysPro.Properties.Oil_TherminolVP1.Temperature_h(h)));
    annotation (Inline=true);
  end setState_phX;

  redeclare function extends setState_pTX
    "Return thermodynamic state from p and T"
  protected
    SpecificEnthalpy h;
  algorithm
    h := ThermoSysPro.Properties.Oil_TherminolVP1.Enthalpy_T(T);
    state := ThermodynamicState(
      p=p,
      h=h,
      T=T,
      d=ThermoSysPro.Properties.Oil_TherminolVP1.Density_T(T));
    annotation (Inline=true);
  end setState_pTX;

  redeclare function extends setState_psX
    "Return thermodynamic state from p and s"
  algorithm
    assert(false, "Oil_TherminolVP1: setState_psX is not available in the legacy ThermoSysPro implementation");
    state := ThermodynamicState(p=p, h=0, T=0, d=0);
  end setState_psX;

  redeclare function extends setState_dTX
    "Return thermodynamic state from d and T"
  algorithm
    state := ThermodynamicState(
      p=reference_p,
      h=ThermoSysPro.Properties.Oil_TherminolVP1.Enthalpy_T(T),
      T=T,
      d=d);
    annotation (Inline=true);
  end setState_dTX;

  redeclare function extends setSmoothState
    import Modelica.Media.Common.smoothStep;
  algorithm
    state := ThermodynamicState(
      p=smoothStep(x, state_a.p, state_b.p, x_small),
      h=smoothStep(x, state_a.h, state_b.h, x_small),
      T=ThermoSysPro.Properties.Oil_TherminolVP1.Temperature_h(smoothStep(x, state_a.h, state_b.h, x_small)),
      d=ThermoSysPro.Properties.Oil_TherminolVP1.Density_T(ThermoSysPro.Properties.Oil_TherminolVP1.Temperature_h(smoothStep(x, state_a.h, state_b.h, x_small))));
    annotation (Inline=true);
  end setSmoothState;

  redeclare function extends pressure
  algorithm
    p := state.p;
    annotation (Inline=true);
  end pressure;

  redeclare function extends temperature
  algorithm
    T := state.T;
    annotation (Inline=true);
  end temperature;

  redeclare function extends density
  algorithm
    d := state.d;
    annotation (Inline=true);
  end density;

  redeclare function extends specificEnthalpy
  algorithm
    h := state.h;
    annotation (Inline=true);
  end specificEnthalpy;

  redeclare function extends specificInternalEnergy
  algorithm
    u := state.h - state.p/state.d;
    annotation (Inline=true);
  end specificInternalEnergy;

  redeclare function extends specificEntropy
  algorithm
    assert(false, "Oil_TherminolVP1: specificEntropy is not available in the legacy ThermoSysPro implementation");
    s := 0;
  end specificEntropy;

  redeclare function extends specificGibbsEnergy
  algorithm
    g := state.h - state.T*specificEntropy(state);
  end specificGibbsEnergy;

  redeclare function extends specificHelmholtzEnergy
  algorithm
    f := state.h - state.p/state.d - state.T*specificEntropy(state);
  end specificHelmholtzEnergy;

  redeclare function extends specificHeatCapacityCp
  algorithm
    cp := ThermoSysPro.Properties.Oil_TherminolVP1.SpecificHeatCp_T(state.T);
    annotation (Inline=true);
  end specificHeatCapacityCp;

  redeclare function extends specificHeatCapacityCv
  algorithm
    cv := specificHeatCapacityCp(state);
    annotation (Inline=true);
  end specificHeatCapacityCv;

  redeclare function extends dynamicViscosity
  algorithm
    eta := ThermoSysPro.Properties.Oil_TherminolVP1.DynamicViscosity_T(state.T);
    annotation (Inline=true);
  end dynamicViscosity;

  redeclare function extends thermalConductivity
  algorithm
    lambda := ThermoSysPro.Properties.Oil_TherminolVP1.ThermalConductivity_T(state.T);
    annotation (Inline=true);
  end thermalConductivity;

  redeclare function extends velocityOfSound
  algorithm
    assert(false, "Oil_TherminolVP1: velocityOfSound is not available in the legacy ThermoSysPro implementation");
    a := 0;
  end velocityOfSound;

  redeclare function extends isentropicEnthalpy
  algorithm
    assert(false, "Oil_TherminolVP1: isentropicEnthalpy is not available in the legacy ThermoSysPro implementation");
    h_is := refState.h;
  end isentropicEnthalpy;

  redeclare function specificEnthalpy_pTX
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input MassFraction X[:] "Mass fractions";
    output SpecificEnthalpy h "Specific enthalpy";
  algorithm
    h := ThermoSysPro.Properties.Oil_TherminolVP1.Enthalpy_T(T);
    annotation (Inline=true);
  end specificEnthalpy_pTX;

  redeclare function temperature_phX
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction X[:] "Mass fractions";
    output Temperature T "Temperature";
  algorithm
    T := ThermoSysPro.Properties.Oil_TherminolVP1.Temperature_h(h);
    annotation (Inline=true);
  end temperature_phX;

  redeclare function density_phX
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction X[:] "Mass fractions";
    output Density d "Density";
  algorithm
    d := ThermoSysPro.Properties.Oil_TherminolVP1.Density_T(ThermoSysPro.Properties.Oil_TherminolVP1.Temperature_h(h));
    annotation (Inline=true);
  end density_phX;

  redeclare function extends density_derh_p
  protected
    SpecificEnthalpy delta_h=0.01*state.h;
  algorithm
    ddhp := (ThermoSysPro.Properties.Oil_TherminolVP1.Density_T(ThermoSysPro.Properties.Oil_TherminolVP1.Temperature_h(state.h + delta_h))
      - ThermoSysPro.Properties.Oil_TherminolVP1.Density_T(ThermoSysPro.Properties.Oil_TherminolVP1.Temperature_h(state.h - delta_h)))/(2*delta_h);
    annotation (Inline=true);
  end density_derh_p;

  redeclare function extends density_derp_h
  algorithm
    ddph := 1e-8;
    annotation (Inline=true);
  end density_derp_h;

  annotation (Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2024</b></p>
<p><b>ThermoSysPro Version 4.1</b></p>
</html>"));
end Oil_TherminolVP1;
