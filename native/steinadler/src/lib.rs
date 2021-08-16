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
fn start_node(address: String, port: i64) {
    Server::new().address(address).port(port).bind().unwrap();
}

#[rustler::nif(schedule = "DirtyCpu")]
fn register(name: String, address: String, port: i64) {
    Server::new()
        .name(name)
        .address(address)
        .port(port)
        .connect()
        .unwrap();
}

#[rustler::nif]
fn unregister(_name: String) -> Atom {
    atoms::ok()
}

rustler::init!(
    "Elixir.Steinadler.Native",
    [start_node, register, unregister]
);
