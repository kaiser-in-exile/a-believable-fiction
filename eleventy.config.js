export default function (eleventyConfig) {
    eleventyConfig.setIncludesDirectory("templates");

    // get main content from here
    eleventyConfig.setInputDirectory("src");
    eleventyConfig.setOutputDirectory("build");

    // copy over styles
    eleventyConfig.addPassthroughCopy("src/styles/main.css")
    eleventyConfig.addPassthroughCopy("src/styles/list.css")
}