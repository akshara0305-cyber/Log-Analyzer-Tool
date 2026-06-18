#!/bin/bash

# ================================================
# Log Analyzer Tool
# Version: 1.0
# Description: Professional log analysis tool for security/system logs
# Author: Akshara
# Github: akshara0305-cyber
# ================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
LOG_FILE=""
REPORT_DIR="./reports"
LOG_DIR="./logs"
SCRIPT_LOG="${LOG_DIR}/analyzer.log"

mkdir -p "$REPORT_DIR" "$LOG_DIR"

usage() {
    echo -e "${CYAN}Usage:${NC} $0 -f <logfile>"
    echo -e "Options: "
    echo -e "  -f FILE     Log file to analyze"
    echo -e "  -h          Show help"
}

log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${timestamp} [${level}] ${message}" | tee -a "$SCRIPT_LOG"
}

log "INFO" "Log Analyzer Tool started"

validate_input() {
    if [ -z "$LOG_FILE" ] || [ ! -f "$LOG_FILE" ]; then
        log "ERROR" "Log file not found: $LOG_FILE"
        echo -e "${RED}Error: Please provide a valid log file with -f${NC}"
        usage
        exit 1
    fi
    log "INFO" "Analyzing file: $LOG_FILE"
}

show_summary() {
    echo -e "\n${CYAN}=== Log Summary ===${NC}"
    awk '
    /ERROR/   {error++}
    /INFO/    {info++}
    /WARNING/ {warn++}
    END {
        print "Total Entries    :", NR
        print "INFO             :", info+0
        print "WARNING          :", warn+0
        print "ERROR            :", error+0
    }' "$LOG_FILE"
}

show_recent_errors() {
    echo -e "\n${RED}--- Recent Errors ---${NC}"
    awk '/ERROR/' "$LOG_FILE" | tail -n 3
}

extract_ips() {
    echo -e "\n${YELLOW}--- Unique IP Addresses ---${NC}"
    awk '{for(i=1;i<=NF;i++) if($i ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/) print $i}' "$LOG_FILE" | sort | uniq
}

search_keyword() {
    read -p "Enter keyword to search: " keyword
    echo -e "\n${CYAN}--- Search Results for '$keyword' ---${NC}"
    grep -i "$keyword" "$LOG_FILE" | head -n 15 || echo "No matches found for '$keyword'."
}

generate_report() {
    local report_file="${REPORT_DIR}/analysis_report_$(date +%Y%m%d-%H%M).txt"
    
    {
        echo "=== Log Analysis Report ==="
        echo "Log File       : $LOG_FILE"
        echo "Generated On   : $(date)"
        echo "================================="
        awk '
        /ERROR/   {error++}
        /INFO/    {info++}
        /WARNING/ {warn++}
        END {
            print "Total Entries :", NR
            print "INFO          :", info+0
            print "WARNING       :", warn+0
            print "ERROR         :", error+0
        }' "$LOG_FILE"
        echo -e "\nUnique IP Addresses:"
        awk '{for(i=1;i<=NF;i++) if($i ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/) print $i}' "$LOG_FILE" | sort | uniq
    } > "$report_file"
    
    log "INFO" "Report generated: $report_file"
    echo -e "\n${GREEN}Full report saved to: $report_file${NC}"
}

interactive_menu() {
    while true; do
        echo -e "\n${CYAN}=== Log Analyzer Menu ===${NC}"
        echo "1. Show Summary"
        echo "2. Show Recent Errors"
        echo "3. Show Unique IPs"
        echo "4. Search Keyword"
        echo "5. Generate Full Report"
        echo "6. Exit"
        read -p "Choose an option (1-6): " choice

        case $choice in
            1) show_summary ;;
            2) show_recent_errors ;;
            3) extract_ips ;;
            4) search_keyword ;;
            5) generate_report ;;
            6) log "INFO" "Tool exited by user"; echo -e "${GREEN}Goodbye!${NC}"; exit 0 ;;
            *) echo -e "${RED}Invalid option! Please try again.${NC}" ;;
        esac
    done
}

# Main
while getopts "f:h" opt; do
    case $opt in
        f) LOG_FILE="$OPTARG" ;;
        h) usage; exit 0 ;;
        *) usage; exit 1 ;;
    esac
done

validate_input

echo -e "${GREEN}Log Analyzer Tool initialized...${NC}"
echo -e "Target Log File : ${CYAN}$LOG_FILE${NC}\n"

interactive_menu
