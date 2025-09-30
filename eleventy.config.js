export default function (eleventyConfig) {
    // get main content from here
    eleventyConfig.setInputDirectory("src/content");
    eleventyConfig.setOutputDirectory("build");

    // copy over styles
    eleventyConfig.addPassthroughCopy("src/styles")
}