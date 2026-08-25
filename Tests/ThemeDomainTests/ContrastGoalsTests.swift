import Pigment
import Testing

@testable import ThemeDomain

@Suite("What each role must reach")
struct ContrastGoalsTests
{
    @Test("every slot has a goal")
    func everySlotIsCovered()
    {
        for slot in InkSlot.allCases
        {
            #expect(ContrastGoals.bySlot[slot] != nil, "\(slot)")
        }
    }

    @Test("every syntax goal clears the accessible minimum")
    func syntaxClearsFourAndAHalf()
    {
        for (slot, goal) in ContrastGoals.bySlot
        {
            #expect(goal.target >= 4.5, "\(slot) at \(goal.target.value)")
        }
    }

    @Test("furniture is deliberately quieter than any syntax role")
    func furnitureRecedes()
    {
        let quietest = ContrastGoals.bySlot.values
            .map(\.target)
            .min() ?? ContrastRatio(0)
        #expect(ContrastGoals.comment < quietest)
        #expect(ContrastGoals.whitespace < ContrastGoals.comment)
        #expect(ContrastGoals.indentGuide < ContrastGoals.whitespace)
    }

    @Test("plain text is the loudest thing on the page")
    func textIsLoudest()
    {
        for goal in ContrastGoals.bySlot.values
        {
            #expect(ContrastGoals.plainText > goal.target)
        }
    }

    @Test("keywords are set above the types they introduce")
    func keywordsLeadTypes()
    {
        let keyword = ContrastGoals.bySlot[.keyword]!.target
        let type = ContrastGoals.bySlot[.type]!.target
        #expect(keyword > type)
    }

    @Test("chroma factors never amplify a source hue")
    func chromaIsNeverAmplified()
    {
        for (slot, goal) in ContrastGoals.bySlot
        {
            #expect(goal.chromaFactor <= 1.0, "\(slot)")
            #expect(goal.chromaFactor > 0, "\(slot)")
        }
    }

    @Test("retargeting keeps the chroma factor")
    func retargetingIsSurgical()
    {
        let original = ContrastGoal(5.0, chromaFactor: 0.8)
        let louder = original.reaching(9.0)
        #expect(louder.target == 9.0)
        #expect(louder.chromaFactor == original.chromaFactor)
    }
}
