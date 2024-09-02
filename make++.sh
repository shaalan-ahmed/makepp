#!/bin/bash

# Check if a string argument is provided
if [ -z "$1" ]; then
    echo "No name provided"
    exit 1
fi

# Check if the directory already exists
if [ -d "$1" ]; then
    echo "'$1' already exists"
    exit 1
fi

# Create the main directory with the provided name
mkdir "$1"

# Create the subdirectories inside the main directory
mkdir "$1/Main" "$1/Classes" "$1/Commands" "$1/Declarations"

# Create the main.cpp file in the Main subdirectory with the inclusion of declarations.h
cat << 'EOF' > "$1/Main/main.cpp"
#include "../Declarations/declarations.h"

int main () {
    
    
    return 0;
}
EOF

# Create the declarations.h and declarations.cpp files inside the Declarations directory
cat << 'EOF' > "$1/Declarations/declarations.h"
#pragma once

EOF

cat << 'EOF' > "$1/Declarations/declarations.cpp"
#include "declarations.h"

EOF

# Create the newClass.sh script inside the Commands directory
cat << 'EOF' > "$1/Commands/newClass.sh"
create_folder_and_files() {
  local folder_name="$1"

  if [ -d "$folder_name" ]; then
    echo "Class '$folder_name' already exists."
    return 1
  fi

  mkdir -p "../Classes/$folder_name"

  touch "../Classes/$folder_name/$folder_name.h"
  echo "#pragma once" > "../Classes/$folder_name/$folder_name.h"

  touch "../Classes/$folder_name/$folder_name.cpp"
  echo "#include  \"$folder_name.h\"" > "../Classes/$folder_name/$folder_name.cpp"
}

folder_name="${1:-}"

if [ -z "$folder_name" ]; then
  echo "Class name required"
  exit 1
fi

create_folder_and_files "$folder_name"
EOF

# Create the make.sh script inside the Commands directory
cat << 'EOF' > "$1/Commands/make.sh"
#!/bin/bash

clear

compiler=g++

main=../Main/main.cpp
declarations=../Declarations/declarations.cpp

executable=main

list="$declarations "

for entry in ../Classes/*; do
  if [ -d "$entry" ]; then
    filename="${entry}/${entry##*/}.cpp"
    list+="$filename "
  fi
done

$compiler $main $list -o $executable

./$executable

rm $executable
EOF

# Make the scripts executable
chmod +x "$1/Commands/newClass.sh" "$1/Commands/make.sh"

cd $1
