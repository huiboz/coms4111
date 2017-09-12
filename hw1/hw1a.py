import sys
import findClass
import insertClass




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
        f1 = findClass.Find(f_obj)
        f1.search(dictionary)

# INSERT
else:
    if (len(sys.argv)>4):
        sys.exit("For insert operation, please do not leave any space "+
                    "between entries")

    if (sys.argv[3][0] != '(' or sys.argv[3][len(sys.argv[3])-1] != ')'):
        sys.exit("Please make sure the inserted data is inside "+
                    "the parentheses")

    dictionary = {}
    word = sys.argv[3][1:len(sys.argv[3])-1]
    tokens = word.split(",")

    if (table.lower() == "customer"):
        if (len(tokens) != 11):
            sys.exit("The customer table requires 11 entries ")

        with open("customers.csv") as f_obj:
            f1 = findClass.Find(f_obj)
            if (f1.repeatItem(tokens[0],"CustomerID") == True):
                sys.exit("This inserted data has a same ID as an existed data ")

    if (table.lower() == "order"):
        if (len(tokens) != 14):
            sys.exit("The order table requires 11 entries ")

        with open("orders.csv") as f_obj:
            f1 = findClass.Find(f_obj)
            if (f1.repeatItem(tokens[0],"OrderID") == True):
                sys.exit("This inserted data has a same ID as an existed data ")

    with open(table.lower()+"s.csv", 'a') as f_obj:
        f1 = insertClass.Insert(f_obj)
        f1.write(tokens)
