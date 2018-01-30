# Development virtual machine
_Scripts to build a virtual machine (.ova file) with all necessary tools to play with the code in this repository._

## Prerequisites

This should run fine on Windows, Mac and Linux - but has only been tested on Windows 10.

 * Vagrant
 * Virtual Box - with "vmboxmanage(.exe)" added to the path
 * GNU Make
 * Bash or PowerShell

## Building the OVA

```bash
make
```

_Requires some patience._

## Deleting the OVA

```bash
make clean
```

## Building & running the VM without creating an OVA

```bash
vagrant up
```