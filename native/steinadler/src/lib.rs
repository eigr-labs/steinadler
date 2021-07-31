#[macro_use]
extern crate rustler;

use rustler::Atom;

mod atoms {
    atoms! {
        ok,
        error
    }
}

#[rustler::nif(schedule = "DirtyCpu")]
fn bind(address: String, port: i64) -> Atom {
    atoms::ok()
}

#[rustler::nif(schedule = "DirtyCpu")]
fn connect(name: String, address: String, port: i64) -> Atom {
    atoms::ok()
}

#[rustler::nif]
fn disconnect(name: String) -> Atom {
    atoms::ok()
}

rustler::init!("Elixir.Steinadler.Native", [bind, connect, disconnect]);
