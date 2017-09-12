import csv
import sys

class Insert:

    def __init__(self,file_obj):
        self.writer = csv.writer(file_obj)

    def write(self,tokens):
        self.writer.writerow(tokens)
