# PanelCombine

Stata programs to combine LaTex output files from esttab and sutex into single, ready-to-include LaTex-formatted tables with multiple panels

## Use
#### Panelcombine
Program for combining production-ready regression tables from `esttab ... ,style(tex)`
User outputs (writes to disk or tempfile) multiple files intended to form multiple panels of the same table.
Program then takes multiple files and trims the extraneous leading/trailing code and inputs specified panel titles

Syntax:

`panelcombine, use(filenames) paneltitles(strings) columncount(integer) save(filepath)`


MWE:

````
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
````

Then in LaTeX:

````
\begin{table}[H] \centering \caption{Table title} \label{tablelabel}
\input{combined_table.tex}
\end{table}
````


#### Panelcombinesutex
Program for combining production-ready summary statistics tables from `sutex ... ,style(tex)`

Syntax:
`panelcombine, use(filenames) paneltitles(strings) columncount(integer) save(filepath)`


MWE:
````
include "https://raw.githubusercontent.com/steveofconnell/PanelCombine/master/PanelCombineSutex.do"
sysuse auto, clear
forval i = 1/5 {
sutex price mpg headroom weight length turn displacement gear_ratio, labels minmax file("sumstatsP`i'.tex")  title("Summary statistics TITLE")
}

panelcombinesutex, use(sumstatsP1.tex sumstatsP2.tex sumstatsP3.tex sumstatsP3.tex sumstatsP4.tex sumstatsP5.tex) ///
paneltitles("PanelAtitle" "PanelBtitle" "PanelCtitle" "PanelDtitle" "PanelEtitle") columncount(9) save(sumstats.tex)
````

Then in LaTeX (table environment already included):

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
2. ?


## Contributing
I am happy to recieve general critique, suggestions or bug fixes on the code, or otherwise...

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

