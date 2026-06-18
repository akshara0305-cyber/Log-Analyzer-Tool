# Log Analyzer Tool
A professional Bash Script for analysing system and security logs with an interactive interface.

## Features
- Interactive menu driven interface
- Log level summary (INFO, ERROR, WARNING)
- Recent error detection
- Unique IP Address extraction
- Keyword search functionality
- Build-in logging system
- Colorful and user friendly output
- Robust error handling

## Demo Screenshots

![ Demo Screenshot 1](screenshot-1.png)
![ Demo Screenshot 2](screenshot-2.png)
![ Demo Screenshot 3](screenshot-3.png)
![ Demo Screenshot 4](screenshot-4.png)

## How to Use 

### Prerequisites
- Linux System
- Basic Terminal knowledge

### Installation

```bash
git clone https://github.com/akshara0305-cyber/Log-Analyzer-Tool.git
cd Log-Analyzer-Tool
chmod u+x log_analyzer.sh

## Usage 

### Basic Usage 
./log_analyzer.sh -f filename

### Show Help 
./log_analyzer.sh -h 

## MENU OPTIONS 
1. Show Summary
2. Show Recent Errors
3. Show Unique IP Address
4. Search Keyword
5. Generate Full Report
6. Exit

## Project Structure
.
├── log_analyzer.sh          # Main script
├── reports/                 # Generated analysis reports
├── logs/                    # Tool activity logs
├── server.log               # Sample log file
├── screenshot-*.png         # Demo screenshots
└── README.md

## How It Works 
- This tool relies primarily on awk and grep for fast, dependency free text processing.
- Summary and report counts use awk pattern matching ERROR, INFO and WARNING keywords.
- IP extraction using regex pattern.
- getopts for command line parsing.

## AUTHOR
   Akshara | BCA Student 
