#Make a Mono folder in the same directory as your files
#This script will extract the left channel of stereo audio. If you use a Zoom H4N recorder with external microphones,
#This corresponds to Input #1

directory$=chooseDirectory$("Where are your files?")
directory$="'directory$'/"
mono$=chooseDirectory$("Where do the mono files go?")
mono$="'mono$'/"
strings = do ("Create Strings as file list...", "list", "'directory$'*.wav")
numberOfFiles = Get number of strings
for ifile to numberOfFiles
	selectObject(strings)
	filename$ = do$ ("Get string..." , ifile)
	sound$="Sound "+"'filename$'"-".wav"
	soundname$="'directory$'"+"'filename$'"
	Read from file... 'soundname$'
	selectObject: "'sound$'"
	Extract one channel: 1
	Save as WAV file... 'mono$''filename$'
	printline File 'ifile' of 'numberOfFiles' complete
endfor
select all
Remove
	