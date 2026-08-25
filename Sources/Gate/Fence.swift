import Foundation

package struct Fence<Subject: Hashable & Sendable>: Sendable
{
    package struct Ticket: Hashable, Sendable
    {
        let fence: UUID
        let generation: UInt64
        package let subject: Subject
    }

    private let id = UUID()
    private var generation: UInt64 = 0
    private var subject: Subject?

    package init()
    {
    }

    package mutating func begin(for subject: Subject) -> Ticket
    {
        generation &+= 1
        self.subject = subject
        return Ticket(fence: id, generation: generation, subject: subject)
    }

    package func accepts(_ ticket: Ticket) -> Bool
    {
        ticket.fence == id && ticket.generation == generation
    }

    package mutating func invalidate()
    {
        generation &+= 1
        subject = nil
    }
}
