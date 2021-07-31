#[macro_use]
extern crate rustler;

use rustler::Atom;
use std::io::{Read, Write};
use std::net::{Shutdown, TcpListener, TcpStream};
use std::str::from_utf8;
use std::string::String;
use std::thread;

mod atoms {
    atoms! {
        ok,
        error
    }
}

fn handle_connection(mut stream: TcpStream) {
    let mut buffer = [0; 1024];

    stream.read(&mut buffer).unwrap();

    let response = "HTTP/1.1 200 OK\r\n\r\n\r";

    stream.write(response.as_bytes()).unwrap();
    stream.flush().unwrap();
}

#[rustler::nif(schedule = "DirtyCpu")]
fn bind(address: String, port: i64) -> Atom {
    let addr = format!("{}:{}", address, port);
    let listener = TcpListener::bind(&addr).unwrap();

    println!("Server running at {}\r", addr);

    for stream in listener.incoming() {
        let stream = stream.unwrap();
        println!("New connection: {}\r", stream.peer_addr().unwrap());
        thread::spawn(move || handle_connection(stream));
    }

    atoms::ok()
}

#[rustler::nif(schedule = "DirtyCpu")]
fn connect(name: String, address: String, port: i64) -> Atom {
    let addr = format!("{}:{}", address, port);
    let mut stream = TcpStream::connect(&addr).unwrap();
    println!("Sent Hello, awaiting reply...\r");
    let msg = b"Hello!";
    stream.write(msg).unwrap();
    stream.read(&mut [0; 128]).unwrap();
    atoms::ok()
}

#[rustler::nif]
fn disconnect(name: String) -> Atom {
    atoms::ok()
}

rustler::init!("Elixir.Steinadler.Native", [bind, connect, disconnect]);
