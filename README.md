# Primitives digger

![GitHub last commit](https://img.shields.io/github/last-commit/SEA-group/Primitives-Digger)
![GitHub issues](https://img.shields.io/github/issues-raw/SEA-group/Primitives-Digger)

By AstreTunes @ SEA group

These scripts can add a pair of vertex and indice sections into a bunch of *.primitives* files, you can use them to add a new renderSet. By default only a simple triangle is added.

## How to use
1. Put your *.primitives* files into `Queue/`
2. Open `Main.m`, assign the new section name in line 19; toggle "wire" vertex type in line 23; toggle "list32" in line 24.
3. Run `Main.m`
4. Now the sections are added, Original *.primitives* files are backed up and renamed to **.primitivesbak*.

## Attention
1. **The backup will be overwritten if you run the script twice**
2. This tool helps you to dig a hole （only one) on the file, but you still need a dedicated model tool to put your 3D mesh inside.