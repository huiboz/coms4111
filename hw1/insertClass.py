# COMS4111 hw1a section003
# Huibo Zhao hz2480
# Sep.13th.2017
# The Insert class uses csv library to load
# and write to the csv file

import csv
import sys

class Insert:

    def __init__(self,file_obj):
        self.writer = csv.writer(file_obj)

    def write(self,tokens):
        self.writer.writerow(tokens)
