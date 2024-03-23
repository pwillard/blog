
# Color Computer Development Environment on Windows

If you’ve never tried to write 6×09 assembly language programming for the Radio Shack Color Computer before, now it’s easier than ever before. While you can use a native editor assembler, like Robert Gault’s 6×09 patches to Tandy’s DISK EDTASM (which is excellent, by the way), its probably a lot simpler to just write the code in your favorite editor and then use a cross-compiler such as LWASM to assemble your code on your PC.

You can then use programs from the cross development TOOLSHED to copy your local binaries to a virtual floppy and test your work on one of the virtual color computer emulators such as Xroar, VCC or MAME.

When I started to learn assembly language programming, my biggest hurdle was finding out how to set up the various graphics modes available to the Color Computer. I mean, after a few tests, the 32 column screen with eye piercing radium green background you really end up wanting alternatives.

## The LWASM Toolset

The Assembler, LWASM is part of the LWTOOLS distribution (along with documentation) found at: http://www.lwtools.ca/. LWASM is  used to compile your MC6809 assembly language code into object code that can be loaded into the Color Computer. Its simple to use and with some command line arguments you can get it to produce output in the formats required by the various Color Computer versions as well as emulators.

### Formats

Here are some of the output options available.

RAW - Just a binary file containing the assembled code.

DECB - A binary file containing the assembled code with the DEC BASIC header added so you can use LOADM to load it into the Color Computer.

Motorola S-Record - This is a legacy format standard, often used by EPROM programmers.

Intel HEX - This is a different format standard, also often used by EPROM programmers.

0S9 - This is a format used by OS9 for the 6×09 modules.

### Command line options for LWASM

--6309  - Assemble for use with the 6309
--6800compat  - Assemble for use with the 6800 compatibility mode
--6809  - Assemble for use with the 6809 and will work if you have a 6309 as well
--decb - Add the DEC BASIC header to the output
--format=_type_     - Specify the output format, IE decb, os9, raw, srec, or ihex
--list - Generate a listing file (if supplied with a filename) to STDOUT
--output - Specify the output filename (if not supplied, `a.out` is used)

There are also some other options, but these are the ones I use most often. There are also single letter equivalents for these options that you can find by asking for help by typing `lwasm --help`.

## Installing LWTOOLS 

If you use Windows, look for the appropriate pre-compiled windows binaries zip file at

http://www.lwtools.ca/contrib/tormod/

TOOLSHED is found at : https://sourceforge.net/projects/toolshed/files/

## Running the Assembler

For a quick test, you can use the LWASM command line tool to assemble a simple program. You will supply the filename of the source file and the filename of the output file. For example, to assemble the file `hello.asm` and produce an output file called `hello.bin`, you would type: `lwasm --decb hello.asm --output hello.bin`.

If you would also like an Assembled listing, you would add the list option... `lwasm --decb --list hello.asm --output hello.bin`.

If you feel ambitious, you can install GNUmake for Windows. You should not need to install the full MinGW distribution, just the `make` utility which you can find with a Google search.  Creating a `Makefile` for you projects is a great way to automate the process of assembling your code.

IE: 

```

#Specify Directory Lister
LS=ls

#Specify Compiler
ASM=lwasm

# Specify Linker (use it maybe some day?)
LINK=lwlink

main.bin : test.asm
#compile the source files
        $(ASM) --decb -o test.bin test.asm


# Binary Program copy, # Load Disk with XROAR
diskbin : test.bin
        decb dskini test.dsk
        decb copy -2 test.bin test.dsk,TEST.BIN -r

        $(LS)

# clean
clean :
        rm -f test.bin test.dsk
        $(info *** Cleaned ***)
        $(LS)
```

# The ToolShed Tools

TOOLSHED is found at : https://sourceforge.net/projects/toolshed/files/

If you look at the README file, you will see that it is a collection of tools for the Radio Shack Color Computer to move files from your PC to virtual disks or .DSK files. There are 2 types of Color Computer disk images, the DECB disk images and the OS9 disk images.  There are a series of commands that can be used with each format.  These commands are compound statements that can be used to perform a number of tasks.

If we focus on the DECB disk images, there are 3 major commands that can be used to interact with files and disk images.

1. decb dskini `diskname.dsk`   - Create a new disk image
2. decb copy _options_ `sourcefile` `diskname.dsk,destfile` - Copy a file to a disk image
3. decb copy _options_ `diskname.dsk,sourcefile` `diskname.dsk,destfile` - Copy a file from a disk image

Options 2 and 3 will also require you to specify options related to the file types being copied. For example, using option `-2` will copy a binary file to/from a disk image.

## Options List

```
Options:
     -[0-3]     file type (when copying to a Disk BASIC image)
                  0 = BASIC program
                  1 = BASIC data file
                  2 = machine-language program
                  3 = text editor source file
     -[a|b]     data type (a = ASCII, b = binary)
     -l         perform end of line translation
     -r         rewrite if file exists
     -t         perform BASIC token translation
     -c         perform segment concatenation on machine language loadables
```
NOTE: The Toolshed commands do not supply well explained errors.  You will just get an error code that you will need to lookup.  They error numbers can be translated using the ERROR CODE explanations supplied with OS9.

This should be enough to get you started.

To expand on this experience, it is recommended that you install Microsoft's Visual Studio Code editor with the following extensions: 6x09 Assembly by Blair Leduc, and Cody AI.  Cody AI can help you write better code (most of the time).  