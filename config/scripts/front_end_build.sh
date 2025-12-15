skipBuild=false
newui=false

print_help() {
    echo -e "\nScript for running Platform's frontend\n"
    echo "Flags:"
    echo "  -skipBuild         -- will skip the build process and just run"
    echo "  -newui or -u       -- will skip the build process and just run"
    exit 0
}

## Parse the arguments
for arg in "$@"; do
    case $arg in
    -h)
        print_help
        ;;
    -skipBuild | -s)
        skipBuild=true
        ;;
    -newui | -u)
        newui=true
        ;;
    esac
done

#########################
####     MAIN   #########
#########################
if $newui; then
    echo "starting new ui"
    cd "$(git rev-parse --show-toplevel)"
    cd client-ui

    # Check if fnm exists before using it
    if which fnm >/dev/null 2>&1; then
        fnm use 24.11.1
    else
        echo "Warning: fnm not found. Skipping node version management."
        echo "Make sure you're using Node.js 22.15.0"
    fi

    if ! $skipBuild; then
        pnpm clean
        pnpm install
        pnpm api
    fi
    pnpm run dev:no-open
else
    echo "starting old ui"
    cd "$(git rev-parse --show-toplevel)"
    cd ui

    # Check if fnm exists before using it
    if which fnm >/dev/null 2>&1; then
        fnm use 18.16.0
    else
        echo "Warning: fnm not found. Skipping node version management."
        echo "Make sure you're using Node.js 18.16.0"
    fi

    if ! $skipBuild; then
        corepack enable
        corepack prepare yarn@3.5.1 --activate
        yarn cache clean
        yarn install
        yarn api
        yarn build
    fi
    yarn start-4444 --no-open
fi
