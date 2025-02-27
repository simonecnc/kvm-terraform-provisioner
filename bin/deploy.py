import csv
import subprocess
import os

# Path of the CSV file within the project in the data folder
script_dir = os.path.dirname(os.path.abspath(__file__))
project_path = os.path.abspath(os.path.join(script_dir, ".."))
csv_file = os.path.join(project_path, "data", "vm_list.csv")

# Verify if CSV exists
if not os.path.exists(csv_file):
    raise FileNotFoundError(f"File CSV non trovato: {csv_file}")

# Reads the CSV file and ignores the first line (header)
with open(csv_file, newline='') as file:
    reader = csv.reader(file)
    next(reader)  # Skip the header
    
    for row in reader:
        if len(row) < 5:
            print(f"Row ignored, insufficient data: {row}")
            continue
        
        campo1, campo2, campo3, campo4, campo5 = row[:5]
        
        # Run the create_vm.sh command with the parameters
        subprocess.run(["./create_vm.sh", campo1, campo2, campo3, campo4, campo5])
