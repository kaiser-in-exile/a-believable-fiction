---
title: Recursion & Induction
layout: chain.njk
---

# Understanding Recursion

Recursion is a way of definition, where an object is defined in term of itself. The most everyday example of this is language. Parts of a language, are often made up of other "parts of a language". Or the clouds (the ones that float high in the sky and look a rather grumpy gray on a rainy day) can be thought of to be made up of more clouds, or coastlines, are made of coastlines.

In mathematics, recursion manifests itself elegantly in things like Fibonacci series, a mathematical series of numbers which converges to a geometric series with a purported aesthetically pleasant ratio. In the world of the living, it manifests in sworls of flowers, and on the prickly shells of pineapples, as well as the protective and beautiful spiral shells of marine molluscs.

In computers, recursion is an elegant technique that is used to describe constructs like trees, and graphs. Unfortunately because of implementation complexities, and quirks of how modern computers work, recursion is rather frowned upon, despite it's elegance.

```python
def fibonacci(n):
    if n == 1: return 0
    if n == 2: return 1
    return fibonacci(n - 1) + fibonacci(n - 2)
```

When the computer for instance tries to compute the value for `fibonacci(3)` it realises that `fibonacci(3) = fibonacci(2) + fibonacci(1)`, using the final rule in the definition of the fibonacci function. With fibonacci of 1, and 2 being known values from the rules above, it can trivially compute 3, and from three being known. it can compute 4, and so on....

A method, which someone with a mild familiarity of mathematics might find reminiscent of...

# Understanding Induction

Induction is a rather abstract proof technique, it builds upon the idea that if something is true for a value, and then the fact that something is true for a value, can demonstrate that something is true for another value, you can club these two observations, and then say that something being true for another value if you are capable of deriving another another value, you can say that what you postulated is true for the another another value as well.

A rather trivial proof of sum of natural numbers follows, you may skip it if you already know how it works

Let's just take the example of proving that the sum of all natural numbers up to $N$ is actually $\frac{N(N + 1)}{2}$

The first step in induction, is to assume, that we know for some value of n, the sum of all natural numbers is as defined above.

$$ \Sigma_1^n{n} = \frac{n \cdot (n + 1)}{2} $$

Now let us try to find the sum of all natural numbers till n + 1.

$$ \Sigma_1^{n+1}{n} = ??? $$

One can make this simple observation that the sum of all natural numbers till $n + 1$ should surely be expressible as the sum of all natural numbers till $n$, and then adding $n + 1$ to it. Surely that is how summation works

$$ \Sigma_1^{n+1}{n} = \Sigma_1^n{n} + (n + 1) $$

We know from our inductive base case, that the sum of natural numbers up to n can be assumed to be a particular derivation.

$$ \Sigma_1^n{n} = \frac{n \cdot (n + 1)}{2} $$

Thus we can substitute that in

$$ \Sigma_1^{n+1}{n} = \frac{n \cdot (n + 1)}{2} + (n + 1) $$

Factoring out $n + 1$ as a common factor here we get

$$ \Sigma_1^{n+1}{n} = (n + 1) \cdot (\frac{n}{2} + 1) $$

Adding the 1 and n over 2 on the right side makes

$$ \Sigma_1^{n+1}{n} = (n + 1) \cdot (\frac{n + 2}{2}) $$

Which with some brackets becomes

$$ \Sigma_1^{n+1}{n} = (\frac{(n + 1) \cdot ((n + 1) + 1)}{2}) $$

Therefore, we have now shown, that assuming the postulate true for a number $n$ allows us to demonstrate validity for $n+1$. That is if we assume, that our postulate is true for the number 1, we can assume it to be true for 2. If it is true for 2, we can assume it to be true for 3, and so on.....

# The connection

Honestly, induction feels like magic, as does recursion, with a little assumption, so many pieces simply fall into place. It is most certainly an elegant piece of logic, and when expanded it feels rather [recursive](/posts/chains/recursion-induction). One proving itself through logic, one manifesting itself through application. A tree is essentially a recursive definition, every branch a small tree in itself, but induction allows us to gleam the existence of all branches from a tree from the existence of a trunk.

Where recursion defines what a type is, induction allows you to reason on the type of what you might not know. They feel very much like two halves of the same coin, the same concept of building up one in structure and one in reason.

I have personally found this rather poetic, two concepts, from rather different worlds (well technically not that different since computer science is a subdiscipline of mathematics) would end up just being so elegantly linked to one another.

Every recursive algorithm in itself is actually an inductive proof of it's own working.
