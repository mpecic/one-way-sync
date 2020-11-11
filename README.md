# One way sync with bash

Syncs files in source dir to destination dir recursively, with following rules:

* match on filenames and sizes
* if source file found on destination:
  * if in same dir, do nothing
  * if in different dir, move it to same dir as source
* if source file not found on destination, copy it to same dir as source
* create missing dirs on destination if necessary
* remove files on destination if no match on source

Script doesn't actually do anything, only outputs linux shell commands.

Usage:
```
 sync.sh [src] [dest]
```
