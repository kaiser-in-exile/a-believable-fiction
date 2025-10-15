const CSS_FILES = [
    "src/styles/base.css",
    "src/styles/main.css",
    "src/styles/list.css",
    "src/styles/article.css",
]

export default function (eleventyConfig) {
    eleventyConfig.setIncludesDirectory("templates");

    // get main content from here
    eleventyConfig.setInputDirectory("src");
    eleventyConfig.setOutputDirectory("build");

    // copy over styles
    for (let stylesheet of CSS_FILES) {
        eleventyConfig.addPassthroughCopy(stylesheet);
    }
}