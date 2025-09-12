skipBuild=false

print_help() {
    echo -e "\nScript for running Platform's frontend\n"
    echo "Flags:"
    echo "  -skipBuild -s        -- will skip the build process and just run"
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
    esac
done

#########################
####     MAIN   #########
#########################

cd "$(git rev-parse --show-toplevel)"
cd client-ui

fnm use 22.15.0

if ! $skipBuild; then
    pnpm install
    pnpm api
fi
pnpm dev
