# Introduction

This container is packaged as `ghcr.io/dhirsch1138/cc65_template/cc65_buildrules`

This is my meager attempt to create functional 6502 dev container template. This template is targeted for VSCode but could easily be adapted (see the vscode extensions in the devcontainer.json). The [examples](#quick-examples) are modeled on Ben Eater's "blink.s" program from his 6502 tutorial videos. 

It gives you:
* An installed and configured 6502 compile chain in cc65, with the 'make file' already built. Why CC65?
  * CC65 offers more features than vasm (see the [examples](#quick-examples)/ folder)
  * CC65 also supports C code, though my current rules files won't support it.
* 6502 specific VS Code extensions
* Minipro already installed and ready to rock

All without having to install anything on your workstation (other than what is needed for Dev Containers & VS Code). No having to download or compile anything on your own.

**This is my first attempt at a dev container project, I offer no warranty and make no promises. I will gratefully accept any and all guidance and advice**

---

# Dev Containers
This might be your first encounter with dev containers. This project was mine (killing two birds with one rock, learning Dev Containers and 6502).

Firstly: it is worth looking over https://code.visualstudio.com/docs/devcontainers/containers to see what you are getting into. 

## What are they? 
Dev containers are self contained docker containers that house everything needed to code and compile a project (or really do anything, they are super flexible). You can use this one to:
 * code 6502 assembly
 * compile it using cc65
 * load it onto the eeprom using minipro.
You don't actually have to install any of these tools on your machine, it is all automagically in the dev container for you.

## Why create a dev container template?
I am both meticious and lazy. I want my environment a specific way, but I am far too lazy to document it or recreate it verbatim every time I want to change something. Templates are self documenting, reproducible, easy to share, and easy to apply.

## What do I need to use dev containers?
Follow the instructions on https://code.visualstudio.com/docs/devcontainers/containers#getstarted-articles. But basically you need: docker, vscode, and the dev container extension. 

## Create a Dev Container using this template
**_I encourage you to review this repo and is declared features [minipro_feature](https://github.com/dhirsch1138/minipro_feature) & [cc65_template](https://github.com/dhirsch1138/cc65_feature) before doing so, as you might be prompted to trust this container._**

**Note**: This container runs a _privileged docker instance_. Be mindful. I'm no doing anything turbo odd, but I am pulling in code from CC65 and minipro.
 - To mitigate risk MINIPRO is no longer always cloning the latest and greatest. I built a debian based on the latest 'presumed good' code and have MINIPRO installing that. That will at least protect us in case someone nasty gets that repo. I'll have to update the MINIPRO feature myself periodically to pull in new features.

**Short answer:** VS Code task (F1) "Dev Containers: New Dev Container", provide custom template `ghcr.io/dhirsch1138/cc65_template/cc65_buildrules`.

This project was originally a dev container with everything in it: https://github.com/dhirsch1138/cc65_devcontainer_1 , but I moved it all into a dev container template to make it easier to use as intended.
Use the VS Code task (F1) "Dev Containers: New Dev Container" to load a new container using this template.
* When prompted for the container, type in `ghcr.io/dhirsch1138/cc65_template/cc65_buildrules`. 
  * I intend to get this template registered so that it shows in the lookup. One day. I hope.
* When prompted to create a dev container for this template, say yes. Or don't. You do you.

**Recommended**: Use your own repo to track your changes and push them somewhere outside of the container. I don't know how permenant docker containers are, I wouldn't trust a lot of work to one without having it backed up.

---

# Coding in the Dev Container
## I'm in the dev container, now what?
You are now in a container. Woo. No matter what OS you are running, your container is a debian installation (currently bookworm) with the necessary build tools already installed for you.

A few VS Code shortcuts to know:
* CTRL + SHIFT + ` = open a terminal INSIDE the container. This terminal is a debian session with cc65 and minipro installed and ready to roll
* F1 opens the VSCode Command Palette. You may need to use it to rebuild your dev container if you decide to be adventerous and start tweaking you own dev container. 

## Code and Configuration
To build a project, the source code and the configuration file "linker.cfg" will need to be in the correct directory: "source/"

This dev container template comes with NO CONFIGURATION OR SOURCE in the required directories. See the [Jumpstart](#jumpstart-stage-an-example) section for one way to get started.

### Source Code
* All *.s files in "source/" will be assembled and linked. This means they can and will step on eachother in the resulting output if you are not careful. 
* *.s files can include other files without that extension and the resulting combined file will treated as a single *.s file. 
* These concepts are shown in the the [example(s)](#quick-examples).

### Configuration

[The cc65 documentation for ld65](https://cc65.github.io/doc/ld65.html#config-files), says _"Configuration files are used to describe the layout of the output file(s)"_. We can use the configuration file to define address spaces and vectors that the source can dynamically reference and utilize. 

On its own, that might seem like more work, but imagine one day you wanted to reorganize your addressing scheme. Instead of having to update all your code, you could just update the configuration file. 

Maintanability and self documentation means a happier programmer.

**Configuration is defined in source/linker.cfg**. The make rules in this template expect a linker.cfg file in the source director. They are in all three examples:
* "[examplesvideo3_original_w_cc65](#quick-examples)/" is Ben Eater's original example
  * This is not referencing the linker.cfg file at all.
* "[examples/video3_w_cc65](#quick-examples)" evolves on Ben Eater's example utilizing the configuration file modestly.
  * The starting ".org" has been replaced by [.code](https://cc65.github.io/doc/ca65.html#.CODE),  which the linker knows to map to $8000 for us as it is defined as a SEGMENT for the the MEMORY definition ROM.
  * The reset reference at $fffc has been replaced with [.segment](https://cc65.github.io/doc/ca65.html#.SEGMENT) reference to "VECTORS", which is another defined SEGMENT in the configuration.
* "[examples/video3_w_cc65_viafirmware](#quick-examples)/" futher evolves on the example and adds more functionality provided by the configuration file.
  * defines a MEMORY space for the VIA addresses
  * uses that new VIA space in 'via.s', where it it is used to dynamically define familiar addresses DDRB and DDRA.

In summary (again):
* Source goes in : source/*.s
* Configuration goes in : source/linker.cfg

Again: This dev container comes with NO CONFIGURATION OR SOURCE in the required directories. See the [Jumpstart](#jumpstart-stage-an-example) section for one way to get started.

## Compiling Projects And Writing Eprom
### Assembling & Linking
- Open a terminal instance for the container.
- Make sure you are in the base folder of the image (where the makefile is)
- run "make all"
- If all goes well, your generated binary will be placed in "build/output.bin"

```
$ make all
INFO: Processing source files in folder "source/"
INFO: Located these source files and will process "source/blink.s source/via.s"
INFO: CC65 rules folder ".c65/"
INFO: Source files to assemble blink.s via.s
INFO: Objects to build build/output/blink.o build/output/via.o
ca65 --cpu 65C02  -o build/output/blink.o -l build/output/blink.lst source/blink.s
ca65 --cpu 65C02  -o build/output/via.o -l build/output/via.lst source/via.s
ld65  -C source/linker.cfg -o build/output.bin -m build/output/output.map build/output/blink.o build/output/via.o
```

### Looking at generated "output.bin" using hexdump
* hexdump is already installed in the container. just run: "hexdump -C build/output.bin" without quotes in container terminal instance.

```
$ hexdump -C build/output.bin
00000000  a9 ff 8d 02 60 a9 50 8d  00 60 6a 8d 00 60 4c 0a  |....`.P..`j..`L.|
00000010  80 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000020  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00007ff0  00 00 00 00 00 00 00 00  00 00 00 00 00 80 00 00  |................|
00008000
```

### Writing eprom
#### From inside the container
- open a terminal instance for the container.
- run minipro as usual
```
$ minipro -p 28C256 -uP -w build/output.bin
```

#### From outside of the container
If for whatever reason minipro isn't playing nice (again it is untested, sorry) then just get the bin directly in your system and run minipro there.

# Quick Examples
This dev container has three examples of different implementations of Ben Eater's blink.s program from Video 3 (https://eater.net/downloads/blink.s) . All three examples do the same thing, they just illustrate how the functionality of cc65 can be leveraged to help remove mental labor from the coder.

- "examples/video3_original_w_cc65" - [Ben's rotating led blinker "blinks.s" from video 3](https://eater.net/downloads/blink.s)
  - Includes the associated configuration file so that it'll build with ld65, even though the configuration file isn't actually being used.
- "examples/video3_w_cc65" - [dbuchwald's cc65'd version of Ben's example video 3](https://github.com/dbuchwald/cc65-tools/blob/main/tutorial/02_blink/blink.s)
  - This illustrates how the vector and code definitions can be used (as provided by cc65 functionality) 
- "examples/video3_w_cc65_viafirmware" - A futher evolution based on [dbuchwalds work](https://github.com/dbuchwald/cc65-tools/blob/main/tutorial/03_blink/blink.s)
  - Illustrates how the configuration file can be leveraged to dynamically handle memory spaces to replace the static address refences (use dynamic references to VIA addresses).
  - We also introduce included files to keep our codebase organized. 

Reminder: the code from the examples will need to be moved into "source/" to build them

All three of these examples build into an identical binary @ "build/output.bin". You can prove this yourself after staging an example into "source/" and running `make all`. Below is result of staging, compiling, and viewing the contents "examples/video3_w_cc65_viafirmware"
```
vscode ➜ /workspaces/TestTemplate1 $ cp examples/video3_w_cc65_viafirmware/source/* source/
vscode ➜ /workspaces/TestTemplate1 $ make all
INFO: Processing source files in folder "source/"
INFO: Located these source files and will process "source/blink.s source/reset_interrupt.s source/via.s"
INFO: Will use linker configuration "source/linker.cfg"
INFO: CC65 rules folder ".c65/"
INFO: Source files to assemble blink.s reset_interrupt.s via.s
INFO: Objects to build build/output/blink.o build/output/reset_interrupt.o build/output/via.o
ca65 --cpu 65C02  -o build/output/blink.o -l build/output/blink.lst source/blink.s
ld65  -C source/linker.cfg -o build/output.bin -m build/output/output.map build/output/blink.o build/output/reset_interrupt.o build/output/via.o
vscode ➜ /workspaces/TestTemplate1 $ hexdump -C build/output.bin
00000000  a9 ff 8d 02 60 a9 50 8d  00 60 6a 8d 00 60 4c 0a  |....`.P..`j..`L.|
00000010  80 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000020  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00007ff0  00 00 00 00 00 00 00 00  00 00 00 00 00 80 00 00  |................|
00008000
```

## Jumpstart: stage an example
To help get you started you can stage an example by running the following from the workspace folder to move the example into the working source folder.
```
vscode ➜ /workspaces/<YourContainer> $ cp examples/video3_w_cc65_viafirmware/source/* source/
```

---

# Attributions and Resources
* [**dbuchwald**](https://github.com/dbuchwald/cc65-tools) This project is only possible because of their makefile rules, configurations, and source examples. Sorry for butchering your work. Many of the examples presented are (or are based on) their work.
* [**Ben Eater**](https://eater.net/6502) The creator the the awesome 6502 youtube series. Also sells kits @ https://eater.net/shop
* [**cc65**](https://cc65.github.io/) development package platform for 6502 family
  * [**ca65**](https://cc65.github.io/doc/ca65.html) assembler guide (for our source code)
  * [**ld65**](https://cc65.github.io/doc/ld65.html) linker guide (which applies the configuration)
* [**Dev Containers**](https://code.visualstudio.com/docs/devcontainers/containers) all about dev containers
* [**Garth Wilson**](http://wilsonminesco.com/6502primer/65tutor_intro.html) The 6502 primer. Enough said.
* [**MINIPRO**](https://gitlab.com/DavidGriffith/minipro) This is the project that lets us program eproms
* [**VASM**](http://sun.hasenbraten.de/vasm) Another 6502 compatible assembler.
* [**The Western Design Center**](https://www.westerndesigncenter.com/) - Makers of amazing the W65C02S processor (and much more! did you know they have a 16 bit version?!). Also very lovely people.
  * [**WDC Datasheets**](https://www.westerndesigncenter.com/wdc/documentation.php) - Direct link to the WDC documentation page, with links to their most current datasheet versions.  
