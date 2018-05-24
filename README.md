# PanelCombine

Stata programs to combine LaTex output files from esttab and sutex into single, ready-to-include LaTex-formatted tables with multiple panels

## Use
###Panelcombine -- program for combining regression tables from esttab ... ,style(tex)
User outputs (writes to disk or tempfile) multiple files intended to form multiple panels of the same table.

Syntax:

    panelcombine, use(filenames) paneltitles(strings) columncount(integer) save(filepath)


MWE:



## Contributing
I am happy to recieve general critique, suggestions or bug fixes on the code, or otherwise...

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Acknowledgments
This script was written with heavy inspiration from Anthony J. Damico's "Analyze Survey Data For Free" repository (see https://github.com/ajdamico/usgsd/), in particular the PSID download program. Any mistakes or inelegancies in the script are attributable to me and me alone.

## License
Use in academic research will require a citation to the paper for which the code was developed:

Joyce, Ted, Sean Crockett, David A. Jaeger, R. Onur Altindag and Stephen D. O'Connell, "Does Classroom Time Matter? A Randomized Field Experiment of Hybrid and Traditional Lecture Formats in Economics," NBER Working Paper #20006. March 2014.

