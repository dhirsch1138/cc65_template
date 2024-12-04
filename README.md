# Introduction
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
**_I encourage you to check out this repo before doing so, as you might be prompted to trust this container (as it'll be running code)._**

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

## Code and Firmware
To build a project, the source code and firmware.cfg file will need to be in the correct directory: "source/"

This dev container comes with NO FIRMWARE OR SOURCE in the required directories. See the [Jumpstart](#jumpstart-stage-an-example) section for one way to get started.

### Source Code
* All *.s files in "source/" will be assembled and linked. This means they can and will step on eachother in the resulting output if you are not careful. 
* *.s files can include other files without that extension and the resulting combined file will treated as a single *.s file. 
* These concepts are shown in the the [example(s)](#quick-examples).

### Firmware
Defines memory spaces & segments that your code will use. This sounds scary, don't panic. I'll try to explain it in comments as part of my examples. For now, just know that **firmware is defined in source/firmware.cfg**. The make rules in this template expect a firmware.cfg file in the source director. When in doubt, simpler is better if you don't need the extra features. They are in all three examples:
* "[examples](#quick-examples)/video3_original_w_cc65" has a simple firmware definition but it isn't actually being utilized in the source.
* "[examples](#quick-examples)/video3_w_cc65" has the same simple firmware definition, just declaring the code address range: starting at $8000 for $8000 bytes. The reset segment is defined too.
* "[examples](#quick-examples)/video3_w_cc65_viafirmware" has the same code address range, but also reserved addresses for the VIA. This lets the code reference the VIA address space dynamically.
Documentation is here https://cc65.github.io/doc/ld65.html#config-files


In summary (again):
* Source goes in : source/*.s
* Firmware goes in : source/firmware.cfg

Again: This dev container comes with NO FIRMWARE OR SOURCE in the required directories. See the Jumpstart section for one way to get started.

## Compiling Projects And Writing Eprom
### Assembling & Linking
- Open a terminal instance for the container.
- Make sure you are in the base folder of the image (where the makefile is)
- run "make all"
- If all goes well, your generated binary will be placed in "build/output.bin"

### Looking at generated "output.bin" using hexdump
* hexdump is already installed in the container. just run: "hexdump -C build/output.bin" without quotes in container terminal instance.

### Writing eprom
#### From inside the container
- open a terminal instance for the container.
- run minipro as usual (untested, I don't own a programmer yet)
#### From outside of the container
If for whatever reason minipro isn't playing nice (again it is untested, sorry) then just get the bin directly in your system and run minipro there.

# Quick Examples
This dev container has three examples of different implementations of Ben Eater's blink.s program from Video 3 (https://eater.net/downloads/blink.s) . All three examples do the same thing, they just illustrate how the functionality of cc65 can be leveraged to help remove mental labor from the coder.

- "examples/video3_original_w_cc65" - Ben's rotating led blinker "blinks.s" from video 3 (https://eater.net/downloads/blink.s)
  - Includes the associated firmware so that it'll build with ld65, even though the firmware isn't actually being used.
- "examples/video3_w_cc65" - dbuchwald's cc65'd version of Ben's example video 3 (https://github.com/dbuchwald/cc65-tools/blob/main/tutorial/02_blink/blink.s)
  - This illustrates how the vector and code definitions can be used (as provided by cc65 functionality) 
- "examples/video3_w_cc65_viafirmware" - A futher evolution based on dbuchwalds work (https://github.com/dbuchwald/cc65-tools/blob/main/tutorial/03_blink/blink.s)
  - Illustrates how the firmware can be leveraged to dynamically handle memory spaces to replace the static address refences (use dynamic references to VIA addresses).
  - We also introduce included files to keep our codebase organized. 

Reminder: the code from the examples will need to be moved into "source/" to build them

All three of these examples build into an identical binary @ "build/output.bin". You can prove this yourself after staging an example into "source/" and running `make all`. Below is result of staging, compiling, and viewing the contents "examples/video3_w_cc65_viafirmware"
```
vscode ➜ /workspaces/TestTemplate1 $ cp examples/video3_w_cc65_viafirmware/source/* source/
vscode ➜ /workspaces/TestTemplate1 $ make all
INFO: Processing source files in folder "source/"
INFO: Located these source files and will process "source/blink.s source/via.s"
INFO: CC65 rules folder ".c65/"
INFO: Source files to assemble blink.s via.s
INFO: Objects to build build/output/blink.o build/output/via.o
ca65 --cpu 65C02  -o build/output/blink.o -l build/output/blink.lst source/blink.s
ca65 --cpu 65C02  -o build/output/via.o -l build/output/via.lst source/via.s
ld65  -C source/firmware.cfg -o build/output.bin -m build/output/output.map build/output/blink.o build/output/via.o
vscode ➜ /workspaces/TestTemplate1 $ hexdump -C build/output.bin
00000000  a9 ff 8d 02 60 a9 50 8d  00 60 6a 8d 00 60 4c 0a  |....`.P..`j..`L.|
00000010  80 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000020  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00007ff0  00 00 00 00 00 00 00 00  00 00 00 00 00 80 00 00  |................|
00008000
```


## Jumpstart: stage an example
To help get you started you can stage an example by running the following from the workspace folder `cp examples/video3_w_cc65_viafirmware/source/* source/`

---

# Attributions and Resources
* **dbuchwald** https://github.com/dbuchwald/cc65-tools This project is only possible because of their makefile rules, configurations, and source examples. Sorry for butchering your work. Many of the examples presented are (or are based on) their work.
* **MINIPRO** https://gitlab.com/DavidGriffith/minipro This is the project that lets us program eproms
* **Ben Eater** https://eater.net/6502 The creator the the awesome 6502 youtube series. Also sells kits @ https://eater.net/shop
* **Garth Wilson** http://wilsonminesco.com/6502primer/65tutor_intro.html The 6502 primer. Enough said.
* **VASM** http://sun.hasenbraten.de/vasm the first assembler Ben introduces us too.
* **cc65** https://cc65.github.io/ development package platform for 6502 family
 * **ca65** https://cc65.github.io/doc/ca65.html assembler guide (for our source code)
 * **ld65** https://cc65.github.io/doc/ld65.html linker guide (for the firmware.cfg)
* **Dev Containers** https://code.visualstudio.com/docs/devcontainers/containers all about dev containers
