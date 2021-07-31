

#[rustler::nif(schedule = "DirtyCpu")]
fn bind(address: String, port: i64) -> bool {
    true
}

#[rustler::nif(schedule = "DirtyCpu")]
fn connect(name: String, address: String, port: i64) -> bool {
    true
}

#[rustler::nif]
fn disconnect(name: String) -> bool {
    true
}

rustler::init!("Elixir.Steinadler.Native", [bind, connect, disconnect]);
