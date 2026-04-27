---
title: Experiments with PreText
description: Experimenting with the pretext library for laying out text
published: Sun, 12 Apr 2026 18:00:00 +0530
publishedISO: 2026-12-04T12:30:00Z
layout: post.njk
tags: post
draft: false
---

# Experiments With Pretext

A couple of weeks ago, I saw (as is usual) a new "Death of X technology" post on Instagram. This time the target was the humble CSS. A rather odd not-quite-sure-what-it-wants-to-be language used to describe how things are laid out on the internet. And the supposed killer was expected to be the library [@chenglou/pretext](https://github.com/chenglou/pretext). A library used to layout text by using canvas technologies to first measure text then followed by giving you cursor based layout APIs which you can constrain by widths to draw text in segments. Naturally killing CSS is a bit of a hype, considering CSS is so much more than layout, but I decided to give this library a spin, and try it out for myself what I could come up with.

## Goal

I decided to design a page with some small sprinklings of text, which should wrap around my cursor in a known radius as the cursor moves across the screen.

## Getting Started

Like every grand project I started this one too, with the most humble of commands ~let there be light~ `pnpm create vite`. Why vite? Well vite is quick, it's easy to bootstrap, works well for producing static output which was what I wanted in this case, and is usually a 0 fuss bundler as well with really good defaults. That is to say, one is able to get pretty far without a config file. Like most of my other throwaway demos, this too is built to be hosted as a single page.

I also decided to take some help from claude, to walk me through the API, and iterate over things one at a time, largely as a sort of rubber duck, and to help me get unstuck if I fell into a rut (as I did with some geometry).

## The Basics

The first thing, I wanted to know was how the library works, to do this I decided to make a very simple prototype, a div who's width I could resize in real time with a slider, as the library the relayout. The code was simple.

```js
inputElement.addEventListener("input", (e) => {
	const width = inputElement.value;
	const { lines } = layoutTextWithLines(prepared, width);
	for (let line of lines) {
		const lineContainer = document.createElement("div");
		div.innerText = line.text;
		textContainer.appendChild(line);
	}
});
```

This gave a simple workable foundation and a base to build upon.

## One Step Up

The logical next step was to do wrapping around the cursor, in a given radius. The key here is to understand certain assumptions, you can safely make about the English language and the nature of my problem.

> English is a left to right language, and given that I want wrapping around a circle. the text will always be in two segments, ergo I can live without generalising the segmentation logic right now.

With this idea, I went ahead and tore down all that I had earlier, replaced everything I had with a single div of text, reading it's text content, preparing it with the library. Next, we start building from the bottom up. Trying to solve the problem:

> Given coordinates of a center, a circle radius, a container width, the y coordinate of the current line of text, and the height of every line of text. How does one determine the number of segments the text is broken into.

The idea is to check whether the y coordinate of the line (plus half the line height for balance) is between circle center's y coordinate +- circle radius. If it does intersect, we need can calculate the left and right segments, widths, and we can calculate the margin for the right segment. Written down in code, this looks something like

```ts
function computeAvailableWidthAroundCircle(
	centerX: number,
	centerY: number,
	radius: number,
	lineY: number,
	lineHeight: number,
	containerWidth: number,
) {
	const lineMiddle = lineY + lineHeight / 2;
	const verticalDistanceBetweenCircleCenterAndLine = Math.abs(
		lineMiddle - centerY,
	);
	if (verticalDistanceBetweenCircleCenterAndLine < radius) {
		const halfChordWidthAtY = Math.sqrt(
			radius * radius -
				verticalDistanceBetweenCircleCenterAndLine *
					verticalDistanceBetweenCircleCenterAndLine,
		);
		const leftWidth = clamp(centerX - halfChordWidthAtY, 0, containerWidth);
		const rightWidth = clamp(
			containerWidth - (centerX + halfChordWidthAtY),
			0,
			containerWidth,
		);
		return {
			leftWidth,
			rightWidth,
			rightStart: centerX + halfChordWidthAtY,
			gap: 2 * halfChordWidthAtY,
			rightMargin: Math.max(centerX + halfChordWidthAtY - leftWidth, 0),
		};
	}
	return {
		leftWidth: containerWidth,
		rightWidth: 0,
		rightStart: 0,
		gap: 0,
		rightMargin: 0,
	};
}
```

It's the same idea, expressed in JS. The first if checks whether the line intersects with the circle, if it does, it computes the chord length of the intersection and computes the left side width as X coordinate of the center - chord width (the part inside the circle), then the right side width as well as the start coordinate for the right side, and the margin required between the left and right side.

In the fallback case, since English is a LTR language, we just assume everything is in the left segment.

Now to draw this, we wrap up the left and right segment in two spans, those spans in a div, and insert that div in the text container.

```ts
function drawTextInContainerWrapAroundCircle(
	prepared: PreparedTextWithSegments,
	container: HTMLDivElement,
	containerRelativeX: number,
	containerRelativeY: number,
) {
	container.innerHTML = "";
	let cursor = { segmentIndex: 0, graphemeIndex: 0 };
	let y = 0;
	while (true) {
		const availableWidth = computeAvailableWidthAroundCircle(
			containerRelativeX,
			containerRelativeY,
			WRAPAROUND_CIRCLE_RADIUS,
			y,
			LINE_HEIGHT,
			WIDTH,
		);

		const lineContainer = document.createElement("div");
		lineContainer.classList.add("line-container");

		if (availableWidth.leftWidth > 0) {
			const leftSegment = layoutNextLineRange(
				prepared,
				cursor,
				availableWidth.leftWidth,
			);
			if (leftSegment === null) {
				break;
			}
			const leftSegmentContainer = createSegmentSpan(
				prepared,
				leftSegment,
			);
			lineContainer.appendChild(leftSegmentContainer);
			cursor = leftSegment.end;
		}
		if (availableWidth.rightWidth > 0) {
			const nextSameLineCursor = cursor;
			const rightSegment = layoutNextLineRange(
				prepared,
				nextSameLineCursor,
				availableWidth.rightWidth,
			);
			if (rightSegment === null) {
				break;
			}
			const rightSegmentContainer = createSegmentSpan(
				prepared,
				rightSegment,
				availableWidth.rightMargin,
			);
			lineContainer.appendChild(rightSegmentContainer);
			cursor = rightSegment.end;
		}
		container.appendChild(lineContainer);
		y += LINE_HEIGHT;
	}
}
```

Note the checks for left and right widths being > 0 this helps in elimating edge cases where we attempt to render the either segment even when they do not exist, i.e. the cursor is outside the box bounds.

This gives us a basic layout, where we can hardcode coordinates, and test it out. The only thing that remains, is tying it to a cursor, for which we can add a mouse move event listener.

## Finishing Touches

Mousemove events are bit janky, and sometimes fire too often, causing compute distress. In order to alleviate we have a common solution, where we use a fake "div" to act as the cursor, and lerp this div's position to the mouse every animation frame, this keeps our animation smooth, consistent and responsive.

```
let mouseX = 0;
let mouseY = 0;
let cursorX = 0;
let cursorY = 0;
const CURSOR_LERP_FACTOR = 0.1;
const CURSOR_OFFSET = -48;
const cursorCircle = document.createElement("div");
cursorCircle.classList.add("cursor");
cursorCircle.style.cssText = `
    position: fixed;
    width: ${(WRAPAROUND_CIRCLE_RADIUS - CURSOR_OFFSET) * 2}px;
    height: ${(WRAPAROUND_CIRCLE_RADIUS - CURSOR_OFFSET) * 2}px;
    cursor: none;
`;
const cursorImage = document.createElement("img");
cursorImage.src = "/images/cursor.png";
cursorImage.classList.add("spinning");
cursorCircle.appendChild(cursorImage);
document.body.appendChild(cursorCircle);

cursorCircle.addEventListener("click", (_e) => {
    cursorImage.classList.toggle("spinning");
});
```

And use this cursor in the animation loop

```
function animate() {
    cursorX = cursorX + (mouseX - cursorX) * CURSOR_LERP_FACTOR;
    cursorY = cursorY + (mouseY - cursorY) * CURSOR_LERP_FACTOR;
    cursorCircle.style.left = `${cursorX - WRAPAROUND_CIRCLE_RADIUS + CURSOR_OFFSET}px`;
    cursorCircle.style.top = `${cursorY - WRAPAROUND_CIRCLE_RADIUS + CURSOR_OFFSET}px`;

    for (const { container, prepared } of TEXT_CONTAINERS_WITH_PREPARED) {
        const rect = container.getBoundingClientRect();
        const x = cursorX - rect.left;
        const y = cursorY - rect.top;
        drawTextInContainerWrapAroundCircle(prepared, container, x, y);
    }
    requestAnimationFrame(animate);
}

animate();
```

The end result of this process ia now available at: [pretext-playground](https://pretext-playground.abelievablefiction.net)
