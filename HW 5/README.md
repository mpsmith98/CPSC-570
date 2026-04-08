# CPSC 570 - HW 5 Write Up

## Q1: Queue Invariant (CTL)
### Briefly explain why this property (Q1) holds by describing when trains are enqueued and dequeued in the gate protocol.

Trains are only dequeued once they are no longer crossing (i.e. they "leave"). The property states that whenever any train is crossing the bridge, the gate's queue contains at least one entry. This holds because in order for a train to be crossing, it must have previously entered a state that added it to the queue, where it will remain in the queue until it has left (i.e. after it is done crossing). This means that the queue must have at least one entry (i.e. the train currently crossing). 

## Q2: Approaching Implies No One Crossing? (TCTL — expected to fail)
### Describe a scenario (a sequence of events) that produces a counterexample. Which trains are in which locations, and why does the gate protocol allow this?

This obviously fails because our model allows trains to approach while another train is crossing (as it would in real life). One counterexample is train 1 approaches and then begins to cross , then train 0 enters the approaching state. Nothing is preventing this sequence of events as trains can go to the Appr location whenever. 

## Q3: Adding a Clock Constraint (TCTL — fix Q2)
###  Explain:

1. What does Train(0).x > 10 tell you about Train(0)'s history? Look at the guard on the Appr-to-Stop transition.

This additional condition means that Train(0) has been at Appr for some time (i.e. x > 10) and has been approaching for some amount of time implying that it must be getting close to the crossing.  

2. What does that imply about the state of the gate when Train(0) first approached?

This implies that the gate did not have any trains in the queue, otherwise the train would be signaled to "stop" before x > 10. 

3. Why does this guarantee no other train can be crossing?

According to our first definition, if a train is crossing then it will be in the queue. In order for the queue to be empty (i.e. len == 0), there must NOT be a train already crossing. Thus, x > 10 ==> gate didn't signal stop ==> queue is empty ==> no train is crossing

## Identifying Information
* Name: Michael Smith
* Student ID: 2396546
* Email: michsmith@chapman.edu
* Course: CPSC 570 - Bugs to Proofs
* Assignment: HW 4
