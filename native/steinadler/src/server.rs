use tokio::io::{AsyncReadExt, AsyncWriteExt};
use tokio::net::{TcpListener, TcpStream};
use tokio_stream::StreamExt;
use tokio_util::codec::{Framed, LinesCodec};

use futures::SinkExt;
use std::collections::HashMap;
use std::env;
use std::error::Error;
use std::io;
use std::net::SocketAddr;

#[derive(Debug, Clone)]
pub struct Server {
    pub address: String,
    pub port: i64
}

impl Default for Server {

    fn default() -> Server {
        Server {
            address: String::from("0.0.0.0"),
            port: 4096
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
        use tracing_subscriber::{fmt::format::FmtSpan, EnvFilter};
        // Configure a `tracing` subscriber that logs traces emitted by the chat
        // server.
        /*tracing_subscriber::fmt()
            // Filter what traces are displayed based on the RUST_LOG environment
            // variable.
            //
            // Traces emitted by the example code will always be displayed. You
            // can set `RUST_LOG=tokio=trace` to enable additional traces emitted by
            // Tokio itself.
            .with_env_filter(EnvFilter::from_default_env().add_directive("chat=info".parse()?))
            // Log events when `tracing` spans are created, entered, exited, or
            // closed. When Tokio's internal tracing support is enabled (as
            // described above), this can be used to track the lifecycle of spawned
            // tasks on the Tokio runtime.
            .with_span_events(FmtSpan::FULL)
            // Set this subscriber as the default, to collect all traces emitted by
            // the program.
            .init();
        */

        // Create the shared state. This is how all the peers communicate.
        //
        // The server task will hold a handle to this. For every new client, the
        // `state` handle is cloned and passed into the task that processes the
        // client connection.
        
        
        let address = format!("{}:{}", self.address, self.port);

        // Bind a TCP listener to the socket address.
        //
        // Note that this is the Tokio TcpListener, which is fully async.
        let listener = TcpListener::bind(address).await?;

        //tracing::info!("server running on {}", addr);
        println!("server running...");

        loop {
            // Asynchronously wait for an inbound TcpStream.
            let (mut stream, addr) = listener.accept().await?;

              // Spawn our handler to be run asynchronously.
            tokio::spawn(async move {
                //tracing::debug!("accepted connection");
                println!("accepted connection");
                let mut buf = [0; 1024];

                // In a loop, read data from the socket and write the data back.
                loop {
                    let n = match stream.read(&mut buf).await {
                        // socket closed
                        Ok(n) if n == 0 => return,
                        Ok(n) => n,
                        Err(e) => {
                            eprintln!("failed to read from socket; err = {:?}", e);
                            return;
                        }
                    };

                    // Write the data back
                    if let Err(e) = stream.write_all(&buf[0..n]).await {
                        eprintln!("failed to write to socket; err = {:?}", e);
                        return;
                    }
                }
                
            });
        }
    }

}