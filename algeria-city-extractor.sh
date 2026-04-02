#!/bin/bash

# Algeria City Extractor
# A grep-based utility to extract Algerian city/wilaya names from text-based files
# Supports: .txt, .csv, .sql, .json, .log, and any other text format
# Handles multiple spelling variations and diacritic combinations
# Automatically creates output files with extracted results

# Usage: ./algeria-city-extractor.sh <input_file> [--no-output] [--stdout-only] [--case-sensitive]
# Example: ./algeria-city-extractor.sh mydata.txt
#          ./algeria-city-extractor.sh mydata.txt --no-output
#          ./algeria-city-extractor.sh mydata.txt --case-sensitive

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
ORANGE='\033[0;33m'
BRIGHT_RED='\033[1;31m'
NC='\033[0m' # No Color

# Default options
NO_OUTPUT=false
STDOUT_ONLY=false
CASE_SENSITIVE=false

# Parse arguments
INPUT_FILE=""
for arg in "$@"; do
    case "$arg" in
        --no-output)
            NO_OUTPUT=true
            ;;
        --stdout-only)
            STDOUT_ONLY=true
            ;;
        --case-sensitive)
            CASE_SENSITIVE=true
            ;;
        *)
            if [ -z "$INPUT_FILE" ]; then
                INPUT_FILE="$arg"
            fi
            ;;
    esac
done

# Validate input
if [ -z "$INPUT_FILE" ]; then
    echo -e "${RED}Usage:${NC} $0 <input_file> [--no-output] [--stdout-only] [--case-sensitive]"
    echo ""
    echo -e "${ORANGE}Options:${NC}"
    echo "  --no-output       Don't create output files, only display to stdout"
    echo "  --stdout-only     Same as --no-output (alias)"
    echo "  --case-sensitive  Match city names with exact case sensitivity"
    echo ""
    echo -e "${CYAN}Examples:${NC}"
    echo "  $0 data.txt"
    echo "  $0 data.txt --no-output"
    echo "  $0 data.txt --case-sensitive"
    exit 1
fi

if [ ! -f "$INPUT_FILE" ]; then
    echo -e "${RED}Error: File '$INPUT_FILE' not found${NC}"
    exit 1
fi

# Create output directory if needed
OUTPUT_DIR="algerian-cities-results"
if [ "$NO_OUTPUT" = false ] && [ "$STDOUT_ONLY" = false ]; then
    if [ ! -d "$OUTPUT_DIR" ]; then
        mkdir -p "$OUTPUT_DIR"
        echo -e "${GREEN}✓ Created output directory: $OUTPUT_DIR${NC}"
    fi
fi

# Generate output filename with timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BASE_FILENAME=$(basename "$INPUT_FILE" | sed 's/\.[^.]*$//')
OUTPUT_FILE="$OUTPUT_DIR/${BASE_FILENAME}_matches_${TIMESTAMP}.txt"
STATS_FILE="$OUTPUT_DIR/${BASE_FILENAME}_stats_${TIMESTAMP}.txt"

# Grep pattern to match Algerian cities/wilayas
# Matches variations including:
# - Major cities (Algiers, Oran, Constantine, etc.)
# - All 58 Algerian wilayas
# - Common spelling variations (accents, apostrophes, hyphens, underscores)
# - Word boundaries using character class negation

PATTERN="(^|[^[:alnum:]])(Algiers|Alger|M[iï]la|Adrar|Oran|Laghouat|Batna|B[eé]ja[iï]a|Biskra|Blida|Bouira|Tamanrasset|T[eé]?bessa|Tlemcen|Tiaret|Djelfa|J[iï]jel|Skikda|Annaba|Gharda[iï]a|Gu[ae]lma|Mosta?gh?anem|Ouargla|Ouahran|Illizi|Boumerdes|Tindouf|Tipp?aza|R[ie]lizane?|Ghilizane?|Médéa|El[[:space:]_-]+Bayadh|Touggourt|Wahran|Khenche?la|Chlef|S[eé]tif|In[[:space:]_-]+Guezzam|In[[:space:]_-]+Salah|Oum[[:space:]_-]+El[[:space:]_-]+Bouaghi|Tizi[[:space:]_-]+Ouzou|Sidi[[:space:]_-]+Bel[[:space:]_-]+Abb[eé]s|Bordj[[:space:]_-]+Bou[[:space:]_-]+Arr[eé]ridj|El[[:space:]_-]+Tare?f|A[iï]n[[:space:]_-]+Defla|A[iï]n[[:space:]_-]+T[eé]mouchent|Tissemsile?t|El[[:space:]_-]+Oued|Na[aâ]ma|Souk[[:space:]_-]+Ahras|El[[:space:]_-]+Meniaa|Ouled[[:space:]_-]+Djellal|Bordj[[:space:]_-]+Badji[[:space:]_-]+Mokhtar|B[eé]ni[[:space:]_-]+Abb[eé]s|A[iï]n[[:space:]_-]+Salah|A[iï]n[[:space:]_-]+Guezzam|Constantine|Sa[ïi]da|Mascara|B[eé]char|Timimoun|Djanet)([^[:alnum:]]|$)|(^|[^[:alnum:]])M['']Sila([^[:alnum:]]|$)|(^|[^[:alnum:]])El[[:space:]_-]+M['']Ghair([^[:alnum:]]|$)"

