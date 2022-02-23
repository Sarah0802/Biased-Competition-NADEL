from collections import defaultdict
import sys
import re
import csv
import codecs

code_list_name = input('Enter file name of code list:')
file_name = input('Enter output file name from the decoding program:')

# load the code to number association to dictionary
dictionarycodelist = defaultdict(int)

csv_reader = csv.reader(codecs.open(code_list_name, 'rU', 'utf-8'), delimiter=';')
for line_entries in csv_reader:
    dictionarycodelist[line_entries[0]] = line_entries[1]

# create a output file handle
fq_extension = '.fq'
output_file_name = 'out_' + file_name[:len(file_name)-len(fq_extension)]+'.csv'

output_file_handle = codecs.open(output_file_name, 'w+', 'utf-8')

# read sequencing file and replace sequences
csv_reader = csv.reader(codecs.open(file_name, 'rU', 'utf-8'), delimiter='\t')
for line_entries in csv_reader:
    sequence_replacement = dictionarycodelist[line_entries[2]]
    entry_length = len(line_entries)
    sequence_replacement2 =0
    if entry_length >3:
        sequence_replacement2 = dictionarycodelist[line_entries[3]]
        if sequence_replacement != 0 and sequence_replacement2 != 0:
            new_line = line_entries[0] + ';' + sequence_replacement + ';' + sequence_replacement2 + '\n'
            output_file_handle.write(new_line)

    elif sequence_replacement != 0:
        new_line = line_entries[0] + ';' + sequence_replacement + '\n'
        output_file_handle.write(new_line)

output_file_handle.close()

