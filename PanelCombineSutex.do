
cap prog drop panelcombinesutex
prog define panelcombinesutex
qui {
syntax, use(str asis) paneltitles(str asis) columncount(integer) save(str asis) addcustomnotes(str asis)
preserve

tokenize `"`paneltitles'"'
//read in loop
local num 1
while "``num''"~="" {
local panel`num'title="``num''"
local num=`num'+1
}


tokenize `use'
//read in loop
local num 1
while "``num''"~="" {
tempfile temp`num'
insheet using "``num''", clear nonames
save `temp`num''
local max = `num'
local num=`num'+1
}

//conditional processing loop
local num 1
while "``num''"~="" {
local panellabel : word `num' of `c(ALPHA)'
use `temp`num'', clear
	if `num'==1 { //process first panel -- clip bottom
	replace v1 = "\hline" if v1=="\hline\end{tabular}"
	drop if v1=="\end{table}"
	replace v1 = subinstr(v1,"\hline","\hline \multicolumn{`columncount'}{l}{\textbf{\textit{Panel `panellabel': `panel`num'title'}}} \\",1) if _n==4
	drop if trim(v1)==""
	}
	else if `num'==`max' { //process final panel -- clip top
	//process header to drop everything until first hline
	drop if _n<4
	replace v1 = " \multicolumn{`columncount'}{l}{\textbf{\textit{Panel `panellabel': `panel`num'title'}}} \\" if _n==1
	drop if trim(v1)==""
	}
	else { //process middle panels -- clip top and bottom
	//process header to drop everything until first hline
	drop if _n<4
	replace v1 = " \multicolumn{`columncount'}{l}{\textbf{\textit{Panel `panellabel': `panel`num'title'}}} \\" if _n==1
	replace v1 = "\hline" if v1=="\hline\end{tabular}"
	replace v1 = "`addcustomnotes'" if v1== "\end{table}"
	replace v1 = "\end{table}" if _n==_N
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
