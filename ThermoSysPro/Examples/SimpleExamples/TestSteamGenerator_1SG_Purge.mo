within ThermoSysPro.Examples.SimpleExamples;
model TestSteamGenerator_1SG_Purge
  extends TestSteamGenerator_1SG(
    singularPressureLoss1K(start=50.28986358642578),
    sinkP1(C(Q(start=514.4500122070312))),
    steamGenerator(
      DomeGV(
        Cm(Q(start=1845.9014892578125), h(start=1690211.75)),
        Cs(Q(start=0.0)),
        P(start=7098894.5),
        Pfond(start=7106131.5),
        Tp(start=559.9216918945312),
        Wlv(start=-269.8937683105469),
        hl(start=1272508.375),
        hv(start=2771272.75)),
      MixAlimDomeGV(
        Cs(h(start=1189539.75)),
        P(start=7105718.0),
        h(start=1189539.75)),
      RiserGV(
        Tp1(start={563.983154296875,563.29150390625,562.676025390625,
              562.1549072265625,561.7216186523438}),
        Tp2(start={570.7962036132812,569.0865478515625,567.487548828125,
              566.1039428710938,564.94091796875}),
        P(start={7141604.5,7126388.0,7117948.0,7113000.5,7109066.5,
              7105564.5,7102277.5}),
        Q(start={1845.9014892578125,1845.9014892578125,
              1845.9014892578125,1845.9014892578125,
              1845.9014892578125,1845.9014892578125}),
        h(start={1189539.75,1335110.375,1452824.125,1548607.25,
              1626646.5,1690211.75,1690211.75}),
        hb(start={1189539.75,1335110.375,1452824.125,1548607.25,
              1626646.5,1690211.75})),
      DownComerGV(h(start=1189539.75)),
      DPSeparateurCyclone(h(start=1690211.75)),
      CapteurPAlim(C2(h_vol(start=1189539.75))),
      UtubeHotLeg(
        P(start={15500000.0,15470475.0,15441021.0,15411611.0,15382225.0,
              15352856.0,15323495.0}),
        h(start={1478000.0,1438409.0,1406318.5,1380158.125,1358817.625,
              1341423.5,1341423.5}),
        Tp(start={583.4002075195312,578.8013537968291,575.2721921431346,
              572.8978271484375,569.966238010435})),
      UtubeColdLeg(
        P(start={15323495.0,15322583.0,15321885.0,15321358.0,15320966.0,
              15320682.0,15320682.0}),
        h(start={1341423.5,1327272.625,1315905.625,1306704.75,1299234.75,
              1293161.75,1293161.75}),
        Tp(start={568.4881591796875,566.5096447049349,565.2562105299215,
              564.2390488335911,563.4150073006446})),
      heatExchangerWall(Tp(start={576.9068603515625,574.03955078125,
              571.5252685546875,569.3977661132812,567.6256103515625})),
      heatExchangerWall1(Tp(start={566.1672973632812,565.0459594726562,
              564.0961303710938,563.3079223632812,562.658935546875})),
      volumeA(P(start=7144266.0), h(start=1189539.75)),
      volumeA1(P(start=7102277.5), h(start=1690211.75)),
      fluidOutletI_purge(h_vol(start=1189539.75))));

  parameter ThermoSysPro.Units.SI.MassFlowRate Q_Purges=5.55  "Purge massflowrate per SG" annotation (Dialog(group="Secondary"));

  WaterSteam.BoundaryConditions.SinkQ sinkQ1(
    Q0=Q_Purges,
    h0=1.278e6,
    C(h(start=1278000.0))) annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  WaterSteam.Sensors.SensorT SensorT_Tpurge(
    T(start=544.114013671875),
    h(start=1189539.75),
    C1(h_vol(start=1189539.75)),
    C2(h_vol(start=1278000.0)),
    pro(
      T(start=544.114013671875),
      d(start=768.1298828125),
      cp(start=5100.14599609375),
      s(start=2980.276123046875),
      u(start=1180158.125),
      x(start=0.0))) annotation (Placement(transformation(
        origin={58,8},
        extent={{-10,-10},{10,10}},
        rotation=0)));
equation
  connect(SensorT_Tpurge.C2, sinkQ1.C) annotation (Line(points={{68.2,0},{80,0}}, color={0,0,255}));
  connect(steamGenerator.fluidOutletI_purge, SensorT_Tpurge.C1) annotation (Line(points={{7.8,-20.8},{7.8,-20},{26,-20},{26,0},{48,0}}, color={255,0,0}));
end TestSteamGenerator_1SG_Purge;
