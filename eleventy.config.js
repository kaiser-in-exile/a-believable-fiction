const CSS_FILES = [
    "src/styles/base.css",
    "src/styles/main.css",
    "src/styles/list.css",
    "src/styles/article.css",
]

const NOW = new Date();
const THIRTY_DAYS_IN_MINUTES = 30 * 24 * 60;
const BASE_URL = "https://a-believable-fiction.netlify.app"

export default function (eleventyConfig) {
    // setup global variables
    eleventyConfig.addGlobalData("now", NOW)
    
    // setup RSS feed specific variables
    eleventyConfig.addGlobalData("feed", { ttl: THIRTY_DAYS_IN_MINUTES, base: BASE_URL });

    // setup build folders
    eleventyConfig.setIncludesDirectory("templates");

    // get main content from here
    eleventyConfig.setInputDirectory("src");
    eleventyConfig.setOutputDirectory("build");

    // copy over styles
    for (let stylesheet of CSS_FILES) {
        eleventyConfig.addPassthroughCopy(stylesheet);
    }
}