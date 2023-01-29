open Core
open Lwt
open Cohttp
open Cohttp_lwt_unix

let queue = Queue.create ()

let server =
  let callback _conn req body =
    let uri = req |> Request.uri |> Uri.to_string in
    let meth = req |> Request.meth |> Code.string_of_method in
    let headers = req |> Request.headers |> Header.to_string in
    let body = body |> Cohttp_lwt.Body.to_string >|= fun body ->
      Printf.sprintf "Uri: %s\nMethod: %s\nHeaders\nHeaders: %s\nBody: %s" uri
        meth headers body in
    let mutex = Lwt_mutex.create () in
    let%lwt _ = Lwt_mutex.lock mutex in
    Queue.enqueue queue (Time_ns.now (), mutex);
    let%lwt _ = Lwt_mutex.lock mutex in
    body >>= fun body -> Server.respond_string ~status:`OK ~body ()
  in
  Server.create ~mode:(`TCP (`Port 8000)) (Server.make ~callback ())

let loop =
  let rec loop () =
    let%lwt _ = Lwt_io.printf "Queue length: %d\n" (Queue.length queue) in
    let now = Time_ns.now () in
    let expired_at = Time_ns.sub now (Time_ns.Span.of_sec 5.0) in
    let wait_sec = match Queue.peek queue with
    | Some (t, mutex) when Time_ns.is_earlier t ~than:expired_at ->
      Lwt_mutex.unlock mutex;
      ignore (Queue.dequeue queue);
      0.0
    | Some _ -> 1.0
    | None -> 1.0
    in
    let%lwt _ = Lwt_unix.sleep wait_sec in
    loop ()
  in loop ()
  
let () = ignore (Lwt_main.run (Lwt.pick [server; loop]))
 