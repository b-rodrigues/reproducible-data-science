# Reproducible Polyglot Data Science: A Unified Approach with Nix and T

This repository contains the source code for my free ebook,
**Reproducible Polyglot Data Science**.
This book presents a modern, unified, and language-agnostic workflow
for creating analytical pipelines that are truly reproducible, from environment
to execution.

## What This Book Is About

This book is the culmination of my previous works and experiences, including:

-   [Reproducible Analytical Pipelines with R](https://raps-with-r.dev)
-   The `{rix}` R package for managing Nix environments
-   The `{rixpress}` R package for orchestrating Nix-based pipelines
-   The `ryxpress` Python package for orchestrating Nix-based pipelines

After writing my first book and starting on a Python edition, I realized that
solving the reproducibility problem one language at a time was a flawed
approach. The real solution needed to be universal. That universal solution is Nix.

Since discovering Nix, I built several tools on top of it: `{rix}`, `{rixpress}`,
and `ryxpress`. They solved real problems, but they were tied to individual
languages. Then came large language models (LLMs), which I believe will be a
game changer: you, as the data scientist, can focus on the actual data science
and leave the mechanical plumbing — environment setup and pipeline code — to
LLMs. That insight is what led me to build **T**.

[T](https://github.com/b-rodrigues/tlang) is a new programming language that I
designed and implemented with the help of LLMs. It is a domain-specific
language specialised for pipelines: its only purpose is to make writing,
inspecting, debugging, and running pipelines as simple as possible. T is
designed to be used both by humans who want full control and by LLMs acting on
their behalf. It coordinates R, Python, and Julia, and it is built on top of
Nix: every T project is a Nix project, and Nix is used both to set up the
reproducible environment and to run the pipeline. See the
[T documentation](https://tstats-project.org) for more.

This book moves beyond language-specific tools. Instead, it shares a vision for
what robust, polyglot data science should be, with Nix as the foundational
layer and T as the language that makes it all possible.

## What You'll Learn

-   **Master the Nix Philosophy:** Understand why Nix is the ultimate tool for
    solving the "it works on my machine" problem once and for all.
-   **Build Bulletproof Environments:** Use T to declaratively define exact
    software environments, pinning versions of R, Python, Julia, their
    packages, and all system dependencies.
-   **Orchestrate Polyglot Pipelines:** Use T to build, run, and debug complex
    analytical pipelines that seamlessly pass data between different languages.
-   **Pair with LLMs:** Treat LLMs as first-class collaborators, using T's
    structured feedback and built-in agent onboarding to let them write and
    verify the pipeline plumbing for you.
-   **Automate and Distribute:** Package your pipelines with Docker and automate
    your entire workflow with GitHub Actions, all built on your reproducible Nix
    foundation.

## Read The Book

The latest compiled version of the book is available to read online here:

**[https://b-rodrigues.github.io/reproducible-data-science/](https://b-rodrigues.github.io/reproducible-data-science/)**

*(Note: The book is a work in progress, and the online version is updated periodically as new chapters are completed.)*

### Status (as of August 2026)

The book is actively being written. I expect it to be done by mid 2027.
