## fwtoolchain
The cross-compiler for the FrostWing operating system.

### Installing the cross compiler.
It is simple, just open your terminal git clone this repository by,

```sh
git clone https://github.com/Frost-Wing/fwtoolchain.git
```

then cd into the cloned directory and just run

```sh
./build.sh
```

### Build executables
After installation, the standard GNU tools are available under custom names for convenience:

```sh
gcc      -> fwgcc
g++      -> fwg++
ld       -> fwld
as       -> fwas
ar       -> fwar
objcopy  -> fwobjcopy
objdump  -> fwobjdump
nm       -> fwnm
```