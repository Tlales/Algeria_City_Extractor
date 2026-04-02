# Algerian Wilaya Extractor

A powerful grep-based utility to extract and identify Algerian cities and wilayas (provinces) from any text-based files. Perfect for data processing, geolocation extraction, and text analysis.

**Supported file formats:** `.txt`, `.csv`, `.sql`, `.json`, `.log`, `.xml`, and any other text-based format.

## Features

✨ **Comprehensive City Coverage**
- All 58 Algerian wilayas (provinces)
- Major cities and alternative names
- Multiple spelling variations (French, Arabic-influenced, transliteration differences)

🔤 **Smart Pattern Matching**
- Handles French and Local Algerian-influenced spelling variations ✅
- Supports diacritical marks: é, ï, â
- Recognizes city names with separators: spaces, hyphens, underscores, apostrophes
- Case-insensitive matching (with optional case-sensitive mode) ✅
- Proper word boundary detection to avoid false positives ✅
- Works across multiple lines in structured data ✅

📁 **Automatic Output Files**
- Creates timestamped output files in `algerian-cities-results/` directory
- Generates matched lines file with full line content
- Generates statistics file with match counts and precise percentages
- Optional: disable file output with `--no-output` flag

🎨 **Smart Color Output**
- Readable color scheme optimized for terminal viewing
- Distinct colors for different sections and information types
- Supports standard ANSI color terminals

## Installation

1. Clone the repository:
```bash
git clone https://github.com/Tlales/Algerian-Data-Extraction.git
cd Algerian-Data-Extraction
```

2. Make the script executable:
```bash
chmod +x algeria-city-extractor.sh
```

## Usage

### Basic Usage
```bash
./algeria-city-extractor.sh <input_file>
```

### Options
- `--no-output` or `--stdout-only` - Display results only in terminal, don't create output files
- `--case-sensitive` - Match city names with exact case sensitivity (default: case-insensitive)

### Examples

#### Standard Usage with Text File (Creates Output Files)
```bash
./algeria-city-extractor.sh data.txt
```

#### CSV File Processing
```bash
./algeria-city-extractor.sh addresses.csv
```

#### SQL File Analysis
```bash
./algeria-city-extractor.sh database_dump.sql
```

#### JSON Data Extraction
```bash
./algeria-city-extractor.sh export.json
```

#### Display Only (No Files)
```bash
./algeria-city-extractor.sh data.txt --no-output
```

#### Case-Sensitive Matching
```bash
# Only matches exact capitalization
./algeria-city-extractor.sh data.txt --case-sensitive
```

#### Combine Options
```bash
./algeria-city-extractor.sh data.csv --case-sensitive --no-output
```

#### Process Multiple Files
```bash
for file in *.csv *.txt *.sql; do
    ./algeria-city-extractor.sh "$file"
done
```

#### Chain with Other Commands
```bash
./algeria-city-extractor.sh myfile.txt --no-output | grep -v "^#"
```

#### Count Total Matches
```bash
for file in *.txt; do
    echo "$file: $(./algeria-city-extractor.sh "$file" --no-output | wc -l) matches"
done
```

## Supported Cities/Wilayas

The script recognizes all 58 Algerian wilayas including:

### Major Northern Cities
- Algiers (Alger)
- Oran (Wahran, Ouahran)
- Constantine
- Annaba
- Skikda
- Blida
- Béjaïa
- Jijel
- And many more...

### Southern Regions
- Tamanrasset
- In Guezzam
- In Salah
- Illizi
- Djanet
- And others...

### Central Wilayas
- Médéa
- Bouira
- Tizi Ouzou
- Kabylie region
- And more...

## Example Output

### Input File (`data.txt`)
```
I visited Algiers last summer.
My friend lives in Constantine.
We drove through Ouargla and Ghardaia.
The city of Oran is famous for its beaches.
```

### Command
```bash
./algeria-city-extractor.sh data.txt --no-output
```

### Terminal Display
```
════════════════════════════════════════
Algeria City Extractor - Results
════════════════════════════════════════
Input file: data.txt
Total lines: 4
Matched lines: 4
Match rate: 100%
════════════════════════════════════════

Matched Lines:
────────────────────────────────────────
 1. I visited Algiers last summer.
 2. My friend lives in Constantine.
 3. We drove through Ouargla and Ghardaia.
 4. The city of Oran is famous for its beaches.
────────────────────────────────────────
```

### Generated Files (when not using --no-output)

**`data_matches_20260402_143022.txt`**
```
I visited Algiers last summer.
My friend lives in Constantine.
We drove through Ouargla and Ghardaia.
The city of Oran is famous for its beaches.
```

