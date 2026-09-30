within ThermoSysPro.Properties.Media;
package DryAirIdealGas "Dry air ideal gas medium using the legacy ThermoSysPro property functions"

  extends PartialThermoSysProMedium(
    isCompressible=true,
    mediumName="DryAirIdealGas",
    substanceNames={"DryAirIdealGas"},
    singleState=false,
    SpecificEnthalpy(start=3e5, nominal=3e5),
    Density(start=1, nominal=1),
    AbsolutePressure(start=1e5, nominal=1e5),
    Temperature(start=300, nominal=300),
    ThermoStates=Modelica.Media.Interfaces.Choices.IndependentVariables.ph);

  constant ThermoSysPro.Properties.DryAirIdealGas.DryAirIdealGas data;
  constant FluidConstants dryAirConstants(
    iupacName="Dry air",
    casRegistryNumber="",
    chemicalFormula="",
    structureFormula="",
    molarMass=data.molarMass);
  constant FluidConstants fluidConstants[1]={dryAirConstants};

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
    T = ThermoSysPro.Properties.DryAirIdealGas.Temperature_h(h);
    d = ThermoSysPro.Properties.DryAirIdealGas.Density_PT(P=p, T=T);
    u = h - data.specificGasConstant*T;
    MM = fluidConstants[1].molarMass;
    R_s = data.specificGasConstant;
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
    T := ThermoSysPro.Properties.DryAirIdealGas.Temperature_h(h);
    state := ThermodynamicState(
        p=p,
        h=h,
        T=T,
        d=ThermoSysPro.Properties.DryAirIdealGas.Density_PT(P=p, T=T));
    annotation (Inline=true);
  end setState_phX;

  redeclare function extends setState_pTX
  protected
    SpecificEnthalpy h;
  algorithm
    h := ThermoSysPro.Properties.DryAirIdealGas.SpecificEnthalpy_T(T);
    state := ThermodynamicState(
        p=p,
        h=h,
        T=T,
        d=ThermoSysPro.Properties.DryAirIdealGas.Density_PT(P=p, T=T));
    annotation (Inline=true);
  end setState_pTX;

  redeclare function extends setState_psX
  algorithm
    assert(false, "DryAirIdealGas: setState_psX is not available in the legacy ThermoSysPro implementation");
    state := ThermodynamicState(
        p=p,
        h=0,
        T=0,
        d=0);
  end setState_psX;

  redeclare function extends setState_dTX
  algorithm
    state := ThermodynamicState(
        p=d*data.specificGasConstant*T,
        h=ThermoSysPro.Properties.DryAirIdealGas.SpecificEnthalpy_T(T),
        T=T,
        d=d);
    annotation (Inline=true);
  end setState_dTX;

  redeclare function extends setSmoothState
    import Modelica.Media.Common.smoothStep;
  protected
    SpecificEnthalpy h;
    AbsolutePressure p;
    Temperature T;
  algorithm
    h := smoothStep(
        x,
        state_a.h,
        state_b.h,
        x_small);
    p := smoothStep(
        x,
        state_a.p,
        state_b.p,
        x_small);
    T := ThermoSysPro.Properties.DryAirIdealGas.Temperature_h(h);
    state := ThermodynamicState(
        p=p,
        h=h,
        T=T,
        d=ThermoSysPro.Properties.DryAirIdealGas.Density_PT(P=p, T=T));
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
    u := state.h - data.specificGasConstant*state.T;
    annotation (Inline=true);
  end specificInternalEnergy;

  redeclare function extends specificEntropy
  algorithm
    assert(false, "DryAirIdealGas: specificEntropy is not available in the legacy ThermoSysPro implementation");
    s := 0;
  end specificEntropy;

  redeclare function extends specificGibbsEnergy
  algorithm
    g := state.h - state.T*specificEntropy(state);
  end specificGibbsEnergy;

  redeclare function extends specificHelmholtzEnergy
  algorithm
    f := state.h - data.specificGasConstant*state.T - state.T*specificEntropy(state);
  end specificHelmholtzEnergy;

  redeclare function extends specificHeatCapacityCp
  algorithm
    cp := ThermoSysPro.Properties.DryAirIdealGas.SpecificHeatCp_T(state.T);
    annotation (Inline=true);
  end specificHeatCapacityCp;

  redeclare function extends specificHeatCapacityCv
  algorithm
    cv := specificHeatCapacityCp(state) - data.specificGasConstant;
    annotation (Inline=true);
  end specificHeatCapacityCv;

  redeclare function extends dynamicViscosity
  algorithm
    eta := ThermoSysPro.Properties.DryAirIdealGas.DynamicViscosity_Trho(T=state.T, rho=state.d);
    annotation (Inline=true);
  end dynamicViscosity;

  redeclare function extends thermalConductivity
  algorithm
    lambda := ThermoSysPro.Properties.DryAirIdealGas.ThermalConductivity_Trho(T=state.T, rho=state.d);
    annotation (Inline=true);
  end thermalConductivity;

  redeclare function extends velocityOfSound
  algorithm
    a := sqrt(specificHeatCapacityCp(state)/specificHeatCapacityCv(state)*data.specificGasConstant*state.T);
    annotation (Inline=true);
  end velocityOfSound;

  redeclare function extends isentropicEnthalpy
  algorithm
    assert(false, "DryAirIdealGas: isentropicEnthalpy is not available in the legacy ThermoSysPro implementation");
    h_is := refState.h;
  end isentropicEnthalpy;

  redeclare function specificEnthalpy_pTX
    extends Modelica.Icons.Function;
    input AbsolutePressure p;
    input Temperature T;
    input MassFraction X[:];
    output SpecificEnthalpy h;
  algorithm
    h := ThermoSysPro.Properties.DryAirIdealGas.SpecificEnthalpy_T(T);
    annotation (Inline=true);
  end specificEnthalpy_pTX;

  redeclare function temperature_phX
    extends Modelica.Icons.Function;
    input AbsolutePressure p;
    input SpecificEnthalpy h;
    input MassFraction X[:];
    output Temperature T;
  algorithm
    T := ThermoSysPro.Properties.DryAirIdealGas.Temperature_h(h);
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
    T := ThermoSysPro.Properties.DryAirIdealGas.Temperature_h(h);
    d := ThermoSysPro.Properties.DryAirIdealGas.Density_PT(P=p, T=T);
    annotation (Inline=true);
  end density_phX;

  redeclare function extends density_derh_p
  protected
    SpecificEnthalpy delta_h=0.01*state.h;
  algorithm
    ddhp := (ThermoSysPro.Properties.DryAirIdealGas.Density_PT(P=state.p, T=ThermoSysPro.Properties.DryAirIdealGas.Temperature_h(state.h + delta_h)) - ThermoSysPro.Properties.DryAirIdealGas.Density_PT(P=state.p, T=ThermoSysPro.Properties.DryAirIdealGas.Temperature_h(state.h - delta_h)))/(2*delta_h);
    annotation (Inline=true);
  end density_derh_p;

  redeclare function extends density_derp_h
  protected
    AbsolutePressure delta_P=0.0001*state.p;
  algorithm
    ddph := (ThermoSysPro.Properties.DryAirIdealGas.Density_PT(P=state.p + delta_P, T=state.T) - ThermoSysPro.Properties.DryAirIdealGas.Density_PT(P=state.p - delta_P, T=state.T))/(2*delta_P);
    annotation (Inline=true);
  end density_derp_h;
end DryAirIdealGas;
