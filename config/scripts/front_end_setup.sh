echo "copy env file"
cp /Users/gkrohn/code/front_end_work/master/.env ./.env

echo "submodule init"
git submodule update --init

echo "yarn install"
yarn install
