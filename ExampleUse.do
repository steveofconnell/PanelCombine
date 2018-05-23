
cd ~/downloads
include "https://raw.githubusercontent.com/steveofconnell/PanelCombine/master/PanelCombine.do"

sysuse auto, clear
eststo clear
eststo: regress price mpg
estadd ysumm
esttab _all using PanelA.tex, style(tex) stats(N r2 ymean ysd, fmt( %9.0g %9.2f  %9.2f %9.2f) labels("\$N$" "\$R^2$" "Mean of outcome" "St. dev. of outcome")) label replace ///
star( * .1 ** .05 *** .01) b(%9.3f) se(%9.3f) nogaps  ///
mtitles("\makecell{(1)}"  ) ///
nonotes nonum addnotes("\begin{minipage}{`linewidth'\linewidth} \footnotesize \smallskip \textbf{Note:} Table reports coefficient estimates from equation TK2 estimated via OLS. All specifications include TKYXZ... Standard errors are clustered by state. Significance levels are indicated by $*$ $<.1$, ** $<.05$,  *** $<.01$.   \end{minipage}" )

eststo clear
eststo: regress price  trunk
estadd ysumm
esttab using PanelB.tex, style(tex) stats(N r2 ymean ysd, fmt( %9.0g %9.2f  %9.2f %9.2f) labels("\$N$" "\$R^2$" "Mean of outcome" "St. dev. of outcome")) label replace ///
star( * .1 ** .05 *** .01) b(%9.3f) se(%9.3f) nogaps  ///
mtitles("\makecell{(1)}"  ) ///
nonotes nonum addnotes("\begin{minipage}{`linewidth'\linewidth} \footnotesize \smallskip \textbf{Note:} Table reports coefficient estimates from equation TK2 estimated via OLS. All specifications include TKYXZ... Standard errors are clustered by state. Significance levels are indicated by $*$ $<.1$, ** $<.05$,  *** $<.01$.   \end{minipage}" )


panelcombine, save(panelstuff2pan.tex) paneltitles(testA testB) use(PanelA.tex PanelB.tex)  replace


eststo clear
eststo: regress price mpg trunk   weight length
estadd ysumm
esttab using PanelC.tex, style(tex) stats(N r2 ymean ysd, fmt( %9.0g %9.2f  %9.2f %9.2f) labels("\$N$" "\$R^2$" "Mean of outcome" "St. dev. of outcome")) label replace ///
star( * .1 ** .05 *** .01) b(%9.3f) se(%9.3f) nogaps  ///
mtitles("\makecell{(1)}"  ) ///
nonotes nonum addnotes("\begin{minipage}{`linewidth'\linewidth} \footnotesize \smallskip \textbf{Note:} Table reports coefficient estimates from equation TK2 estimated via OLS. All specifications include TKYXZ... Standard errors are clustered by state. Significance levels are indicated by $*$ $<.1$, ** $<.05$,  *** $<.01$.   \end{minipage}" )


panelcombine, use(PanelA.tex PanelB.tex PanelC.tex)  paneltitles(testA testB testC) save(panelstuff3pan.tex) replace

