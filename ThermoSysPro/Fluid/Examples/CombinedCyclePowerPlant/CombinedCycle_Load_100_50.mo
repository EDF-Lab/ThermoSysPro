within ThermoSysPro.Fluid.Examples.CombinedCyclePowerPlant;

model CombinedCycle_Load_100_50 "CCPP model to simulate a load variation from 100% to 50%"
  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam "Water/steam medium";
  replaceable package Medium_FlueGases = ThermoSysPro.Properties.Media.FlueGases "Flue gases medium";
  parameter Real CstHP(fixed = false, start = 7870372.0) "Stodola's ellipse coefficient HP";
  parameter Real CstMP(fixed = false, start = 250029.328125) "Stodola's ellipse coefficient MP";
  parameter Real CstBP(fixed = false, start = 10565.39453125) "Stodola's ellipse coefficient BP";
  parameter ThermoSysPro.Units.xSI.Cv CvmaxValveAHP(fixed = false, start = 135) "Maximum CV: alim. valve HP Drum  ";
  parameter ThermoSysPro.Units.xSI.Cv CvmaxValveAMP(fixed = false, start = 70) "Maximum CV: alim. valve MP Drum ";
  parameter ThermoSysPro.Units.xSI.Cv CvmaxValveVBP(fixed = false, start = 32000) "Maximum CV: steam valve BP Drum ";
  parameter Real Encras_SHP1(fixed = false, start = 0.01957226) "Sur HP1: heat exchange fouling coefficient";
  parameter Real Encras_SHP2(fixed = false, start = 0.04979854) "Sur HP2: heat exchange fouling coefficient";
  parameter Real Encras_SHP3(fixed = false, start = 0.06854334) "Sur HP3: heat exchange fouling coefficient";
  parameter Real Encras_EHP1(fixed = false, start = 0.07060027) "Eco HP1: heat exchange fouling coefficient";
  parameter Real Encras_EHP2(fixed = false, start = 0.11225893) "Eco HP2: heat exchange fouling coefficient";
  parameter Real Encras_EHP3(fixed = false, start = 0.0589451) "Eco HP3: heat exchange fouling coefficient";
  parameter Real Encras_EHP4(fixed = false, start = 0.02870644) "Eco HP4: heat exchange fouling coefficient";
  parameter Real Encras_SMP1(fixed = false, start = 0.03562396) "Sur MP1: heat exchange fouling coefficient";
  parameter Real Encras_SMP2(fixed = false, start = 0.06445078) "Sur MP2: heat exchange fouling coefficient";
  parameter Real Encras_SMP3(fixed = false, start = 0.05669266) "Sur MP3: heat exchange fouling coefficient";
  parameter Real Encras_EMP(fixed = false, start = 0.08260051) "Eco MP: heat exchange fouling coefficient";
  parameter Real Encras_EvHP(fixed = false, start = 0.02220076) "Evapo HP: heat exchange fouling coefficient";
  parameter Real Encras_EvMP(fixed = false, start = 0.05100356) "Evapo MP: heat exchange fouling coefficient";
  parameter Real Encras_EvBP(fixed = false, start = 0.05506011) "Evapo BP: heat exchange fouling coefficient";
  parameter Real Encras_SBP(fixed = false, start = 0.04970671) "Sur BP: heat exchange fouling coefficient";
  parameter Real Encras_EBP(fixed = false, start = 0.05872156) "Eco BP: heat exchange fouling coefficient";
  parameter Real KgainChargeHP(fixed = false, start = 1397.64331055) "HP: Friction pressure loss coefficient";
  parameter Real KgainChargeMP(fixed = false, start = 2109.40600586) "MP: Friction pressure loss coefficient";
  parameter Real Kin_SMP2(fixed = false, start = 200.53651428) "SMPin: Friction pressure loss coefficient";
  parameter Real K_PerteChargeZero2(fixed = false, start = 128.79850769) "TurbineMP out: Friction pressure loss coefficient";
  parameter ThermoSysPro.Units.xSI.Cv Cvmax_THP(fixed = false, start = 8000) "Maximum CV input Turbine HP ";
  parameter ThermoSysPro.Units.xSI.Cv Cvmax_TMP(fixed = false, start = 1500) "Maximum CV input Turbine MP ";
  ThermoSysPro.Fluid.Volumes.DynamicDrum BallonHP(redeclare package Medium = Medium, L = 16.27, Vertical = false, hl(start = 1460157.0, fixed = false), hv(start = 2664771.25, fixed = false), Vv(start = 28.176434, fixed = false), R = 1.05, xmv(fixed = false), P(start = 12726798.0, fixed = false), zl(start = 1.05, fixed = true), Mp = 5000, Kpa = 5, Kvl = 1000, Pfond(start = 12733709.0), Tp(start = 589.4727172851562), state_out_l(d(start = 671.1120605)), Cd(h_vol_1(start = 1460157)), Ce2(h_vol_1(start = 1460157)), Ce3(h_vol_1(start = 1460157)), Cs(h_vol_2(start = 1460157))) annotation(
    Placement(transformation(extent = {{38, 10}, {-2, 50}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve vanne_alimentationHP(redeclare package Medium = Medium, Cvmax = CvmaxValveAHP, C1(P(start = 13377830.0), h_vol_2(start = 1398733.0)), h(start = 1398733.0), Cv(start = 177.89662170410156), Pm(start = 13052314.0)) annotation(
    Placement(transformation(extent = {{78, 46}, {58, 66}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante_vanne_vapeurHP(k = 0.5) annotation(
    Placement(transformation(extent = {{-18, 70}, {-28, 78}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve vanne_vapeurHP(redeclare package Medium = Medium, Cvmax = 47829.4, C2(h_vol_1(start = 2664771.25)), h(start = 2664771.25), Cv(start = 23914.69921875), Pm(start = 12725285.0)) annotation(
    Placement(transformation(extent = {{-22, 46}, {-42, 66}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss GainChargeHP(redeclare package Medium = Medium, z2 = 0, Q(start = 150, fixed = true), z1 = 10.83, K = KgainChargeHP, C2(P(start = 12758131.0)), h(start = 1460157.0), Pm(start = 12745920.0)) annotation(
    Placement(transformation(origin = {28, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  ThermoSysPro.Fluid.Volumes.VolumeC VolumeEvapHP(redeclare package Medium = Medium, V = 5, h(start = 1460157.0), P(start = 12758131.0), Ce2(h_vol_1(start = 1460157)), Ce3(h_vol_1(start = 1460157))) annotation(
    Placement(transformation(extent = {{8, -100}, {-12, -80}}, rotation = 0)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger EvaporateurHP(steady_state = false, option_temperature = false, h0 = {1842996.125, 2021168.75, 2103751.5}, T0 = fill(605.824, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Dint = 32.8e-3, Ntubes = 1476, L = 20.7, ExchangerWall(e = 0.0026, lambda = 47, dW1(start = {-57425876.0, -26725888.0, -12387397.0}), Tp(start = {607.973388671875, 605.4445190429688, 604.0555419921875}), Tp1(start = {606.516845703125, 604.7666015625, 603.7413330078125})), Ns = 3, ExchangerFlueGasesMetal(Dext = 0.038, step_L = 0.092, step_T = 0.0869, St = 1, Fa = 1, K(fixed = true, start = 37.69), CSailettes = 11.86442072, p_rho = 1.05, Encras = Encras_EvHP, deltaT(start = {106, 49, 23}), T2(start = {755.54833984375, 674.4067359457392, 636.0812177546504, 618.193603515625}), T1(start = {714.9775457406769, 655.2439768501948, 627.1374112677474}), Tp(start = {609.32666015625, 606.0742797851562, 604.3474731445312}), h(start = {3060028.5, 2965298.75, 2921211.75, 2900777.25, 2895017})), TwoPhaseFlowPipe(advection = false, rugosrel = 5e-6, z2 = 10.83, option_temperature(start = false) = false, continuous_flow_reversal = true, inertia = true, dW1(start = {57425876.0, 26725888.0, 12387397.0}), h(start = {1460157.0, 1842996.125, 2021168.75, 2103751.5, 1460157.0}), hb(start = {1460157.0, 1842996.125, 2021168.75, 2103751.5}), P(start = {12758131.0, 12740277.0, 12734658.0, 12730511.0, 12726798.0}), T0(start = {300.0, 300.0, 300.0}), hi(start = {13419.6875, 10783.772461, 8669.30957}), Q(start = {150.0, 150.0, 150.0, 150.0})), Cfg1(Xi(start = {0.7542451793792345, 0.1115701174007655, 0.07254632562, 0.06163837761, 0}), h_vol_1(start = 3060028.5), h_vol_2(start = 2965298.75)), Cfg2(h_vol_1(start = 2900777.25), h_vol_2(start = 2895017))) annotation(
    Placement(transformation(origin = {-14, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger EconomiseurHP4(steady_state = false, option_temperature = false, h0 = {1338057.875, 1372606.625, 1398733.0}, T0 = fill(581.72, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Ns = 3, L = 20.726, Dint = 0.0266, Ntubes = 246, ExchangerWall(e = 0.0026, lambda = 47, dW1(start = {-3491887.0, -2629980.25, -1988833.5}), Tp(start = {577.0819702148438, 582.1712646484375, 585.9067993164062}), Tp1(start = {576.43310546875, 581.6826171875, 585.5372314453125})), Cws1(P(start = 13304374.0), h_vol_2(start = 1292186.75)), Cws2(h_vol_1(start = 1398733.0)), ExchangerFlueGasesMetal(Dext = 0.0318, step_L = 0.111, step_T = 0.0869, St = 1, Fa = 1, CSailettes = 11.39069779, K(fixed = true, start = 47.53), p_rho = 1.06, Encras = Encras_EHP4, deltaT(start = {38, 29, 22}), T2(start = {618.193603515625, 613.1248964422501, 609.3035158562986, 606.41162109375}), T1(start = {615.6592506115472, 611.2142061492743, 607.857569142044}), Tp(start = {577.6754150390625, 582.6182861328125, 586.2448120117188}), h(start = {2900777.25, 2895017, 2890678.75, 2887398, 2885295.5})), TwoPhaseFlowPipe(advection = false, rugosrel = 5e-6, z1 = 10.83, z2 = 0, option_temperature(start = false) = false, inertia = true, dW1(start = {3491887.0, 2629980.25, 1988833.5}), h(start = {1292186.75, 1338057.875, 1372606.625, 1398733.0, 1398733.0}), hb(start = {1292186.75, 1338057.875, 1372606.625, 1398733.0}), P(start = {13304374.0, 13323348.0, 13341852.0, 13359985.0, 13377830.0}), T0(start = {300.0, 300.0, 300.0}), hi(start = {6917.688965, 6996.496094, 7062.208496}), Q(start = {76.123756, 76.123756, 76.123756, 76.123756})), Cfg2(h_vol_1(start = 2887398), h_vol_2(start = 2885295.5))) annotation(
    Placement(transformation(origin = {86, -50}, extent = {{20, 20}, {-20, -20}}, rotation = 270)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger SurchauffeurHP1(steady_state = false, option_temperature = false, h0 = {2793338.75, 2894601.25, 2972997.5}, T0 = fill(658.513, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Ns = 3, L = 20.4, Dint = 0.0324, Ntubes = 246, ExchangerWall(e = 0.0028, lambda = 37.61, dW1(start = {-9787038.0, -7708485.5, -5967831.5}), Tp(start = {641.7616577148438, 659.242431640625, 674.5349731445312}), Tp1(start = {639.70947265625, 657.6260986328125, 673.2836303710938})), Cws1(h_vol_2(start = 2664771.25)), Cws2(P(start = 12720380.0), h_vol_1(start = 2972997.5)), ExchangerFlueGasesMetal(Dext = 0.038, step_L = 0.111, step_T = 0.0869, St = 1, Fa = 1, CSailettes = 10.25056, K(fixed = true, start = 34.71), p_rho = 1.04, Encras = Encras_SHP1, deltaT(start = {138, 108, 84}), T2(start = {788.2433471679688, 774.636330839027, 763.888258455914, 755.54833984375}), T1(start = {781.4398445109163, 769.2622946474705, 759.7183069957642}), Tp(start = {643.6566772460938, 660.7349853515625, 675.6904907226562}), h(start = {3098733.75, 3082589, 3069873, 3060028.5, 2965298.75})), TwoPhaseFlowPipe(advection = false, rugosrel = 5e-6, z1 = 10.83, option_temperature(start = false) = false, inertia = true, dW1(start = {9787038.0, 7708485.5, 5967831.5}), h(start = {2664771.25, 2793338.75, 2894601.25, 2972997.5, 2972997.5}), hb(start = {2664771.25, 2793338.75, 2894601.25, 2972997.5}), P(start = {12723773.0, 12723715.0, 12723035.0, 12721883.0, 12720380.0}), T0(start = {300.0, 300.0, 300.0}), hi(start = {2799.019043, 2370.857422, 2135.596191}), Q(start = {76.123756, 76.123756, 76.123756, 76.123756})), Cfg1(h_vol_1(start = 3098733.75), h_vol_2(start = 3082589))) annotation(
    Placement(transformation(origin = {-54, -50}, extent = {{-20, 20}, {20, -20}}, rotation = 270)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger EconomiseurHP3(steady_state = false, option_temperature = false, h0 = {1192151.75, 1265586.75, 1292186.75}, T0 = fill(562.167, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Dint = 26.6e-3, Ntubes = 1476, Ns = 3, ExchangerWall(e = 2.6e-3, lambda = 47, dW1(start = {-15527223.0, -5590150.0, -2024889.125}), Tp(start = {556.9667358398438, 563.5999145507812, 565.9346923828125}), Tp1(start = {556.4859008789062, 563.4267578125, 565.8719482421875})), L = 20.726, ExchangerFlueGasesMetal(Dext = 31.8e-3, step_L = 74e-3, step_T = 86.9e-3, Fa = 1, CSailettes = 12.451, K(fixed = true, start = 36.0300000000857), p_rho = 1.08, Encras = Encras_EHP3, St = 5, deltaT(start = {34, 12, 4.4}), T2(start = {602.6719360351563, 579.980900946576, 571.7829862725544, 568.8102416992188}), T1(start = {591.3264094805266, 575.8819436095652, 570.2965996068247}), Tp(start = {557.4065551757812, 563.7582397460938, 565.9920043945312}), h(start = {2883137, 2857523.25, 2848301.75, 2844961.5, 2843184.25})), TwoPhaseFlowPipe(rugosrel = 5e-6, z2 = 0, advection = false, z1 = 10.767, inertia = true, dW1(start = {15527223.0, 5590150.0, 2024889.125}), h(start = {988178.3125, 1192151.75, 1265586.75, 1292186.75, 1292186.75}), hb(start = {988178.3125, 1192151.75, 1265586.75, 1292186.75}), P(start = {13222570.0, 13244666.0, 13265102.0, 13284865.0, 13304374.0}), T0(start = {300.0, 300.0, 300.0}), Q(start = {76.123756, 76.123756, 76.123756, 76.123756})), Cfg1(h_vol_1(start = 2883137), h_vol_2(start = 2857523.25)), Cfg2(h_vol_1(start = 2844961.5), h_vol_2(start = 2843184.25))) annotation(
    Placement(transformation(origin = {206, -50}, extent = {{20, -20}, {-20, 20}}, rotation = 90)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger EconomiseurHP2(steady_state = false, option_temperature = false, h0 = {922134.562, 962653.5, 988178.312}, T0 = fill(498.43, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Dint = 26.6e-3, Ns = 3, ExchangerWall(e = 2.6e-3, lambda = 47, dW1(start = {-5e6, -3e6, -2.e6}), Tp(start = {492.0558166503906, 499.33734130859375, 503.8979187011719}), Tp1(start = {491.85382080078125, 499.2102355957031, 503.81787109375})), L = 20.767, Ntubes = 1107, ExchangerFlueGasesMetal(Dext = 31.8e-3, step_T = 86.9e-3, Fa = 1, step_L = 111e-3, CSailettes = 2.76134577, K(fixed = true, start = 65.5300000000393), p_rho = 1.11, Encras = Encras_EHP2, St = 5, deltaT(start = {36, 23, 14}), T2(start = {531.16064453125, 523.8360138077611, 519.2214124321695, 516.3124389648438}), T1(start = {527.4983362936189, 521.5287131199652, 517.7669224567446}), Tp(start = {492.2405700683594, 499.45361328125, 503.9711608886719}), h(start = {2802681.25, 2794595.5, 2789507.25, 2786302, 2782058.75})), TwoPhaseFlowPipe(rugosrel = 5e-6, z2 = 0, advection = false, z1 = 10.767, inertia = true, dW1(start = {5e6, 3e6, 2.e6}), h(start = {857742.5, 922134.5625, 962653.5, 988178.3125, 988178.3125}), hb(start = {857742.5, 922134.5625, 962653.5, 988178.3125}), P(start = {13132658.0, 13155663.0, 13178223.0, 13200491.0, 13222570.0}), T0(start = {300.0, 300.0, 300.0}), hi(start = {1831.615479, 1859.022339, 1875.480103}), Q(start = {76.123756, 76.123756, 76.123756, 76.123756})), Cfg1(h_vol_1(start = 2802681.25), h_vol_2(start = 2794595.5)), Cfg2(h_vol_1(start = 2786302), h_vol_2(start = 2782058.75))) annotation(
    Placement(transformation(origin = {406, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger EconomiseurHP1(steady_state = false, option_temperature = false, h0 = {760481.0, 826108.812, 857742.5}, T0 = fill(469.09, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Dint = 26.6e-3, Ns = 3, ExchangerWall(e = 2.6e-3, lambda = 47, dW1(start = {-10336913.0, -4995835.0, -2408076.5}), Tp(start = {461.0337829589844, 470.7584533691406, 475.4774169921875}), Tp1(start = {460.6069641113281, 470.5521545410156, 475.37799072265625})), L = 20.726, Ntubes = 1107, Cws1(h_vol_2(start = 624690.125)), ExchangerFlueGasesMetal(Dext = 31.8e-3, step_L = 74e-3, step_T = 86.9e-3, Fa = 1, CSailettes = 8.30057632, K(fixed = true, start = 40.24), p_rho = 1.13, Encras = Encras_EHP1, St = 5, deltaT(start = {41, 20, 10}), T2(start = {509.31475830078125, 493.76452187742854, 486.23046610566547, 482.5950622558594}), T1(start = {501.5396335543568, 489.997493991547, 484.4127676365523}), Tp(start = {461.4241943359375, 470.9471130371094, 475.568359375}), h(start = {2778575.75, 2761524, 2753282.75, 2749310.5, 2729320.5})), TwoPhaseFlowPipe(rugosrel = 5e-6, z2 = 0, z1 = 10.767, inertia = true, dW1(start = {10336913.0, 4995835.0, 2408076.5}), h(start = {624690.125, 760481.0, 826108.8125, 857742.5, 857742.5}), hb(start = {624690.125, 760481.0, 826108.8125, 857742.5}), advection = true, dynamic_mass_balance = true, P(start = {13038369.0, 13062802.0, 13086438.0, 13109653.0, 13132658.0}), T0(start = {300.0, 300.0, 300.0}), hi(start = {1703.350342, 1759.462891, 1784.450073}), Q(start = {76.123756, 76.123756, 76.123756, 76.123756})), Cfg1(h_vol_1(start = 2778575.75), h_vol_2(start = 2761524)), Cfg2(h_vol_1(start = 2749310.5), h_vol_2(start = 2729320.5))) annotation(
    Placement(transformation(origin = {526, -50}, extent = {{20, -20}, {-20, 20}}, rotation = 90)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger SurchauffeurHP2(steady_state = false, option_temperature = false, h0 = {3088810.75, 3175837.75, 3240716.25}, T0 = fill(737.382, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Ns = 3, L = 20.4, Dint = 32e-3, Ntubes = 246, ExchangerWall(e = 3e-3, lambda = 27, dW1(start = {-8816137.0, -6624821.0, -4938789.5}), Tp(start = {718.056396484375, 738.9192504882812, 755.1716918945312}), Tp1(start = {715.2724609375, 736.8273315429688, 753.6121215820312})), Cws2(P(start = 12711013.0), h_vol_1(start = 3240716.25)), ExchangerFlueGasesMetal(step_T = 86.9e-3, Fa = 1, Dext = 38e-3, step_L = 111e-3, K(fixed = true, start = 34.74), CSailettes = 10.2505424803872, p_rho = 1.02, Encras = Encras_SHP2, St = 5, deltaT(start = {124, 93, 70}), T2(start = {850.646484375, 838.5707346201303, 829.4749488031354, 822.6819458007813}), T1(start = {844.6086089059804, 834.0228417116329, 826.0784372242802}), Tp(start = {720.6112060546875, 740.839111328125, 756.6029052734375}), h(start = {3173470.25, 3158927, 3147998.75, 3139851.75, 3120912.5})), TwoPhaseFlowPipe(rugosrel = 5e-6, z2 = 0, advection = false, z1 = 10.83, inertia = true, dW1(start = {8816137.0, 6624821.0, 4938789.5}), h(start = {2972997.5, 3088810.75, 3175837.75, 3240716.25, 3240716.25}), hb(start = {2972997.5, 3088810.75, 3175837.75, 3240716.25}), P(start = {12720380.0, 12718686.0, 12716472.0, 12713880.0, 12711013.0}), T0(start = {300.0, 300.0, 300.0}), hi(start = {1977.683594, 1886.197876, 1841.59021}), Q(start = {76.123756, 76.123756, 76.123756, 76.123756})), Cfg1(h_vol_1(start = 3173470.25), h_vol_2(start = 3158927)), Cfg2(h_vol_1(start = 3139851.75), h_vol_2(start = 3120912.5))) annotation(
    Placement(transformation(origin = {-174, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger SurchauffeurHP3(steady_state = false, option_temperature = false, h0 = {3323878.25, 3386384.25, 3433201.75}, T0 = fill(805.437, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Ns = 3, L = 20.4, Ntubes = 246, ExchangerWall(lambda = 27, e = 5e-3, dW1(start = {-6330595.0, -4758206.5, -3563920.25}), Tp(start = {789.3624877929688, 806.8161010742188, 820.1324462890625}), Tp1(start = {785.697265625, 804.0612182617188, 818.0690307617188})), Dint = 28e-3, Cws2(h_vol_1(start = 3433201.75), h_vol_2(start = 3433201.75)), ExchangerFlueGasesMetal(step_T = 86.9e-3, Fa = 1, Dext = 38e-3, step_L = 111e-3, K(fixed = true, start = 49.33), CSailettes = 6.59672842597229, p_rho = 1, Encras = Encras_SHP3, St = 5, deltaT(start = {97, 73, 55}), T2(start = {894.2188110351563, 885.636025090525, 879.1746662824661, 874.3292236328125}), T1(start = {889.9274067093704, 882.4053456864956, 876.7519418617093}), Tp(start = {792.5096435546875, 809.1815185546875, 821.9041748046875}), h(start = {3226298.5, 3215855.5, 3208006.25, 3202127.25, 3188843.25})), TwoPhaseFlowPipe(rugosrel = 5e-6, z2 = 0, advection = false, z1 = 10.726, inertia = true, dW1(start = {6330595.0, 4758206.5, 3563920.25}), h(start = {3240716.25, 3323878.25, 3386384.25, 3433201.75, 3433201.75}), hb(start = {3240716.25, 3323878.25, 3386384.25, 3433201.75}), P(start = {12711013.0, 12704275.0, 12696931.0, 12689134.0, 12681000.0}), T0(start = {300.0, 300.0, 300.0}), hi(start = {2295.884033, 2276.14624, 2267.704834}), Q(start = {76.123756, 76.123756, 76.123756, 76.123756})), Cfg1(h_vol_2(start = 3215855.5)), Cfg2(h_vol_1(start = 3202127.25), h_vol_2(start = 3188843.25))) annotation(
    Placement(transformation(origin = {-294, -50}, extent = {{20, -20}, {-20, 20}}, rotation = 90)));
  ThermoSysPro.Fluid.Volumes.DynamicDrum BallonMP(redeclare package Medium = Medium, L = 16.27, Vertical = false, P0 = 27.29e5, hl(start = 980845.5, fixed = false), hv(start = 2798679.25, fixed = false), Vv(start = 28.176434, fixed = false), R = 1.05, P(start = 2733888.0, fixed = false), zl(start = 1.05, fixed = true), Kpa = 5, Mp = 5000, Kvl = 1000, Pfond(start = 2742433.0), Tp(start = 497.4056091308594), state_out_l(d(start = 829.8590088)), Cd(h_vol_1(start = 980845.5)), Ce2(h_vol_1(start = 980845.5)), Ce3(h_vol_1(start = 980845.5)), Cs(h_vol_2(start = 980845.5))) annotation(
    Placement(transformation(extent = {{358, 10}, {320, 50}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante_vanne_vapeurMP(k = 0.5) annotation(
    Placement(transformation(extent = {{304, 70}, {292, 80}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve vanne_alimentationMP(redeclare package Medium = Medium, Cvmax = CvmaxValveAMP, C1(P(start = 3235124.75), h_vol_2(start = 946338.375)), h(start = 946338.375), Cv(start = 27.634977340698242), Pm(start = 2984506.25)) annotation(
    Placement(transformation(extent = {{398, 46}, {378, 66}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve vanne_vapeurMP(redeclare package Medium = Medium, Cvmax = 47829.4, C2(h_vol_1(start = 2798679.25)), h(fixed = false, start = 2798000), Cv(start = 23914.69921875), Pm(fixed = false, start = 2732628.5)) annotation(
    Placement(transformation(extent = {{298, 46}, {278, 66}}, rotation = 0)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger EvaporateurMP(steady_state = false, option_temperature = false, h0 = {1046149.875, 1096680.0, 1135771.875}, T0 = fill(504.323, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Dint = 32.8e-3, L = 20.767, Ntubes = 738, ExchangerWall(e = 2.6e-3, lambda = 47, dW1(start = {-9795648.0, -7579518.5, -5863791.0}), Tp(start = {504.9960632324219, 504.2750244140625, 503.69677734375}), Tp1(start = {504.5007629394531, 503.89178466796875, 503.4002685546875})), Ns = 3, TwoPhaseFlowPipe(advection = false, rugosrel = 5e-6, z1 = 0, z2 = 10.83, continuous_flow_reversal = true, inertia = true, dW1(start = {9795648.0, 7579518.5, 5863791.0}), P(start = {2773379.25, 2751240.0, 2743512.5, 2738258.0, 2733888.0}), h(start = {980845.5, 1046149.875, 1096680.0, 1135771.875, 980845.5}), hb(start = {980845.5, 1046149.875, 1096680.0, 1135771.875}), T0(start = {300.0, 300.0, 300.0}), Q(start = {150.0, 150.0, 150.0, 150.0})), Cws1(P(start = 2773379.25)), ExchangerFlueGasesMetal(K(fixed = true, start = 30.22), Dext = 38e-3, step_L = 111e-3, step_T = 86.9e-3, Fa = 1, CSailettes = 10.0676093, p_rho = 1.1, Encras = Encras_EvMP, St = 5, deltaT(start = {53, 41, 32}), T2(start = {565.2481689453125, 550.9126306026692, 539.787269523939, 531.16064453125}), T1(start = {558.0803978580261, 545.349950063304, 535.4739641517078}), Tp(start = {505.45623779296875, 504.631103515625, 503.9722595214844}), h(start = {2841016.25, 2824857.5, 2812354.25, 2802681.25, 2794595.5})), Cfg1(h_vol_1(start = 2841016.25), h_vol_2(start = 2824857.5))) annotation(
    Placement(transformation(origin = {306, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss GainChargeMP(redeclare package Medium = Medium, z2 = 0, z1 = 10.83, Q(start = 150, fixed = true), K = KgainChargeMP, Pm(start = 2757906.0), h(start = 980845.5)) annotation(
    Placement(transformation(origin = {348, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  ThermoSysPro.Fluid.Volumes.VolumeC VolumeEvapMP(redeclare package Medium = Medium, V = 5, h(start = 980845.5), P(start = 2773379.25), Ce2(h_vol_1(start = 980845.5)), Ce3(h_vol_1(start = 980845.5))) annotation(
    Placement(transformation(extent = {{328, -100}, {308, -80}}, rotation = 0)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger EconomiseurMP(steady_state = false, option_temperature = false, h0 = {777225.0, 887380.812, 946338.375}, T0 = fill(485.041, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, ExchangerWall(e = 2.6e-3, lambda = 47, dW1(start = {-2572232.0, -1375385.125, -736132.5625}), Tp(start = {469.9423828125, 487.818603515625, 497.3634033203125}), Tp1(start = {469.4644470214844, 487.5630187988281, 497.22662353515625})), L = 20.726, Ns = 3, Dint = 26.6e-3, Ntubes = 246, Cws1(h_vol_2(start = 571212.5625), P(start = 3142462.75)), Cws2(h_vol_1(start = 946338.375)), ExchangerFlueGasesMetal(step_L = 111e-3, step_T = 86.9e-3, Fa = 1, Dext = 31.8e-3, K(fixed = true, start = 47.78), CSailettes = 7.16188651, p_rho = 1.12, Encras = Encras_EMP, St = 5, deltaT(start = {45, 24, 13}), T2(start = {516.3124389648438, 512.4675048876576, 510.41305969109146, 509.31475830078125}), T1(start = {514.3899686844887, 511.4402822893745, 509.8639024611882}), Tp(start = {470.3795471191406, 488.0523376464844, 497.488525390625}), h(start = {2786302, 2782058.75, 2779790, 2778575.75, 2761524})), TwoPhaseFlowPipe(advection = false, rugosrel = 5e-6, z1 = 10.767, z2 = 0, inertia = true, dW1(start = {2572232.0, 1375385.125, 736132.5625}), h(start = {571212.5625, 777225.0, 887380.8125, 946338.375, 946338.375}), hb(start = {571212.5625, 777225.0, 887380.8125, 946338.375}), P(start = {3142462.75, 3167032.0, 3190375.75, 3212966.75, 3235124.75}), T0(start = {300.0, 300.0, 300.0}), Q(start = {12.485812, 12.485812, 12.485812, 12.485812}))) annotation(
    Placement(transformation(origin = {466, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger SurchauffeurMP1(steady_state = false, option_temperature = false, h0 = {2900753.0, 2965210.75, 3005554.0}, T0 = fill(572.207, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, ExchangerWall(e = 2.6e-3, lambda = 47, dW1(start = {-1274475.75, -804807.1875, -503716.96875}), Tp(start = {558.1707153320312, 574.1082763671875, 584.3428344726562}), Tp1(start = {557.7833251953125, 573.8636474609375, 584.189697265625})), L = 20.726, Ns = 3, Dint = 32.8e-3, Ntubes = 123, Cws1(h_vol_2(start = 2798679.25)), ExchangerFlueGasesMetal(step_L = 111e-3, step_T = 86.9e-3, Fa = 1, Dext = 31.8e-3, K(fixed = true, start = 22.09), CSailettes = 14.46509765, p_rho = 1.07, Encras = Encras_SMP1, St = 5, deltaT(start = {45, 30, 19}), T2(start = {606.41162109375, 604.5654891969185, 603.4004814494892, 602.6719360351563}), T1(start = {605.488555812354, 603.9829853232038, 603.0361997319833}), Tp(start = {558.5307006835938, 574.3355712890625, 584.485107421875}), h(start = {2887398, 2885295.5, 2883968, 2883137, 2857523.25})), TwoPhaseFlowPipe(advection = false, rugosrel = 5e-6, z2 = 0, z1 = 10.77, inertia = true, dW1(start = {1274475.75, 804807.1875, 503716.96875}), h(start = {2798679.25, 2900753.0, 2965210.75, 3005554.0, 3040476.25}), hb(start = {2798679.25, 2900753.0, 2965210.75, 3005554.0}), P(start = {2731369.25, 2730428.5, 2729299.75, 2728041.0, 2726700.0}), T0(start = {300.0, 300.0, 300.0}), hi(start = {612.407593, 588.981079, 580.601746}), Q(start = {12.485812, 12.485812, 12.485812, 12.485812}))) annotation(
    Placement(transformation(origin = {146, -50}, extent = {{20, -20}, {-20, 20}}, rotation = 90)));
  ThermoSysPro.Fluid.Volumes.VolumeB MelangeurHPMP(redeclare package Medium = Medium, Ce1(h(start = 3046204.25), h_vol_1(start = 3040476.25)), h(start = 3040476.25), P(start = 2726700.0), Cs1(h_vol_2(start = 3040476.25))) annotation(
    Placement(transformation(origin = {148, -110}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger SurchauffeurMP2(steady_state = false, option_temperature = false, h0 = {3170044.75, 3259807.75, 3321777.5}, T0 = fill(711.74, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Ns = 3, L = 20.4, Dint = 39.3e-3, Ntubes = 369, ExchangerWall(e = 2.6e-3, lambda = 36.86, dW1(start = {-11481016.0, -7953862.5, -5491113.5}), Tp(start = {689.0643310546875, 714.2538452148438, 731.902587890625}), Tp1(start = {687.7987060546875, 713.3770141601562, 731.2972412109375})), Cws1(P(start = 2575616.0), h_vol_2(start = 3040476.25)), Cws2(P(start = 2558251.25), h_vol_1(start = 3321777.5)), ExchangerFlueGasesMetal(step_T = 86.9e-3, Fa = 1, Dext = 44.5e-3, step_L = 92e-3, K(fixed = true, start = 45.22), CSailettes = 5.814209831, p_rho = 1.03, Encras = Encras_SMP2, St = 5, deltaT(start = {125, 86, 60}), T2(start = {822.6819458007813, 806.8523532375756, 795.852828640494, 788.2433471679688}), T1(start = {814.7671394415003, 801.3525909390348, 792.0480934116497}), Tp(start = {690.2537231445312, 715.0778198242188, 732.471435546875}), h(start = {3139851.75, 3120912.5, 3107791.75, 3098733.75, 3082589})), TwoPhaseFlowPipe(advection = false, z2 = 0, z1 = 10.83, rugosrel = 1e-5, inertia = true, dW1(start = {11481016.0, 7953862.5, 5491113.5}), h(start = {3040476.25, 3170044.75, 3259807.75, 3321777.5, 3321777.5}), hb(start = {3040476.25, 3170044.75, 3259807.75, 3321777.5}), P(start = {2575616.0, 2571929.75, 2567706.0, 2563108.75, 2558251.25}), T0(start = {300.0, 300.0, 300.0}), hi(start = {821.471375, 831.789978, 841.549561}), Q(start = {88.609566, 88.609566, 88.609566, 88.609566}))) annotation(
    Placement(transformation(origin = {-114, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger SurchauffeurMP3(steady_state = false, option_temperature = false, h0 = {3412658.5, 3475062.5, 3517830.25}, T0 = fill(801.1, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Ns = 3, L = 20.4, Ntubes = 369, Dint = 45.6e-3, ExchangerWall(e = 2.6e-3, lambda = 27, dW1(start = {-8052911.0, -5529594.5, -3789643.25}), Tp(start = {786.1732788085938, 802.8152465820312, 814.31103515625}), Tp1(start = {785.124267578125, 802.094970703125, 813.8173828125})), Cws2(h_vol_1(start = 3517830.25), h_vol_2(start = 3517830.25)), ExchangerFlueGasesMetal(step_T = 86.9e-3, Fa = 1, step_L = 92e-3, Dext = 50.8e-3, K(fixed = true, start = 43.23), CSailettes = 5.695842178, p_rho = 1.01, Encras = Encras_SMP3, St = 5, deltaT(start = {82, 56, 38}), T2(start = {874.3292236328125, 863.3655435931397, 855.822658205448, 850.646484375}), T1(start = {868.8473805170461, 859.5941008992938, 853.2345706986391}), Tp(start = {787.1671752929688, 803.4977416992188, 814.77880859375}), h(start = {3202127.25, 3188843.25, 3179721.5, 3173470.25, 3158927})), TwoPhaseFlowPipe(advection = false, z2 = 0, z1 = 10.83, rugosrel = 1e-5, inertia = true, dW1(start = {8052911.0, 5529594.5, 3789643.25}), h(start = {3321777.5, 3412658.5, 3475062.5, 3517830.25, 3517830.25}), hb(start = {3321777.5, 3412658.5, 3475062.5, 3517830.25}), P(start = {2558251.25, 2556062.0, 2553688.0, 2551187.75, 2548600.0}), T0(start = {300.0, 300.0, 300.0}), hi(start = {656.760193, 666.429688, 673.31543}), Q(start = {88.609566, 88.609566, 88.609566, 88.609566}))) annotation(
    Placement(transformation(origin = {-234, -50}, extent = {{20, -20}, {-20, 20}}, rotation = 90)));
  ThermoSysPro.Fluid.Volumes.DynamicDrum BallonBP(redeclare package Medium = Medium, Vertical = false, P0 = 5e5, Vv(start = 58.244598, fixed = false), L = 8, hl(start = 556201.6875, fixed = false), hv(start = 2683834.25, fixed = false), R = 2, P(start = 512417.21875, fixed = false), zl(start = 1.75, fixed = true), Kpa = 5, Mp = 5000, Kvl = 1000, Pfond(start = 528429.3125), Tp(start = 407.79571533203125), state_out_l(d(start = 933.0153198)), Cd(h_vol_1(start = 556201.6875)), Ce2(h_vol_1(start = 556201.6875)), Ce3(h_vol_1(start = 556201.6875))) annotation(
    Placement(transformation(extent = {{618, 10}, {578, 50}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante_vanne_vapeurBP(k = 0.5) annotation(
    Placement(transformation(extent = {{666, 76}, {654, 86}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve vanne_vapeurBP(redeclare package Medium = Medium, p_rho = 3, Cvmax = CvmaxValveVBP, C2(P(start = 510105.625), h_vol_1(start = 2683834.25)), h(start = 2683834.25), Cv(start = 93443.7890625), Pm(start = 511261.4375)) annotation(
    Placement(transformation(extent = {{558, 46}, {538, 66}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve vanne_alimentationBP(redeclare package Medium = Medium, Cvmax = 285, C1(h_vol_2(start = 513770.84375)), h(fixed = false, start = 509000), Cv(start = 142.5), Pm(start = 982596.875, fixed = false)) annotation(
    Placement(transformation(extent = {{650, 44}, {630, 64}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss GainChargeBP(redeclare package Medium = Medium, z2 = 0, z1 = 10.767, Q(start = 50, fixed = false), K = 32766, rho(start = 933.0189819335938), Pm(start = 533961.8125), h(start = 556201.6875)) annotation(
    Placement(transformation(origin = {610, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  ThermoSysPro.Fluid.Volumes.VolumeC VolumeEvapBP(redeclare package Medium = Medium, h(start = 556201.6875), V = 5, P(start = 539494.25), Ce2(h_vol_1(start = 556201.6875)), Ce3(h_vol_1(start = 556201.6875))) annotation(
    Placement(transformation(extent = {{592, -100}, {572, -80}}, rotation = 0)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger EvaporateurBP(steady_state = false, option_temperature = false, h0 = {799038.938, 964745.875, 1078052.375}, T0 = fill(428.658, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Dint = 32.8e-3, ExchangerWall(e = 2.6e-3, lambda = 47, dW1(start = {-12117996.0, -8269060.0, -5654191.5}), Tp(start = {429.7086181640625, 428.56280517578125, 427.70245361328125}), Tp1(start = {429.2481689453125, 428.24859619140625, 427.48760986328125})), L = 20.726, Ntubes = 984, Ns = 3, ExchangerFlueGasesMetal(Dext = 38e-3, step_T = 86.9e-3, Fa = 1, step_L = 138e-3, K(fixed = true, start = 30.62), CSailettes = 11.07985, p_rho = 1.14, Encras = Encras_EvBP, St = 5, deltaT(start = {45, 31, 21}), T2(start = {482.5950622558594, 464.01748118772224, 451.30051770870455, 442.58880615234375}), T1(start = {473.3062751775807, 457.6589994482134, 446.94466391603106}), Tp(start = {430.1364440917969, 428.854736328125, 427.9020690917969}), h(start = {2749310.5, 2729320.5, 2715680, 2706352.75, 2665392.25})), TwoPhaseFlowPipe(advection = false, rugosrel = 5e-6, z1 = 0, z2 = 10.767, continuous_flow_reversal = true, inertia = true, dW1(start = {12117996.0, 8269060.0, 5654191.5}), h(start = {556201.6875, 799038.9375, 964745.875, 1078052.375, 556201.6875}), hb(start = {556201.6875, 799038.9375, 964745.875, 1078052.375}), Q(start = {49.90171432495117, 49.90171432495117, 49.90171432495117, 49.90171432495117}), P(start = {539494.25, 514856.03125, 513786.09375, 513081.78125, 512417.21875}), T0(start = {300.0, 300.0, 300.0}), hi(start = {5481.984863, 5281.962402, 5290.007812})), Cfg2(h_vol_1(start = 2706352.75), h_vol_2(start = 2665392.25))) annotation(
    Placement(transformation(origin = {566, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante_ballonBP(k = 1) annotation(
    Placement(transformation(extent = {{742, 6}, {728, 18}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve Vanne_alimentationMPHP(redeclare package Medium = Medium, Cvmax = 308.931, C1(h_vol_2(start = 556201.6875)), h(start = 556201.6875), Cv(start = 308.9309997558594), Pm(start = 430516.15625)) annotation(
    Placement(transformation(extent = {{710, -14}, {730, 6}}, rotation = 0)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger SurchauffeurBP(steady_state = false, option_temperature = false, h0 = {2789058.5, 2864136.25, 2917424.75}, T0 = fill(499.111, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Ns = 3, L = 20.726, Dint = 39.3e-3, Ntubes = 123, ExchangerWall(e = 2.6e-3, lambda = 47, dW1(start = {-1077319.25, -768670.0625, -545585.3125}), Tp(start = {476.5025939941406, 501.4080810546875, 519.423583984375}), Tp1(start = {476.2275695800781, 501.21185302734375, 519.2843017578125})), Cws1(h_vol_2(start = 2683834.25)), Cws2(h_vol_1(start = 2917424.75), h_vol_2(start = 2917424.75)), ExchangerFlueGasesMetal(step_T = 86.9e-3, Fa = 1, Dext = 44.5e-3, step_L = 222.1e-3, K(fixed = true, start = 30.46), CSailettes = 3.25763059984175, p_rho = 1.09, Encras = Encras_SBP, St = 5, deltaT(start = {92, 66, 47}), T2(start = {568.8102416992188, 567.2151210721856, 566.0683353396659, 565.2481689453125}), T1(start = {568.0126670066404, 566.6417282059258, 565.6582502265244}), Tp(start = {476.76104736328125, 501.5924987792969, 519.554443359375}), h(start = {2844961.5, 2843184.25, 2841916.25, 2841016.25, 2824857.5})), TwoPhaseFlowPipe(advection = false, z2 = 0, rugosrel = 1e-5, z1 = 10.767, inertia = true, dW1(start = {1077319.25, 768670.0625, 545585.3125}), h(start = {2683834.25, 2789058.5, 2864136.25, 2917424.75, 2917424.75}), hb(start = {2683834.25, 2789058.5, 2864136.25, 2917424.75}), P(start = {510105.625, 508332.65625, 506373.03125, 504193.3125, 501850.0}), T0(start = {300.0, 300.0, 300.0}), Q(start = {10.238324, 10.238324, 10.238324, 10.238324}))) annotation(
    Placement(transformation(origin = {266, -50}, extent = {{20, -20}, {-20, 20}}, rotation = 90)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP PuitsFumees(redeclare package Medium = Medium_FlueGases, P0 = 1.013e5, C(h_vol_1(start = 2654311.25)), X(start = {0.7536821216, 0.1121331751, 0.07254632562, 0.06163837761, 0})) annotation(
    Placement(transformation(origin = {722, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicFlueGasesMultiFluidHeatExchanger EconomiseurBP(steady_state = false, option_temperature = false, h0 = {445813.0, 501821.062, 513770.844}, T0 = fill(398.305, 3), redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, Ns = 3, Dint = 32.8e-3, ExchangerWall(e = 2.6e-3, lambda = 47, dW1(start = {-24830472.0, -5536280.5, -1181209.875}), Tp(start = {401.4523620605469, 397.1709289550781, 396.2907409667969}), Tp1(start = {401.18280029296875, 397.1108093261719, 396.2779235839844})), Ntubes = 3444, L = 20.726, Cws1(h_vol_2(start = 194614.1875)), Cws2(h_vol_1(start = 513770.84375)), ExchangerFlueGasesMetal(step_T = 86.9e-3, Fa = 1, Dext = 38e-3, step_L = 92e-3, K(fixed = true, start = 31.53), CSailettes = 11.673758598919, p_rho = 1.15, Encras = Encras_EBP, St = 5, deltaT(start = {23.5, 5.3, 1.1}), T2(start = {442.58880615234375, 405.54898708865323, 397.2418326138536, 395.4642028808594}), T1(start = {424.0688986060054, 401.3954098512534, 396.353024695102}), Tp(start = {401.70281982421875, 397.2267761230469, 396.30267333984375}), h(start = {2706352.75, 2665392.25, 2656259.75, 2654311.25, 2654311.25})), TwoPhaseFlowPipe(advection = false, rugosrel = 5e-6, z1 = 0, z2 = 10.767, inertia = true, dW1(start = {24830472.0, 5536280.5, 1181209.875}), h(start = {194614.1875, 445813.0, 501821.0625, 513770.84375, 513770.84375}), hb(start = {194614.1875, 445813.0, 501821.0625, 513770.84375}), P(start = {1553925.0, 1527777.625, 1502576.125, 1477646.0, 1452776.625}), T0(start = {300.0, 300.0, 300.0}), hi(start = {461.386383, 487.565826, 492.916229}), Q(start = {98.847893, 98.847893, 98.847893, 98.847893}))) annotation(
    Placement(transformation(origin = {680, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  ThermoSysPro.Fluid.Machines.StodolaTurbine TurbineHP(redeclare package Medium = Medium, W_fric = 1, eta_stato = 1, eta_is(start = 0.8805699944496155), Qmax = 140, eta_is_nom = 0.88057, eta_is_min = 0.75, Cst(start = 8182844.56002535) = CstHP, rhos(start = 10.664762496948242), Hrs(start = 3046204.25), Pe(fixed = true, start = 12431000), Ps(fixed = false, start = 2726700)) annotation(
    Placement(transformation(extent = {{-2, -250}, {38, -210}}, rotation = 0)));
  ThermoSysPro.Fluid.Machines.StodolaTurbine TurbineMP(redeclare package Medium = Medium, W_fric = 1, eta_stato = 1, eta_is(start = 0.9624999761581421), Qmax = 150, eta_is_nom = 0.9625, eta_is_min = 0.75, Cst(start = 256335.364995961) = CstMP, rhos(start = 1.8829431533813477), Hrs(start = 3029680.75), Pe(fixed = true, start = 2548500), Ps(fixed = false, start = 476800)) annotation(
    Placement(transformation(extent = {{318, -250}, {358, -210}}, rotation = 0)));
  ThermoSysPro.Fluid.Volumes.VolumeC MelangeurPostTMP1(redeclare package Medium = Medium, h(start = 3018053.5), P(start = 476800.0), Ce1(h(start = 3029680.75)), Ce2(Q(start = 20.476648)), Ce3(h_vol_1(start = 3018053.5))) annotation(
    Placement(transformation(origin = {418, -230}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  ThermoSysPro.Fluid.Machines.StodolaTurbine TurbineBP(redeclare package Medium = Medium, W_fric = 1, eta_stato = 1, eta_is(start = 0.9538000226020813), Qmax = 150, eta_is_nom = 0.9538, eta_is_min = 0.75, Cst(start = 11944.9445735985) = CstBP, Cs(h(start = 2401340.5)), Hrs(start = 2401340.5), Pe(fixed = true, start = 476799.99999954), Ps(start = 10052.8291015625)) annotation(
    Placement(transformation(extent = {{576, -250}, {616, -210}}, rotation = 0)));
  ThermoSysPro.Fluid.Junctions.MassFlowMultiplier DoubleDebitHP(redeclare package Medium = Medium, alpha = 2) annotation(
    Placement(transformation(origin = {-292, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  ThermoSysPro.Fluid.Junctions.MassFlowMultiplier DoubleDebitMP(redeclare package Medium = Medium, alpha = 2) annotation(
    Placement(transformation(origin = {-232, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  ThermoSysPro.Fluid.Junctions.MassFlowMultiplier MoitieDebitHP(redeclare package Medium = Medium, alpha = 0.5, Ce(h(start = 3046204.25)), P(start = 2726700.0)) annotation(
    Placement(transformation(extent = {{114, -180}, {134, -160}}, rotation = 0)));
  ThermoSysPro.Fluid.HeatExchangers.SimpleDynamicCondenser Condenseur(redeclare package Medium = Medium, redeclare package Medium_Cooling = Medium, D = 0.018, V = 1000, A = 100, lambda = 0.01, ntubes = 28700, continuous_flow_reversal = true, Vf0 = 0.15, steady_state = false, yNiveau(signal(start = 1.5)), Cse(h(start = 128035.9921875), h_vol_1(start = 70825.89844)), P(start = 10000.0, fixed = false), Pfond(start = 10000.0), Cl(h(start = 191812.296875), Q(start = 197.69578552246094), h_vol_2(start = 191812.296875)), rhom(start = 996.0200805664062), hv(start = 2583886.75), Vv(start = 850.0), state_d(d(start = 989.8436279)), Cee(P(start = 146447.2031), h(start = 113380), h_vol_2(start = 113380))) annotation(
    Placement(transformation(extent = {{637, -384}, {717, -304}}, rotation = 0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ SourceCaloporteur(redeclare package Medium = Medium, h0 = 113.38e3, Q0 = 29804.5) annotation(
    Placement(transformation(extent = {{572, -377}, {620, -329}}, rotation = 0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP PuitsCaloporteur(redeclare package Medium = Medium, C(h_vol_1(start = 70825.89844))) annotation(
    Placement(transformation(extent = {{736, -374}, {780, -330}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss perteChargeK1(redeclare package Medium = Medium, K = 1e-4, h(start = 2401340.5), C1(h_vol_2(start = 2401340.5), h(start = 2401340.5)), Pm(start = 10026.4140625)) annotation(
    Placement(transformation(extent = {{640, -240}, {660, -220}}, rotation = 0)));
  ThermoSysPro.Fluid.Volumes.VolumeC VolumeCond1(redeclare package Medium = Medium, Ce3(h(start = 194614.1875)), h(start = 194614.1875), P(start = 1553925.0), Ce1(h_vol_1(start = 194614.1875)), Ce2(h_vol_1(start = 194614.1875))) annotation(
    Placement(transformation(origin = {902, -318}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss perteChargeKCond1(redeclare package Medium = Medium, K = 1e-4, rho(start = 990.3626098632812), Pm(start = 1553925.0)) annotation(
    Placement(transformation(origin = {902, -270}, extent = {{12, -12}, {-12, 12}}, rotation = 270)));
  ThermoSysPro.Fluid.Volumes.VolumeA VolumeAlimMPHP(redeclare package Medium = Medium, h(start = 556201.6875), P(start = 348615.09375), Ce2(h_vol_1(start = 556201.6875)), Cs1(h(start = 556201.6875)), Cs2(h(start = 556201.6875))) annotation(
    Placement(transformation(extent = {{742, -20}, {762, 0}}, rotation = 0)));
  ThermoSysPro.Fluid.Machines.StaticCentrifugalPump PompeAlimMP(redeclare package Medium = Medium, a3 = 350, b1(fixed = true) = -3.7751, a1 = -244551, Q(fixed = false), C1(h_vol_2(start = 556201.6875), P(start = 348615.0938)), C2(h_vol_1(start = 571212.5625), P(start = 3147558.25)), Qv(start = 0.013392460532486439), rho(start = 932.3015747070312), Pm(start = 1748086.625), h(start = 563707.125)) annotation(
    Placement(transformation(extent = {{804, -20}, {824, 0}}, rotation = 0)));
  ThermoSysPro.Fluid.Machines.StaticCentrifugalPump PompeAlimHP(redeclare package Medium = Medium, a3 = 1600, a1 = -28056.2, b1 = -12.7952660447433, Q(fixed = false), C1(h_vol_2(start = 556201.6875), P(start = 348615.0938)), C2(h_vol_1(start = 624690.125), P(start = 13229581)), Qv(start = 0.08183819055557251), rho(start = 930.1739501953125), Pm(start = 6789098.0), h(start = 590445.875)) annotation(
    Placement(transformation(extent = {{804, -60}, {824, -40}}, rotation = 0)));
  ThermoSysPro.Fluid.Junctions.MassFlowMultiplier MoitieDebitBP(redeclare package Medium = Medium, alpha = 0.5, h(start = 194614.1875), P(start = 1553925.0), Cs(h(start = 194614.1875))) annotation(
    Placement(transformation(extent = {{872, -328}, {886, -308}}, rotation = 0)));
  ThermoSysPro.Fluid.Junctions.MassFlowMultiplier DoubleDebitBP(redeclare package Medium = Medium, alpha = 2) annotation(
    Placement(transformation(origin = {268, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss PerteChargeZero2(redeclare package Medium = Medium, z2 = 0, z1 = 0, K = K_PerteChargeZero2, h(start = 2917424.75), C1(h_vol_2(start = 2917424.75), h(start = 2917424.75), P(fixed = true, start = 501850)), Pm(start = 489325.0), rho(start = 2.155861378)) annotation(
    Placement(transformation(origin = {344, -278}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss perteChargeK3(redeclare package Medium = Medium, K = 1e-4, Pm(start = 348615.09375)) annotation(
    Placement(transformation(origin = {780, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss perteChargeK8(redeclare package Medium = Medium, K = 1e-4, Pm(start = 348615.09375)) annotation(
    Placement(transformation(origin = {780, -10}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  ThermoSysPro.ElectroMechanics.Machines.Generator Alternateur annotation(
    Placement(transformation(extent = {{402, -448}, {522, -348}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss perteChargeK(redeclare package Medium = Medium, K = 1e-4, C1(h_vol_2(start = 191812.296875)), C2(h_vol_1(start = 191812.296875), P(start = 9999.996094)), rho(start = 989.83837890625), Pm(start = 9999.998046875)) annotation(
    Placement(transformation(extent = {{702, -446}, {722, -426}}, rotation = 0)));
  ThermoSysPro.Fluid.Machines.StaticCentrifugalPump PompeAlimBP(redeclare package Medium = Medium, Qv(start = 0.1996714472770691), a3 = 400, a1(fixed = true) = -6000, Q(start = 194.502, fixed = false), C2(h_vol_1(start = 194614.1875), P(start = 1571189)), Pm(start = 790594.5), h(start = 193213.2344)) annotation(
    Placement(transformation(extent = {{742, -446}, {762, -426}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss perteChargeK2(redeclare package Medium = Medium, K = 1e-4, rho(start = 990.3626098632812), C1(h_vol_2(start = 194614.1875), h(start = 194614.1875), P(start = 1553925)), Pm(start = 1553925.0)) annotation(
    Placement(transformation(extent = {{840, -446}, {860, -426}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve vanne_extraction(redeclare package Medium = Medium, Cvmax = 2000, h(start = 194614.1875), Cv(start = 2000.0), Pm(start = 1562557.0)) annotation(
    Placement(transformation(extent = {{802, -440}, {822, -420}}, rotation = 0)));
  ThermoSysPro.Fluid.Sensors.SensorQ CapteurDebitVapHP(redeclare package Medium = Medium, C1(h_vol_2(start = 2664771.25), h(start = 2664771.25))) annotation(
    Placement(transformation(origin = {-58, 8}, extent = {{-6, 6}, {6, -6}}, rotation = 270)));
  ThermoSysPro.Fluid.Sensors.SensorQ CapteurDebitEauHP(redeclare package Medium = Medium, C2(h_vol_1(start = 1398733.0), h(start = 1398733.0))) " " annotation(
    Placement(transformation(origin = {91.5, 32}, extent = {{6, -6.5}, {-6, 6.5}}, rotation = 270)));
  ThermoSysPro.Fluid.Sensors.SensorQ CapteurDebitEauMP(redeclare package Medium = Medium, C2(h_vol_1(start = 946338.375), h(start = 946338.375))) annotation(
    Placement(transformation(extent = {{424, 49}, {409, 63}}, rotation = 0)));
  ThermoSysPro.Fluid.Sensors.SensorQ CapteurDebitVapMP(redeclare package Medium = Medium, C1(h_vol_2(start = 2798679.25), h(start = 2798679.25))) annotation(
    Placement(transformation(origin = {236, 56}, extent = {{-8, 8}, {8, -8}}, rotation = 180)));
  ThermoSysPro.Fluid.Sensors.SensorQ CapteurDebitVapBP(redeclare package Medium = Medium, C2(h_vol_1(start = 2683834.25), h(start = 2683834.25))) annotation(
    Placement(transformation(origin = {514, 56}, extent = {{-8, 8}, {8, -8}}, rotation = 180)));
  ThermoSysPro.Fluid.Sensors.SensorQ CapteurDebitEauBP(redeclare package Medium = Medium, C2(h_vol_1(start = 513770.84375), h(start = 513770.84375))) annotation(
    Placement(transformation(origin = {663.5, 34}, extent = {{6, -6.5}, {-6, 6.5}}, rotation = 270)));
  ThermoSysPro.Fluid.Sensors.SensorQ CapteurDebitEauBPsortie(redeclare package Medium = Medium, C2(h_vol_1(start = 556201.6875), h(start = 556201.6875))) annotation(
    Placement(transformation(extent = {{687, -11}, {700, 1}}, rotation = 0)));
  ThermoSysPro.Fluid.Sensors.SensorQ CapteurDebitEauCondenseur(redeclare package Medium = Medium, C2(h_vol_1(start = 191812.296875), h(start = 191812.296875))) annotation(
    Placement(transformation(origin = {685.5, -412}, extent = {{-10, -6.5}, {10, 6.5}}, rotation = 270)));
  ThermoSysPro.Fluid.Sensors.SensorQ CapteurDebitVapCondenseur(redeclare package Medium = Medium, C2(h_vol_1(start = 2583886.75), h(start = 2401340.5))) annotation(
    Placement(transformation(origin = {684.5, -264}, extent = {{-10, -6.5}, {10, 6.5}}, rotation = 270)));
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss lumpedStraightPipeK2(redeclare package Medium = Medium, K = Kin_SMP2, Pm(start = 2651158.0), C1(P(fixed = true, start = 2726700), h_vol_2(start = 3040476.25), h(start = 3040476.25))) annotation(
    Placement(transformation(extent = {{114, -120}, {94, -100}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve vanne_entree_TurbineHP(redeclare package Medium = Medium, C1(P(fixed = true, start = 12680999.9999969)), Cvmax = Cvmax_THP, h(fixed = false, start = 3433000), Cv(start = 10876.2412109375), Pm(fixed = false, start = 12550000), deltaP(start = 250000)) annotation(
    Placement(transformation(extent = {{-124, -234}, {-104, -214}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante ConsigneNiveauEauHP(k = 1.05) annotation(
    Placement(transformation(extent = {{-158, 113}, {-124, 131}}, rotation = 0)));
  ThermoSysPro.Examples.Control.Drum_LevelControl regulation_Niveau_HP(pIsat(Ti = 500, Limiteur1(u(signal(start = 0.800000011920929)))), add(k1 = -1, k2 = +1), Ti = 500) annotation(
    Placement(transformation(extent = {{-40, 106}, {-20, 126}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante ConsigneNiveauEauMP(k = 1.05) annotation(
    Placement(transformation(extent = {{173, 113}, {207, 131}}, rotation = 0)));
  ThermoSysPro.Examples.Control.Drum_LevelControl regulation_Niveau_MP(pIsat(Ti = 500, Limiteur1(u(signal(start = 0.800000011920929)))), add(k1 = -1, k2 = +1), Ti = 500) annotation(
    Placement(transformation(extent = {{262, 106}, {282, 126}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante ConsigneNiveauEauBP(k = 1.75) annotation(
    Placement(transformation(extent = {{470, 126}, {504, 144}}, rotation = 0)));
  ThermoSysPro.Examples.Control.Drum_LevelControl regulation_Niveau_BP(add(k1 = -1, k2 = +1), pIsat(Ti = 500, Limiteur1(u(signal(start = 0.800000011920929)))), Ti = 10) annotation(
    Placement(transformation(extent = {{568, 108}, {588, 128}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante ConsigneNiveauCondenseur1(k = 1.5) annotation(
    Placement(transformation(extent = {{716, -246}, {740, -230}}, rotation = 0)));
  ThermoSysPro.Examples.Control.Condenser_LevelControl regulation_Niveau_Condenseur(pIsat(Ti = 500, Limiteur1(u(signal(start = 0.800000011920929)))), add(k1 = +1, k2 = -1), edge(uL(signal(start = true)))) annotation(
    Placement(transformation(extent = {{758, -282}, {778, -262}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Tables.Table1DTemps ConstantVanneTurbineHP(Table = [0, 0.8; 10, 0.8; 600, 0.8; 650, 0.8; 3000, 0.8; 3100, 0.8]) annotation(
    Placement(transformation(extent = {{-208, -216}, {-138, -142}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Rampe arretPomesMp(Initialvalue = 1400, Finalvalue = 1000, Duration = 1000, Starttime = 200000) annotation(
    Placement(transformation(extent = {{944, -42}, {906, -10}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Rampe arretPomesHP(Initialvalue = 1400, Finalvalue = 1000, Duration = 1000, Starttime = 200000) annotation(
    Placement(transformation(extent = {{945, -96}, {907, -64}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Rampe arretPomesBP(Initialvalue = 1400, Finalvalue = 1000, Duration = 1000, Starttime = 200000) annotation(
    Placement(transformation(extent = {{945, -458}, {907, -426}}, rotation = 0)));
  ThermoSysPro.Fluid.Volumes.VolumeC VolumeECO_HP1_2(redeclare package Medium = Medium, V = 1, h0 = 988332, h(start = 857742.5), dynamic_mass_balance = true, P0 = 7010000, P(start = 13132658.0), Ce2(h_vol_1(start = 857742.5)), Ce3(h_vol_1(start = 857742.5))) annotation(
    Placement(transformation(extent = {{456, -98}, {436, -78}}, rotation = 0)));
  ThermoSysPro.Fluid.Volumes.VolumeC VolumeECO_HP2_3(redeclare package Medium = Medium, V = 1, h0 = 983786, h(start = 988178.3125), dynamic_mass_balance = true, P0 = 7000000, P(start = 13222570.0), Ce2(h_vol_1(start = 988178.3125)), Ce3(h_vol_1(start = 988178.3125))) annotation(
    Placement(transformation(extent = {{252, -20}, {232, 0}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve Vanne_alimentationMPHP1(redeclare package Medium = Medium, Cvmax = 308.931, h(start = 624690.125), Cv(start = 247.14480590820312), Pm(start = 13133975.0)) annotation(
    Placement(transformation(extent = {{754, -98}, {730, -122}}, rotation = 0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve Vanne_alimentationMPHP2(redeclare package Medium = Medium, Cvmax = 308.931, h(start = 571212.5625), Cv(start = 247.14480590820312), Pm(start = 3145010.5)) annotation(
    Placement(transformation(extent = {{804, -138}, {780, -162}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Rampe arretPomesMp1(Initialvalue = 0.8, Finalvalue = 0.01, Duration = 1000, Starttime = 200000) annotation(
    Placement(transformation(extent = {{946, -150}, {908, -118}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Rampe arretPomesHP1(Initialvalue = 0.8, Finalvalue = 0.01, Duration = 1000, Starttime = 200000) annotation(
    Placement(transformation(extent = {{946, -194}, {908, -162}}, rotation = 0)));
  ThermoSysPro.Fluid.Volumes.VolumeD VolumePreTHP(redeclare package Medium = Medium, h0 = 3e6, h(start = 3433201.75), dynamic_mass_balance = true, P0 = 12700000, P(start = 12431000.0), Cs1(h_vol_2(start = 3433201.75)), Cs2(h_vol_2(start = 3433201.75))) annotation(
    Placement(transformation(origin = {-52, -230}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  ThermoSysPro.Fluid.Volumes.VolumeC MelangeurPreTMP(redeclare package Medium = Medium, h0 = 3523910, h(start = 3517830.25), dynamic_mass_balance = true, P0 = 2400000, P(start = 2548500.0), Ce2(h_vol_1(start = 3517830.25)), Ce3(h_vol_1(start = 3517830.25))) annotation(
    Placement(transformation(origin = {-50, -314}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve vanne_entree_TurbineMP(redeclare package Medium = Medium, C1(P(fixed = true, start = 25.486e5)), Cvmax = Cvmax_TMP, h(fixed = false, start = 3518000), Cv(start = 3313994.0), Pm(fixed = false, start = 2547000), deltaP(start = 100)) annotation(
    Placement(transformation(extent = {{-124, -318}, {-104, -298}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Tables.Table1DTemps ConstantVanneTurbineMP(Table = [0, 0.8; 10, 0.8; 600, 0.8; 2000, 0.8; 3000, 0.8; 3100, 0.8]) annotation(
    Placement(transformation(extent = {{-208, -300}, {-138, -226}}, rotation = 0)));
  ThermoSysPro.Thermal.BoundaryConditions.HeatSource heatSource(T0 = {303.16}) annotation(
    Placement(transformation(extent = {{5, 68}, {31, 98}}, rotation = 0)));
  ThermoSysPro.Thermal.BoundaryConditions.HeatSource heatSource1(T0 = {303.16}) annotation(
    Placement(transformation(extent = {{326, 68}, {352, 98}}, rotation = 0)));
  ThermoSysPro.Thermal.BoundaryConditions.HeatSource heatSource2(T0 = {303.16}) annotation(
    Placement(transformation(extent = {{585, 64}, {611, 94}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Gain Gain_2GasTurbine(Gain = 2) annotation(
    Placement(transformation(extent = {{-18, -448}, {2, -428}}, rotation = 0)));
  ThermoSysPro.Fluid.Combustion.BoundaryConditions.FuelSourcePQ sourceCombustible(Hum = 0, Xo = 0, Xn = 0, Xs = 0, rho = 0.838, Q0 = 13.4368286133, T0 = 185 + 273.16, Xc = 0.755, Xh = 0.245, Cp = 2255, LHV = 46989e3) annotation(
    Placement(transformation(extent = {{-421, 24}, {-385, 60}}, rotation = 0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourceEau(redeclare package Medium = Medium, Q0 = 0.0) annotation(
    Placement(transformation(extent = {{-473, 27}, {-445, 57}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante Humidite(k = 0.93) annotation(
    Placement(transformation(extent = {{-539, 23}, {-518, 43}}, rotation = 0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ SourceFumees(redeclare package Medium = Medium_FlueGases, X0 = {0.79006, 0.20994, 0, 0, 0}, option_temperature = true, Q0 = 600, T0 = 29.4 + 273.16, P0 = 1.013e5) annotation(
    Placement(transformation(extent = {{-539, -74}, {-495, -28}}, rotation = 0)));
  ThermoSysPro.Fluid.Machines.GasTurbine GasTurbine(redeclare package Medium = Medium, redeclare package Medium_FlueGases = Medium_FlueGases, comp_tau_n = 14.0178, comp_eff_n = 0.87004, exp_tau_n = 0.06458, exp_eff_n = 0.89045, TurbQred = 0.0175634, Kcham = 2.02088, chambreCombustionTAC(Pea(fixed = false, start = 14.0e5), Psf(start = 1333895.5), Tsf(start = 1493.547119140625), Hrfg(start = 181479.640625), Tea(start = 678.0772094726562)), Wpth = 1e6, Compresseur(is_eff(fixed = false, start = 0.88), Xtau(fixed = false, start = 1.00), Ps(start = 1419887.5), Ts(start = 678.0772094726562), Tis(start = 630.7854614257812), Te(start = 302.55999755859375)), TurbineAgaz(Ps(fixed = false), is_eff(fixed = false, start = 0.87), Pe(fixed = false, start = 1333900), Te(start = 1493.547119140625), Ts(fixed = false, start = 893.16), Tis(start = 814.7440795898438)), xAIR(rho_air(start = 1.0994528532028198), ppvap0(start = 3817.616455), rho_vap(start = 0.02738765999674797), C2(Xi(start = {0.7708577346, 0.2048374414, 0.02430482395, 0, 0})), pro(h(start = 2554653.25)))) annotation(
    Placement(transformation(extent = {{-471, -115}, {-341, 13}}, rotation = 0)));
  InstrumentationAndControl.Blocks.Sources.Rampe rampeQfuel(Starttime = 200, Duration = 800, Initialvalue = 13.507, Finalvalue = 8.756) annotation(
    Placement(transformation(extent = {{-539, 64}, {-519, 84}}, rotation = 0)));
  InstrumentationAndControl.Blocks.Sources.Rampe rampeIQair(Starttime = 200, Duration = 800, Finalvalue = 415.70, Initialvalue = 592.7) annotation(
    Placement(transformation(extent = {{-541, -20}, {-521, 0}}, rotation = 0)));
equation
  connect(SurchauffeurHP3.Cws1, SurchauffeurHP2.Cws2) annotation(
    Line(points = {{-294, -30}, {-294, -10}, {-174, -10}, {-174, -30}}, color = {255, 0, 0}));
  connect(SurchauffeurHP2.Cws1, SurchauffeurHP1.Cws2) annotation(
    Line(points = {{-174, -70}, {-174, -90}, {-54, -90}, {-54, -70}}, color = {255, 0, 0}));
  connect(constante_vanne_vapeurHP.y, vanne_vapeurHP.Ouv) annotation(
    Line(points = {{-28.5, 74}, {-32, 74}, {-32, 67}}));
  connect(vanne_vapeurHP.C1, BallonHP.Cv) annotation(
    Line(points = {{-22, 50}, {-2, 50}}, color = {255, 0, 0}));
  connect(GainChargeHP.C1, BallonHP.Cd) annotation(
    Line(points = {{38, -90}, {48, -90}, {48, 10}, {38, 10}}, color = {255, 128, 0}));
  connect(BallonHP.Cm, EvaporateurHP.Cws2) annotation(
    Line(points = {{-2, 10}, {-14, 10}, {-14, -30}}));
  connect(VolumeEvapHP.Cs, EvaporateurHP.Cws1) annotation(
    Line(points = {{-12, -90}, {-12, -70}, {-14, -70}}, color = {255, 128, 0}));
  connect(VolumeEvapHP.Ce1, GainChargeHP.C2) annotation(
    Line(points = {{8, -90}, {18, -90}}, color = {255, 128, 0}));
  connect(EconomiseurHP4.Cws1, EconomiseurHP3.Cws2) annotation(
    Line(points = {{86, -70}, {86, -82}, {206, -82}, {206, -70}}));
  connect(BallonMP.Cm, EvaporateurMP.Cws2) annotation(
    Line(points = {{320, 10}, {306, 10}, {306, -30}}));
  connect(EvaporateurMP.Cws1, VolumeEvapMP.Cs) annotation(
    Line(points = {{306, -70}, {306, -80}, {308, -80}, {308, -90}}, color = {255, 128, 0}));
  connect(VolumeEvapMP.Ce1, GainChargeMP.C2) annotation(
    Line(points = {{328, -90}, {338, -90}}, color = {255, 128, 0}));
  connect(constante_vanne_vapeurMP.y, vanne_vapeurMP.Ouv) annotation(
    Line(points = {{291.4, 75}, {288, 75}, {288, 67}}));
  connect(SurchauffeurHP1.Cfg2, EvaporateurHP.Cfg1) annotation(
    Line(points = {{-44, -50}, {-24, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(EvaporateurHP.Cfg2, EconomiseurHP4.Cfg1) annotation(
    Line(points = {{-4, -50}, {76, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(EconomiseurHP4.Cfg2, SurchauffeurMP1.Cfg1) annotation(
    Line(points = {{96, -50}, {136, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(SurchauffeurMP1.Cfg2, EconomiseurHP3.Cfg1) annotation(
    Line(points = {{156, -50}, {196, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(EvaporateurMP.Cfg2, EconomiseurHP2.Cfg1) annotation(
    Line(points = {{316, -50}, {396, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(EconomiseurHP2.Cfg2, EconomiseurMP.Cfg1) annotation(
    Line(points = {{416, -50}, {456, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(EconomiseurMP.Cfg2, EconomiseurHP1.Cfg1) annotation(
    Line(points = {{476, -50}, {516, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(GainChargeMP.C1, BallonMP.Cd) annotation(
    Line(points = {{358, -90}, {368, -90}, {368, 10}, {358, 10}}, color = {255, 128, 0}));
  connect(SurchauffeurMP2.Cfg2, SurchauffeurHP1.Cfg1) annotation(
    Line(points = {{-104, -50}, {-64, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(SurchauffeurMP2.Cfg1, SurchauffeurHP2.Cfg2) annotation(
    Line(points = {{-124, -50}, {-164, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(SurchauffeurMP3.Cfg2, SurchauffeurHP2.Cfg1) annotation(
    Line(points = {{-224, -50}, {-184, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(SurchauffeurHP3.Cfg2, SurchauffeurMP3.Cfg1) annotation(
    Line(points = {{-284, -50}, {-244, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(SurchauffeurMP3.Cws1, SurchauffeurMP2.Cws2) annotation(
    Line(points = {{-234, -30}, {-234, 10}, {-114, 10}, {-114, -30}}, color = {255, 0, 0}));
  connect(SurchauffeurMP1.Cws2, MelangeurHPMP.Ce2) annotation(
    Line(points = {{146, -70}, {146, -85}, {148, -85}, {148, -100}}, color = {255, 0, 0}, pattern = LinePattern.None));
  connect(vanne_vapeurBP.C1, BallonBP.Cv) annotation(
    Line(points = {{558, 50}, {578, 50}}, color = {255, 0, 0}));
  connect(EvaporateurBP.Cws1, VolumeEvapBP.Cs) annotation(
    Line(points = {{566, -70}, {566, -90}, {572, -90}}, color = {255, 128, 0}));
  connect(VolumeEvapBP.Ce1, GainChargeBP.C2) annotation(
    Line(points = {{592, -90}, {600, -90}}, color = {255, 128, 0}));
  connect(BallonBP.Cd, GainChargeBP.C1) annotation(
    Line(points = {{618, 10}, {628, 10}, {628, -90}, {620, -90}}, color = {255, 128, 0}));
  connect(EconomiseurBP.Cfg2, PuitsFumees.C) annotation(
    Line(points = {{690, -50}, {712, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(EconomiseurHP3.Cfg2, SurchauffeurBP.Cfg1) annotation(
    Line(points = {{216, -50}, {256, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(SurchauffeurBP.Cfg2, EvaporateurMP.Cfg1) annotation(
    Line(points = {{276, -50}, {296, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(EconomiseurHP1.Cfg2, EvaporateurBP.Cfg1) annotation(
    Line(points = {{536, -50}, {556, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(EvaporateurBP.Cfg2, EconomiseurBP.Cfg1) annotation(
    Line(points = {{576, -50}, {670, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(BallonBP.Cm, EvaporateurBP.Cws2) annotation(
    Line(points = {{578, 10}, {566, 10}, {566, -30}}));
  connect(vanne_vapeurMP.C1, BallonMP.Cv) annotation(
    Line(points = {{298, 50}, {320, 50}}, color = {255, 0, 0}));
  connect(Vanne_alimentationMPHP.Ouv, constante_ballonBP.y) annotation(
    Line(points = {{720, 7}, {720, 12}, {727.3, 12}}));
  connect(SurchauffeurHP3.Cws2, DoubleDebitHP.Ce) annotation(
    Line(points = {{-294, -70}, {-294, -80}, {-292, -80}, {-292, -90}}, color = {255, 0, 0}));
  connect(SurchauffeurMP3.Cws2, DoubleDebitMP.Ce) annotation(
    Line(points = {{-234, -70}, {-234, -80}, {-232, -80}, {-232, -90}}, color = {255, 0, 0}));
  connect(VolumeCond1.Cs, perteChargeKCond1.C1) annotation(
    Line(points = {{902, -308}, {902, -282}}, color = {0, 0, 255}));
  connect(Vanne_alimentationMPHP.C2, VolumeAlimMPHP.Ce1) annotation(
    Line(points = {{730, -10}, {742, -10}}, color = {0, 0, 255}));
  connect(SurchauffeurBP.Cws2, DoubleDebitBP.Ce) annotation(
    Line(points = {{266, -70}, {266, -80}, {268, -80}, {268, -90}}, color = {255, 0, 0}));
  connect(perteChargeK8.C2, PompeAlimMP.C1) annotation(
    Line(points = {{790, -10}, {797, -10}, {804, -10}}, color = {0, 0, 255}));
  connect(VolumeAlimMPHP.Cs1, perteChargeK8.C1) annotation(
    Line(points = {{762, -10}, {766, -10}, {770, -10}}, color = {0, 0, 255}));
  connect(VolumeAlimMPHP.Cs2, perteChargeK3.C1) annotation(
    Line(points = {{752, -20}, {752, -50}, {770, -50}}, color = {0, 0, 255}));
  connect(perteChargeK3.C2, PompeAlimHP.C1) annotation(
    Line(points = {{790, -50}, {804, -50}}, color = {0, 0, 255}));
  connect(MelangeurPostTMP1.Ce2, PerteChargeZero2.C2) annotation(
    Line(points = {{418, -240}, {418, -278}, {354, -278}}, color = {255, 0, 0}));
  connect(perteChargeK.C2, PompeAlimBP.C1) annotation(
    Line(points = {{722, -436}, {742, -436}}, color = {0, 0, 255}));
  connect(vanne_extraction.C2, perteChargeK2.C1) annotation(
    Line(points = {{822, -436}, {840, -436}}, color = {0, 0, 255}));
  connect(vanne_alimentationHP.C1, CapteurDebitEauHP.C2) annotation(
    Line(points = {{78, 50}, {86.3, 50}, {86.3, 38.12}}));
  connect(vanne_vapeurHP.C2, CapteurDebitVapHP.C1) annotation(
    Line(points = {{-42, 50}, {-53.2, 50}, {-53.2, 14}}, color = {255, 0, 0}));
  connect(CapteurDebitVapHP.C2, SurchauffeurHP1.Cws1) annotation(
    Line(points = {{-53.2, 1.88}, {-53.2, -3.06}, {-54, -3.06}, {-54, -30}}, color = {255, 0, 0}));
  connect(vanne_alimentationMP.C1, CapteurDebitEauMP.C2) annotation(
    Line(points = {{398, 50}, {403.425, 50}, {403.425, 50.4}, {408.85, 50.4}}));
  connect(CapteurDebitVapMP.C1, vanne_vapeurMP.C2) annotation(
    Line(points = {{244, 49.6}, {260, 49.6}, {260, 50}, {278, 50}}, color = {255, 0, 0}));
  connect(CapteurDebitVapMP.C2, SurchauffeurMP1.Cws1) annotation(
    Line(points = {{227.84, 49.6}, {146, 49.6}, {146, -30}}, color = {255, 0, 0}));
  connect(CapteurDebitVapBP.C2, SurchauffeurBP.Cws1) annotation(
    Line(points = {{505.84, 49.6}, {490, 49.6}, {490, -2}, {266, -2}, {266, -30}}, color = {255, 0, 0}));
  connect(CapteurDebitVapBP.C1, vanne_vapeurBP.C2) annotation(
    Line(points = {{522, 49.6}, {530, 49.6}, {530, 50}, {538, 50}}, color = {255, 0, 0}));
  connect(CapteurDebitEauBP.C2, vanne_alimentationBP.C1) annotation(
    Line(points = {{658.3, 40.12}, {658.3, 48}, {650, 48}}, color = {0, 0, 255}));
  connect(CapteurDebitEauBPsortie.C2, Vanne_alimentationMPHP.C1) annotation(
    Line(points = {{700.13, -9.8}, {705.065, -9.8}, {705.065, -10}, {710, -10}}, color = {0, 0, 255}));
  connect(CapteurDebitEauCondenseur.C2, perteChargeK.C1) annotation(
    Line(points = {{680.3, -422.2}, {680.3, -436}, {702, -436}}, color = {0, 0, 255}));
  connect(perteChargeK1.C2, CapteurDebitVapCondenseur.C1) annotation(
    Line(points = {{660, -230}, {679.3, -230}, {679.3, -254}}, color = {255, 0, 0}));
  connect(MelangeurHPMP.Ce1, MoitieDebitHP.Cs) annotation(
    Line(points = {{148, -120}, {148, -170}, {134, -170}}, color = {255, 0, 0}));
  connect(perteChargeK2.C2, MoitieDebitBP.Ce) annotation(
    Line(points = {{860, -436}, {862, -436}, {862, -318}, {872, -318}}, color = {0, 0, 255}));
  connect(MoitieDebitBP.Cs, VolumeCond1.Ce3) annotation(
    Line(points = {{886, -318}, {892, -318}}, color = {0, 0, 255}));
  connect(SurchauffeurMP2.Cws1, lumpedStraightPipeK2.C2) annotation(
    Line(points = {{-114, -70}, {-114, -110}, {94, -110}}, color = {255, 0, 0}));
  connect(lumpedStraightPipeK2.C1, MelangeurHPMP.Cs2) annotation(
    Line(points = {{114, -110}, {138, -110}}, color = {255, 0, 0}));
  connect(DoubleDebitHP.Cs, vanne_entree_TurbineHP.C1) annotation(
    Line(points = {{-292, -110}, {-292, -230}, {-124, -230}}, color = {255, 0, 0}));
  connect(DoubleDebitBP.Cs, PerteChargeZero2.C1) annotation(
    Line(points = {{268, -110}, {268, -278}, {334, -278}}, color = {255, 0, 0}));
  connect(PompeAlimBP.C2, vanne_extraction.C1) annotation(
    Line(points = {{762, -436}, {802, -436}}, color = {0, 0, 255}));
  connect(BallonHP.yLevel, regulation_Niveau_HP.MesureNiveauEau) annotation(
    Line(points = {{-4, 30}, {-68, 30}, {-68, 125}, {-40.5, 125}}));
  connect(regulation_Niveau_HP.SortieReelle1, vanne_alimentationHP.Ouv) annotation(
    Line(points = {{-19.5, 107}, {68, 107}, {68, 67}}));
  connect(ConsigneNiveauEauMP.y, regulation_Niveau_MP.ConsigneNiveauEau) annotation(
    Line(points = {{208.7, 122}, {234, 122}, {234, 110}, {261.5, 110}}));
  connect(BallonMP.yLevel, regulation_Niveau_MP.MesureNiveauEau) annotation(
    Line(points = {{318.1, 30}, {252, 30}, {252, 125}, {261.5, 125}}));
  connect(regulation_Niveau_MP.SortieReelle1, vanne_alimentationMP.Ouv) annotation(
    Line(points = {{282.5, 107}, {377.25, 107}, {377.25, 67}, {388, 67}}));
  connect(ConsigneNiveauEauBP.y, regulation_Niveau_BP.ConsigneNiveauEau) annotation(
    Line(points = {{505.7, 135}, {529.85, 135}, {529.85, 112}, {567.5, 112}}));
  connect(BallonBP.yLevel, regulation_Niveau_BP.MesureNiveauEau) annotation(
    Line(points = {{576, 30}, {518, 30}, {518, 127}, {567.5, 127}}));
  connect(ConsigneNiveauCondenseur1.y, regulation_Niveau_Condenseur.ConsigneNiveauEau) annotation(
    Line(points = {{741.2, -238}, {752, -238}, {752, -269}, {757.5, -269}}));
  connect(regulation_Niveau_Condenseur.SortieReelle1, vanne_extraction.Ouv) annotation(
    Line(points = {{778.5, -281}, {812, -281}, {812, -419}}));
  connect(CapteurDebitEauBP.C1, EconomiseurBP.Cws2) annotation(
    Line(points = {{658.3, 28}, {660, 28}, {660, 6}, {680, 6}, {680, -30}}));
  connect(EconomiseurBP.Cws1, perteChargeKCond1.C2) annotation(
    Line(points = {{680, -70}, {680, -186}, {902, -186}, {902, -258}}));
  connect(CapteurDebitVapCondenseur.Measure, regulation_Niveau_Condenseur.MesureDebitVapeur) annotation(
    Line(points = {{691.13, -264}, {704, -264}, {704, -280.9}, {757.6, -280.9}}));
  connect(regulation_Niveau_Condenseur.MesureDebitEau, CapteurDebitEauCondenseur.Measure) annotation(
    Line(points = {{757.45, -274.95}, {750, -274.95}, {750, -310}, {792, -310}, {792, -412}, {692.13, -412}}));
  connect(ConstantVanneTurbineHP.y, vanne_entree_TurbineHP.Ouv) annotation(
    Line(points = {{-134.5, -179}, {-114, -179}, {-114, -213}}));
  connect(regulation_Niveau_BP.SortieReelle1, vanne_vapeurBP.Ouv) annotation(
    Line(points = {{588.5, 109}, {600, 109}, {600, 90}, {548, 90}, {548, 67}}));
  connect(vanne_alimentationBP.Ouv, constante_vanne_vapeurBP.y) annotation(
    Line(points = {{640, 65}, {640, 81}, {653.4, 81}}));
  connect(EconomiseurHP1.Cws2, VolumeECO_HP1_2.Ce1) annotation(
    Line(points = {{526, -70}, {526, -88}, {456, -88}}, color = {0, 0, 255}));
  connect(VolumeECO_HP1_2.Cs, EconomiseurHP2.Cws1) annotation(
    Line(points = {{436, -88}, {406, -88}, {406, -70}}, color = {0, 0, 255}));
  connect(EconomiseurHP2.Cws2, VolumeECO_HP2_3.Ce1) annotation(
    Line(points = {{406, -30}, {406, -10}, {252, -10}}, color = {0, 0, 255}));
  connect(VolumeECO_HP2_3.Cs, EconomiseurHP3.Cws1) annotation(
    Line(points = {{232, -10}, {206, -10}, {206, -30}}, color = {0, 0, 255}));
  connect(Vanne_alimentationMPHP1.C1, PompeAlimHP.C2) annotation(
    Line(points = {{754, -102.8}, {842, -102.8}, {842, -50}, {824, -50}}));
  connect(PompeAlimMP.C2, Vanne_alimentationMPHP2.C1) annotation(
    Line(points = {{824, -10}, {870, -10}, {870, -142.8}, {804, -142.8}}, color = {0, 0, 255}));
  connect(arretPomesMp1.y, Vanne_alimentationMPHP1.Ouv) annotation(
    Line(points = {{906.1, -134}, {856, -134}, {856, -122}, {742, -122}, {742, -123.2}}));
  connect(arretPomesHP1.y, Vanne_alimentationMPHP2.Ouv) annotation(
    Line(points = {{906.1, -178}, {883.05, -178}, {883.05, -163.2}, {792, -163.2}}));
  connect(Vanne_alimentationMPHP1.C2, EconomiseurHP1.Cws1) annotation(
    Line(points = {{730, -102.8}, {636, -102.8}, {636, -106}, {548, -106}, {548, -6}, {526, -6}, {526, -30}}, color = {0, 0, 255}));
  connect(EconomiseurMP.Cws1, Vanne_alimentationMPHP2.C2) annotation(
    Line(points = {{466, -70}, {466, -142.8}, {780, -142.8}}));
  connect(ConstantVanneTurbineMP.y, vanne_entree_TurbineMP.Ouv) annotation(
    Line(points = {{-134.5, -263}, {-114, -263}, {-114, -297}}));
  connect(vanne_entree_TurbineHP.C2, VolumePreTHP.Ce) annotation(
    Line(points = {{-104, -230}, {-62, -230}}, color = {255, 0, 0}));
  connect(DoubleDebitMP.Cs, vanne_entree_TurbineMP.C1) annotation(
    Line(points = {{-232, -110}, {-232, -314}, {-124, -314}}, color = {255, 0, 0}));
  connect(vanne_entree_TurbineMP.C2, MelangeurPreTMP.Ce1) annotation(
    Line(points = {{-104, -314}, {-60, -314}}, color = {255, 0, 0}));
  connect(SourceCaloporteur.C, Condenseur.Cee) annotation(
    Line(points = {{620, -353}, {638, -353}, {638, -352.8}, {637, -352.8}}, color = {0, 0, 255}));
  connect(Condenseur.Cse, PuitsCaloporteur.C) annotation(
    Line(points = {{717, -352}, {736, -352}}, color = {0, 0, 255}));
  connect(CapteurDebitVapCondenseur.C2, Condenseur.Cv) annotation(
    Line(points = {{679.3, -274.2}, {679.3, -288.1}, {677, -288.1}, {677, -304}}, color = {0, 0, 255}));
  connect(CapteurDebitEauCondenseur.C1, Condenseur.Cl) annotation(
    Line(points = {{680.3, -402}, {677.8, -402}, {677.8, -384}}));
  connect(ConsigneNiveauEauHP.y, regulation_Niveau_HP.ConsigneNiveauEau) annotation(
    Line(points = {{-122.3, 122}, {-100, 122}, {-100, 110}, {-40.5, 110}}));
  connect(Condenseur.yNiveau, regulation_Niveau_Condenseur.MesureNiveauEau) annotation(
    Line(points = {{721, -372.8}, {780, -372.8}, {780, -326}, {732, -326}, {732, -263}, {757.5, -263}}));
  connect(BallonBP.Cs, CapteurDebitEauBPsortie.C1) annotation(
    Line(points = {{578, 22}, {564, 22}, {564, 16}, {642, 16}, {642, -9.8}, {687, -9.8}}, color = {0, 0, 255}));
  connect(BallonBP.Ce1, vanne_alimentationBP.C2) annotation(
    Line(points = {{618, 50}, {624, 50}, {624, 48}, {630, 48}}));
  connect(BallonMP.Ce1, vanne_alimentationMP.C2) annotation(
    Line(points = {{358, 50}, {378, 50}}));
  connect(BallonHP.Ce1, vanne_alimentationHP.C2) annotation(
    Line(points = {{38, 50}, {58, 50}}));
  connect(TurbineHP.Cs, MoitieDebitHP.Ce) annotation(
    Line(points = {{38.2, -230}, {74, -230}, {74, -170}, {114, -170}}, color = {255, 0, 0}));
  connect(VolumePreTHP.Cs3, TurbineHP.Ce) annotation(
    Line(points = {{-42, -230}, {-2.2, -230}}, color = {255, 0, 0}));
  connect(MelangeurPreTMP.Cs, TurbineMP.Ce) annotation(
    Line(points = {{-40, -314}, {106, -314}, {106, -230}, {317.8, -230}}, color = {255, 0, 0}));
  connect(TurbineMP.Cs, MelangeurPostTMP1.Ce1) annotation(
    Line(points = {{358.2, -230}, {408, -230}}, color = {255, 0, 0}));
  connect(MelangeurPostTMP1.Cs, TurbineBP.Ce) annotation(
    Line(points = {{428, -230}, {575.8, -230}}, color = {255, 0, 0}));
  connect(TurbineBP.Cs, perteChargeK1.C1) annotation(
    Line(points = {{616.2, -230}, {640, -230}}, color = {255, 0, 0}));
  connect(EconomiseurMP.Cws2, CapteurDebitEauMP.C1) annotation(
    Line(points = {{466, -30}, {470, -30}, {470, 50.4}, {424, 50.4}}, color = {0, 0, 255}));
  connect(TurbineMP.MechPower, Alternateur.Wmec2) annotation(
    Line(points = {{360, -248}, {368, -248}, {368, -378}, {402, -378}}));
  connect(TurbineBP.MechPower, Alternateur.Wmec1) annotation(
    Line(points = {{618, -248}, {628, -248}, {628, -290}, {388, -290}, {388, -358}, {402, -358}}));
  connect(TurbineHP.MechPower, Alternateur.Wmec3) annotation(
    Line(points = {{40, -248}, {48, -248}, {48, -398}, {402, -398}}));
  connect(heatSource.C[1], BallonHP.Cex) annotation(
    Line(points = {{18, 68.3}, {18, 50}}, color = {191, 95, 0}));
  connect(heatSource1.C[1], BallonMP.Cex) annotation(
    Line(points = {{339, 68.3}, {339, 50}}, color = {191, 95, 0}));
  connect(heatSource2.C[1], BallonBP.Cex) annotation(
    Line(points = {{598, 64.3}, {598, 50}}, color = {191, 95, 0}));
  connect(Gain_2GasTurbine.y, Alternateur.Wmec5) annotation(
    Line(points = {{3, -438}, {402, -438}}));
  connect(CapteurDebitEauHP.C1, EconomiseurHP4.Cws2) annotation(
    Line(points = {{86.3, 26}, {86, 26}, {86, -30}}, smooth = Smooth.None));
  connect(PompeAlimMP.rpm_or_mpower, arretPomesMp.y) annotation(
    Line(points = {{814, -21}, {814, -26}, {904.1, -26}}, smooth = Smooth.None));
  connect(PompeAlimHP.rpm_or_mpower, arretPomesHP.y) annotation(
    Line(points = {{814, -61}, {814, -80}, {905.1, -80}}, smooth = Smooth.None));
  connect(PompeAlimBP.rpm_or_mpower, arretPomesBP.y) annotation(
    Line(points = {{752, -447}, {754, -447}, {754, -460}, {878, -460}, {878, -442}, {905.1, -442}}, smooth = Smooth.None));
  connect(SourceFumees.C, GasTurbine.Entree_air) annotation(
    Line(points = {{-495, -51}, {-471, -51}}, color = {0, 0, 0}, thickness = 1));
  connect(sourceCombustible.C, GasTurbine.Entree_combustible) annotation(
    Line(points = {{-385, 42}, {-367, 42}, {-367, 13}}, color = {0, 0, 0}));
  connect(sourceEau.C, GasTurbine.Entree_eau_combustion) annotation(
    Line(points = {{-445, 42}, {-445, 13}}, color = {0, 0, 255}));
  connect(sourceCombustible.IMassFlow, rampeQfuel.y) annotation(
    Line(points = {{-403, 51}, {-403, 74}, {-518, 74}}));
  connect(rampeIQair.y, SourceFumees.IMassFlow) annotation(
    Line(points = {{-520, -10}, {-520, -36}, {-517, -36}, {-517, -39.5}}));
  connect(Humidite.y, GasTurbine.Huminide) annotation(
    Line(points = {{-516.95, 33}, {-487, 33}, {-487, -12.6}, {-473.6, -12.6}}));
  connect(GasTurbine.Sortie_fumees, SurchauffeurHP3.Cfg1) annotation(
    Line(points = {{-341, -51}, {-290, -50}, {-304, -50}}, color = {0, 0, 0}, thickness = 1));
  connect(GasTurbine.PuissanceMeca, Gain_2GasTurbine.u) annotation(
    Line(points = {{-338.4, -76.6}, {-326, -76.6}, {-326, -438}, {-19, -438}}));
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-550, -460}, {950, 150}}, initialScale = 0.1)),
    experiment(StopTime = 2500, Tolerance = 0.001),
    experimentSetupOutput,
    Icon(graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100.0, -100.0}, {100.0, 100.0}}, radius = 25.0), Rectangle(lineColor = {128, 128, 128}, extent = {{-100.0, -100.0}, {100.0, 100.0}}, radius = 25.0), Polygon(origin = {8.0, 14.0}, lineColor = {78, 138, 73}, fillColor = {78, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-58.0, 46.0}, {42.0, -14.0}, {-58.0, -74.0}, {-58.0, 46.0}})}),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
    "));
end CombinedCycle_Load_100_50;