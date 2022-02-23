from collections import defaultdict
import sys
import re

counter = defaultdict(int) # dictionary to count compounds

file_name = input('Enter file name of sequencing data:')

i=0
for line in open(file_name):
	line=line.strip()
	# Sequencing primer 1
	# 5ly rev comp code
	if line[:12]=='index sequence' and line[89:101]=='index sequence': line = line[:12]+"\t"+line[30:55]
	# 3L rev comp code
	# if line[:15]=='index sequence' and line[74:86]== 'index sequence' : line = line[:12]+"\t"+line[35:56]
	# elif line[:12]=='' and line[89:101]=='': line= line[:12]+"\t" + line[49:70]
	# Y shape rev comp code
	# if line[:12]=='index sequence' and line[55:113]=='sequence of spacer domain':
	# line = line[:12] +"\t" + line[30:55] + "\t" +line[113:134]

	# SP2
	# 5ly original code
	# if line[:12]=='index sequence' and line[89:101]=='index sequence': line = line[:12]+"\t"+line[46:71]
	# 3L  original code
	# if line[:12]=='index sequence' and line[88:100]=='index sequence': line = line[:12]+"\t" + line[31:52]
	# elif line[:12]=='' and line[89:101]=='': line =line[:12]+"\t" + line[31:52]
	# Y shape original code
	# if line[:12]=='index sequence' and line[152:164]=='index sequence': line = line[:12] +"\t" +line[30:51]+"\t"+line[109:134]

	else: line = "N"+"\t"+"N"

	i+=1
	if i%4 == 2: # line number i is 4*n+2
		if all(c in "ACGTN\t" for c in line):
			counter[line]+=1
		else: 
			print("Problem in line %d. Expected DNA sequence, but found:\n%s"%(i,line))
			sys.exit(1)
f= open("S3.fq", "w+")

print("Frequency, DNA sequence")
for (k,v) in sorted(counter.items(), key=lambda kv: kv[1], reverse=True):
	f.write("%d\t %s"%(v,k)) 
	f.write ("\n")
	print("%d\t %s"%(v,k))

f.close()
