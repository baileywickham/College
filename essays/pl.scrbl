#lang scribble/manual

Bailey Wickham
CSC430
Clements

Here at Wickham enterprises, we are interested in creating
the next mobile operating system. Why we think we will be
successful at this where others have failed, and justifying
the choice to roll our own OS are good questions, but they
are out of the scope of this memo.

To decide what is important in a new operating system, we
first look at other current operating systems and look at
their goals. For traditional operating systems we have
Linux/Unix/BSD... Windows, and MacOS. One major goal of each
of these platforms is stability. Stability is needed for
developers to be able to write applications for the end user
on top of our OS, to make your OS useful. Another goal of
these systems is efficiency. We want our programs to run
fast, the faster the better. Another major goal is security,
each of these operating systems should be secure from
attackers, to protect personal information and privacy (a
goal which is rarely met). The programming language(s) used
should assist with these goals. This means our language
should be stable, we shouldn't be using the newest language
maintained by a single person at a startup. The language
should be fast, as fast as possible while still vauling
developer time (no x86). Ideally, the language should also
be secure, but as we see with the current set of OSs this
isn't always the case. Additionally, we are developing a
mobile operating system which probably is using the ARM ISA,
so the compiler or interpreter should have ARM support.

Now that we have a vague set of requirements, we can propose
a language. Looking at the other OSs, all are implemented in
C or a C variant. Linux is C, Windows has a lot of C++ but
the kernel is C, MacOS is C, objective-c and swift (from my
memory). Realistically, the only languages I would use for a
new operating system are C or C++. These languages have the
history, the efficiency, and the power to write an OS. Both
of these languages are very fast and do not have garbage
collection. C has direct control over the memory it uses,
allowing extreme efficiency and control, but this also leads
to a new class of bugs. A new language I would consider
using is Rust. Rust has no garbage collection which improves
the performance. It also has better guarantees for memory
safety, one of the largest problems with C and C++. Rust
also has a modern package management system and better
support for asynchronous programming than C++. One thing
rust lacks is the history to compete with C and C++. In
class we use C89, Rust wasn't created until 2010. This is a
problem because there are still major changes to the
language being made. Further, there are fewer developers
with experience needed to write an OS. Also from ~1 minute
of reading, it looks like rust doesn’t have full support for
ARM, they are a “tier 2” platform - I could be wrong here,
but this is something to consider.

One of my favorite languages which I wouldn't use is golang.
While golang is a (somewhat) low level statically typed
language, it still has a garbage collector and produces
fairly large binaries. Golang excels in parallel server
programming which is not the goal of a mobile OS. Another
language I like but wouldn't use is python. Dynamic typing
in the kernel would be a nightmare and anyone who is
developing their own OS probably has the resources to use a
less developer friendly language like C.

An example of something similar is Fuchsia OS by Google
which uses their custom Zircon kernel but it is still in
development.
