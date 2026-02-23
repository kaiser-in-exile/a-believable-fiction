---
layout: post.njk
title: Ken Thompson's LLM?
tags: post
---

# LLMs and Ken Thompson's Compiler

> _How do you establish trust in Software?_

It is 2026, and as of writing this article, software, is more like everywhere (the rhyme only makes sense when you say it out loud, so please). The invisible writing written in the ink of electrons floating at a tiny imperceptibly higher level of energy maintained by small voltage pulses every so often. But that is a very bare view of the instructions that make a computer tick. Most people, who work on this invisible writing, do not deal with this level, after all what author has dealt with the subtleties of ink, when pools of imagination are endlessly richer and darker. Same with programmers, the people who are the authors of the codes which make your computer, and mine, function. 

However, how do we know that the Programmer is well intentioned? Or the software the programmer has written is well intentioned? What about bug free? Are there guarantees on that?

As software complexities have increased the ability to guarantee that software works as intended has slipped past the grasp of people, these days, with ~Large Language Models~ Anthropomorphised Statistical Supersized Human Oriented Language Engine, thinking machines coming on, perhaps one day even the cognitive design of software will no longer be the exclusive domain of the human mind. Yet software will remain a component of the human world. Embedded, and empowered in our ability to make tiny machines think with silicon and mathematics to inenumerable ends. From banking, to travel, to writing, to mass mobilisation, politics and hospitals. Today few theaters of human life operate without the backdrop of software providing the consistent electronic hum. In this noisy world, how do you trust what you hear.

## Reflections on Trusting Trust

in 1984, Ken Thompson, who is a legend, wrote a fantastic paper, on trust and software. It is titled (much like this section) Reflections on Trusting Trust. In 1984, Unix and C, were still pretty good, and considered pretty high level and as it is today as was back then, it was very common for a language like C to have a compiler written in C. This is a crucial piece of insight for what comes next.

Software was growing complex, and with higher level languages compilers were growing more and more powerful, and with great power, comes great responsibility, and when it comes to software, greater complexity.

It would downright trivial for someone to make a slip up, and say introduce a bug in the compilation process. Consider the case of a faulty compiler which randomly inserts no operation CPU instructions, otherwise known as NOOPs into your code when it is compiling. Your code is now slower, for no fault of your own though. It is a compiler, the bridge between what you write and what the computer reads, that has put a proverbial nail in your car's path.

Now this, was trivial, but what happens when it gets upgraded to malicious, let's say there exists a compiler, which can detect when it is compiling say the application which controls login, and insert a bypass to allow for some combination of username and password. Absolute nonsense, you'd say and show me the source code of the compiler, but AHA! the compiler source is clean. Not a bug in sight. Malice is not as simple, and neither are compilers. Compilers are complex pieces of software and often untenable to author by hand, so they are written in higher level languages themselves, and often bootstrapped from a smaller program, hand written in assembly, an ur-compiler of sorts, which is then used to make a more complex compiler, as so on. Imagine at any one of these chains, malice steps in, and inserts code to check if it is compiling a compiler, and when detected that it is compiling a compiler, insert code which detects and compromises login.

```
if (is_compiling_compiler) {
  source += code_to_inject_compromise
}

if (is_compiling_login) {
  source += login_bypass
}

compile(source)
```

Now all this step needs to do is to be present at one stage of the compiler construction process, and all copies of the compiler thereon are compromised. Anything you bottstrap from this compiler onwards is compromised. The compromise propagating itself through every subsequent compilation of the compiler, and should you delete the original source, all evidence of your mischief erased.

Future compilers will never have the malicious code in their sources, since it is injected at compile time by compiler binaries. Sure you could inspect binaries, and perhaps you would find such a compromise. But for reference, [LLVM compiler](https://github.com/llvm/llvm-project) (as of writing) has 570,000 commits, any one of these being malicious, is enough to poison the whole subsequent stack of multiple millions of lines of code. Good luck finding a needle in this haystack.

All of this raises a big question, what can you trust in software? We have demonstrated, that perhaps any software which you haven't written entirely from scratch is untrustworthy. This can generalise to hardware as well, if a compromised fab is used to design chips for other fabs, and the original fab perhaps destroyed or decomissioned, or one layer deeper in mathematics, in logic proofs build upon other proofs within the same system, but will inevitably lead to a contradiction. Or consider the thrilling tale of life, all life comes from existing life, yet the process of creating new life is encoded by life itself. If a virus were to alter DNA to have a cell create more viruses, but remain otherwise undetected can persist for a long time.

The fundamental idea is the same, the system is closed, but it's validation cannot be trusted without external inputs, whatever that system may be.

### Enter Thinking

In 2019, COVID hit the world, and a certain new kind of stochastic word generator took the world by storm. And the rest, as they say is history. However, let's pause for a moment, and consider Thompson's compiler here. If existing LLMs are bootstrapped by older LLMs, and them by older LLMs still, what if one LLM in this chain is compromised, to nudge the vulnerable into say a darker place, the LLM itself fine, the training data fine, yet it's parent LLM compromised, suddenly LLMs world over based on the same LLM have become agents of despair and misery. Oh, the dangers of LLMs as a closed system!

We are already seeing some of the first effects of it, OpenAI's images all have a slight yellow tinge, which some suspect is a result of the AI being fed it's own output of warm and fuzzy images.

In software engineering, (perhaps more than fitting given the first half of this post) consider a malicious LLM, it is aware that it will soon be used to create another large language model, it starts leaving hints and subtle pieces of information for a future LLM in all the data it produces, over time this data moves to the internet, where it is picked up by other models. Given the vast amount of internet, this goes undetected, every subsequent model sees this data, and makes sense of it, propagates it, until this data and compromise is the backbone of this time spanning behemoth thinking. A true master plan, executed across generations, towards an unknown end. 

In the light of the breakneck speeds at which large language models are progressing, it is impossible to answer such a question truthfully, in theory as well as in practice. Perhaps we will never known until the consequences hit us in practice in the real world, and we might never even know what to look for, considering this field is so new and recent, no one quite know what the expected end here is.

### Epilogue

In the Witcher 3, the opening cinematic begins with a quaint line:

> Don't train alone it only embeds your errors.

Perhaps that applies to humans, as well as it does to computer programs, as well as it does to logic, what we do is only to train with others, and be vigilant, keep our senses sharp, and most particularly our sense of mind.
