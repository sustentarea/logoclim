# NetLogo pathdir Extension
Version 5.2 - September 2025 (for NetLogo v7)

* [What is it?](#what-is-it)
* [Installation](#installation)
* [Examples](#examples)
* [Primitives](#primitives)
* [Author](#author)
* [Feedback](#feedback-bugs-feature-requests)
* [Credits](#credits)
* [Terms of use](#terms-of-use)

## What is it?

This package contains the NetLogo **pathdir extension**, which provides NetLogo with some file-related primitives not included in the standard language, particularly primitives related to manipulating directories, identifying the current NetLogo model, moving files, finding the size and modification dates of files, and getting the values of environment variables and system properties.

[back to top](#netlogo-pathdir-extension)

## Installation

Include the extension in your NetLogo model using the **extensions** primitive. It should be the first line in your model. (If there are already other extensions in your model, simply add *pathdir* to the list.)

    extensions [pathdir]

If the extension has not yet been installed, NetLogo will prompt you to install it and, upon your replying in the affirmative, will download the extension and its associated files to the appropriate location.

For more information on NetLogo extensions:
[http://ccl.northwestern.edu/netlogo/docs/extensions.html](http://ccl.northwestern.edu/netlogo/docs/extensions.html)

[back to top](#netlogo-pathdir-extension)

## Examples

See the **PathDir.nlogox** model for examples of usage.


[back to top](#netlogo-pathdir-extension)

## Primitives

**pathdir:get-separator**
**pathdir:get-file-separator**

*pathdir:get-separator*
*pathdir:get-file-separator*

Returns a string with the character used by the host operating system to separate directories in a given path.  E.g., for Windows the string "\\\" would be returned (as the backslash must be escaped), while for Mac OSX and linux, the string "/" would be returned.  Useful for creating operating system-independent paths to files.

---------------------------------------

**pathdir:get-path-separator**

*pathdir:get-path-separator**

Returns a string with the character used by the host operating system to separate paths in a list of paths, such as in Windows "PATH" environmental variable or in java.library.path. 
E.g., for Windows the string ";" would be returned while for Mac OSX and linux, the string ":" would be returned.  Useful for creating operating system-independent lists of paths.

---------------------------------------

**pathdir:get-model-path**

*pathdir:get-model-path*

Returns a string with the full (absolute) path to the directory in which the current model is located.

NOTE: Returns an empty string ("") if the current model has not yet been saved to a file.

---------------------------------------

**pathdir:get-model-file**

*pathdir:get-model-file*

Returns a string with the filename of the .nlogox or .nlogo3dx file containing the current model. 

NOTE: Returns an empty string ("") if the current model has not yet been saved to a file.

Stripping the .nlogox extension  (or any extension) is easily done:

    let modelName pathdir:get-model-name
    let shortName substring modelName 0 (length modelName - position "." reverse modelName - 1)
(Note that the code above can handle filenames with embedded periods.)

The model filename can also be concatenated with the path to it:

    let fullModelPath (word pathdir:get-model pathdir:get-separator pathdir:get-model-name)

---------------------------------------
**pathdir:get-model-name**

*pathdir:get-model-name*

Returns a string with the name of the current model. NetLogo sets the name of the model to the filename of the .nlogox or .nlogo3dx file containing the model, stripped of the file extension.

NOTE: Returns an empty string ("") if the current model has not yet been saved to a file, although NetLogo calls an unsaved model "Untitled".

---------------------------------------

**pathdir:get-home-path**

*pathdir:get-home-path*

Returns a string with the full (absolute) path to the user's home directory, as specified by the "user.home" environment variable of the host operating system.  This may not exist for all operating systems?

---------------------------------------

**pathdir:get-CWD-path**

*pathdir:get-CWD-path*

Returns a string with the full (absolute) path to the current working directory (CWD) as specified in the NetLogo context for the current model.  The CWD may be set by the NetLogo command set-current-directory.  Note that set-current-directory will accept a path to a directory that does not actually exist and subsequently using the nonexistent CWD, say to open a file, will normally cause an error.  Note too that when a NetLogo model first opens, the CWD is set to the directory from which the model is opened.

---------------------------------------

**pathdir:get-extn-path**

*pathdir:get-extn-path*

Returns the path to the directory where NetLogo places un-bundled extensions, i.e., those installed by the Extension Manager. The location varies by platform.

---------------------------------------

**pathdir:get-env-var**

*pathdir:get-env-var environment_variable*

Returns the value of the specified environment variable in the user's environment, e.g., the value of the PATH variable. The list of standard environment variables varies by platform and the user can add new variables. Sometimes this is useful if one has a variable/value that one wants to set externally to NetLogo and then have the model "import".

If *environment_variable* is an empty string, i.e., "", the primitive returns a list of strings containing all the environment variables. Each element of the list is a string with the name of an environment variable followed by a colon and a blank, and then the variables value.

---------------------------------------

**pathdir:get-sys-property**

*pathdir:get-sys-property system_property*

Returns the valuee of the specified system property in the user's environment, e.g., the name of the operating system, "os-name". The list of standard system properties varies by platform.

If *system_property* is an empty string, i.e., "", the primitive returns a list of strings containing all the system properties. Each element of the list is a string with the name of a property followed by a colon and a blank, and then the property value.

---------------------------------------

**pathdir:create**

*pathdir:create directory-string*

Creates the directory specified in the given string.  If the string does not contain an absolute path, i.e. the path does not begin at the root of the file system, then the directory is created relative to the current working directory.  Note that this procedure will create as many intermediate directories as are needed to create the last directory in the path.  So, if one specifies 

    pathdir:create "dir1\\dir2\\dir3" 

(using Windows path syntax) and if dir1 does not exist in the CWD, then the procedure will create dir1 in the CWD, dir2 in dir1, and finally dir3 in dir2.  If the directory to be created already exists, then no action is taken.

---------------------------------------

**pathdir:isDirectory?**

*pathdir:isDirectory? directory-string*

Returns TRUE if the file or directory given by the string both exists **and** is a directory.  Otherwise, returns FALSE.  (Note that the NetLogo command file-exists? can be used to see if a file or directory simply exists, but does not distinguish between files and directories.)  If the path given by the string is not an absolute path, i.e., it does not begin at the root of the file system, then the path is assumed to be relative to the current working directory.

---------------------------------------

**pathdir:list**
**pathdir:list-sorted**

*pathdir:list directory-string*

Returns a NetLogo list of strings, each element of which contains an element of the directory listing of the specified directory. The listing is sorted according to the operating system.  Windows is case insensitive.  Linux and IOS are not.  If the path given by the string is not an absolute path, i.e., it does not begin at the root of the file system, then the path is assumed to be relative to the current working directory.  If the directory is empty, the command returns an empty list.  To get a listing of the CWD one could use 

    pathdir:list pathdir:get-CWD-path 

or, more simply, 

    pathdir:list ""

*pathdir:list-sorted directory-string*

Works as above, but returns a case-insensitive sorted directory list.
	
---------------------------------------

**pathdir:move**

*pathdir:move string1 string2*

Moves or simply renames the file or directory given by string1 to string2.  If either string does not contain an absolute path, i.e., the path does not begin at the root of the file system, then the path is assumed to be relative to the current working directory.  E.g.,
 
    let sep pathdir:get-separator    
    pathdir:move (word "dir1" sep "file1.csv") (word pathdir:get-home sep "keep.csv")

will rename and move the file "file1.csv" in dir1 of the CWD to "keep.csv" in the user's home directory.  If a file with the same name already exists at the destination, an error is returned.

---------------------------------------

**pathdir:delete**

*pathdir:delete directory-string*

Deletes the directory given by the string.  The directory must be empty and must not be hidden.  (**The check for a read-only directory currently does not work. Be careful!**)  If the path given by the string is not an absolute path, i.e., it does not begin at the root of the file system, then the path is assumed to be relative to the current working directory.  This command will return an error if the path refers to a file rather than a directory as there already is a NetLogo command for deleting a file: file-delete. Use pathdir:isDirectory? if there is any doubt. 

--------------------------------------

**pathdir:get-size**

*pathdir:get-size file-string*

Returns the size in bytes of the file given by the string. If the path given by the string is not an absolute path, i.e., it does not begin at the root of the file system, then the path is assumed to be relative to the current working directory.

--------------------------------------

**pathdir:get-date**

*pathdir:get-date file-string*

Returns the modification date of the file given by the string. The date is returned as a string in the form dd-MM-yyyy HH-mm-ss, where dd is the day in the month, MM the month in the year, yyyy the year, HH the hour in 24-hour time, mm the minute in the hour and ss the second in the minute. If the path given by the string is not an absolute path, i.e., it does not begin at the root of the file system, then the path is assumed to be relative to the current working directory.

--------------------------------------

**pathdir:get-date-ms**

*pathdir:get-date-ms file-string*

Returns the modification date of the file given by the string. The date is returned as the number of milliseconds since the base date of the operating system, making it easy to compare dates down to the millisecond. This time format is useful for comparing the modification dates of two files. If the path given by the string is not an absolute path, i.e., it does not begin at the root of the file system, then the path is assumed to be relative to the current working directory.

---------------------------------------

[back to top](#netlogo-pathdir-extension)


## Author

Charles Staelin<br>
Smith College<br>
Northampton, MA 01063

## Feedback? Bugs? Feature Requests?

Please visit the [github issue tracker](https://github.com/cstaelin/Pathdir-Extension/issues?state=open) to submit comments, bug reports, or feature requests.  I'm also more than willing to accept pull requests.

## Credits

Many thanks to the NetLogo developers and the NetLogo user community for answering my questions and suggesting  additional features.

## Terms of Use

[![CC0](http://i.creativecommons.org/p/zero/1.0/88x31.png)](http://creativecommons.org/publicdomain/zero/1.0/)

The NetLogo pathdir extension is in the public domain.  To the extent possible under law, Charles Staelin has waived all copyright and related or neighboring rights. For more information please refer to the `licence.md` file accompanying this release.

[back to top](#netlogo-pathdir-extension)
