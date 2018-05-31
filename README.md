# PanelCombine

Stata programs to combine LaTex output files from esttab and sutex into single, ready-to-include LaTex-formatted tables with multiple panels

## Use
#### Panelcombine
Program for combining production-ready regression tables from `esttab ... ,style(tex)`
User outputs (writes to disk or tempfile) multiple files intended to form multiple panels of the same table.
Program then takes multiple files and trims the extraneous leading/trailing code and inputs specified panel titles

Syntax:

`panelcombine, use(filenames) paneltitles(strings) columncount(integer) save(filepath) [CLEANup]`


MWE:

````
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
include "https://raw.githubusercontent.com/steveofconnell/PanelCombine/master/PanelCombine.do"
panelcombine, use(Panel1.tex Panel2.tex Panel3.tex)  columncount(5) paneltitles("Full sample" "Foreign cars" "Domestic cars") save(combined_table.tex) cleanup

````

Then in LaTeX (specific esttab output used above requires `makecell` and `caption` packages):

````
\begin{table}[H] \centering \caption{Table title} \label{tablelabel}
\input{combined_table.tex}
\end{table}
````


#### Panelcombinesutex
Program for combining production-ready summary statistics tables from `sutex ... ,style(tex)`

Syntax:
`panelcombine, use(filenames) paneltitles(strings) columncount(integer) save(filepath)  addcustomnotes(str asis) [CLEANup]`


MWE:
````
sysuse auto, clear
local count = 1
foreach sample in "" "if foreign==1" "if foreign==0" {
sutex price mpg headroom weight length turn displacement gear_ratio `sample', labels minmax file("sumstatsP`count'.tex")  title("Summary statistics") replace
local ++count
}

include "https://raw.githubusercontent.com/steveofconnell/PanelCombine/master/PanelCombineSutex.do"
panelcombinesutex, use(sumstatsP1.tex sumstatsP2.tex sumstatsP3.tex) ///
paneltitles("Full sample" "Foreign cars" "Domestic cars") columncount(5) save(sumstats.tex) ///
addcustomnotes("\begin{minipage}{`linewidth'\linewidth} \footnotesize \smallskip \textbf{Note:} Table shows summary statistics for cars in different estimation samples.\end{minipage}" ) cleanup
````

Then in LaTeX (table environment already included in output; `makecell` and `caption` needed again):

````
\input{sumstats.tex}
````

#### Notes

0. files used will appear in the table in the order they are input; similarly, paneltitle are indexed to the files used based on the order they are entered into the option string
1. File written automatically overwrites existing file (replace option is automatically applied)
2. `panelcolumns` option specified the number of columns for the panel titles to span, although they are automatically left-justified
3. Panels are automatically prefixed with Panel A: [paneltitle1], Panel B: [paneltitle2], Panel C: [paneltitle3]...


#### Potential improvements


1. justification option for panel titles (currently left only)


## Contributing
I am happy to recieve general critique, suggestions or bug fixes on the code, or otherwise...

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

