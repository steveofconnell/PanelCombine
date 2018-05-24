
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

include "https://raw.githubusercontent.com/steveofconnell/PanelCombine/master/PanelCombineSutex.do"

sysuse auto, clear
forval i = 1/5 {
sutex price mpg headroom weight length turn displacement gear_ratio, labels minmax file("sumstatsP`i'.tex")  title("Summary statistics TITLE")
}

panelcombinesutex, use(sumstatsP1.tex sumstatsP2.tex sumstatsP3.tex sumstatsP3.tex sumstatsP4.tex sumstatsP5.tex) ///
paneltitles("PanelAtitle" "PanelBtitle" "PanelCtitle" "PanelDtitle" "PanelEtitle") columncount(9) save(sumstats.tex)
