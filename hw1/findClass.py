# COMS4111 hw1a section003
# Huibo Zhao hz2480
# Sep.13th.2017

# The Find class uses csv library to load csv file
# The search function is implemented for "find"
# operation.
# The repeatItem function is implemented for checking
# if a given ID already exists in the table or not.
import csv
import sys

class Find:

    def __init__(self,file_obj):
        self.reader = csv.DictReader(file_obj,delimiter=',')

    def search(self,dictionary):
        find = False
        for line in self.reader:
            match = True
            dict_keys = dictionary.keys()
            for key in dict_keys:
                if (line.has_key(key) == False):
                    sys.exit("Your input column name " + key +
                                " is not a valid column name." + "\n" +
                                "Make sure it is spelled correct "+
                                "and it is case sensitive!")
                if (line[key] != dictionary[key]):
                    match = False
                    break
            if (match == True):
                find = True
                print line

        if (find == False):
            sys.exit("Done searching but find no match result")

    def repeatItem(self,ID,tableID):
        for line in self.reader:
            if (line[tableID].lower() == ID.lower()):
                return True
        return False
