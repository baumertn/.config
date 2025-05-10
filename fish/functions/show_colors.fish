function show_colors
  for i in (seq 0 255)
   printf '\e[38;5;%sm%3d ' $i $i
   if test (math "$i % 16") -eq 15
           echo
       end
   end
   echo
end
