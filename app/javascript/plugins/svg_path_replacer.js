export default {
  name: 'svg-path-replacer',
  setup(build) {
    build.onLoad({ filter: /\.(js|jsx)$/ }, async (args) => {
      const text = await Bun.file(args.path).text();
      const contents = text.replace("img/sprite.svg", "assets/sprite.svg");
      return { contents, loader: 'js' };
    })
  },
}