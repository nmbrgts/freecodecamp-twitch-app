mv build/LocalStorage.js build/LocalStorage.js.temp;
mv build/index.html build/index.html.temp;

(tsc --outFile build/LocalStorage.js --target 'es2016' --strict src/LocalStorage.ts &&
        rm build/*.temp &&
        echo "sucessfully compiled LocalStorage.ts") ||
    (echo "compliation failed, reverting to prior js build" &&
            mv build/LocalStorage.js.temp build/LocalStorage.js;
            mv build/index.html.temp build/index.html)

elm-make src/Main.elm --output build/elm.js;
