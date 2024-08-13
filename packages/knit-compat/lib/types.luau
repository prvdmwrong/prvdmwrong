export type Middleware = {
  Inbound: ClientMiddleware?,
  Outbound: ClientMiddleware?,
}

export type ClientMiddlewareFn = (args: { any }) -> (boolean, ...any)
export type ClientMiddleware = { ClientMiddlewareFn }
export type PerServiceMiddleware = { [string]: Middleware }

export type ControllerDef = {
  Name: string,
  [any]: any,
}

export type Controller = {
  Name: string,
  [any]: any,
}

export type KnitOptions = {
  ServicePromises: boolean,
  Middleware: Middleware?,
  PerServiceMiddleware: PerServiceMiddleware?,
}

export type ServerMiddlewareFn = (player: Player, args: { any }) -> (boolean, ...any)

export type ServerMiddleware = { ServerMiddlewareFn }

export type ServiceDef = {
  Name: string,
  Client: { [any]: any }?,
  Middleware: Middleware?,
  [any]: any,
}

export type Service = {
  Name: string,
  Client: ServiceClient,
  KnitComm: any,
  [any]: any,
}

export type ServiceClient = {
  Server: Service,
  [any]: any,
}

return nil
