#This script will search through a user-defined dictionary saved in .txt format,
#and find all matches in a pre-determined tier on all text grids in a given directory.
#The script will then create a new tier below the word tier containing only those words which
#match those found in the dictionary.
#Finally, the text grids are saved in the home directory
#####################################
#Written for Dr. Matthew T. Carlson by
#Grant M. Berry (grant [dot] berry [at] psu [dot] edu
#Web: grantberry [dot] info
#(c) 09-03-15
#####################################
#Identify the dictionary filepath
#NB: This file should be in an encoding that PRAAT can handle (UTF-8, Latin ISO), lest the program fail to read special characters
words$=chooseReadFile$("Where is your Word List?")

#Create strings from text file
list$=do$("Read Strings from raw text file...", "'words$'")
#Convert to WordList for easier querying
Genericize
Sort
wdlist=To WordList

#Now, find the text grids to be analyzed:
directory$=chooseDirectory$("Where are your text grid files?")
directory$="'directory$'"+"/"
 
#Query the user to find the appropriate word tier
form Tiers
comment Which tier contains the word-level transcription?
real wtier 2
endform

#Find all TextGrid files in the directory
strings=do("Create Strings as file list...", "list", directory$ + "*.TextGrid")
numGrids=Get number of strings

#Report number of text grids in the directory
if numGrids=1
	writeInfoLine: "There is 1 Text Grid to be analyzed. Starting now..."
else
	writeInfoLine: "There are 'numGrids' Text Grids to be analyzed. Starting now..."
endif

#Now, start going through the text grids
for x to numGrids
	printline working on 'x' of 'numGrids'
	targets=0
	selectObject(strings)
	filename$=do$("Get string...", 'x')
	gridname$="TextGrid "+"'filename$'"-".TextGrid"
	gridloc$="'directory$'"+"'filename$'"
	grid=do("Read from file...",gridloc$)

	#Set up the result window:
	writeInfoLine: "Matching words found in 'gridname$', file 'x' of 'numGrids'"
	appendInfoLine: "Word",tab$,"Start",tab$,"End"
	selectObject('grid')
	
	#Set up results tier
	#This is the position of the new tier, containing only target words (directly below the word tier)
	targs='wtier'+1
	Insert interval tier... 'targs' Targets

	#Now we need to start looping through the words to find matches
	wdsint=do("Get number of intervals...", 'wtier')
	for y to wdsint
		#Reset variables
		tstart=0
		tend=0
		tmid=0
		#Get the label, start, and end for every interval in the word tier
		word$=do$("Get label of interval...",'wtier', 'y')
		start=do("Get starting point...",'wtier', 'y')
		end=do("Get end point...",'wtier','y')
		#Anything that's not empty has a word that we need to check in the word list
		if word$<>""
			selectObject(wdlist)
			test=Has word: "'word$'"
			#Now, if the word we have matches one in our dictionary, we want to get its beginning and end points, add it to our list
			#and insert boundaries where necessary in the result tier
			if test=1
				sround$=fixed$('start',2)
				eround$=fixed$('end',2)
				appendInfoLine: "'word$'",tab$, "'sround$'",tab$, "'eround$'"

				#Watch out, though. If you have two adjacent target words, you have to make sure not to add two boundaries on 
				#top of one another. This if loop will only add the left boundary if it isn't already there.
				selectObject("'gridname$'")
				thresh=start-0.001
				xs=do("Get interval at time...",'targs','thresh')
				t$=do$("Get label of interval...",'targs', 'xs')
				if t$=""
					tstart=do("Insert boundary...",'targs','start')
				endif
				#Add the boundaries and then add the word label where it belongs
				tend=do("Insert boundary...",'targs','end')
				tmid=1/2*'start'+1/2*'end'
				blank=do("Get interval at time...",'targs','tmid')
				target$=do$("Set interval text...",'targs', 'blank', "'word$'")
				#Increase the counter by 1
				targets=targets+1
			endif
		endif
		selectObject("'gridname$'")
	endfor
selectObject("'gridname$'")
do("Save as text file...",gridloc$)
appendInfoLine: "There are 'targets' target words in 'filename$', file 'x' of 'numGrids' (counting repetitions)."
selectObject('strings')
endfor
select all
Remove

