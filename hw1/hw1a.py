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
                                "it is case sensitive!")
                if (line[key] != dictionary[key]):
                    match = False
            if (match == True):
                find = True
                print line

        if (find == False):
            sys.exit("Done searching but find no match result")




    #def csv_dict_reader(file_obj):
        # Read a CSV file using csv.DictReader
    #    reader = csv.DictReader(file_obj, delimiter=',')
    #    for line in reader:
            #print(line["first_name"]),
            #print(line["last_name"])
    #        print line['OrderID']
    #        break



#print 'Number of arguments:', len(sys.argv), 'arguments.'
#print 'Argument List:', str(sys.argv)

# exit the program if input arguments are invalid
if (len(sys.argv)<4):
    sys.exit("Invalid input, please refer to data operation "+
                "for correct input")

operation = sys.argv[1]
table = sys.argv[2]

# exit the program if the operation is neither find nor operation
if (operation.lower() != "find".lower() and
operation.lower() != "insert".lower()) :
    sys.exit("Invalid operation command")

# exit the program if the table name is neither customer nor order
if (table.lower() != "order".lower() and
table.lower() != "customer".lower()) :
    sys.exit("Invalid table name")

# FIND
if (operation.lower() == "find".lower()):

    dictionary = {}
    for x in range(3,len(sys.argv)-1):
        if (sys.argv[x][len(sys.argv[x])-1] != ','):
            sys.exit("Invalid input, please use comma and space to "+
                        "seperate searching terms")
        else:
            word = sys.argv[x][:-1]
            tokens = word.split("=",1)
            if (len(tokens)!=2):
                sys.exit("Invalid input, each searching term must "+
                            "contain '=' sign")
            dictionary[tokens[0]] = tokens[1]

    tokens_last = sys.argv[len(sys.argv)-1].split("=",1)
    if (len(tokens_last)!=2):
        sys.exit("Invalid input, each searching term must "+
                    "contain one and only one '=' sign")
    dictionary[tokens_last[0]] = tokens_last[1]

    with open(table.lower()+"s.csv") as f_obj:
        f1 = Find(f_obj)
        f1.search(dictionary)



test = {}
test['hehe'] = 3
test['haha'] = 2

#print test
#print type(test)
