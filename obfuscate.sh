#!/bin/bash

echo "Enter the path of the file you want to obfuscate:"
read file_path

if [ ! -f "$file_path" ]; then
  echo "Error: $file_path is not a file."
  exit 1
fi

echo "Enter the new name for the obfuscated file:"
read new_name

dir_path="$(dirname "$file_path")"
key="$(date | md5sum | cut -d' ' -f1)"
encoded_code=$(cat "$file_path" | openssl enc -aes-256-cbc -pbkdf2 -base64 -k "$key")

output_file="$dir_path/$new_name"

cat > "$output_file" << EOF
#!/bin/bash
key="$key"
encoded_code="$encoded_code"
eval "\$(echo "\$encoded_code" | openssl enc -d -aes-256-cbc -pbkdf2 -base64 -k "\$key")"
EOF

chmod +x "$output_file"

echo "File $file_path has been obfuscated and saved as $output_file."
