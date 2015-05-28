# Welcome

Welcome to the `rdr` project.

`rdr` is an OCaml tool/library for doing cross-platform analysis of binaries.  I typically use it for looking up symbol names, finding the address offset, and then running `gdb` or `lldb` (you should be using both if you even know what you're doing) to mess around.

See the [usage section](#usage) for a list of features.

Currently, only 64-bit _ELF_ and _mach-o_ binaries are supported.  32-bit binaries aren't cool anymore; stop publishing reverse engineering tutorials on them.

It has no OPAM dependencies (not that I don't love OPAM) and can be built with the provided `build.sh` script, or simply with:

````bash
ocamlbuild.native -lib unix -lib str src/Rdr.native && mv Rdr.native rdr
````

I'll look into getting it on OPAM soon, but it's in a state of _flux_ right now, and is under [active development](TODO.md).  Contributions welcome!


# Install

* You must have OCaml installed, version 4.02.1.  You'll need at least 4.01 (I use `|>` and `@@`), but I haven't tested on that.
* You must run the `build.sh` script, or execute `ocamlbuild.native -lib unix -lib str src/Rdr.native && mv Rdr.native rdr` in the base directory.
* You may then copy or symlink the resulting `rdr` binary to anywhere that is exported in your `${PATH}`.

# Usage

Essentially, `rdr` performs two tasks, and should probably be two programs.

## Binary Analysis

The first is pointing `rdr` at a binary.  Example:

````bash
rdr /usr/lib/libc.so.6
````

It should output something like: `ELF X86_64 DYN @ 0x20920`.  Which is boring.

You can pass it various flags, `-e` for printing the exports found in the binary (see this post on [ELF exports](http://www.m4b.io/elf/export/binary/analysis/2015/05/25/what-is-an-elf-export.html#conclusion) for what I'm counting as an "export"), `-i` for imports, etc.

Some examples:

* `rdr -h` - prints a help menu
* `rdr -h /usr/lib/libc.so.6` - prints the program headers, bookkeeping data, and other beaurocratic aspects of binaries, just to confuse you.
* `rdr -f printf /usr/lib/libc.so.6` - searches the `libc.so.6` binary for an exported symbol named _exactly_ "printf", and if found, prints its binary offset and size (in bytes).  _Watch out for_ `_` prefixed symbols in mach and compiler private symbols in ELF. Definitely watch out for funny (`$`) symbols, like in mach-o Objective C binaries; you'll need to quote the symbol name to escape them, otherwise bash gets mad.  Future: regexp multiple returns, and searching imports as well.
* `rdr -l /usr/lib/libc.so.6` - lists the dynamic libraries `libc.so.6` _explicitly_ depends on (I'm looking at _you_ `dlsym`).
* `rdr -i /usr/lib/libc.so.6` - lists the imports the binary depends on.  **NOTE** when run on linux binaries, if a system map has been built, it will use that to lookup where the symbol could have come from for you.  Depending on your machine, can add a slight delay; sorry bout that.  On `mach-o` this isn't necessary, since imports are required to state where they come from, because the format was built by sane people (more or less).
* `rdr -g /usr/lib/libz.so.1.2.8` - graphs the libraries, imports, and exports of `libz.so.1.2.8`; run `dot -O -n -Tpng libz.so.1.2.8.gv` to make a pretty picture.  Future: check if dot is installed and run it _for_ you.
* `rdr -s /usr/lib/libc.so.6` - print the nlist/strippable symbol table, if it exists.  Crappy programs like `nm` _only_ use the strippable symbol table, even for exports and imports.
* `rdr -v /usr/lib/libc.so.6` - print everything.

## Symbol Map

`rdr` can create a "symbol map" for you, in `${HOME}/.rdr/`.  What's that you ask?  It's a map from `exported symbol name -> list of symbol info`.

Why hasn't this existed before?  I don't know.

You build the map first by invoking:

````bash
rdr -b
````

Which defaults to scanning `/usr/lib/` for things it considers "binaries".  Basically, it works pretty well.

If you want to recursively search, you give it a directory (or supply none at all, and it uses the default, `/usr/lib`), and the `r` flag:

````bash
rdr -b -r -d "/usr/lib /usr/local/lib"
````

Spaces in the `-d` string separate different directories; with `-r` set, it searches _each_ recursively.

Be careful (patient); on slow machines, this can take some time.  On a MBP, it's so damn fast it can build the map in realtime, and then do a symbol lookup (I don't do that).

After you've built the map, you can perform _exact_ symbol lookups, for example:

````bash
$ rdr -m -f printf
searching /usr/lib/ for printf:
           4f0a0 printf (161) -> /usr/lib/libc-2.21.so
````

This is an experimental feature and subject to change (it'll definitely have to stay in, cause it's awesome), but if you find a symbol you admire, you can disassemble it by adding the `-D` flag using `llvm-mc`.

**_WARNING_**:to quote a C idiom: "this behavior is undefined" if `llvm-mc` isn't installed and in your `${PATH}`.

Example with `llvm-mc` correctly installed:

````bash
$ rdr -D -m -f printf
searching /usr/lib/ for printf:
           4f0a0 printf (161) -> /usr/lib/libc-2.21.so
	.text
	subq	$216, %rsp
	testb	%al, %al
	movq	%rsi, 40(%rsp)
	movq	%rdx, 48(%rsp)
	movq	%rcx, 56(%rsp)
	movq	%r8, 64(%rsp)
	movq	%r9, 72(%rsp)
	je	55
	movaps	%xmm0, 80(%rsp)
	movaps	%xmm1, 96(%rsp)
	movaps	%xmm2, 112(%rsp)
	movaps	%xmm3, 128(%rsp)
	movaps	%xmm4, 144(%rsp)
	movaps	%xmm5, 160(%rsp)
	movaps	%xmm6, 176(%rsp)
	movaps	%xmm7, 192(%rsp)
	leaq	224(%rsp), %rax
	movq	%rdi, %rsi
	leaq	8(%rsp), %rdx
	movq	%rax, 16(%rsp)
	leaq	32(%rsp), %rax
	movl	$8, 8(%rsp)
	movl	$48, 12(%rsp)
	movq	%rax, 24(%rsp)
	movq	3464671(%rip), %rax
	movq	(%rax), %rdi
	callq	-44329
	addq	$216, %rsp
	retq
````


# Project Structure

Because I just knew you were going to ask, I made this _sweet_ graphic, just for you:

![project deps](project_deps.gv.png)
