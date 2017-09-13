# hw1a_4111

accept "find" and "insert" database operation on .csv files

The program will check if the input arguments are valid (It should contain Find/Insert + Table Name + at least one more input argument to be valid)

The operation must be either "find" or "insert", the table name must be either "customer" or "order". These are all not case sensitive.

For "Find" operation, the format is: find tablename condition1, condition2, condition3... Each condition should be follow by a comma and a space except for the last condition and must contain an "=" sign without other spaces around it. Note that the content should be quoted by "" if it contains a space. For example, CompanyName="Bon app'". Also, the condition term is case sensitive. The program will report corresponding error message if it detects wrong input format. During the finding process, the main program will invoke "findClass.py". It would firstly verify that the column name is valid. Then, it would either output the result or report to command window that it does not find any match result.

For "Insert" operation, the format is: insert tablename ("xxx","xxx","xxx"...). All the entries must stay inside the parentheses. For "customer" table, the total entries should be 11. For "order" table, the total entries should be 14. The main program will report format error if found. After checking the format, it will invoke "findClass.py" and check if the ID for this entry already exists in the table or not. If yes, exit the program. If not, invoke "insertClass.py" and insert the entry to the table.




parentheses are interpreted as special characters
