import os

# Specify the directory path
directory_path = 'Icons'

# List all files in the directory
for file_name in os.listdir(directory_path):
    file_path = os.path.join(directory_path, file_name)
    if os.path.isfile(file_path):  # Check if it's a file
        print(file_name.replace(".svg", ""))