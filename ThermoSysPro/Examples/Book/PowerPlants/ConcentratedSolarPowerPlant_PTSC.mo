within ThermoSysPro.Examples.Book.PowerPlants;

model ConcentratedSolarPowerPlant_PTSC "Model of a concentrated solar power plant with PTSC"
  import ThermoSysPro;
  //parameter Real L1 = 500 "Longueur de la première chaine de capteurs";
  parameter Real L1 = 500 "Longueur de la première chaine de capteurs";
  parameter Integer Ns1 = 10 "Nombre de mailles de la première chaine de capteurs";
  parameter Real L2 = 80 "Longueur de la deuxième chaine de capteurs";
  parameter Integer Ns2 = 10 "Nombre de mailles de la deuxième échangeur";
  parameter Real L3 = 450 "Longueur de la première chaine de capteurs";
  parameter Integer Ns3 = 10 "Nombre de mailles de la première échangeur";
  //parameter Real L4 = 7.9254 "Longueur de la première chaine de capteurs";
  parameter Real L4 = 20 "Longueur de la première chaine de capteurs";
  parameter Integer Ns4 = 10 "Nombre de mailles de la première échangeur";
  parameter Real PompeA1(fixed = false, start = -997406144.0);
  parameter Real Pompe1A1(fixed = false, start = -52341772.0);
  parameter Real Pompe2A1(fixed = false, start = -6592032.5);
  parameter Real TurbineCst(fixed = false, start = 68055990272.0);
  parameter Real TurbineMpCst(fixed = false, start = 8363191808.0);
  parameter Real SourcePCaloporteurP0(fixed = false, start = 100066.1328125);
  parameter Real Re1SCondDes(fixed = false, start = 9.582132339477539);
  WaterSteam.HeatExchangers.DynamicOnePhaseFlowPipe TubeEcran_2(option_temperature = 2, L = L2, Ns = Ns2, T0 = {659.137, 670.3592222222, 681.5814444444, 687.5856666667, 691.8505555556, 694.7741111111, 696.3563333333, 697.6894444444, 698.2752222222, 698.861}, h0 = fill(650e3, Ns2), D = 0.04, hcCorr = 2, ntubes = 3, inertia = false, advection = false, P(start = {8136283.5, 8127545.318, 8118301.682, 8106530.773, 8094358.318, 8081382.773, 8068171.455, 8054724.364, 8041142.182, 8027492.455, 8013755, 8000000}), h(start = {2756570, 2911331.818, 3050076.364, 3108734.545, 3155061.818, 3176727.273, 3191588.182, 3199644.545, 3204399.091, 3207502.727, 3208020, 3208020}), hb(start = {2756568.75, 2899303.375, 3042038, 3096046.75, 3150055.5, 3169981.5, 3189907.5, 3197308.625, 3204709.75, 3207554.5, 3210399.25}), mu2(start = {1.94524e-05, 0.0001097262, 0.0002, 0.0002, 0.0002, 0.0002, 0.0002, 0.0002, 0.0002, 0.0002, 0.0002}), pro2(d(start = {43.2944, 520.6472, 998, 998, 998, 998, 998, 998, 998, 998, 998}))) annotation(
    Placement(transformation(extent = {{-31, 34}, {25, 78}}, rotation = 0)));
  Thermal.HeatTransfer.HeatExchangerWallCounterFlow Paroi2(cpw = 1000, steady_state = true, lambda = 26, L = L2, Ns = Ns2, D = 0.04, ntubes = 3, e = 0.003, Tp2(start = {699.6, 698.8182222222, 698.0364444444, 696.8216666667, 695.4625555556, 692.9541111111, 689.2963333333, 684.1416666667, 674.4963333333, 664.851}), Tp(start = {662.094, 672.5002222222, 682.9064444444, 688.471, 692.4216666667, 695.1303333333, 696.597, 697.833, 698.377, 698.921})) annotation(
    Placement(transformation(extent = {{-34, 54}, {26, 102}}, rotation = 0)));
  WaterSteam.PressureLosses.SingularPressureLoss PerteCharge_Huile_3(K = 1e-6, p_rho = 900, C1(h_vol(start = 462620.0)), C2(h_vol(start = 462620.0))) annotation(
    Placement(transformation(origin = {-134, 138.5}, extent = {{6, -9.5}, {-6, 9.5}}, rotation = 180)));
  InstrumentationAndControl.Blocks.Tables.Table1DTemps Tatm(Table = [0, 300; 1, 300]) annotation(
    Placement(transformation(extent = {{-322, 186}, {-306, 202}}, rotation = 0)));
  InstrumentationAndControl.Blocks.Tables.Table1DTemps Incidence(Table = [0, 0; 1, 0]) annotation(
    Placement(transformation(extent = {{-322, 146}, {-306, 162}}, rotation = 0)));
  Thermal.HeatTransfer.HeatExchangerWall Paroi3(cpw = 1000, steady_state = true, lambda = 26, L = L3, Ns = Ns3, D = 0.06, e = 0.006, Tp1(start = {540.2, 560.5396666667, 580.8094444444, 600.3286666667, 619.1036666667, 637.1525555556, 654.5126666667, 671.2563333333, 687.4784444444, 703.26}), Tp2(start = {543.606, 564.574, 584.7921111111, 604.2563333333, 622.9748888889, 640.9643333333, 658.264, 674.9442222222, 691.1018888889, 706.816}), Tp(start = {541.71, 562.7013333333, 582.9427777778, 602.4333333333, 621.1782222222, 639.195, 656.523, 673.2325555556, 689.4197777778, 705.165})) annotation(
    Placement(transformation(extent = {{-105, 134}, {-45, 182}}, rotation = 0)));
  ThermoSysPro.Solar.Collectors.SolarCollector SolarCollector1(EpsGlass = 0.86, Gamma = 0.83, h = 3.06, AlphaGlass = 0.0302, RimAngle = 70, TauN = 0.95, AlphaN = 0.96, EpsTube = 0.14, R = 0.93, Lambda = 2.891407518e-2, f = 1.78518, AReflector(fixed = false, start = 2750), DGlass = 0.115, L = L3, Ns = Ns3, DTube = 0.07, e = 1.e-3, Twall(start = {543.606, 564.574, 584.7921111111, 604.2563333333, 622.9748888889, 640.9643333333, 658.264, 674.9442222222, 691.1018888889, 706.816}), Tglass(start = {364.716, 370.7472222222, 376.8543333333, 383.0026666667, 389.1588888889, 395.2974444444, 401.401, 407.4662222222, 413.5046666667, 419.528})) annotation(
    Placement(transformation(extent = {{-108, 166}, {-43, 200}}, rotation = 0)));
  Solar.HeatExchangers.DynamicOnePhaseFlowPipe_Oil TubeEcran_3(option_temperature = 2, L = L3, Ns = Ns3, T0 = {539.521, 700, 700, 700, 700, 700, 700, 700, 700, 700}, h0 = fill(800e3, Ns3), advection = false, dpfCorr = 0.4, hcCorr = 2, D = 0.06, h(start = {463696.125, 502475.8181818182, 541916.6363636364, 580925.5454545455, 619483.9090909092, 657578.7272727273, 695194.3636363635, 732317.6363636364, 768937.7272727273, 805038.8181818181, 840608.3636363635, 870908})) annotation(
    Placement(transformation(extent = {{-103, 117}, {-47, 161}}, rotation = 0)));
  WaterSteam.PressureLosses.SingularPressureLoss PerteCharge_Huile_4(K = 1e-6, p_rho = 650, C2(h_vol(start = 870908.0))) annotation(
    Placement(transformation(origin = {-5, 139}, extent = {{6, -10}, {-6, 10}}, rotation = 180)));
  Solar.HeatExchangers.DynamicOnePhaseFlowPipe_Oil TubeEcran_22(option_temperature = 2, Ns = Ns2, T0 = {698.976, 699.4311111111, 699.8862222222, 700, 700, 700, 700, 700, 700, 700}, h0 = fill(800e3, Ns2), L = L2, D = 0.04, advection = false, hcCorr = 2, dpfCorr = 0.4, ntubes = 3, Tp(start = {699.8692016602, 699.3633694119, 698.8575371636, 697.7081705729, 696.3442925347, 693.8255750868, 690.1520182292, 684.9737006293, 675.281100803, 665.5885009766}), h(start = {871999.6875, 870918.2215909092, 869806.2727272727, 868541.9090909091, 866565.3636363636, 863164.4545454546, 856860.9090909092, 847654.7272727272, 828393.6363636365, 804105.0909090909, 800057, 800057})) annotation(
    Placement(transformation(extent = {{24, 122}, {-33, 78}}, rotation = 0)));
  Thermal.HeatTransfer.HeatExchangerWallCounterFlow Paroi1(cpw = 1000, steady_state = true, lambda = 26, L = L1, Ns = Ns1, D = 0.04, ntubes = 3, e = 0.003, Tp1(start = {532.912, 534.2464444444, 536.0426666667, 538.4613333333, 541.7268888889, 546.1462222222, 552.1553333333, 560.388, 571.5023333333, 574.577}), Tp2(start = {589.9, 573.1207777778, 561.4175555556, 552.885, 546.6725555556, 542.1102222222, 538.7433333333, 536.2505555556, 534.4001111111, 533.026}), Tp(start = {532.971, 534.3258888889, 536.1502222222, 538.6076666667, 541.9252222222, 546.4184444444, 552.533, 560.9211111111, 572.3397777778, 581.427})) annotation(
    Placement(transformation(extent = {{-174, 54}, {-114, 102}}, rotation = 0)));
  WaterSteam.HeatExchangers.DynamicTwoPhaseFlowPipe TubeEcran_1(option_temperature = 2, L = L1, Ns = Ns1, T0 = fill(300, Ns1), h0 = fill(650e3, Ns1), D = 0.04, ntubes = 3, inertia = false, advection = false, P(start = {8716030, 8675988.182, 8635855.455, 8595597.273, 8555192.727, 8514570, 8473668.182, 8432370, 8390529.091, 8347889.091, 8300660, 8135653}), Tp1(start = {533.7798461914, 534.8800184462, 536.4120483398, 538.5472208659, 541.5267876519, 545.6940171984, 551.5440266927, 559.8079833984, 571.5279812283, 574.6042480469}), h(start = {1130270, 1135216.364, 1141697.273, 1150208.182, 1161420.909, 1176230.909, 1195898.182, 1222220, 1257891.818, 1307722.727, 1460189.091, 2756578.25}), hb(start = {1135107.75, 1139313.25, 1145080.25, 1153001.5, 1163909.875, 1178988, 1199949.625, 1229353.25, 1271222.625, 1333245.5, 1704848.25})) annotation(
    Placement(transformation(extent = {{-171, 34}, {-115, 78}}, rotation = 0)));
  Solar.HeatExchangers.DynamicOnePhaseFlowPipe_Oil TubeEcran_11(option_temperature = 2, L = L1, Ns = Ns1, T0 = {587.815, 550, 550, 550, 550, 550, 550, 550, 550, 550}, h0 = fill(650e3, Ns1), D = 0.04, advection = false, hcCorr = 2, dpfCorr = 0.4, ntubes = 3, Tp(start = {587.951965332, 573.1594984266, 560.8732842339, 552.2766520182, 546.2064887153, 541.8887532552, 538.8043823242, 536.5955132378, 535.0111287435, 533.8737182617}), h(start = {801122.25, 587728.1818181819, 549725.7272727273, 525943.5454545454, 508532.0909090909, 495588.3636363636, 485872.9090909091, 478535.1818181819, 472969.9090909091, 468735.6363636364, 465508, 464248})) annotation(
    Placement(transformation(extent = {{-116, 122}, {-173, 78}}, rotation = 0)));
  ThermoSysPro.WaterSteam.Junctions.SteamDryer Secheur(proe(x(start = 0.273553))) annotation(
    Placement(transformation(extent = {{-86, 39}, {-62, 63}}, rotation = 0)));
  WaterSteam.HeatExchangers.SimpleDynamicCondenser Condenseur(A = 5, Kvl = 100, e = 0.0005, L = 3.5, Vf0 = 0.15, ntubes = 300, steady_state = false, V = 30, P0 = 5000, Cv(Q(start = 1.13)), Pfond(start = 5000.53), proe(d(start = 995.533))) annotation(
    Placement(transformation(extent = {{116, -51}, {156, -11}}, rotation = 0)));
  WaterSteam.BoundaryConditions.SinkP puitsPCaloporteur(mode = 0, P0 = 1e5, option_temperature = 2) annotation(
    Placement(transformation(extent = {{178, -48}, {206, -22}}, rotation = 0)));
  WaterSteam.PressureLosses.SingularPressureLoss PerteChargeCondPompe(K = 1e-6, C2(h_vol(start = 137765.0)), Pm(start = 5000.53)) annotation(
    Placement(transformation(origin = {117, -82.5}, extent = {{-6, -9.5}, {6, 9.5}}, rotation = 180)));
  WaterSteam.PressureLosses.InvSingularPressureLoss Connection_HQ_Secheur_Ballon(Q(start = 1)) annotation(
    Placement(transformation(origin = {-73, -15}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  WaterSteam.Machines.StaticCentrifugalPump Pompe(Pm(fixed = false, start = 3502560.0), a1 = PompeA1, hn(start = 716.167), a3 = 2000, b1 = -3500, b2 = 510, Q(fixed = true, start = 1.13), C2(h_vol(start = 150161.0)), Qv(start = 0.00113454), h(start = 143963.0)) annotation(
    Placement(transformation(extent = {{84, -91}, {64, -71}}, rotation = 0)));
  WaterSteam.Volumes.VolumeC Ballon(V = 1, h0 = 3e5, h(start = 1125640.0), P0 = 7000000, dynamic_mass_balance = true, P(start = 7000000)) annotation(
    Placement(transformation(extent = {{-63, -91}, {-83, -71}}, rotation = 0)));
  WaterSteam.PressureLosses.ControlValve ControlValveBallon(Cvmax(fixed = true) = 300, C2(P(fixed = false, start = 70e5)), Pm(start = 7000060.0)) annotation(
    Placement(transformation(origin = {-30, -75}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  WaterSteam.PressureLosses.ControlValve ControlValveBallon1(Cvmax = 10, C1(P(start = 10618800.0), h_vol(start = 1127430.0)), C2(h_vol(start = 1127430.0)), Pm(start = 9676220.0)) annotation(
    Placement(transformation(origin = {-212, -75}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  WaterSteam.BoundaryConditions.SourceP sourcePCaloporteur(option_temperature = 2, h0 = 63.03e3, P0 = SourcePCaloporteurP0, Q(fixed = true, start = 14.9263)) annotation(
    Placement(transformation(extent = {{66, -49}, {94, -22}}, rotation = 0)));
  WaterSteam.PressureLosses.SingularPressureLoss PerteChargeCondPompe1(K = 1e-6) annotation(
    Placement(transformation(origin = {171, -35}, extent = {{6, -10}, {-6, 10}}, rotation = 180)));
  WaterSteam.PressureLosses.SingularPressureLoss PerteChargeCondPompe2(K = 1e-6, pro(d(start = 999.099))) annotation(
    Placement(transformation(origin = {101, -36}, extent = {{6, -10}, {-6, 10}}, rotation = 180)));
  InstrumentationAndControl.Blocks.Sources.Constante Ouv(k = 0.5) annotation(
    Placement(transformation(extent = {{-48, -62}, {-38, -52}}, rotation = 0)));
  InstrumentationAndControl.Blocks.Sources.Constante Ouv1(k = 0.5) annotation(
    Placement(transformation(extent = {{-231, -62}, {-221, -52}}, rotation = 0)));
  WaterSteam.Machines.StaticCentrifugalPump Pompe1(Pm(fixed = false, start = 8881936.0), hn(start = 466.292), a3 = 2000, b2 = 510, b1 = -3500, a1 = Pompe1A1, Q(fixed = false, start = 0.65), C2(P(fixed = false, start = 75e5), h_vol(start = 1132880.125)), C1(P(fixed = true, start = 70e5), h_vol(start = 1125640.0)), Qv(start = 0.00521975), h(start = 1126540.0)) annotation(
    Placement(transformation(extent = {{-158, -91}, {-178, -71}}, rotation = 0)));
  WaterSteam.PressureLosses.SingularPressureLoss PerteChargeCondPompe3(K = 1e-6, C2(h_vol(start = 1131070.75)), Pm(start = 7000000.0)) annotation(
    Placement(transformation(origin = {-120, -81}, extent = {{-6, -10}, {6, 10}}, rotation = 180)));
  WaterSteam.Machines.StodolaTurbine Turbine(W_fric = 1, Cst = TurbineCst, Qmax = 0.001, eta_is_min = 0.80, rhos(start = 10), eta_is_nom = 0.92, Pe(fixed = true, start = 8000000), Ps(fixed = false, start = 1800000), pros(d(start = 8.36949))) annotation(
    Placement(transformation(extent = {{47, 72}, {73, 40}}, rotation = 0)));
  WaterSteam.Machines.Generator Alternateur annotation(
    Placement(transformation(extent = {{168, 90}, {198, 130}}, rotation = 0)));
  Thermal.HeatTransfer.HeatExchangerWallCounterFlow Paroi4(cpw = 1000, steady_state = true, lambda = 26, D = 0.04, L = L4, Ns = Ns4, ntubes = 3, e = 0.003, Tp1(start = {532.06, 532.1048888889, 532.1497777778, 532.1946666667, 532.2395555556, 532.286, 532.334, 532.382, 532.43, 532.478}), Tp2(start = {533.3, 533.1064444444, 532.9128888889, 532.7193333333, 532.5257777778, 532.4054444444, 532.3583333333, 532.3112222222, 532.2641111111, 532.217}), Tp(start = {532.141, 532.1872222222, 532.2334444444, 532.2796666667, 532.3258888889, 532.3735555556, 532.4226666667, 532.4717777778, 532.5208888889, 532.57})) annotation(
    Placement(transformation(origin = {-269, -12}, extent = {{-24, -30}, {24, 30}}, rotation = 90)));
  WaterSteam.HeatExchangers.DynamicTwoPhaseFlowPipe TubeEcran_4(option_temperature = 2, D = 0.04, L = L4, Ns = Ns4, T0 = fill(300, Ns4), h0 = fill(650e3, Ns4), ntubes = 3, inertia = false, advection = false, P(start = {8751668, 8743508.727, 8735349.455, 8728830, 8727230, 8725630, 8724030, 8722430, 8720830, 8724093.545, 8728978.273, 8733863}), Tp1(start = {533.1015625, 533.1368815104, 533.1722005208, 533.2075195312, 533.2428385417, 533.2794731988, 533.3174235026, 533.3553738064, 533.3933241102, 533.4312744141}), h(start = {1128519.5, 1128443.318, 1128367.136, 1128396.364, 1128741.818, 1129087.273, 1129443.636, 1129810.909, 1130178.182, 1130667.909, 1131198.455, 1131729}), hb(start = {1132880.125, 1133086.975, 1133293.825, 1133500.675, 1133717.875, 1133940.25, 1134162.625, 1134390.562, 1134629.625, 1134868.688, 1135107.75})) annotation(
    Placement(transformation(origin = {-245.5, -11.5}, extent = {{-23.5, -23.5}, {23.5, 23.5}}, rotation = 90)));
  Solar.HeatExchangers.DynamicOnePhaseFlowPipe_Oil TubeEcran_44(option_temperature = 2, L = L4, Ns = Ns4, T0 = {532.656, 536.5102222222, 540.3644444444, 544.2186666667, 548.0728888889, 550, 550, 550, 550, 550}, h0 = fill(650e3, Ns4), advection = false, D(fixed = true) = 0.04, C2(P(fixed = false, start = 16.99e5), Q(fixed = false, start = 2)), hcCorr = 2, dpfCorr = 0.4, ntubes = 3, Tp(start = {533.5760498047, 533.5358479818, 533.4956461589, 533.4554443359, 533.415242513, 533.3764444987, 533.339050293, 533.3016560872, 533.2642618815, 533.2268676758}), h(start = {465547.78125, 464864.9517045454, 464182.1221590909, 463620.7272727273, 463423.6363636364, 463226.5454545455, 463035.6363636364, 462850.9090909091, 462666.1818181818, 462620, 462620, 462620})) annotation(
    Placement(transformation(origin = {-293, -12}, extent = {{23, 24}, {-23, -24}}, rotation = 90)));
  WaterSteam.Machines.StaticCentrifugalPump Pompe2(Pm(fixed = false, start = 2022597.75), b2 = 510, b1 = -3500, hn(start = 350), adiabatic_compression = true, C1(P(fixed = false, start = 17e5), h_vol(start = 462620.0)), a3(fixed = true) = 500, C2(P(fixed = false, start = 24.5146e5)), p_rho = 900, Q(fixed = true, start = 7.2), a1 = Pompe2A1) annotation(
    Placement(transformation(extent = {{-184, 129}, {-164, 149}}, rotation = 0)));
  WaterSteam.PressureLosses.SingularPressureLoss PerteCharge_Huile_2(K = 1e-6, p_rho = 900, C2(h_vol(start = 464735.1875))) annotation(
    Placement(transformation(origin = {-212, 138.5}, extent = {{6, -9.5}, {-6, 9.5}}, rotation = 180)));
  WaterSteam.PressureLosses.SingularPressureLoss PerteCharge_Huile_1(K = 1e-6, p_rho = 900) annotation(
    Placement(transformation(origin = {-286, 138.5}, extent = {{6, -9.5}, {-6, 9.5}}, rotation = 180)));
  WaterSteam.Machines.StodolaTurbine TurbineMp(W_fric = 1, Cst = TurbineMpCst, Qmax = 0.001, eta_is_min = 0.80, rhos(start = 10), eta_is_nom = 0.94, Pe(fixed = true, start = 1800000), Ps(fixed = false, start = 5000), pros(d(start = 0.0434309)), xm(start = 0.908482)) annotation(
    Placement(transformation(extent = {{105, 72}, {131, 40}}, rotation = 0)));
  WaterSteam.Volumes.Tank Tank(p_rho = 895, A = 0.1, z0 = 1, h0 = 423600, steady_state = true, h(start = 462620.0), rho(start = 895), Patm = 1670000, P(start = 1699000)) annotation(
    Placement(transformation(origin = {-248, 142}, extent = {{6, 6}, {-6, -6}}, rotation = 180)));
  WaterSteam.Volumes.VolumeA VolumeMP(V = 1, rho(start = 10), h0 = 2.4e6, h(start = 2868560.0), P0 = 1800000, dynamic_mass_balance = true, P(start = 1800000), Cs2(Q(start = 0.255955))) annotation(
    Placement(transformation(extent = {{84, 50}, {94, 62}}, rotation = 0)));
  WaterSteam.Volumes.VolumeA VolumeCond(V = 1, rho(start = 10), h(start = 1837610.0), h0 = 2.1e6, P0 = 5000, dynamic_mass_balance = false, P(start = 5000)) annotation(
    Placement(transformation(extent = {{141, 24}, {130, 34}}, rotation = 0)));
  WaterSteam.HeatExchangers.NTUWaterHeating Re_1(KPurge = 10, SPurge = 0.3, Se(h(fixed = true, start = 600e3)), SCondDes = Re1SCondDes, HDesF(start = 583561.0), HeiF(start = 150619.0), Hep(start = 884611.0), SDes(start = 0.932441), h(start = 882589.0), lambdaE = 1, KCond = 500) annotation(
    Placement(transformation(extent = {{42, -106}, {0, -56}}, rotation = 0)));
  WaterSteam.PressureLosses.SingularPressureLoss Dp_Re_1(rho(start = 10), h(start = 2400e3), Q(start = 0.1), K = 1e-4, Pm(start = 1800000)) annotation(
    Placement(transformation(origin = {31.5, -13.5}, extent = {{5.5, -5.5}, {-5.5, 5.5}}, rotation = 90)));
  WaterSteam.PressureLosses.InvSingularPressureLoss invSingularPressureLoss annotation(
    Placement(transformation(extent = {{108, -106}, {122, -90}}, rotation = 0)));
  WaterSteam.PressureLosses.SingularPressureLoss Dp_Cond_2(K = 1e-4, rho(start = 10), Q(start = 0.35), Pm(start = 5000.53), h(start = 2100e3)) annotation(
    Placement(transformation(origin = {135.5, 8.5}, extent = {{5.5, -5.5}, {-5.5, 5.5}}, rotation = 90)));
  InstrumentationAndControl.Blocks.Tables.Table1DTemps Rayonnement(Table = [0, 700; 200, 2; 1200, 2; 1800, 2; 2400, 0.1; 3000, 0.1; 3600, 0.1; 4200, 327; 4800, 287; 5400, 176; 6000, 410; 6600, 299; 7200, 26; 7800, 168; 8400, 485; 9000, 482; 9600, 664; 10200, 344; 10800, 684; 11400, 564; 12000, 460; 12600, 560; 13200, 611; 13800, 557; 14400, 682; 15000, 785; 15600, 321; 16200, 850; 16800, 330; 17400, 619; 18000, 480; 18600, 192; 19200, 750; 19800, 650; 20400, 450; 21000, 350; 21600, 763; 22200, 455; 22800, 290; 23400, 494; 24000, 800; 24600, 565; 25200, 320; 25800, 110; 26400, 479; 27000, 263; 27600, 747; 28200, 805; 28800, 576; 29400, 550; 30000, 470; 30600, 395; 31200, 315; 31800, 657; 32400, 670; 33000, 381; 33600, 209; 34200, 457; 34800, 320; 35400, 13; 36000, 0.1; 36600, 0.1; 37200, 0.1; 37800, 0.1; 38400, 0.1; 39000, 0.1; 39600, 0.1; 40200, 0.1; 40800, 0; 41400, 0; 42000, 0; 42600, 0; 43200, 0; 43800, 0]) annotation(
    Placement(transformation(extent = {{-322, 166}, {-306, 182}}, rotation = 0)));
  WaterSteam.Junctions.MassFlowMultiplier massFlowMultiplier(alpha = 3, P(start = 2300000)) annotation(
    Placement(transformation(extent = {{21, 128}, {37, 150}})));
  WaterSteam.Junctions.MassFlowMultiplier massFlowMultiplier2(alpha = 1/3, P(start = 2400000), h(start = 464735.1875)) annotation(
    Placement(transformation(extent = {{-7.75, -9.75}, {7.75, 9.75}}, rotation = 0, origin = {-158.25, 139.75})));
equation

equation
  connect(TubeEcran_2.CTh, Paroi2.WT1) annotation(
    Line(points = {{-3, 62.6}, {-4, 64}, {-4, 73.2}}, color = {191, 95, 0}));
  connect(SolarCollector1.ITemperature, Paroi3.WT2) annotation(
    Line(points = {{-74.3026, 166.992}, {-75, 166.992}, {-75, 162.8}}, color = {191, 95, 0}));
  connect(Incidence.y, SolarCollector1.IncidenceAngle) annotation(
    Line(points = {{-305.2, 154}, {-262, 154}, {-262, 182}, {-106.289, 182}, {-106.289, 183}}));
  connect(TubeEcran_3.CTh, Paroi3.WT1) annotation(
    Line(points = {{-75, 145.6}, {-75, 153.2}}, color = {191, 95, 0}));
  connect(Tatm.y, SolarCollector1.AtmTemp) annotation(
    Line(points = {{-305.2, 194}, {-282, 194}, {-282, 197.167}, {-106.289, 197.167}}));
  connect(PerteCharge_Huile_3.C2, TubeEcran_3.C1) annotation(
    Line(points = {{-128, 138.5}, {-102, 138.5}, {-102, 140}, {-103, 139}}, color = {0, 127, 0}, thickness = 0.5));
  connect(TubeEcran_3.C2, PerteCharge_Huile_4.C1) annotation(
    Line(points = {{-47, 139}, {-11, 139}}, color = {0, 127, 0}, thickness = 0.5));
  connect(Paroi2.WT2, TubeEcran_22.CTh) annotation(
    Line(points = {{-4, 82.8}, {-4, 93.4}, {-4.5, 93.4}}, color = {191, 95, 0}));
  connect(TubeEcran_1.CTh, Paroi1.WT1) annotation(
    Line(points = {{-143, 62.6}, {-144, 64}, {-144, 73.2}}, color = {191, 95, 0}));
  connect(Paroi1.WT2, TubeEcran_11.CTh) annotation(
    Line(points = {{-144, 82.8}, {-144, 93.4}, {-144.5, 93.4}}, color = {191, 95, 0}));
  connect(TubeEcran_11.C1, TubeEcran_22.C2) annotation(
    Line(points = {{-116, 100}, {-33, 100}}, color = {0, 127, 0}, thickness = 0.5));
  connect(TubeEcran_1.C2, Secheur.Cev) annotation(
    Line(points = {{-115, 56}, {-85.88, 56}, {-85.88, 55.8}}, color = {255, 0, 0}, thickness = 0.5));
  connect(Secheur.Csv, TubeEcran_2.C1) annotation(
    Line(points = {{-62.12, 55.8}, {-60, 55.8}, {-60, 56}, {-31, 56}}, color = {255, 0, 0}, thickness = 0.5));
  connect(Pompe.C1, PerteChargeCondPompe.C2) annotation(
    Line(points = {{84, -81}, {84, -82}, {111, -82}, {111, -82.5}}, color = {0, 0, 255}, thickness = 0.5));
  connect(Ballon.Ce1, ControlValveBallon.C2) annotation(
    Line(points = {{-63, -81}, {-40, -81}}, color = {0, 0, 255}, thickness = 0.5));
  connect(Secheur.Csl, Connection_HQ_Secheur_Ballon.C1) annotation(
    Line(points = {{-73.88, 39}, {-73.88, -5}, {-73, -5}}, color = {0, 0, 255}, thickness = 0.5));
  connect(Connection_HQ_Secheur_Ballon.C2, Ballon.Ce2) annotation(
    Line(points = {{-73, -25}, {-73, -72}}, color = {0, 0, 255}, thickness = 0.5));
  connect(sourcePCaloporteur.C, PerteChargeCondPompe2.C1) annotation(
    Line(points = {{94, -35.5}, {94, -36}, {95, -36}}, color = {0, 0, 255}));
  connect(PerteChargeCondPompe1.C2, puitsPCaloporteur.C) annotation(
    Line(points = {{177, -35}, {178, -36}, {178, -35}}, color = {0, 0, 255}));
  connect(Pompe1.C2, ControlValveBallon1.C1) annotation(
    Line(points = {{-178, -81}, {-202, -81}}, color = {0, 0, 255}, thickness = 0.5));
  connect(PerteChargeCondPompe3.C1, Ballon.Cs) annotation(
    Line(points = {{-114, -81}, {-83, -81}}, color = {0, 0, 255}, thickness = 0.5));
  connect(Ouv1.y, ControlValveBallon1.Ouv) annotation(
    Line(points = {{-220.5, -57}, {-212, -57}, {-212, -64}}));
  connect(Ouv.y, ControlValveBallon.Ouv) annotation(
    Line(points = {{-37.5, -57}, {-30, -57}, {-30, -64}}));
  connect(PerteChargeCondPompe2.C2, Condenseur.Cee) annotation(
    Line(points = {{107, -36}, {109.25, -36}, {109.25, -35.4}, {116, -35.4}}, color = {0, 0, 255}));
  connect(Condenseur.Cse, PerteChargeCondPompe1.C1) annotation(
    Line(points = {{156, -35}, {160, -34}, {160, -35}, {165, -35}}, color = {0, 0, 255}));
  connect(Condenseur.Cl, PerteChargeCondPompe.C1) annotation(
    Line(points = {{136.4, -51}, {136.4, -82.5}, {123, -82.5}}, color = {0, 0, 255}, thickness = 0.5));
  connect(PerteChargeCondPompe3.C2, Pompe1.C1) annotation(
    Line(points = {{-126, -81}, {-158, -81}}, color = {0, 0, 255}, thickness = 0.5));
  connect(Turbine.MechPower, Alternateur.Wmec5) annotation(
    Line(points = {{74.3, 70.4}, {76, 70.4}, {76, 94}, {168, 94}}));
  connect(TubeEcran_2.C2, Turbine.Ce) annotation(
    Line(points = {{25, 56}, {46.87, 56}}, color = {255, 0, 0}, thickness = 0.5));
  connect(TubeEcran_4.CTh, Paroi4.WT1) annotation(
    Line(points = {{-252.55, -11.5}, {-257, -11.5}, {-257, -12}, {-263, -12}}, color = {191, 95, 0}));
  connect(Paroi4.WT2, TubeEcran_44.CTh) annotation(
    Line(points = {{-275, -12}, {-285.8, -12}, {-285.8, -12}}, color = {191, 95, 0}));
  connect(ControlValveBallon1.C2, TubeEcran_4.C1) annotation(
    Line(points = {{-222, -81}, {-245.5, -81}, {-245.5, -35}}, color = {0, 0, 255}, thickness = 0.5));
  connect(TubeEcran_4.C2, TubeEcran_1.C1) annotation(
    Line(points = {{-245.5, 12}, {-245.5, 56}, {-171, 56}}, color = {0, 0, 255}, thickness = 0.5));
  connect(TubeEcran_11.C2, TubeEcran_44.C1) annotation(
    Line(points = {{-173, 100}, {-293, 100}, {-293, 11}}, color = {0, 127, 0}, thickness = 0.5));
  connect(PerteCharge_Huile_2.C2, Pompe2.C1) annotation(
    Line(points = {{-206, 138.5}, {-184, 138.5}, {-184, 139}}, color = {0, 127, 0}, thickness = 0.5));
  connect(Tank.Cs2, PerteCharge_Huile_2.C1) annotation(
    Line(points = {{-242, 138.4}, {-230, 138.4}, {-230, 138.5}, {-218, 138.5}}, color = {0, 127, 0}, thickness = 0.5));
  connect(PerteCharge_Huile_1.C2, Tank.Ce2) annotation(
    Line(points = {{-280, 138.5}, {-268, 138.5}, {-268, 138.4}, {-254, 138.4}}, color = {0, 127, 0}, thickness = 0.5));
  connect(Turbine.Cs, VolumeMP.Ce1) annotation(
    Line(points = {{73.13, 56}, {84, 56}}, color = {255, 0, 0}, thickness = 0.5));
  connect(VolumeMP.Cs1, TurbineMp.Ce) annotation(
    Line(points = {{94, 56}, {104.87, 56}}, color = {255, 0, 0}, thickness = 0.5));
  connect(TurbineMp.MechPower, Alternateur.Wmec4) annotation(
    Line(points = {{132.3, 70.4}, {142, 70.4}, {142, 102}, {168, 102}}));
  connect(TurbineMp.Cs, VolumeCond.Ce2) annotation(
    Line(points = {{131.13, 56}, {135.5, 56}, {135.5, 33.9}}, color = {255, 0, 0}, thickness = 0.5));
  connect(Re_1.Ee, Pompe.C2) annotation(
    Line(points = {{42.42, -81}, {64, -81}}, thickness = 0.5));
  connect(VolumeMP.Cs2, Dp_Re_1.C1) annotation(
    Line(points = {{89, 50}, {90, 50}, {90, 22}, {31.5, 22}, {31.5, -8}}, color = {255, 0, 0}, thickness = 0.5));
  connect(Dp_Re_1.C2, Re_1.Ev) annotation(
    Line(points = {{31.5, -19}, {31.5, -36}, {8.4, -36}, {8.4, -73}}, color = {255, 0, 0}, thickness = 0.5));
  connect(ControlValveBallon.C1, Re_1.Se) annotation(
    Line(points = {{-20, -81}, {0, -81}}, thickness = 0.5));
  connect(Re_1.Sp, invSingularPressureLoss.C1) annotation(
    Line(points = {{33.6, -89.25}, {33.6, -98}, {108, -98}}, color = {0, 0, 255}, thickness = 0.5));
  connect(invSingularPressureLoss.C2, VolumeCond.Ce1) annotation(
    Line(points = {{122, -98}, {202, -98}, {202, 29}, {141, 29}}, color = {0, 0, 255}, thickness = 0.5));
  connect(Dp_Cond_2.C1, VolumeCond.Cs2) annotation(
    Line(points = {{135.5, 14}, {135.5, 24}}, color = {255, 0, 0}, thickness = 0.5));
  connect(Condenseur.Cv, Dp_Cond_2.C2) annotation(
    Line(points = {{136, -11}, {136, 3}, {135.5, 3}}, color = {255, 0, 0}, thickness = 0.5));
  connect(PerteCharge_Huile_4.C2, massFlowMultiplier.Ce) annotation(
    Line(points = {{1, 139}, {21, 139}}, color = {0, 140, 72}, thickness = 0.5));
  connect(massFlowMultiplier.Cs, TubeEcran_22.C1) annotation(
    Line(points = {{37, 139}, {63, 139}, {63, 100}, {24, 100}}, color = {0, 140, 72}, thickness = 0.5));
  connect(Pompe2.C2, massFlowMultiplier2.Ce) annotation(
    Line(points = {{-164, 139}, {-166, 139}, {-166, 139.75}}, color = {0, 140, 72}, thickness = 0.5));
  connect(massFlowMultiplier2.Cs, PerteCharge_Huile_3.C1) annotation(
    Line(points = {{-150.5, 139.75}, {-140, 139.75}, {-140, 138.5}}, color = {0, 140, 72}, thickness = 0.5));
  connect(PerteCharge_Huile_1.C1, TubeEcran_44.C2) annotation(
    Line(points = {{-292, 138.5}, {-319, 138.5}, {-319, -80}, {-293, -80}, {-293, -35}}, color = {0, 127, 0}, thickness = 0.5));
  connect(Rayonnement.y, SolarCollector1.ISun) annotation(
    Line(points = {{-305.2, 174}, {-280, 174}, {-280, 190.083}, {-106.289, 190.083}}, color = {0, 0, 255}));
  annotation(
    Window(x = 0.43, y = 0, width = 0.57, height = 0.63),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-320, -100}, {200, 200}}, grid = {2, 2}, initialScale = 0.1), graphics = {Text(extent = {{-237, -8}, {-217, -18}}, lineColor = {0, 0, 255}, lineThickness = 0.5, textString = "Eco"), Text(extent = {{-164, 48}, {-126, 34}}, lineColor = {0, 0, 255}, lineThickness = 0.5, textString = "Evaporator"), Text(extent = {{-23, 49}, {21, 33}}, lineColor = {0, 0, 255}, lineThickness = 0.5, textString = "Super-heater"), Text(extent = {{151, -53}, {194, -68}}, lineColor = {0, 0, 255}, lineThickness = 0.5, textString = "Condenser"), Text(extent = {{-115, 215}, {-37, 197}}, lineColor = {0, 0, 255}, lineThickness = 0.5, textString = "Parabolic solar receiver")}),
    experiment(StopTime = 40000),
    Documentation(revisions = "
Author  

Baligh El Hefni  

    ", info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
This is the dynamic model of a 1 MWe concentrated solar power plant with a parabolic trough collector.   
It is documented in a conference paper and in Sect. 6.7 of the ThermoSysPro book.   
The results reported in the ThermoSysPro book were computed using Dymola.  
    "),
    Icon(graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100.0, -100.0}, {100.0, 100.0}}, radius = 25.0), Rectangle(lineColor = {128, 128, 128}, extent = {{-100.0, -100.0}, {100.0, 100.0}}, radius = 25.0), Polygon(origin = {8.0, 14.0}, lineColor = {78, 138, 73}, fillColor = {78, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-58.0, 46.0}, {42.0, -14.0}, {-58.0, -74.0}, {-58.0, 46.0}})}));
end ConcentratedSolarPowerPlant_PTSC;
