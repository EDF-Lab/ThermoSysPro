within ThermoSysPro.Properties.Media.PartialSubCMedium;
partial function partialPhasesSeparation
  input Real SubC[:] "Total Species Concentrations";
  output C_BiPhase C_record;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                          Ellipse(
          extent={{-60,60},{60,-60}},
          lineColor={0,0,255},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{60,0},{58,14},{54,26},{48,36},{38,46},{26,54},{14,58},{0,60},
              {0,0},{60,0}},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-60,0},{-58,14},{-54,26},{-48,36},{-38,46},{-26,54},{-14,58},
              {0,60},{0,0},{-60,0}},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-42,28},{-26,12}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-18,48},{-6,36}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-4,24},{16,4}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{26,34},{42,18}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{24,-12},{40,-28}},
          lineColor={28,108,200},
          fillColor={85,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-40,-22},{-24,-38}},
          lineColor={28,108,200},
          fillColor={85,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{10,-36},{22,-48}},
          lineColor={28,108,200},
          fillColor={85,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-20,-4},{2,-26}},
          lineColor={28,108,200},
          fillColor={85,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end partialPhasesSeparation;
