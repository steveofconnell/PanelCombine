//some 2010-gen inspiration from here: https://www.stata.com/statalist/archive/2010-01/msg00213.html
prog drop _all
prog define panelcombine
qui {
syntax, use(str asis) combine(str asis) save(str asis) *
preserve


tempfile temp1 temp2
insheet using `use', noname clear
replace v1 = "\\" if strpos(v1,"Note:")>0
drop if v1=="\end{tabular}" | v1=="}"
save `temp1', replace

insheet using `combine', noname clear
drop if _n<=3
replace v1 = "\\" if _n==1
save `temp2', replace

use `temp1',clear
append using `temp2'

outsheet using `save', noname replace
restore
}
end


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


panelcombine, save(panelstuff.tex) use(PanelA.tex) combine(PanelB.tex) replace


eststo clear
eststo: regress price mpg trunk   weight length
estadd ysumm
esttab using PanelC.tex, style(tex) stats(N r2 ymean ysd, fmt( %9.0g %9.2f  %9.2f %9.2f) labels("\$N$" "\$R^2$" "Mean of outcome" "St. dev. of outcome")) label replace ///
star( * .1 ** .05 *** .01) b(%9.3f) se(%9.3f) nogaps  ///
mtitles("\makecell{(1)}"  ) ///
nonotes nonum addnotes("\begin{minipage}{`linewidth'\linewidth} \footnotesize \smallskip \textbf{Note:} Table reports coefficient estimates from equation TK2 estimated via OLS. All specifications include TKYXZ... Standard errors are clustered by state. Significance levels are indicated by $*$ $<.1$, ** $<.05$,  *** $<.01$.   \end{minipage}" )


panelcombine, use(panelstuff.tex) combine(PanelC.tex) save(panelstuff.tex) replace

