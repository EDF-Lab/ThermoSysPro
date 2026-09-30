within PbHE_V2.old;
model TEstHE2_Test_HE_TSPcalcDTLM
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Rampe rampe2(
    Starttime=10,
    Duration=20,
    Initialvalue=5,
    Finalvalue=2)
    annotation (Placement(transformation(extent={{48,10},{68,30}})));
  ThermoSysPro.Fluid.HeatExchangers.StaticExchangerKS staticExchangerKS3(
    K=2500,
    S=1,
    Kc=40,
    Kf=40,
    p_rhof=1000)
    annotation (Placement(transformation(extent={{-10,16},{-38,-2}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourceColdWater4(
    ftype=ThermoSysPro.Fluid.Interfaces.PropertyInterfaces.FluidType.WaterSteam,
    P0=501000,
    Q0=2,
    T0=293.15,
    option_temperature=true)
                 annotation (Placement(transformation(
        extent={{-17,-18},{17,18}},
        rotation=-90,
        origin={22,-9})));
  ThermoSysPro.Fluid.BoundaryConditions.Sink  sinkP5(T0=323.15)
                                                     annotation (Placement(transformation(extent={{-18,-20},
            {18,20}},
        rotation=90,
        origin={-76,6})));
  ThermoSysPro.Fluid.BoundaryConditions.Sink  sinkP6(T0=323.15)
                                                     annotation (Placement(transformation(extent={{-18,-20},
            {18,20}},
        rotation=90,
        origin={-76,46})));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourceColdWater5(
    ftype=ThermoSysPro.Fluid.Interfaces.PropertyInterfaces.FluidType.WaterSteam,
    P0=501000,
    Q0=2,
    T0=333.15,
    option_temperature=true)
                 annotation (Placement(transformation(
        extent={{-16,-16},{16,16}},
        rotation=-90,
        origin={20,40})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Rampe rampe3(
    Starttime=60,
    Duration=20,
    Initialvalue=2,
    Finalvalue=2.0002)
    annotation (Placement(transformation(extent={{-22,62},{-2,82}})));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkP(P0=990000) annotation (Placement(transformation(extent={{276,12},
            {296,32}})));
  ThermoSysPro.Fluid.PressureLosses.ControlValve controlValve(p_rho(displayUnit
        ="kg/m3") = 1350, Pm(start=1000000))                  annotation (Placement(transformation(extent={{138,18},
            {158,38}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante(k=0.5)
    annotation (Placement(transformation(extent={{116,56},{136,76}})));
  ThermoSysPro.Fluid.HeatExchangers.StaticExchangerKS staticExchangerKS(
    Kc=10,
    Kf=10,
    Tec(start=293.15),
    Tsc(start=293.15),
    Tef(start=293.15),
    Tsf(start=293.15)) annotation (Placement(transformation(extent={{218,8},{
            238,28}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceQ(
    ftype=ThermoSysPro.Fluid.Interfaces.PropertyInterfaces.FluidType.WaterSteam,
    T0=288.15,
    option_temperature=true)                            annotation (Placement(transformation(extent={{152,-18},
            {172,2}})));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkP1(P0=290000,
      option_temperature=false)                                annotation (Placement(transformation(extent={{274,-28},
            {294,-8}})));
  ThermoSysPro.Fluid.Volumes.VolumeA volumeA(
    ftype=ThermoSysPro.Fluid.Interfaces.PropertyInterfaces.FluidType.WaterSteam,
    dynamic_energy_balance=false,
    steady_state=true,
    P(start=1000000),
    h(start=230000)) annotation (Placement(transformation(extent={{172,12},{192,
            32}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceQ1(
    ftype=ThermoSysPro.Fluid.Interfaces.PropertyInterfaces.FluidType.WaterSteam,
    T0=288.15,
    option_temperature=true)                            annotation (Placement(transformation(extent={{98,12},
            {118,32}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Rampe rampe1(
    Starttime=10,
    Duration=10,
    Initialvalue=0.1,
    Finalvalue=0.01)
    annotation (Placement(transformation(extent={{476,-2},{496,18}})));
  Components.old.StaticExchanger_TSPcalcDTLM staticExchangerKS1(
    K=2500,
    S=1,
    Kc=40,
    Kf=40,
    p_rhof=1000)
    annotation (Placement(transformation(extent={{418,4},{390,-14}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourceColdWater1(
    ftype=ThermoSysPro.Fluid.Interfaces.PropertyInterfaces.FluidType.WaterSteam,
    P0=501000,
    Q0=2,
    T0=293.15,
    option_temperature=true)
                 annotation (Placement(transformation(
        extent={{-17,-18},{17,18}},
        rotation=-90,
        origin={450,-21})));
  ThermoSysPro.Fluid.BoundaryConditions.Sink  sinkP2(T0=323.15)
                                                     annotation (Placement(transformation(extent={{-18,-20},
            {18,20}},
        rotation=90,
        origin={352,-6})));
  ThermoSysPro.Fluid.BoundaryConditions.Sink  sinkP3(T0=323.15)
                                                     annotation (Placement(transformation(extent={{-18,-20},
            {18,20}},
        rotation=90,
        origin={352,34})));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourceColdWater2(
    ftype=ThermoSysPro.Fluid.Interfaces.PropertyInterfaces.FluidType.WaterSteam,
    P0=501000,
    Q0=2,
    T0=333.15,
    option_temperature=true)
                 annotation (Placement(transformation(
        extent={{-16,-16},{16,16}},
        rotation=-90,
        origin={448,28})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Rampe rampe4(
    Starttime=60,
    Duration=20,
    Initialvalue=4,
    Finalvalue=4)
    annotation (Placement(transformation(extent={{406,50},{426,70}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Rampe rampe5(
    Starttime=30,
    Duration=1,
    Initialvalue=20 + 273.15,
    Finalvalue=25 + 273.15)
    annotation (Placement(transformation(extent={{356,-90},{376,-70}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Rampe rampe6(
    Starttime=40,
    Duration=1,
    Initialvalue=60 + 273.15,
    Finalvalue=65 + 273.15)
    annotation (Placement(transformation(extent={{348,68},{368,88}})));
equation
  connect(staticExchangerKS3.Sf,sinkP5. C) annotation (Line(
      points={{-38,4.3},{-46,4.3},{-46,-14},{-76,-14},{-76,-12}},
      color={0,128,255},
      thickness=0.5));
  connect(sourceColdWater4.C,staticExchangerKS3. Ef) annotation (Line(points={{22,-26},
          {22,-32},{-4,-32},{-4,4.3},{-10,4.3}},            color={0,0,0}));
  connect(sinkP6.C,staticExchangerKS3. Sc) annotation (Line(points={{-76,28},{
          -36,28},{-36,9.7},{-38,9.7}},                          color={0,0,0}));
  connect(sourceColdWater5.C,staticExchangerKS3. Ec) annotation (Line(points={{20,24},
          {20,12},{-4,12},{-4,9.7},{-10,9.7}},                     color={0,0,0}));
  connect(rampe2.y,sourceColdWater4. IMassFlow) annotation (Line(points={{69,20},
          {74,20},{74,-9},{31,-9}},        color={0,0,255}));
  connect(rampe3.y,sourceColdWater5. IMassFlow) annotation (Line(points={{-1,72},
          {42,72},{42,40},{28,40}},                          color={0,0,255}));
  connect(constante.y,controlValve. Ouv) annotation (Line(points={{137,66},{148,
          66},{148,39}},                                                                       color={0,0,255}));
  connect(staticExchangerKS.Sf,sinkP. C) annotation (Line(points={{238,21},{264,
          21},{264,22},{276,22}},                                                                   color={0,0,0}));
  connect(sourceQ.C,staticExchangerKS. Ec) annotation (Line(points={{172,-8},{
          210,-8},{210,15},{218,15}},                                                                  color={0,0,0}));
  connect(staticExchangerKS.Sc,sinkP1. C)
    annotation (Line(points={{238,15},{246,15},{246,10},{254,10},{254,-18},{274,
          -18}},                                                                 color={0,0,0}));
  connect(controlValve.C2,volumeA. Ce1) annotation (Line(points={{158,22},{172,
          22}},                                                                      color={0,0,0}));
  connect(volumeA.Cs1,staticExchangerKS. Ef) annotation (Line(points={{192,22},
          {205,22},{205,21},{218,21}},                                                                  color={0,0,0}));
  connect(sourceQ1.C,controlValve. C1) annotation (Line(points={{118,22},{138,
          22}},                                                                     color={0,0,0}));
  connect(staticExchangerKS1.Sf, sinkP2.C) annotation (Line(
      points={{390,-7.7},{382,-7.7},{382,-26},{352,-26},{352,-24}},
      color={0,128,255},
      thickness=0.5));
  connect(sourceColdWater1.C, staticExchangerKS1.Ef) annotation (Line(points={{
          450,-38},{450,-44},{424,-44},{424,-7.7},{418,-7.7}}, color={0,0,0}));
  connect(sinkP3.C, staticExchangerKS1.Sc) annotation (Line(points={{352,16},{
          392,16},{392,-2.3},{390,-2.3}}, color={0,0,0}));
  connect(sourceColdWater2.C, staticExchangerKS1.Ec) annotation (Line(points={{
          448,12},{448,0},{424,0},{424,-2.3},{418,-2.3}}, color={0,0,0}));
  connect(rampe1.y,sourceColdWater1. IMassFlow) annotation (Line(points={{497,8},
          {502,8},{502,-21},{459,-21}},    color={0,0,255}));
  connect(rampe4.y,sourceColdWater2. IMassFlow) annotation (Line(points={{427,60},
          {470,60},{470,28},{456,28}},                       color={0,0,255}));
  connect(rampe5.y, sourceColdWater1.ISpecificEnthalpyOrTemperature)
    annotation (Line(points={{377,-80},{404,-80},{404,-86},{432,-86},{432,-21},
          {441,-21}}, color={0,0,255}));
  connect(rampe6.y, sourceColdWater2.ISpecificEnthalpyOrTemperature)
    annotation (Line(points={{369,78},{382,78},{382,44},{440,44},{440,28}},
        color={0,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{540,
            100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            540,100}})),
    experiment(
      StopTime=100,
      __Dymola_NumberOfIntervals=1000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end TEstHE2_Test_HE_TSPcalcDTLM;
