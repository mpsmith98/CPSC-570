# CPSC 570 - HW 4 Write Up

## Does the safety property hold? If not during development, what was the counterexample?

Yes, the safety property holds. 

## Which LTL properties pass and why?

Yes, all LTL properties pass. 

Safety passes due to the fact that the gate must begin to lower by the time a train is approaching and be down after the train is near at the latest and can't begin raising until after the train is leaving

For similar reasons, Response passes since the gate cannot idle indefinitely once the train has started the sequence. As train draws near, the gate is forced to enter lowering and then down until the train has left. 

Gate Progress passes because of how the train is defined. Since the train goes immediately from approaching to near, the condition for gate to be set to lowering is only ever satisfied for one state consectutively meaning it is then forced to transition to down as the very next state, satisfying the property. 


## Which CTL properties fail without fairness? What changes with fairness?

The last property (Bonus) fails without fairness. Fairness ensures that a state is infinitely recurring. Without fairness, we can have paths where trains never approach after a certain time period (or from the very beginning) which would mean that not all states/paths are guaranteed to eventually have a train crossing.

## Compare one LTL property with its CTL equivalent — are they checking the same thing?

Looking at the Response CTL property and the Response LTL property, we can deduce that they are effectively checking for the same thing. Under LTL, we are saying all states (globally) uphold train approaching implies gate comes down eventually. Similarly, we are saying that all states (globally) for all possible paths (A) train approaching implies gate comes down eventually (F) for all paths (A). By specificing this as the case for every state and possible subsequent path, we have guaranteed that the property holds for all states in any scenario achieving the same result as saying the implication must be true in any state. 


## Identifying Information
* Name: Michael Smith
* Student ID: 2396546
* Email: michsmith@chapman.edu
* Course: CPSC 570 - Bugs to Proofs
* Assignment: HW 4