#[macro_use]
extern crate rustler;

pub mod server;

use rustler::Atom;
use std::string::String;

use crate::server::Server;

mod atoms {
    atoms! {
        ok,
        error
    }
}

#[rustler::nif]
fn register_node(_name: String, _port: i64) {}

#[rustler::nif(schedule = "DirtyCpu")]
fn bind(address: String, port: i64) {
    Server::new().address(address).port(port).bind().unwrap();
}

#[rustler::nif(schedule = "DirtyCpu")]
fn connect(name: String, address: String, port: i64) {
    Server::new()
        .name(name)
        .address(address)
        .port(port)
        .connect()
        .unwrap();
}

#[rustler::nif]
fn disconnect(name: String) -> Atom {
    atoms::ok()
}

rustler::init!(
    "Elixir.Steinadler.Native",
    [bind, connect, disconnect, register_node]
);
