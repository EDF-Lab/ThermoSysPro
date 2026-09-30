within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestDynamicMultiFluidHeatExchangerShell_FlueGases
  extends TestDynamicMultiFluidHeatExchangerShell(
    redeclare package Medium_shell = Properties.Media.FlueGases,
    redeclare package Medium_pipe = Properties.Media.FlueGases,
    exchanger(
      P0=450000,
      h0=fill(3e6, 1),
      option_temperature=false,
      dynamicOnePhaseFlowShell(h(start=fill(3e6, 3)), hb(start=fill(3e6, 2))),
      DynamicOnePhaseFlowPipe(h(start=fill(3e6, 3)), hb(start=fill(3e6, 2)))),
    sourceShell(P0=450000, h0=3e6, option_temperature=false, X0={0.1,0.2,0.3,0.2,0.2}, C(h(start=3e6), h_vol_1(start=3e6))),
    sinkShell(P0=100000, h0=3e6, option_temperature=false, C(h(start=3e6), h_vol_2(start=3e6))),
    sourcePipe(P0=450000, h0=3e6, option_temperature=false, X0={0.1,0.2,0.3,0.2,0.2}, C(h(start=3e6), h_vol_1(start=3e6))),
    sinkPipe(P0=100000, h0=3e6, option_temperature=false, C(h(start=3e6), h_vol_2(start=3e6))));
end TestDynamicMultiFluidHeatExchangerShell_FlueGases;
