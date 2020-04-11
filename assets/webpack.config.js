const path = require('path');
const glob = require('glob');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const TerserPlugin = require('terser-webpack-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const webpack = require('webpack')

module.exports = (env, options) => ({
  optimization: {
    minimizer: [
      new TerserPlugin({ cache: true, parallel: true, sourceMap: false }),
      new OptimizeCSSAssetsPlugin({})
    ]
  },
  entry: {
    './js/app.js': glob.sync('./vendor/**/*.js').concat(['./js/app.js'])
  },
  output: {
    filename: 'app.js',
    path: path.resolve(__dirname, '../priv/static/js')
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader'
        }
      },
      { 
        test: /\.css$/,
        use: [
          MiniCssExtractPlugin.loader,
          { 
            loader: 'css-loader', options: { } 
          },
          'postcss-loader',
        ],  
      },
      {
        test: /\.sass$|.scss$/,
        use: [
          MiniCssExtractPlugin.loader, 
          {loader: 'css-loader', options: {importLoaders: 1}},
          {
            loader: 'postcss-loader', 
            options: {
              sourceMap: true, 
              config: {
                path: 'postcss.config.js'
              }
            }
          },
          {loader: 'sass-loader?sourceMap'},
        ]
      },
      {
        test: /\.(woff(2)?|ttf|eot|svg)(\?v=\d+\.\d+\.\d+)?$/,
        use: [
          {
            loader: 'file-loader',
            options: {
              name: '[name].[ext]',
              outputPath: '../fonts'
            }
          }
        ]
      }
    ]
  },
  plugins: [
    new webpack.ProvidePlugin({
          // add jquery
          $: 'jquery',
          jQuery: 'jquery'
        }),
    new MiniCssExtractPlugin({ filename: '../css/app.css' }),
    new CopyWebpackPlugin([{ from: 'static/', to: '../' }])
  ]
});
