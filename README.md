# OneDriveIgnore
This project implements .onedriveignore, which is similar to .gitignore, so that Onedrive does not synchronize certain files.

## Usage

Write the file name that you do not want to be synchronized to the .onedriveignore file in the root directory of the local OneDrive storage path.

Same as .gitignore, the file content supports regular expressions.

If the .onedriveignore file does not exist, the script will automatically create one.

Here is an example:

```.onedriveignore
example0.exe
example1.*
*example2
```

**Please note that each time you modify the .onedriveignore file, you need to re-execute the script.**

## Implementation

OneDrive can desynchronize certain files by setting the registry. The registry location is `HKLM:\SOFTWARE\Policies\Microsoft\OneDrive\EnableODIgnoreListFromGPO`.
