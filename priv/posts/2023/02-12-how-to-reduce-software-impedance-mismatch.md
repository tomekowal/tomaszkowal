%{
  author: "Tomasz Kowal",
  description: "Team velocity observations from ten years of experience working in startups and consultancies",
  title: "How to reduce software impedance mismatch?",
  tags: ["elixir", "phoenix", "liveview"],
  published: true
}
---

The term "impedance mismatch" comes from electrical engineering, and I won't pretend I fully understand it. However, after reading [some Wikipedia](https://en.wikipedia.org/wiki/Impedance_matching), I am starting to grasp why programmers use it for [Object-relational impedance mismatch](https://en.wikipedia.org/wiki/Object%E2%80%93relational_impedance_mismatch). I think it is because it represents a problem connecting two things that "should work" if you squint, but upon closer inspection, we have to deal with super annoying details.

In the SQL to OO example, classes have attributes and tables have columns, so we could, in theory, map columns to attributes, right? RIGHT? Of course, we could! It is not the problem. The devil lies in the details.

Suppose you've received an object with a deeply nested structure. Objects within objects within objects... You can easily update parts of it in OOP. How do you later persist it? What query does your ORM produce? Is it fast? Does it do it in a transaction? Does it suffer from n+1? What if DB constraints prevent the update? What happens to your in-memory object structure?

Many software developers feel like programming nowadays is mostly "plumbing". "Plumbing" is a task that requires very little thinking about the problem domain or algorithms but is still fuzzy enough it is not easy to automate. E.g. your programming language might have richer types than the database, and then you need to serialize and deserialize them. "Plumbing" issues are often not considered during high-level planning because those are mostly "leaky abstractions". You are either aware of the problem because you've stumbled upon it or are in the dark until it hits you. It is **frustrating**.

 I recently connected the two dots and formulated a theory. What people call "plumbing" are different instances of "impedance mismatch". They often require much more work than anticipated.

There are many other examples. Maybe your language algebraic data types `data Tree = Empty | Leaf Int | Node Tree Tree`, but you need to write a JSON API that returns the tree. There isn't a "correct" way to do it. There are trade-offs.

Imagine writing a translation layer between two APIs. The sender sends one field called `address`, but the receiver expects `street`, `house_number` and `postal_code`. Now you need to parse the address and **pray** that the sender system did at least *some* validations because the receiver made all the fields required.

Even worse, the sender requires a response in 5s, but the receiver is slow and suggests a timeout of at least 10s. Caching may help if you call the same thing many times. But how do you invalidate the cache? Or you could provide a frustrating experience where 2% of requests to your translation layer time out? It depends on your business domain.

Don't let me start on browsers having slight differences and incompatibilities. Again, you are either aware of them because they've bitten you or you stumble upon them. Nobody considers those "timeless abstractions" that deserve a book where you can learn about them in advance. And even if there were a definitive list of all of them, it would be huge. It would still be better to stumble upon the most popular ones instead of learning them upfront.

But there is light at the end of the tunnel. Super intelligent people understand those issues and devise ways to reduce impedance mismatch. Almost fifteen years ago, in 2009, node.js promised to lower the mismatch between the backend and the frontend by using the same language. Clojurescript had a similar idea even earlier, in 2007.

I started programming in Erlang around 2010, and node.js callback-based IO seemed convoluted compared to Erlang's selective receives and processes that automatically went to sleep when waiting on IO. Could we somehow write Erlang in the frontend? Around the same time, José Valim wanted to marry Erlang's great concurrency primitives with ease of use and joy of programming in Ruby. From that marriage, the [Elixir programming language](https://elixir-lang.org/) was born.

Of course, it is hard to mention Ruby without mentioning Rails in the same sentence. Chris McCord made Phoenix Framework "The Rails for Elixir". The initial tagline was "productive > reliable > fast". It delivered on all fronts. Great tooling made you productive, Erlang's concurrency semantics and supervision trees made it reliable and the [BEAM's scheduler made it fast](https://tkowal.wordpress.com/2015/01/27/the-unintuitive-latency-over-throughput-problem/).

Almost accidentally, it solved a bunch of impedance mismatch problems. If you are using Elixir, you don't need Sidekiq for background jobs. The Oban library works within the Elixir VM. You don't need a webserver in front of your application. Phoenix webserver is within the BEAM and has an outstanding property: each request is a separate BEAM process.

The mismatch between relational data and your application code is fantastically abstracted by Ecto. The mismatch still exists. At least until someone rewrites an SQL database in a BEAM language 😛 but Ecto makes it less painful than in any other language I know.

And finally, Phoenix has LiveView. LiveView is the ultimate "impedance mismatch eradicator" because it deals with the frontend-to-backend mismatch. It allows writing highly interactive websites that work entirely on the backend: no more JSON APIs, no more GraphQL, and no more duplicating validations between client and server. There is a trade-off, of course. Your clients need to be online. But if you are in a position where it is not a big issue, you are golden.

If you follow closely, you might have the impression that impedance mismatch is the worst thing on earth and it would be best to use one technology for all problems. That is false. SQL ACID guarantees are an immense help in development, but it is good to know that even using default tools like SQL has trade-offs.

An API is an excellent boundary if you have multiple teams with a clear separation between the backend and the frontend. But beware! Every new tool, every specialized database, and every flashy technology introduces impedance mismatch. It is a "death by a thousand cuts". You might not jump out of the pot before the water boils.

Reducing the impedance mismatch should be one of your top priorities if you have a small team and care about velocity. If you run a startup, consider using Elixir, Phoenix and Postgres for as long as feasible. It will reward you with ["Peace of mind from prototype to production"](https://www.phoenixframework.org/). It also scales well when your startup grows, so it is future-proof. What is your excuse not to try it?
