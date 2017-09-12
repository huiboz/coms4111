import csv

def csv_writer(data, path):
    """
    Write data to a CSV file path
    """
    with open(path, "wb") as csv_file:
        writer = csv.writer(csv_file, delimiter=',')
        for line in data:
            writer.writerow(line)


fields=['123','321','2342342342']
with open('output.csv', 'a') as f:
    writer = csv.writer(f)
    writer.writerow(fields)
