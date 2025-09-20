set -ex
export INPUT='content/posts'
export OUTPUT='build/posts'
npx @11ty/eleventy --input=$INPUT --output=$OUTPUT