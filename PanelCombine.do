//some 2010-gen inspiration from here: https://www.stata.com/statalist/archive/2010-01/msg00213.html
prog drop _all
prog define panelcombine
qui {
syntax, use(str asis) save(str asis) *
preserve
tokenize `use'

//read in loop
local num 1
while "``num''"~="" {
tempfile temp`num'
insheet using "``num''", clear
save `temp`num''
local max = `num'
local num=`num'+1
}

//conditional processing loop
local num 1
while "``num''"~="" {
use `temp`num'', clear
	if `num'==1 { //process first panel
	replace v1 = "\\" if strpos(v1,"Note:")>0
	drop if v1=="\end{tabular}" | v1=="}"
	}
	else if `num'==`max' { //process final panel
	drop if _n<=3
	replace v1 = "\\" if _n==1
	}
	else { //process middle panels
	replace v1 = "\\" if strpos(v1,"Note:")>0
	drop if v1=="\end{tabular}" | v1=="}"
	}
	save `temp`num'', replace
local num=`num'+1
}

use `temp1',clear
local num 2
while "``num''"~="" {
append using `temp`num''
local num=`num'+1
}

outsheet using `save', noname replace noquote
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


panelcombine, save(panelstuff2pan.tex) use(PanelA.tex PanelB.tex)  replace


eststo clear
eststo: regress price mpg trunk   weight length
estadd ysumm
esttab using PanelC.tex, style(tex) stats(N r2 ymean ysd, fmt( %9.0g %9.2f  %9.2f %9.2f) labels("\$N$" "\$R^2$" "Mean of outcome" "St. dev. of outcome")) label replace ///
star( * .1 ** .05 *** .01) b(%9.3f) se(%9.3f) nogaps  ///
mtitles("\makecell{(1)}"  ) ///
nonotes nonum addnotes("\begin{minipage}{`linewidth'\linewidth} \footnotesize \smallskip \textbf{Note:} Table reports coefficient estimates from equation TK2 estimated via OLS. All specifications include TKYXZ... Standard errors are clustered by state. Significance levels are indicated by $*$ $<.1$, ** $<.05$,  *** $<.01$.   \end{minipage}" )


panelcombine, use(PanelA.tex PanelB.tex PanelC.tex)  save(panelstuff3pan.tex) replace

