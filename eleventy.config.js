export default function (eleventyConfig) {
    // get main content from here
    eleventyConfig.setInputDirectory("content");
    eleventyConfig.setOutputDirectory("build");

    // copy over styles
    eleventyConfig.addPassthroughCopy("styles")
}