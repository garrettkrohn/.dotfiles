# HTTP API Environment Setup

## Structure

- `http-client.env.json` - Public environment configs (committed to git)
- `http-client.private.env.json` - Private tokens/secrets (gitignored)
- `*.http` - Your HTTP request files with variables

## Usage

### In Neovim (kulala)

1. Open any `.http` file
2. Press `<leader>re` to select environment (dev/staging/prod/local)
3. Press `<leader>rr` to send the request under cursor
4. Press `<leader>ri` to inspect the resolved request (see variables replaced)

### With Tmux/Sesh

Create dedicated sessions per environment:

```bash
# Quick access to API testing in specific environment
sesh connect api-dev
sesh connect api-staging
sesh connect api-prod
```

## Adding to sesh.toml

Add these sessions to your `~/dotfiles/config/sesh.toml`:

```toml
[[session]]
name = "api-dev"
path = "~/code/your-project"
startup_command = "nvim requests.http -c 'lua require(\"kulala\").set_selected_env(\"dev\")'"

[[session]]
name = "api-staging"
path = "~/code/your-project"
startup_command = "nvim requests.http -c 'lua require(\"kulala\").set_selected_env(\"staging\")'"

[[session]]
name = "api-prod"
path = "~/code/your-project"
startup_command = "nvim requests.http -c 'lua require(\"kulala\").set_selected_env(\"prod\")'"
```

## Environment Variables

Variables are automatically loaded from:
1. `http-client.env.json` - base config
2. `http-client.private.env.json` - secrets (overrides base)

Access in `.http` files with `{{variable_name}}`.
