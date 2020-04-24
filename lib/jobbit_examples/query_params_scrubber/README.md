
# JobbitExamples.QueryParamsScrubber

An example that demonstrates the value proposition of using `Jobbit`.

#### Expectations

The submodules of QueryParamsScrubber are implementations of a parser for a
query params string with or without the leading `?` where for any pair all keys
are allowed, but the input values are limited to `"1"` and `"2"`. Each parser
must return, either a list of `{String.t(), :one | :two}`, or raise an error, or
the afformentioned list wrapped in an 2 sized ok-tuple, or 2 sized error-tuple.

Expectations for return values are based on the "will crash?" bullet in the
moduledocs of each implementation. If the "will crash?" is "Yes" then successful
parsing results in a list of values. If the "will crash?" is "No" then the
implementation is expected to return the same list wrapped in an ok-tuple or in
the case of failure returns an error-tuple. Any other behavior or outcome for
the implementations is a bug on my part.

#### Code Properties Under Consideration

  + will_crash? - answers the question: "Given input of any type or value
    (within reason) will this code crash?"

  + effective lines of code - the count of lines of code including the `def` and
    `end` of code blocks because functions have clause that can logically branch
    in Elixir/Erlang.

  + time spent coding - the time from `def parse(str)` being able to compile,
    load, and run the happy path AND some non-happy-path cases without
    unexpected results.

  + level of effort - is completely subjective. However, the stress that was
    experienced in coding the `Declaratively` first (easy, quick, and simple)
    *THEN* coding the `Defensively` (less easy, more code, a little convoluted)
    and knowing that the solution "could be so simple" almost certainly caused
    my cortisol levels to rise. Though, *actual* science is needed to
    substantiate this claim.

  + optimized for fewer LOC? - answers the question: "Was extra time and effort
    spent reducing the effective lines of code?"I did not want the perception
    that I made decisions to make the `Defensively` example more complex than it
    needed to be so I decided to go over `Defensively` attempting to reduce its
    LOC. I took considerable effort to present the `Defensively` code example
    and its stats a fair and balance manner. As such, I spent some extra time
    reducing the LOC of `Defensively`. However, the "refactor" did not help
    `Defensively`'s case. I feel the effort to reduce the LOC is exactly the
    type of thing that is a trap, and may appear to make code better, but in
    reality has cost all of us (me, you, our company, our world) precious time.

  + easy-of-understanding - is a subjective measure of how long and how
    difficult a piece of code takes to understand. This measure include how much
    effort is spent deciding what the code was meant to do, what the code
    *actually* does in the most obvious cases, and as well as an estimation of
    how many ways a piece of code can do something unexpected.