# Determine grep flags based on case-sensitive option
if [ "$CASE_SENSITIVE" = true ]; then
    GREP_FLAGS="-E"
else
    GREP_FLAGS="-iE"
fi

# Run grep and capture results
MATCHES=$(grep $GREP_FLAGS "$PATTERN" "$INPUT_FILE")
MATCH_COUNT=$(echo "$MATCHES" | grep -c . 2>/dev/null || echo 0)
TOTAL_LINES=$(wc -l < "$INPUT_FILE")

# Display results to stdout
echo -e "${ORANGE}════════════════════════════════════════${NC}"
echo -e "${CYAN}Algeria City Extractor - Results${NC}"
echo -e "${ORANGE}════════════════════════════════════════${NC}"
echo -e "Input file: ${ORANGE}$INPUT_FILE${NC}"
echo -e "Total lines: ${ORANGE}$TOTAL_LINES${NC}"
echo -e "Matched lines: ${GREEN}$MATCH_COUNT${NC}"
if [ "$MATCH_COUNT" -gt 0 ]; then
    PERCENT=$(awk "BEGIN {printf \"%.2f\", ($MATCH_COUNT * 100 / $TOTAL_LINES)}")
else
    PERCENT="0.00"
fi

# Format percentage to remove unnecessary decimals
if [[ $PERCENT == *.00 ]]; then
    # Remove .00 if it's a whole number (X.00% -> X%)
    FORMATTED_PERCENT=${PERCENT%.00}
elif [[ $PERCENT == *0 ]] && [[ $PERCENT != *.0 ]]; then
    # Remove trailing 0 if it ends in 0 but not .0 (X.X0% -> X.X%)
    FORMATTED_PERCENT=${PERCENT%0}
else
    FORMATTED_PERCENT=$PERCENT
fi

echo -e "Match rate: ${BRIGHT_RED}${FORMATTED_PERCENT}%${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo ""

if [ "$MATCH_COUNT" -gt 0 ]; then
    echo -e "${CYAN}Matched Lines:${NC}"
    echo -e "${ORANGE}────────────────────────────────────────${NC}"
    echo "$MATCHES" | nl -w2 -s'. '
    echo -e "${ORANGE}────────────────────────────────────────${NC}"
    echo ""
else
    echo -e "${BRIGHT_RED}⚠ No matches found${NC}"
    echo ""
fi

# Save to output file if not disabled
if [ "$NO_OUTPUT" = false ] && [ "$STDOUT_ONLY" = false ]; then
    # Save matched lines
    echo "$MATCHES" > "$OUTPUT_FILE"
    echo -e "${GREEN}✓ Matched lines saved to: $OUTPUT_FILE${NC}"
    
    # Create statistics file
    cat > "$STATS_FILE" << EOF
Algerian City Detector - Statistics Report
Generated: $(date)
Input file: $INPUT_FILE

Summary:
--------
Total lines in file: $TOTAL_LINES
Matched lines: $MATCH_COUNT
Match percentage: ${PERCENT}%

Matched Lines with Line Numbers:
EOF
    
    echo "$MATCHES" | nl -w4 -s'. ' >> "$STATS_FILE"
    
    echo -e "${GREEN}✓ Statistics saved to: $STATS_FILE${NC}"
    echo ""
    echo -e "${CYAN}Output files created in: ${ORANGE}${OUTPUT_DIR}/${NC}"
else
    echo -e "${ORANGE}(Output file creation disabled)${NC}"
fi
