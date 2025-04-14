const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  corePlugins: {
    preflight: true
  },
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim,turbo_stream}',
    './app/components/**/*.{erb,html,yml,js,rb}',
    './config/utility_classes.yml'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/line-clamp'),
    require('@tailwindcss/container-queries'),
  ]
}
