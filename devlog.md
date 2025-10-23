#IT STARTS HERE!!!!!!!

#ENTRY 1: 10/23/2025, time: 12:32PM

	This is my first log entry. Obviously a little late on starting the project but I do have the whole day to work on this so I will still add commits throughout the day with time stamps on it and hopefuly be able to finish it today instead of stretching it all the way to tomorrow!

What I know about this project: I am going to create a prefix notation calculator that has two modes, an interactive mode(which it is by default) that continously asks the user for expressions, and also a batch mode which is activated using a batch flag, and it won't prompt you or anything just outputs the answer.

another importnat part of this porject i skeeping the history of results wtih newest first in a queue(this just means you don't actually need to reverse, all I would need to do is cons the answer to a history array and save it somehow and just return the history so it should be fairly simple)


I think I should first start off with the interactive section, then batch, then handle errors at the end and the history thign shouldn't be too hard


#ENTRY 2: 10/23/2025, TIME: 4:35PM


I am making it so that for now main will only contain the looping mechanism for the interactive terminal output,and everything else will branch off from this like the actual calculator section and error checking and things like this

I figured out that the way to run this is through the terminal so that the -b and -batch commands work as required:

interactive: "/Applications/Racket v8.18/bin/racket" main.rkt 

batch: "/Applications/Racket v8.18/bin/racket" main.rkt -b

#ENTRY 3: 10/23/2025, TIME: 5:15PM

I have currently added a file called io.rkt which if given a success value will print the success id but if it faisl will print "Error: Invalid Expression"


I have also connnected this to the main so that anything that isn't a number is an invalid expression, next we need to create the code that will check what type of symbol it is, and if it is a +, -, *, or /, then you need to do something special




