if [ $# != 1 ]; then
    echo "must pass in name of app to create"
    exit 1
else
    npx create-react-app $1
    (cd $1; npm install gh-pages --save-dev;)
fi
