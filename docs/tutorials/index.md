# Get Started

Congratulations on choosing Prvd 'M Wrong! You're finally making good choices.

Prvd 'M Wrong is a service provider framework for a next-generation Roblox. Here, you will
learn how to build great games with Prvd 'M Wrong, even if you're a complete
newcomer to the library.

!!! warning "But first, something important..."

    **<span style="font-size: 1.5em;">
    Do not use Prvd 'M Wrong in production unless you're *really, really,
    really, REALLY, really* willing and able to withstand large, sweeping
    changes.
    </span>**

    Yes, that was five-reallys important.

    Prvd 'M Wrong is still under active development! Full backward compatibility
    is not guaranteed before reaching version 1.0. Again, ___Do not use Prvd 'M
    Wrong in production yet, unless you are willing and able to withstand large,
    sweeping changes.___ You *will* encounter:

    - nonexistent or broken packages
    - changes in how things work between versions
    - updates that completely remove existing features
    - evolving recommendations on conventions and project structure

    This is not a bad thing! It means we can quickly abandon counterproductive
    ideas and features, and build a solid foundation for the future.

    Don't be discouraged though, feel free to follow along with our development
    and try using the library in your own time. We hope you enjoy using Prvd 'M
    Wrong!

---

## Expectations

These tutorials assume:

- That you're comfortable with Roblox and the Luau scripting language.
      - These tutorials _are not_ an introduction to Luau – If you'd like to learn,
        see the [Roblox creator documentation](https://create.roblox.com/docs).
- That - if you're using Roblox TypeScript - you're comfortable with TypeScript.
      - These tutorials _are not_ an introduction to TypeScript - If you'd like
        to learn, see [Roblox TypeScript's documentation](https://roblox-ts.com/docs/)
        and the [TypeScript handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
      - These tutorials also assume you're familiar with Luau, which especially
        is important when troubleshooting bugs – If you'd like to learn, see the
        [Roblox creator documentation](https://create.roblox.com/docs).

Some tutorials might challenge you more than others. Remember, Prvd 'M Wrong is
built with you in mind, but it may still take a bit of time to absorb some
concepts. Take your time and explore at your own pace.

---

## Support

Should you be struggling to understand a concept, or need help debugging an
error, here are some resources which can help.

### Support with Errors

Prvd 'M Wrong attaches a link with every console log message. These links direct
you to our comprehensive [errors](../reference/errors.md) documentation.

```Txt hl_lines="2"
[PMW(requireAfterIgnition)]: cannot require other providers after startup
  more info: prvdmwrong.github.io/prvdmwrong/latest/reference/general/error-messages#requireafterignition
  stack trace:
    prvdmwrong.log:118 function throw
    prvdmwrong.prvd:181 function use
    Main:42
```

It explains the meaning of each message, its origin within Prvd 'M Wrong, and
relevant context. When you run into an error, that page is a great place to start!

### Additional Support

Prvd 'M Wrong is built with you in mind and our documentation aims to be as useful
and comprehensive as possible. However, you might need specific advice on an
issue, perhaps you may want to learn Prvd 'M Wrong through other means, or you
caught a showstopper bug.

Whatever you're looking for, feel free to swing by [our dedicated
thread](https://discord.com/channels/385151591524597761/1267055070374268969)
over the [Roblox OSS Discord server](https://discord.gg/VaDCnesCXj). Maintainers
drop in frequently alongside eager Prvd 'M Wrong users.
