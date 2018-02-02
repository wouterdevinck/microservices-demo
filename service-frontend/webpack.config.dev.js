const path = require('path');
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
    entry: './src/main.ts',
    resolve: {
        extensions: [ '.js', '.ts' ]
    },
    devtool: 'cheap-module-eval-source-map',
    output: {
        publicPath: '/',
        filename: 'bundle.js'
    },
    module: {
        rules: [
            {
                test: /\.ts$/,
                use: [
                    {
                        loader: 'awesome-typescript-loader', 
                        options: {
                            transpileOnly: true,
                            configFileName: 'tsconfig.json'
                        }
                    },
                    { loader: 'angular2-template-loader' },
                    { loader: 'angular-router-loader' } 
                ]
            }
        ]
    },
    devServer: {
        stats: {
            colors: true,
            hash: true,
            timings: true,
            chunks: true,
            chunkModules: false,
            children: false,
            modules: false,
            reasons: false,
            warnings: true,
            assets: false, 
            version: false
        },
        overlay: {
            errors: true,
            warnings: false
        }
    },
    plugins: [
        new HtmlWebpackPlugin({
            template: './src/index.html'
        }),
        new webpack.ContextReplacementPlugin(
            /angular(\\|\/)core(\\|\/)/,
            path.resolve(__dirname, './')
        )
    ]
};