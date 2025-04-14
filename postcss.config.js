module.exports = {
  plugins: [
    require('postcss-import'),
    require('postcss-nesting'),
    require('autoprefixer'),
    require('postcss-url')({
      url: (asset) => {
        return asset.url.replace('fonts/', '')
      }
    })
  ],
}
