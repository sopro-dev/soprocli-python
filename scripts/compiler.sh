#!/bin/bash

out_folders=(src/soprocli)
python_out_folder=src/soprocli
app_abs_path=/app

function print_error_and_exit() {
    echo "❌ Error occurred. Printing tree and exiting..."
    tree -aC ./pkg/ ./internal/ ./cpp ./src
    exit 1
}

echo "🧹 Cleaning up..."
rm -rf "${out_folders[@]}"/*
mkdir -p "${out_folders[@]}"

echo "🚀 Compiling the project..."
MAIN_FOLDER="internal"
list_proto_files=()

for folder in $(find "$MAIN_FOLDER" -type d); do
    if [[ $folder != $MAIN_FOLDER ]]; then
        list_proto_files+=($(find "$folder" -type f -name "*.proto"))
    fi
done

echo "📜 List of proto files:"
for file in "${list_proto_files[@]}"; do
    echo $file
done

echo "🌀 Compiling Python..."
cd "$app_abs_path"
for file in "${list_proto_files[@]}"; do
    file_name=$(basename "$file")
    current_folder_name=$(dirname "$file" | xargs basename)

    cd "$app_abs_path/$MAIN_FOLDER/$current_folder_name"
    echo "⌛️ Compiling $file_name python"
    protoc --python_out=. --grpc_out=. --plugin=protoc-gen-grpc=/usr/local/bin/grpc_python_plugin "$file_name"

    if [ $? -eq 0 ]; then
        echo "✅ Compiled $file_name"
    else
        echo "❌ Failed to compile $file_name"
        print_error_and_exit
    fi

    tree -L 2 || print_error_and_exit

    echo "👨🏽‍🔧 Moving Python files to output folder..."
    python_files=$(find . -name \*_pb2.py -o -name \*_pb2_grpc.py)
    if [ -n "$python_files" ]; then
        mv -v $python_files "$app_abs_path/$python_out_folder"
    else
        echo "❌ No Python files found to move."
    fi
    tree -L 2 || print_error_and_exit

    cd "$app_abs_path"
done

echo "⭐ Finished compiling the project ⭐"
tree -aC ./internal/ ./src
echo "🌐 Pipeline design: Python"
