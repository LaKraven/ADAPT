# Advanced Developer Async Programming Toolkit (ADAPT)
ADAPT is a foundation library intended to be used at the heart of your projects for the purpose of providing extremely powerful, multi-threaded (and thread-safe) capabilities.

It supercedes the LaKraven Studios Standard Library (LKSL), improves upon it, expands up on it, and resolves many of its fundamental architectural issues.

Much of ADAPT's distinct features are derrived from the "Another Game Engine" (AGE) project (soon to be made publicly available on GitHub) and have been collected together into this public library because they are extremely useful in other contexts beyond a Game Engine.

## Installation
On *Windows*, don't forget to run **INSTALL.BAT** to register the necessary Environment Variables.

Environment Variables registered by **INSTALL.BAT** on *Windows*:

| Variable Name  | Points to Path     |
| -------------- | ------------------ |
| ADAPT_HOME     | \                  |
| ADAPT_PASCAL   | \Source\Lib\Pascal |

## Features:
|         Feature         | Description                                                                                      |
| ----------------------- | ------------------------------------------------------------------------------------------------ |
| Base Types              | Special *Common Base Types*. Used throughout the ADAPT Library.                                  |
| Event Engine            | A *very powerful* system for producing Multi-Threaded, Asynchronous and Event-Driven programs.   |
| Generics Collections    | Highly efficient Collection Types (*Lists, Trees, Maps etc.*)                                    |
| High Precision Threads  | A special Thread Base Type designed to provide supremely High Precision Tick Rates.              |
| Math Library            | A library for Unit Conversion, special calculation and other useful mathematics routines.        |
| Package Engine          | Extension of the Streamables Engine supporting the packaging of files together (a VFS of sorts)  |
| Shared Streams Library  | 100% Thread-Safe Stream Classes (Interfaced too) allowing read/write from multiple Threads.      |
| Stream Handling Library | Makes working with Streams *much* easier! Handles Deleting, Inserting, Reading and Writing data. |
| Streamables Engine      | A system to serialize Object Instances into Streams, and to dynamically reconstitute them, too.  |

Where possible/rational, every implemented Class Type in the ADAPT library is complemented by a Thread-Safe counterpart. These Class Type Names are suffixed with `TS`.

## Support Matrix:

|         Feature         | Delphi (XE2+)    | C++ Builder (XE2+)    | FreePascal 3.x+ |
| ----------------------- | ---------------- | --------------------- | --------------- |
| Base Types              | Yes              | Soon                  | Soon/Untested   |
| Event Engine            | Yes              | Soon                  | Soon/Untested   |
| Generics Collections    | Yes              | Soon                  | Soon/Untested   |
| High Precision Threads  | Yes              | Soon                  | Soon/Untested   |
| Math Library            | Yes              | Soon                  | Soon/Untested   |
| Package Engine          | Soon             | Soon                  | Soon/Untested   |
| Shared Streams Library  | Yes              | Soon                  | Soon/Untested   |
| Stream Handling Library | Yes              | Soon                  | Soon/Untested   |
| Streamables Engine      | Yes              | Soon                  | Soon/Untested   |

## Documentation:
Coming soon, not yet available.

## License:
See the LICENSE.MD file for full details.
