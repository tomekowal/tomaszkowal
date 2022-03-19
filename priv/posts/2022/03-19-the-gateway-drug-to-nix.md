%{
  author: "Tomasz Kowal",
  description: "How using `nix-shell --packages` solves problems with system dependencies",
  title: "The gateway drug to Nix",
  tags: ["nix"],
  published: true
}
---
Have you ever tried to install something and failed multiple times?

I needed to generate some diagrams using [plantuml](https://plantuml.com/starting). When installing such things, I always start with apt:
```bash
sudo apt-get install plantuml
```
And it looked like everything was fine, but I got errors when generating the diagrams. Some unrecognized syntax. I was positive that my colleagues used the same source to create other diagrams I'd already seen, so I checked the version.
```bash
plantuml -version
PlantUML version 1.2018.13 (Mon Nov 26 18:11:51 CET 2018)
```
Oh! That is it. It is three years old! Let's grab one from the [official website](https://plantuml.com/download). There are eleven different versions to download... After some digging, I went with the MIT version.

```bash
java -jar plantuml.jar sequenceDiagram.txt
```

And it failed because my java version is too new.

And then I realized! I have this new magical piece of software called [Nix](https://nixos.org/) on my PC!

Nix might feel complicated because it has many facades: NixOS, Nix package manager and the website even mentions cloud and continues integration. The [Learn section on Nix website](https://nixos.org/guides/dev-environment.html) starts immediately with setting up a `*.nix` file. There is, however, one even simpler thing you can try. 

```bash
nix-shell -p plantuml
```

This command starts a new shell with plantuml ready to use. The first time it runs, it will fetch all necessary dependencies and store them. The program is prepared to use when Nix finishes. This time `plantuml` is much more recent.

```bash
plantuml -version                                                                                                                                                    
PlantUML version 1.2021.16 (Wed Dec 08 18:25:22 CET 2021)
```

No knowledge of how Nix works is required. It just works! I've escaped the dependency hell. 

It is awesome!

Next time, when you'd like to try out some new tool without installing it globally - try `nix`. You won't regret it!
