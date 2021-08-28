#[macro_use]
extern crate rustler;
extern crate lazy_static;

pub mod server;

use rustler::Atom;
use std::string::String;

use crate::server::Node;

mod atoms {
    atoms! {
        ok,
        error
    }
}

#[rustler::nif]
fn send(address: String, port: i64, _data: String) {
    Node::new().address(address).port(port).connect().unwrap();
}

#[rustler::nif(schedule = "DirtyCpu")]
fn bind(name: String, address: String, port: i64) {
    Node::new()
        .name(name)
        .address(address)
        .port(port)
        .bind()
        .unwrap();
}

#[rustler::nif]
fn unbind(_name: String) -> Atom {
    atoms::ok()
}

rustler::init!("Elixir.Steinadler.Node.Client.Native", [bind, unbind, send]);
