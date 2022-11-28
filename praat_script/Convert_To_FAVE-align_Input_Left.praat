###############################################################
## This Praat script exports orthographic transcriptions in Praat                      	##
## to a format suitable as input to the FAVE-align forced aligner                      	##
## (http://fave.ling.upenn.edu/FAAValign.html).                                              	##
## The transcription will be converted to a 5-column tab-delimited .txt file     	##
## as outlined in the instructions on the FAVE web site.                                    	##
## 																		##
## To run this program, select the TextGrid containing the transcriptions,		##
## open this script, and select "Run" > "Run".								##
##																		##
## This script was written by Ingrid Rosenfelder, 							##
## last modified October 31, 2011											##
###############################################################


## Get all the textgrid in a given directory

form Read all files of the given type from the given directory
   sentence Mono_left /Users/jojohu/Documents/Time/data/mono_left
   sentence Output_path /Users/jojohu/Documents/Time/data/output_folder/
   sentence File_extension .TextGrid
endform


## Collect all the files that match the search criteria and save them

Create Strings as file list... list 'mono_left$'/*'file_extension$'
textgrid_list = selected("Strings")
file_count = Get number of strings


## get TextGrid name

for current_file from 1 to file_count
	select Strings list
	filename$ = Get string... current_file
	Read from file... 'mono_left$'/'filename$'

## To Do: change the directory of the output .txt files by changing fileappend command below; and remove string lists from praat object list at the end;
    outfile$ = output_path$ + filename$ - ".TextGrid" + ".txt"
	
	## ask the user before overwriting exiting file
	if fileReadable(outfile$)
		pause 'filename$'.txt already exists.  Overwrite?
		deleteFile(outfile$)
	endif

	## extract transcription info and write to file
	n_tiers = Get number of tiers

	## To Do: Make sure point tier is not included (make sure tier 0 is point tier if possible)

	for tier from 1 to n_tiers
	    echo 'outfile$'
		tiername$ = Get tier name... 'tier'
		n_intervals = Get number of intervals... 'tier'
	
		for interval from 1 to 'n_intervals'
			start = Get start point...  'tier' 'interval'
			end = Get end point... 'tier' 'interval'
			label$ =  Get label of interval... 'tier' 'interval'
			if label$ <> ""
				fileappend 'outfile$' 'tiername$''tab$''tiername$''tab$''start''tab$''end''tab$''label$''newline$'
			endif
		endfor
	endfor
endfor

echo Written transcription in FAVE-align input format to file 'outfile$'.