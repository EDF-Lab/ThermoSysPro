within ThermoSysPro.Properties.Media;
package MoltenSalt "Molten salt medium using the legacy ThermoSysPro property functions"

  extends PartialThermoSysProMedium(
    isCompressible=false,
    mediumName="MoltenSalt",
    substanceNames={"MoltenSalt"},
    singleState=false,
    SpecificEnthalpy(start=3e5, nominal=3e5),
    Density(start=1800, nominal=1800),
    AbsolutePressure(start=1e5, nominal=1e5),
    Temperature(start=600, nominal=600),
    ThermoStates=Modelica.Media.Interfaces.Choices.IndependentVariables.ph);

  constant FluidConstants saltConstants(
    iupacName="Molten salt",
    casRegistryNumber="",
    chemicalFormula="",
    structureFormula="",
    molarMass=0.1);
  constant FluidConstants fluidConstants[1]={saltConstants};

  redeclare record extends ThermodynamicState
    SpecificEnthalpy h;
    Density d;
    Temperature T;
    AbsolutePressure p;
  end ThermodynamicState;

  redeclare replaceable model extends BaseProperties(
    h(stateSelect=StateSelect.prefer),
    d(stateSelect=StateSelect.default),
    T(stateSelect=StateSelect.default),
    p(stateSelect=StateSelect.prefer))
  equation
    T = ThermoSysPro.Properties.MoltenSalt.Temperature_h(h);
    d = ThermoSysPro.Properties.MoltenSalt.Density_T(T);
    u = h - p/d;
    MM = fluidConstants[1].molarMass;
    R_s = 0;
    state = ThermodynamicState(
        p=p,
        h=h,
        T=T,
        d=d);
  end BaseProperties;

  redeclare function extends setState_phX
  protected
    Temperature T;
  algorithm
    T := ThermoSysPro.Properties.MoltenSalt.Temperature_h(h);
    state := ThermodynamicState(
        p=p,
        h=h,
        T=T,
        d=ThermoSysPro.Properties.MoltenSalt.Density_T(T));
    annotation (Inline=true);
  end setState_phX;

  redeclare function extends setState_pTX
  protected
    SpecificEnthalpy h;
  algorithm
    h := ThermoSysPro.Properties.MoltenSalt.SpecificEnthalpy_T(T);
    state := ThermodynamicState(
        p=p,
        h=h,
        T=T,
        d=ThermoSysPro.Properties.MoltenSalt.Density_T(T));
    annotation (Inline=true);
  end setState_pTX;

  redeclare function extends setState_psX
  algorithm
    assert(false, "MoltenSalt: setState_psX is not available in the legacy ThermoSysPro implementation");
    state := ThermodynamicState(
        p=p,
        h=0,
        T=0,
        d=0);
  end setState_psX;

  redeclare function extends setState_dTX
  algorithm
    state := ThermodynamicState(
        p=reference_p,
        h=ThermoSysPro.Properties.MoltenSalt.SpecificEnthalpy_T(T),
        T=T,
        d=d);
    annotation (Inline=true);
  end setState_dTX;

  redeclare function extends setSmoothState
    import Modelica.Media.Common.smoothStep;
  protected
    SpecificEnthalpy h;
    Temperature T;
  algorithm
    h := smoothStep(
        x,
        state_a.h,
        state_b.h,
        x_small);
    T := ThermoSysPro.Properties.MoltenSalt.Temperature_h(h);
    state := ThermodynamicState(
        p=smoothStep(
          x,
          state_a.p,
          state_b.p,
          x_small),
        h=h,
        T=T,
        d=ThermoSysPro.Properties.MoltenSalt.Density_T(T));
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
    assert(false, "MoltenSalt: specificEntropy is not available in the legacy ThermoSysPro implementation");
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
    cp := ThermoSysPro.Properties.MoltenSalt.SpecificHeatCapacityCp_T(state.T);
    annotation (Inline=true);
  end specificHeatCapacityCp;

  redeclare function extends specificHeatCapacityCv
  algorithm
    cv := specificHeatCapacityCp(state);
    annotation (Inline=true);
  end specificHeatCapacityCv;

  redeclare function extends dynamicViscosity
  algorithm
    eta := ThermoSysPro.Properties.MoltenSalt.DynamicViscosity_T(state.T);
    annotation (Inline=true);
  end dynamicViscosity;

  redeclare function extends thermalConductivity
  algorithm
    lambda := ThermoSysPro.Properties.MoltenSalt.ThermalConductivity_T(state.T);
    annotation (Inline=true);
  end thermalConductivity;

  redeclare function extends velocityOfSound
  algorithm
    assert(false, "MoltenSalt: velocityOfSound is not available in the legacy ThermoSysPro implementation");
    a := 0;
  end velocityOfSound;

  redeclare function extends isentropicEnthalpy
  algorithm
    assert(false, "MoltenSalt: isentropicEnthalpy is not available in the legacy ThermoSysPro implementation");
    h_is := refState.h;
  end isentropicEnthalpy;

  redeclare function specificEnthalpy_pTX
    extends Modelica.Icons.Function;
    input AbsolutePressure p;
    input Temperature T;
    input MassFraction X[:];
    output SpecificEnthalpy h;
  algorithm
    h := ThermoSysPro.Properties.MoltenSalt.SpecificEnthalpy_T(T);
    annotation (Inline=true);
  end specificEnthalpy_pTX;

  redeclare function temperature_phX
    extends Modelica.Icons.Function;
    input AbsolutePressure p;
    input SpecificEnthalpy h;
    input MassFraction X[:];
    output Temperature T;
  algorithm
    T := ThermoSysPro.Properties.MoltenSalt.Temperature_h(h);
    annotation (Inline=true);
  end temperature_phX;

  redeclare function density_phX
    extends Modelica.Icons.Function;
    input AbsolutePressure p;
    input SpecificEnthalpy h;
    input MassFraction X[:];
    output Density d;
  protected
    Temperature T;
  algorithm
    T := ThermoSysPro.Properties.MoltenSalt.Temperature_h(h);
    d := ThermoSysPro.Properties.MoltenSalt.Density_T(T);
    annotation (Inline=true);
  end density_phX;

  redeclare function extends density_derh_p
  protected
    SpecificEnthalpy delta_h=0.01*state.h;
  algorithm
    ddhp := (ThermoSysPro.Properties.MoltenSalt.Density_T(ThermoSysPro.Properties.MoltenSalt.Temperature_h(state.h + delta_h)) - ThermoSysPro.Properties.MoltenSalt.Density_T(ThermoSysPro.Properties.MoltenSalt.Temperature_h(state.h - delta_h)))/(2*delta_h);
    annotation (Inline=true);
  end density_derh_p;

  redeclare function extends density_derp_h
  algorithm
    ddph := 1e-8;
    annotation (Inline=true);
  end density_derp_h;
end MoltenSalt;
