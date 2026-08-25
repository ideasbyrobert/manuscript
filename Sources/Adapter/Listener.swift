struct Listener
{
    let id: Int
    let wake: CheckedContinuation<Message?, Never>
}
