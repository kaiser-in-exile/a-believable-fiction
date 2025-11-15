# A Believable Fiction

A blog for random things that happen. Fictions which are believable, and reality which borders on fiction. This blog is currently hosted on netlify and can be found on the URL: https://a-believable-fiction.pages.dev

Yes, I know this used to be on netlify, but is now on cloudflare

![Friendship Ended](/assets/images/netlify-to-cloudflare.jpg)

## How to Develop

To develop this blog, i.e. to write more you need to have setup

1. NodeJS
2. Git

Just git clone this blog and run `npm install` to get started.

The content of this blog is contained in the `src/posts` directory. Which is subdivided by the kind of posts (longforms/lists/something else that comes up in the future).

Each type often also has an accompanying Nunjucks template which provides some simple templating (Eg: setting up title tags, and css). The nunjucks templates are found in `src/templates`

The styles for the pages are found in `src/styles`. Try to keep the broader structure there clean. Use CSS only, none of that fancy scss nonsense. In the ever wise words of Steve Jobs, simplicity is the ultimate sophistication.

## How To Build

This is NodeJS project configured using [eleventy](https://www.11ty.dev/) for the build stack. The deployment to the production website is done automatically when one merges a PR to main.
