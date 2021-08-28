use rsocket_rust::Client;
use std::collections::HashMap;

use futures::StreamExt;
use rsocket_rust::async_trait;
use rsocket_rust::prelude::*;
use rsocket_rust::runtime;
use rsocket_rust::stream;
use rsocket_rust::Result;
use rsocket_rust_transport_tcp::{TcpClientTransport, TcpServerTransport};
use tokio::sync::mpsc;

use log::{error, info};

pub struct Handle;

#[async_trait]
impl RSocket for Handle {
    async fn request_response(&self, _req: Payload) -> Result<Option<Payload>> {
        todo!()
    }

    async fn metadata_push(&self, _req: Payload) -> Result<()> {
        todo!()
    }

    async fn fire_and_forget(&self, req: Payload) -> Result<()> {
        info!("{:?}", req.data_utf8().unwrap());
        Ok(())
    }

    fn request_stream(&self, _req: Payload) -> Flux<Result<Payload>> {
        todo!()
    }

    fn request_channel(&self, mut reqs: Flux<Result<Payload>>) -> Flux<Result<Payload>> {
        let (sender, mut receiver) = mpsc::unbounded_channel();
        runtime::spawn(async move {
            while let Some(it) = reqs.next().await {
                info!("Received request: {:?}", it);
                sender.send(it).unwrap();
            }
        });
        Box::pin(stream! {
            while let Some(it) = receiver.recv().await {
                yield it;
            }
        })
    }
}

#[derive(Clone)]
pub struct Node {
    pub address: String,
    pub port: i64,
    pub name: String,
    pub clients: HashMap<String, Client>,
}

impl Default for Node {
    fn default() -> Node {
        Node {
            address: String::from("0.0.0.0"),
            port: 4096,
            name: String::from("app"),
            clients: HashMap::new(),
        }
    }
}

impl Node {
    pub fn new() -> Self {
        Default::default()
    }

    pub fn address(&mut self, address: String) -> &mut Node {
        self.address = address;
        self
    }

    pub fn port(&mut self, port: i64) -> &mut Node {
        self.port = port;
        self
    }

    pub fn name(&mut self, name: String) -> &mut Node {
        self.name = name;
        self
    }

    #[tokio::main]
    pub async fn bind(&mut self) -> Result<()> {
        env_logger::builder().format_timestamp_millis().init();
        let addr = format!("{}:{}", &self.address, &self.port);

        let _mtu: usize = 0;
        let transport = TcpServerTransport::from(addr);

        RSocketFactory::receive()
            .transport(transport)
            .acceptor(Box::new(|setup, _socket| {
                info!("accept setup: {:?}", setup);
                Ok(Box::new(Handle))
            }))
            .on_start(Box::new(|| info!("server running...")))
            .serve()
            .await;

        Ok(())
    }

    #[tokio::main]
    pub async fn connect(&mut self) -> Result<()> {
        //&self.clients.contains_key(k: &name)
        let addr = format!("{}:{}", &self.address, &self.port);

        let mtu: usize = 0;
        let transport = TcpClientTransport::from(addr);

        let cli = RSocketFactory::connect()
            .fragment(mtu)
            .transport(transport)
            .start()
            .await?;

        let mut bu = Payload::builder();
        bu = bu.set_data_utf8("Teste!");
        let req = bu.build();

        let mut results = cli.request_channel(Box::pin(futures::stream::iter(vec![Ok(req)])));
        loop {
            match results.next().await {
                Some(Ok(v)) => info!("{:?}", v),
                Some(Err(e)) => {
                    error!("CHANNEL_RESPONSE FAILED: {:?}", e);
                    break;
                }
                None => break,
            }
        }

        Ok(())
    }
}
