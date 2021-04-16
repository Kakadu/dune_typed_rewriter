##### demo about typed rewriter

In `rewriter/` you can see a rewriter that parses file, typecheckes it and prints parsetree back.

module `A` is just a module

module `B` depends on `A` and is preprocessed by a rewriter above.

*Issue* in `./dune` file I neeed to pass ugly option to my rewriter to make module `A` discoverable.

*Question* how to do better?
