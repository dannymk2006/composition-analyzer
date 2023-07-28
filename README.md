<!-- <a name="readme-top"></a> -->

# composition-analyzer

<h1 align="center">
  <br>
  <a href="https://github.com/dannymk2006/composition-analyzer/"><img src="https://i.imgur.com/PDG394z.png" alt="Composition-Analyzer" width="250"></a>
  <br>
  <b>Composition-Analyzer</b>
  <br>
</h1>

A composition analyzer that ... well, analyse a composition for you

<!-- <p align="right">(<a href="#readme-top">back to top</a>)</p> -->

## Getting Started

This software was meant to built only on windows since it used windows api.

The latest build for Windows can be found on [releases](https://github.com/dannymk2006/composition-analyzer/releases/latest).

## Build Setup

Follow the guideline if you wants to build it by yourself.

* [Windows](#windows)

### Windows

* Install [Free Pascal Compiler](https://sourceforge.net/projects/freepascal/files/Win32/3.2.2/fpc-3.2.2.win32.and.win64.exe/download)

## Building
Composition Analyzer is built with [Pascal](https://en.wikipedia.org/wiki/Pascal_(programming_language)), based on [ALGOL](https://en.wikipedia.org/wiki/ALGOL). Composition Analyzer will use [Free Pascal Compiler](https://www.freepascal.org/) as the Pascal compiler.

To Build the executable (.exe):
```sh
fpc [main.pas path]
```

or

```sh
fpc [main.pas path] -FE[output path] -FU[output path]
```
Add "-FE[Path] -FU[Path]" if you want to output the executable to a specific path. No spaces between -FE(-FU) and path

The executable should appear at the same folder where the [main.pas](https://github.com/dannymk2006/composition-analyzer/blob/main/main.pas?raw=1) belongs to.

## Results

- [x] Total word count
- [x] Frequency of letters
- [ ] Total paragraph count
- [ ] Frequency of a specific word

## Contact me
DannyMK - me@danny.mk

Project Link: [https://github.com/dannymk/composition-analyzer](https://github.com/dannymk/composition-analyzer)