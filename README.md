# lwt-example
An example project to play with Lwt (a concurrent programming library for OCaml)

## How I set up this project and test it

```
$ dune init proj lwt_example --libs core,cohttp-lwt-unix,yojson --ppx lwt_ppx,ppx_deriving.std,ppx_deriving_yojson
$ cd lwt_example
$ vi dune-project    # Add the above packages to `package.depends` and modify `authors` and so on
$ dune build         # Create lwt_example.opam automatically based on dune-project
$ opam install . --deps-only   # Install dependencies based on lwt_example.opam
$ vi bin/main.ml
$ dune exec lwt_example
```

