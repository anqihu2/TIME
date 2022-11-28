## Praat script by Kevin Ryan 9/05
## Below: the user is asked for a directory (the default below is the path for my own desktop;
## you will probably want to change that), a file extension, and an optional substring to match
## in the filenames (leaving this blank will get all the files of the given type)

form Read all files of the given type from the given directory
   sentence Source_directory /Users/jojohu/Documents/Time/data/
   sentence File_extension .wav
   sentence Mono_left /Users/jojohu/Documents/Time/data/mono_left
   sentence Mono_right /Users/jojohu/Documents/Time/data/mono_right
endform


## Below: collect all the files that match the search criteria and save them

Create Strings as file list... list 'source_directory$'/*'file_extension$'
wav_list = selected("Strings")
file_count = Get number of strings

# http://www.u.arizona.edu/~dbrenner/Scripts/getLeftChannels.praat
# This script extracts the left channel (or just the single channel from 1-channel
# recordings) from all .wav, .WAV, .aif, and .AIF sound files, removes the original
# file, and saves each as a .wav file.
# This is handy for prepping files from annoying recorders
# that make two-channel recordings when only one contains
# any data.
# If a .wav file with the same name already exists, it will be overwritten.
# Don't forget to back up your sound files in a separate
# folder before running.

# handsomely flummoxed 12/2011 by dan brenner
# dbrenner atmark email dot arizona dot edu
#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#



for current_file from 1 to file_count
	select Strings list
	filename$ = Get string... current_file
	sound = Read from file... 'source_directory$'/'filename$'
	left = Extract one channel... Left
	Save as WAV file... 'mono_left$'/'filename$'
	plus sound
	Remove
endfor

select wav_list
Remove

print Left channel selection done.


## Below: collect the mono channel sound data files

Create Strings as file list... list 'mono_left$'/*'file_extension$'
leftL = selected("Strings")
file_count_left = Get number of strings

## Below: loop through the list of files, extracting each name and reading it into the Objects list

for current_file from 1 to file_count_left
   select Strings list
   mono_filename$ = Get string... current_file
   Read from file... 'mono_left$'/'mono_filename$'
endfor

select leftL
Remove

echo Done! 'file_count' files read.'newline$'.
