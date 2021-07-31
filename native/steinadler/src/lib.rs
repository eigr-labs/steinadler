#[macro_use]
extern crate rustler;

pub mod server;

use rustler::Atom;
use std::io::{Read, Write};
use std::net::{Shutdown, TcpListener, TcpStream};
use std::str::from_utf8;
use std::string::String;
use std::thread;

use crate::server::Server;

mod atoms {
    atoms! {
        ok,
        error
    }
}

#[rustler::nif(schedule = "DirtyCpu")]
fn bind(address: String, port: i64) {
    Server::new()
      .address(address)
      .port(port)
      .bind().unwrap();

    //atoms::ok()
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
