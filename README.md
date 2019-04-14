# WSE

## Fetch dependencies
```bash
mix deps.get
```

## Start server
```bash
mix phx.server
```

## Create release
```bash
mix deps.get --only prod; MIX_ENV=prod mix release
```

