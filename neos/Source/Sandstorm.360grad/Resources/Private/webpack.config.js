var path = require("path");
const globImporter = require('node-sass-glob-importer');

module.exports = {
    entry: "./main.js",
    output: {
        path: path.resolve(__dirname, "../Public"),
        filename: "bundle.js",
        publicPath: "/"
    },
    module: {
        rules: [
            {
                test: /\.js$/,
                use: {
                    loader: "babel-loader",
                    options: {presets: ["@babel/env"]}
                }
            },
            {
                test: /\.scss$/,
                use: [
                    {
                        loader: "style-loader" // creates style nodes from JS strings
                    },
                    {
                        loader: "css-loader" // translates CSS into CommonJS
                    },
                    {
                        loader: "sass-loader", // compiles Sass to CSS
                        options: {
                            importer: globImporter()
                        }
                    }
                ]
            }
        ]
    }
};
