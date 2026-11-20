within ThermoSysPro.Fluid.Examples.CombinedCyclePowerPlant;

model CombinedCycle_TripTAC "CCPP model to simulate a load variation from 100% to 50%"
  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam "Water/steam medium";
  package Medium_Liquid = ThermoSysPro.Properties.Media.WaterSteam(Region=1) "Water/steam forced in IF97 region 1 (liquid), as mode = 1 in the WaterSteam example";
  replaceable package Medium_FlueGases = ThermoSysPro.Properties.Media.FlueGases "Flue gases medium";
  parameter Real CstHP(fixed = false, start = 7919515.5) "Stodola's ellipse coefficient HP";
  parameter Real CstMP(fixed = false, start = 251048.328125) "Stodola's ellipse coefficient MP";
  parameter Real CstBP(fixed = false, start = 10720.13671875) "Stodola's ellipse coefficient BP";
  parameter ThermoSysPro.Units.xSI.Cv CvmaxValveAHP(fixed = false, start = 135) "Maximum CV: alim. valve HP Drum  ";
  parameter ThermoSysPro.Units.xSI.Cv CvmaxValveAMP(fixed = false, start = 70) "Maximum CV: alim. valve MP Drum ";
  parameter ThermoSysPro.Units.xSI.Cv CvmaxValveVBP(fixed = false, start = 32000) "Maximum CV: steam valve BP Drum ";
  parameter Real Encras_SHP1(fixed = false, start = 0.01957859) "Sur HP1: heat exchange fouling coefficient";
  parameter Real Encras_SHP2(fixed = false, start = 0.04982952) "Sur HP2: heat exchange fouling coefficient";
  parameter Real Encras_SHP3(fixed = false, start = 0.06859577) "Sur HP3: heat exchange fouling coefficient";
  parameter Real Encras_EHP1(fixed = false, start = 0.07054558) "Eco HP1: heat exchange fouling coefficient";
  parameter Real Encras_EHP2(fixed = false, start = 0.11222337) "Eco HP2: heat exchange fouling coefficient";
  parameter Real Encras_EHP3(fixed = false, start = 0.05893945) "Eco HP3: heat exchange fouling coefficient";
  parameter Real Encras_EHP4(fixed = false, start = 0.02870633) "Eco HP4: heat exchange fouling coefficient";
  parameter Real Encras_SMP1(fixed = false, start = 0.03562902) "Sur MP1: heat exchange fouling coefficient";
  parameter Real Encras_SMP2(fixed = false, start = 0.06448392) "Sur MP2: heat exchange fouling coefficient";
  parameter Real Encras_SMP3(fixed = false, start = 0.05672803) "Sur MP3: heat exchange fouling coefficient";
  parameter Real Encras_EMP(fixed = false, start = 0.08256767) "Eco MP: heat exchange fouling coefficient";
  parameter Real Encras_EvHP(fixed = false, start = 0.02220394) "Evapo HP: heat exchange fouling coefficient";
  parameter Real Encras_EvMP(fixed = false, start = 0.05100306) "Evapo MP: heat exchange fouling coefficient";
  parameter Real Encras_EvBP(fixed = false, start = 0.05495019) "Evapo BP: heat exchange fouling coefficient";
  parameter Real Encras_SBP(fixed = false, start = 0.04966641) "Sur BP: heat exchange fouling coefficient";
  parameter Real Encras_EBP(fixed = false, start = 0.0586358) "Eco BP: heat exchange fouling coefficient";
  parameter Real KgainChargeHP(fixed = false, start = 1395.875) "HP: Friction pressure loss coefficient";
  parameter Real KgainChargeMP(fixed = false, start = 2111.61694336) "MP: Friction pressure loss coefficient";
  parameter Real Kin_SMP2(fixed = false, start = 201.48884583) "SMPin: Friction pressure loss coefficient";
  parameter Real K_PerteChargeZero2(fixed = false, start = 144.01260376) "TurbineMP out: Friction pressure loss coefficient";
  parameter ThermoSysPro.Units.xSI.Cv Cvmax_THP(fixed = false, start = 8000) "Maximum CV input Turbine HP ";
  parameter ThermoSysPro.Units.xSI.Cv Cvmax_TMP(fixed = false, start = 1500) "Maximum CV input Turbine MP ";
  ThermoSysPro.Fluid.Volumes.DynamicDrum BallonHP(redeclare package Medium = Medium, L = 16.27, Vertical = false, hl(start = 1460690.625, fixed = false), hv(start = 2664802.75, fixed = false), Vv(start = 28.176434, fixed = false), R = 1.05, xmv(fixed = false), zl(start = 1.05, fixed = true), Mp = 5000, Kpa = 5, Kvl = 1000, P(start = 12726434.0, fixed = false), Pfond(start = 12733342.0), Tp(start = 589.5374755859375), Cd(h_vol_1(start = 1460690.625)), Ce2(h_vol_1(start = 1460690.625)), Ce3(h_vol_1(start = 1460690.625)), Cs(h_vol_2(start = 1460690.625)), state_out_l(d(start = 670.8724976))) annotation(
    Placement(transformation(extent = {{5, 10}, {-35, 50}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve vanne_alimentationHP(redeclare package Medium = Medium, Cvmax = CvmaxValveAHP, C1(P(start = 13398096.0), h_vol_2(start = 1399475.5)), h(start = 1399475.5), Cv(start = 174.68450927734375), Pm(start = 13062265.0)) annotation(
    Placement(transformation(extent = {{45, 46}, {25, 66}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante_vanne_vapeurHP(k = 0.5) annotation(
    Placement(transformation(extent = {{-51, 70}, {-61, 78}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve vanne_vapeurHP(redeclare package Medium = Medium, Cvmax = 47829.4, C2(h_vol_1(start = 2664802.75)), h(start = 2664802.75), Cv(start = 23914.69921875), Pm(start = 12724930.0)) annotation(
    Placement(transformation(extent = {{-55, 46}, {-75, 66}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss GainChargeHP(redeclare package Medium = Medium_Liquid, z2 = 0, Q(start = 150, fixed = true), z1 = 10.83, K = KgainChargeHP, C2(P(start = 12757782.0)), h(start = 1460690.625), Pm(start = 12745562.0)) annotation(
    Placement(transformation(origin = {-5, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  ThermoSysPro.Fluid.Volumes.VolumeC VolumeEvapHP(redeclare package Medium = Medium_Liquid, V = 5, h(start = 1460690.625), P(start = 12757782.0), Ce2(h_vol_1(start = 1460690.625)), Ce3(h_vol_1(start = 1460690.625))) annotation(
    Placement(transformation(extent = {{-25, -100}, {-45, -80}}, rotation = 0)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger EvaporateurHP(steady_state = false, option_temperature = false, h0 = {1842497.375, 2019893.75, 2101978.0}, T0 = fill(605.812, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Dint = 32.8e-3, Ntubes = 1476, L = 20.7, ExchangerWall(e = 0.0026, lambda = 47, dW1(start = {-57271024.0, -26609444.0, -12312660.0}), Tp(start = {607.958740234375, 605.4310302734375, 604.044921875}), Tp1(start = {606.506103515625, 604.756103515625, 603.7326049804688})), Ns = 3, ExchangerFlueGasesMetal(Dext = 0.038, step_L = 0.092, step_T = 0.0869, St = 1, Fa = 1, K(fixed = true, start = 37.69), CSailettes = 11.86442072, p_rho = 1.05, Encras = Encras_EvHP, deltaT(start = {106, 49, 23}), h(start = {3057821.75, 2963461.75, 2919619.75, 2899333.25, 2893620}), T2(start = {755.2099609375, 674.1281000784297, 635.8939469832528, 618.0787353515625}), T1(start = {714.669037024263, 655.0110235308413, 626.9863546635906}), Tp(start = {609.308349609375, 606.0580444335938, 604.3350830078125})), TwoPhaseFlowPipe(advection = false, rugosrel = 5e-6, z2 = 10.83, option_temperature = false, continuous_flow_reversal = true, inertia = true, dW1(start = {57271024.0, 26609444.0, 12312660.0}), h(start = {1460690.625, 1842497.375, 2019893.75, 2101978.0, 1460690.625}), hb(start = {1460690.625, 1842497.375, 2019893.75, 2101978.0}), P(start = {12757782.0, 12739934.0, 12734309.0, 12730154.0, 12726434.0}), hi(start = {13411.995117, 10775.180664, 8658.856445}), Q(start = {150.0, 150.0, 150.0, 150.0}), state1(h(start = {1842497.375, 2019893.75, 2101978}))), Cfg1(h_vol_1(start = 3057821.75), h_vol_2(start = 2963461.75)), Cfg2(h_vol_1(start = 2899333.25), h_vol_2(start = 2893620))) annotation(
    Placement(transformation(origin = {-47, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger EconomiseurHP4(steady_state = false, option_temperature = false, h0 = {1339086.5, 1373480.25, 1399475.5}, T0 = fill(581.861, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Ns = 3, L = 20.726, Dint = 0.0266, Ntubes = 246, ExchangerWall(e = 0.0026, lambda = 47, dW1(start = {-3467507.0, -2610240.0, -1972859.0}), Tp(start = {577.249755859375, 582.3107299804688, 586.023681640625}), Tp1(start = {576.6054077148438, 581.82568359375, 585.6571044921875})), Cws1(P(start = 13324661.0), h_vol_2(start = 1293397.125)), Cws2(h_vol_1(start = 1399475.5)), ExchangerFlueGasesMetal(Dext = 0.0318, step_L = 0.111, step_T = 0.0869, St = 1, Fa = 1, CSailettes = 11.39069779, K(fixed = true, start = 47.53), p_rho = 1.06, Encras = Encras_EHP4, deltaT(start = {38, 29, 22}), h(start = {2899333.25, 2893620, 2889319.5, 2886069, 2883965.75}), T2(start = {618.0787353515625, 613.037602447671, 609.2389186305828, 606.3656616210938}), T1(start = {615.5581823957998, 611.1382605391269, 607.8022941316214}), Tp(start = {577.8390502929688, 582.7543334960938, 586.3590087890625})), TwoPhaseFlowPipe(advection = false, rugosrel = 5e-6, z1 = 10.83, z2 = 0, option_temperature = false, inertia = true, dW1(start = {3467507.0, 2610240.0, 1972859.0}), h(start = {1293397.125, 1339086.5, 1373480.25, 1399475.5, 1399475.5}), hb(start = {1293397.125, 1339086.5, 1373480.25, 1399475.5}), P(start = {13324661.0, 13343628.0, 13362125.0, 13380254.0, 13398096.0}), hi(start = {6902.874512, 6981.29834, 7046.654297}), Q(start = {75.893021, 75.893021, 75.893021, 75.893021}), state1(h(start = {1339086.5, 1373480.25, 1399475.5}))), Cfg2(h_vol_1(start = 2886069), h_vol_2(start = 2883965.75))) annotation(
    Placement(transformation(origin = {53, -50}, extent = {{20, 20}, {-20, -20}}, rotation = 270)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger SurchauffeurHP1(steady_state = false, option_temperature = false, h0 = {2793422.5, 2894672.25, 2973015.75}, T0 = fill(658.506, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Ns = 3, L = 20.4, Dint = 0.0324, Ntubes = 246, ExchangerWall(e = 0.0028, lambda = 37.61, dW1(start = {-9761341.0, -7684141.0, -5945731.5}), Tp(start = {641.7667236328125, 659.2384033203125, 674.5120849609375}), Tp1(start = {639.7199096679688, 657.627197265625, 673.265380859375})), Cws1(h_vol_2(start = 2664802.75)), Cws2(P(start = 12720091.0), h_vol_1(start = 2973015.75)), ExchangerFlueGasesMetal(Dext = 0.038, step_L = 0.111, step_T = 0.0869, St = 1, Fa = 1, CSailettes = 10.25056, K(fixed = true, start = 34.71), p_rho = 1.04, Encras = Encras_SHP1, deltaT(start = {138, 108, 84}), h(start = {3096361.5, 3080278.5, 3067618, 3057821.75, 2963461.75}), T2(start = {787.8693237304688, 774.2709985521502, 763.5355376271307, 755.2099609375}), T1(start = {781.0701669240514, 768.9032680896405, 759.3727557986135}), Tp(start = {643.65673828125, 660.7262573242188, 675.663330078125})), TwoPhaseFlowPipe(advection = false, rugosrel = 5e-6, z1 = 10.83, option_temperature = false, inertia = true, dW1(start = {9761341.0, 7684141.0, 5945731.5}), h(start = {2664802.75, 2793422.5, 2894672.25, 2973015.75, 2973015.75}), hb(start = {2664802.75, 2793422.5, 2894672.25, 2973015.75}), P(start = {12723426.0, 12723380.0, 12722714.0, 12721577.0, 12720091.0}), Q(start = {75.893021, 75.893021, 75.893021, 75.893021}), state1(h(start = {2793422.5, 2894672.25, 2973015.75}))), Cfg1(h_vol_1(start = 3096361.5), h_vol_2(start = 3080278.5))) annotation(
    Placement(transformation(origin = {-87, -50}, extent = {{-20, 20}, {20, -20}}, rotation = 270)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger EconomiseurHP3(steady_state = false, option_temperature = false, h0 = {1194111.25, 1267023.125, 1293397.125}, T0 = fill(562.423, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Dint = 26.6e-3, Ntubes = 1476, Ns = 3, ExchangerWall(e = 2.6e-3, lambda = 47, dW1(start = {-15390955.0, -5533500.5, -2001599.0}), Tp(start = {557.2764282226562, 563.8421630859375, 566.1499633789062}), Tp1(start = {556.7998046875, 563.6707763671875, 566.0880126953125})), L = 20.726, ExchangerFlueGasesMetal(Dext = 31.8e-3, step_L = 74e-3, step_T = 86.9e-3, Fa = 1, CSailettes = 12.451, K(fixed = true, start = 36.0300000000857), p_rho = 1.08, Encras = Encras_EHP3, St = 5, deltaT(start = {34, 12, 4.4}), h(start = {2881802.25, 2856444, 2847326.75, 2844029, 2842288.5}), T2(start = {602.606689453125, 580.0827929934445, 571.956039969206, 569.0130004882813}), T1(start = {591.3447334381658, 576.0194164813253, 570.4845269121585}), Tp(start = {557.71240234375, 563.9989013671875, 566.2066650390625})), TwoPhaseFlowPipe(rugosrel = 5e-6, z2 = 0, advection = false, z1 = 10.767, inertia = true, dW1(start = {15390955.0, 5533500.5, 2001599.0}), h(start = {991313.25, 1194111.25, 1267023.125, 1293397.125, 1293397.125}), hb(start = {991313.25, 1194111.25, 1267023.125, 1293397.125}), P(start = {13242920.0, 13264994.0, 13285413.0, 13305163.0, 13324661.0}), Q(start = {75.893021, 75.893021, 75.893021, 75.893021}), state1(h(start = {1194111.25, 1267023.125, 1293397.125})), state2(h(start = {991313.25, 1194111.25, 1267023.125, 1293397.125}))), Cfg1(h_vol_1(start = 2881802.25), h_vol_2(start = 2856444)), Cfg2(h_vol_1(start = 2844029), h_vol_2(start = 2842288.5))) annotation(
    Placement(transformation(origin = {173, -50}, extent = {{20, -20}, {-20, 20}}, rotation = 90)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger EconomiseurHP2(steady_state = false, option_temperature = false, h0 = {926522.188, 966285.25, 991313.25}, T0 = fill(499.187, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Dint = 26.6e-3, Ns = 3, ExchangerWall(e = 2.6e-3, lambda = 47, dW1(start = {-5e6, -3e6, -2.e6}), Tp(start = {492.93975830078125, 500.0770263671875, 504.5434875488281}), Tp1(start = {492.7419738769531, 499.9526672363281, 504.4652099609375})), L = 20.767, Ntubes = 1107, ExchangerFlueGasesMetal(Dext = 31.8e-3, step_T = 86.9e-3, Fa = 1, step_L = 111e-3, CSailettes = 2.76134577, K(fixed = true, start = 65.5300000000393), p_rho = 1.11, Encras = Encras_EHP2, St = 5, deltaT(start = {36, 23, 14}), h(start = {2801776.5, 2793868.25, 2788896.25, 2785766.75, 2781592.5}), T2(start = {531.2528686523438, 524.0786479337396, 519.5624877991071, 516.7178344726563}), T1(start = {527.6657680129605, 521.8205678664233, 518.1401706426662}), Tp(start = {493.12066650390625, 500.1907653808594, 504.6151123046875})), TwoPhaseFlowPipe(rugosrel = 5e-6, z2 = 0, advection = false, z1 = 10.767, inertia = true, dW1(start = {5e6, 3e6, 2.e6}), h(start = {863278.8125, 926522.1875, 966285.25, 991313.25, 991313.25}), hb(start = {863278.8125, 926522.1875, 966285.25, 991313.25}), P(start = {13153124.0, 13176093.0, 13198622.0, 13220864.0, 13242920.0}), Q(start = {75.893021, 75.893021, 75.893021, 75.893021}), state1(h(start = {926522.1875, 966285.25, 991313.25}))), Cfg1(h_vol_1(start = 2801776.5), h_vol_2(start = 2793868.25)), Cfg2(h_vol_1(start = 2785766.75), h_vol_2(start = 2781592.5))) annotation(
    Placement(transformation(origin = {373, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger EconomiseurHP1(steady_state = false, option_temperature = false, h0 = {768078.438, 832342.438, 863278.812}, T0 = fill(470.423, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Dint = 26.6e-3, Ns = 3, ExchangerWall(e = 2.6e-3, lambda = 47, dW1(start = {-10106326.0, -4877192.0, -2347854.75}), Tp(start = {462.5415954589844, 472.0587463378906, 476.6681213378906}), Tp1(start = {462.1242980957031, 471.85736083984375, 476.5711975097656})), L = 20.726, Ntubes = 1107, Cws1(h_vol_2(start = 634913.0)), ExchangerFlueGasesMetal(Dext = 31.8e-3, step_L = 74e-3, step_T = 86.9e-3, Fa = 1, CSailettes = 8.30057632, K(fixed = true, start = 40.24), p_rho = 1.13, Encras = Encras_EHP1, St = 5, deltaT(start = {41, 20, 10}), h(start = {2778157.75, 2761506.5, 2753470.75, 2749602.5, 2730474.25}), T2(start = {509.81195068359375, 494.60709242744036, 487.25141439639447, 483.7066345214844}), T1(start = {502.2095163065458, 490.92925341191744, 485.4790272730564}), Tp(start = {462.9233093261719, 472.2429504394531, 476.7568054199219})), TwoPhaseFlowPipe(rugosrel = 5e-6, z2 = 0, z1 = 10.767, inertia = true, dW1(start = {10106326.0, 4877192.0, 2347854.75}), h(start = {634913.0, 768078.4375, 832342.4375, 863278.8125, 863278.8125}), hb(start = {634913.0, 768078.4375, 832342.4375, 863278.8125}), advection = true, dynamic_mass_balance = true, P(start = {13059016.0, 13083393.0, 13106981.0, 13130156.0, 13153124.0}), hi(start = {1705.988037, 1760.190674, 1784.338379}), Q(start = {75.893021, 75.893021, 75.893021, 75.893021}), state1(h(start = {768078.4375, 832342.4375, 863278.8125}))), Cfg1(h_vol_1(start = 2778157.75), h_vol_2(start = 2761506.5)), Cfg2(h_vol_1(start = 2749602.5), h_vol_2(start = 2730474.25))) annotation(
    Placement(transformation(origin = {493, -50}, extent = {{20, -20}, {-20, 20}}, rotation = 90)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger SurchauffeurHP2(steady_state = false, option_temperature = false, h0 = {3088828.0, 3175801.75, 3240601.0}, T0 = fill(737.334, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Ns = 3, L = 20.4, Dint = 32e-3, Ntubes = 246, ExchangerWall(e = 3e-3, lambda = 27, dW1(start = {-8789339.0, -6600706.0, -4917819.0}), Tp(start = {718.035400390625, 738.872802734375, 755.0946655273438}), Tp1(start = {715.2599487304688, 736.7884521484375, 753.541748046875})), Cws2(P(start = 12710808.0), h_vol_1(start = 3240601.0)), ExchangerFlueGasesMetal(step_T = 86.9e-3, Fa = 1, Dext = 38e-3, step_L = 111e-3, K(fixed = true, start = 34.74), CSailettes = 10.2505424803872, p_rho = 1.02, Encras = Encras_SHP2, St = 5, deltaT(start = {124, 93, 70}), h(start = {3170799.5, 3156318.25, 3145442.75, 3137340.25, 3118458.25}), T2(start = {850.2295532226563, 838.165359685431, 829.0838172755421, 822.3056030273438}), T1(start = {844.1974477839519, 833.6245884804865, 825.6946997760892}), Tp(start = {720.58251953125, 740.78564453125, 756.5198364257812})), TwoPhaseFlowPipe(rugosrel = 5e-6, z2 = 0, advection = false, z1 = 10.83, inertia = true, dW1(start = {8789339.0, 6600706.0, 4917819.0}), h(start = {2973015.75, 3088828.0, 3175801.75, 3240601.0, 3240601.0}), hb(start = {2973015.75, 3088828.0, 3175801.75, 3240601.0}), P(start = {12720091.0, 12718416.0, 12716221.0, 12713652.0, 12710808.0}), hi(start = {1972.852539, 1881.643066, 1837.180298}), Q(start = {75.893021, 75.893021, 75.893021, 75.893021}), state1(h(start = {3088828, 3175801.75, 3240601})), state2(h(start = {2973015.75, 3088828, 3175801.75, 3240601}))), Cfg1(h_vol_1(start = 3170799.5), h_vol_2(start = 3156318.25)), Cfg2(h_vol_1(start = 3137340.25), h_vol_2(start = 3118458.25))) annotation(
    Placement(transformation(origin = {-207, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger SurchauffeurHP3(steady_state = false, option_temperature = false, h0 = {3323713.5, 3386144.0, 3432876.0}, T0 = fill(805.309, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Ns = 3, L = 20.4, Ntubes = 246, ExchangerWall(lambda = 27, e = 5e-3, dW1(start = {-6307650.5, -4738049.5, -3546629.0}), Tp(start = {789.2659301757812, 806.6884765625, 819.9727783203125}), Tp1(start = {785.6139526367188, 803.9453125, 817.91943359375})), Dint = 28e-3, Cws2(h_vol_1(start = 3432876.0)), ExchangerFlueGasesMetal(step_T = 86.9e-3, Fa = 1, Dext = 38e-3, step_L = 111e-3, K(fixed = true, start = 49.33), CSailettes = 6.59672842597229, p_rho = 1, Encras = Encras_SHP3, St = 5, deltaT(start = {97, 73, 55}), h(start = {3223385, 3212992.25, 3205186, 3199342.5, 3186106.25}), T2(start = {893.75, 885.1796729176981, 878.7316754228791, 873.8992309570313}), T1(start = {889.464836458849, 881.9556741702886, 876.315464574507}), Tp(start = {792.4016723632812, 809.0439453125, 821.7359619140625})), TwoPhaseFlowPipe(rugosrel = 5e-6, z2 = 0, advection = false, z1 = 10.726, inertia = true, dW1(start = {6307650.5, 4738049.5, 3546629.0}), h(start = {3240601.0, 3323713.5, 3386144.0, 3432876.0, 3432876.0}), hb(start = {3240601.0, 3323713.5, 3386144.0, 3432876.0}), P(start = {12710808.0, 12704117.0, 12696822.0, 12689079.0, 12681000.0}), Q(start = {75.893021, 75.893021, 75.893021, 75.893021}), state1(h(start = {3323713.5, 3386144, 3432876})), state2(h(start = {3240601, 3323713.5, 3386144, 3432876}))), Cfg1(h_vol_2(start = 3212992.25)), Cfg2(h_vol_1(start = 3199342.5), h_vol_2(start = 3186106.25))) annotation(
    Placement(transformation(origin = {-327, -50}, extent = {{20, -20}, {-20, 20}}, rotation = 90)));
  ThermoSysPro.Fluid.Volumes.DynamicDrum BallonMP(redeclare package Medium = Medium, L = 16.27, Vertical = false, P0 = 27.29e5, hl(start = 981073.3125, fixed = false), hv(start = 2798846.0, fixed = false), Vv(start = 28.176434, fixed = false), R = 1.05, P(start = 2733970.0, fixed = false), zl(start = 1.05, fixed = true), Kpa = 5, Mp = 5000, Kvl = 1000, Pfond(start = 2742514.5), Tp(start = 497.4441833496094), Cd(h_vol_1(start = 981073.3125)), Ce2(h_vol_1(start = 981073.3125)), Ce3(h_vol_1(start = 981073.3125)), Cs(h_vol_2(start = 981073.3125)), state_out_l(d(start = 829.7919922))) annotation(
    Placement(transformation(extent = {{325, 10}, {287, 50}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante_vanne_vapeurMP(k = 0.5) annotation(
    Placement(transformation(extent = {{271, 70}, {259, 80}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve vanne_alimentationMP(redeclare package Medium = Medium, Cvmax = CvmaxValveAMP, C1(P(start = 3269445.75), h_vol_2(start = 949320.25)), h(start = 949320.25), Cv(start = 26.902315139770508), Pm(start = 3001708.0)) annotation(
    Placement(transformation(extent = {{365, 46}, {345, 66}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve vanne_vapeurMP(redeclare package Medium = Medium, Cvmax = 47829.4, C2(h_vol_1(start = 2798846.0)), h(fixed = false, start = 2798000), Cv(start = 23914.69921875), Pm(fixed = false, start = 2732653.9482791456)) annotation(
    Placement(transformation(extent = {{265, 46}, {245, 66}}, rotation = 0)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger EvaporateurMP(steady_state = false, option_temperature = false, h0 = {1046648.0, 1097357.125, 1136563.875}, T0 = fill(504.329, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Dint = 32.8e-3, L = 20.767, Ntubes = 738, ExchangerWall(e = 2.6e-3, lambda = 47, dW1(start = {-9836201.0, -7606364.5, -5881023.0}), Tp(start = {505.00445556640625, 504.2812805175781, 503.7012634277344}), Tp1(start = {504.5071105957031, 503.89666748046875, 503.4039001464844})), Ns = 3, TwoPhaseFlowPipe(advection = false, rugosrel = 5e-6, z1 = 0, z2 = 10.83, continuous_flow_reversal = true, inertia = true, dW1(start = {9836201.0, 7606364.5, 5881023.0}), P(start = {2773389.0, 2751251.75, 2743562.25, 2738327.25, 2733970.0}), h(start = {981073.3125, 1046648.0, 1097357.125, 1136563.875, 981073.3125}), hb(start = {981073.3125, 1046648.0, 1097357.125, 1136563.875}), Q(start = {150.0, 150.0, 150.0, 150.0}), state1(h(start = {1046648, 1097357.125, 1136563.875}))), Cws1(P(start = 2773389.0)), ExchangerFlueGasesMetal(K(fixed = true, start = 30.22), Dext = 38e-3, step_L = 111e-3, step_T = 86.9e-3, Fa = 1, CSailettes = 10.0676093, p_rho = 1.1, Encras = Encras_EvMP, St = 5, deltaT(start = {53, 41, 32}), h(start = {2840204.5, 2823998.25, 2811466, 2801776.5, 2793868.25}), T2(start = {565.5570068359375, 551.1237970278224, 539.9287004763471, 531.2528686523438}), T1(start = {558.3404164937012, 545.5262487520847, 535.5907942842642}), Tp(start = {505.466552734375, 504.63861083984375, 503.9775390625})), Cfg1(h_vol_2(start = 2823998.25))) annotation(
    Placement(transformation(origin = {273, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss GainChargeMP(redeclare package Medium = Medium_Liquid, z2 = 0, z1 = 10.83, Q(start = 150, fixed = true), K = KgainChargeMP, Pm(start = 2757951.75), h(start = 981073.3125)) annotation(
    Placement(transformation(origin = {315, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  ThermoSysPro.Fluid.Volumes.VolumeC VolumeEvapMP(redeclare package Medium = Medium_Liquid, V = 5, h(start = 981073.3125), P(start = 2773389.0), Ce2(h_vol_1(start = 981073.3125)), Ce3(h_vol_1(start = 981073.3125))) annotation(
    Placement(transformation(extent = {{295, -100}, {275, -80}}, rotation = 0)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger EconomiseurMP(steady_state = false, option_temperature = false, h0 = {783226.25, 891345.188, 949320.25}, T0 = fill(485.834, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, ExchangerWall(e = 2.6e-3, lambda = 47, dW1(start = {-2533582.5, -1356953.375, -727620.0625}), Tp(start = {470.99713134765625, 488.55792236328125, 497.9468994140625}), Tp1(start = {470.5263671875, 488.3057556152344, 497.81170654296875})), L = 20.726, Ns = 3, Dint = 26.6e-3, Ntubes = 246, Cws1(h_vol_2(start = 581356.1875)), Cws2(h_vol_1(start = 949320.25)), ExchangerFlueGasesMetal(step_L = 111e-3, step_T = 86.9e-3, Fa = 1, Dext = 31.8e-3, K(fixed = true, start = 47.78), CSailettes = 7.16188651, p_rho = 1.12, Encras = Encras_EMP, St = 5, deltaT(start = {45, 24, 13}), h(start = {2785766.75, 2781592.5, 2779356.75, 2778157.75, 2761506.5}), T2(start = {516.7178344726563, 512.927875284067, 510.89894284399503, 509.81195068359375}), T1(start = {514.8228643851462, 511.91340906403104, 510.35544151482316}), Tp(start = {471.427734375, 488.7885437011719, 498.0705871582031})), TwoPhaseFlowPipe(advection = false, rugosrel = 5e-6, z1 = 10.767, z2 = 0, inertia = true, dW1(start = {2533582.5, 1356953.375, 727620.0625}), h(start = {581356.1875, 783226.25, 891345.1875, 949320.25, 949320.25}), hb(start = {581356.1875, 783226.25, 891345.1875, 949320.25}), P(start = {3176926.5, 3201441.25, 3224746.25, 3247309.5, 3269445.75}), Q(start = {12.550562, 12.550562, 12.550562, 12.550562}), state1(h(start = {783226.25, 891345.1875, 949320.25})))) annotation(
    Placement(transformation(origin = {433, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger SurchauffeurMP1(steady_state = false, option_temperature = false, h0 = {2900559.5, 2964876.0, 3005185.25}, T0 = fill(572.064, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, ExchangerWall(e = 2.6e-3, lambda = 47, dW1(start = {-1276559.875, -807207.9375, -505905.21875}), Tp(start = {558.0389404296875, 573.9583740234375, 584.1954956054688}), Tp1(start = {557.65087890625, 573.7130126953125, 584.041748046875})), L = 20.726, Ns = 3, Dint = 32.8e-3, Ntubes = 123, Cws1(h_vol_2(start = 2798846.0)), ExchangerFlueGasesMetal(step_L = 111e-3, step_T = 86.9e-3, Fa = 1, Dext = 31.8e-3, K(fixed = true, start = 22.09), CSailettes = 14.46509765, p_rho = 1.07, Encras = Encras_SMP1, St = 5, deltaT(start = {45, 30, 19}), h(start = {2886069, 2883965.75, 2882635.75, 2881802.25, 2856444}), T2(start = {606.3656616210938, 604.5120304885253, 603.3404748736327, 602.606689453125}), T1(start = {605.4388500605926, 603.926252681079, 602.9735743782599}), Tp(start = {558.3994750976562, 574.1863403320312, 584.33837890625})), TwoPhaseFlowPipe(advection = false, rugosrel = 5e-6, z2 = 0, z1 = 10.77, inertia = true, dW1(start = {1276559.875, 807207.9375, 505905.21875}), h(start = {2798846.0, 2900559.5, 2964876.0, 3005185.25, 3040176.25}), hb(start = {2798846.0, 2900559.5, 2964876.0, 3005185.25}), P(start = {2731424.75, 2730471.75, 2729329.5, 2728056.0, 2726700.0}), hi(start = {615.04425, 591.511108, 583.069275}), Q(start = {12.550562, 12.550562, 12.550562, 12.550562}), state1(h(start = {2900559.5, 2964876, 3005185.25})))) annotation(
    Placement(transformation(origin = {113, -50}, extent = {{20, -20}, {-20, 20}}, rotation = 90)));
  ThermoSysPro.Fluid.Volumes.VolumeB MelangeurHPMP(redeclare package Medium = Medium, Ce1(h(start = 3045962.75), h_vol_1(start = 3040176.25)), h(start = 3040176.25), P(start = 2726700.0), Cs1(h_vol_2(start = 3040176.25))) annotation(
    Placement(transformation(origin = {115, -110}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger SurchauffeurMP2(steady_state = false, option_temperature = false, h0 = {3169752.75, 3259477.5, 3321390.75}, T0 = fill(711.567, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Ns = 3, L = 20.4, Dint = 39.3e-3, Ntubes = 369, ExchangerWall(e = 2.6e-3, lambda = 36.86, dW1(start = {-11460208.0, -7935598.5, -5475816.5}), Tp(start = {688.9197387695312, 714.0809326171875, 731.7014770507812}), Tp1(start = {687.6563720703125, 713.2061157226562, 731.0978393554688})), Cws1(P(start = 2575504.75), h_vol_2(start = 3040176.25)), Cws2(P(start = 2558210.5), h_vol_1(start = 3321390.75)), ExchangerFlueGasesMetal(step_T = 86.9e-3, Fa = 1, Dext = 44.5e-3, step_L = 92e-3, K(fixed = true, start = 45.22), CSailettes = 5.814209831, p_rho = 1.03, Encras = Encras_SMP2, St = 5, deltaT(start = {125, 86, 60}), h(start = {3137340.25, 3118458.25, 3105383.5, 3096361.5, 3080278.5}), T2(start = {822.3056030273438, 806.4713844816748, 795.4738313791455, 787.8693237304688}), T1(start = {814.3884833791556, 800.9726079304102, 791.671583337549}), Tp(start = {690.10693359375, 714.9030151367188, 732.2687377929688})), TwoPhaseFlowPipe(advection = false, z2 = 0, z1 = 10.83, rugosrel = 1e-5, inertia = true, dW1(start = {11460208.0, 7935598.5, 5475816.5}), h(start = {3040176.25, 3169752.75, 3259477.5, 3321390.75, 3321390.75}), hb(start = {3040176.25, 3169752.75, 3259477.5, 3321390.75}), P(start = {2575504.75, 2571833.75, 2567627.25, 2563048.25, 2558210.5}), hi(start = {820.215881, 830.493896, 840.220764}), Q(start = {88.443581, 88.443581, 88.443581, 88.443581}), state1(h(start = {3169752.75, 3259477.5, 3321390.75})))) annotation(
    Placement(transformation(origin = {-147, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger SurchauffeurMP3(steady_state = false, option_temperature = false, h0 = {3412222.25, 3474561.75, 3517264.5}, T0 = fill(800.845, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Ns = 3, L = 20.4, Ntubes = 369, Dint = 45.6e-3, ExchangerWall(e = 2.6e-3, lambda = 27, dW1(start = {-8033471.0, -5513534.5, -3776766.75}), Tp(start = {785.9468383789062, 802.5588989257812, 814.0285034179688}), Tp1(start = {784.900390625, 801.8406982421875, 813.5364990234375})), Cws2(h_vol_1(start = 3517264.5)), ExchangerFlueGasesMetal(step_T = 86.9e-3, Fa = 1, step_L = 92e-3, Dext = 50.8e-3, K(fixed = true, start = 43.23), CSailettes = 5.695842178, p_rho = 1.01, Encras = Encras_SMP3, St = 5, deltaT(start = {82, 56, 38}), h(start = {3199342.5, 3186106.25, 3177022.25, 3170799.5, 3156318.25}), T2(start = {873.8992309570313, 862.9376291442026, 855.3997728669909, 850.2295532226563}), T1(start = {868.4184414351687, 859.1687010055967, 852.814654374732}), Tp(start = {786.9383544921875, 803.2393798828125, 814.49462890625})), TwoPhaseFlowPipe(advection = false, z2 = 0, z1 = 10.83, rugosrel = 1e-5, inertia = true, dW1(start = {8033471.0, 5513534.5, 3776766.75}), h(start = {3321390.75, 3412222.25, 3474561.75, 3517264.5, 3517264.5}), hb(start = {3321390.75, 3412222.25, 3474561.75, 3517264.5}), P(start = {2558210.5, 2556030.5, 2553666.5, 2551176.75, 2548600.0}), hi(start = {655.709778, 665.350952, 672.213684}), Q(start = {88.443581, 88.443581, 88.443581, 88.443581}), state1(h(start = {3412222.25, 3474561.75, 3517264.5})), state2(h(start = {3321390.75, 3412222.25, 3474561.75, 3517264.5})))) annotation(
    Placement(transformation(origin = {-267, -50}, extent = {{20, -20}, {-20, 20}}, rotation = 90)));
  ThermoSysPro.Fluid.Volumes.DynamicDrum BallonBP(redeclare package Medium = Medium, Vertical = false, P0 = 5e5, Vv(start = 58.244598, fixed = false), L = 8, hl(start = 566377.1875, fixed = false), hv(start = 2682039.0, fixed = false), R = 2, P(start = 559147.5625, fixed = false), zl(start = 1.75, fixed = true), Kpa = 5, Mp = 5000, Kvl = 1000, Pfond(start = 575124.6875), Tp(start = 410.3314514160156), Cd(h_vol_1(start = 566377.1875)), Ce2(h_vol_1(start = 566377.1875)), Ce3(h_vol_1(start = 566377.1875)), state_out_l(d(start = 930.9786377))) annotation(
    Placement(transformation(extent = {{585, 10}, {545, 50}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante_vanne_vapeurBP(k = 0.5) annotation(
    Placement(transformation(extent = {{633, 76}, {621, 86}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve vanne_vapeurBP(redeclare package Medium = Medium, p_rho = 3, Cvmax = CvmaxValveVBP, C2(P(start = 509256.375), h_vol_1(start = 2682039.0)), h(start = 2682039.0), Cv(start = 18973.1328125), Pm(start = 534202.0)) annotation(
    Placement(transformation(extent = {{525, 46}, {505, 66}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve vanne_alimentationBP(redeclare package Medium = Medium, Cvmax = 285, C1(h_vol_2(start = 521173.59375)), h(fixed = false, start = 509000), Cv(start = 142.5), Pm(start = 1023636.3125, fixed = false)) annotation(
    Placement(transformation(extent = {{617, 44}, {597, 64}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss GainChargeBP(redeclare package Medium = Medium_Liquid, z2 = 0, z1 = 10.767, Q(start = 50, fixed = false), K = 32766, rho(start = 930.9823608398438), Pm(start = 580761.8125), h(start = 566377.1875)) annotation(
    Placement(transformation(origin = {577, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  ThermoSysPro.Fluid.Volumes.VolumeC VolumeEvapBP(redeclare package Medium = Medium_Liquid, h(start = 566377.1875), V = 5, P(start = 586398.9375), Ce2(h_vol_1(start = 566377.1875)), Ce3(h_vol_1(start = 566377.1875))) annotation(
    Placement(transformation(extent = {{559, -100}, {539, -80}}, rotation = 0)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger EvaporateurBP(steady_state = false, option_temperature = false, h0 = {799848.25, 959006.75, 1067765.75}, T0 = fill(431.922, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Dint = 32.8e-3, ExchangerWall(e = 2.6e-3, lambda = 47, dW1(start = {-11609618.0, -7914340.5, -5408166.0}), Tp(start = {432.92791748046875, 431.8335876464844, 431.004638671875}), Tp1(start = {432.4867858886719, 431.5328369140625, 430.79913330078125})), L = 20.726, Ntubes = 984, Ns = 3, ExchangerFlueGasesMetal(Dext = 38e-3, step_T = 86.9e-3, Fa = 1, step_L = 138e-3, K(fixed = true, start = 30.62), CSailettes = 11.07985, p_rho = 1.14, Encras = Encras_EvBP, St = 5, deltaT(start = {45, 31, 21}), h(start = {2749602.5, 2730474.25, 2717434.5, 2708524, 2666933.25}), T2(start = {483.7066345214844, 465.9440370193418, 453.7982409323057, 445.483154296875}), T1(start = {474.8253385845301, 459.8711389758238, 449.6406958379268}), Tp(start = {433.3377990722656, 432.11297607421875, 431.195556640625})), TwoPhaseFlowPipe(advection = false, rugosrel = 5e-6, z1 = 0, z2 = 10.767, continuous_flow_reversal = true, inertia = true, dW1(start = {11609618.0, 7914340.5, 5408166.0}), h(start = {566377.1875, 799848.25, 959006.75, 1067765.75, 566377.1875}), hb(start = {566377.1875, 799848.25, 959006.75, 1067765.75}), Q(start = {49.726158142089844, 49.726158142089844, 49.726158142089844, 49.726158142089844}), P(start = {586398.9375, 561814.5, 560589.375, 559835.75, 559147.5625}), hi(start = {5420.776855, 5164.606934, 5127.338379}), state1(h(start = {799848.25, 959006.75, 1067765.75}))), Cfg2(h_vol_1(start = 2708524), h_vol_2(start = 2666933.25))) annotation(
    Placement(transformation(origin = {533, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante_ballonBP(k = 1) annotation(
    Placement(transformation(extent = {{709, 6}, {695, 18}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve Vanne_alimentationMPHP(redeclare package Medium = Medium_Liquid, Cvmax = 308.931, C1(h_vol_2(start = 566377.1875)), h(start = 566377.1875), Cv(start = 308.9309997558594), Pm(start = 477195.5625)) annotation(
    Placement(transformation(extent = {{677, -14}, {697, 6}}, rotation = 0)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger SurchauffeurBP(steady_state = false, option_temperature = false, h0 = {2791421.0, 2868442.25, 2922385.0}, T0 = fill(501.331, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Ns = 3, L = 20.726, Dint = 39.3e-3, Ntubes = 123, ExchangerWall(e = 2.6e-3, lambda = 47, dW1(start = {-1056375.625, -743847.4375, -520961.90625}), Tp(start = {478.4757385253906, 503.7419738769531, 521.7748413085938}), Tp1(start = {478.2060546875, 503.5520935058594, 521.641845703125})), Cws1(h_vol_2(start = 2682039.0)), Cws2(h_vol_1(start = 2922385.0)), ExchangerFlueGasesMetal(step_T = 86.9e-3, Fa = 1, Dext = 44.5e-3, step_L = 222.1e-3, K(fixed = true, start = 30.46), CSailettes = 3.25763059984175, p_rho = 1.09, Encras = Encras_SBP, St = 5, deltaT(start = {92, 66, 47}), h(start = {2844029, 2842288.5, 2841063, 2840204.5, 2823998.25}), T2(start = {569.0130004882813, 567.4482541171128, 566.3390581546068, 565.5570068359375}), T1(start = {568.2306339861118, 566.8936561358598, 565.9480470570934}), Tp(start = {478.7291564941406, 503.9204406738281, 521.8997802734375})), TwoPhaseFlowPipe(advection = false, z2 = 0, rugosrel = 1e-5, z1 = 10.767, inertia = true, dW1(start = {1056375.625, 743847.4375, 520961.90625}), h(start = {2682039.0, 2791421.0, 2868442.25, 2922385.0, 2922385.0}), hb(start = {2682039.0, 2791421.0, 2868442.25, 2922385.0}), P(start = {509256.375, 507673.78125, 505917.34375, 503957.90625, 501850.0}), Q(start = {9.657684, 9.657684, 9.657684, 9.657684}), state1(h(start = {2791421, 2868442.25, 2922385})))) annotation(
    Placement(transformation(origin = {233, -50}, extent = {{20, -20}, {-20, 20}}, rotation = 90)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP PuitsFumees(redeclare package Medium = Medium_FlueGases, P0 = 1.013e5) annotation(
    Placement(transformation(origin = {689, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger EconomiseurBP(steady_state = false, option_temperature = false, h0 = {452010.875, 509069.875, 521173.594}, T0 = fill(400.077, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Ns = 3, Dint = 32.8e-3, ExchangerWall(e = 2.6e-3, lambda = 47, dW1(start = {-25243184.0, -5597562.0, -1187388.0}), Tp(start = {403.2759704589844, 398.9235534667969, 398.032958984375}), Tp1(start = {403.0019226074219, 398.86279296875, 398.02008056640625})), Ntubes = 3444, L = 20.726, Cws1(h_vol_2(start = 194693.25)), Cws2(h_vol_1(start = 521173.59375)), ExchangerFlueGasesMetal(step_T = 86.9e-3, Fa = 1, Dext = 38e-3, step_L = 92e-3, K(fixed = true, start = 31.53), CSailettes = 11.673758598919, p_rho = 1.15, Encras = Encras_EBP, St = 5, deltaT(start = {23.5, 5.3, 1.1}), h(start = {2708524, 2666933.25, 2657710.5, 2655754.25, 2655754.25}), T2(start = {445.483154296875, 407.64728846356843, 399.20963445670407, 397.4152526855469}), T1(start = {426.56521960355815, 403.42846146013625, 398.31244500376624}), Tp(start = {403.53057861328125, 398.9800109863281, 398.0449523925781})), TwoPhaseFlowPipe(advection = false, rugosrel = 5e-6, z1 = 0, z2 = 10.767, inertia = true, dW1(start = {25243184.0, 5597562.0, 1187388.0}), h(start = {194693.25, 452010.875, 509069.875, 521173.59375, 521173.59375}), hb(start = {194693.25, 452010.875, 509069.875, 521173.59375}), P(start = {1589172.0, 1563024.375, 1537851.5, 1512957.25, 1488125.0}), hi(start = {461.55191, 487.833466, 493.167328}), Q(start = {98.101273, 98.101273, 98.101273, 98.101273}), state1(h(start = {452010.875, 509069.875, 521173.5938})))) annotation(
    Placement(transformation(origin = {647, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  ThermoSysPro.Fluid.Machines.StodolaTurbine TurbineHP(redeclare package Medium = Medium, W_fric = 1, eta_stato = 1, eta_is(start = 0.8805699944496155), Qmax = 140, eta_is_nom = 0.88057, eta_is_min = 0.75, Cst(start = 8182844.56002535) = CstHP, rhos(start = 10.667095184326172), Hrs(start = 3045962.75), Pe(fixed = true, start = 12431000), Ps(fixed = false, start = 2726700)) annotation(
    Placement(transformation(extent = {{-35, -250}, {5, -210}}, rotation = 0)));
  ThermoSysPro.Fluid.Machines.StodolaTurbine TurbineMP(redeclare package Medium = Medium, W_fric = 1, eta_stato = 1, eta_is(start = 0.9624999761581421), Qmax = 150, eta_is_nom = 0.9625, eta_is_min = 0.75, Cst(start = 256335.364995961) = CstMP, rhos(start = 1.883624792098999), Hrs(start = 3029286.25), Pe(fixed = true, start = 2548500), Ps(fixed = false, start = 476800)) annotation(
    Placement(transformation(extent = {{285, -250}, {325, -210}}, rotation = 0)));
  ThermoSysPro.Fluid.Volumes.VolumeC MelangeurPostTMP1(redeclare package Medium = Medium, h(start = 3018762.25), P(start = 476800.0), Ce1(h(start = 3029286.25)), Ce3(h_vol_1(start = 3018762.25))) annotation(
    Placement(transformation(origin = {385, -230}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  ThermoSysPro.Fluid.Machines.StodolaTurbine TurbineBP(redeclare package Medium = Medium, W_fric = 1, eta_stato = 1, eta_is(start = 0.9538000226020813), Qmax = 150, eta_is_nom = 0.9538, eta_is_min = 0.75, Cst(start = 11944.9445735985) = CstBP, Cs(h(start = 2401715.75)), Hrs(start = 2401715.75), Pe(fixed = true, start = 476799.99999954), Ps(start = 10052.044921875)) annotation(
    Placement(transformation(extent = {{543, -250}, {583, -210}}, rotation = 0)));
  ThermoSysPro.Fluid.Junctions.MassFlowMultiplier DoubleDebitHP(redeclare package Medium = Medium, alpha = 2) annotation(
    Placement(transformation(origin = {-325, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  ThermoSysPro.Fluid.Junctions.MassFlowMultiplier DoubleDebitMP(redeclare package Medium = Medium, alpha = 2) annotation(
    Placement(transformation(origin = {-265, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  ThermoSysPro.Fluid.Junctions.MassFlowMultiplier MoitieDebitHP(redeclare package Medium = Medium, alpha = 0.5, Ce(h(start = 3045962.75)), P(start = 2726700.0)) annotation(
    Placement(transformation(extent = {{81, -180}, {101, -160}}, rotation = 0)));
  ThermoSysPro.Fluid.HeatExchangers.SimpleDynamicCondenser Condenseur(redeclare package Medium = Medium, redeclare package Medium_Cooling = Medium, D = 0.018, V = 1000, A = 100, lambda = 0.01, ntubes = 28700, continuous_flow_reversal = true, Vf0 = 0.15, steady_state = false, yNiveau(signal(start = 1.5)), Cse(h(start = 127927.7578125), h_vol_1(start = 70825.89844)), P(start = 10000.0, fixed = false), Pfond(start = 10000.0), Cl(h(start = 191812.296875)), rhom(start = 996.0238647460938), hv(start = 2583886.75), Vv(start = 850.0), Cee(P(start = 146447.0156), h(start = 113380), h_vol_2(start = 113380)), state_d(d(start = 989.8436279))) annotation(
    Placement(transformation(extent = {{604, -384}, {684, -304}}, rotation = 0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ SourceCaloporteur(redeclare package Medium = Medium, h0 = 113.38e3, Q0 = 29804.5) annotation(
    Placement(transformation(extent = {{539, -377}, {587, -329}}, rotation = 0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP PuitsCaloporteur(redeclare package Medium = Medium, C(h_vol_1(start = 70825.89844))) annotation(
    Placement(transformation(extent = {{703, -374}, {747, -330}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss perteChargeK1(redeclare package Medium = Medium, K = 1e-4, h(start = 2401715.75), C1(h_vol_2(start = 2401715.75), h(start = 2401715.75)), Pm(start = 10026.0224609375)) annotation(
    Placement(transformation(extent = {{607, -240}, {627, -220}}, rotation = 0)));
  ThermoSysPro.Fluid.Volumes.VolumeC VolumeCond1(redeclare package Medium = Medium_Liquid, Ce3(h(start = 194693.25)), h(start = 194693.25), P(start = 1589172.0), Ce1(h_vol_1(start = 194693.25)), Ce2(h_vol_1(start = 194693.25))) annotation(
    Placement(transformation(origin = {869, -318}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss perteChargeKCond1(redeclare package Medium = Medium_Liquid, K = 1e-4, rho(start = 990.373046875), Pm(start = 1589172.0)) annotation(
    Placement(transformation(origin = {869, -270}, extent = {{12, -12}, {-12, 12}}, rotation = 270)));
  ThermoSysPro.Fluid.Volumes.VolumeA VolumeAlimMPHP(redeclare package Medium = Medium_Liquid, h(start = 566377.1875), P(start = 395243.53125), Ce2(h_vol_1(start = 566377.1875)), Cs1(h(start = 566377.1875)), Cs2(h(start = 566377.1875))) annotation(
    Placement(transformation(extent = {{709, -20}, {729, 0}}, rotation = 0)));
  ThermoSysPro.Fluid.Machines.StaticCentrifugalPump PompeAlimMP(redeclare package Medium = Medium_Liquid, a3 = 350, b1(fixed = true) = -3.7751, a1 = -244551, Q(fixed = false), C1(h_vol_2(start = 566377.1875), P(start = 395243.5312)), C2(h_vol_1(start = 581356.1875), P(start = 3182097.75)), Qv(start = 0.013491539284586906), rho(start = 930.2542724609375), Pm(start = 1788670.625), h(start = 573866.6875)) annotation(
    Placement(transformation(extent = {{771, -20}, {791, 0}}, rotation = 0)));
  ThermoSysPro.Fluid.Machines.StaticCentrifugalPump PompeAlimHP(redeclare package Medium = Medium_Liquid, a3 = 1600, a1 = -28056.2, b1 = -12.7952660447433, Q(fixed = false), C1(h_vol_2(start = 566377.1875), P(start = 395243.5312)), C2(h_vol_1(start = 634913.0), P(start = 13249950)), Qv(start = 0.08177389204502106), rho(start = 928.083740234375), Pm(start = 6822597.0), h(start = 600645.0625)) annotation(
    Placement(transformation(extent = {{771, -60}, {791, -40}}, rotation = 0)));
  ThermoSysPro.Fluid.Junctions.MassFlowMultiplier MoitieDebitBP(redeclare package Medium = Medium, alpha = 0.5, h(start = 194693.25), P(start = 1589172.0), Cs(h(start = 194693.25))) annotation(
    Placement(transformation(extent = {{839, -328}, {853, -308}}, rotation = 0)));
  ThermoSysPro.Fluid.Junctions.MassFlowMultiplier DoubleDebitBP(redeclare package Medium = Medium, alpha = 2) annotation(
    Placement(transformation(origin = {235, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss PerteChargeZero2(redeclare package Medium = Medium, z2 = 0, z1 = 0, K = K_PerteChargeZero2, h(start = 2922385.0), C1(h_vol_2(start = 2922385.0), h(start = 2922385.0), P(fixed = true, start = 501850)), Pm(start = 489325.0), rho(start = 2.144859076)) annotation(
    Placement(transformation(origin = {311, -278}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss perteChargeK3(redeclare package Medium = Medium_Liquid, K = 1e-4, Pm(start = 395243.53125)) annotation(
    Placement(transformation(origin = {747, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss perteChargeK8(redeclare package Medium = Medium_Liquid, K = 1e-4, Pm(start = 395243.53125)) annotation(
    Placement(transformation(origin = {747, -10}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  ThermoSysPro.ElectroMechanics.Machines.Generator Alternateur annotation(
    Placement(transformation(extent = {{369, -448}, {489, -348}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss perteChargeK(redeclare package Medium = Medium_Liquid, K = 1e-4, C1(h_vol_2(start = 191812.296875)), C2(h_vol_1(start = 191812.296875), P(start = 9999.996094)), rho(start = 989.83837890625), Pm(start = 9999.998046875)) annotation(
    Placement(transformation(extent = {{669, -446}, {689, -426}}, rotation = 0)));
  ThermoSysPro.Fluid.Machines.StaticCentrifugalPump PompeAlimBP(redeclare package Medium = Medium_Liquid, Qv(start = 0.198162242770195), a3 = 400, a1(fixed = true) = -6000, Q(start = 194.502, fixed = false), C2(h_vol_1(start = 194693.25), P(start = 1606175.875)), Pm(start = 808087.9375), h(start = 193252.7656)) annotation(
    Placement(transformation(extent = {{709, -446}, {729, -426}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss perteChargeK2(redeclare package Medium = Medium_Liquid, K = 1e-4, rho(start = 990.373046875), C1(h_vol_2(start = 194693.25), h(start = 194693.25), P(start = 1589172)), Pm(start = 1589172.0)) annotation(
    Placement(transformation(extent = {{807, -446}, {827, -426}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve vanne_extraction(redeclare package Medium = Medium_Liquid, Cvmax = 2000, h(start = 194693.25), Cv(start = 2000.0), Pm(start = 1597674.0)) annotation(
    Placement(transformation(extent = {{769, -440}, {789, -420}}, rotation = 0)));
  ThermoSysPro.Fluid.Sensors.SensorQ CapteurDebitVapHP(redeclare package Medium = Medium, C1(h_vol_2(start = 2664802.75), h(start = 2664802.75))) annotation(
    Placement(transformation(origin = {-91, 8}, extent = {{-6, 6}, {6, -6}}, rotation = 270)));
  ThermoSysPro.Fluid.Sensors.SensorQ CapteurDebitEauHP(redeclare package Medium = Medium, C2(h_vol_1(start = 1399475.5), h(start = 1399475.5))) " " annotation(
    Placement(transformation(origin = {58.5, 32}, extent = {{6, -6.5}, {-6, 6.5}}, rotation = 270)));
  ThermoSysPro.Fluid.Sensors.SensorQ CapteurDebitEauMP(redeclare package Medium = Medium, C2(h_vol_1(start = 949320.25), h(start = 949320.25))) annotation(
    Placement(transformation(extent = {{391, 49}, {376, 63}}, rotation = 0)));
  ThermoSysPro.Fluid.Sensors.SensorQ CapteurDebitVapMP(redeclare package Medium = Medium, C1(h_vol_2(start = 2798846.0), h(start = 2798846.0))) annotation(
    Placement(transformation(origin = {203, 56}, extent = {{-8, 8}, {8, -8}}, rotation = 180)));
  ThermoSysPro.Fluid.Sensors.SensorQ CapteurDebitVapBP(redeclare package Medium = Medium, C2(h_vol_1(start = 2682039.0), h(start = 2682039.0))) annotation(
    Placement(transformation(origin = {481, 56}, extent = {{-8, 8}, {8, -8}}, rotation = 180)));
  ThermoSysPro.Fluid.Sensors.SensorQ CapteurDebitEauBP(redeclare package Medium = Medium, C2(h_vol_1(start = 521173.59375), h(start = 521173.59375))) annotation(
    Placement(transformation(origin = {630.5, 34}, extent = {{6, -6.5}, {-6, 6.5}}, rotation = 270)));
  ThermoSysPro.Fluid.Sensors.SensorQ CapteurDebitEauBPsortie(redeclare package Medium = Medium, C2(h_vol_1(start = 566377.1875), h(start = 566377.1875))) annotation(
    Placement(transformation(extent = {{654, -11}, {667, 1}}, rotation = 0)));
  ThermoSysPro.Fluid.Sensors.SensorQ CapteurDebitEauCondenseur(redeclare package Medium = Medium, C2(h_vol_1(start = 191812.296875), h(start = 191812.296875))) annotation(
    Placement(transformation(origin = {652.5, -412}, extent = {{-10, -6.5}, {10, 6.5}}, rotation = 270)));
  ThermoSysPro.Fluid.Sensors.SensorQ CapteurDebitVapCondenseur(redeclare package Medium = Medium, C2(h_vol_1(start = 2583886.75), h(start = 2401715.75))) annotation(
    Placement(transformation(origin = {651.5, -264}, extent = {{-10, -6.5}, {10, 6.5}}, rotation = 270)));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss lumpedStraightPipeK2(redeclare package Medium = Medium, K = Kin_SMP2, Pm(start = 2651102.5), C1(P(fixed = true, start = 2726700), h_vol_2(start = 3040176.25), h(start = 3040176.25))) annotation(
    Placement(transformation(extent = {{81, -120}, {61, -100}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve vanne_entree_TurbineHP(redeclare package Medium = Medium, C1(P(fixed = true, start = 12680999.9999969)), Cvmax = Cvmax_THP, h(fixed = false, start = 3433000), Cv(start = 10840.94140625), Pm(fixed = false, start = 12550000), deltaP(start = 250000)) annotation(
    Placement(transformation(extent = {{-157, -234}, {-137, -214}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante ConsigneNiveauEauHP(k = 1.05) annotation(
    Placement(transformation(extent = {{-191, 113}, {-157, 131}}, rotation = 0)));
  ThermoSysPro.Examples.Control.Drum_LevelControl regulation_Niveau_HP(pIsat(Ti = 500, Limiteur1(u(signal(start = 0.800000011920929)))), add(k1 = -1, k2 = +1), Ti = 500, minval = 0.007) annotation(
    Placement(transformation(extent = {{-73, 106}, {-53, 126}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante ConsigneNiveauEauMP(k = 1.05) annotation(
    Placement(transformation(extent = {{140, 113}, {174, 131}}, rotation = 0)));
  ThermoSysPro.Examples.Control.Drum_LevelControl regulation_Niveau_MP(pIsat(Ti = 500, Limiteur1(u(signal(start = 0.800000011920929)))), add(k1 = -1, k2 = +1), Ti = 500) annotation(
    Placement(transformation(extent = {{229, 106}, {249, 126}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante ConsigneNiveauEauBP(k = 1.75) annotation(
    Placement(transformation(extent = {{437, 126}, {471, 144}}, rotation = 0)));
  ThermoSysPro.Examples.Control.Drum_LevelControl regulation_Niveau_BP(add(k1 = -1, k2 = +1), pIsat(Ti = 500, Limiteur1(u(signal(start = 0.800000011920929)))), Ti = 10, minval = 0.006) annotation(
    Placement(transformation(extent = {{535, 108}, {555, 128}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante ConsigneNiveauCondenseur1(k = 1.5) annotation(
    Placement(transformation(extent = {{683, -246}, {707, -230}}, rotation = 0)));
  ThermoSysPro.Examples.Control.Condenser_LevelControl regulation_Niveau_Condenseur(pIsat(Ti = 500, Limiteur1(u(signal(start = 0.800000011920929)))), add(k1 = +1, k2 = -1), edge(uL(signal(start = true)))) annotation(
    Placement(transformation(extent = {{725, -282}, {745, -262}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Tables.Table1DTemps ConstantVanneTurbineHP(Table = [0, 0.8; 10, 0.8; 600, 0.8; 650, 0.8; 3000, 0.8; 3100, 0.8]) annotation(
    Placement(transformation(extent = {{-241, -216}, {-171, -142}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Rampe arretPomesMp(Initialvalue = 1400, Duration = 1000, Starttime = 4000, Finalvalue = 1000) annotation(
    Placement(transformation(extent = {{911, -42}, {873, -10}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Rampe arretPomesHP(Initialvalue = 1400, Starttime = 4000, Duration = 1000, Finalvalue = 700) annotation(
    Placement(transformation(extent = {{912, -96}, {874, -64}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Rampe arretPomesBP(Initialvalue = 1400, Finalvalue = 1000, Duration = 1000, Starttime = 200000) annotation(
    Placement(transformation(extent = {{912, -458}, {874, -426}}, rotation = 0)));
  ThermoSysPro.Fluid.Volumes.VolumeC VolumeECO_HP1_2(redeclare package Medium = Medium_Liquid, V = 1, h0 = 988332, h(start = 863278.8125), dynamic_mass_balance = true, P0 = 7010000, P(start = 13153124.0), Ce2(h_vol_1(start = 863278.8125)), Ce3(h_vol_1(start = 863278.8125))) annotation(
    Placement(transformation(extent = {{423, -98}, {403, -78}}, rotation = 0)));
  ThermoSysPro.Fluid.Volumes.VolumeC VolumeECO_HP2_3(redeclare package Medium = Medium_Liquid, V = 1, h0 = 983786, h(start = 991313.25), dynamic_mass_balance = true, P0 = 7000000, P(start = 13242920.0), Ce2(h_vol_1(start = 991313.25)), Ce3(h_vol_1(start = 991313.25))) annotation(
    Placement(transformation(extent = {{219, -20}, {199, 0}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve Vanne_alimentationMPHP1(redeclare package Medium = Medium_Liquid, Cvmax = 308.931, h(start = 634913.0), Cv(start = 247.14480590820312), Pm(start = 13154483.0)) annotation(
    Placement(transformation(extent = {{721, -98}, {697, -122}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve Vanne_alimentationMPHP2(redeclare package Medium = Medium_Liquid, Cvmax = 308.931, h(start = 581356.1875), Cv(start = 247.14480590820312), Pm(start = 3179512.25)) annotation(
    Placement(transformation(extent = {{771, -138}, {747, -162}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Rampe arretPomesMp1(Initialvalue = 0.8, Duration = 1000, Starttime = 3000, Finalvalue = 0.005) annotation(
    Placement(transformation(extent = {{913, -150}, {875, -118}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Rampe arretPomesHP1(Initialvalue = 0.8, Duration = 1000, Starttime = 3000, Finalvalue = 0.005) annotation(
    Placement(transformation(extent = {{913, -194}, {875, -162}}, rotation = 0)));
  ThermoSysPro.Fluid.Volumes.VolumeD VolumePreTHP(redeclare package Medium = Medium, h0 = 3e6, h(start = 3432876.0), dynamic_mass_balance = true, P0 = 12700000, P(start = 12431000.0), Cs1(h_vol_2(start = 3432876)), Cs2(h_vol_2(start = 3432876))) annotation(
    Placement(transformation(origin = {-85, -230}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  ThermoSysPro.Fluid.Volumes.VolumeC MelangeurPreTMP(redeclare package Medium = Medium, h0 = 3523910, h(start = 3517264.5), dynamic_mass_balance = true, P0 = 2400000, P(start = 2548500.0), Ce2(h_vol_1(start = 3517264.5)), Ce3(h_vol_1(start = 3517264.5))) annotation(
    Placement(transformation(origin = {-83, -314}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve vanne_entree_TurbineMP(redeclare package Medium = Medium, C1(P(fixed = true, start = 25.486e5)), Cvmax = Cvmax_TMP, h(fixed = false, start = 3518000), Cv(start = 3306662.0), Pm(fixed = false, start = 2547000), deltaP(start = 100)) annotation(
    Placement(transformation(extent = {{-157, -318}, {-137, -298}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Tables.Table1DTemps ConstantVanneTurbineMP(Table = [0, 0.8; 10, 0.8; 600, 0.8; 2000, 0.8; 3000, 0.8; 3100, 0.8]) annotation(
    Placement(transformation(extent = {{-241, -300}, {-171, -226}}, rotation = 0)));
  ThermoSysPro.Thermal.BoundaryConditions.HeatSource heatSource(T0 = {303.16}) annotation(
    Placement(transformation(extent = {{-28, 68}, {-2, 98}}, rotation = 0)));
  ThermoSysPro.Thermal.BoundaryConditions.HeatSource heatSource1(T0 = {303.16}) annotation(
    Placement(transformation(extent = {{293, 68}, {319, 98}}, rotation = 0)));
  ThermoSysPro.Thermal.BoundaryConditions.HeatSource heatSource2(T0 = {303.16}) annotation(
    Placement(transformation(extent = {{552, 64}, {578, 94}}, rotation = 0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ SourceFumees(redeclare package Medium = Medium_FlueGases, X0 = {0.7301, 0.1380, 0.0706, 0.0613, 0}, option_temperature = true, T0 = 893.75, Q0 = 606.94) annotation(
    Placement(transformation(extent = {{-473, -91}, {-371, -7}}, rotation = 0)));
  InstrumentationAndControl.Blocks.Tables.Table1DTemps Debit(Table = [0, 606.94; 10, 606.94; 600, 50; 650, 50]) annotation(
    Placement(transformation(extent = {{-527, -19}, {-457, 55}}, rotation = 0)));
  InstrumentationAndControl.Blocks.Tables.Table1DTemps Temperature(Table = [0, 893.75; 10, 893.75; 600, 423; 650, 423]) annotation(
    Placement(transformation(extent = {{-527, -157}, {-457, -83}}, rotation = 0)));
equation
  connect(SurchauffeurHP3.Cws1, SurchauffeurHP2.Cws2) annotation(
    Line(points = {{-327, -30}, {-327, -10}, {-207, -10}, {-207, -30}}, color = {255, 0, 0}));
  connect(SurchauffeurHP2.Cws1, SurchauffeurHP1.Cws2) annotation(
    Line(points = {{-207, -70}, {-207, -90}, {-87, -90}, {-87, -70}}, color = {255, 0, 0}));
  connect(constante_vanne_vapeurHP.y, vanne_vapeurHP.Ouv) annotation(
    Line(points = {{-61.5, 74}, {-65, 74}, {-65, 67}}));
  connect(vanne_vapeurHP.C1, BallonHP.Cv) annotation(
    Line(points = {{-55, 50}, {-35, 50}}, color = {255, 0, 0}));
  connect(GainChargeHP.C1, BallonHP.Cd) annotation(
    Line(points = {{5, -90}, {15, -90}, {15, 10}, {5, 10}}, color = {255, 128, 0}));
  connect(BallonHP.Cm, EvaporateurHP.Cws2) annotation(
    Line(points = {{-35, 10}, {-47, 10}, {-47, -30}}));
  connect(VolumeEvapHP.Cs, EvaporateurHP.Cws1) annotation(
    Line(points = {{-45, -90}, {-45, -70}, {-47, -70}}, color = {255, 128, 0}));
  connect(VolumeEvapHP.Ce1, GainChargeHP.C2) annotation(
    Line(points = {{-25, -90}, {-15, -90}}, color = {255, 128, 0}));
  connect(EconomiseurHP4.Cws1, EconomiseurHP3.Cws2) annotation(
    Line(points = {{53, -70}, {53, -82}, {173, -82}, {173, -70}}));
  connect(BallonMP.Cm, EvaporateurMP.Cws2) annotation(
    Line(points = {{287, 10}, {273, 10}, {273, -30}}));
  connect(EvaporateurMP.Cws1, VolumeEvapMP.Cs) annotation(
    Line(points = {{273, -70}, {273, -80}, {275, -80}, {275, -90}}, color = {255, 128, 0}));
  connect(VolumeEvapMP.Ce1, GainChargeMP.C2) annotation(
    Line(points = {{295, -90}, {305, -90}}, color = {255, 128, 0}));
  connect(constante_vanne_vapeurMP.y, vanne_vapeurMP.Ouv) annotation(
    Line(points = {{258.4, 75}, {255, 75}, {255, 67}}));
  connect(SurchauffeurHP1.Cfg2, EvaporateurHP.Cfg1) annotation(
    Line(points = {{-77, -50}, {-57, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(EvaporateurHP.Cfg2, EconomiseurHP4.Cfg1) annotation(
    Line(points = {{-37, -50}, {43, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(EconomiseurHP4.Cfg2, SurchauffeurMP1.Cfg1) annotation(
    Line(points = {{63, -50}, {103, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(SurchauffeurMP1.Cfg2, EconomiseurHP3.Cfg1) annotation(
    Line(points = {{123, -50}, {163, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(EvaporateurMP.Cfg2, EconomiseurHP2.Cfg1) annotation(
    Line(points = {{283, -50}, {363, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(EconomiseurHP2.Cfg2, EconomiseurMP.Cfg1) annotation(
    Line(points = {{383, -50}, {423, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(EconomiseurMP.Cfg2, EconomiseurHP1.Cfg1) annotation(
    Line(points = {{443, -50}, {483, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(GainChargeMP.C1, BallonMP.Cd) annotation(
    Line(points = {{325, -90}, {335, -90}, {335, 10}, {325, 10}}, color = {255, 128, 0}));
  connect(SurchauffeurMP2.Cfg2, SurchauffeurHP1.Cfg1) annotation(
    Line(points = {{-137, -50}, {-97, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(SurchauffeurMP2.Cfg1, SurchauffeurHP2.Cfg2) annotation(
    Line(points = {{-157, -50}, {-197, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(SurchauffeurMP3.Cfg2, SurchauffeurHP2.Cfg1) annotation(
    Line(points = {{-257, -50}, {-217, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(SurchauffeurHP3.Cfg2, SurchauffeurMP3.Cfg1) annotation(
    Line(points = {{-317, -50}, {-277, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(SurchauffeurMP3.Cws1, SurchauffeurMP2.Cws2) annotation(
    Line(points = {{-267, -30}, {-267, 10}, {-147, 10}, {-147, -30}}, color = {255, 0, 0}));
  connect(SurchauffeurMP1.Cws2, MelangeurHPMP.Ce2) annotation(
    Line(points = {{113, -70}, {113, -85}, {115, -85}, {115, -100}}, color = {255, 0, 0}, pattern = LinePattern.None));
  connect(vanne_vapeurBP.C1, BallonBP.Cv) annotation(
    Line(points = {{525, 50}, {545, 50}}, color = {255, 0, 0}));
  connect(EvaporateurBP.Cws1, VolumeEvapBP.Cs) annotation(
    Line(points = {{533, -70}, {533, -90}, {539, -90}}, color = {255, 128, 0}));
  connect(VolumeEvapBP.Ce1, GainChargeBP.C2) annotation(
    Line(points = {{559, -90}, {567, -90}}, color = {255, 128, 0}));
  connect(BallonBP.Cd, GainChargeBP.C1) annotation(
    Line(points = {{585, 10}, {595, 10}, {595, -90}, {587, -90}}, color = {255, 128, 0}));
  connect(EconomiseurBP.Cfg2, PuitsFumees.C) annotation(
    Line(points = {{657, -50}, {679, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(EconomiseurHP3.Cfg2, SurchauffeurBP.Cfg1) annotation(
    Line(points = {{183, -50}, {223, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(SurchauffeurBP.Cfg2, EvaporateurMP.Cfg1) annotation(
    Line(points = {{243, -50}, {263, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(EconomiseurHP1.Cfg2, EvaporateurBP.Cfg1) annotation(
    Line(points = {{503, -50}, {523, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(EvaporateurBP.Cfg2, EconomiseurBP.Cfg1) annotation(
    Line(points = {{543, -50}, {637, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(BallonBP.Cm, EvaporateurBP.Cws2) annotation(
    Line(points = {{545, 10}, {533, 10}, {533, -30}}));
  connect(vanne_vapeurMP.C1, BallonMP.Cv) annotation(
    Line(points = {{265, 50}, {287, 50}}, color = {255, 0, 0}));
  connect(Vanne_alimentationMPHP.Ouv, constante_ballonBP.y) annotation(
    Line(points = {{687, 7}, {687, 12}, {694.3, 12}}));
  connect(SurchauffeurHP3.Cws2, DoubleDebitHP.Ce) annotation(
    Line(points = {{-327, -70}, {-327, -80}, {-325, -80}, {-325, -90}}, color = {255, 0, 0}));
  connect(SurchauffeurMP3.Cws2, DoubleDebitMP.Ce) annotation(
    Line(points = {{-267, -70}, {-267, -80}, {-265, -80}, {-265, -90}}, color = {255, 0, 0}));
  connect(VolumeCond1.Cs, perteChargeKCond1.C1) annotation(
    Line(points = {{869, -308}, {869, -282}}, color = {0, 0, 255}));
  connect(Vanne_alimentationMPHP.C2, VolumeAlimMPHP.Ce1) annotation(
    Line(points = {{697, -10}, {709, -10}}, color = {0, 0, 255}));
  connect(SurchauffeurBP.Cws2, DoubleDebitBP.Ce) annotation(
    Line(points = {{233, -70}, {233, -80}, {235, -80}, {235, -90}}, color = {255, 0, 0}));
  connect(perteChargeK8.C2, PompeAlimMP.C1) annotation(
    Line(points = {{757, -10}, {764, -10}, {771, -10}}, color = {0, 0, 255}));
  connect(VolumeAlimMPHP.Cs1, perteChargeK8.C1) annotation(
    Line(points = {{729, -10}, {733, -10}, {737, -10}}, color = {0, 0, 255}));
  connect(VolumeAlimMPHP.Cs2, perteChargeK3.C1) annotation(
    Line(points = {{719, -20}, {719, -50}, {737, -50}}, color = {0, 0, 255}));
  connect(perteChargeK3.C2, PompeAlimHP.C1) annotation(
    Line(points = {{757, -50}, {771, -50}}, color = {0, 0, 255}));
  connect(MelangeurPostTMP1.Ce2, PerteChargeZero2.C2) annotation(
    Line(points = {{385, -240}, {385, -278}, {321, -278}}, color = {255, 0, 0}));
  connect(perteChargeK.C2, PompeAlimBP.C1) annotation(
    Line(points = {{689, -436}, {709, -436}}, color = {0, 0, 255}));
  connect(vanne_extraction.C2, perteChargeK2.C1) annotation(
    Line(points = {{789, -436}, {807, -436}}, color = {0, 0, 255}));
  connect(vanne_alimentationHP.C1, CapteurDebitEauHP.C2) annotation(
    Line(points = {{45, 50}, {53.3, 50}, {53.3, 38.12}}));
  connect(vanne_vapeurHP.C2, CapteurDebitVapHP.C1) annotation(
    Line(points = {{-75, 50}, {-86.2, 50}, {-86.2, 14}}, color = {255, 0, 0}));
  connect(CapteurDebitVapHP.C2, SurchauffeurHP1.Cws1) annotation(
    Line(points = {{-86.2, 1.88}, {-86.2, -3.06}, {-87, -3.06}, {-87, -30}}, color = {255, 0, 0}));
  connect(vanne_alimentationMP.C1, CapteurDebitEauMP.C2) annotation(
    Line(points = {{365, 50}, {370.425, 50}, {370.425, 50.4}, {375.85, 50.4}}));
  connect(CapteurDebitVapMP.C1, vanne_vapeurMP.C2) annotation(
    Line(points = {{211, 49.6}, {227, 49.6}, {227, 50}, {245, 50}}, color = {255, 0, 0}));
  connect(CapteurDebitVapMP.C2, SurchauffeurMP1.Cws1) annotation(
    Line(points = {{194.84, 49.6}, {113, 49.6}, {113, -30}}, color = {255, 0, 0}));
  connect(CapteurDebitVapBP.C2, SurchauffeurBP.Cws1) annotation(
    Line(points = {{472.84, 49.6}, {457, 49.6}, {457, -2}, {233, -2}, {233, -30}}, color = {255, 0, 0}));
  connect(CapteurDebitVapBP.C1, vanne_vapeurBP.C2) annotation(
    Line(points = {{489, 49.6}, {497, 49.6}, {497, 50}, {505, 50}}, color = {255, 0, 0}));
  connect(CapteurDebitEauBP.C2, vanne_alimentationBP.C1) annotation(
    Line(points = {{625.3, 40.12}, {625.3, 48}, {617, 48}}, color = {0, 0, 255}));
  connect(CapteurDebitEauBPsortie.C2, Vanne_alimentationMPHP.C1) annotation(
    Line(points = {{667.13, -9.8}, {672.065, -9.8}, {672.065, -10}, {677, -10}}, color = {0, 0, 255}));
  connect(CapteurDebitEauCondenseur.C2, perteChargeK.C1) annotation(
    Line(points = {{647.3, -422.2}, {647.3, -436}, {669, -436}}, color = {0, 0, 255}));
  connect(perteChargeK1.C2, CapteurDebitVapCondenseur.C1) annotation(
    Line(points = {{627, -230}, {646.3, -230}, {646.3, -254}}, color = {255, 0, 0}));
  connect(MelangeurHPMP.Ce1, MoitieDebitHP.Cs) annotation(
    Line(points = {{115, -120}, {115, -170}, {101, -170}}, color = {255, 0, 0}));
  connect(perteChargeK2.C2, MoitieDebitBP.Ce) annotation(
    Line(points = {{827, -436}, {829, -436}, {829, -318}, {839, -318}}, color = {0, 0, 255}));
  connect(MoitieDebitBP.Cs, VolumeCond1.Ce3) annotation(
    Line(points = {{853, -318}, {859, -318}}, color = {0, 0, 255}));
  connect(SurchauffeurMP2.Cws1, lumpedStraightPipeK2.C2) annotation(
    Line(points = {{-147, -70}, {-147, -110}, {61, -110}}, color = {255, 0, 0}));
  connect(lumpedStraightPipeK2.C1, MelangeurHPMP.Cs2) annotation(
    Line(points = {{81, -110}, {105, -110}}, color = {255, 0, 0}));
  connect(DoubleDebitHP.Cs, vanne_entree_TurbineHP.C1) annotation(
    Line(points = {{-325, -110}, {-325, -230}, {-157, -230}}, color = {255, 0, 0}));
  connect(DoubleDebitBP.Cs, PerteChargeZero2.C1) annotation(
    Line(points = {{235, -110}, {235, -278}, {301, -278}}, color = {255, 0, 0}));
  connect(PompeAlimBP.C2, vanne_extraction.C1) annotation(
    Line(points = {{729, -436}, {769, -436}}, color = {0, 0, 255}));
  connect(BallonHP.yLevel, regulation_Niveau_HP.MesureNiveauEau) annotation(
    Line(points = {{-37, 30}, {-101, 30}, {-101, 125}, {-73.5, 125}}));
  connect(regulation_Niveau_HP.SortieReelle1, vanne_alimentationHP.Ouv) annotation(
    Line(points = {{-52.5, 107}, {35, 107}, {35, 67}}));
  connect(ConsigneNiveauEauMP.y, regulation_Niveau_MP.ConsigneNiveauEau) annotation(
    Line(points = {{175.7, 122}, {201, 122}, {201, 110}, {228.5, 110}}));
  connect(BallonMP.yLevel, regulation_Niveau_MP.MesureNiveauEau) annotation(
    Line(points = {{285.1, 30}, {219, 30}, {219, 125}, {228.5, 125}}));
  connect(regulation_Niveau_MP.SortieReelle1, vanne_alimentationMP.Ouv) annotation(
    Line(points = {{249.5, 107}, {344.25, 107}, {344.25, 67}, {355, 67}}));
  connect(ConsigneNiveauEauBP.y, regulation_Niveau_BP.ConsigneNiveauEau) annotation(
    Line(points = {{472.7, 135}, {496.85, 135}, {496.85, 112}, {534.5, 112}}));
  connect(BallonBP.yLevel, regulation_Niveau_BP.MesureNiveauEau) annotation(
    Line(points = {{543, 30}, {485, 30}, {485, 127}, {534.5, 127}}));
  connect(ConsigneNiveauCondenseur1.y, regulation_Niveau_Condenseur.ConsigneNiveauEau) annotation(
    Line(points = {{708.2, -238}, {719, -238}, {719, -269}, {724.5, -269}}));
  connect(regulation_Niveau_Condenseur.SortieReelle1, vanne_extraction.Ouv) annotation(
    Line(points = {{745.5, -281}, {779, -281}, {779, -419}}));
  connect(CapteurDebitEauBP.C1, EconomiseurBP.Cws2) annotation(
    Line(points = {{625.3, 28}, {627, 28}, {627, 6}, {647, 6}, {647, -30}}));
  connect(EconomiseurBP.Cws1, perteChargeKCond1.C2) annotation(
    Line(points = {{647, -70}, {647, -186}, {869, -186}, {869, -258}}));
  connect(CapteurDebitVapCondenseur.Measure, regulation_Niveau_Condenseur.MesureDebitVapeur) annotation(
    Line(points = {{658.13, -264}, {671, -264}, {671, -280.9}, {724.6, -280.9}}));
  connect(regulation_Niveau_Condenseur.MesureDebitEau, CapteurDebitEauCondenseur.Measure) annotation(
    Line(points = {{724.45, -274.95}, {717, -274.95}, {717, -310}, {759, -310}, {759, -412}, {659.13, -412}}));
  connect(ConstantVanneTurbineHP.y, vanne_entree_TurbineHP.Ouv) annotation(
    Line(points = {{-167.5, -179}, {-147, -179}, {-147, -213}}));
  connect(regulation_Niveau_BP.SortieReelle1, vanne_vapeurBP.Ouv) annotation(
    Line(points = {{555.5, 109}, {567, 109}, {567, 90}, {515, 90}, {515, 67}}));
  connect(vanne_alimentationBP.Ouv, constante_vanne_vapeurBP.y) annotation(
    Line(points = {{607, 65}, {607, 81}, {620.4, 81}}));
  connect(EconomiseurHP1.Cws2, VolumeECO_HP1_2.Ce1) annotation(
    Line(points = {{493, -70}, {493, -88}, {423, -88}}, color = {0, 0, 255}));
  connect(VolumeECO_HP1_2.Cs, EconomiseurHP2.Cws1) annotation(
    Line(points = {{403, -88}, {373, -88}, {373, -70}}, color = {0, 0, 255}));
  connect(EconomiseurHP2.Cws2, VolumeECO_HP2_3.Ce1) annotation(
    Line(points = {{373, -30}, {373, -10}, {219, -10}}, color = {0, 0, 255}));
  connect(VolumeECO_HP2_3.Cs, EconomiseurHP3.Cws1) annotation(
    Line(points = {{199, -10}, {173, -10}, {173, -30}}, color = {0, 0, 255}));
  connect(Vanne_alimentationMPHP1.C1, PompeAlimHP.C2) annotation(
    Line(points = {{721, -102.8}, {809, -102.8}, {809, -50}, {791, -50}}));
  connect(PompeAlimMP.C2, Vanne_alimentationMPHP2.C1) annotation(
    Line(points = {{791, -10}, {837, -10}, {837, -142.8}, {771, -142.8}}, color = {0, 0, 255}));
  connect(arretPomesMp1.y, Vanne_alimentationMPHP1.Ouv) annotation(
    Line(points = {{873.1, -134}, {823, -134}, {823, -122}, {709, -122}, {709, -123.2}}));
  connect(arretPomesHP1.y, Vanne_alimentationMPHP2.Ouv) annotation(
    Line(points = {{873.1, -178}, {850.05, -178}, {850.05, -163.2}, {759, -163.2}}));
  connect(Vanne_alimentationMPHP1.C2, EconomiseurHP1.Cws1) annotation(
    Line(points = {{697, -102.8}, {603, -102.8}, {603, -106}, {515, -106}, {515, -6}, {493, -6}, {493, -30}}, color = {0, 0, 255}));
  connect(EconomiseurMP.Cws1, Vanne_alimentationMPHP2.C2) annotation(
    Line(points = {{433, -70}, {433, -142.8}, {747, -142.8}}));
  connect(ConstantVanneTurbineMP.y, vanne_entree_TurbineMP.Ouv) annotation(
    Line(points = {{-167.5, -263}, {-147, -263}, {-147, -297}}));
  connect(vanne_entree_TurbineHP.C2, VolumePreTHP.Ce) annotation(
    Line(points = {{-137, -230}, {-95, -230}}, color = {255, 0, 0}));
  connect(DoubleDebitMP.Cs, vanne_entree_TurbineMP.C1) annotation(
    Line(points = {{-265, -110}, {-265, -314}, {-157, -314}}, color = {255, 0, 0}));
  connect(vanne_entree_TurbineMP.C2, MelangeurPreTMP.Ce1) annotation(
    Line(points = {{-137, -314}, {-93, -314}}, color = {255, 0, 0}));
  connect(SourceCaloporteur.C, Condenseur.Cee) annotation(
    Line(points = {{587, -353}, {605, -353}, {605, -352.8}, {604, -352.8}}, color = {0, 0, 255}));
  connect(Condenseur.Cse, PuitsCaloporteur.C) annotation(
    Line(points = {{684, -352}, {703, -352}}, color = {0, 0, 255}));
  connect(CapteurDebitVapCondenseur.C2, Condenseur.Cv) annotation(
    Line(points = {{646.3, -274.2}, {646.3, -288.1}, {644, -288.1}, {644, -304}}, color = {0, 0, 255}));
  connect(CapteurDebitEauCondenseur.C1, Condenseur.Cl) annotation(
    Line(points = {{647.3, -402}, {644.8, -402}, {644.8, -384}}));
  connect(ConsigneNiveauEauHP.y, regulation_Niveau_HP.ConsigneNiveauEau) annotation(
    Line(points = {{-155.3, 122}, {-133, 122}, {-133, 110}, {-73.5, 110}}));
  connect(Condenseur.yNiveau, regulation_Niveau_Condenseur.MesureNiveauEau) annotation(
    Line(points = {{688, -372.8}, {747, -372.8}, {747, -326}, {699, -326}, {699, -263}, {724.5, -263}}));
  connect(BallonBP.Cs, CapteurDebitEauBPsortie.C1) annotation(
    Line(points = {{545, 22}, {531, 22}, {531, 16}, {609, 16}, {609, -9.8}, {654, -9.8}}, color = {0, 0, 255}));
  connect(BallonBP.Ce1, vanne_alimentationBP.C2) annotation(
    Line(points = {{585, 50}, {591, 50}, {591, 48}, {597, 48}}));
  connect(BallonMP.Ce1, vanne_alimentationMP.C2) annotation(
    Line(points = {{325, 50}, {345, 50}}));
  connect(BallonHP.Ce1, vanne_alimentationHP.C2) annotation(
    Line(points = {{5, 50}, {25, 50}}));
  connect(TurbineHP.Cs, MoitieDebitHP.Ce) annotation(
    Line(points = {{5.2, -230}, {41, -230}, {41, -170}, {81, -170}}, color = {255, 0, 0}));
  connect(VolumePreTHP.Cs3, TurbineHP.Ce) annotation(
    Line(points = {{-75, -230}, {-35.2, -230}}, color = {255, 0, 0}));
  connect(MelangeurPreTMP.Cs, TurbineMP.Ce) annotation(
    Line(points = {{-73, -314}, {73, -314}, {73, -230}, {284.8, -230}}, color = {255, 0, 0}));
  connect(TurbineMP.Cs, MelangeurPostTMP1.Ce1) annotation(
    Line(points = {{325.2, -230}, {375, -230}}, color = {255, 0, 0}));
  connect(MelangeurPostTMP1.Cs, TurbineBP.Ce) annotation(
    Line(points = {{395, -230}, {542.8, -230}}, color = {255, 0, 0}));
  connect(TurbineBP.Cs, perteChargeK1.C1) annotation(
    Line(points = {{583.2, -230}, {607, -230}}, color = {255, 0, 0}));
  connect(EconomiseurMP.Cws2, CapteurDebitEauMP.C1) annotation(
    Line(points = {{433, -30}, {437, -30}, {437, 50.4}, {391, 50.4}}, color = {0, 0, 255}));
  connect(TurbineMP.MechPower, Alternateur.Wmec2) annotation(
    Line(points = {{327, -248}, {335, -248}, {335, -378}, {369, -378}}));
  connect(TurbineBP.MechPower, Alternateur.Wmec1) annotation(
    Line(points = {{585, -248}, {595, -248}, {595, -290}, {355, -290}, {355, -358}, {369, -358}}));
  connect(TurbineHP.MechPower, Alternateur.Wmec3) annotation(
    Line(points = {{7, -248}, {15, -248}, {15, -398}, {369, -398}}));
  connect(heatSource.C[1], BallonHP.Cex) annotation(
    Line(points = {{-15, 68.3}, {-15, 50}}, color = {191, 95, 0}));
  connect(heatSource1.C[1], BallonMP.Cex) annotation(
    Line(points = {{306, 68.3}, {306, 50}}, color = {191, 95, 0}));
  connect(heatSource2.C[1], BallonBP.Cex) annotation(
    Line(points = {{565, 64.3}, {565, 50}}, color = {191, 95, 0}));
  connect(CapteurDebitEauHP.C1, EconomiseurHP4.Cws2) annotation(
    Line(points = {{53.3, 26}, {53, 26}, {53, -30}}, smooth = Smooth.None));
  connect(PompeAlimMP.rpm_or_mpower, arretPomesMp.y) annotation(
    Line(points = {{781, -21}, {781, -26}, {871.1, -26}}, smooth = Smooth.None));
  connect(PompeAlimHP.rpm_or_mpower, arretPomesHP.y) annotation(
    Line(points = {{781, -61}, {781, -80}, {872.1, -80}}, smooth = Smooth.None));
  connect(PompeAlimBP.rpm_or_mpower, arretPomesBP.y) annotation(
    Line(points = {{719, -447}, {721, -447}, {721, -460}, {845, -460}, {845, -442}, {872.1, -442}}, smooth = Smooth.None));
  connect(SourceFumees.C, SurchauffeurHP3.Cfg1) annotation(
    Line(points = {{-371, -49}, {-371, -50}, {-337, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(Debit.y, SourceFumees.IMassFlow) annotation(
    Line(points = {{-453.5, 18}, {-422, 18}, {-422, -28}}));
  connect(Temperature.y, SourceFumees.ISpecificEnthalpyOrTemperature) annotation(
    Line(points = {{-453.5, -120}, {-422, -120}, {-422, -70}}, color = {0, 0, 255}));
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-560, -460}, {950, 150}}, initialScale = 0.1)),
    experiment(StopTime = 10000, Tolerance = 0.001),
    experimentSetupOutput,
    Icon(graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100.0, -100.0}, {100.0, 100.0}}, radius = 25.0), Rectangle(lineColor = {128, 128, 128}, extent = {{-100.0, -100.0}, {100.0, 100.0}}, radius = 25.0), Polygon(origin = {8.0, 14.0}, lineColor = {78, 138, 73}, fillColor = {78, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-58.0, 46.0}, {42.0, -14.0}, {-58.0, -74.0}, {-58.0, 46.0}})}),
    Documentation(info = "
## Copyright © EDF 2002 - 2026
## ThermoSysPro Version 4.2

Adaptation to `Fluid` of the WaterSteam model `ThermoSysPro.Examples.CombinedCyclePowerPlant.CombinedCycle_TripTAC`.

In the WaterSteam model, 22 components of the feedwater circuit force the liquid IF97 region (`mode = 1`): the water stays liquid even when the pressure drops below saturation during the gas turbine trip. `Fluid` components have no such parameter, the IF97 region is carried by the medium. These 22 components therefore use `Medium_Liquid = ThermoSysPro.Properties.Media.WaterSteam(Region=1)`, the water/steam medium forced in region 1 (liquid).
    "));
end CombinedCycle_TripTAC;