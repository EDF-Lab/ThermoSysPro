within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestDynamicMultiFluidHeatExchanger_FlueGases
  extends TestDynamicMultiFluidHeatExchanger(
    redeclare package Medium_1 = Properties.Media.FlueGases,
    redeclare package Medium_2 = Properties.Media.FlueGases,
    exchanger(
      P0=450000,
      h0=fill(3e6, 1),
      option_temperature=false,
      DynamicOnePhaseFlowPipe_1(h(start=fill(3e6, 3)), hb(start=fill(3e6, 2))),
      DynamicOnePhaseFlowPipe_2(h(start=fill(3e6, 3)), hb(start=fill(3e6, 2)))),
    source1(P0=450000, h0=3e6, option_temperature=false, X0={0.1,0.2,0.3,0.2,0.2}, C(h(start=3e6), h_vol_1(start=3e6))),
    sink1(P0=100000, h0=3e6, option_temperature=false, C(h(start=3e6), h_vol_2(start=3e6))),
    source2(P0=450000, h0=3e6, option_temperature=false, X0={0.1,0.2,0.3,0.2,0.2}, C(h(start=3e6), h_vol_1(start=3e6))),
    sink2(P0=100000, h0=3e6, option_temperature=false, C(h(start=3e6), h_vol_2(start=3e6))));
end TestDynamicMultiFluidHeatExchanger_FlueGases;
