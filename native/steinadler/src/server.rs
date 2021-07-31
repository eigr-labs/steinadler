use std::error::Error;
use tokio::net::{TcpListener, TcpStream};
use tokio_util::codec::{BytesCodec, FramedRead, FramedWrite};

use std::io;
use std::net::SocketAddr;

#[derive(Debug, Clone)]
pub struct Server {
    pub address: String,
    pub port: i64,
}

impl Default for Server {
    fn default() -> Server {
        Server {
            address: String::from("0.0.0.0"),
            port: 4096,
        }
    }
}

impl Server {
    pub fn new() -> Self {
        Default::default()
    }

    pub fn address(&mut self, address: String) -> &mut Server {
        self.address = address;
        self
    }

    pub fn port(&mut self, port: i64) -> &mut Server {
        self.port = port;
        self
    }

    #[tokio::main]
    pub async fn bind(&mut self) -> Result<(), Box<dyn Error>> {
        let addr = format!("{}:{}", &self.address, &self.port);
        let listener = TcpListener::bind(addr).await?;

        println!("server running\r");

        loop {
            // Asynchronously wait for an inbound TcpStream.
            let (_socket, _addr) = listener.accept().await?;

            // Spawn our handler to be run asynchronously.
            tokio::spawn(async move {
                println!("accepted connection\r");
            });
        }
    }
}
