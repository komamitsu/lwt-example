(lang dune 3.6)

(name lwt_example)

(generate_opam_files true)

(source
 (github komamitsu/lwt-example))

(authors "Mitsunori Komatsu")

(maintainers "Mitsunori Komatsu")

(license LICENSE)

(documentation https://github.com/komamitsu/lwt-example)

(package
 (name lwt_example)
 (synopsis "Lwt example")
 (description "Lwt example project")
 (depends ocaml dune core cohttp-lwt-unix yojson lwt_ppx ppx_deriving ppx_deriving_yojson)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
