package struct Patience: Hashable, Sendable
{
    package let answer: Duration
    package let grace: Duration
    package let kill: Duration

    package init(
        answer: Duration = .seconds(2),
        grace: Duration = .milliseconds(750),
        kill: Duration = .seconds(1))
    {
        self.answer = answer
        self.grace = grace
        self.kill = kill
    }

    package var bound: Duration
    {
        answer + grace + kill + kill
    }
}
