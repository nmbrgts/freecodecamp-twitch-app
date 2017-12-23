mv build/LocalStorage.js build/LocalStorage.js.temp;

(tsc --outFile build/LocalStorage.js --target 'es2016' --strict src/LocalStorage.ts &&
        rm build/LocalStorage.js.temp &&
        echo "sucessfully compiled LocalStorage.ts") ||
    (echo "reverting js build" &&
            mv build/LocalStorage.js build/LocalStorage.js.temp;)

elm-make src/Main.elm --output build/elm.js;
