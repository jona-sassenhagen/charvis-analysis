# script to determine the error rate

# import sys

# csvfile = sys.argv[1]
# outfile = sys.argv[2]

import csv

syncorrrate=[];semcorrrate=[];

for i in range(1,22):
	csvfile = '/Users/jona/Dropbox/experimente/charvis/newfirst/subject-' + str(i) + '.csv'
	f = open(csvfile, 'rt')
	print f
	syntax = 211, 221, 231, 213
	semantics = 212, 222, 232
	syntaxlist=[];semanticslist=[];
	with open(csvfile,'rb') as f:
		reader = csv.DictReader(f,fieldnames=('time','tdelta','hyponym','hyperonym','trg','rt','response'))
		for row in reader:
			try:
				if int(row['trg']) in syntax:
					syntaxlist.append(row['response'])
				elif int(row['trg']) in semantics:
					semanticslist.append(row['response'])
			except:
				pass
	syncorrrate.append(int((float(syntaxlist.count('correct'))/float(len(syntaxlist)))*100))
	semcorrrate.append(int((float(semanticslist.count('correct'))/float(len(semanticslist)))*100))

print syncorrrate
print semcorrrate
