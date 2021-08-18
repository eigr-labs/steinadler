use protoc_rust::Customize;
use std::path::Path;

extern crate protoc_rust;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    tonic_build::configure()
        .out_dir(Path::new("src/protocol"))
        .compile(&["protocol/dist.proto"], &["proto"])?;

    Ok(())
}
