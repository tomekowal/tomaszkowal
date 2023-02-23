%{
  author: "Tomasz Kowal",
  description: "Emotions, biases and paradoxes stand in the way of discussing the merits of programming languages. Learn what to keep in mind when talking about them.",
  title: "How to discuss programming languages?",
  tags: ["elixir", "soft-skills"],
  published: true
}
---

Do you know that monkeys using a rake consider the tool part of their body? They perceive it as a "long hand". "Extended cognition" is a science field exploring this and similar phenomena. I've recently learned about it from [Technology Adolescence talk](https://youtu.be/XlAqrS-fSAI) by [Tiago Forte](https://fortelabs.com/).

Quick change of topic. [Studies show that the language we use shapes the way we think](https://www.edge.org/conversation/lera_boroditsky-how-does-our-language-shape-the-way-we-think). Russians who have different words for light and dark blue can distinguish them quicker. In Pormpuraaw, Australia, there is an Aboriginal community with no concept of relative direction: left, right, front, or back. They always use cardinal directions: north, south, west and east. It forces them to always be aware of their orientation.

What about programming languages? A programming language is both a tool and a language. That would mean we treat them as *extensions of our brains*. My brain makes me *me*.

Let's pause to consider what it implies for discussing programming languages. If you consider yourself an "INSERT-LANGUAGE programmer", any critics of the language might hurt as if someone attacks you. Somebody criticises a part of who you are! It can spark similar emotions to discussing religion.

There are other issues with comparing programming languages. In [one of his essays](http://www.paulgraham.com/avg.html), Paul Graham coined the term "Blub Paradox". If you program in a language with a set of features, you adjust to it and don't feel the need for any other features. However, programming with one that doesn't have one of them feels super painful. We overestimate the pain of missing features and underestimate the things we don't use daily.

I love Elixir. It is the best programming language out there. However, after programming for a while in Elm, I miss the type-system that makes me feel safer during refactors.

I always wanted to learn Haskell and superficially get what monads and functors are. Still, I never programmed in Haskell enough to miss combining computations with `<$>` and `<*>` (and maybe it is a good thing because I would feel constantly miserable writing anything else :P).

On the other hand, a language that includes everything and a kitchen sink is also considered a bad design. Scala is functional, object-oriented and statically typed, and I've once heard that it is hard to keep conventions. A Java programmer will write procedural Java in it, a Haskeller will turn everything into higher-order FP, and a Rubyist will overuse macros. However, Scala programs have their unique style and best practices that are somewhere in between the three.

That situation made people think you should always use "the best tool for the job". That might also lead to a slippery slope. One programmer might need to perform many tasks, each requiring a different programming language. Even if we omit the cost of learning, using many tools creates a kind of [Impedance Mismatch](https://www.tomaszkowal.com/blog/how-to-reduce-software-impedance-mismatch). Different abstractions only sometimes work together, and plumbing between them gets hard, incurring an invisible cost.

Does any of this translate into actionable advice? Yes!
1. If someone criticises "your" language, mind your emotions. It is OK that it hurts. Refrain from getting angry; others might not appreciate things you consider vital!
2. Picking a language or a set of languages is a complex optimisation problem. Look for things that hurt you the most and seek languages that optimise solving that problem.
3. If you have time and resources, try investing in learning "foreign" programming languages. You might always borrow some tricks and change your way of thinking.
