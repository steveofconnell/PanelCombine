//some 2010-gen inspiration from here: https://www.stata.com/statalist/archive/2010-01/msg00213.html
cap prog drop panelcombine
prog define panelcombine
qui {
syntax, use(str asis) paneltitles(str asis) columncount(integer) save(str asis) [CLEANup]
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
insheet using "``num''", clear
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
	drop if strpos(v1,"Note:")>0 | strpos(v1,"in parentheses")>0 | strpos(v1,"p<0")>0
	drop if v1=="\end{tabular}" | v1=="}"
	replace v1 = "\hline \multicolumn{`columncount'}{l}{ \linebreak \textbf{\textit{Panel `panellabel': `panel1title'}}} \\" if v1=="\hline" & _n<8
	replace v1 = "\hline" if v1=="\hline\hline" & _n>4 //this is intended to replace the bottom double line; more robust condition probably exists
	}
	else if `num'==`max' { //process final panel -- clip top
	//process header to drop everything until first hline
	g temp = (v1 == "\hline")
	replace temp = temp+temp[_n-1] if _n>1
	drop if temp==0
	drop temp
	
	replace v1 = " \multicolumn{`columncount'}{l}{\linebreak \textbf{\textit{Panel `panellabel': `panel`num'title'}}} \\" if _n==1
	}
	else { //process middle panels -- clip top and bottom
	//process header to drop everything until first hline
	g temp = (v1 == "\hline")
	replace temp = temp+temp[_n-1] if _n>1
	drop if temp==0
	drop temp
	
	replace v1 = " \multicolumn{`columncount'}{l}{\linebreak \textbf{\textit{Panel `panellabel': `panel`num'title'}}} \\" if _n==1
	drop if strpos(v1,"Note:")>0 | strpos(v1,"in parentheses")>0 | strpos(v1,"p<0")>0
	drop if v1=="\end{tabular}" | v1=="}"
	replace v1 = "\hline" if v1=="\hline\hline"
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


	if "`cleanup'"!="" { //erasure loop
	tokenize `use'
	local num 1
		while "``num''"~="" {
		erase "``num''"
		local num=`num'+1
		}
	}

restore
}
end
