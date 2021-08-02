use std::error::Error;
use tokio::io::{AsyncReadExt, AsyncWriteExt};
use tokio::net::{TcpListener, TcpStream};

use std::str;

#[derive(Debug, Clone)]
pub struct Server {
    pub address: String,
    pub port: i64,
    pub name: String,
}

impl Default for Server {
    fn default() -> Server {
        Server {
            address: String::from("0.0.0.0"),
            port: 4096,
            name: String::from("app"),
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

    pub fn name(&mut self, name: String) -> &mut Server {
        self.name = name;
        self
    }

    #[tokio::main]
    pub async fn bind(&mut self) -> Result<(), Box<dyn Error>> {
        let addr = format!("{}:{}", &self.address, &self.port);
        let listener = TcpListener::bind(addr).await?;

        //tracing::info!("server running on {}", addr);
        println!("server running...\r");

        loop {
            // Asynchronously wait for an inbound TcpStream.
            let (mut stream, _addr) = listener.accept().await?;

            // Spawn our handler to be run asynchronously.
            tokio::spawn(async move {
                //tracing::debug!("accepted connection");
                println!("accepted connection\r");
                let mut buf = [0; 1024];

                // In a loop, read data from the socket and write the data back.
                loop {
                    let n = match stream.read(&mut buf).await {
                        // socket closed
                        Ok(n) if n == 0 => return,
                        Ok(n) => {
                            eprintln!(
                                "stream read message: {:?}\r",
                                str::from_utf8(&buf[0..n]).unwrap()
                            );
                            n
                        }
                        Err(e) => {
                            eprintln!("failed to read from socket; err = {:?}\r", e);
                            return;
                        }
                    };

                    // Write the data back
                    if let Err(e) = stream.write_all(&buf[0..n]).await {
                        eprintln!("failed to write to socket; err = {:?}\r", e);
                        return;
                    }
                }
            });
        }
    }

    #[tokio::main]
    pub async fn connect(&mut self) -> Result<(), Box<dyn Error>> {
        let addr = format!("{}:{}", &self.address, &self.port);
        let mut stream = TcpStream::connect(&addr).await?;

        stream.write_all(b"hello world!").await?;

        Ok(())
    }
}
