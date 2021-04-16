open Misc

let usage = "usage"

let ppf = Format.err_formatter

let parse_impl i =
  let open Compile_common in
  Pparse.parse_implementation ~tool_name:i.tool_name i.source_file
  |> print_if i.ppf_dump Clflags.dump_parsetree Printast.implementation
  |> print_if i.ppf_dump Clflags.dump_source Pprintast.structure

let typecheck_impl i parsetree =
  let open Compile_common in
  parsetree
  |> Typemod.type_implementation i.source_file i.output_prefix i.module_name
       i.env
  |> fun _ -> Printast.implementation Format.std_formatter parsetree

let implementation info ~backend =
  let parsed = parse_impl info in
  if Clflags.(should_stop_after Compiler_pass.Parsing) then ()
  else
    let typed = typecheck_impl info parsed in
    if Clflags.(should_stop_after Compiler_pass.Typing) then ()
    else backend info typed

let run source_file =
  let backend _ _ = () in
  try
    Compile_common.with_info ~native:false ~tool_name:"asf" ~source_file
      ~output_prefix:"aaa" ~dump_ext:"asdf"
      (Compile_common.implementation ~backend)
  with Env.Error e as exc ->
    Format.printf "%a\n%!" Env.report_error e;
    raise exc

let () =
  let input_name = ref "" in
  Clflags.add_arguments "loc"
    [
      ( "-I",
        Arg.String (fun s -> Clflags.include_dirs := s :: !Clflags.include_dirs),
        "desc" );
    ];
  Clflags.parse_arguments (fun path -> input_name := path) usage;
  run !input_name
