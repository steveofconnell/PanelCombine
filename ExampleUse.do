
cd ~/Dropbox/Quickdrop/PanelCombine/
include "https://raw.githubusercontent.com/steveofconnell/PanelCombine/master/PanelCombine.do"

sysuse auto, clear
local count = 1
foreach sample in "" "if foreign==1" "if foreign==0" {
eststo clear
foreach set in "mpg" "mpg trunk" "mpg trunk headroom" "mpg trunk headroom length" {
eststo: regress price `set' `sample'
estadd ysumm
}
esttab _all using Panel`count'.tex, style(tex) keep(mpg)  ///
stats(N r2 ymean ysd, fmt( %9.0g %9.2f  %9.2f %9.2f) ///
labels("\$N$" "\$R^2$" "Mean of outcome" "St. dev. of outcome")) label  ///
drop() replace se r2 star( * .1 ** .05 *** .01) b(%9.5f) se(%9.5f) ///
mtitles("\makecell{Base\\ (1)}" "\makecell{+trunk\\(2)}" "\makecell{+headroom\\(3)}" "\makecell{+length\\(4)}"   ) ///
nonotes addnotes("\begin{minipage}{.8\linewidth} \footnotesize \smallskip \textbf{Note:} Table reports regression estimates about cars. Significance levels are indicated by $*$ $<.1$, ** $<.05$,  *** $<.01$.   \end{minipage}" )


local ++count
}
panelcombine, use(Panel1.tex Panel2.tex Panel3.tex)  columncount(5) paneltitles("Full sample" "Foreign cars" "Domestic cars") save(combined_table.tex) cleanup


include "https://raw.githubusercontent.com/steveofconnell/PanelCombine/master/PanelCombineSutex.do"
sysuse auto, clear
local count = 1
foreach sample in "" "if foreign==1" "if foreign==0" {
sutex price mpg headroom weight length turn displacement gear_ratio `sample', labels minmax file("sumstatsP`count'.tex")  title("Summary statistics") replace
local ++count
}

panelcombinesutex, use(sumstatsP1.tex sumstatsP2.tex sumstatsP3.tex) ///
paneltitles("Full sample" "Foreign cars" "Domestic cars") columncount(5) save(sumstats.tex) ///
addcustomnotes("\begin{minipage}{`linewidth'\linewidth} \footnotesize \smallskip \textbf{Note:} Table shows summary statistics for cars in different estimation samples.\end{minipage}" ) ///
cleanup

