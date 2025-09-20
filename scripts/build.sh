set -ex
export INPUT='content/posts'
export OUTPUT='build'
npx @11ty/eleventy --input=$INPUT --output=$OUTPUT