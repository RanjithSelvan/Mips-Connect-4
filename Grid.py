import sys

for j in range(0,24):
	sys.stdout.write("_")
sys.stdout.write("\n")

for i	in range(0,4):
	for j in range(0,18):
		if( (j)%3 == 0):
			sys.stdout.write("|")
		sys.stdout.write(" ")
	sys.stdout.write("|\n")
	for j in range(0,18):
		if( (j)%3 == 0):
			sys.stdout.write("|")
		sys.stdout.write(" ")
	sys.stdout.write("|\n")
	for j in range(0,18):
		if( (j)%3 == 0):
			sys.stdout.write("|")
		sys.stdout.write("_")
	sys.stdout.write("|\n")

