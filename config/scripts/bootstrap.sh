#!/bin/bash

rebuild=false
start_up_script=true
exit_script=false

print_help() {
    echo -e "\nScript to bootstrap db with user info and possibly start up script\n"
    echo "Flags:"
    echo "  -rebuild    -- rebuilds the bootstrap container"
    echo "  -clean      -- bootstraps without seed data"
    exit 0
}

print_pink() {
    local text="$1"
    echo -e "\033[1;35m\n$text\n\033[0m"
}

# Trap SIGINT (Ctrl-C) and set exit_script flag
trap 'exit_script=true' SIGINT

## Parse the arguments
for arg in "$@"; do
    case $arg in
    -h)
        print_help
        ;;
    -rebuild | -r)
        rebuild=true
        ;;
    -clean | -c)
        start_up_script=false
        ;;
    esac
done

if $rebuild; then
    print_pink "destroying bootstrap container"
    docker ps -a --filter "name=bootstrap" --format "{{.ID}}" | xargs docker stop
    docker ps -a --filter "name=bootstrap" --format "{{.ID}}" | xargs docker rmi --force
    docker images --format '{{.Repository}}:{{.Tag}} {{.ID}}' | grep "bootstrap" | awk '{print$2}' | xargs docker rmi --force
    docker rm $(docker ps -a --filter "name=^/bootstrap$" --format "{{.ID}}")
    docker compose up bootstrap -d --build --no-deps
else
    docker compose up bootstrap -d --no-deps
fi

# Check if the script was interrupted
if $exit_script; then
    echo "Script interrupted. Exiting."
    exit 1
fi

if $start_up_script; then
    print_pink "Running seed script"
    PGPASSWORD='postgres' psql -h localhost -p 4432 -U postgres -d novaapi -f ~/dotfiles/config/secrets/scripts/platform_startup_script.sql
fi
