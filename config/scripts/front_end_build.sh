skipBuild=false

print_help() {
    echo -e "\nScript for running Platform's frontend\n"
    echo "Flags:"
    echo "  -skipBuild         -- will skip the build process and just run"
    exit 0
}

## Parse the arguments
for arg in "$@"
do
    case $arg in
        -h)
            print_help
            ;;
        -skipBuild|-s)
            skipBuild=true
            ;;
    esac
done

#########################
####     MAIN   #########
#########################

cd "$(git rev-parse --show-toplevel)"
cd ui

fnm use 18.16.0 
if ! $skipBuild; then
    corepack enable 
    corepack prepare yarn@3.5.1 --activate 
    yarn cache clean 
    yarn install 
    yarn api 
    yarn build 
fi
yarn start-4444 --no-open
