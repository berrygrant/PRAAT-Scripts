#Copyright Grant M. Berry, 2014#
#This script is designed to go through a long sound file, such as the interviews in the NMSEB corpus,
#and find segments of the interview which were anonymized using a low-pass filter.
#The long sound has to be opened in PRAAT and selected for the script to work
#To open long sound, cmd+L
#This can be edited by specifying a directory of many long sound files
#Window length and power threshold can be adjusted to tweak the sensitivity of the program
#
#The script is acceptable, but far from perfect. Make sure you check within the window for any
#anonymization that it picks up. This script is currently unable to find multiple anonymizations within the same window
#If you notice any other problems, please email me at grantberry@psu.edu or berry.grant@gmail.com
################################
form Sensitivity Settings
	comment What is the highest frequency passed?
	real freqthresh 600
	comment Power threshold
	real powthresh 1e-8
	comment Window Length (s)
	real window 2
endform
sound=selected("LongSound")
soundname$=selected$()
selectObject("'soundname$'")
s=Get start time
end=Get end time
len=end-s
numint=round(len/'window')
grid=To TextGrid: "anon", ""
soundname$=replace$("'soundname$'","LongSound ","",0)
z=numint-1
check=0
prog=10
perc=round(numint/10)
printline Starting on 'soundname$'...
for x from 1 to z
	check=check+1
	if check=perc
		printline 'prog'% done
		prog=prog+10
		check=0
	endif
	startboundary=0
	endboundary=0
	selectObject("LongSound "+"'soundname$'")
	start=0
	end=0
	start='window'*('x'-1)
	end='window'*('x')
	#printline interval 'x', from 'start' to 'end'
	int'x'=Extract part: start, end, "yes"
	name$=selected$()
	Rename... "interval 'x'_'start's_'end's"
	spect=To Spectrogram: 0.005, 5000, 0.002, 20, "Gaussian"
	selectObject('spect')
	for y from 2 to 498
		j=500/'window'
		pow=Get power at: start+y/j, freqthresh+1000
		#printline power is 'pow' for y='y'
		if pow<powthresh
			bound'y'=start+y/j
			b$=string$(bound'y')
		else
			bound'y'=0
		endif
	endfor
	min=0
	max=0
	for y from 2 to 497
		test=bound'y'
		g=y+1
		sample=bound'g'
		if test<powthresh and sample>0
			min=sample
		endif
	endfor
	for y from 2 to 497
		test=bound'y'
		g=y+1
		sample=bound'g'
		if test>0 and sample>0
			max=max(test,sample)
		endif
	endfor		
	if min>0 and max>0
		startboundary=min
		endboundary=max
		selectObject('grid')
		Insert boundary... 1 'startboundary'
		Insert boundary... 1 'endboundary'
		an=Get interval at time... 1 'startboundary'
		Set interval text... 1 an a
	endif
	#printline 'startboundary' and 'endboundary'
	selectObject("LongSound "+"'soundname$'")
select all
minusObject("LongSound "+"'soundname$'")
minusObject('grid')
Remove
endfor
selectObject('grid')
name$=selected$()
newname$="'soundname$'"-"_anonym"+"_anontier"
Rename... 'newname$'
printline Finished with 'soundname$'.