**`data_stats_20260402_143022.txt`**
```
Algeria City Extractor - Statistics Report
Generated: Thu Apr 02 14:30:22 UTC 2026
Input file: data.txt

Summary:
--------
Total lines in file: 4
Matched lines: 4
Match percentage: 100%

Matched Lines with Line Numbers:
   1. I visited Algiers last summer.
   2. My friend lives in Constantine.
   3. We drove through Ouargla and Ghardaia.
   4. The city of Oran is famous for its beaches.
```

## File Format Support

### CSV Files
Perfect for extracting location data from customer lists, addresses, or geographic datasets:
```bash
./algeria-city-extractor.sh customers.csv
```

### SQL Dumps
Analyze database exports for city/wilaya references:
```bash
./algeria-city-extractor.sh database_backup.sql
```

### JSON Files
Extract cities from API responses or data exports:
```bash
./algeria-city-extractor.sh api_response.json
```

### Log Files
Find location references in application logs:
```bash
./algeria-city-extractor.sh application.log
```

### XML Files
Parse structured data for city mentions:
```bash
./algeria-city-extractor.sh data.xml
```

## Requirements

- **Bash** (version 3.0+)
- **grep** with extended regex support (`grep -E`)
- **awk** for percentage calculations
- Unix-like environment (Linux, macOS, WSL on Windows)

### System Compatibility
- ✅ Linux (Ubuntu, CentOS, Debian, etc.)
- ✅ macOS
- ✅ WSL (Windows Subsystem for Linux)
- ✅ Git Bash on Windows (MSYS2)
- ⚠️ Pure Windows Command Prompt (requires WSL or cygwin❗)

## Performance Considerations

- **File Size**: Optimized for files up to several GB
- **Regex Complexity**: The pattern is comprehensive but scales well
- **Memory Usage**: Minimal; uses standard grep line-by-line processing

For very large datasets (>10GB), consider splitting the input:
```bash
split -l 1000000 largefile.txt chunk_
for chunk in chunk_*; do
    ./algeria-city-extractor.sh "$chunk"
done

# Combine results
cat algerian-cities-results/*_matches_*.txt > all_matches.txt
```

## Advanced Usage

### Extract Only Lines with Multiple Cities
```bash
./algeria-city-extractor.sh data.csv --no-output | awk -F',' 'NF>1'
```

### Find Cities with Context (surrounding lines)
```bash
./algeria-city-extractor.sh data.txt --no-output | head -c 500
```

### Filter Results by Specific Cities
```bash
./algeria-city-extractor.sh data.txt --no-output | grep -i "algiers|oran|constantine"
```

### Combine with Data Processing
```bash
./algeria-city-extractor.sh export.csv --no-output | \
  awk -F',' '{print $1, $2}' | \
  sort | uniq -c | sort -rn
```

## Troubleshooting

### Output Files Not Created
- Check that the script has write permissions in the current directory
- The `algerian-cities-results/` directory will be created automatically
- Use `--no-output` if you only want terminal display

### Script doesn't execute
```bash
# Make sure it's executable
chmod +x algeria-city-extractor.sh

# Run with explicit bash
bash algeria-city-extractor.sh myfile.txt
```

### No matches found
- Check that your input file uses UTF-8 encoding for diacritical marks
- Verify the city names in your file match the supported variations
- City names may need to be separated by whitespace or punctuation
- Try with `--no-output` to see terminal output directly

### Encoding Issues
If you see garbled characters with accents:
```bash
# Convert file to UTF-8
iconv -f ISO-8859-1 -t UTF-8 input.txt > input_utf8.txt
./algeria-city-extractor.sh input_utf8.txt
```

### Colors Not Displaying Correctly
- Standard ANSI color codes are used
- If colors don't appear, your terminal may not support ANSI colors
- Use `--no-output` or redirect output to see raw text

## Use Cases

### 📊 Data Analysis ✅
Extract location data from customer databases, surveys, or geographic datasets to understand regional distribution.

### 🔍 Text Mining ✅
Analyze logs, documents, or data dumps to identify all mentions of Algerian locations.

### 📋 Data Validation ✅
Verify that location data in datasets uses recognized Algerian city names.

### 🗺️ Geolocation Processing ✅
Pre-process text data for geolocation tagging and geographic analysis.

### 📈 Business Intelligence ✅
Extract location information from sales data, customer feedback, or market research.

## Contributing

Contributions are welcome! To add more Wilayas, improve the pattern, or suggest enhancements:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Test your changes with various file types and city variations
4. Submit a pull request with a description of improvements

### Areas for Contribution
- Adding more city name variations
- Improving regex patterns for better matching
- Performance optimizations for large files
- Documentation improvements
- Additional file format examples

## Author

Created for efficient Algerian geolocation data extraction.

## Repository

🔗 **GitHub**: https://github.com/Tlales/Algerian-Data-Extraction

## Support

For issues, questions, or suggestions:
- Open an Issue on GitHub
- Submit a Pull Request with improvements

---

**Last Updated**: April 2026
**Version**: 1.0.0
