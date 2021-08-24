import Config

config :injectx, Injectx,
  context: %{
    name: ApplicationContext,
    bindings: [
      %{
        behavior: Steinadler.NodeBehaviour,
        definitions: [
          %{module: Steinadler.Node.Client.SimpleNode, default: true, name: SimpleNode},
          %{module: Steinadler.Node.Client.NativeNode, default: false, name: NativeNode}
        ]
      }
    ]
  }
