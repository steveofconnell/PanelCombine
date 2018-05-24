
cd ~/downloads
include "https://raw.githubusercontent.com/steveofconnell/PanelCombine/master/PanelCombine.do"

sysuse auto, clear
eststo clear
eststo: regress price mpg
estadd ysumm
esttab _all using PanelA.tex, style(tex) replace

eststo clear
eststo: regress price  trunk
estadd ysumm
esttab using PanelB.tex, style(tex)  replace

eststo clear
eststo: regress price mpg trunk   weight length
estadd ysumm
esttab using PanelC.tex, style(tex) replace
panelcombine, use(PanelA.tex PanelB.tex PanelC.tex)  columncount(2) paneltitles(TitleA TitleB titleC) save(combined_table.tex)

