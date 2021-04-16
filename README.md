##### demo about typed rewriter

In `rewriter/` you can see a rewriter that parses file, typecheckes it and prints parsetree back.

Module `A` is just a module.

Module `B` depends on `A` and is preprocessed by a rewriter above.

**Issue**: In `./dune` file I neeed to pass ugly option to my rewriter to make module `A` discoverable.

**Question**: How to do better?
