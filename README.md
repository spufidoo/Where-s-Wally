# Where's Wally
Bash and Powershell scripts to find files or text within files, and open them with VS Code. Or not. 

## codegrep
This searches recursively for a pattern in files under a directory, extracts the filenames with matches (once each), and opens them in VS Code. For example, I wanted to open VS Code for all programs that included "some_header.h" in them.

This first originated as a bash command:
```bash
egrep -ra $pattern $directory | awk -F':' '{print $1}' | sort -u | xargs code
```
It's now available as a bash function and a PowerShell function.
```bash
Bash usage: codegrep [-e EXT] [-c] PATTERN [DIRECTORY]
Search for a string in files within a directory.
    -e EXT   Search for files with the specified extension
    -c       Open matching files in VS Code
```
```PowerShell
PowerShell usage: codegrep -Pattern <text> [-Directory <path>] [-Extension <.ext>] [-Code]
Search for a string in files within a directory.
Example: codegrep -Pattern 'TODO' -Directory 'C:\Projects' -Extension '.txt' -Code
```

## codefind
Search for file names matching a pattern in a directory, and open them in VS Code. For example, I wanted to open VS Code for all programs that were named "*_wibble.cpp".

This also originated as a bash command:
```bash
find . -iname "$pattern" -exec code '{}'\;
```
This too is now available as a bash function and a PowerShell function.
```bash
Bash usage: codefind [-r] [-c] PATTERN [DIRECTORY]
Search for file names matching a pattern in a directory.
    -r       Use regex for pattern matching
    -c       Open matching files in VS Code
```
```PowerShell
PowerShell usage: codefind -Pattern <filename or regex> [-Directory <path>] [-Regex] [-Code]
Search for file names matching a pattern in a directory.
Example: codefind -Pattern 'TODO' -Directory 'C:\Projects' -Regex -Code
```
