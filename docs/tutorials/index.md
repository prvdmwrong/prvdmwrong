# Get Started

Congratulations on choosing Oh My Prvd! You're already making good choices.

Oh My Prvd is a delightful framework for next-generation Roblox game
development. Here, you will learn how to build great games with Oh My Prvd, even
if you're a complete newcomer to the library.

!!! warning "But first, something important..."

    **<span style="font-size: 1.5em;">
    Do not use Oh My Prvd in production unless you're *really, really, really, REALLY, really*
    willing and able to withstand large, sweeping changes.
    </span>**

    Yes, that was five-reallys important.

    Oh My Prvd is in very early alpha right now! You *will* encounter:

    - glitches in core features
    - changes in how things work between versions
    - updates that completely remove existing features
    - evolving recommendations on conventions and project structure

    This is not a bad thing! It means we can quickly abandon counterproductive
    ideas and features, and build a solid foundation for the future.

    Don't be discouraged though, feel free to follow along with our development
    and try using the library in your own time. We hope you enjoy using Oh My
    Prvd!

## Expectations

These tutorials assume:

- That you're comfortable with Roblox and the Luau scripting language.
      - These tutorials _are not_ an introduction Luau – If you'd like to learn,
        see the [Roblox creator documentation](https://create.roblox.com/docs).
- That - if you're using Roblox TypeScript - you're comfortable with TypeScript.
      - These tutorials _are not_ an introduction to TypeScript - If you'd like
        to learn, see [Roblox TypeScript's documentation](https://roblox-ts.com/docs/)
        and the [TypeScript handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
      - These tutorials also assume you're familiar with Luau, which especially
        is important when troubleshooting bugs – If you'd like to learn, see the
        [Roblox creator documentation](https://create.roblox.com/docs).

Some tutorials might challenge you more than others. Remember, Oh My Prvd is
built with you in mind, but it may still take a bit of time to absorb some
concepts. Take your time and explore at your own pace.

## Support

If you're struggling to understand a concept, or need help debugging an error,
here are some resources which can help.

### Support with Errors

Oh My Prvd provides helpful links with every console log message. These links
direct you to our comprehensive [Error Messages](../api-reference/general/error-messages.md)
documentation.

```txt hl_lines="2"
[ohmyprvd error(requireAfterIgnition)]: cannot require other providers after ignition
  more info: team-fireworks.github.io/ohmyprvd/latest/api-reference/general/error-messages#requireafterignition
  stack trace:
    ohmyprvd.log:118 function throw
    ohmyprvd.prvd:181 function use
    Main:42
```

It explains the meaning of each message, its origin within Oh My Prvd, and
relevant context. When you run into an error, that page is a great place to start!
