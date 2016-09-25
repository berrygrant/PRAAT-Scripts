#Pull average pitch and intensity from each file and normalize all files based on grand mean
#Save new files to a separate directory
#Copyright Grant M. Berry (berry.grant@gmail.com), 2015

directory$=chooseDirectory$("Where are your original sound files?")
normdirectory$=chooseDirectory$("Where do you want to save the normed sound files?")
directory$="'directory$'"+"/"
normdirectory$="'normdirectory$'"+"/"
strings = do ("Create Strings as file list...", "list", directory$ + "*.wav")
numberOfFiles=Get number of strings
pavg=0
intavg=0
printline Getting average pitch and intensity for 'numberOfFiles' files
for x to numberOfFiles
	selectObject(strings)
	filename$ = do$ ("Get string..." , x)
	soundname$="Sound "+"'filename$'"
	soundloc$="'directory$''filename$'"
	sound=Read from file... 'soundloc$'
	selectObject(sound)
	pitch=To Pitch... 0.0 75.0 600.0
	pavgsamp=Get mean... 0.0 0.0 Hertz
	pavg=pavg+pavgsamp
	selectObject(sound)
	int=To Intensity... 100 0.0 Yes
	selectObject(int)
	intavgsamp=Get mean... 0.0 0.0 energy
	intavg=intavg+intavgsamp
	plusObject(pitch)
	plusObject(sound)
	Remove
endfor
pavg=pavg/numberOfFiles
intavg=intavg/numberOfFiles
printline The average pitch is 'pavg' and the average intensity is 'intavg'
printline Now scaling sounds...
for y to numberOfFiles
	selectObject(strings)
	filename$ = do$ ("Get string..." , y)
	newname$=replace$("'filename$'","S4_","",0)
	newname2$="'newname$'"-"_"-"*.wav"
	printline 'newname2$'
	soundname$="Sound "+"'filename$'"
	soundloc$="'directory$''filename$'"
	sound=Read from file... 'soundloc$'
	selectObject(sound)
	do("Scale intensity...", intavg)
	pitch=To Pitch... 0.0 75.0 600.0
	pavgsamp=Get mean... 0.0 0.0 Hertz
	ratio=pavgsamp/pavg
	selectObject(pitch)
	Formula: "self*ratio; Rescale"
	plusObject(sound)
	man=To Manipulation
	resynth= Get resynthesis (overlap-add)
	selectObject(resynth)	
	zone$="'normdirectory$'"+"'newname2$'.wav"
	Save as WAV file... 'zone$'
	plusObject(pitch)
	plusObject(sound)
	plusObject(man)
	Remove
endfor
printline All sounds have been rescaled, and they are in 'normdirectory$'

	
	