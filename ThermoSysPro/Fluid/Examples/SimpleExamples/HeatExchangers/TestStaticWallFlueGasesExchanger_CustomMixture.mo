within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestStaticWallFlueGasesExchanger_CustomMixture
  extends ThermoSysPro.UsersGuide.Icons.Example;

  package Medium
    extends ThermoSysPro.Properties.Media.PartialSubCMedium(nSubC=nC, isCompressible=true);
    extends Modelica.Media.IdealGases.Common.MixtureGasNasa(
    mediumName="CustomCombustionGas",
    data={Modelica.Media.IdealGases.Common.SingleGasesData.CO2,
          Modelica.Media.IdealGases.Common.SingleGasesData.H2O,
          Modelica.Media.IdealGases.Common.SingleGasesData.O2,
          Modelica.Media.IdealGases.Common.SingleGasesData.N2},
    fluidConstants={Modelica.Media.IdealGases.Common.FluidData.CO2,
                    Modelica.Media.IdealGases.Common.FluidData.H2O,
                    Modelica.Media.IdealGases.Common.FluidData.O2,
                    Modelica.Media.IdealGases.Common.FluidData.N2},
    substanceNames={"CO2","H2O","O2","N2"},
    reference_X={0.12,0.08,0.05,0.75});
  end Medium;

  parameter Integer Ns=3;
  parameter Medium.MassFraction X0[Medium.nX]={0.12,0.08,0.05,0.75};

  ThermoSysPro.Fluid.HeatExchangers.StaticWallFlueGasesExchanger exchanger(
    redeclare package Medium = Medium,
    Ns=Ns,
    DPc=1e-4,
    Tp0=500,
    C1(P(start=4500000), h(start=700000), Q(start=10), Xi(start={0.12,0.08,0.05,0.75})),
    C2(P(start=4450000), h(start=650000), Q(start=10), Xi(start={0.12,0.08,0.05,0.75})),
    h(start=fill(700000, Ns + 2)),
    hb(start=fill(700000, Ns + 1)),
    T1(start=fill(650, Ns)),
    T2(start=fill(650, Ns + 1))) annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ source(
    redeclare package Medium = Medium,
    P0=4500000,
    Q0=10,
    option_temperature=true,
    T0=650,
    X0=X0) annotation (Placement(transformation(extent={{-70,-10},{-50,10}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink(
    redeclare package Medium = Medium,
    option_temperature=false,
    h0=650000) annotation (Placement(transformation(extent={{50,-10},{70,10}}, rotation=0)));
  ThermoSysPro.Thermal.BoundaryConditions.HeatSource wall(
    T0=fill(500, Ns),
    option_temperature=1) annotation (Placement(transformation(extent={{-10,50},{10,70}}, rotation=0)));
equation
  connect(source.C, exchanger.C1) annotation (Line(points={{-50,0},{-10,0}}, color={0,0,255}));
  connect(exchanger.C2, sink.C) annotation (Line(points={{10,0},{50,0}}, color={0,0,255}));
  connect(wall.C, exchanger.CTh) annotation (Line(points={{0,50.2},{0,3}}, color={255,127,0}));
  annotation (experiment(StopTime=1000), Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestStaticWallFlueGasesExchanger_CustomMixture;
