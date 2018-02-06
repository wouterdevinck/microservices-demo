const path = require('path');
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  entry: './src/main.prod.ts',
  output: {
    path: path.resolve(__dirname, './dist/'),
    publicPath: '/',
    filename: '[hash].js'
  },
  module: {
    rules: [
      {
        test: /\.ts$/,
        use: [
          {
            loader: 'awesome-typescript-loader', 
            options: {
              configFileName: 'tsconfig.json',
              usePrecompiledFiles: true,
              transpileOnly: true
            }
          }, { 
            loader: 'angular2-template-loader' 
          }, { 
            loader: 'angular-router-loader', 
            options: {
                aot: true
            }
          }
        ]
      }, {
        test: /\.html$/,
        loader: [ 'html-loader' ]
      }, {
        test: /\.css$/,
        loader: [ 'raw-loader' ]
      }
    ],
    exprContextCritical: false
  },
  plugins: [
    new webpack.optimize.UglifyJsPlugin({
      beautify: false, 
      output: {
        comments: false
      },
      mangle: {
        screw_ie8: true
      }, 
      compress: {
        screw_ie8: true,
        warnings: false,
        conditionals: true,
        unused: true,
        comparisons: true,
        sequences: true,
        dead_code: true,
        evaluate: true,
        if_return: true,
        join_vars: true,
        negate_iife: false
      }
    }),
    new HtmlWebpackPlugin({
      template: './src/index.html'
    }),
    new webpack.ContextReplacementPlugin(
      /angular(\\|\/)core(\\|\/)/,
      path.resolve(__dirname, './')
    )
  ]
};