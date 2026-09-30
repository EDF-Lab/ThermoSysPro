within ThermoSysPro.Properties.Media;
package Functions
  function findSubstanceIndex
    input String substanceNames[:];
    input String aliases[:];
    output Integer index;
  algorithm
    index := 0;
    for i in 1:size(substanceNames, 1) loop
      for j in 1:size(aliases, 1) loop
        if substanceNames[i] == aliases[j] then
          index := i;
        end if;
      end for;
    end for;
  end findSubstanceIndex;
end Functions;
